package com.web.app.service;

import com.web.app.model.DonHang;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.io.OutputStream;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
public class ExcelExportService {

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    public void exportOrdersToExcel(List<DonHang> orders, OutputStream outputStream) throws IOException {
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Danh Sách Đơn Hàng");

            // Fonts
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerFont.setColor(IndexedColors.WHITE.getIndex());
            headerFont.setFontHeightInPoints((short) 11);

            Font titleFont = workbook.createFont();
            titleFont.setBold(true);
            titleFont.setFontHeightInPoints((short) 16);
            titleFont.setColor(IndexedColors.DARK_BLUE.getIndex());

            Font boldFont = workbook.createFont();
            boldFont.setBold(true);

            // Styles
            CellStyle titleStyle = workbook.createCellStyle();
            titleStyle.setFont(titleFont);
            titleStyle.setAlignment(HorizontalAlignment.CENTER);

            CellStyle headerStyle = workbook.createCellStyle();
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(IndexedColors.ROYAL_BLUE.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerStyle.setAlignment(HorizontalAlignment.CENTER);
            headerStyle.setVerticalAlignment(VerticalAlignment.CENTER);
            setBorders(headerStyle);

            CellStyle dataStyle = workbook.createCellStyle();
            dataStyle.setVerticalAlignment(VerticalAlignment.CENTER);
            setBorders(dataStyle);

            CellStyle centerDataStyle = workbook.createCellStyle();
            centerDataStyle.setAlignment(HorizontalAlignment.CENTER);
            centerDataStyle.setVerticalAlignment(VerticalAlignment.CENTER);
            setBorders(centerDataStyle);

            CellStyle currencyStyle = workbook.createCellStyle();
            DataFormat format = workbook.createDataFormat();
            currencyStyle.setDataFormat(format.getFormat("#,##0 ₫"));
            currencyStyle.setAlignment(HorizontalAlignment.RIGHT);
            currencyStyle.setVerticalAlignment(VerticalAlignment.CENTER);
            setBorders(currencyStyle);

            CellStyle summaryStyle = workbook.createCellStyle();
            summaryStyle.setFont(boldFont);
            summaryStyle.setDataFormat(format.getFormat("#,##0 ₫"));
            summaryStyle.setAlignment(HorizontalAlignment.RIGHT);
            summaryStyle.setVerticalAlignment(VerticalAlignment.CENTER);
            summaryStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            summaryStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            setBorders(summaryStyle);

            CellStyle summaryLabelStyle = workbook.createCellStyle();
            summaryLabelStyle.setFont(boldFont);
            summaryLabelStyle.setAlignment(HorizontalAlignment.CENTER);
            summaryLabelStyle.setVerticalAlignment(VerticalAlignment.CENTER);
            summaryLabelStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            summaryLabelStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            setBorders(summaryLabelStyle);

            // Title Row
            Row titleRow = sheet.createRow(0);
            titleRow.setHeightInPoints(30);
            Cell titleCell = titleRow.createCell(0);
            titleCell.setCellValue("HỆ THỐNG MŨ THỜI TRANG HATS.VN - BÁO CÁO DOANH THU ĐƠN HÀNG");
            titleCell.setCellStyle(titleStyle);
            sheet.addMergedRegion(new org.apache.poi.ss.util.CellRangeAddress(0, 0, 0, 9));

            // Subtitle
            Row subTitleRow = sheet.createRow(1);
            Cell subTitleCell = subTitleRow.createCell(0);
            subTitleCell.setCellValue("Ngày xuất: " + java.time.LocalDateTime.now().format(DATE_FORMATTER) + " | Tổng số đơn: " + orders.size());
            sheet.addMergedRegion(new org.apache.poi.ss.util.CellRangeAddress(1, 1, 0, 9));

            // Blank row
            sheet.createRow(2);

            // Headers
            String[] headers = {
                    "Mã ĐH", "Ngày Đặt", "Người Nhận", "Số Điện Thoại",
                    "Địa Chỉ Giao Hàng", "Phương Thức TT", "Trạng Thái TT",
                    "Trạng Thái Đơn", "Mã Giảm Giá", "Tổng Tiền (VNĐ)"
            };

            Row headerRow = sheet.createRow(3);
            headerRow.setHeightInPoints(26);
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            // Data Rows
            int rowIdx = 4;
            double totalRevenue = 0.0;

            for (DonHang order : orders) {
                Row row = sheet.createRow(rowIdx++);
                row.setHeightInPoints(20);

                // Col 0: Mã ĐH
                Cell c0 = row.createCell(0);
                c0.setCellValue("#DH" + order.getId());
                c0.setCellStyle(centerDataStyle);

                // Col 1: Ngày Đặt
                Cell c1 = row.createCell(1);
                c1.setCellValue(order.getNgayDat() != null ? order.getNgayDat().format(DATE_FORMATTER) : "");
                c1.setCellStyle(centerDataStyle);

                // Col 2: Người Nhận
                Cell c2 = row.createCell(2);
                c2.setCellValue(order.getHoTenNhan() != null ? order.getHoTenNhan() : "");
                c2.setCellStyle(dataStyle);

                // Col 3: Số Điện Thoại
                Cell c3 = row.createCell(3);
                c3.setCellValue(order.getSoDienThoaiNhan() != null ? order.getSoDienThoaiNhan() : "");
                c3.setCellStyle(centerDataStyle);

                // Col 4: Địa Chỉ
                Cell c4 = row.createCell(4);
                c4.setCellValue(order.getDiaChiNhan() != null ? order.getDiaChiNhan() : "");
                c4.setCellStyle(dataStyle);

                // Col 5: Phương Thức TT
                Cell c5 = row.createCell(5);
                String pt = order.getPhuongThucThanhToan();
                String ptLabel = "COD".equalsIgnoreCase(pt) ? "Thanh toán khi nhận (COD)"
                        : "VIETQR".equalsIgnoreCase(pt) ? "Chuyển khoản VietQR"
                        : "VNPAY".equalsIgnoreCase(pt) ? "Cổng VNPAY" : (pt != null ? pt : "COD");
                c5.setCellValue(ptLabel);
                c5.setCellStyle(centerDataStyle);

                // Col 6: Trạng Thái TT
                Cell c6 = row.createCell(6);
                String tt = "PAID".equalsIgnoreCase(order.getTrangThaiThanhToan()) ? "Đã thanh toán" : "Chưa thanh toán";
                c6.setCellValue(tt);
                c6.setCellStyle(centerDataStyle);

                // Col 7: Trạng Thái Đơn
                Cell c7 = row.createCell(7);
                String statusLabel = switch (order.getTrangThai() != null ? order.getTrangThai() : "") {
                    case "PENDING" -> "Chờ xử lý";
                    case "CONFIRMED" -> "Đã xác nhận";
                    case "SHIPPING" -> "Đang giao";
                    case "DELIVERED" -> "Đã hoàn thành";
                    case "CANCELLED" -> "Đã hủy";
                    default -> order.getTrangThai();
                };
                c7.setCellValue(statusLabel);
                c7.setCellStyle(centerDataStyle);

                // Col 8: Mã Giảm Giá
                Cell c8 = row.createCell(8);
                c8.setCellValue(order.getKhuyenMai() != null ? order.getKhuyenMai().getMaCode() : "-");
                c8.setCellStyle(centerDataStyle);

                // Col 9: Tổng Tiền
                Cell c9 = row.createCell(9);
                double amount = order.getTongTien() != null ? order.getTongTien() : 0.0;
                c9.setCellValue(amount);
                c9.setCellStyle(currencyStyle);

                if (!"CANCELLED".equalsIgnoreCase(order.getTrangThai())) {
                    totalRevenue += amount;
                }
            }

            // Summary Row
            Row summaryRow = sheet.createRow(rowIdx);
            summaryRow.setHeightInPoints(24);
            Cell sumLabel = summaryRow.createCell(0);
            sumLabel.setCellValue("TỔNG DOANH THU THỰC TẾ (Không tính đơn hủy):");
            sumLabel.setCellStyle(summaryLabelStyle);
            sheet.addMergedRegion(new org.apache.poi.ss.util.CellRangeAddress(rowIdx, rowIdx, 0, 8));

            for (int i = 1; i <= 8; i++) {
                Cell emptyCell = summaryRow.createCell(i);
                emptyCell.setCellStyle(summaryLabelStyle);
            }

            Cell sumVal = summaryRow.createCell(9);
            sumVal.setCellValue(totalRevenue);
            sumVal.setCellStyle(summaryStyle);

            // Auto-size columns
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
                // Extra margin
                sheet.setColumnWidth(i, Math.max(sheet.getColumnWidth(i) + 1200, 3000));
            }

            workbook.write(outputStream);
        }
    }

    private void setBorders(CellStyle style) {
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        style.setTopBorderColor(IndexedColors.GREY_40_PERCENT.getIndex());
        style.setBottomBorderColor(IndexedColors.GREY_40_PERCENT.getIndex());
        style.setLeftBorderColor(IndexedColors.GREY_40_PERCENT.getIndex());
        style.setRightBorderColor(IndexedColors.GREY_40_PERCENT.getIndex());
    }
}
