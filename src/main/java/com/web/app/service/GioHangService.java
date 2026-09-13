package com.web.app.service;

import com.web.app.model.*;
import com.web.app.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class GioHangService {
    @Autowired private GioHangRepository gioHangRepository;
    @Autowired private ChiTietGioHangRepository chiTietGioHangRepository;
    @Autowired private KhachHangRepository khachHangRepository;
    @Autowired private SanPhamRepository sanPhamRepository;
    @Autowired private BienTheSanPhamRepository bienTheSanPhamRepository;
    @Autowired private RealtimeService realtimeService;

    private GioHang getOrCreateGioHang(Integer customerId) {
        return gioHangRepository.findByKhachHangId(customerId).orElseGet(() -> {
            KhachHang customer = khachHangRepository.findById(customerId)
                    .orElseThrow(() -> new IllegalArgumentException("Khách hàng không tồn tại!"));
            return gioHangRepository.save(GioHang.builder().khachHang(customer).build());
        });
    }

    public List<ChiTietGioHang> getCartDetails(Integer customerId) {
        return gioHangRepository.findByKhachHangId(customerId)
                .map(cart -> chiTietGioHangRepository.findByGioHangId(cart.getId()))
                .orElseGet(ArrayList::new);
    }

    @Transactional
    public void addToCart(Integer customerId, Integer productId, int quantity) { addToCart(customerId, productId, null, quantity); }

    @Transactional
    public void addToCart(Integer customerId, Integer productId, Integer variantId, int quantity) {
        if (quantity <= 0) throw new IllegalArgumentException("Số lượng phải lớn hơn 0!");
        GioHang cart = getOrCreateGioHang(customerId);
        SanPham product = sanPhamRepository.findById(productId)
                .orElseThrow(() -> new IllegalArgumentException("Sản phẩm không tồn tại!"));
        BienTheSanPham variant = variantId == null ? null : bienTheSanPhamRepository.findById(variantId)
                .orElseThrow(() -> new IllegalArgumentException("Biến thể không tồn tại!"));
        if (variant != null && !variant.getSanPham().getId().equals(productId)) throw new IllegalArgumentException("Biến thể không thuộc sản phẩm này!");
        int stock = variant == null ? product.getSoLuong() : variant.getSoLuong();
        if (stock < quantity) throw new IllegalArgumentException("Số lượng trong kho không đủ!");
        Optional<ChiTietGioHang> existing = variant == null
                ? chiTietGioHangRepository.findByGioHangIdAndSanPhamIdAndBienTheIsNull(cart.getId(), productId)
                : chiTietGioHangRepository.findByGioHangIdAndBienTheId(cart.getId(), variantId);
        if (existing.isPresent()) {
            ChiTietGioHang item = existing.get();
            if (stock < item.getSoLuong() + quantity) throw new IllegalArgumentException("Tổng số lượng vượt quá tồn kho!");
            item.setSoLuong(item.getSoLuong() + quantity);
            chiTietGioHangRepository.save(item);
        } else chiTietGioHangRepository.save(ChiTietGioHang.builder().gioHang(cart).sanPham(product).bienThe(variant).soLuong(quantity).build());
        realtimeService.publishForCustomer("CART", customerId);
    }

    @Transactional
    public void updateCartItemQuantityById(Integer customerId, Integer itemId, int quantity) {
        ChiTietGioHang item = getOwnedItem(customerId, itemId);
        if (item == null) return;
        if (quantity <= 0) { chiTietGioHangRepository.delete(item); realtimeService.publishForCustomer("CART", customerId); return; }
        if (item.getTonKho() < quantity) throw new IllegalArgumentException("Số lượng trong kho không đủ!");
        item.setSoLuong(quantity); chiTietGioHangRepository.save(item); realtimeService.publishForCustomer("CART", customerId);
    }

    @Transactional
    public void updateCartItemQuantity(Integer customerId, Integer productId, int quantity) {
        GioHang cart = getOrCreateGioHang(customerId);
        Optional<ChiTietGioHang> itemOpt = chiTietGioHangRepository.findByGioHangIdAndSanPhamIdAndBienTheIsNull(cart.getId(), productId);
        if (itemOpt.isEmpty()) {
            itemOpt = chiTietGioHangRepository.findById(productId);
        }
        ChiTietGioHang item = itemOpt.orElseThrow(() -> new IllegalArgumentException("Sản phẩm không có trong giỏ hàng!"));
        updateCartItemQuantityById(customerId, item.getId(), quantity);
    }

    @Transactional
    public void removeCartItemById(Integer customerId, Integer itemId) {
        ChiTietGioHang item = getOwnedItem(customerId, itemId);
        if (item != null) {
            chiTietGioHangRepository.delete(item);
            realtimeService.publishForCustomer("CART", customerId);
        }
    }

    @Transactional
    public void removeCartItem(Integer customerId, Integer productId) {
        gioHangRepository.findByKhachHangId(customerId).ifPresent(cart -> {
            List<ChiTietGioHang> list = chiTietGioHangRepository.findByGioHangId(cart.getId());
            boolean modified = false;
            for (ChiTietGioHang it : list) {
                if ((it.getSanPham() != null && it.getSanPham().getId().equals(productId)) ||
                    (it.getBienThe() != null && it.getBienThe().getId().equals(productId)) ||
                    it.getId().equals(productId)) {
                    chiTietGioHangRepository.delete(it);
                    modified = true;
                }
            }
            if (modified) {
                realtimeService.publishForCustomer("CART", customerId);
            }
        });
    }

    private ChiTietGioHang getOwnedItem(Integer customerId, Integer itemId) {
        Optional<ChiTietGioHang> itemOpt = chiTietGioHangRepository.findById(itemId);
        if (itemOpt.isPresent()) {
            ChiTietGioHang item = itemOpt.get();
            if (!item.getGioHang().getKhachHang().getId().equals(customerId)) {
                throw new IllegalArgumentException("Không có quyền thao tác giỏ hàng!");
            }
            return item;
        }
        // Fallback: If itemId passed was a product ID or variant ID in this customer's cart
        Optional<GioHang> cartOpt = gioHangRepository.findByKhachHangId(customerId);
        if (cartOpt.isPresent()) {
            List<ChiTietGioHang> items = chiTietGioHangRepository.findByGioHangId(cartOpt.get().getId());
            for (ChiTietGioHang it : items) {
                if ((it.getSanPham() != null && it.getSanPham().getId().equals(itemId)) ||
                    (it.getBienThe() != null && it.getBienThe().getId().equals(itemId))) {
                    return it;
                }
            }
        }
        return null;
    }

    @Transactional
    public void clearCart(Integer customerId) {
        gioHangRepository.findByKhachHangId(customerId).ifPresent(cart -> { chiTietGioHangRepository.deleteAll(chiTietGioHangRepository.findByGioHangId(cart.getId())); realtimeService.publishForCustomer("CART", customerId); });
    }
}
