package com.web.app.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "DanhGiaSanPham")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DanhGiaSanPham {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "san_pham_id", nullable = false)
    private SanPham sanPham;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "khach_hang_id", nullable = false)
    private KhachHang khachHang;

    @Column(name = "so_sao", nullable = false)
    private Integer soSao;

    @Column(name = "noi_dung", columnDefinition = "NVARCHAR(MAX)")
    private String noiDung;

    @Column(name = "ngay_tao")
    private LocalDateTime ngayTao;

    @PrePersist
    protected void onCreate() {
        if (ngayTao == null) {
            ngayTao = LocalDateTime.now();
        }
    }
}
