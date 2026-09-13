package com.web.app.service;

import org.springframework.stereotype.Service;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Service
public class VietQrService {

    // Default demo shop bank account information
    private final String bankId = "MB"; // MBBank
    private final String accountNo = "0987654321";
    private final String accountName = "SHOP MU THOI TRANG HATS VN";

    public String generateQrUrl(Integer orderId, double amount) {
        long roundedAmount = Math.round(amount);
        String memo = "DH" + orderId;
        String encodedAccountName = URLEncoder.encode(accountName, StandardCharsets.UTF_8);
        String encodedMemo = URLEncoder.encode(memo, StandardCharsets.UTF_8);

        // Standard VietQR QuickLink URL
        return String.format(
                "https://img.vietqr.io/image/%s-%s-compact2.png?amount=%d&addInfo=%s&accountName=%s",
                bankId, accountNo, roundedAmount, encodedMemo, encodedAccountName
        );
    }

    public String getBankId() {
        return bankId;
    }

    public String getAccountNo() {
        return accountNo;
    }

    public String getAccountName() {
        return accountName;
    }
}
