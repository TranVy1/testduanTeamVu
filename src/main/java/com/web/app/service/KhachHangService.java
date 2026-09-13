package com.web.app.service;

import com.web.app.model.KhachHang;
import com.web.app.model.DonHang;
import com.web.app.dto.KhachHangAdminDTO;
import com.web.app.repository.KhachHangRepository;
import com.web.app.repository.DonHangRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.Comparator;
import java.time.LocalDateTime;

@Service
public class KhachHangService {

    @Autowired
    private KhachHangRepository khachHangRepository;

    @Autowired
    private DonHangRepository donHangRepository;

    public List<KhachHang> findAll() {
        return khachHangRepository.findAll();
    }

    public Optional<KhachHang> findById(Integer id) {
        return khachHangRepository.findById(id);
    }

    public Optional<KhachHang> findByTaiKhoanId(Integer taiKhoanId) {
        return khachHangRepository.findByTaiKhoanId(taiKhoanId);
    }

    public Optional<KhachHang> findByTenDangNhap(String tenDangNhap) {
        return khachHangRepository.findByTaiKhoanTenDangNhap(tenDangNhap);
    }

    public List<KhachHangAdminDTO> getAdminCustomers() {
        Map<Integer, List<DonHang>> ordersByCustomer = donHangRepository.findAllByOrderByNgayDatDesc().stream()
                .filter(order -> order.getKhachHang() != null)
                .collect(Collectors.groupingBy(order -> order.getKhachHang().getId()));
        return khachHangRepository.findAll().stream().map(customer -> {
            List<DonHang> orders = ordersByCustomer.getOrDefault(customer.getId(), List.of());
            double spent = orders.stream().filter(order -> "DELIVERED".equals(order.getTrangThai()))
                    .mapToDouble(order -> order.getTongTien() == null ? 0 : order.getTongTien()).sum();
            LocalDateTime firstOrder = orders.stream().map(DonHang::getNgayDat).filter(java.util.Objects::nonNull)
                    .min(Comparator.naturalOrder()).orElse(null);
            return new KhachHangAdminDTO(customer, orders.size(), spent, firstOrder);
        }).toList();
    }

    @Transactional
    public void toggleAccountStatus(Integer customerId) {
        KhachHang customer = khachHangRepository.findById(customerId)
                .orElseThrow(() -> new IllegalArgumentException("Khách hàng không tồn tại."));
        if (customer.getTaiKhoan() == null) {
            throw new IllegalArgumentException("Khách hàng chưa có tài khoản.");
        }
        customer.getTaiKhoan().setTrangThai("LOCKED".equals(customer.getTaiKhoan().getTrangThai()) ? "ACTIVE" : "LOCKED");
        khachHangRepository.save(customer);
    }

    @Transactional
    public KhachHang updateProfile(Integer id, String hoTen, String email, String soDienThoai, String diaChi) {
        KhachHang khachHang = khachHangRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Khách hàng không tồn tại!"));

        if (hoTen == null || !com.web.app.util.ValidationUtil.isValidFullName(hoTen)) {
            throw new IllegalArgumentException("Họ tên không hợp lệ! Vui lòng nhập từ 2 ký tự và không chứa số/ký tự đặc biệt.");
        }
        if (soDienThoai != null && !soDienThoai.isBlank() && !com.web.app.util.ValidationUtil.isValidPhone(soDienThoai)) {
            throw new IllegalArgumentException("Số điện thoại không hợp lệ! Vui lòng nhập đúng 10 số (bắt đầu bằng 03, 05, 07, 08, 09).");
        }
        if (email != null && !email.isBlank() && !com.web.app.util.ValidationUtil.isValidEmail(email)) {
            throw new IllegalArgumentException("Địa chỉ email không đúng định dạng!");
        }
        if (diaChi != null && !diaChi.isBlank() && !com.web.app.util.ValidationUtil.isValidAddress(diaChi)) {
            throw new IllegalArgumentException("Địa chỉ quá ngắn! Vui lòng nhập địa chỉ cụ thể từ 8 ký tự trở lên.");
        }

        khachHang.setHoTen(hoTen.trim());
        khachHang.setEmail(email != null ? email.trim() : null);
        khachHang.setSoDienThoai(soDienThoai != null ? soDienThoai.trim() : null);
        khachHang.setDiaChi(diaChi != null ? diaChi.trim() : null);

        return khachHangRepository.save(khachHang);
    }
}

