package com.web.app;

import com.web.app.model.DonHang;
import com.web.app.model.ChiTietDonHang;
import com.web.app.model.KhachHang;
import com.web.app.service.GioHangService;
import com.web.app.service.DonHangService;
import com.web.app.service.KhachHangService;
import com.web.app.controller.CustomerController;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.mvc.support.RedirectAttributesModelMap;

import java.util.List;
import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
class AppApplicationTests {

	@Autowired
	private GioHangService gioHangService;

	@Autowired
	private DonHangService donHangService;

	@Autowired
	private KhachHangService khachHangService;

	@Autowired
	private CustomerController customerController;

	@Autowired
	private com.web.app.repository.SanPhamRepository sanPhamRepository;

	@Test
	void testCartItemDeletion() {
		Integer testPid = sanPhamRepository.findAll().get(0).getId();
		// Ensure product is in the cart
		gioHangService.addToCart(1, testPid, 1);

		// 1. Verify product is initially in customer 1's cart
		var cartDetailsBefore = gioHangService.getCartDetails(1);
		assertFalse(cartDetailsBefore.isEmpty(), "Cart should not be empty initially");
		boolean hasProduct = cartDetailsBefore.stream()
				.anyMatch(item -> item.getSanPham().getId().equals(testPid));
		assertTrue(hasProduct, "Cart should contain test product");

		// 2. Perform deletion
		gioHangService.removeCartItem(1, testPid);

		// 3. Verify product is no longer in the cart
		var cartDetailsAfter = gioHangService.getCartDetails(1);
		boolean stillHasProduct = cartDetailsAfter.stream()
				.anyMatch(item -> item.getSanPham().getId().equals(testPid));
		assertFalse(stillHasProduct, "Cart should not contain test product after deletion");

		// 4. Restore the item back to the cart for verification
		gioHangService.addToCart(1, testPid, 1);
		
		var cartDetailsRestored = gioHangService.getCartDetails(1);
		assertFalse(cartDetailsRestored.isEmpty(), "Cart should have the item restored");
	}

	@Test
	void testOrderCancellation() {
		// Find a pending order or create one
		var orders = donHangService.getOrderHistory(1);
		DonHang pendingOrder = orders.stream()
				.filter(o -> "PENDING".equals(o.getTrangThai()))
				.findFirst()
				.orElse(null);

		if (pendingOrder == null) {
			// Create a dummy order
			Integer testPid = sanPhamRepository.findAll().get(0).getId();
			gioHangService.addToCart(1, testPid, 1);
			pendingOrder = donHangService.createOrder(1, "Test Recipient", "0987654321", "Test Address", "Test Ghi chu");
		}

		assertNotNull(pendingOrder, "Should have at least one PENDING order for testing");

		// Get stock before cancellation
		List<ChiTietDonHang> details = donHangService.getOrderDetails(pendingOrder.getId());
		assertFalse(details.isEmpty(), "Order should have details");
		int originalQtyInStock = details.get(0).getSanPham().getSoLuong();
		int orderQty = details.get(0).getSoLuong();

		// Cancel the order
		donHangService.updateOrderStatus(pendingOrder.getId(), "CANCELLED");

		// Verify status updated to CANCELLED
		DonHang cancelledOrder = donHangService.findById(pendingOrder.getId()).orElseThrow();
		assertEquals("CANCELLED", cancelledOrder.getTrangThai(), "Order status should be CANCELLED");

		// Verify stock was restored
		List<ChiTietDonHang> detailsAfter = donHangService.getOrderDetails(pendingOrder.getId());
		int currentQtyInStock = detailsAfter.get(0).getSanPham().getSoLuong();
		assertEquals(originalQtyInStock + orderQty, currentQtyInStock, "Stock should be restored");
	}

	@Test
	void testCartItemDeletionEndpoint() throws Exception {
		KhachHang kh = khachHangService.findById(1).orElseThrow();
		MockHttpSession session = new MockHttpSession();
		session.setAttribute("user", kh);

		Integer testPid = sanPhamRepository.findAll().get(0).getId();
		// Make sure product is in cart
		gioHangService.addToCart(1, testPid, 1);

		var response = customerController.removeCartItemAjax(testPid, session);
		assertEquals(200, response.getStatusCode().value());
	}

	@Test
	void testOrderCancellationEndpoint() throws Exception {
		KhachHang kh = khachHangService.findById(1).orElseThrow();
		MockHttpSession session = new MockHttpSession();
		session.setAttribute("user", kh);

		// Find a pending order or create one
		var orders = donHangService.getOrderHistory(1);
		DonHang pendingOrder = orders.stream()
				.filter(o -> "PENDING".equals(o.getTrangThai()))
				.findFirst()
				.orElse(null);

		if (pendingOrder == null) {
			Integer testPid = sanPhamRepository.findAll().get(0).getId();
			gioHangService.addToCart(1, testPid, 1);
			pendingOrder = donHangService.createOrder(1, "Test Recipient", "0987654321", "Test Address", "Test Ghi chu");
		}

		RedirectAttributes redirectAttributes = new RedirectAttributesModelMap();
		String result = customerController.cancelOrder(pendingOrder.getId(), session, redirectAttributes);
		assertEquals("redirect:/orders/" + pendingOrder.getId(), result);

		DonHang cancelledOrder = donHangService.findById(pendingOrder.getId()).orElseThrow();
		assertEquals("CANCELLED", cancelledOrder.getTrangThai(), "Order status should be CANCELLED via endpoint");
	}

}
