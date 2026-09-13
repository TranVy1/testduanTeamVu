package com.web.app.repository;

import com.web.app.model.DanhGiaSanPham;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DanhGiaSanPhamRepository extends JpaRepository<DanhGiaSanPham, Integer> {
    List<DanhGiaSanPham> findBySanPhamIdOrderByNgayTaoDesc(Integer sanPhamId);
    long countBySanPhamId(Integer sanPhamId);
}
