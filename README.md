# HATS.VN - Hệ Thống Website Bán Mũ Thời Trang & Quản Trị Bán Hàng

Chào mừng các bạn thành viên nhóm tham gia dự án **HATS.VN**!  
Tài liệu này hướng dẫn chi tiết từ A đến Z cách cài đặt cơ sở dữ liệu và khởi chạy ứng dụng lần đầu tiên trên máy cá nhân một cách nhanh chóng và chính xác nhất.

---

## 📌 1. Yêu Cầu Môi Trường (Prerequisites)

Trước khi bắt đầu, máy tính của bạn cần cài đặt sẵn các phần mềm sau:
- **Java Development Kit (JDK)**: JDK 21 (khuyến nghị) hoặc JDK 17+.
- **Apache Maven**: Phiên bản 3.8+ (hoặc dùng terminal có lệnh `mvn`).
- **Microsoft SQL Server**: Bản 2016, 2019, 2022 hoặc SQL Server Express (đã bật SQL Server Authentication và giao thức TCP/IP cổng 1433).
- **SQL Server Management Studio (SSMS)** hoặc công cụ quản lý DB tương đương (DBeaver, DataGrip, VS Code mssql extension).
- **Git**: Đã cài đặt Git để clone và quản lý mã nguồn.

---

## 🚀 2. Hướng Dẫn Cài Đặt & Chạy Lần Đầu (Quick Start)

### Bước 1: Clone mã nguồn về máy
Mở Terminal / PowerShell / Git Bash và chạy lệnh:
```bash
git clone https://github.com/TranVy1/testduanTeamVu.git
cd testduanTeamVu
```

---

### Bước 2: Tạo Cơ Sở Dữ Liệu (Restore Database)
Dự án đã đính kèm sẵn toàn bộ cấu trúc bảng và dữ liệu mẫu đầy đủ trong file: **`WebsiteBanMu.sql`** ở ngay thư mục gốc của dự án.

#### Cách 1: Sử dụng SQL Server Management Studio (SSMS) (Khuyến nghị)
1. Mở **SQL Server Management Studio (SSMS)** và đăng nhập vào máy chủ SQL Server của bạn.
2. Nhấn `Ctrl + O` (hoặc vào menu `File -> Open -> File...`) và chọn đến file **`WebsiteBanMu.sql`** trong thư mục dự án.
3. Nhấn nút **Execute** (hoặc phím **`F5`**).
4. Kiểm tra tab Messages bên dưới xuất hiện thông báo:  
   `DATABASE RESTORE COMPLETED SUCCESSFULLY!` là đã hoàn tất!
5. Nhấn chuột phải vào thư mục **Databases** chọn **Refresh**, bạn sẽ thấy CSDL `WebsiteBanMu` với đầy đủ 13 bảng dữ liệu.

#### Cách 2: Sử dụng dòng lệnh `sqlcmd`
Mở Command Prompt hoặc PowerShell tại thư mục dự án và chạy:
```bash
sqlcmd -S localhost -U sa -P 123456 -C -i WebsiteBanMu.sql
```
*(Thay `sa` và `123456` bằng tài khoản SQL Server trên máy của bạn nếu có thay đổi).*

---

### Bước 3: Cấu Hình Kết Nối Database trong Project
Mở file cấu hình:  
📂 `src/main/resources/application.properties`

Kiểm tra và chỉnh sửa lại thông tin tài khoản SQL Server của bạn nếu khác mặc định:
```properties
# Cổng ứng dụng
server.port=8085

# Cấu hình CSDL SQL Server
spring.datasource.url=jdbc:sqlserver://localhost:1433;databaseName=WebsiteBanMu;encrypt=true;trustServerCertificate=true;
spring.datasource.username=sa
spring.datasource.password=123456
spring.datasource.driver-class-name=com.microsoft.sqlserver.jdbc.SQLServerDriver
```
> **Lưu ý**: Nếu mật khẩu SQL Server của bạn khác `123456`, hãy sửa dòng `spring.datasource.password` cho khớp với máy của bạn.

---

### Bước 4: Khởi Chạy Ứng Dụng

Mở Terminal tại thư mục gốc dự án và gõ lệnh:
```bash
mvn clean spring-boot:run
```
Chờ ứng dụng biên dịch và hiển thị dòng chữ:
```
Tomcat initialized with port 8085 (http)
Started AppApplication in ... seconds
```

Truy cập ứng dụng ngay trên trình duyệt:
👉 **http://localhost:8085**

---

## 🔑 3. Danh Sách Tài Khoản Mặc Định Kiểm Thử

Hệ thống đã chuẩn bị sẵn tài khoản quản trị và khách hàng để kiểm thử ngay:

| Vai trò | Tên đăng nhập | Mật khẩu | Đường dẫn truy cập | Quyền hạn chính |
| :--- | :--- | :--- | :--- | :--- |
| **Quản trị viên (Admin)** | `admin` | `123456` | `http://localhost:8085/login` | Toàn quyền quản trị Dashboard, Sản phẩm, Biến thể, Danh mục, Thương hiệu, Voucher, Đơn hàng, Live Chat Admin |
| **Khách hàng 1 (User)** | `user` | `123456` | `http://localhost:8085/login` | Mua hàng, Giỏ hàng, Đặt hàng VietQR/VNPAY/COD, Lịch sử đơn hàng, Đánh giá sản phẩm đã mua |
| **Khách hàng 2 (User)** | `user2` | `123456` | `http://localhost:8085/login` | Mua hàng, Chat trực tiếp với Shop qua widget |

---

## 🌟 4. Các Tính Năng Chính Của Dự Án

### 🛍️ Phía Khách Hàng (Storefront - User)
1. **Giao diện hiện đại Midnight Dark Theme**: Tông màu tối bảo vệ mắt, thiết kế cao cấp, đồng bộ trên toàn bộ các trang.
2. **Bộ lọc sản phẩm thông minh**: Lọc tức thì theo danh mục, thương hiệu, khoảng giá, màu sắc và trạng thái còn hàng.
3. **Chi tiết sản phẩm & biến thể**: Xem hình ảnh, màu sắc/kích cỡ, tồn kho thời gian thực.
4. **Đánh giá & Nhận xét (Verified Buyer Review)**:
   - Khách hàng đã mua sản phẩm có thể chấm sao (1 - 5 sao) và nhận xét chi tiết.
   - Hiển thị sao trung bình, tổng lượt đánh giá, huy hiệu "Đã mua hàng".
5. **Thanh toán đa cổng (Fintech Gateway)**:
   - **VietQR Napas 247**: Tự động sinh mã QR ngân hàng chuẩn VietQR kèm mã đơn và số tiền chính xác, đếm ngược thời gian và sao chép nhanh số tài khoản.
   - **VNPAY**: Tích hợp cổng thanh toán trực tuyến.
   - **COD**: Thanh toán tiền mặt khi nhận hàng.
   - **Áp dụng Mã giảm giá (Voucher)**: Kiểm tra điều kiện đơn hàng tối thiểu và giảm giá trực tiếp.
6. **Lịch sử đơn hàng & Chi tiết**:
   - Phân trang lịch sử đơn hàng mượt mà.
   - Theo dõi tiến trình giao hàng trực quan (Timeline: Chờ xử lý -> Đã xác nhận -> Đang giao -> Đã giao).
   - Hủy đơn hàng tự động khi đơn còn ở trạng thái "Chờ xử lý".
7. **Hỗ trợ trao đổi trực tuyến (Live Chat Widget)**:
   - Chatbot tự động trả lời tức thì các câu hỏi thường gặp (Chọn size, Phí ship, Đổi trả).
   - Gặp nhân viên tư vấn: Kết nối trò chuyện trực tiếp với Admin thời gian thực.

---

### 🛡️ Phía Quản Trị Viên (Admin Dashboard)
1. **Bảng điều khiển (Dashboard)**: Thống kê doanh thu, đơn hàng, khách hàng và danh sách đơn mới nhất.
2. **Quản lý sản phẩm & biến thể**: Thêm mới, chỉnh sửa, xóa mềm, tải ảnh lên (`uploads/`), thiết lập từng biến thể (Màu sắc, kích cỡ, SKU, số lượng, giá riêng).
3. **Quản lý danh mục & thương hiệu**: Thêm nhanh, sửa tên và quản lý phân loại sản phẩm.
4. **Quản lý khuyến mãi (Voucher)**: Cấu hình mã giảm theo phần trăm hoặc số tiền cố định, giá trị giảm tối đa, ngày bắt đầu và kết thúc.
5. **Quản lý đơn hàng**:
   - Cập nhật trạng thái đơn (Chờ xử lý -> Đã xác nhận -> Đang giao -> Hoàn thành / Hủy).
   - Xem chi tiết đơn hàng, thông tin người nhận, biên lai điện tử đối soát Napas.
   - In hóa đơn bán hàng chuyên nghiệp (`/orders/{id}/invoice`).
   - Xuất dữ liệu danh sách đơn hàng ra file Excel.
6. **Trung tâm Tin nhắn & Chăm sóc khách hàng (`/admin/chat`)**:
   - Quản lý danh sách các cuộc hội thoại với khách hàng.
   - Trả lời tin nhắn trực tiếp theo thời gian thực (WebSocket).
   - Nhắn tin nhanh bằng các mẫu phản hồi có sẵn.

---

## 📂 5. Cấu Trúc Thư Mục Dự Án (Project Directory Structure)

```text
Duan/
├── WebsiteBanMu.sql                    # File Script Backup Database đầy đủ (DDL + DML)
├── pom.xml                             # Cấu hình phụ thuộc Maven
├── README.md                           # Tài liệu hướng dẫn dự án
├── src/
│   ├── main/
│   │   ├── java/com/web/app/
│   │   │   ├── controller/             # Các Controller điều hướng (Admin, Auth, Cart, Chat, Customer, Vnpay...)
│   │   │   ├── dto/                    # Data Transfer Objects (Chat, DTOs)
│   │   │   ├── interceptor/            # Phân quyền & chặn truy cập người dùng / admin
│   │   │   ├── model/                  # Các JPA Entity (13 bảng)
│   │   │   ├── repository/             # Các Spring Data JPA Repositories
│   │   │   ├── service/                # Business Logic Services
│   │   │   └── util/                   # Tiện ích mã hóa mật khẩu, kiểm tra hợp lệ, upload ảnh...
│   │   └── resources/
│   │       ├── application.properties  # Cấu hình kết nối DB & Spring Boot
│   │       ├── static/                 # Tài nguyên tĩnh (CSS Midnight theme, JS, Images)
│   │       └── templates/              # Giao diện Thymeleaf HTML
│   │           ├── admin/              # Giao diện quản trị Admin
│   │           ├── fragments/          # Header, Footer, Chat Widget...
│   │           └── ...                 # Trang chủ, Chi tiết sản phẩm, Giỏ hàng, Đơn hàng...
```

---

## 🛠️ 6. Xử Lý Các Sự Cố Thường Gặp (Troubleshooting)

1. **Lỗi: `Cannot open database "WebsiteBanMu" requested by the login`**  
   👉 **Khắc phục**: Bạn chưa thực thi file `WebsiteBanMu.sql`. Hãy mở SSMS và chạy file này trước khi khởi động ứng dụng.

2. **Lỗi: `The TCP/IP connection to the host localhost, port 1433 has failed`**  
   👉 **Khắc phục**: 
   - Mở **SQL Server Configuration Manager** trên Windows.
   - Tìm mục **SQL Server Network Configuration -> Protocols for MSSQLSERVER**.
   - Chuột phải vào **TCP/IP** chọn **Enable**.
   - Vào **SQL Server Services**, chuột phải vào SQL Server và chọn **Restart**.

3. **Lỗi cổng 8085 đã bị chiếm dụng (`Port 8085 was already in use`)**  
   👉 **Khắc phục**: 
   - Mở file `src/main/resources/application.properties`.
   - Đổi `server.port=8085` thành cổng khác (ví dụ `server.port=8086`).
   - Truy cập theo cổng mới: `http://localhost:8086`.

---
*Chúc các bạn trong nhóm phối hợp làm việc hiệu quả và phát triển thêm nhiều tính năng xuất sắc! 🎉*
