package com.web.app.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "tin_nhan")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TinNhan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "khach_hang_id")
    private KhachHang khachHang;

    @Column(name = "session_guest_id", length = 100)
    private String sessionGuestId;

    @Column(name = "sender_role", length = 20, nullable = false)
    private String senderRole; // CUSTOMER, ADMIN, BOT

    @Column(name = "sender_name", length = 100)
    private String senderName;

    @Column(name = "noi_dung", columnDefinition = "NVARCHAR(MAX)", nullable = false)
    private String noiDung;

    @Column(name = "thoi_gian", nullable = false)
    private LocalDateTime thoiGian;

    @Column(name = "da_doc", nullable = false)
    @Builder.Default
    private Boolean daDoc = false;
}
