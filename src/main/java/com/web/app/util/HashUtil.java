package com.web.app.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class HashUtil {

    private static final BCryptPasswordEncoder BCRYPT = new BCryptPasswordEncoder();

    public static String hashPassword(String password) {
        if (password == null) {
            return null;
        }
        return BCRYPT.encode(password);
    }

    public static boolean verifyPassword(String rawPassword, String hashedPassword) {
        if (rawPassword == null || hashedPassword == null) {
            return false;
        }

        // If password is stored as BCrypt hash (starts with $2a$, $2b$, or $2y$)
        if (hashedPassword.startsWith("$2a$") || hashedPassword.startsWith("$2b$") || hashedPassword.startsWith("$2y$")) {
            return BCRYPT.matches(rawPassword, hashedPassword);
        }

        // Backward compatibility fallback for legacy SHA-256 hashes
        String sha256 = legacySha256(rawPassword);
        return sha256.equalsIgnoreCase(hashedPassword);
    }

    private static String legacySha256(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }
}
