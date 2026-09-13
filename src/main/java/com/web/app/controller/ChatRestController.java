package com.web.app.controller;

import com.web.app.dto.ChatConversationDTO;
import com.web.app.dto.ChatMessageDTO;
import com.web.app.model.KhachHang;
import com.web.app.model.TaiKhoan;
import com.web.app.service.ChatService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/chat")
@RequiredArgsConstructor
public class ChatRestController {

    private final ChatService chatService;

    /**
     * Customer get conversation history
     */
    @GetMapping("/history")
    public ResponseEntity<List<ChatMessageDTO>> getCustomerHistory(
            @RequestParam(value = "sessionGuestId", required = false) String sessionGuestId,
            HttpSession session) {

        KhachHang user = (KhachHang) session.getAttribute("user");
        Integer customerId = user != null ? user.getId() : null;

        List<ChatMessageDTO> history = chatService.getHistory(customerId, sessionGuestId);
        return ResponseEntity.ok(history);
    }

    /**
     * Customer send message
     */
    @PostMapping("/send")
    public ResponseEntity<?> sendCustomerMessage(
            @RequestParam("content") String content,
            @RequestParam(value = "sessionGuestId", required = false) String sessionGuestId,
            HttpSession session) {

        if (content == null || content.trim().isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("error", "Nội dung tin nhắn không được để trống!"));
        }

        KhachHang user = (KhachHang) session.getAttribute("user");
        Integer customerId = user != null ? user.getId() : null;

        ChatMessageDTO msg = chatService.sendCustomerMessage(customerId, sessionGuestId, content.trim());
        return ResponseEntity.ok(msg);
    }

    /**
     * Admin get list of conversations
     */
    @GetMapping("/admin/conversations")
    public ResponseEntity<?> getAdminConversations(HttpSession session) {
        if (session.getAttribute("admin") == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Yêu cầu quyền Admin"));
        }
        List<ChatConversationDTO> list = chatService.getAllConversations();
        return ResponseEntity.ok(list);
    }

    /**
     * Admin get conversation history
     */
    @GetMapping("/admin/history")
    public ResponseEntity<?> getAdminHistory(
            @RequestParam("conversationKey") String conversationKey,
            HttpSession session) {

        if (session.getAttribute("admin") == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Yêu cầu quyền Admin"));
        }
        List<ChatMessageDTO> history = chatService.getHistoryByConversationKey(conversationKey);
        return ResponseEntity.ok(history);
    }

    /**
     * Admin send message to customer
     */
    @PostMapping("/admin/send")
    public ResponseEntity<?> sendAdminMessage(
            @RequestParam("conversationKey") String conversationKey,
            @RequestParam("content") String content,
            HttpSession session) {

        if (session.getAttribute("admin") == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Yêu cầu quyền Admin"));
        }

        if (content == null || content.trim().isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("error", "Nội dung tin nhắn không được để trống!"));
        }

        TaiKhoan adminTk = (TaiKhoan) session.getAttribute("admin");
        String adminName = (adminTk != null && adminTk.getTenDangNhap() != null) ? adminTk.getTenDangNhap() : "Quản trị viên";

        ChatMessageDTO msg = chatService.sendAdminMessage(conversationKey, content.trim(), adminName);
        return ResponseEntity.ok(msg);
    }

    /**
     * Admin mark conversation as read
     */
    @PostMapping("/admin/read")
    public ResponseEntity<?> markAsRead(
            @RequestParam("conversationKey") String conversationKey,
            HttpSession session) {

        if (session.getAttribute("admin") == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Yêu cầu quyền Admin"));
        }
        chatService.markAsReadByAdmin(conversationKey);
        return ResponseEntity.ok(Map.of("success", true));
    }
}
