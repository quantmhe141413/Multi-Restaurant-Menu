USE [MultiRestaurantOrderingDB]
GO

-- =============================================
-- Sample Data Insert Script
-- Multi-Restaurant Ordering Database
-- =============================================

SET IDENTITY_INSERT [dbo].[Roles] ON
GO

-- Insert Roles (if not already exists)
IF NOT EXISTS (SELECT 1 FROM [dbo].[Roles] WHERE [RoleID] = 1)
    INSERT INTO [dbo].[Roles] ([RoleID], [RoleName]) VALUES (1, N'SuperAdmin')
IF NOT EXISTS (SELECT 1 FROM [dbo].[Roles] WHERE [RoleID] = 2)
    INSERT INTO [dbo].[Roles] ([RoleID], [RoleName]) VALUES (2, N'Owner')
IF NOT EXISTS (SELECT 1 FROM [dbo].[Roles] WHERE [RoleID] = 3)
    INSERT INTO [dbo].[Roles] ([RoleID], [RoleName]) VALUES (3, N'Staff')
IF NOT EXISTS (SELECT 1 FROM [dbo].[Roles] WHERE [RoleID] = 4)
    INSERT INTO [dbo].[Roles] ([RoleID], [RoleName]) VALUES (4, N'Customer')
GO

SET IDENTITY_INSERT [dbo].[Roles] OFF
GO

SET IDENTITY_INSERT [dbo].[Users] ON
GO

-- Insert Users
INSERT INTO [dbo].[Users] ([UserID], [FullName], [Email], [PasswordHash], [Phone], [RoleID], [IsActive], [CreatedAt])
VALUES
    (6, N'Nguyễn Văn An', N'nguyenvanan@email.com', N'$2a$10$hashedpassword1', N'0912345678', 4, 1, GETDATE()),
    (7, N'Trần Thị Bình', N'tranthibinh@email.com', N'$2a$10$hashedpassword2', N'0923456789', 4, 1, GETDATE()),
    (8, N'Lê Văn Cường', N'levancuong@email.com', N'$2a$10$hashedpassword3', N'0934567890', 4, 1, GETDATE()),
    (9, N'Phạm Thị Dung', N'phamthidung@email.com', N'$2a$10$hashedpassword4', N'0945678901', 4, 1, GETDATE()),
    (10, N'Hoàng Văn Em', N'hoangvanem@email.com', N'$2a$10$hashedpassword5', N'0956789012', 4, 1, GETDATE()),
    (11, N'Vũ Thị Phương', N'vuthiphuong@email.com', N'$2a$10$hashedpassword6', N'0967890123', 4, 1, GETDATE()),
    (12, N'Đỗ Văn Giang', N'dovangiang@email.com', N'$2a$10$hashedpassword7', N'0978901234', 4, 1, GETDATE()),
    (13, N'Bùi Thị Hoa', N'buithihoa@email.com', N'$2a$10$hashedpassword8', N'0989012345', 4, 1, GETDATE()),
    (14, N'Nguyễn Văn Hùng', N'nguyenvanhung@email.com', N'$2a$10$hashedpassword9', N'0990123456', 4, 1, GETDATE()),
    (15, N'Trần Văn Khoa', N'tranvankhoa@email.com', N'$2a$10$hashedpassword10', N'0901234567', 4, 1, GETDATE()),
    -- Staff Users
    (16, N'Lê Thị Lan', N'lethilan@staff.com', N'$2a$10$hashedpassword11', N'0911111111', 3, 1, GETDATE()),
    (17, N'Phạm Văn Minh', N'phamvanminh@staff.com', N'$2a$10$hashedpassword12', N'0922222222', 3, 1, GETDATE()),
    (18, N'Hoàng Thị Nga', N'hoangthinga@staff.com', N'$2a$10$hashedpassword13', N'0933333333', 3, 1, GETDATE()),
    (19, N'Vũ Văn Oanh', N'vuvanoanh@staff.com', N'$2a$10$hashedpassword14', N'0944444444', 3, 1, GETDATE()),
    (20, N'Đỗ Thị Phượng', N'dothiphuong@staff.com', N'$2a$10$hashedpassword15', N'0955555555', 3, 1, GETDATE())
GO

SET IDENTITY_INSERT [dbo].[Users] OFF
GO

SET IDENTITY_INSERT [dbo].[Restaurants] ON
GO

-- Insert More Restaurants
INSERT INTO [dbo].[Restaurants] ([RestaurantID], [OwnerID], [Name], [Address], [LicenseNumber], [LogoUrl], [ThemeColor], [IsOpen], [DeliveryFee], [CommissionRate], [Status], [CreatedAt])
VALUES
    (5, 3, N'Pizza Hut Việt Nam', N'123 Nguyễn Huệ, Quận 1, TP.HCM', N'LIC-005-2026', NULL, N'#FF0000', 1, CAST(25000.00 AS Decimal(10, 2)), CAST(12.00 AS Decimal(5, 2)), N'Approved', GETDATE()),
    (6, 3, N'KFC Việt Nam', N'456 Lê Lợi, Quận 1, TP.HCM', N'LIC-006-2026', NULL, N'#FF6600', 1, CAST(20000.00 AS Decimal(10, 2)), CAST(11.00 AS Decimal(5, 2)), N'Approved', GETDATE()),
    (7, 4, N'Highlands Coffee', N'789 Điện Biên Phủ, Quận Bình Thạnh, TP.HCM', N'LIC-007-2026', NULL, N'#8B4513', 1, CAST(15000.00 AS Decimal(10, 2)), CAST(10.00 AS Decimal(5, 2)), N'Approved', GETDATE()),
    (8, 4, N'Bánh Mì Huỳnh Hoa', N'26 Lê Thị Riêng, Quận 1, TP.HCM', N'LIC-008-2026', NULL, N'#FFD700', 1, CAST(10000.00 AS Decimal(10, 2)), CAST(8.00 AS Decimal(5, 2)), N'Approved', GETDATE()),
    (9, 3, N'Phở 24', N'321 Nguyễn Trãi, Quận 5, TP.HCM', N'LIC-009-2026', NULL, N'#228B22', 1, CAST(18000.00 AS Decimal(10, 2)), CAST(9.00 AS Decimal(5, 2)), N'Approved', GETDATE()),
    (10, 4, N'Bún Bò Huế', N'654 Võ Văn Tần, Quận 3, TP.HCM', N'LIC-010-2026', NULL, N'#DC143C', 1, CAST(12000.00 AS Decimal(10, 2)), CAST(8.50 AS Decimal(5, 2)), N'Approved', GETDATE())
GO

SET IDENTITY_INSERT [dbo].[Restaurants] OFF
GO

SET IDENTITY_INSERT [dbo].[MenuCategories] ON
GO

-- Insert Menu Categories for each restaurant
INSERT INTO [dbo].[MenuCategories] ([CategoryID], [RestaurantID], [CategoryName], [DisplayOrder], [IsActive])
VALUES
    -- Restaurant 2 (Phở Hà Nội)
    (1, 2, N'Phở', 1, 1),
    (2, 2, N'Bún', 2, 1),
    (3, 2, N'Đồ Uống', 3, 1),
    -- Restaurant 3 (Bún Bò Huế Ngon)
    (4, 3, N'Bún Bò Huế', 1, 1),
    (5, 3, N'Bún Riêu', 2, 1),
    (6, 3, N'Đồ Uống', 3, 1),
    -- Restaurant 4 (Cơm Tấm Sài Gòn)
    (7, 4, N'Cơm Tấm', 1, 1),
    (8, 4, N'Cơm Gà', 2, 1),
    (9, 4, N'Canh Chua', 3, 1),
    (10, 4, N'Đồ Uống', 4, 1),
    -- Restaurant 5 (Pizza Hut)
    (11, 5, N'Pizza', 1, 1),
    (12, 5, N'Pasta', 2, 1),
    (13, 5, N'Salad', 3, 1),
    (14, 5, N'Đồ Uống', 4, 1),
    -- Restaurant 6 (KFC)
    (15, 6, N'Gà Rán', 1, 1),
    (16, 6, N'Burger', 2, 1),
    (17, 6, N'Khoai Tây', 3, 1),
    (18, 6, N'Đồ Uống', 4, 1),
    -- Restaurant 7 (Highlands Coffee)
    (19, 7, N'Cà Phê', 1, 1),
    (20, 7, N'Trà', 2, 1),
    (21, 7, N'Bánh Ngọt', 3, 1),
    (22, 7, N'Nước Ép', 4, 1),
    -- Restaurant 8 (Bánh Mì)
    (23, 8, N'Bánh Mì', 1, 1),
    (24, 8, N'Bánh Mì Kẹp', 2, 1),
    (25, 8, N'Đồ Uống', 3, 1),
    -- Restaurant 9 (Phở 24)
    (26, 9, N'Phở', 1, 1),
    (27, 9, N'Bún', 2, 1),
    (28, 9, N'Đồ Uống', 3, 1),
    -- Restaurant 10 (Bún Bò Huế)
    (29, 10, N'Bún Bò Huế', 1, 1),
    (30, 10, N'Bún Bò Giò Heo', 2, 1),
    (31, 10, N'Đồ Uống', 3, 1)
GO

SET IDENTITY_INSERT [dbo].[MenuCategories] OFF
GO

SET IDENTITY_INSERT [dbo].[MenuItems] ON
GO

-- Insert Menu Items
INSERT INTO [dbo].[MenuItems] ([ItemID], [RestaurantID], [CategoryID], [SKU], [ItemName], [Description], [Price], [IsAvailable], [CreatedAt])
VALUES
    -- Restaurant 2 - Phở Hà Nội
    (1, 2, 1, N'PHO-001', N'Phở Bò Tái', N'Phở bò tái thơm ngon, nước dùng đậm đà', CAST(75000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (2, 2, 1, N'PHO-002', N'Phở Bò Chín', N'Phở bò chín mềm, nước dùng ngọt thanh', CAST(70000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (3, 2, 1, N'PHO-003', N'Phở Bò Tái Chín', N'Phở bò tái chín kết hợp', CAST(80000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (4, 2, 2, N'BUN-001', N'Bún Chả', N'Bún chả Hà Nội đặc trưng', CAST(65000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (5, 2, 3, N'DRINK-001', N'Nước Ngọt', N'Coca, Pepsi, 7Up', CAST(15000.00 AS Decimal(10, 2)), 1, GETDATE()),
    
    -- Restaurant 3 - Bún Bò Huế Ngon
    (6, 3, 4, N'BBH-001', N'Bún Bò Huế Đặc Biệt', N'Bún bò Huế đầy đủ thịt bò, giò heo, chả', CAST(85000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (7, 3, 4, N'BBH-002', N'Bún Bò Huế Thường', N'Bún bò Huế thường', CAST(65000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (8, 3, 5, N'BR-001', N'Bún Riêu Cua', N'Bún riêu cua chua ngọt', CAST(60000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (9, 3, 6, N'DRINK-002', N'Chè Đậu Xanh', N'Chè đậu xanh mát lạnh', CAST(20000.00 AS Decimal(10, 2)), 1, GETDATE()),
    
    -- Restaurant 4 - Cơm Tấm Sài Gòn
    (10, 4, 7, N'COM-001', N'Cơm Tấm Sườn Nướng', N'Cơm tấm sườn nướng thơm lừng', CAST(75000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (11, 4, 7, N'COM-002', N'Cơm Tấm Chả Trứng', N'Cơm tấm chả trứng đặc biệt', CAST(70000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (12, 4, 8, N'COM-003', N'Cơm Gà Nướng', N'Cơm gà nướng mật ong', CAST(80000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (13, 4, 9, N'CANH-001', N'Canh Chua Cá Lóc', N'Canh chua cá lóc chua ngọt', CAST(90000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (14, 4, 10, N'DRINK-003', N'Nước Dừa Tươi', N'Nước dừa tươi mát lạnh', CAST(25000.00 AS Decimal(10, 2)), 1, GETDATE()),
    
    -- Restaurant 5 - Pizza Hut
    (15, 5, 11, N'PIZZA-001', N'Pizza Hải Sản', N'Pizza hải sản đầy đủ tôm, mực, cua', CAST(250000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (16, 5, 11, N'PIZZA-002', N'Pizza Pepperoni', N'Pizza pepperoni phô mai đầy đủ', CAST(220000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (17, 5, 11, N'PIZZA-003', N'Pizza Margherita', N'Pizza margherita cổ điển', CAST(180000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (18, 5, 12, N'PASTA-001', N'Spaghetti Carbonara', N'Spaghetti carbonara kem béo', CAST(150000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (19, 5, 13, N'SALAD-001', N'Salad Caesar', N'Salad caesar tươi ngon', CAST(120000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (20, 5, 14, N'DRINK-004', N'Coca Cola', N'Coca cola lạnh', CAST(30000.00 AS Decimal(10, 2)), 1, GETDATE()),
    
    -- Restaurant 6 - KFC
    (21, 6, 15, N'CHICKEN-001', N'Gà Rán Giòn', N'Gà rán giòn cay', CAST(89000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (22, 6, 15, N'CHICKEN-002', N'Gà Rán Không Xương', N'Gà rán không xương tiện lợi', CAST(95000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (23, 6, 16, N'BURGER-001', N'Burger Gà', N'Burger gà giòn cay', CAST(85000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (24, 6, 17, N'FRIES-001', N'Khoai Tây Chiên', N'Khoai tây chiên giòn', CAST(35000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (25, 6, 18, N'DRINK-005', N'Pepsi', N'Pepsi lạnh', CAST(25000.00 AS Decimal(10, 2)), 1, GETDATE()),
    
    -- Restaurant 7 - Highlands Coffee
    (26, 7, 19, N'COFFEE-001', N'Cà Phê Đen', N'Cà phê đen đậm đà', CAST(35000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (27, 7, 19, N'COFFEE-002', N'Cà Phê Sữa', N'Cà phê sữa ngọt ngào', CAST(40000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (28, 7, 19, N'COFFEE-003', N'Cappuccino', N'Cappuccino thơm béo', CAST(55000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (29, 7, 20, N'TEA-001', N'Trà Đào', N'Trà đào mát lạnh', CAST(45000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (30, 7, 21, N'CAKE-001', N'Bánh Tiramisu', N'Bánh tiramisu Ý', CAST(65000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (31, 7, 22, N'JUICE-001', N'Nước Ép Cam', N'Nước ép cam tươi', CAST(50000.00 AS Decimal(10, 2)), 1, GETDATE()),
    
    -- Restaurant 8 - Bánh Mì
    (32, 8, 23, N'BM-001', N'Bánh Mì Thịt Nướng', N'Bánh mì thịt nướng đặc biệt', CAST(35000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (33, 8, 23, N'BM-002', N'Bánh Mì Pate', N'Bánh mì pate truyền thống', CAST(30000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (34, 8, 24, N'BM-003', N'Bánh Mì Kẹp Thịt', N'Bánh mì kẹp thịt đầy đủ', CAST(40000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (35, 8, 25, N'DRINK-006', N'Sữa Đậu Nành', N'Sữa đậu nành nóng', CAST(15000.00 AS Decimal(10, 2)), 1, GETDATE()),
    
    -- Restaurant 9 - Phở 24
    (36, 9, 26, N'PHO24-001', N'Phở Bò Tái', N'Phở bò tái thơm ngon', CAST(70000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (37, 9, 26, N'PHO24-002', N'Phở Gà', N'Phở gà nóng hổi', CAST(65000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (38, 9, 27, N'BUN24-001', N'Bún Bò', N'Bún bò Huế cay nồng', CAST(70000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (39, 9, 28, N'DRINK-007', N'Trà Đá', N'Trà đá mát lạnh', CAST(10000.00 AS Decimal(10, 2)), 1, GETDATE()),
    
    -- Restaurant 10 - Bún Bò Huế
    (40, 10, 29, N'BBH10-001', N'Bún Bò Huế Đặc Biệt', N'Bún bò Huế đầy đủ', CAST(80000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (41, 10, 29, N'BBH10-002', N'Bún Bò Huế Thường', N'Bún bò Huế thường', CAST(60000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (42, 10, 30, N'BBH10-003', N'Bún Bò Giò Heo', N'Bún bò giò heo đặc biệt', CAST(75000.00 AS Decimal(10, 2)), 1, GETDATE()),
    (43, 10, 31, N'DRINK-008', N'Nước Sâm', N'Nước sâm mát lạnh', CAST(20000.00 AS Decimal(10, 2)), 1, GETDATE())
GO

SET IDENTITY_INSERT [dbo].[MenuItems] OFF
GO

SET IDENTITY_INSERT [dbo].[ItemOptions] ON
GO

-- Insert Item Options
INSERT INTO [dbo].[ItemOptions] ([OptionID], [ItemID], [OptionName], [AdditionalPrice], [IsActive])
VALUES
    -- Pizza Options
    (1, 15, N'Size Lớn (+50k)', CAST(50000.00 AS Decimal(10, 2)), 1),
    (2, 15, N'Thêm Phô Mai (+30k)', CAST(30000.00 AS Decimal(10, 2)), 1),
    (3, 16, N'Size Lớn (+50k)', CAST(50000.00 AS Decimal(10, 2)), 1),
    (4, 17, N'Size Lớn (+50k)', CAST(50000.00 AS Decimal(10, 2)), 1),
    -- Coffee Options
    (5, 26, N'Đá (+5k)', CAST(5000.00 AS Decimal(10, 2)), 1),
    (6, 27, N'Đá (+5k)', CAST(5000.00 AS Decimal(10, 2)), 1),
    (7, 28, N'Size Lớn (+10k)', CAST(10000.00 AS Decimal(10, 2)), 1),
    -- Phở Options
    (8, 1, N'Thêm Bánh Phở (+10k)', CAST(10000.00 AS Decimal(10, 2)), 1),
    (9, 1, N'Thêm Thịt Bò (+20k)', CAST(20000.00 AS Decimal(10, 2)), 1),
    (10, 3, N'Thêm Bánh Phở (+10k)', CAST(10000.00 AS Decimal(10, 2)), 1),
    -- Bánh Mì Options
    (11, 32, N'Thêm Pate (+5k)', CAST(5000.00 AS Decimal(10, 2)), 1),
    (12, 32, N'Thêm Thịt (+10k)', CAST(10000.00 AS Decimal(10, 2)), 1),
    (13, 33, N'Thêm Trứng (+5k)', CAST(5000.00 AS Decimal(10, 2)), 1)
GO

SET IDENTITY_INSERT [dbo].[ItemOptions] OFF
GO

SET IDENTITY_INSERT [dbo].[RestaurantTables] ON
GO

-- Insert Restaurant Tables
INSERT INTO [dbo].[RestaurantTables] ([TableID], [RestaurantID], [TableNumber], [Capacity], [TableStatus], [IsActive])
VALUES
    -- Restaurant 2
    (1, 2, N'T1', 4, N'Available', 1),
    (2, 2, N'T2', 4, N'Available', 1),
    (3, 2, N'T3', 6, N'Available', 1),
    (4, 2, N'T4', 2, N'Available', 1),
    -- Restaurant 3
    (5, 3, N'T1', 4, N'Available', 1),
    (6, 3, N'T2', 4, N'Available', 1),
    (7, 3, N'T3', 8, N'Available', 1),
    -- Restaurant 4
    (8, 4, N'T1', 4, N'Available', 1),
    (9, 4, N'T2', 6, N'Available', 1),
    (10, 4, N'T3', 4, N'Available', 1),
    (11, 4, N'T4', 2, N'Available', 1),
    -- Restaurant 5
    (12, 5, N'T1', 4, N'Available', 1),
    (13, 5, N'T2', 6, N'Available', 1),
    (14, 5, N'T3', 8, N'Available', 1),
    (15, 5, N'T4', 2, N'Available', 1),
    -- Restaurant 6
    (16, 6, N'T1', 4, N'Available', 1),
    (17, 6, N'T2', 4, N'Available', 1),
    (18, 6, N'T3', 6, N'Available', 1)
GO

SET IDENTITY_INSERT [dbo].[RestaurantTables] OFF
GO

SET IDENTITY_INSERT [dbo].[RestaurantDeliveryZones] ON
GO

-- Insert Delivery Zones
INSERT INTO [dbo].[RestaurantDeliveryZones] ([ZoneID], [RestaurantID], [ZoneName], [ZoneDefinition], [IsActive], [CreatedAt])
VALUES
    (13, 2, N'Quận 1', N'Toàn bộ Quận 1', 1, GETDATE()),
    (14, 2, N'Quận 3', N'Toàn bộ Quận 3', 1, GETDATE()),
    (15, 3, N'Quận 1', N'Toàn bộ Quận 1', 1, GETDATE()),
    (16, 3, N'Quận 5', N'Toàn bộ Quận 5', 1, GETDATE()),
    (17, 4, N'Quận 1', N'Toàn bộ Quận 1', 1, GETDATE()),
    (18, 4, N'Quận 3', N'Toàn bộ Quận 3', 1, GETDATE()),
    (19, 5, N'Quận 1', N'Toàn bộ Quận 1', 1, GETDATE()),
    (20, 5, N'Quận 2', N'Toàn bộ Quận 2', 1, GETDATE()),
    (21, 5, N'Quận 3', N'Toàn bộ Quận 3', 1, GETDATE()),
    (22, 6, N'Quận 1', N'Toàn bộ Quận 1', 1, GETDATE()),
    (23, 6, N'Quận 7', N'Toàn bộ Quận 7', 1, GETDATE()),
    (24, 7, N'Quận Bình Thạnh', N'Toàn bộ Quận Bình Thạnh', 1, GETDATE()),
    (25, 7, N'Quận 1', N'Toàn bộ Quận 1', 1, GETDATE()),
    (26, 8, N'Quận 1', N'Toàn bộ Quận 1', 1, GETDATE()),
    (27, 9, N'Quận 5', N'Toàn bộ Quận 5', 1, GETDATE()),
    (28, 10, N'Quận 3', N'Toàn bộ Quận 3', 1, GETDATE())
GO

SET IDENTITY_INSERT [dbo].[RestaurantDeliveryZones] OFF
GO

SET IDENTITY_INSERT [dbo].[DeliveryFees] ON
GO

-- Insert Delivery Fees
INSERT INTO [dbo].[DeliveryFees] ([FeeID], [ZoneID], [FeeType], [FeeValue], [MinOrderAmount], [MaxOrderAmount], [IsActive], [CreatedAt])
VALUES
    (4, 13, N'Flat', CAST(20000.00 AS Decimal(10, 2)), NULL, NULL, 1, GETDATE()),
    (5, 14, N'Flat', CAST(25000.00 AS Decimal(10, 2)), NULL, NULL, 1, GETDATE()),
    (6, 15, N'Flat', CAST(18000.00 AS Decimal(10, 2)), NULL, NULL, 1, GETDATE()),
    (7, 16, N'Flat', CAST(20000.00 AS Decimal(10, 2)), NULL, NULL, 1, GETDATE()),
    (8, 17, N'FreeAboveAmount', CAST(0.00 AS Decimal(10, 2)), CAST(200000.00 AS Decimal(10, 2)), NULL, 1, GETDATE()),
    (9, 18, N'Flat', CAST(22000.00 AS Decimal(10, 2)), NULL, NULL, 1, GETDATE()),
    (10, 19, N'Flat', CAST(30000.00 AS Decimal(10, 2)), NULL, NULL, 1, GETDATE()),
    (11, 20, N'Flat', CAST(35000.00 AS Decimal(10, 2)), NULL, NULL, 1, GETDATE()),
    (12, 21, N'Flat', CAST(30000.00 AS Decimal(10, 2)), NULL, NULL, 1, GETDATE()),
    (13, 22, N'Flat', CAST(25000.00 AS Decimal(10, 2)), NULL, NULL, 1, GETDATE()),
    (14, 23, N'Flat', CAST(30000.00 AS Decimal(10, 2)), NULL, NULL, 1, GETDATE()),
    (15, 24, N'Flat', CAST(15000.00 AS Decimal(10, 2)), NULL, NULL, 1, GETDATE()),
    (16, 25, N'Flat', CAST(20000.00 AS Decimal(10, 2)), NULL, NULL, 1, GETDATE()),
    (17, 26, N'Flat', CAST(10000.00 AS Decimal(10, 2)), NULL, NULL, 1, GETDATE()),
    (18, 27, N'Flat', CAST(18000.00 AS Decimal(10, 2)), NULL, NULL, 1, GETDATE()),
    (19, 28, N'Flat', CAST(12000.00 AS Decimal(10, 2)), NULL, NULL, 1, GETDATE())
GO

SET IDENTITY_INSERT [dbo].[DeliveryFees] OFF
GO

SET IDENTITY_INSERT [dbo].[Discounts] ON
GO

-- Insert Discounts
INSERT INTO [dbo].[Discounts] ([DiscountID], [RestaurantID], [Code], [DiscountType], [DiscountValue], [ExpiryDate], [IsActive], [CreatedAt])
VALUES
    (1, 2, N'WELCOME10', N'Percentage', CAST(10.00 AS Decimal(10, 2)), DATEADD(day, 30, GETDATE()), 1, GETDATE()),
    (2, 2, N'NEWUSER20', N'Percentage', CAST(20.00 AS Decimal(10, 2)), DATEADD(day, 60, GETDATE()), 1, GETDATE()),
    (3, 3, N'FIRST15', N'Percentage', CAST(15.00 AS Decimal(10, 2)), DATEADD(day, 45, GETDATE()), 1, GETDATE()),
    (4, 4, N'SAVE50K', N'Fixed', CAST(50000.00 AS Decimal(10, 2)), DATEADD(day, 30, GETDATE()), 1, GETDATE()),
    (5, 5, N'PIZZA30', N'Percentage', CAST(30.00 AS Decimal(10, 2)), DATEADD(day, 15, GETDATE()), 1, GETDATE()),
    (6, 5, N'FREESHIP', N'Fixed', CAST(25000.00 AS Decimal(10, 2)), DATEADD(day, 20, GETDATE()), 1, GETDATE()),
    (7, 6, N'CHICKEN20', N'Percentage', CAST(20.00 AS Decimal(10, 2)), DATEADD(day, 30, GETDATE()), 1, GETDATE()),
    (8, 7, N'COFFEE25', N'Percentage', CAST(25.00 AS Decimal(10, 2)), DATEADD(day, 25, GETDATE()), 1, GETDATE()),
    (9, 8, N'BANHMI5K', N'Fixed', CAST(5000.00 AS Decimal(10, 2)), DATEADD(day, 60, GETDATE()), 1, GETDATE()),
    (10, NULL, N'SYSTEM10', N'Percentage', CAST(10.00 AS Decimal(10, 2)), DATEADD(day, 90, GETDATE()), 1, GETDATE())
GO

SET IDENTITY_INSERT [dbo].[Discounts] OFF
GO

SET IDENTITY_INSERT [dbo].[Orders] ON
GO

-- Insert Orders (with new payment fields)
INSERT INTO [dbo].[Orders] ([OrderID], [RestaurantID], [CustomerID], [OrderType], [TableID], [OrderStatus], [DiscountID], [TotalAmount], [DiscountAmount], [DeliveryFee], [FinalAmount], [PaymentMethod], [PaymentStatus], [PaidAt], [IsClosed], [CreatedAt])
VALUES
    (1, 2, 6, N'Online', NULL, N'Completed', 1, CAST(150000.00 AS Decimal(10, 2)), CAST(15000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(135000.00 AS Decimal(10, 2)), N'VNPay', N'Paid', DATEADD(day, -5, GETDATE()), 1, DATEADD(day, -5, GETDATE())),
    (2, 3, 7, N'Online', NULL, N'Completed', NULL, CAST(130000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(130000.00 AS Decimal(10, 2)), N'VNPay', N'Paid', DATEADD(day, -4, GETDATE()), 1, DATEADD(day, -4, GETDATE())),
    (3, 4, 8, N'DineIn', 8, N'Completed', NULL, CAST(150000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(150000.00 AS Decimal(10, 2)), N'Cash', N'Paid', DATEADD(day, -3, GETDATE()), 1, DATEADD(day, -3, GETDATE())),
    (4, 5, 9, N'Online', NULL, N'Delivering', 5, CAST(500000.00 AS Decimal(10, 2)), CAST(150000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(350000.00 AS Decimal(10, 2)), N'VNPay', N'Paid', DATEADD(day, -2, GETDATE()), 0, DATEADD(day, -2, GETDATE())),
    (5, 6, 10, N'Pickup', NULL, N'Preparing', NULL, CAST(178000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(178000.00 AS Decimal(10, 2)), N'COD', N'Pending', NULL, 0, DATEADD(day, -1, GETDATE())),
    (6, 7, 11, N'Online', NULL, N'Completed', 8, CAST(90000.00 AS Decimal(10, 2)), CAST(22500.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(67500.00 AS Decimal(10, 2)), N'VNPay', N'Paid', DATEADD(hour, -3, GETDATE()), 1, DATEADD(hour, -3, GETDATE())),
    (7, 8, 12, N'Pickup', NULL, N'Completed', 9, CAST(70000.00 AS Decimal(10, 2)), CAST(5000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(65000.00 AS Decimal(10, 2)), N'Cash', N'Paid', DATEADD(hour, -2, GETDATE()), 1, DATEADD(hour, -2, GETDATE())),
    (8, 2, 13, N'DineIn', 1, N'Preparing', NULL, CAST(160000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(160000.00 AS Decimal(10, 2)), N'Cash', N'Pending', NULL, 0, DATEADD(hour, -1, GETDATE())),
    (9, 3, 14, N'Online', NULL, N'Delivering', NULL, CAST(145000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(145000.00 AS Decimal(10, 2)), N'VNPay', N'Paid', GETDATE(), 0, GETDATE()),
    (10, 4, 15, N'Online', NULL, N'Preparing', 4, CAST(200000.00 AS Decimal(10, 2)), CAST(50000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(150000.00 AS Decimal(10, 2)), N'COD', N'Pending', NULL, 0, GETDATE())
GO

SET IDENTITY_INSERT [dbo].[Orders] OFF
GO

SET IDENTITY_INSERT [dbo].[OrderItems] ON
GO

-- Insert Order Items
INSERT INTO [dbo].[OrderItems] ([OrderItemID], [OrderID], [ItemID], [Quantity], [UnitPrice], [Note], [CreatedAt])
VALUES
    -- Order 1
    (1, 1, 1, 2, CAST(75000.00 AS Decimal(10, 2)), N'Không hành', GETDATE()),
    -- Order 2
    (2, 2, 6, 1, CAST(85000.00 AS Decimal(10, 2)), N'Cay vừa', GETDATE()),
    (3, 2, 8, 1, CAST(60000.00 AS Decimal(10, 2)), NULL, GETDATE()),
    -- Order 3
    (4, 3, 10, 2, CAST(75000.00 AS Decimal(10, 2)), NULL, GETDATE()),
    -- Order 4
    (5, 4, 15, 1, CAST(250000.00 AS Decimal(10, 2)), N'Size lớn, thêm phô mai', GETDATE()),
    (6, 4, 18, 1, CAST(150000.00 AS Decimal(10, 2)), NULL, GETDATE()),
    (7, 4, 20, 2, CAST(30000.00 AS Decimal(10, 2)), NULL, GETDATE()),
    -- Order 5
    (8, 5, 21, 2, CAST(89000.00 AS Decimal(10, 2)), NULL, GETDATE()),
    -- Order 6
    (9, 6, 26, 1, CAST(35000.00 AS Decimal(10, 2)), N'Đá', GETDATE()),
    (10, 6, 28, 1, CAST(55000.00 AS Decimal(10, 2)), NULL, GETDATE()),
    -- Order 7
    (11, 7, 32, 2, CAST(35000.00 AS Decimal(10, 2)), N'Thêm pate', GETDATE()),
    -- Order 8
    (12, 8, 1, 1, CAST(75000.00 AS Decimal(10, 2)), NULL, GETDATE()),
    (13, 8, 4, 1, CAST(65000.00 AS Decimal(10, 2)), NULL, GETDATE()),
    (14, 8, 5, 2, CAST(15000.00 AS Decimal(10, 2)), NULL, GETDATE()),
    -- Order 9
    (15, 9, 6, 1, CAST(85000.00 AS Decimal(10, 2)), NULL, GETDATE()),
    (16, 9, 7, 1, CAST(65000.00 AS Decimal(10, 2)), NULL, GETDATE()),
    -- Order 10
    (17, 10, 10, 1, CAST(75000.00 AS Decimal(10, 2)), NULL, GETDATE()),
    (18, 10, 12, 1, CAST(80000.00 AS Decimal(10, 2)), NULL, GETDATE()),
    (19, 10, 13, 1, CAST(90000.00 AS Decimal(10, 2)), NULL, GETDATE())
GO

SET IDENTITY_INSERT [dbo].[OrderItems] OFF
GO

SET IDENTITY_INSERT [dbo].[Payments] ON
GO

-- Insert Payments (with new schema)
INSERT INTO [dbo].[Payments] ([PaymentID], [OrderID], [CustomerID], [PaymentType], [PaymentStatus], [Amount], [TransactionRef], [BankCode], [CardType], [PayDate], [ResponseCode], [TransactionNo], [TransactionStatus], [SecureHash], [PaidAt], [CreatedAt])
VALUES
    -- VNPay payments (completed)
    (1, 1, 6, N'VNPay', N'Success', 13500000, N'ORDER1_12345678', N'NCB', N'ATM', N'20260128123045', N'00', N'14123456', N'00', N'a1b2c3d4e5f6...', DATEADD(day, -5, GETDATE()), DATEADD(day, -5, GETDATE())),
    (2, 2, 7, N'VNPay', N'Success', 13000000, N'ORDER2_23456789', N'BIDV', N'ATM', N'20260129143056', N'00', N'14234567', N'00', N'b2c3d4e5f6a7...', DATEADD(day, -4, GETDATE()), DATEADD(day, -4, GETDATE())),
    (3, 4, 9, N'VNPay', N'Success', 35000000, N'ORDER4_45678901', N'VCB', N'ATM', N'20260131183078', N'00', N'14456789', N'00', N'd4e5f6a7b8c9...', DATEADD(day, -2, GETDATE()), DATEADD(day, -2, GETDATE())),
    (4, 6, 11, N'VNPay', N'Success', 6750000, N'ORDER6_67890123', N'TCB', N'ATM', N'20260202093090', N'00', N'14678901', N'00', N'f6a7b8c9d0e1...', DATEADD(hour, -3, GETDATE()), DATEADD(hour, -3, GETDATE())),
    (5, 9, 14, N'VNPay', N'Success', 14500000, N'ORDER9_90123456', N'ACB', N'ATM', N'20260202153015', N'00', N'14901234', N'00', N'a7b8c9d0e1f2...', GETDATE(), GETDATE()),
    
    -- Cash payments
    (6, 3, 8, N'Cash', N'Success', 15000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, DATEADD(day, -3, GETDATE()), DATEADD(day, -3, GETDATE())),
    (7, 7, 12, N'Cash', N'Success', 6500000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, DATEADD(hour, -2, GETDATE()), DATEADD(hour, -2, GETDATE())),
    
    -- COD payments (pending)
    (8, 5, 10, N'COD', N'Pending', 17800000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, DATEADD(day, -1, GETDATE())),
    (9, 10, 15, N'COD', N'Pending', 15000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, GETDATE())
GO

SET IDENTITY_INSERT [dbo].[Payments] OFF
GO

SET IDENTITY_INSERT [dbo].[DeliveryInfo] ON
GO

-- Insert Delivery Info
INSERT INTO [dbo].[DeliveryInfo] ([DeliveryID], [OrderID], [ReceiverName], [Phone], [Address], [Latitude], [Longitude], [DeliveryNote], [DeliveryStatus], [ShippedAt], [DeliveredAt])
VALUES
    (1, 1, N'Nguyễn Văn An', N'0912345678', N'123 Nguyễn Huệ, Quận 1, TP.HCM', CAST(10.7769 AS Decimal(10, 6)), CAST(106.7009 AS Decimal(10, 6)), N'Giao vào buổi trưa', N'Delivered', DATEADD(day, -5, DATEADD(hour, 11, GETDATE())), DATEADD(day, -5, DATEADD(hour, 12, GETDATE()))),
    (2, 2, N'Trần Thị Bình', N'0923456789', N'456 Lê Lợi, Quận 1, TP.HCM', CAST(10.7756 AS Decimal(10, 6)), CAST(106.7019 AS Decimal(10, 6)), N'Gọi trước khi giao', N'Delivered', DATEADD(day, -4, DATEADD(hour, 14, GETDATE())), DATEADD(day, -4, DATEADD(hour, 15, GETDATE()))),
    (3, 4, N'Phạm Thị Dung', N'0945678901', N'789 Điện Biên Phủ, Quận Bình Thạnh, TP.HCM', CAST(10.8019 AS Decimal(10, 6)), CAST(106.7148 AS Decimal(10, 6)), NULL, N'OnTheWay', DATEADD(day, -2, DATEADD(hour, 18, GETDATE())), NULL),
    (4, 6, N'Vũ Thị Phương', N'0967890123', N'321 Nguyễn Trãi, Quận 5, TP.HCM', CAST(10.7540 AS Decimal(10, 6)), CAST(106.6697 AS Decimal(10, 6)), N'Giao nhanh', N'Delivered', DATEADD(hour, -3, DATEADD(minute, 30, GETDATE())), DATEADD(hour, -2, GETDATE())),
    (5, 9, N'Nguyễn Văn Hùng', N'0990123456', N'654 Võ Văn Tần, Quận 3, TP.HCM', CAST(10.7831 AS Decimal(10, 6)), CAST(106.6907 AS Decimal(10, 6)), NULL, N'Assigned', NULL, NULL),
    (6, 10, N'Trần Văn Khoa', N'0901234567', N'987 Cách Mạng Tháng 8, Quận 10, TP.HCM', CAST(10.7679 AS Decimal(10, 6)), CAST(106.6668 AS Decimal(10, 6)), N'Giao vào buổi tối', N'Assigned', NULL, NULL)
GO

SET IDENTITY_INSERT [dbo].[DeliveryInfo] OFF
GO

SET IDENTITY_INSERT [dbo].[Invoices] ON
GO

-- Insert Invoices
INSERT INTO [dbo].[Invoices] ([InvoiceID], [OrderID], [InvoiceNumber], [IssuedDate], [Subtotal], [TaxAmount], [FinalAmount])
VALUES
    (1, 1, N'INV-2026-0001', DATEADD(day, -5, GETDATE()), CAST(135000.00 AS Decimal(10, 2)), CAST(13500.00 AS Decimal(10, 2)), CAST(148500.00 AS Decimal(10, 2))),
    (2, 2, N'INV-2026-0002', DATEADD(day, -4, GETDATE()), CAST(130000.00 AS Decimal(10, 2)), CAST(13000.00 AS Decimal(10, 2)), CAST(143000.00 AS Decimal(10, 2))),
    (3, 3, N'INV-2026-0003', DATEADD(day, -3, GETDATE()), CAST(150000.00 AS Decimal(10, 2)), CAST(15000.00 AS Decimal(10, 2)), CAST(165000.00 AS Decimal(10, 2))),
    (4, 4, N'INV-2026-0004', DATEADD(day, -2, GETDATE()), CAST(350000.00 AS Decimal(10, 2)), CAST(35000.00 AS Decimal(10, 2)), CAST(385000.00 AS Decimal(10, 2))),
    (5, 6, N'INV-2026-0005', DATEADD(hour, -3, GETDATE()), CAST(67500.00 AS Decimal(10, 2)), CAST(6750.00 AS Decimal(10, 2)), CAST(74250.00 AS Decimal(10, 2))),
    (6, 7, N'INV-2026-0006', DATEADD(hour, -2, GETDATE()), CAST(65000.00 AS Decimal(10, 2)), CAST(6500.00 AS Decimal(10, 2)), CAST(71500.00 AS Decimal(10, 2)))
GO

SET IDENTITY_INSERT [dbo].[Invoices] OFF
GO

SET IDENTITY_INSERT [dbo].[Reviews] ON
GO

-- Insert Reviews
INSERT INTO [dbo].[Reviews] ([ReviewID], [RestaurantID], [CustomerID], [Rating], [Comment], [CreatedAt])
VALUES
    (1, 2, 6, 5, N'Phở rất ngon, nước dùng đậm đà!', DATEADD(day, -4, GETDATE())),
    (2, 3, 7, 4, N'Bún bò Huế cay vừa phải, ngon lắm', DATEADD(day, -3, GETDATE())),
    (3, 4, 8, 5, N'Cơm tấm ngon, giá cả hợp lý', DATEADD(day, -2, GETDATE())),
    (4, 5, 9, 4, N'Pizza ngon nhưng hơi đắt', DATEADD(day, -1, GETDATE())),
    (5, 6, 10, 5, N'Gà rán giòn, đúng vị KFC', DATEADD(day, -1, GETDATE())),
    (6, 7, 11, 5, N'Cà phê thơm ngon, không gian đẹp', DATEADD(hour, -2, GETDATE())),
    (7, 8, 12, 4, N'Bánh mì ngon, giá rẻ', DATEADD(hour, -1, GETDATE())),
    (8, 2, 13, 3, N'Phở ổn nhưng hơi nhạt', DATEADD(hour, -1, GETDATE())),
    (9, 3, 14, 5, N'Bún bò Huế đúng vị xứ Huế', GETDATE())
GO

SET IDENTITY_INSERT [dbo].[Reviews] OFF
GO

SET IDENTITY_INSERT [dbo].[Complaints] ON
GO

-- Insert Complaints
INSERT INTO [dbo].[Complaints] ([ComplaintID], [OrderID], [CustomerID], [Description], [Status], [CreatedAt])
VALUES
    (1, 1, 6, N'Giao hàng trễ 30 phút', N'Resolved', DATEADD(day, -4, GETDATE())),
    (2, 4, 9, N'Món ăn không đúng như mô tả', N'InProgress', DATEADD(day, -1, GETDATE())),
    (3, 5, 10, N'Thiếu đồ ăn trong đơn hàng', N'Open', DATEADD(hour, -2, GETDATE()))
GO

SET IDENTITY_INSERT [dbo].[Complaints] OFF
GO

SET IDENTITY_INSERT [dbo].[RestaurantUsers] ON
GO

-- Insert Restaurant Users (Staff assignments)
INSERT INTO [dbo].[RestaurantUsers] ([RestaurantUserID], [RestaurantID], [UserID], [RestaurantRole], [IsActive], [CreatedAt])
VALUES
    (1, 2, 16, N'Staff', 1, GETDATE()),
    (2, 2, 17, N'Manager', 1, GETDATE()),
    (3, 3, 18, N'Staff', 1, GETDATE()),
    (4, 4, 19, N'Staff', 1, GETDATE()),
    (5, 5, 20, N'Manager', 1, GETDATE()),
    (6, 5, 16, N'Staff', 1, GETDATE()),
    (7, 6, 17, N'Staff', 1, GETDATE()),
    (8, 7, 18, N'Staff', 1, GETDATE())
GO

SET IDENTITY_INSERT [dbo].[RestaurantUsers] OFF
GO

SET IDENTITY_INSERT [dbo].[EmployeeShifts] ON
GO

-- Insert Employee Shifts
INSERT INTO [dbo].[EmployeeShifts] ([ShiftID], [RestaurantID], [StaffID], [ShiftDate], [StartTime], [EndTime], [Position], [CreatedAt])
VALUES
    (1, 2, 16, CAST(GETDATE() AS Date), CAST('08:00:00' AS Time(7)), CAST('16:00:00' AS Time(7)), N'Phục Vụ', GETDATE()),
    (2, 2, 17, CAST(GETDATE() AS Date), CAST('09:00:00' AS Time(7)), CAST('17:00:00' AS Time(7)), N'Quản Lý', GETDATE()),
    (3, 3, 18, CAST(GETDATE() AS Date), CAST('10:00:00' AS Time(7)), CAST('18:00:00' AS Time(7)), N'Phục Vụ', GETDATE()),
    (4, 4, 19, CAST(GETDATE() AS Date), CAST('07:00:00' AS Time(7)), CAST('15:00:00' AS Time(7)), N'Bếp', GETDATE()),
    (5, 5, 20, CAST(GETDATE() AS Date), CAST('11:00:00' AS Time(7)), CAST('19:00:00' AS Time(7)), N'Quản Lý', GETDATE()),
    (6, 5, 16, CAST(GETDATE() AS Date), CAST('12:00:00' AS Time(7)), CAST('20:00:00' AS Time(7)), N'Phục Vụ', GETDATE()),
    (7, 6, 17, CAST(GETDATE() AS Date), CAST('08:30:00' AS Time(7)), CAST('16:30:00' AS Time(7)), N'Thu Ngân', GETDATE()),
    (8, 7, 18, CAST(GETDATE() AS Date), CAST('09:30:00' AS Time(7)), CAST('17:30:00' AS Time(7)), N'Barista', GETDATE())
GO

SET IDENTITY_INSERT [dbo].[EmployeeShifts] OFF
GO

SET IDENTITY_INSERT [dbo].[TableReservations] ON
GO

-- Insert Table Reservations
INSERT INTO [dbo].[TableReservations] ([ReservationID], [RestaurantID], [TableID], [CustomerID], [ReservationDate], [StartTime], [EndTime], [NumberOfGuests], [Status], [CreatedAt])
VALUES
    (1, 2, 1, 6, CAST(DATEADD(day, 1, GETDATE()) AS Date), CAST('18:00:00' AS Time(7)), CAST('20:00:00' AS Time(7)), 4, N'Confirmed', DATEADD(day, -1, GETDATE())),
    (2, 4, 8, 8, CAST(DATEADD(day, 2, GETDATE()) AS Date), CAST('19:00:00' AS Time(7)), CAST('21:00:00' AS Time(7)), 4, N'Pending', DATEADD(day, -1, GETDATE())),
    (3, 5, 12, 9, CAST(DATEADD(day, 3, GETDATE()) AS Date), CAST('18:30:00' AS Time(7)), CAST('20:30:00' AS Time(7)), 4, N'Confirmed', GETDATE()),
    (4, 2, 3, 13, CAST(DATEADD(day, 1, GETDATE()) AS Date), CAST('19:30:00' AS Time(7)), CAST('21:30:00' AS Time(7)), 6, N'Pending', GETDATE()),
    (5, 4, 9, 15, CAST(DATEADD(day, 4, GETDATE()) AS Date), CAST('20:00:00' AS Time(7)), CAST('22:00:00' AS Time(7)), 6, N'Confirmed', GETDATE())
GO

SET IDENTITY_INSERT [dbo].[TableReservations] OFF
GO

PRINT 'Sample data inserted successfully!'
GO
