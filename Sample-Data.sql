USE [MultiRestaurantOrderingDB]
GO

-----------------------------------------------------------------------
-- 1. CLEAN UP & RESET (Xóa sạch để ID bắt đầu từ 1)
-----------------------------------------------------------------------
DELETE FROM [dbo].[OrderItems]; DELETE FROM [dbo].[Orders];
DELETE FROM [dbo].[DeliveryInfo]; DELETE FROM [dbo].[Payments];
DELETE FROM [dbo].[Invoices]; DELETE FROM [dbo].[Reviews];
DELETE FROM [dbo].[TableReservations]; DELETE FROM [dbo].[EmployeeShifts];
DELETE FROM [dbo].[MenuItems]; DELETE FROM [dbo].[MenuCategories];
DELETE FROM [dbo].[BusinessHours]; DELETE FROM [dbo].[RestaurantTables];
DELETE FROM [dbo].[RestaurantUsers]; DELETE FROM [dbo].[Restaurants];
DELETE FROM [dbo].[Users]; DELETE FROM [dbo].[Roles];

DBCC CHECKIDENT ('[dbo].[Roles]', RESEED, 0);
DBCC CHECKIDENT ('[dbo].[Users]', RESEED, 0);
DBCC CHECKIDENT ('[dbo].[Restaurants]', RESEED, 0);
DBCC CHECKIDENT ('[dbo].[MenuCategories]', RESEED, 0);
DBCC CHECKIDENT ('[dbo].[MenuItems]', RESEED, 0);
DBCC CHECKIDENT ('[dbo].[Orders]', RESEED, 0);

-----------------------------------------------------------------------
-- 2. THIẾT LẬP ROLES (Cố định ID 1-4)
-----------------------------------------------------------------------
SET IDENTITY_INSERT [dbo].[Roles] ON;
INSERT INTO [dbo].[Roles] ([RoleID], [RoleName]) VALUES 
(1, N'SuperAdmin'), 
(2, N'Owner'), 
(3, N'Staff'), 
(4, N'Customer');
SET IDENTITY_INSERT [dbo].[Roles] OFF;

-----------------------------------------------------------------------
-- 3. KHỞI TẠO NGƯỜI DÙNG (Mật khẩu: 123)
-----------------------------------------------------------------------
INSERT INTO [dbo].[Users] ([FullName], [Email], [PasswordHash], [Phone], [RoleID], [IsActive]) VALUES 
(N'System Admin', 'admin@system.com', '123456', '0123456789', 1, 1),
(N'Manager', 'owner@restaurant.com', '123456', '0988888888', 2, 1),
(N'Staff Member', 'staff@restaurant.com', '123456', '0977777777', 3, 1),
(N'Customer', 'customer@gmail.com', '123456', '0966666666', 4, 1);

DECLARE @OwnerID INT = (SELECT UserID FROM Users WHERE RoleID = 2);
DECLARE @StaffID INT = (SELECT UserID FROM Users WHERE RoleID = 3);
DECLARE @CustomerID INT = (SELECT UserID FROM Users WHERE RoleID = 4);

-----------------------------------------------------------------------
-- 4. THÔNG TIN NHÀ HÀNG
-----------------------------------------------------------------------
INSERT INTO [dbo].[Restaurants] ([OwnerID], [Name], [Address], [Phone], [Description], [IsOpen], [Status], [DeliveryFee], [CommissionRate])
VALUES (@OwnerID, N'Cơm Niêu Việt', N'Số 1 Đại Cồ Việt, Hà Nội', '0988888888', N'Nhà hàng đặc sản cơm niêu', 1, 'Approved', 15000, 10);


DECLARE @RestID INT = SCOPE_IDENTITY();

-- Liên kết nhân viên vào nhà hàng
INSERT INTO [dbo].[RestaurantUsers] ([RestaurantID], [UserID], [RestaurantRole], [IsActive])
VALUES (@RestID, @StaffID, 'Staff', 1);

-----------------------------------------------------------------------
-- 5. THỰC ĐƠN (MENU)
-----------------------------------------------------------------------
INSERT INTO [dbo].[MenuCategories] ([RestaurantID], [CategoryName], [DisplayOrder], [IsActive]) VALUES 
(@RestID, N'Món Chính', 1, 1), 
(@RestID, N'Khai Vị', 2, 1);

DECLARE @CatID INT = (SELECT CategoryID FROM MenuCategories WHERE CategoryName = N'Món Chính');

INSERT INTO [dbo].[MenuItems] ([RestaurantID], [CategoryID], [SKU], [ItemName], [Description], [Price], [IsAvailable]) VALUES 
(@RestID, @CatID, 'CN-01', N'Cơm Niêu Sườn Kho', N'Sườn non kho tộ đậm đà', 75000, 1),
(@RestID, @CatID, 'CN-02', N'Cơm Niêu Cá Kho', N'Cá bống kho tiêu', 65000, 1);

-----------------------------------------------------------------------
-- 6. VẬN HÀNH (GIỜ MỞ CỬA & BÀN)
-----------------------------------------------------------------------
INSERT INTO [dbo].[RestaurantTables] ([RestaurantID], [TableNumber], [Capacity], [TableStatus], [IsActive]) 
VALUES (@RestID, 'V01', 4, 'Available', 1), (@RestID, 'V02', 2, 'Available', 1);

INSERT INTO [dbo].[BusinessHours] ([RestaurantID], [DayOfWeek], [OpeningTime], [ClosingTime], [IsOpen]) VALUES 
(@RestID, 'Monday', '09:00', '21:00', 1),
(@RestID, 'Tuesday', '09:00', '21:00', 1),
(@RestID, 'Wednesday', '09:00', '21:00', 1),
(@RestID, 'Thursday', '09:00', '21:00', 1),
(@RestID, 'Friday', '09:00', '22:00', 1),
(@RestID, 'Saturday', '08:00', '22:00', 1),
(@RestID, 'Sunday', '08:00', '22:00', 1);

-----------------------------------------------------------------------
-- 7. GIAO DỊCH MẪU (ORDER & DELIVERY)
-----------------------------------------------------------------------
INSERT INTO [dbo].[Orders] ([RestaurantID], [CustomerID], [OrderType], [OrderStatus], [TotalAmount], [DiscountAmount], [FinalAmount], [IsClosed], [DeliveryFee], [PaymentStatus])
VALUES (@RestID, @CustomerID, 'Online', 'Completed', 140000, 0, 155000, 1, 15000, 'Completed');

DECLARE @OrderID INT = SCOPE_IDENTITY();

INSERT INTO [dbo].[OrderItems] ([OrderID], [ItemID], [Quantity], [UnitPrice]) VALUES 
(@OrderID, (SELECT ItemID FROM MenuItems WHERE SKU='CN-01'), 1, 75000),
(@OrderID, (SELECT ItemID FROM MenuItems WHERE SKU='CN-02'), 1, 65000);

INSERT INTO [dbo].[DeliveryInfo] ([OrderID], [ReceiverName], [Phone], [Address], [DeliveryStatus])
VALUES (@OrderID, N'Customer', '0966666666', N'Hà Nội, Việt Nam', 'Delivered');

-----------------------------------------------------------------------
-- 8. ĐÁNH GIÁ (REVIEWS)
-----------------------------------------------------------------------
INSERT INTO [dbo].[Reviews] ([RestaurantID], [CustomerID], [Rating], [Comment])
VALUES (@RestID, @CustomerID, 5, N'Đồ ăn nóng hổi, cơm niêu rất ngon!');

PRINT '--- INIT DATA COMPLETED SUCCESSFULLY ---';
GO