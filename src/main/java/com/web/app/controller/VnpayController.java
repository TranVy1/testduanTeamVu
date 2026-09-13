package com.web.app.controller;

import com.web.app.model.DonHang;
import com.web.app.model.KhachHang;
import com.web.app.service.DonHangService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.time.LocalDateTime;

@Controller
@RequestMapping("/payment/vnpay")
public class VnpayController {

    @Autowired
    private DonHangService donHangService;

    @GetMapping("/{orderId}")
    public String showVnpayGateway(@PathVariable("orderId") Integer orderId,
                                   HttpSession session,
                                   Model model,
                                   RedirectAttributes redirectAttributes) {
        KhachHang kh = (KhachHang) session.getAttribute("user");
        if (kh == null) {
            return "redirect:/login?error=login-required&redirect=/payment/vnpay/" + orderId;
        }

        DonHang order = donHangService.findById(orderId)
                .orElseThrow(() -> new IllegalArgumentException("Đơn hàng không tồn tại!"));

        if (!order.getKhachHang().getId().equals(kh.getId())) {
            redirectAttributes.addFlashAttribute("errorMessage", "Bạn không có quyền truy cập thanh toán đơn hàng này!");
            return "redirect:/orders";
        }

        if ("PAID".equals(order.getTrangThaiThanhToan())) {
            redirectAttributes.addFlashAttribute("successMessage", "Đơn hàng này đã được thanh toán trước đó!");
            return "redirect:/orders/" + orderId;
        }

        model.addAttribute("order", order);
        return "vnpay_gateway";
    }

    @PostMapping("/{orderId}/process")
    public String processPayment(@PathVariable("orderId") Integer orderId,
                                 @RequestParam(value = "bankCode", defaultValue = "NCB") String bankCode,
                                 @RequestParam(value = "cardNumber", required = false) String cardNumber,
                                 @RequestParam(value = "cardHolder", required = false) String cardHolder,
                                 @RequestParam(value = "otp", required = false) String otp,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        KhachHang kh = (KhachHang) session.getAttribute("user");
        if (kh == null) {
            return "redirect:/login?error=login-required";
        }

        DonHang order = donHangService.findById(orderId)
                .orElseThrow(() -> new IllegalArgumentException("Đơn hàng không tồn tại!"));

        if (!order.getKhachHang().getId().equals(kh.getId())) {
            redirectAttributes.addFlashAttribute("errorMessage", "Bạn không có quyền thanh toán đơn này!");
            return "redirect:/orders";
        }

        // Generate realistic VNPAY transaction reference
        String vnpTxn = "14" + (System.currentTimeMillis() % 1000000);
        String bankTranNo = "VNP" + vnpTxn;
        LocalDateTime payTime = LocalDateTime.now();

        // Mark payment as PAID with transaction details
        donHangService.updatePaymentStatus(orderId, "PAID", bankTranNo, payTime);

        // Update order status to CONFIRMED if it was PENDING
        if ("PENDING".equals(order.getTrangThai())) {
            donHangService.updateOrderStatus(orderId, "CONFIRMED");
        }

        return "redirect:/payment/vnpay/result?orderId=" + orderId +
               "&vnp_TransactionNo=" + vnpTxn +
               "&vnp_BankCode=" + (bankCode != null ? bankCode : "NCB") +
               "&vnp_ResponseCode=00";
    }

    @GetMapping("/result")
    public String showPaymentResult(@RequestParam("orderId") Integer orderId,
                                    @RequestParam(value = "vnp_TransactionNo", defaultValue = "") String vnpTransactionNo,
                                    @RequestParam(value = "vnp_BankCode", defaultValue = "NCB") String bankCode,
                                    @RequestParam(value = "vnp_ResponseCode", defaultValue = "00") String responseCode,
                                    HttpSession session,
                                    Model model,
                                    RedirectAttributes redirectAttributes) {
        KhachHang kh = (KhachHang) session.getAttribute("user");
        if (kh == null) {
            return "redirect:/login?error=login-required";
        }

        DonHang order = donHangService.findById(orderId)
                .orElseThrow(() -> new IllegalArgumentException("Đơn hàng không tồn tại!"));

        if (!order.getKhachHang().getId().equals(kh.getId())) {
            redirectAttributes.addFlashAttribute("errorMessage", "Bạn không có quyền xem giao dịch này!");
            return "redirect:/orders";
        }

        model.addAttribute("order", order);
        model.addAttribute("vnpTransactionNo", vnpTransactionNo);
        model.addAttribute("bankCode", bankCode);
        model.addAttribute("isSuccess", "00".equals(responseCode));
        return "payment_result";
    }
}
