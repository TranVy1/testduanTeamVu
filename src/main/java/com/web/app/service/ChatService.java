package com.web.app.service;

import com.web.app.dto.ChatConversationDTO;
import com.web.app.dto.ChatMessageDTO;
import com.web.app.model.KhachHang;
import com.web.app.model.TinNhan;
import com.web.app.repository.KhachHangRepository;
import com.web.app.repository.TinNhanRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class ChatService {

    private final TinNhanRepository tinNhanRepo;
    private final KhachHangRepository khachHangRepo;
    private final SimpMessagingTemplate messagingTemplate;

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("HH:mm dd/MM");

    /**
     * Get conversation key
     */
    public String buildConversationKey(Integer customerId, String sessionGuestId) {
        if (customerId != null) {
            return "C_" + customerId;
        }
        return "G_" + (sessionGuestId != null ? sessionGuestId : "guest");
    }

    /**
     * Get chat history for customer or guest
     */
    @Transactional
    public List<ChatMessageDTO> getHistory(Integer customerId, String sessionGuestId) {
        List<TinNhan> messages;
        if (customerId != null) {
            messages = tinNhanRepo.findByKhachHangIdOrderByThoiGianAsc(customerId);
            tinNhanRepo.markCustomerReadByCustomerId(customerId);
        } else if (sessionGuestId != null && !sessionGuestId.isBlank()) {
            messages = tinNhanRepo.findBySessionGuestIdOrderByThoiGianAsc(sessionGuestId);
            tinNhanRepo.markCustomerReadByGuestId(sessionGuestId);
        } else {
            messages = Collections.emptyList();
        }

        if (messages.isEmpty()) {
            // Send a warm welcome message if no prior messages exist
            return List.of(ChatMessageDTO.builder()
                    .id(-1)
                    .customerId(customerId)
                    .sessionGuestId(sessionGuestId)
                    .senderRole("BOT")
                    .senderName("Trợ lý Shop")
                    .content("Chào bạn! Chào mừng bạn đến với Cửa hàng Mũ Bảo Hiểm. Bạn cần tư vấn chọn size mũ, thông tin bảo hành hay tra cứu sản phẩm? Chúng mình luôn sẵn sàng hỗ trợ!")
                    .time(LocalDateTime.now().format(FORMATTER))
                    .read(true)
                    .build());
        }

        return messages.stream().map(this::toDTO).collect(Collectors.toList());
    }

    /**
     * Get history for admin by conversation key
     */
    @Transactional
    public List<ChatMessageDTO> getHistoryByConversationKey(String conversationKey) {
        List<TinNhan> messages = new ArrayList<>();
        if (conversationKey.startsWith("C_")) {
            Integer customerId = Integer.parseInt(conversationKey.substring(2));
            messages = tinNhanRepo.findByKhachHangIdOrderByThoiGianAsc(customerId);
            tinNhanRepo.markAsReadByCustomerId(customerId);
        } else if (conversationKey.startsWith("G_")) {
            String guestId = conversationKey.substring(2);
            messages = tinNhanRepo.findBySessionGuestIdOrderByThoiGianAsc(guestId);
            tinNhanRepo.markAsReadByGuestId(guestId);
        }
        return messages.stream().map(this::toDTO).collect(Collectors.toList());
    }

    /**
     * Customer sends a message
     */
    @Transactional
    public ChatMessageDTO sendCustomerMessage(Integer customerId, String sessionGuestId, String content) {
        if (content == null || content.trim().isEmpty()) {
            return null;
        }

        KhachHang khachHang = null;
        String senderName = "Khách vãng lai";
        if (customerId != null) {
            khachHang = khachHangRepo.findById(customerId).orElse(null);
            if (khachHang != null && khachHang.getHoTen() != null && !khachHang.getHoTen().isBlank()) {
                senderName = khachHang.getHoTen();
            } else if (khachHang != null) {
                senderName = "Khách hàng #" + customerId;
            }
        }

        TinNhan message = TinNhan.builder()
                .khachHang(khachHang)
                .sessionGuestId(customerId == null ? sessionGuestId : null)
                .senderRole("CUSTOMER")
                .senderName(senderName)
                .noiDung(content.trim())
                .thoiGian(LocalDateTime.now())
                .daDoc(false)
                .build();

        TinNhan saved = tinNhanRepo.save(message);
        ChatMessageDTO dto = toDTO(saved);

        String convKey = buildConversationKey(customerId, sessionGuestId);

        // Broadcast to customer and admin
        broadcastMessage(convKey, dto);

        // Check for smart bot auto reply
        handleAutoBotReply(khachHang, sessionGuestId, convKey, content.trim());

        return dto;
    }

    /**
     * Admin sends a message
     */
    @Transactional
    public ChatMessageDTO sendAdminMessage(String conversationKey, String content, String adminName) {
        if (content == null || content.trim().isEmpty() || conversationKey == null) {
            return null;
        }

        KhachHang khachHang = null;
        String guestId = null;

        if (conversationKey.startsWith("C_")) {
            Integer customerId = Integer.parseInt(conversationKey.substring(2));
            khachHang = khachHangRepo.findById(customerId).orElse(null);
        } else if (conversationKey.startsWith("G_")) {
            guestId = conversationKey.substring(2);
        }

        TinNhan message = TinNhan.builder()
                .khachHang(khachHang)
                .sessionGuestId(guestId)
                .senderRole("ADMIN")
                .senderName(adminName != null && !adminName.isBlank() ? adminName : "Nhân viên Tư vấn")
                .noiDung(content.trim())
                .thoiGian(LocalDateTime.now())
                .daDoc(false)
                .build();

        TinNhan saved = tinNhanRepo.save(message);
        ChatMessageDTO dto = toDTO(saved);

        broadcastMessage(conversationKey, dto);
        return dto;
    }

    /**
     * Get all conversations summary for Admin dashboard
     */
    @Transactional(readOnly = true)
    public List<ChatConversationDTO> getAllConversations() {
        List<TinNhan> allMessages = tinNhanRepo.findAllByOrderByThoiGianDesc();
        Map<String, List<TinNhan>> groups = new LinkedHashMap<>();

        for (TinNhan tn : allMessages) {
            String key = tn.getKhachHang() != null ? ("C_" + tn.getKhachHang().getId()) : ("G_" + tn.getSessionGuestId());
            groups.computeIfAbsent(key, k -> new ArrayList<>()).add(tn);
        }

        List<ChatConversationDTO> conversationList = new ArrayList<>();
        for (Map.Entry<String, List<TinNhan>> entry : groups.entrySet()) {
            String key = entry.getKey();
            List<TinNhan> msgs = entry.getValue();
            if (msgs.isEmpty()) continue;

            TinNhan latest = msgs.get(0);
            long unread = msgs.stream().filter(m -> "CUSTOMER".equals(m.getSenderRole()) && Boolean.FALSE.equals(m.getDaDoc())).count();

            ChatConversationDTO conv = new ChatConversationDTO();
            conv.setConversationKey(key);
            conv.setLastMessage(latest.getNoiDung());
            conv.setLastTime(latest.getThoiGian().format(FORMATTER));
            conv.setUnreadCount((int) unread);

            if (latest.getKhachHang() != null) {
                KhachHang kh = latest.getKhachHang();
                conv.setCustomerId(kh.getId());
                conv.setCustomerName(kh.getHoTen() != null && !kh.getHoTen().isBlank() ? kh.getHoTen() : "Khách hàng #" + kh.getId());
                conv.setCustomerPhone(kh.getSoDienThoai());
                conv.setCustomerEmail(kh.getEmail());
            } else {
                conv.setSessionGuestId(latest.getSessionGuestId());
                String gid = latest.getSessionGuestId();
                conv.setCustomerName("Khách #" + (gid != null && gid.length() > 6 ? gid.substring(0, 6) : (gid != null ? gid : "Guest")));
            }

            conversationList.add(conv);
        }

        return conversationList;
    }

    /**
     * Mark conversation read by admin
     */
    @Transactional
    public void markAsReadByAdmin(String conversationKey) {
        if (conversationKey.startsWith("C_")) {
            Integer customerId = Integer.parseInt(conversationKey.substring(2));
            tinNhanRepo.markAsReadByCustomerId(customerId);
        } else if (conversationKey.startsWith("G_")) {
            String guestId = conversationKey.substring(2);
            tinNhanRepo.markAsReadByGuestId(guestId);
        }
    }

    private void broadcastMessage(String conversationKey, ChatMessageDTO dto) {
        try {
            // Customer channel
            messagingTemplate.convertAndSend("/topic/chat/" + conversationKey, dto);
            // Admin channel
            messagingTemplate.convertAndSend("/topic/admin/chat", dto);
        } catch (Exception e) {
            log.warn("WebSocket broadcast failed (fallback to REST): {}", e.getMessage());
        }
    }

    private void handleAutoBotReply(KhachHang khachHang, String sessionGuestId, String convKey, String content) {
        String lower = content.toLowerCase();
        String botReply = null;

        if (lower.contains("size") || lower.contains("kích thước") || lower.contains("đo đầu") || lower.contains("vòng đầu") || lower.contains("vừa")) {
            botReply = "📏 **Hướng dẫn chọn size mũ bảo hiểm chuẩn xác**:\n"
                    + "• **Size M**: Vòng đầu 54 - 56 cm (phổ thông cho nữ hoặc nam dáng gọn)\n"
                    + "• **Size L**: Vòng đầu 57 - 59 cm (phổ thông cho nam giới)\n"
                    + "• **Size XL**: Vòng đầu 60 - 62 cm (vòng đầu lớn)\n\n"
                    + "👉 *Mẹo nhỏ*: Dùng thước dây đo ngang trán cách lông mày 2cm. Nếu nằm giữa 2 size, nên chọn size lớn hơn để đội thoải mái nhé!";
        } else if (lower.contains("ship") || lower.contains("giao hàng") || lower.contains("vận chuyển") || lower.contains("bao lâu") || lower.contains("phí")) {
            botReply = "🚚 **Chính sách giao nhận hàng**:\n"
                    + "• **Nội thành**: Nhận hàng trong 1-2 ngày.\n"
                    + "• **Toàn quốc**: 2-4 ngày làm việc.\n"
                    + "• **Phí ship**: Đồng giá 30.000đ, miễn phí giao hàng cho đơn hàng giá trị cao.\n"
                    + "• Quý khách được **đồng kiểm và thử đội** trước khi thanh toán tiền cho shipper!";
        } else if (lower.contains("bảo hành") || lower.contains("đổi") || lower.contains("trả") || lower.contains("lỗi") || lower.contains("hoàn tiền")) {
            botReply = "🛡️ **Chính sách bảo hành & Đổi trả**:\n"
                    + "• **Đổi mới 1-1** trong 7 ngày nếu lỗi từ nhà sản xuất hoặc đội không vừa size (giữ nguyên tem mác).\n"
                    + "• **Bảo hành chính hãng** 12 - 24 tháng cho chốt khóa, kính chắn gió và kết cấu nón.\n"
                    + "• Để yêu cầu đổi hàng nhanh, bạn chỉ cần gửi mã đơn hàng tại đây nhé!";
        } else if (lower.contains("chào") || lower.contains("hi") || lower.contains("hello") || lower.contains("alo") || lower.contains("ad ơi") || lower.contains("shop ơi") || lower.contains("tư vấn")) {
            botReply = "Dạ chào bạn! Rất vui được hỗ trợ bạn. Chuyên viên tư vấn đang kết nối và sẽ phản hồi bạn trong giây lát.\nBạn đang tìm mũ bảo hiểm dòng nào: **Fullface**, **Mũ 3/4** hay **Nửa đầu tiện lợi** ạ?";
        }

        if (botReply != null) {
            String finalReply = botReply;
            new Thread(() -> {
                try {
                    Thread.sleep(600); // Realistic small typing delay
                    TinNhan botMsg = TinNhan.builder()
                            .khachHang(khachHang)
                            .sessionGuestId(khachHang == null ? sessionGuestId : null)
                            .senderRole("BOT")
                            .senderName("Trợ lý Shop")
                            .noiDung(finalReply)
                            .thoiGian(LocalDateTime.now())
                            .daDoc(false)
                            .build();

                    TinNhan savedBot = tinNhanRepo.save(botMsg);
                    ChatMessageDTO botDto = toDTO(savedBot);
                    broadcastMessage(convKey, botDto);
                } catch (Exception e) {
                    log.error("Error sending bot reply: ", e);
                }
            }).start();
        }
    }

    private ChatMessageDTO toDTO(TinNhan tn) {
        return ChatMessageDTO.builder()
                .id(tn.getId())
                .customerId(tn.getKhachHang() != null ? tn.getKhachHang().getId() : null)
                .sessionGuestId(tn.getSessionGuestId())
                .senderRole(tn.getSenderRole())
                .senderName(tn.getSenderName())
                .content(tn.getNoiDung())
                .time(tn.getThoiGian() != null ? tn.getThoiGian().format(FORMATTER) : "")
                .read(Boolean.TRUE.equals(tn.getDaDoc()))
                .build();
    }
}
