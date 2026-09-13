-- ==========================================================
-- DATABASE BACKUP / RESTORE SCRIPT: WebsiteBanMu
-- Há»‡ Thá»‘ng Website BÃ¡n MÅ© Thá»i Trang HATS.VN
-- NgÃ y táº¡o: 2026-09-13 17:02:26
-- ==========================================================

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'WebsiteBanMu')
BEGIN
    CREATE DATABASE [WebsiteBanMu];
END
GO

USE [WebsiteBanMu];
GO

-- ----------------------------------------------------------
-- Table: danh_muc
-- ----------------------------------------------------------
IF OBJECT_ID(N'[dbo].[danh_muc]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[danh_muc] (
    [id] int IDENTITY(1,1) NOT NULL,
    [mo_ta] nvarchar(255) NULL,
    [ten_danh_muc] nvarchar(100) NULL,
    CONSTRAINT [PK_danh_muc] PRIMARY KEY CLUSTERED ([id])
    );
END
GO

-- ----------------------------------------------------------
-- Table: thuong_hieu
-- ----------------------------------------------------------
IF OBJECT_ID(N'[dbo].[thuong_hieu]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[thuong_hieu] (
    [id] int IDENTITY(1,1) NOT NULL,
    [mo_ta] nvarchar(255) NULL,
    [ten_thuong_hieu] nvarchar(100) NULL,
    CONSTRAINT [PK_thuong_hieu] PRIMARY KEY CLUSTERED ([id])
    );
END
GO

-- ----------------------------------------------------------
-- Table: ma_giam_gia
-- ----------------------------------------------------------
IF OBJECT_ID(N'[dbo].[ma_giam_gia]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[ma_giam_gia] (
    [id] int IDENTITY(1,1) NOT NULL,
    [gia_tri_giam] float NOT NULL,
    [gia_tri_giam_toi_da] float NULL,
    [gia_tri_toi_thieu] float NULL,
    [loai_giam_gia] varchar(50) NOT NULL,
    [ma_code] varchar(50) NOT NULL,
    [ngay_bat_dau] datetime2 NULL,
    [ngay_ket_thuc] datetime2 NULL,
    [so_luong] int NULL,
    [so_luong_da_dung] int NULL,
    [ten_khuyen_mai] nvarchar(255) NULL,
    [trang_thai] bit NULL,
    CONSTRAINT [PK_ma_giam_gia] PRIMARY KEY CLUSTERED ([id])
    );
END
GO

-- ----------------------------------------------------------
-- Table: tai_khoan
-- ----------------------------------------------------------
IF OBJECT_ID(N'[dbo].[tai_khoan]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[tai_khoan] (
    [id] int IDENTITY(1,1) NOT NULL,
    [mat_khau] varchar(255) NOT NULL,
    [ten_dang_nhap] varchar(50) NOT NULL,
    [trang_thai] varchar(20) NOT NULL,
    [vai_tro] varchar(20) NOT NULL,
    CONSTRAINT [PK_tai_khoan] PRIMARY KEY CLUSTERED ([id])
    );
END
GO

-- ----------------------------------------------------------
-- Table: khach_hang
-- ----------------------------------------------------------
IF OBJECT_ID(N'[dbo].[khach_hang]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[khach_hang] (
    [id] int IDENTITY(1,1) NOT NULL,
    [dia_chi] nvarchar(255) NULL,
    [email] varchar(100) NULL,
    [ho_ten] nvarchar(100) NULL,
    [so_dien_thoai] varchar(15) NULL,
    [tai_khoan_id] int NULL,
    CONSTRAINT [PK_khach_hang] PRIMARY KEY CLUSTERED ([id])
    );
END
GO

-- ----------------------------------------------------------
-- Table: gio_hang
-- ----------------------------------------------------------
IF OBJECT_ID(N'[dbo].[gio_hang]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[gio_hang] (
    [id] int IDENTITY(1,1) NOT NULL,
    [ngay_tao] datetime2 NULL,
    [khach_hang_id] int NULL,
    CONSTRAINT [PK_gio_hang] PRIMARY KEY CLUSTERED ([id])
    );
END
GO

-- ----------------------------------------------------------
-- Table: san_pham
-- ----------------------------------------------------------
IF OBJECT_ID(N'[dbo].[san_pham]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[san_pham] (
    [id] int IDENTITY(1,1) NOT NULL,
    [anh_url] varchar(255) NULL,
    [gia] float NOT NULL,
    [mo_ta] nvarchar(MAX) NULL,
    [ngay_tao] datetime2 NULL,
    [so_luong] int NOT NULL,
    [ten_san_pham] nvarchar(150) NULL,
    [danh_muc_id] int NULL,
    [thuong_hieu_id] int NULL,
    CONSTRAINT [PK_san_pham] PRIMARY KEY CLUSTERED ([id])
    );
END
GO

-- ----------------------------------------------------------
-- Table: bien_the_san_pham
-- ----------------------------------------------------------
IF OBJECT_ID(N'[dbo].[bien_the_san_pham]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[bien_the_san_pham] (
    [id] int IDENTITY(1,1) NOT NULL,
    [gia] float NOT NULL,
    [kich_co] nvarchar(30) NOT NULL,
    [mau_sac] nvarchar(50) NOT NULL,
    [sku] varchar(80) NULL,
    [so_luong] int NOT NULL,
    [san_pham_id] int NOT NULL,
    CONSTRAINT [PK_bien_the_san_pham] PRIMARY KEY CLUSTERED ([id])
    );
END
GO

-- ----------------------------------------------------------
-- Table: chi_tiet_gio_hang
-- ----------------------------------------------------------
IF OBJECT_ID(N'[dbo].[chi_tiet_gio_hang]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[chi_tiet_gio_hang] (
    [id] int IDENTITY(1,1) NOT NULL,
    [so_luong] int NOT NULL,
    [bien_the_id] int NULL,
    [gio_hang_id] int NOT NULL,
    [san_pham_id] int NOT NULL,
    CONSTRAINT [PK_chi_tiet_gio_hang] PRIMARY KEY CLUSTERED ([id])
    );
END
GO

-- ----------------------------------------------------------
-- Table: don_hang
-- ----------------------------------------------------------
IF OBJECT_ID(N'[dbo].[don_hang]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[don_hang] (
    [id] int IDENTITY(1,1) NOT NULL,
    [dia_chi_nhan] nvarchar(255) NOT NULL,
    [ghi_chu] nvarchar(255) NULL,
    [ho_ten_nhan] nvarchar(100) NULL,
    [ngay_dat] datetime2 NULL,
    [so_dien_thoai_nhan] varchar(15) NOT NULL,
    [so_tien_giam] float NULL,
    [tong_tien] float NOT NULL,
    [trang_thai] varchar(50) NOT NULL,
    [khach_hang_id] int NULL,
    [khuyen_mai_id] int NULL,
    [phuong_thuc_thanh_toan] varchar(30) NULL,
    [trang_thai_thanh_toan] varchar(30) NULL,
    [ma_giao_dich] varchar(100) NULL,
    [ngay_thanh_toan] datetime2 NULL,
    CONSTRAINT [PK_don_hang] PRIMARY KEY CLUSTERED ([id])
    );
END
GO

-- ----------------------------------------------------------
-- Table: chi_tiet_don_hang
-- ----------------------------------------------------------
IF OBJECT_ID(N'[dbo].[chi_tiet_don_hang]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[chi_tiet_don_hang] (
    [id] int IDENTITY(1,1) NOT NULL,
    [gia_ban] float NOT NULL,
    [so_luong] int NOT NULL,
    [bien_the_id] int NULL,
    [don_hang_id] int NOT NULL,
    [san_pham_id] int NOT NULL,
    CONSTRAINT [PK_chi_tiet_don_hang] PRIMARY KEY CLUSTERED ([id])
    );
END
GO

-- ----------------------------------------------------------
-- Table: danh_gia_san_pham
-- ----------------------------------------------------------
IF OBJECT_ID(N'[dbo].[danh_gia_san_pham]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[danh_gia_san_pham] (
    [id] int IDENTITY(1,1) NOT NULL,
    [ngay_tao] datetime2 NULL,
    [noi_dung] nvarchar(MAX) NULL,
    [so_sao] int NOT NULL,
    [khach_hang_id] int NOT NULL,
    [san_pham_id] int NOT NULL,
    CONSTRAINT [PK_danh_gia_san_pham] PRIMARY KEY CLUSTERED ([id])
    );
END
GO

-- ----------------------------------------------------------
-- Table: tin_nhan
-- ----------------------------------------------------------
IF OBJECT_ID(N'[dbo].[tin_nhan]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[tin_nhan] (
    [id] int IDENTITY(1,1) NOT NULL,
    [da_doc] bit NOT NULL,
    [noi_dung] nvarchar(MAX) NULL,
    [sender_name] varchar(100) NULL,
    [sender_role] varchar(20) NOT NULL,
    [session_guest_id] varchar(100) NULL,
    [thoi_gian] datetime2 NOT NULL,
    [khach_hang_id] int NULL,
    CONSTRAINT [PK_tin_nhan] PRIMARY KEY CLUSTERED ([id])
    );
END
GO

-- ----------------------------------------------------------
-- Foreign Keys
-- ----------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK3qitk7g9111a7sr03e4546yud')
BEGIN
    ALTER TABLE [dbo].[bien_the_san_pham] WITH CHECK ADD CONSTRAINT [FK3qitk7g9111a7sr03e4546yud] FOREIGN KEY ([san_pham_id]) REFERENCES [dbo].[san_pham] ([id]);
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FKnlr5jpmfbvgad2w40cqo54mwg')
BEGIN
    ALTER TABLE [dbo].[chi_tiet_don_hang] WITH CHECK ADD CONSTRAINT [FKnlr5jpmfbvgad2w40cqo54mwg] FOREIGN KEY ([san_pham_id]) REFERENCES [dbo].[san_pham] ([id]);
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FKt57maavf6s28hxyar724mdr1b')
BEGIN
    ALTER TABLE [dbo].[chi_tiet_don_hang] WITH CHECK ADD CONSTRAINT [FKt57maavf6s28hxyar724mdr1b] FOREIGN KEY ([don_hang_id]) REFERENCES [dbo].[don_hang] ([id]);
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FKp0ftrmotnluuqb55cxspov2ck')
BEGIN
    ALTER TABLE [dbo].[chi_tiet_don_hang] WITH CHECK ADD CONSTRAINT [FKp0ftrmotnluuqb55cxspov2ck] FOREIGN KEY ([bien_the_id]) REFERENCES [dbo].[bien_the_san_pham] ([id]);
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK96up5s55hovemhuf3uj3d7qgq')
BEGIN
    ALTER TABLE [dbo].[chi_tiet_gio_hang] WITH CHECK ADD CONSTRAINT [FK96up5s55hovemhuf3uj3d7qgq] FOREIGN KEY ([bien_the_id]) REFERENCES [dbo].[bien_the_san_pham] ([id]);
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK5e5jfe401gg179es4akmlg2u9')
BEGIN
    ALTER TABLE [dbo].[chi_tiet_gio_hang] WITH CHECK ADD CONSTRAINT [FK5e5jfe401gg179es4akmlg2u9] FOREIGN KEY ([gio_hang_id]) REFERENCES [dbo].[gio_hang] ([id]);
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FKt07ttsgensh9pe6v04e71y4q5')
BEGIN
    ALTER TABLE [dbo].[chi_tiet_gio_hang] WITH CHECK ADD CONSTRAINT [FKt07ttsgensh9pe6v04e71y4q5] FOREIGN KEY ([san_pham_id]) REFERENCES [dbo].[san_pham] ([id]);
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FKiqj0127ers93u2lqt8l6x2x7a')
BEGIN
    ALTER TABLE [dbo].[danh_gia_san_pham] WITH CHECK ADD CONSTRAINT [FKiqj0127ers93u2lqt8l6x2x7a] FOREIGN KEY ([san_pham_id]) REFERENCES [dbo].[san_pham] ([id]);
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FKontig9eenpc2861rdjxg8yn8l')
BEGIN
    ALTER TABLE [dbo].[danh_gia_san_pham] WITH CHECK ADD CONSTRAINT [FKontig9eenpc2861rdjxg8yn8l] FOREIGN KEY ([khach_hang_id]) REFERENCES [dbo].[khach_hang] ([id]);
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FKeyporccvr9mq4k9j4fc5wpum5')
BEGIN
    ALTER TABLE [dbo].[don_hang] WITH CHECK ADD CONSTRAINT [FKeyporccvr9mq4k9j4fc5wpum5] FOREIGN KEY ([khach_hang_id]) REFERENCES [dbo].[khach_hang] ([id]);
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FKsthvimh7ve6akabgj695jc6yt')
BEGIN
    ALTER TABLE [dbo].[don_hang] WITH CHECK ADD CONSTRAINT [FKsthvimh7ve6akabgj695jc6yt] FOREIGN KEY ([khuyen_mai_id]) REFERENCES [dbo].[ma_giam_gia] ([id]);
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FKtfg3dplbmn3wiwy26si1daye3')
BEGIN
    ALTER TABLE [dbo].[gio_hang] WITH CHECK ADD CONSTRAINT [FKtfg3dplbmn3wiwy26si1daye3] FOREIGN KEY ([khach_hang_id]) REFERENCES [dbo].[khach_hang] ([id]);
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FKjdwuhrypcrkgwync42t2fn2jw')
BEGIN
    ALTER TABLE [dbo].[khach_hang] WITH CHECK ADD CONSTRAINT [FKjdwuhrypcrkgwync42t2fn2jw] FOREIGN KEY ([tai_khoan_id]) REFERENCES [dbo].[tai_khoan] ([id]);
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FKrum92qs4m7i0u7p7ub6bhbrr5')
BEGIN
    ALTER TABLE [dbo].[san_pham] WITH CHECK ADD CONSTRAINT [FKrum92qs4m7i0u7p7ub6bhbrr5] FOREIGN KEY ([thuong_hieu_id]) REFERENCES [dbo].[thuong_hieu] ([id]);
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FKmnhsdc3pdlvp4pkronxu5hasp')
BEGIN
    ALTER TABLE [dbo].[san_pham] WITH CHECK ADD CONSTRAINT [FKmnhsdc3pdlvp4pkronxu5hasp] FOREIGN KEY ([danh_muc_id]) REFERENCES [dbo].[danh_muc] ([id]);
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FKt5fvrouoek42gb39c5uoqyf4w')
BEGIN
    ALTER TABLE [dbo].[tin_nhan] WITH CHECK ADD CONSTRAINT [FKt5fvrouoek42gb39c5uoqyf4w] FOREIGN KEY ([khach_hang_id]) REFERENCES [dbo].[khach_hang] ([id]);
END
GO

-- ----------------------------------------------------------
-- Disable Constraints for Safe Data Seeding
-- ----------------------------------------------------------
EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';
GO

-- Data for table: danh_muc (4 rows)
SET IDENTITY_INSERT [dbo].[danh_muc] ON;
INSERT INTO [dbo].[danh_muc] ([id], [mo_ta], [ten_danh_muc]) VALUES (1, N'Mũ lưỡi trai phong cách trẻ trung, năng động', N'Mũ Lưỡi Trai');
INSERT INTO [dbo].[danh_muc] ([id], [mo_ta], [ten_danh_muc]) VALUES (2, N'Mũ Snapback cá tính, đậm chất streetwear', N'Mũ Snapback');
INSERT INTO [dbo].[danh_muc] ([id], [mo_ta], [ten_danh_muc]) VALUES (3, N'Mũ bucket thời trang, tiện lợi khi đi chơi dã ngoại', N'Mũ Bucket (Tai bèo)');
INSERT INTO [dbo].[danh_muc] ([id], [mo_ta], [ten_danh_muc]) VALUES (4, N'Mũ len ấm áp cho mùa đông', N'Mũ Len (Beanie)');
SET IDENTITY_INSERT [dbo].[danh_muc] OFF;
GO

-- Data for table: thuong_hieu (5 rows)
SET IDENTITY_INSERT [dbo].[thuong_hieu] ON;
INSERT INTO [dbo].[thuong_hieu] ([id], [mo_ta], [ten_thuong_hieu]) VALUES (1, N'Thương hiệu thể thao hàng đầu thế giới', N'Nike');
INSERT INTO [dbo].[thuong_hieu] ([id], [mo_ta], [ten_thuong_hieu]) VALUES (2, N'Thương hiệu phong cách thể thao ba sọc cổ điển', N'Adidas');
INSERT INTO [dbo].[thuong_hieu] ([id], [mo_ta], [ten_thuong_hieu]) VALUES (3, N'Thương hiệu thời trang bóng chày Hàn Quốc cực hot', N'MLB');
INSERT INTO [dbo].[thuong_hieu] ([id], [mo_ta], [ten_thuong_hieu]) VALUES (4, N'Thương hiệu mũ snapback và lưỡi trai huyền thoại', N'New Era');
INSERT INTO [dbo].[thuong_hieu] ([id], [mo_ta], [ten_thuong_hieu]) VALUES (5, N'Thương hiệu thời trang thể thao năng động', N'Puma');
SET IDENTITY_INSERT [dbo].[thuong_hieu] OFF;
GO

-- Data for table: ma_giam_gia (1 rows)
SET IDENTITY_INSERT [dbo].[ma_giam_gia] ON;
INSERT INTO [dbo].[ma_giam_gia] ([id], [gia_tri_giam], [gia_tri_giam_toi_da], [gia_tri_toi_thieu], [loai_giam_gia], [ma_code], [ngay_bat_dau], [ngay_ket_thuc], [so_luong], [so_luong_da_dung], [ten_khuyen_mai], [trang_thai]) VALUES (1, 40, 50000, 300000, N'PERCENTAGE', N'HATS07A37V', '2026-09-13 00:46:00.000', '2029-06-13 00:46:00.000', 15, 0, N'ngon', 1);
SET IDENTITY_INSERT [dbo].[ma_giam_gia] OFF;
GO

-- Data for table: tai_khoan (3 rows)
SET IDENTITY_INSERT [dbo].[tai_khoan] ON;
INSERT INTO [dbo].[tai_khoan] ([id], [mat_khau], [ten_dang_nhap], [trang_thai], [vai_tro]) VALUES (1, N'$2a$10$ZFec8V7rfzXioRzUbE/p5uQt/5utCQhvTtVtym2oWtA2s8agMaw9G', N'admin', N'ACTIVE', N'ADMIN');
INSERT INTO [dbo].[tai_khoan] ([id], [mat_khau], [ten_dang_nhap], [trang_thai], [vai_tro]) VALUES (2, N'$2a$10$13nMLalYKWnqW1iZfVQa5.c9SrQw.SsqqoNJwMA86t4vjpDr8p3k.', N'user', N'ACTIVE', N'USER');
INSERT INTO [dbo].[tai_khoan] ([id], [mat_khau], [ten_dang_nhap], [trang_thai], [vai_tro]) VALUES (3, N'$2a$10$31ywVxCVYFRG2aujQj6SkOaUviLd3OffrwJiS1KMtlCGmhg5gu9/q', N'user2', N'ACTIVE', N'USER');
SET IDENTITY_INSERT [dbo].[tai_khoan] OFF;
GO

-- Data for table: khach_hang (2 rows)
SET IDENTITY_INSERT [dbo].[khach_hang] ON;
INSERT INTO [dbo].[khach_hang] ([id], [dia_chi], [email], [ho_ten], [so_dien_thoai], [tai_khoan_id]) VALUES (1, N'1441/322/ nhân mỹ, mỹ đình', N'user@fpt.com', N'Nguyễn Văn A', N'0987654321', 2);
INSERT INTO [dbo].[khach_hang] ([id], [dia_chi], [email], [ho_ten], [so_dien_thoai], [tai_khoan_id]) VALUES (2, N'HCM', N'user2@test.com', N'Khach Hang 2', N'0911223344', 3);
SET IDENTITY_INSERT [dbo].[khach_hang] OFF;
GO

-- Data for table: gio_hang (2 rows)
SET IDENTITY_INSERT [dbo].[gio_hang] ON;
INSERT INTO [dbo].[gio_hang] ([id], [ngay_tao], [khach_hang_id]) VALUES (1, '2026-09-12 23:15:38.949', 1);
INSERT INTO [dbo].[gio_hang] ([id], [ngay_tao], [khach_hang_id]) VALUES (3, '2026-09-12 23:42:08.712', 2);
SET IDENTITY_INSERT [dbo].[gio_hang] OFF;
GO

-- Data for table: san_pham (5 rows)
SET IDENTITY_INSERT [dbo].[san_pham] ON;
INSERT INTO [dbo].[san_pham] ([id], [anh_url], [gia], [mo_ta], [ngay_tao], [so_luong], [ten_san_pham], [danh_muc_id], [thuong_hieu_id]) VALUES (1, N'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?w=600', 350000, N'Mo ta', '2026-09-12 23:07:15.238', 136, N'Mũ Lưỡi Trai Nike Heritage86', 1, 1);
INSERT INTO [dbo].[san_pham] ([id], [anh_url], [gia], [mo_ta], [ngay_tao], [so_luong], [ten_san_pham], [danh_muc_id], [thuong_hieu_id]) VALUES (2, N'https://images.unsplash.com/photo-1534215754734-18e55d13e346?w=600', 380000, N'Thiết kế siêu nhẹ dành cho các hoạt động thể thao ngoài trời như chạy bộ, tennis. Công nghệ chống tia UV bảo vệ da đầu.', '2026-09-12 23:07:15.274', 37, N'Mũ Lưỡi Trai Adidas Superlite', 1, 2);
INSERT INTO [dbo].[san_pham] ([id], [anh_url], [gia], [mo_ta], [ngay_tao], [so_luong], [ten_san_pham], [danh_muc_id], [thuong_hieu_id]) VALUES (3, N'https://images.unsplash.com/photo-1516257984-b1b4d707412e?w=600', 490000, N'Mũ Snapback NY huyền thoại từ thương hiệu New Era. Phía sau có khấc nhựa điều chỉnh kích thước dễ dàng, phong cách hiphop cực chất.', '2026-09-12 23:07:15.276', 30, N'Mũ Snapback New Era 9FIFTY NY', 2, 4);
INSERT INTO [dbo].[san_pham] ([id], [anh_url], [gia], [mo_ta], [ngay_tao], [so_luong], [ten_san_pham], [danh_muc_id], [thuong_hieu_id]) VALUES (4, N'https://images.unsplash.com/photo-1529958030586-3aae4ca485ff?w=600', 450000, N'Mũ tai bèo (bucket) in họa tiết logo Boston cá tính. Vải kaki dày dặn giữ form tốt, thích hợp cho cả nam và nữ.', '2026-09-12 23:07:15.278', 37, N'Mũ Bucket MLB Boston Red Sox', 3, 3);
INSERT INTO [dbo].[san_pham] ([id], [anh_url], [gia], [mo_ta], [ngay_tao], [so_luong], [ten_san_pham], [danh_muc_id], [thuong_hieu_id]) VALUES (5, N'https://images.unsplash.com/photo-1576871337632-b9aef4c17ab9?w=600', 420000, N'Mũ MLB thêu chữ LA nổi bật màu xanh dương thanh lịch. Chất liệu cao cấp, đường chỉ thêu tỉ mỉ chuẩn auth.', '2026-09-12 23:07:15.281', 31, N'Mũ Lưỡi Trai MLB LA Dodgers', 2, 3);
SET IDENTITY_INSERT [dbo].[san_pham] OFF;
GO

-- Data for table: bien_the_san_pham (15 rows)
SET IDENTITY_INSERT [dbo].[bien_the_san_pham] ON;
INSERT INTO [dbo].[bien_the_san_pham] ([id], [gia], [kich_co], [mau_sac], [sku], [so_luong], [san_pham_id]) VALUES (1, 233232, N'M', N'Đen', N'MLB-LAD-M', 9, 5);
INSERT INTO [dbo].[bien_the_san_pham] ([id], [gia], [kich_co], [mau_sac], [sku], [so_luong], [san_pham_id]) VALUES (2, 350000, N'M', N'Đen', N'NIKE-BLK-M', 98, 1);
INSERT INTO [dbo].[bien_the_san_pham] ([id], [gia], [kich_co], [mau_sac], [sku], [so_luong], [san_pham_id]) VALUES (3, 360000, N'L', N'Trắng', N'NIKE-WHT-L', 13, 1);
INSERT INTO [dbo].[bien_the_san_pham] ([id], [gia], [kich_co], [mau_sac], [sku], [so_luong], [san_pham_id]) VALUES (5, 370000, N'XL', N'Xanh Navy', N'NIKE-NVY-XL', 25, 1);
INSERT INTO [dbo].[bien_the_san_pham] ([id], [gia], [kich_co], [mau_sac], [sku], [so_luong], [san_pham_id]) VALUES (6, 380000, N'M', N'Đen', N'ADS-BLK-M', 15, 2);
INSERT INTO [dbo].[bien_the_san_pham] ([id], [gia], [kich_co], [mau_sac], [sku], [so_luong], [san_pham_id]) VALUES (7, 380000, N'L', N'Trắng', N'ADS-WHT-L', 12, 2);
INSERT INTO [dbo].[bien_the_san_pham] ([id], [gia], [kich_co], [mau_sac], [sku], [so_luong], [san_pham_id]) VALUES (8, 390000, N'XL', N'Xám', N'ADS-GRY-XL', 10, 2);
INSERT INTO [dbo].[bien_the_san_pham] ([id], [gia], [kich_co], [mau_sac], [sku], [so_luong], [san_pham_id]) VALUES (9, 490000, N'M', N'Đen Phối Trắng', N'NE-BLK-M', 10, 3);
INSERT INTO [dbo].[bien_the_san_pham] ([id], [gia], [kich_co], [mau_sac], [sku], [so_luong], [san_pham_id]) VALUES (10, 490000, N'L', N'Đen Phối Đỏ', N'NE-RED-L', 12, 3);
INSERT INTO [dbo].[bien_the_san_pham] ([id], [gia], [kich_co], [mau_sac], [sku], [so_luong], [san_pham_id]) VALUES (11, 510000, N'XL', N'Xanh Navy', N'NE-NVY-XL', 8, 3);
INSERT INTO [dbo].[bien_the_san_pham] ([id], [gia], [kich_co], [mau_sac], [sku], [so_luong], [san_pham_id]) VALUES (12, 450000, N'M', N'Be (Cream)', N'MLB-BOS-BE-M', 12, 4);
INSERT INTO [dbo].[bien_the_san_pham] ([id], [gia], [kich_co], [mau_sac], [sku], [so_luong], [san_pham_id]) VALUES (13, 450000, N'L', N'Đen', N'MLB-BOS-BLK-L', 15, 4);
INSERT INTO [dbo].[bien_the_san_pham] ([id], [gia], [kich_co], [mau_sac], [sku], [so_luong], [san_pham_id]) VALUES (14, 450000, N'FreeSize', N'Nâu', N'MLB-BOS-BRN-FS', 10, 4);
INSERT INTO [dbo].[bien_the_san_pham] ([id], [gia], [kich_co], [mau_sac], [sku], [so_luong], [san_pham_id]) VALUES (15, 420000, N'L', N'Đen', N'MLB-LAD-BLK-L', 12, 5);
INSERT INTO [dbo].[bien_the_san_pham] ([id], [gia], [kich_co], [mau_sac], [sku], [so_luong], [san_pham_id]) VALUES (16, 420000, N'M', N'Xanh Dương', N'MLB-LAD-BLU-M', 10, 5);
SET IDENTITY_INSERT [dbo].[bien_the_san_pham] OFF;
GO

-- Data for table: don_hang (66 rows)
SET IDENTITY_INSERT [dbo].[don_hang] ON;
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (1, N'123 Đường Lê Lợi, Quận 1, TP. Hồ Chí Minh', N'', N'Nguyễn Văn A', '2026-09-12 23:16:41.179', N'0987654321', 0, 2798784, N'PENDING', 1, NULL, NULL, NULL, NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (2, N'123 Đường Lê Lợi, Quận 1, TP. Hồ Chí Minh', N'', N'Nguyễn Văn A', '2026-09-12 23:18:36.416', N'0987654321', 0, 5040000, N'CANCELLED', 1, NULL, NULL, NULL, NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (3, N'So 1 Dai Co Viet, Ha Noi', N'Giao buoi chieu', N'Nguyen Van Test', '2026-09-12 23:27:15.463', N'0988776655', 0, 700000, N'PENDING', 1, NULL, NULL, NULL, NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (4, N'Hanoi', N'Test', N'Test Stock Deduction', '2026-09-12 23:29:04.985', N'0987654321', 0, 699696, N'PENDING', 1, NULL, NULL, NULL, NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (5, N'So 1 Dai Co Viet, Ha Noi', N'Giao buoi chieu', N'Nguyen Van Test', '2026-09-12 23:41:01.508', N'0988776655', 0, 700000, N'PENDING', 1, NULL, N'COD', N'UNPAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (6, N'So 1 Dai Co Viet, Ha Noi', N'Giao buoi chieu', N'Nguyen Van Test', '2026-09-12 23:41:40.956', N'0988776655', 0, 700000, N'PENDING', 1, NULL, N'COD', N'UNPAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (7, N'So 1 Dai Co Viet, Ha Noi', N'Giao buoi chieu', N'Nguyen Van Test', '2026-09-12 23:42:08.184', N'0988776655', 0, 700000, N'CANCELLED', 1, NULL, N'COD', N'UNPAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (8, N'123 Đường Test, Hà Nội', N'Thanh toán QR', N'Khách Hàng VietQR', '2026-09-12 23:42:08.755', N'0988776655', 0, 350000, N'PENDING', 2, NULL, N'VIETQR', N'UNPAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (9, N'Hanoi', N'Test', N'Test Stock Deduction', '2026-09-12 23:42:24.941', N'0987654321', 0, 1769696, N'PENDING', 1, NULL, N'COD', N'UNPAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (10, N'123 Đường Lê Lợi, Quận 1, TP. Hồ Chí Minh', N'', N'Nguyễn Văn A', '2026-09-12 23:45:13.982', N'0987654321', 0, 420000, N'CONFIRMED', 1, NULL, N'VIETQR', N'PAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (11, N'Ha Noi', NULL, N'Nguyen Van A', '2026-09-12 23:48:36.647', N'0912345678', 0, 350000, N'CONFIRMED', 1, NULL, N'VNPAY', N'PAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (12, N'Ha Noi', NULL, N'Nguyen Van A', '2026-09-12 23:48:40.756', N'0912345678', 0, 350000, N'CONFIRMED', 1, NULL, N'VIETQR', N'PAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (13, N'So 1 Dai Co Viet, Ha Noi', N'Giao buoi chieu', N'Nguyen Van Test', '2026-09-12 23:48:44.003', N'0988776655', 0, 700000, N'PENDING', 1, NULL, N'COD', N'UNPAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (14, N'123 Đường Test, Hà Nội', N'Thanh toán QR', N'Khách Hàng VietQR', '2026-09-12 23:48:44.613', N'0988776655', 0, 350000, N'PENDING', 2, NULL, N'VIETQR', N'PAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (15, N'123 Đường Lê Lợi, Quận 1, TP. Hồ Chí Minh', N'', N'Nguyễn Văn A', '2026-09-13 00:01:03.540', N'0987654321', 0, 420000, N'PENDING', 1, NULL, N'VNPAY', N'UNPAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (16, N'123 Pho Hue, Hai Ba Trung, Ha Noi', N'Giao gio hanh chinh', N'Nguyen Van Test', '2026-09-13 00:10:30.764', N'0912345678', 0, 700000, N'PENDING', 1, NULL, N'COD', N'UNPAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (17, N'123 Pho Hue, Hai Ba Trung, Ha Noi', N'Giao gio hanh chinh', N'Nguyen Van Test', '2026-09-13 00:10:41.890', N'0912345678', 0, 350000, N'PENDING', 1, NULL, N'COD', N'UNPAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (18, N'123 Pho Hue, Hai Ba Trung, Ha Noi', N'Giao gio hanh chinh', N'Nguyen Van Test', '2026-09-13 00:10:51.332', N'0912345678', 0, 350000, N'CONFIRMED', 1, NULL, N'COD', N'UNPAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (19, N'123 Pho Hue, Hai Ba Trung, Ha Noi', N'Giao gio hanh chinh', N'Nguyen Van Test', '2026-09-13 00:10:55.897', N'0912345678', 0, 350000, N'DELIVERED', 1, NULL, N'COD', N'PAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (20, N'123 Pho Hue, Hai Ba Trung, Ha Noi', N'Giao gio hanh chinh', N'Nguyen Van Test', '2026-09-13 00:11:03.485', N'0912345678', 0, 350000, N'DELIVERED', 1, NULL, N'COD', N'PAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (21, N'123 Pho Hue, Hai Ba Trung, Ha Noi', N'Giao gio hanh chinh', N'Nguyen Van Test', '2026-09-13 00:11:09.383', N'0912345678', 0, 350000, N'DELIVERED', 1, NULL, N'COD', N'PAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (22, N'456 Tran Hung Dao, Q1, TP.HCM', N'Thanh toan VNPAY', N'Nguyen Van VNPAY', '2026-09-13 00:11:18.078', N'0987654321', 0, 350000, N'PENDING', 1, NULL, N'VNPAY', N'UNPAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (23, N'456 Tran Hung Dao, Q1, TP.HCM', N'Thanh toan VNPAY', N'Nguyen Van VNPAY', '2026-09-13 00:11:32.406', N'0987654321', 0, 350000, N'CONFIRMED', 1, NULL, N'VNPAY', N'PAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (24, N'123 Đường Lê Lợi, Quận 1, TP. Hồ Chí Minh', N'', N'Nguyễn Văn A', '2026-09-13 00:15:11.941', N'0987654321', 0, 450000, N'CONFIRMED', 1, NULL, N'VNPAY', N'PAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (25, N'123 Pho Hue, Hai Ba Trung, Ha Noi', N'Giao gio hanh chinh', N'Nguyen Van Test', '2026-09-13 00:27:21.840', N'0912345678', 0, 350000, N'DELIVERED', 1, NULL, N'COD', N'PAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (26, N'456 Tran Hung Dao, Q1, TP.HCM', N'Thanh toan VNPAY', N'Nguyen Van VNPAY', '2026-09-13 00:27:27.359', N'0987654321', 0, 350000, N'CONFIRMED', 1, NULL, N'VNPAY', N'PAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (27, N'123 Đường Lê Lợi, Quận 1, TP. Hồ Chí Minh', N'', N'Nguyễn Văn A', '2026-09-13 00:33:53.770', N'0987654321', 0, 233232, N'PENDING', 1, NULL, N'COD', N'UNPAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (28, N'123 Đường Lê Lợi, Quận 1, TP. Hồ Chí Minh', N'', N'Nguyễn Văn A', '2026-09-13 00:34:18.682', N'0987654321', 0, 233232, N'SHIPPING', 1, NULL, N'VIETQR', N'PAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (29, N'123 Đường Lê Lợi, Quận 1, TP. Hồ Chí Minh', N'', N'Nguyễn Văn A', '2026-09-13 00:48:01.691', N'0987654321', 0, 233232, N'PENDING', 1, NULL, N'VNPAY', N'UNPAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (30, N'123 Đường Lê Lợi, Quận 1, TP. Hồ Chí Minh', N'', N'Nguyễn Văn A', '2026-09-13 00:48:24.253', N'0987654321', 0, 233232, N'CONFIRMED', 1, NULL, N'VIETQR', N'PAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (31, N'456 Tran Phu, Da Nang', N'Giao gio hanh chinh', N'Nguyen Van Test', '2026-09-13 00:59:02.913', N'0912345678', 0, 350000, N'CONFIRMED', 1, NULL, N'VIETQR', N'PAID', N'FT235943116', '2026-09-13 00:59:03.116');
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (32, N'456 Tran Phu, Da Nang', N'Giao gio hanh chinh', N'Nguyen Van Test', '2026-09-13 00:59:10.763', N'0912345678', 0, 350000, N'CONFIRMED', 1, NULL, N'VIETQR', N'PAID', N'FT235950872', '2026-09-13 00:59:10.872');
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (33, N'456 Tran Phu, Da Nang', N'Giao gio hanh chinh', N'Nguyen Van Test', '2026-09-13 00:59:10.981', N'0912345678', 0, 350000, N'CONFIRMED', 1, NULL, N'VNPAY', N'PAID', N'VNP14951052', '2026-09-13 00:59:11.052');
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (34, N'789 Le Duan, Ha Noi', N'COD test', N'Nguyen Van COD', '2026-09-13 00:59:26.623', N'0987654321', 0, 350000, N'DELIVERED', 1, NULL, N'COD', N'PAID', N'COD-DLV-34', '2026-09-13 00:59:26.945');
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (35, N'123 Cancel St', N'Test cancel', N'Nguyen Van Cancel', '2026-09-13 00:59:27.113', N'0987654321', 0, 700000, N'CANCELLED', 1, NULL, N'COD', N'UNPAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (36, N'123 Pho Hue, Hai Ba Trung, Ha Noi', NULL, N'Nguyen Van Kiem Thu', '2026-09-13 01:06:19.354', N'0912345678', 0, 350000, N'CONFIRMED', 1, NULL, N'VIETQR', N'PAID', N'FT236379506', '2026-09-13 01:06:19.507');
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (37, N'456 Tran Hung Dao, Quan 1, TP. HCM', NULL, N'Tran Thi VNPAY', '2026-09-13 01:06:19.690', N'0988776655', 0, 380000, N'PENDING', 1, NULL, N'VNPAY', N'UNPAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (38, N'123 Pho Hue, Hai Ba Trung, Ha Noi', NULL, N'Nguyen Van Kiem Thu', '2026-09-13 01:06:36.602', N'0912345678', 0, 350000, N'CONFIRMED', 1, NULL, N'VIETQR', N'PAID', N'FT236396710', '2026-09-13 01:06:36.710');
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (39, N'456 Tran Hung Dao, Quan 1, TP. HCM', NULL, N'Tran Thi VNPAY', '2026-09-13 01:06:36.832', N'0988776655', 0, 380000, N'PENDING', 1, NULL, N'VNPAY', N'UNPAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (40, N'123 Pho Hue, Hai Ba Trung, Ha Noi', NULL, N'Nguyen Van Kiem Thu', '2026-09-13 01:07:17.012', N'0912345678', 0, 350000, N'CONFIRMED', 1, NULL, N'VIETQR', N'PAID', N'FT236437186', '2026-09-13 01:07:17.186');
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (41, N'456 Tran Hung Dao, Quan 1, TP. HCM', NULL, N'Tran Thi VNPAY', '2026-09-13 01:07:17.348', N'0988776655', 0, 380000, N'CONFIRMED', 1, NULL, N'VNPAY', N'PAID', N'VNP14437446', '2026-09-13 01:07:17.446');
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (42, N'So 1 Dai Co Viet, Ha Noi', N'Giao buoi chieu', N'Nguyen Van Test', '2026-09-13 01:07:22.325', N'0988776655', 0, 700000, N'PENDING', 1, NULL, N'COD', N'UNPAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (43, N'123 Đường Test, Hà Nội', N'Thanh toán QR', N'Khách Hàng VietQR', '2026-09-13 01:07:23.074', N'0988776655', 0, 350000, N'PENDING', 2, NULL, N'VIETQR', N'UNPAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (44, N'789 Le Duan, Ha Noi', N'COD test', N'Nguyen Van COD', '2026-09-13 01:07:35.689', N'0987654321', 0, 350000, N'DELIVERED', 1, NULL, N'COD', N'PAID', N'COD-DLV-44', '2026-09-13 01:07:35.996');
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (45, N'123 Cancel St', N'Test cancel', N'Nguyen Van Cancel', '2026-09-13 01:07:36.141', N'0987654321', 0, 700000, N'CANCELLED', 1, NULL, N'COD', N'UNPAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (46, N'123 Đường Lê Lợi, Quận 1, TP. Hồ Chí Minh', N'', N'Nguyễn Văn A', '2026-09-13 01:10:50.410', N'0987654321', 0, 233232, N'DELIVERED', 1, NULL, N'VNPAY', N'PAID', N'VNP14675657', '2026-09-13 01:11:15.657');
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (47, N'123 Pho Hue, Hai Ba Trung, Ha Noi', NULL, N'Nguyen Van Kiem Thu', '2026-09-13 01:17:49.637', N'0912345678', 0, 350000, N'CONFIRMED', 1, NULL, N'VIETQR', N'PAID', N'FT237069794', '2026-09-13 01:17:49.794');
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (48, N'456 Tran Hung Dao, Quan 1, TP. HCM', NULL, N'Tran Thi VNPAY', '2026-09-13 01:17:49.960', N'0988776655', 0, 380000, N'CONFIRMED', 1, NULL, N'VNPAY', N'PAID', N'VNP1470065', '2026-09-13 01:17:50.065');
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (49, N'789 Le Duan, Ha Noi', N'COD test', N'Nguyen Van COD', '2026-09-13 01:17:53.062', N'0987654321', 0, 350000, N'DELIVERED', 1, NULL, N'COD', N'PAID', N'COD-DLV-49', '2026-09-13 01:17:53.331');
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (50, N'123 Cancel St', N'Test cancel', N'Nguyen Van Cancel', '2026-09-13 01:17:53.495', N'0987654321', 0, 700000, N'CANCELLED', 1, NULL, N'COD', N'UNPAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (51, N'd', N'', N'h', '2026-09-13 01:20:30.576', N's', 0, 233232, N'DELIVERED', 1, NULL, N'COD', N'PAID', N'COD-DLV-51', '2026-09-13 01:35:33.848');
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (52, N'Số 456 Đường Nguyễn Trãi, Thanh Xuân, Hà Nội', N'Giao giờ hành chính', N'Trần Thị Mai', '2026-09-13 01:27:15.218', N'0912345678', 0, 350000, N'CANCELLED', 1, NULL, N'COD', N'UNPAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (53, N'789 Le Duan, Ha Noi', N'COD test', N'Nguyen Van COD', '2026-09-13 01:27:45.159', N'0987654321', 0, 350000, N'DELIVERED', 1, NULL, N'COD', N'PAID', N'COD-DLV-53', '2026-09-13 01:27:45.505');
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (54, N'123 Cancel St', N'Test cancel', N'Nguyen Van Cancel', '2026-09-13 01:27:45.659', N'0987654321', 0, 700000, N'CANCELLED', 1, NULL, N'COD', N'UNPAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (55, N'123 Pho Hue, Hai Ba Trung, Ha Noi', NULL, N'Nguyen Van Kiem Thu', '2026-09-13 01:28:49.587', N'0912345678', 0, 350000, N'CONFIRMED', 1, NULL, N'VIETQR', N'PAID', N'FT237729713', '2026-09-13 01:28:49.713');
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (56, N'456 Tran Hung Dao, Quan 1, TP. HCM', NULL, N'Tran Thi VNPAY', '2026-09-13 01:28:49.862', N'0988776655', 0, 380000, N'CONFIRMED', 1, NULL, N'VNPAY', N'PAID', N'VNP14729929', '2026-09-13 01:28:49.929');
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (57, N'Số 456 Đường Nguyễn Trãi, Thanh Xuân, Hà Nội', N'Giao giờ hành chính', N'Trần Thị Mai', '2026-09-13 01:28:54.053', N'0912345678', 0, 350000, N'CANCELLED', 1, NULL, N'COD', N'UNPAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (58, N'789 Le Duan, Ha Noi', N'COD test', N'Nguyen Van COD', '2026-09-13 01:28:59.080', N'0987654321', 0, 350000, N'DELIVERED', 1, NULL, N'COD', N'PAID', N'COD-DLV-58', '2026-09-13 01:28:59.341');
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (59, N'123 Cancel St', N'Test cancel', N'Nguyen Van Cancel', '2026-09-13 01:28:59.474', N'0987654321', 0, 700000, N'CANCELLED', 1, NULL, N'COD', N'UNPAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (60, N'1441/322/ nhân mỹ, mỹ đình', N'', N'Nguyễn Văn A', '2026-09-13 01:33:49.260', N'0987654321', 0, 233232, N'CONFIRMED', 1, NULL, N'VIETQR', N'PAID', N'FT238074488', '2026-09-13 01:34:34.488');
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (61, N'1441/322/ nhân mỹ, mỹ đình', N'', N'Nguyễn Văn A', '2026-09-13 01:35:45.286', N'0987654321', 0, 233232, N'DELIVERED', 1, NULL, N'VIETQR', N'PAID', N'FT238152821', '2026-09-13 01:35:52.821');
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (62, N'Số 456 Đường Nguyễn Trãi, Thanh Xuân, Hà Nội', N'Giao giờ hành chính', N'Trần Thị Mai', '2026-09-13 01:42:20.837', N'0912345678', 0, 350000, N'CANCELLED', 1, NULL, N'COD', N'UNPAID', NULL, NULL);
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (63, N'123 Pho Hue, Hai Ba Trung, Ha Noi', NULL, N'Nguyen Van Kiem Thu', '2026-09-13 01:42:26.483', N'0912345678', 0, 350000, N'CONFIRMED', 1, NULL, N'VIETQR', N'PAID', N'FT238546662', '2026-09-13 01:42:26.662');
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (64, N'456 Tran Hung Dao, Quan 1, TP. HCM', NULL, N'Tran Thi VNPAY', '2026-09-13 01:42:26.811', N'0988776655', 0, 380000, N'CONFIRMED', 1, NULL, N'VNPAY', N'PAID', N'VNP14546889', '2026-09-13 01:42:26.889');
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (65, N'789 Le Duan, Ha Noi', N'COD test', N'Nguyen Van COD', '2026-09-13 01:42:31.384', N'0987654321', 0, 350000, N'DELIVERED', 1, NULL, N'COD', N'PAID', N'COD-DLV-65', '2026-09-13 01:42:31.689');
INSERT INTO [dbo].[don_hang] ([id], [dia_chi_nhan], [ghi_chu], [ho_ten_nhan], [ngay_dat], [so_dien_thoai_nhan], [so_tien_giam], [tong_tien], [trang_thai], [khach_hang_id], [khuyen_mai_id], [phuong_thuc_thanh_toan], [trang_thai_thanh_toan], [ma_giao_dich], [ngay_thanh_toan]) VALUES (66, N'123 Cancel St', N'Test cancel', N'Nguyen Van Cancel', '2026-09-13 01:42:31.908', N'0987654321', 0, 700000, N'CANCELLED', 1, NULL, N'COD', N'UNPAID', NULL, NULL);
SET IDENTITY_INSERT [dbo].[don_hang] OFF;
GO

-- Data for table: chi_tiet_don_hang (68 rows)
SET IDENTITY_INSERT [dbo].[chi_tiet_don_hang] ON;
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (1, 233232, 12, 1, 1, 5);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (2, 420000, 12, NULL, 2, 5);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (3, 350000, 2, NULL, 3, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (4, 233232, 3, 1, 4, 5);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (5, 350000, 2, NULL, 5, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (6, 350000, 2, NULL, 6, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (7, 350000, 2, NULL, 7, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (8, 350000, 1, 2, 8, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (9, 350000, 1, 2, 9, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (10, 360000, 2, 3, 9, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (11, 233232, 3, 1, 9, 5);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (12, 420000, 1, NULL, 10, 5);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (13, 350000, 1, 2, 11, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (14, 350000, 1, 2, 12, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (15, 350000, 2, NULL, 13, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (16, 350000, 1, 2, 14, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (17, 420000, 1, NULL, 15, 5);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (18, 350000, 2, NULL, 16, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (19, 350000, 1, NULL, 17, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (20, 350000, 1, NULL, 18, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (21, 350000, 1, NULL, 19, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (22, 350000, 1, NULL, 20, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (23, 350000, 1, NULL, 21, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (24, 350000, 1, NULL, 22, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (25, 350000, 1, NULL, 23, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (26, 450000, 1, NULL, 24, 4);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (27, 350000, 1, NULL, 25, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (28, 350000, 1, NULL, 26, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (29, 233232, 1, 1, 27, 5);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (30, 233232, 1, 1, 28, 5);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (31, 233232, 1, 1, 29, 5);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (32, 233232, 1, 1, 30, 5);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (33, 350000, 1, NULL, 31, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (34, 350000, 1, NULL, 32, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (35, 350000, 1, NULL, 33, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (36, 350000, 1, NULL, 34, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (37, 350000, 2, NULL, 35, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (38, 350000, 1, 2, 36, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (39, 380000, 1, NULL, 37, 2);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (40, 350000, 1, 2, 38, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (41, 380000, 1, NULL, 39, 2);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (42, 350000, 1, 2, 40, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (43, 380000, 1, NULL, 41, 2);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (44, 350000, 2, NULL, 42, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (45, 350000, 1, 2, 43, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (46, 350000, 1, NULL, 44, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (47, 350000, 2, NULL, 45, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (48, 233232, 1, 1, 46, 5);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (49, 350000, 1, 2, 47, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (50, 380000, 1, NULL, 48, 2);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (51, 350000, 1, NULL, 49, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (52, 350000, 2, NULL, 50, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (53, 233232, 1, 1, 51, 5);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (54, 350000, 1, NULL, 52, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (55, 350000, 1, NULL, 53, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (56, 350000, 2, NULL, 54, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (57, 350000, 1, 2, 55, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (58, 380000, 1, NULL, 56, 2);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (59, 350000, 1, NULL, 57, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (60, 350000, 1, NULL, 58, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (61, 350000, 2, NULL, 59, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (62, 233232, 1, 1, 60, 5);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (63, 233232, 1, 1, 61, 5);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (64, 350000, 1, NULL, 62, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (65, 350000, 1, 2, 63, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (66, 380000, 1, NULL, 64, 2);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (67, 350000, 1, NULL, 65, 1);
INSERT INTO [dbo].[chi_tiet_don_hang] ([id], [gia_ban], [so_luong], [bien_the_id], [don_hang_id], [san_pham_id]) VALUES (68, 350000, 2, NULL, 66, 1);
SET IDENTITY_INSERT [dbo].[chi_tiet_don_hang] OFF;
GO

-- Data for table: danh_gia_san_pham (7 rows)
SET IDENTITY_INSERT [dbo].[danh_gia_san_pham] ON;
INSERT INTO [dbo].[danh_gia_san_pham] ([id], [ngay_tao], [noi_dung], [so_sao], [khach_hang_id], [san_pham_id]) VALUES (1, '2026-09-12 23:41:41.659', N'Mũ rất đẹp, vải dày dặn, form chuẩn! Đánh giá 5 sao cho shop.', 5, 2, 1);
INSERT INTO [dbo].[danh_gia_san_pham] ([id], [ngay_tao], [noi_dung], [so_sao], [khach_hang_id], [san_pham_id]) VALUES (2, '2026-09-12 23:42:08.831', N'Mũ rất đẹp, vải dày dặn, form chuẩn! Đánh giá 5 sao cho shop.', 5, 2, 1);
INSERT INTO [dbo].[danh_gia_san_pham] ([id], [ngay_tao], [noi_dung], [so_sao], [khach_hang_id], [san_pham_id]) VALUES (3, '2026-09-12 23:48:44.681', N'Mũ rất đẹp, vải dày dặn, form chuẩn! Đánh giá 5 sao cho shop.', 5, 2, 1);
INSERT INTO [dbo].[danh_gia_san_pham] ([id], [ngay_tao], [noi_dung], [so_sao], [khach_hang_id], [san_pham_id]) VALUES (4, '2026-09-13 00:36:44.740', N'Mũ MLB Dodgers rất đẹp, đường thêu sắc nét! Đánh giá từ người mua thực tế.', 5, 2, 1);
INSERT INTO [dbo].[danh_gia_san_pham] ([id], [ngay_tao], [noi_dung], [so_sao], [khach_hang_id], [san_pham_id]) VALUES (5, '2026-09-13 00:47:39.940', N'ádấdsa', 5, 1, 5);
INSERT INTO [dbo].[danh_gia_san_pham] ([id], [ngay_tao], [noi_dung], [so_sao], [khach_hang_id], [san_pham_id]) VALUES (6, '2026-09-13 01:07:23.171', N'Mũ rất đẹp, vải dày dặn, form chuẩn! Đánh giá 5 sao cho shop.', 5, 2, 1);
INSERT INTO [dbo].[danh_gia_san_pham] ([id], [ngay_tao], [noi_dung], [so_sao], [khach_hang_id], [san_pham_id]) VALUES (7, '2026-09-13 11:06:43.066', N'ngon', 5, 1, 5);
SET IDENTITY_INSERT [dbo].[danh_gia_san_pham] OFF;
GO

-- Data for table: tin_nhan (27 rows)
SET IDENTITY_INSERT [dbo].[tin_nhan] ON;
INSERT INTO [dbo].[tin_nhan] ([id], [da_doc], [noi_dung], [sender_name], [sender_role], [session_guest_id], [thoi_gian], [khach_hang_id]) VALUES (1, 1, N'Shop tư vấn giúp mình cách đo size mũ bảo hiểm với', N'Khách vãng lai', N'CUSTOMER', N'guest_test_999', '2026-09-13 01:49:30.126', NULL);
INSERT INTO [dbo].[tin_nhan] ([id], [da_doc], [noi_dung], [sender_name], [sender_role], [session_guest_id], [thoi_gian], [khach_hang_id]) VALUES (2, 1, N'📏 **Hướng dẫn chọn size mũ bảo hiểm chuẩn xác**:
• **Size M**: Vòng đầu 54 - 56 cm (phổ thông cho nữ hoặc nam dáng gọn)
• **Size L**: Vòng đầu 57 - 59 cm (phổ thông cho nam giới)
• **Size XL**: Vòng đầu 60 - 62 cm (vòng đầu lớn)

👉 *Mẹo nhỏ*: Dùng thước dây đo ngang trán cách lông mày 2cm. Nếu nằm giữa 2 size, nên chọn size lớn hơn để đội thoải mái nhé!', N'Tr? lý Shop', N'BOT', N'guest_test_999', '2026-09-13 01:49:30.780', NULL);
INSERT INTO [dbo].[tin_nhan] ([id], [da_doc], [noi_dung], [sender_name], [sender_role], [session_guest_id], [thoi_gian], [khach_hang_id]) VALUES (3, 1, N'Thời gian và phí giao hàng về Hà Nội bao lâu vậy shop?', N'Khách vãng lai', N'CUSTOMER', N'guest_test_999', '2026-09-13 01:49:31.737', NULL);
INSERT INTO [dbo].[tin_nhan] ([id], [da_doc], [noi_dung], [sender_name], [sender_role], [session_guest_id], [thoi_gian], [khach_hang_id]) VALUES (4, 1, N'🚚 **Chính sách giao nhận hàng**:
• **Nội thành**: Nhận hàng trong 1-2 ngày.
• **Toàn quốc**: 2-4 ngày làm việc.
• **Phí ship**: Đồng giá 30.000đ, miễn phí giao hàng cho đơn hàng giá trị cao.
• Quý khách được **đồng kiểm và thử đội** trước khi thanh toán tiền cho shipper!', N'Tr? lý Shop', N'BOT', N'guest_test_999', '2026-09-13 01:49:32.350', NULL);
INSERT INTO [dbo].[tin_nhan] ([id], [da_doc], [noi_dung], [sender_name], [sender_role], [session_guest_id], [thoi_gian], [khach_hang_id]) VALUES (5, 1, N'Chào shop, mình cần tư vấn thêm về chế độ bảo hành 24 tháng', N'Nguy?n Van A', N'CUSTOMER', NULL, '2026-09-13 01:49:33.566', 1);
INSERT INTO [dbo].[tin_nhan] ([id], [da_doc], [noi_dung], [sender_name], [sender_role], [session_guest_id], [thoi_gian], [khach_hang_id]) VALUES (6, 1, N'🛡️ **Chính sách bảo hành & Đổi trả**:
• **Đổi mới 1-1** trong 7 ngày nếu lỗi từ nhà sản xuất hoặc đội không vừa size (giữ nguyên tem mác).
• **Bảo hành chính hãng** 12 - 24 tháng cho chốt khóa, kính chắn gió và kết cấu nón.
• Để yêu cầu đổi hàng nhanh, bạn chỉ cần gửi mã đơn hàng tại đây nhé!', N'Tr? lý Shop', N'BOT', NULL, '2026-09-13 01:49:34.181', 1);
INSERT INTO [dbo].[tin_nhan] ([id], [da_doc], [noi_dung], [sender_name], [sender_role], [session_guest_id], [thoi_gian], [khach_hang_id]) VALUES (7, 1, N'Dạ shop chào bạn! Mọi sản phẩm mũ tại shop đều được bảo hành chính hãng 24 tháng và đổi mới 7 ngày nếu không vừa size nhé ạ.', N'admin', N'ADMIN', NULL, '2026-09-13 01:49:35.340', 1);
INSERT INTO [dbo].[tin_nhan] ([id], [da_doc], [noi_dung], [sender_name], [sender_role], [session_guest_id], [thoi_gian], [khach_hang_id]) VALUES (8, 1, N'admin ơi mình cần hỗ trợ', N'Nguy?n Van A', N'CUSTOMER', NULL, '2026-09-13 01:50:22.511', 1);
INSERT INTO [dbo].[tin_nhan] ([id], [da_doc], [noi_dung], [sender_name], [sender_role], [session_guest_id], [thoi_gian], [khach_hang_id]) VALUES (9, 1, N'bạn muốn mua sản phẩm  nào ạ', N'admin', N'ADMIN', NULL, '2026-09-13 01:50:56.376', 1);
INSERT INTO [dbo].[tin_nhan] ([id], [da_doc], [noi_dung], [sender_name], [sender_role], [session_guest_id], [thoi_gian], [khach_hang_id]) VALUES (10, 1, N'Hướng dẫn chọn size mũ bảo hiểm', N'Nguy?n Van A', N'CUSTOMER', NULL, '2026-09-13 01:51:04.515', 1);
INSERT INTO [dbo].[tin_nhan] ([id], [da_doc], [noi_dung], [sender_name], [sender_role], [session_guest_id], [thoi_gian], [khach_hang_id]) VALUES (11, 1, N'📏 **Hướng dẫn chọn size mũ bảo hiểm chuẩn xác**:
• **Size M**: Vòng đầu 54 - 56 cm (phổ thông cho nữ hoặc nam dáng gọn)
• **Size L**: Vòng đầu 57 - 59 cm (phổ thông cho nam giới)
• **Size XL**: Vòng đầu 60 - 62 cm (vòng đầu lớn)

👉 *Mẹo nhỏ*: Dùng thước dây đo ngang trán cách lông mày 2cm. Nếu nằm giữa 2 size, nên chọn size lớn hơn để đội thoải mái nhé!', N'Tr? lý Shop', N'BOT', NULL, '2026-09-13 01:51:05.133', 1);
INSERT INTO [dbo].[tin_nhan] ([id], [da_doc], [noi_dung], [sender_name], [sender_role], [session_guest_id], [thoi_gian], [khach_hang_id]) VALUES (12, 1, N'Hướng dẫn chọn size mũ bảo hiểm', N'Nguy?n Van A', N'CUSTOMER', NULL, '2026-09-13 01:51:17.311', 1);
INSERT INTO [dbo].[tin_nhan] ([id], [da_doc], [noi_dung], [sender_name], [sender_role], [session_guest_id], [thoi_gian], [khach_hang_id]) VALUES (13, 1, N'📏 **Hướng dẫn chọn size mũ bảo hiểm chuẩn xác**:
• **Size M**: Vòng đầu 54 - 56 cm (phổ thông cho nữ hoặc nam dáng gọn)
• **Size L**: Vòng đầu 57 - 59 cm (phổ thông cho nam giới)
• **Size XL**: Vòng đầu 60 - 62 cm (vòng đầu lớn)

👉 *Mẹo nhỏ*: Dùng thước dây đo ngang trán cách lông mày 2cm. Nếu nằm giữa 2 size, nên chọn size lớn hơn để đội thoải mái nhé!', N'Tr? lý Shop', N'BOT', NULL, '2026-09-13 01:51:17.929', 1);
INSERT INTO [dbo].[tin_nhan] ([id], [da_doc], [noi_dung], [sender_name], [sender_role], [session_guest_id], [thoi_gian], [khach_hang_id]) VALUES (14, 1, N'Bạn cho shop xin số đo vòng đầu (cm) để tư vấn size chuẩn nhất nhé!', N'admin', N'ADMIN', NULL, '2026-09-13 01:51:33.205', 1);
INSERT INTO [dbo].[tin_nhan] ([id], [da_doc], [noi_dung], [sender_name], [sender_role], [session_guest_id], [thoi_gian], [khach_hang_id]) VALUES (15, 1, N'Thời gian và phí giao hàng bao lâu?', N'Nguy?n Van A', N'CUSTOMER', NULL, '2026-09-13 01:56:04.936', 1);
INSERT INTO [dbo].[tin_nhan] ([id], [da_doc], [noi_dung], [sender_name], [sender_role], [session_guest_id], [thoi_gian], [khach_hang_id]) VALUES (16, 1, N'🚚 **Chính sách giao nhận hàng**:
• **Nội thành**: Nhận hàng trong 1-2 ngày.
• **Toàn quốc**: 2-4 ngày làm việc.
• **Phí ship**: Đồng giá 30.000đ, miễn phí giao hàng cho đơn hàng giá trị cao.
• Quý khách được **đồng kiểm và thử đội** trước khi thanh toán tiền cho shipper!', N'Tr? lý Shop', N'BOT', NULL, '2026-09-13 01:56:05.556', 1);
INSERT INTO [dbo].[tin_nhan] ([id], [da_doc], [noi_dung], [sender_name], [sender_role], [session_guest_id], [thoi_gian], [khach_hang_id]) VALUES (17, 1, N'Chính sách bảo hành và đổi trả như thế nào?', N'Nguy?n Van A', N'CUSTOMER', NULL, '2026-09-13 01:56:14.884', 1);
INSERT INTO [dbo].[tin_nhan] ([id], [da_doc], [noi_dung], [sender_name], [sender_role], [session_guest_id], [thoi_gian], [khach_hang_id]) VALUES (18, 1, N'🛡️ **Chính sách bảo hành & Đổi trả**:
• **Đổi mới 1-1** trong 7 ngày nếu lỗi từ nhà sản xuất hoặc đội không vừa size (giữ nguyên tem mác).
• **Bảo hành chính hãng** 12 - 24 tháng cho chốt khóa, kính chắn gió và kết cấu nón.
• Để yêu cầu đổi hàng nhanh, bạn chỉ cần gửi mã đơn hàng tại đây nhé!', N'Tr? lý Shop', N'BOT', NULL, '2026-09-13 01:56:15.495', 1);
INSERT INTO [dbo].[tin_nhan] ([id], [da_doc], [noi_dung], [sender_name], [sender_role], [session_guest_id], [thoi_gian], [khach_hang_id]) VALUES (19, 1, N'Mình cần gặp nhân viên tư vấn', N'Nguy?n Van A', N'CUSTOMER', NULL, '2026-09-13 01:56:19.988', 1);
INSERT INTO [dbo].[tin_nhan] ([id], [da_doc], [noi_dung], [sender_name], [sender_role], [session_guest_id], [thoi_gian], [khach_hang_id]) VALUES (20, 1, N'Dạ chào bạn! Rất vui được hỗ trợ bạn. Chuyên viên tư vấn đang kết nối và sẽ phản hồi bạn trong giây lát.
Bạn đang tìm mũ bảo hiểm dòng nào: **Fullface**, **Mũ 3/4** hay **Nửa đầu tiện lợi** ạ?', N'Tr? lý Shop', N'BOT', NULL, '2026-09-13 01:56:20.603', 1);
INSERT INTO [dbo].[tin_nhan] ([id], [da_doc], [noi_dung], [sender_name], [sender_role], [session_guest_id], [thoi_gian], [khach_hang_id]) VALUES (21, 1, N'Shop tư vấn giúp mình cách đo size mũ bảo hiểm với', N'Khách vãng lai', N'CUSTOMER', N'guest_test_999', '2026-09-13 02:04:23.297', NULL);
INSERT INTO [dbo].[tin_nhan] ([id], [da_doc], [noi_dung], [sender_name], [sender_role], [session_guest_id], [thoi_gian], [khach_hang_id]) VALUES (22, 1, N'📏 **Hướng dẫn chọn size mũ bảo hiểm chuẩn xác**:
• **Size M**: Vòng đầu 54 - 56 cm (phổ thông cho nữ hoặc nam dáng gọn)
• **Size L**: Vòng đầu 57 - 59 cm (phổ thông cho nam giới)
• **Size XL**: Vòng đầu 60 - 62 cm (vòng đầu lớn)

👉 *Mẹo nhỏ*: Dùng thước dây đo ngang trán cách lông mày 2cm. Nếu nằm giữa 2 size, nên chọn size lớn hơn để đội thoải mái nhé!', N'Tr? lý Shop', N'BOT', N'guest_test_999', '2026-09-13 02:04:23.997', NULL);
INSERT INTO [dbo].[tin_nhan] ([id], [da_doc], [noi_dung], [sender_name], [sender_role], [session_guest_id], [thoi_gian], [khach_hang_id]) VALUES (23, 1, N'Thời gian và phí giao hàng về Hà Nội bao lâu vậy shop?', N'Khách vãng lai', N'CUSTOMER', N'guest_test_999', '2026-09-13 02:04:24.930', NULL);
INSERT INTO [dbo].[tin_nhan] ([id], [da_doc], [noi_dung], [sender_name], [sender_role], [session_guest_id], [thoi_gian], [khach_hang_id]) VALUES (24, 1, N'🚚 **Chính sách giao nhận hàng**:
• **Nội thành**: Nhận hàng trong 1-2 ngày.
• **Toàn quốc**: 2-4 ngày làm việc.
• **Phí ship**: Đồng giá 30.000đ, miễn phí giao hàng cho đơn hàng giá trị cao.
• Quý khách được **đồng kiểm và thử đội** trước khi thanh toán tiền cho shipper!', N'Tr? lý Shop', N'BOT', N'guest_test_999', '2026-09-13 02:04:25.547', NULL);
INSERT INTO [dbo].[tin_nhan] ([id], [da_doc], [noi_dung], [sender_name], [sender_role], [session_guest_id], [thoi_gian], [khach_hang_id]) VALUES (25, 1, N'Chào shop, mình cần tư vấn thêm về chế độ bảo hành 24 tháng', N'Nguy?n Van A', N'CUSTOMER', NULL, '2026-09-13 02:04:26.807', 1);
INSERT INTO [dbo].[tin_nhan] ([id], [da_doc], [noi_dung], [sender_name], [sender_role], [session_guest_id], [thoi_gian], [khach_hang_id]) VALUES (26, 1, N'🛡️ **Chính sách bảo hành & Đổi trả**:
• **Đổi mới 1-1** trong 7 ngày nếu lỗi từ nhà sản xuất hoặc đội không vừa size (giữ nguyên tem mác).
• **Bảo hành chính hãng** 12 - 24 tháng cho chốt khóa, kính chắn gió và kết cấu nón.
• Để yêu cầu đổi hàng nhanh, bạn chỉ cần gửi mã đơn hàng tại đây nhé!', N'Tr? lý Shop', N'BOT', NULL, '2026-09-13 02:04:27.415', 1);
INSERT INTO [dbo].[tin_nhan] ([id], [da_doc], [noi_dung], [sender_name], [sender_role], [session_guest_id], [thoi_gian], [khach_hang_id]) VALUES (27, 1, N'Dạ shop chào bạn! Mọi sản phẩm mũ tại shop đều được bảo hành chính hãng 24 tháng và đổi mới 7 ngày nếu không vừa size nhé ạ.', N'admin', N'ADMIN', NULL, '2026-09-13 02:04:28.704', 1);
SET IDENTITY_INSERT [dbo].[tin_nhan] OFF;
GO

-- ----------------------------------------------------------
-- Re-enable Constraints
-- ----------------------------------------------------------
EXEC sp_MSforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL';
GO

PRINT 'DATABASE RESTORE COMPLETED SUCCESSFULLY!';
GO
