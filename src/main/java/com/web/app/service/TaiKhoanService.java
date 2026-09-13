package com.web.app.service;

import com.web.app.model.KhachHang;
import com.web.app.model.TaiKhoan;
import com.web.app.repository.KhachHangRepository;
import com.web.app.repository.TaiKhoanRepository;
import com.web.app.util.HashUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
public class TaiKhoanService {

    @Autowired
    private TaiKhoanRepository taiKhoanRepository;

    @Autowired
    private KhachHangRepository khachHangRepository;

    public Optional<TaiKhoan> findByTenDangNhap(String tenDangNhap) {
        return taiKhoanRepository.findByTenDangNhap(tenDangNhap);
    }

    @Transactional
    public TaiKhoan dangKy(String tenDangNhap, String matKhau, String hoTen, String email, String soDienThoai, String diaChi) {
        if (tenDangNhap == null || tenDangNhap.trim().length() < 3) {
            throw new IllegalArgumentException("Tên đăng nhập phải có ít nhất 3 ký tự!");
        }
        if (matKhau == null || matKhau.trim().length() < 6) {
            throw new IllegalArgumentException("Mật khẩu phải có ít nhất 6 ký tự!");
        }
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

        if (taiKhoanRepository.findByTenDangNhap(tenDangNhap.trim()).isPresent()) {
            throw new IllegalArgumentException("Tên đăng nhập đã tồn tại!");
        }

        TaiKhoan taiKhoan = TaiKhoan.builder()
                .tenDangNhap(tenDangNhap.trim())
                .matKhau(HashUtil.hashPassword(matKhau))
                .vaiTro("USER")
                .trangThai("ACTIVE")
                .build();


        TaiKhoan savedAcc = taiKhoanRepository.save(taiKhoan);

        KhachHang khachHang = KhachHang.builder()
                .hoTen(hoTen)
                .email(email)
                .soDienThoai(soDienThoai)
                .diaChi(diaChi)
                .taiKhoan(savedAcc)
                .build();

        khachHangRepository.save(khachHang);
        return savedAcc;
    }

    public Optional<TaiKhoan> dangNhap(String tenDangNhap, String matKhau) {
        Optional<TaiKhoan> taiKhoanOpt = taiKhoanRepository.findByTenDangNhap(tenDangNhap);
        if (taiKhoanOpt.isPresent()) {
            TaiKhoan tk = taiKhoanOpt.get();
            if (HashUtil.verifyPassword(matKhau, tk.getMatKhau()) && "ACTIVE".equals(tk.getTrangThai())) {
                // Auto-upgrade legacy hash to BCrypt on successful login
                if (!tk.getMatKhau().startsWith("$2")) {
                    tk.setMatKhau(HashUtil.hashPassword(matKhau));
                    taiKhoanRepository.save(tk);
                }
                return Optional.of(tk);
            }
        }
        return Optional.empty();
    }

    @Transactional
    public void doiMatKhau(Integer taiKhoanId, String oldPassword, String newPassword) {
        TaiKhoan tk = taiKhoanRepository.findById(taiKhoanId)
                .orElseThrow(() -> new IllegalArgumentException("Tài khoản không tồn tại!"));
        if (!HashUtil.verifyPassword(oldPassword, tk.getMatKhau())) {
            throw new IllegalArgumentException("Mật khẩu hiện tại không chính xác!");
        }
        tk.setMatKhau(HashUtil.hashPassword(newPassword));
        taiKhoanRepository.save(tk);
    }
}
