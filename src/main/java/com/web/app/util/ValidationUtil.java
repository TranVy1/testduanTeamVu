package com.web.app.util;

import java.util.regex.Pattern;

public class ValidationUtil {

    // Vietnamese standard 10-digit mobile phone pattern: 03x, 05x, 07x, 08x, 09x
    private static final Pattern PHONE_PATTERN = Pattern.compile("^0[35789][0-9]{8}$");

    // Vietnamese name pattern: letters, spaces, hyphens, apostrophes (at least 2 characters)
    private static final Pattern NAME_PATTERN = Pattern.compile("^[\\p{L}\\s\\.\\-\\']{2,100}$");

    // Email pattern
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$");

    public static boolean isValidPhone(String phone) {
        if (phone == null) return false;
        String clean = phone.trim().replaceAll("[\\s\\-\\.]", "");
        return PHONE_PATTERN.matcher(clean).matches();
    }

    public static boolean isValidFullName(String name) {
        if (name == null) return false;
        String trimmed = name.trim();
        return trimmed.length() >= 2 && trimmed.length() <= 100 && NAME_PATTERN.matcher(trimmed).matches();
    }

    public static boolean isValidAddress(String address) {
        if (address == null) return false;
        String trimmed = address.trim();
        return trimmed.length() >= 8 && trimmed.length() <= 255;
    }

    public static boolean isValidEmail(String email) {
        if (email == null || email.isBlank()) return true; // optional
        return EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    public static void validateRecipientInfo(String hoTenNhan, String soDienThoaiNhan, String diaChiNhan) {
        if (hoTenNhan == null || !isValidFullName(hoTenNhan)) {
            throw new IllegalArgumentException("Họ tên người nhận không hợp lệ! Vui lòng nhập họ tên từ 2 ký tự và không chứa số/ký tự đặc biệt.");
        }
        if (soDienThoaiNhan == null || !isValidPhone(soDienThoaiNhan)) {
            throw new IllegalArgumentException("Số điện thoại không hợp lệ! Vui lòng nhập đúng số điện thoại di động Việt Nam (10 chữ số, bắt đầu bằng 03, 05, 07, 08, 09).");
        }
        if (diaChiNhan == null || !isValidAddress(diaChiNhan)) {
            throw new IllegalArgumentException("Địa chỉ nhận hàng quá ngắn! Vui lòng nhập địa chỉ cụ thể (tối thiểu 8 ký tự, gồm số nhà, tên đường, phường/xã, quận/huyện).");
        }
    }
}
