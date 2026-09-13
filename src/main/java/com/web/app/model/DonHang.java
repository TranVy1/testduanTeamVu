package com.web.app.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "DonHang")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DonHang {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "khach_hang_id")
    private KhachHang khachHang;

    @Column(name = "ngay_dat")
    private LocalDateTime ngayDat;

    @Column(name = "tong_tien", nullable = false)
    private Double tongTien;

    @Column(name = "trang_thai", nullable = false, length = 50)
    private String trangThai; // "PENDING", "CONFIRMED", "SHIPPING", "DELIVERED", "CANCELLED"

    @Column(name = "ho_ten_nhan", nullable = false, columnDefinition = "NVARCHAR(100)")
    private String hoTenNhan;

    @Column(name = "so_dien_thoai_nhan", nullable = false, length = 15)
    private String soDienThoaiNhan;

    @Column(name = "dia_chi_nhan", nullable = false, columnDefinition = "NVARCHAR(255)")
    private String diaChiNhan;

    @Column(name = "ghi_chu", columnDefinition = "NVARCHAR(255)")
    private String ghiChu;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "khuyen_mai_id")
    private MaGiamGia khuyenMai;

    @Column(name = "so_tien_giam")
    @Builder.Default
    private Double soTienGiam = 0.0;

    @Column(name = "phuong_thuc_thanh_toan", length = 30)
    @Builder.Default
    private String phuongThucThanhToan = "COD"; // "COD", "VIETQR"

    @Column(name = "trang_thai_thanh_toan", length = 30)
    @Builder.Default
    private String trangThaiThanhToan = "UNPAID"; // "UNPAID", "PAID"

    @Column(name = "ma_giao_dich", length = 100)
    private String maGiaoDich;

    @Column(name = "ngay_thanh_toan")
    private LocalDateTime ngayThanhToan;
}
