package com.web.app.repository;

import com.web.app.model.TinNhan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public interface TinNhanRepository extends JpaRepository<TinNhan, Integer> {

    List<TinNhan> findByKhachHangIdOrderByThoiGianAsc(Integer khachHangId);

    List<TinNhan> findBySessionGuestIdOrderByThoiGianAsc(String sessionGuestId);

    List<TinNhan> findAllByOrderByThoiGianDesc();

    long countByKhachHangIdAndSenderRoleAndDaDocFalse(Integer khachHangId, String senderRole);

    long countBySessionGuestIdAndSenderRoleAndDaDocFalse(String sessionGuestId, String senderRole);

    @Modifying
    @Transactional
    @Query("UPDATE TinNhan t SET t.daDoc = true WHERE t.khachHang.id = :khId AND t.senderRole = 'CUSTOMER'")
    void markAsReadByCustomerId(@Param("khId") Integer khId);

    @Modifying
    @Transactional
    @Query("UPDATE TinNhan t SET t.daDoc = true WHERE t.sessionGuestId = :guestId AND t.senderRole = 'CUSTOMER'")
    void markAsReadByGuestId(@Param("guestId") String guestId);

    @Modifying
    @Transactional
    @Query("UPDATE TinNhan t SET t.daDoc = true WHERE t.khachHang.id = :khId AND t.senderRole IN ('ADMIN', 'BOT')")
    void markCustomerReadByCustomerId(@Param("khId") Integer khId);

    @Modifying
    @Transactional
    @Query("UPDATE TinNhan t SET t.daDoc = true WHERE t.sessionGuestId = :guestId AND t.senderRole IN ('ADMIN', 'BOT')")
    void markCustomerReadByGuestId(@Param("guestId") String guestId);
}
