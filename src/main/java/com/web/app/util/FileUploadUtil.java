package com.web.app.util;

import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

public class FileUploadUtil {

    private static final String UPLOAD_DIR = "uploads";
    private static final List<String> ALLOWED_EXTENSIONS = Arrays.asList(".jpg", ".jpeg", ".png", ".webp");
    private static final List<String> ALLOWED_MIME_TYPES = Arrays.asList("image/jpeg", "image/png", "image/webp");
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB

    public static String saveImage(MultipartFile file) throws IOException {
        if (file == null || file.isEmpty()) {
            return null;
        }

        if (file.getSize() > MAX_FILE_SIZE) {
            throw new IllegalArgumentException("Dung lượng tệp ảnh không được vượt quá 5MB!");
        }

        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null || originalFilename.isBlank()) {
            throw new IllegalArgumentException("Tên tệp tin không hợp lệ!");
        }

        // Validate extension
        String lowerFilename = originalFilename.toLowerCase();
        String extension = "";
        int extIndex = lowerFilename.lastIndexOf('.');
        if (extIndex > 0) {
            extension = lowerFilename.substring(extIndex);
        }

        if (!ALLOWED_EXTENSIONS.contains(extension)) {
            throw new IllegalArgumentException("Chỉ chấp nhận các tệp ảnh định dạng JPG, JPEG, PNG, WEBP!");
        }

        // Validate MIME type
        String contentType = file.getContentType();
        if (contentType == null || !ALLOWED_MIME_TYPES.contains(contentType.toLowerCase())) {
            throw new IllegalArgumentException("Định dạng tệp không phải là hình ảnh hợp lệ!");
        }

        // Generate safe unique filename to prevent path traversal and collisions
        String safeFileName = UUID.randomUUID().toString() + extension;
        Path uploadPath = Paths.get(UPLOAD_DIR);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        Path targetPath = uploadPath.resolve(safeFileName).normalize();
        if (!targetPath.startsWith(uploadPath)) {
            throw new IllegalArgumentException("Đường dẫn lưu tệp không an toàn!");
        }

        Files.copy(file.getInputStream(), targetPath, StandardCopyOption.REPLACE_EXISTING);
        return safeFileName;
    }

    public static void deleteImage(String fileName) {
        if (fileName == null || fileName.isBlank() || fileName.startsWith("http")) {
            return;
        }
        try {
            Path filePath = Paths.get(UPLOAD_DIR).resolve(fileName).normalize();
            if (filePath.startsWith(Paths.get(UPLOAD_DIR))) {
                Files.deleteIfExists(filePath);
            }
        } catch (IOException ignored) {
        }
    }
}
