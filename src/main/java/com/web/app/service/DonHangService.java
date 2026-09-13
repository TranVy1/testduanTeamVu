package com.web.app.service;

import com.web.app.model.*;
import com.web.app.repository.*;
import com.web.app.util.ValidationUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;


import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class DonHangService {

    @Autowired
    private DonHangRepository donHangRepository;

    @Autowired
    private ChiTietDonHangRepository chiTietDonHangRepository;

    @Autowired
    private GioHangService gioHangService;

    @Autowired
    private SanPhamRepository sanPhamRepository;

    @Autowired
    private KhachHangRepository khachHangRepository;

    @Autowired
    private MaGiamGiaRepository maGiamGiaRepository;

    @Autowired
    private MaGiamGiaService maGiamGiaService;

    @Autowired
    private BienTheSanPhamRepository bienTheSanPhamRepository;

    @Autowired
    private RealtimeService realtimeService;

    @Transactional
    public DonHang createOrder(Integer khachHangId, String hoTenNhan, String soDienThoaiNhan, String diaChiNhan, String ghiChu) {
        return createOrder(khachHangId, hoTenNhan, soDienThoaiNhan, diaChiNhan, ghiChu, null, "COD");
    }

    @Transactional
    public DonHang createOrder(Integer khachHangId, String hoTenNhan, String soDienThoaiNhan, String diaChiNhan, String ghiChu, String couponCode) {
        return createOrder(khachHangId, hoTenNhan, soDienThoaiNhan, diaChiNhan, ghiChu, couponCode, "COD");
    }

    @Transactional
    public DonHang createOrder(Integer khachHangId, String hoTenNhan, String soDienThoaiNhan, String diaChiNhan, String ghiChu, String couponCode, String phuongThucThanhToan) {
        // Strict recipient info validation
        ValidationUtil.validateRecipientInfo(hoTenNhan, soDienThoaiNhan, diaChiNhan);

        List<ChiTietGioHang> cartItems = gioHangService.getCartDetails(khachHangId);
        if (cartItems.isEmpty()) {
            throw new IllegalArgumentException("Giỏ hàng của bạn đang trống!");
        }


        KhachHang khachHang = khachHangRepository.findById(khachHangId)
                .orElseThrow(() -> new IllegalArgumentException("Khách hàng không tồn tại!"));

        double tongTien = 0.0;
        // Validate stock and calculate total
        for (ChiTietGioHang item : cartItems) {
            SanPham sp = item.getSanPham();
            if (item.getTonKho() < item.getSoLuong()) {
                throw new IllegalArgumentException("Sản phẩm '" + sp.getTenSanPham() + "' không đủ số lượng trong kho!");
            }
            tongTien += item.getDonGia() * item.getSoLuong();
        }

        MaGiamGia khuyenMai = null;
        double soTienGiam = 0.0;
        if (couponCode != null && !couponCode.trim().isEmpty()) {
            khuyenMai = maGiamGiaRepository.findByMaCode(couponCode.trim().toUpperCase())
                    .orElseThrow(() -> new IllegalArgumentException("Mã giảm giá không tồn tại!"));
            maGiamGiaService.checkCouponValidity(khuyenMai, tongTien);
            soTienGiam = maGiamGiaService.calculateDiscount(khuyenMai, tongTien);
            
            // Increment usage count of the coupon
            khuyenMai.setSoLuongDaDung(khuyenMai.getSoLuongDaDung() + 1);
            maGiamGiaRepository.save(khuyenMai);
        }

        double tongTienSauGiam = tongTien - soTienGiam;
        if (tongTienSauGiam < 0) {
            tongTienSauGiam = 0.0;
        }

        // Create order
        String paymentMethod = (phuongThucThanhToan == null || phuongThucThanhToan.isBlank()) ? "COD" : phuongThucThanhToan.trim().toUpperCase();
        DonHang donHang = DonHang.builder()
                .khachHang(khachHang)
                .ngayDat(LocalDateTime.now())
                .tongTien(tongTienSauGiam)
                .trangThai("PENDING") // PENDING, CONFIRMED, SHIPPING, DELIVERED, CANCELLED
                .hoTenNhan(hoTenNhan)
                .soDienThoaiNhan(soDienThoaiNhan)
                .diaChiNhan(diaChiNhan)
                .ghiChu(ghiChu)
                .khuyenMai(khuyenMai)
                .soTienGiam(soTienGiam)
                .phuongThucThanhToan(paymentMethod)
                .trangThaiThanhToan("UNPAID")
                .build();

        DonHang savedOrder = donHangRepository.save(donHang);

        // Create order details and update stock
        for (ChiTietGioHang item : cartItems) {
            SanPham sp = item.getSanPham();
            
            // Create detail
            ChiTietDonHang ctdh = ChiTietDonHang.builder()
                    .donHang(savedOrder)
                    .sanPham(sp)
                    .bienThe(item.getBienThe())
                    .soLuong(item.getSoLuong())
                    .giaBan(item.getDonGia())
                    .build();
            chiTietDonHangRepository.save(ctdh);

            // Deduct stock
            if (item.getBienThe() != null) {
                BienTheSanPham variant = item.getBienThe();
                variant.setSoLuong(variant.getSoLuong() - item.getSoLuong());
                bienTheSanPhamRepository.save(variant);
                sp.setSoLuong(sp.getSoLuong() - item.getSoLuong());
                sanPhamRepository.save(sp);
            } else {
                sp.setSoLuong(sp.getSoLuong() - item.getSoLuong());
                sanPhamRepository.save(sp);
            }
        }

        // Clear cart
        gioHangService.clearCart(khachHangId);
        realtimeService.publishForCustomer("ORDERS", khachHangId);
        realtimeService.publish("ADMIN_ORDERS");
        realtimeService.publish("CATALOG");

        return savedOrder;
    }

    public List<DonHang> getOrderHistory(Integer khachHangId) {
        return donHangRepository.findByKhachHangIdOrderByNgayDatDesc(khachHangId);
    }

    public Page<DonHang> getOrderHistoryPaginated(Integer khachHangId, String status, int page, int size) {
        Pageable pageable = PageRequest.of(Math.max(0, page - 1), size, Sort.by("ngayDat").descending());
        if (status != null && !status.isBlank() && !"ALL".equalsIgnoreCase(status.trim())) {
            return donHangRepository.findByKhachHangIdAndTrangThai(khachHangId, status.trim().toUpperCase(), pageable);
        }
        return donHangRepository.findByKhachHangId(khachHangId, pageable);
    }



    public List<DonHang> getAllOrders() {
        return donHangRepository.findAllByOrderByNgayDatDesc();
    }

    public Page<DonHang> getFilteredOrders(String keyword, String status, LocalDateTime fromDate,
                                           LocalDateTime toDate, int page, int size) {
        String cleanKeyword = keyword == null || keyword.trim().isEmpty() ? null : keyword.trim();
        String cleanStatus = status == null || status.trim().isEmpty() ? null : status.trim();
        return donHangRepository.filterOrders(cleanKeyword, cleanStatus, fromDate, toDate,
                PageRequest.of(page, size, Sort.by("ngayDat").descending()));
    }

    public Optional<DonHang> findById(Integer id) {
        return donHangRepository.findById(id);
    }

    public List<ChiTietDonHang> getOrderDetails(Integer orderId) {
        return chiTietDonHangRepository.findByDonHangId(orderId);
    }

    public boolean isValidStatusTransition(String from, String to) {
        if (from == null || to == null) return false;
        if (from.equals(to)) return true;

        return switch (from) {
            case "PENDING" -> "CONFIRMED".equals(to) || "CANCELLED".equals(to);
            case "CONFIRMED" -> "SHIPPING".equals(to) || "CANCELLED".equals(to);
            case "SHIPPING" -> "DELIVERED".equals(to) || "CANCELLED".equals(to);
            case "DELIVERED", "CANCELLED" -> false; // Terminal states
            default -> false;
        };
    }

    public String getStatusLabel(String status) {
        if (status == null) return "";
        return switch (status) {
            case "PENDING" -> "Chờ xử lý";
            case "CONFIRMED" -> "Đã xác nhận";
            case "SHIPPING" -> "Đang giao hàng";
            case "DELIVERED" -> "Đã hoàn thành";
            case "CANCELLED" -> "Đã hủy";
            default -> status;
        };
    }

    @Transactional
    public void updateOrderStatus(Integer orderId, String newStatus) {
        DonHang dh = donHangRepository.findById(orderId)
                .orElseThrow(() -> new IllegalArgumentException("Đơn hàng không tồn tại!"));

        String currentStatus = dh.getTrangThai();
        if (currentStatus.equals(newStatus)) {
            return;
        }

        if (!isValidStatusTransition(currentStatus, newStatus)) {
            throw new IllegalArgumentException("Quy trình không hợp lệ: Không thể chuyển từ [" + 
                getStatusLabel(currentStatus) + "] sang [" + getStatusLabel(newStatus) + "]!");
        }

        // If order becomes DELIVERED, automatically mark payment as PAID (especially for COD)
        if ("DELIVERED".equals(newStatus)) {
            dh.setTrangThaiThanhToan("PAID");
            if (dh.getNgayThanhToan() == null) {
                dh.setNgayThanhToan(LocalDateTime.now());
            }
            if (dh.getMaGiaoDich() == null || dh.getMaGiaoDich().isBlank()) {
                dh.setMaGiaoDich("COD-DLV-" + orderId);
            }
        }

        // If order gets CANCELLED, restore product stock and coupon usage count
        if (newStatus.equals("CANCELLED") && !currentStatus.equals("CANCELLED")) {
            List<ChiTietDonHang> details = chiTietDonHangRepository.findByDonHangId(orderId);
            for (ChiTietDonHang detail : details) {
                SanPham sp = detail.getSanPham();
                if (detail.getBienThe() != null) {
                    detail.getBienThe().setSoLuong(detail.getBienThe().getSoLuong() + detail.getSoLuong());
                    bienTheSanPhamRepository.save(detail.getBienThe());
                    sp.setSoLuong(sp.getSoLuong() + detail.getSoLuong());
                    sanPhamRepository.save(sp);
                } else {
                    sp.setSoLuong(sp.getSoLuong() + detail.getSoLuong());
                    sanPhamRepository.save(sp);
                }
            }
            if (dh.getKhuyenMai() != null) {
                MaGiamGia km = dh.getKhuyenMai();
                if (km.getSoLuongDaDung() != null && km.getSoLuongDaDung() > 0) {
                    km.setSoLuongDaDung(km.getSoLuongDaDung() - 1);
                    maGiamGiaRepository.save(km);
                }
            }
        } else if (currentStatus.equals("CANCELLED") && !newStatus.equals("CANCELLED")) {
            List<ChiTietDonHang> details = chiTietDonHangRepository.findByDonHangId(orderId);
            for (ChiTietDonHang detail : details) {
                SanPham sp = detail.getSanPham();
                int stock = detail.getBienThe() != null ? detail.getBienThe().getSoLuong() : sp.getSoLuong();
                if (stock < detail.getSoLuong()) {
                    throw new IllegalArgumentException("Không thể khôi phục đơn hàng vì sản phẩm '" + sp.getTenSanPham() + "' không đủ hàng tồn kho!");
                }
                if (detail.getBienThe() != null) {
                    detail.getBienThe().setSoLuong(stock - detail.getSoLuong());
                    bienTheSanPhamRepository.save(detail.getBienThe());
                    sp.setSoLuong(sp.getSoLuong() - detail.getSoLuong());
                    sanPhamRepository.save(sp);
                } else {
                    sp.setSoLuong(stock - detail.getSoLuong());
                    sanPhamRepository.save(sp);
                }
            }
            if (dh.getKhuyenMai() != null) {
                MaGiamGia km = dh.getKhuyenMai();
                if (km.getSoLuong() != null && km.getSoLuongDaDung() != null && km.getSoLuongDaDung() >= km.getSoLuong()) {
                    throw new IllegalArgumentException("Không thể khôi phục đơn hàng vì mã giảm giá đã hết lượt sử dụng!");
                }
                km.setSoLuongDaDung(km.getSoLuongDaDung() + 1);
                maGiamGiaRepository.save(km);
            }
        }

        dh.setTrangThai(newStatus);
        donHangRepository.save(dh);
        realtimeService.publishForCustomer("ORDERS", dh.getKhachHang().getId());
        realtimeService.publish("ADMIN_ORDERS");
        realtimeService.publish("CATALOG");
    }

    @Transactional
    public void updatePaymentStatus(Integer orderId, String paymentStatus) {
        updatePaymentStatus(orderId, paymentStatus, null, null);
    }

    @Transactional
    public void updatePaymentStatus(Integer orderId, String paymentStatus, String maGiaoDich, LocalDateTime ngayThanhToan) {
        DonHang dh = donHangRepository.findById(orderId)
                .orElseThrow(() -> new IllegalArgumentException("Đơn hàng không tồn tại!"));
        dh.setTrangThaiThanhToan(paymentStatus);
        if ("PAID".equals(paymentStatus)) {
            if (ngayThanhToan != null) {
                dh.setNgayThanhToan(ngayThanhToan);
            } else if (dh.getNgayThanhToan() == null) {
                dh.setNgayThanhToan(LocalDateTime.now());
            }
            if (maGiaoDich != null && !maGiaoDich.isBlank()) {
                dh.setMaGiaoDich(maGiaoDich);
            } else if (dh.getMaGiaoDich() == null || dh.getMaGiaoDich().isBlank()) {
                String prefix = "VNPAY".equalsIgnoreCase(dh.getPhuongThucThanhToan()) ? "VNP" :
                                "VIETQR".equalsIgnoreCase(dh.getPhuongThucThanhToan()) ? "FT" : "PAY";
                dh.setMaGiaoDich(prefix + (System.currentTimeMillis() % 100000000));
            }
        }
        donHangRepository.save(dh);
        realtimeService.publishForCustomer("ORDERS", dh.getKhachHang().getId());
        realtimeService.publish("ADMIN_ORDERS");
    }
}
