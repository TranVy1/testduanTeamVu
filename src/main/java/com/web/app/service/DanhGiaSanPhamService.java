package com.web.app.service;

import com.web.app.model.DanhGiaSanPham;
import com.web.app.model.KhachHang;
import com.web.app.model.SanPham;
import com.web.app.repository.DanhGiaSanPhamRepository;
import com.web.app.repository.KhachHangRepository;
import com.web.app.repository.SanPhamRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class DanhGiaSanPhamService {

    @Autowired
    private DanhGiaSanPhamRepository danhGiaSanPhamRepository;

    @Autowired
    private SanPhamRepository sanPhamRepository;

    @Autowired
    private KhachHangRepository khachHangRepository;

    @Autowired
    private com.web.app.repository.ChiTietDonHangRepository chiTietDonHangRepository;

    public boolean hasCustomerPurchasedProduct(Integer khachHangId, Integer sanPhamId) {
        if (khachHangId == null || sanPhamId == null) {
            return false;
        }
        return chiTietDonHangRepository.hasPurchasedProduct(khachHangId, sanPhamId);
    }

    public List<DanhGiaSanPham> getReviewsByProductId(Integer sanPhamId) {
        return danhGiaSanPhamRepository.findBySanPhamIdOrderByNgayTaoDesc(sanPhamId);
    }

    public double getAverageRating(Integer sanPhamId) {
        List<DanhGiaSanPham> reviews = getReviewsByProductId(sanPhamId);
        if (reviews.isEmpty()) {
            return 5.0; // Default 5.0 for display when no reviews
        }
        double sum = 0;
        for (DanhGiaSanPham r : reviews) {
            sum += r.getSoSao();
        }
        return Math.round((sum / reviews.size()) * 10.0) / 10.0;
    }

    public long getReviewCount(Integer sanPhamId) {
        return danhGiaSanPhamRepository.countBySanPhamId(sanPhamId);
    }

    @Transactional
    public DanhGiaSanPham addReview(Integer khachHangId, Integer sanPhamId, int soSao, String noiDung) {
        if (!hasCustomerPurchasedProduct(khachHangId, sanPhamId)) {
            throw new IllegalArgumentException("Bạn chỉ có thể đánh giá sản phẩm sau khi đã có đơn mua tại cửa hàng!");
        }
        if (soSao < 1 || soSao > 5) {
            throw new IllegalArgumentException("Số sao đánh giá phải từ 1 đến 5!");
        }
        if (noiDung == null || noiDung.trim().isEmpty()) {
            throw new IllegalArgumentException("Vui lòng nhập nội dung nhận xét!");
        }

        KhachHang khachHang = khachHangRepository.findById(khachHangId)
                .orElseThrow(() -> new IllegalArgumentException("Khách hàng không tồn tại!"));

        SanPham sanPham = sanPhamRepository.findById(sanPhamId)
                .orElseThrow(() -> new IllegalArgumentException("Sản phẩm không tồn tại!"));

        DanhGiaSanPham review = DanhGiaSanPham.builder()
                .khachHang(khachHang)
                .sanPham(sanPham)
                .soSao(soSao)
                .noiDung(noiDung.trim())
                .build();

        return danhGiaSanPhamRepository.save(review);
    }
}
