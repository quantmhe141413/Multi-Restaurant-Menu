USE [MultiRestaurantOrderingDB]
GO

--------------------------------------------------
-- 1. USERS
--------------------------------------------------
INSERT INTO Users (FullName, Email, PasswordHash, Phone, RoleID, IsActive)
VALUES 
(N'Owner', 'owner@test.com', '123', '0900000001', 2, 1),
(N'Staff', 'staff@test.com', '123', '0900000002', 3, 1),
(N'Customer', 'customer@test.com', '123', '0900000003', 4, 1);

DECLARE @OwnerID INT = (SELECT TOP 1 UserID FROM Users WHERE RoleID = 2 ORDER BY UserID DESC);
DECLARE @StaffID INT = (SELECT TOP 1 UserID FROM Users WHERE RoleID = 3 ORDER BY UserID DESC);
DECLARE @CustomerID INT = (SELECT TOP 1 UserID FROM Users WHERE RoleID = 4 ORDER BY UserID DESC);

--------------------------------------------------
-- 2. RESTAURANT
--------------------------------------------------
INSERT INTO Restaurants (OwnerID, Name, Address, IsOpen, DeliveryFee, CommissionRate, Status)
VALUES (@OwnerID, N'Cơm Niêu Việt', N'Hà Nội', 1, 15000, 10, 'Approved');

DECLARE @RestID INT = SCOPE_IDENTITY();

--------------------------------------------------
-- 3. STAFF LINK
--------------------------------------------------
INSERT INTO RestaurantUsers (RestaurantID, UserID, RestaurantRole, IsActive)
VALUES (@RestID, @StaffID, 'Staff', 1);

--------------------------------------------------
-- 4. MENU
--------------------------------------------------
INSERT INTO MenuCategories (RestaurantID, CategoryName)
VALUES 
(@RestID, N'Món chính'),
(@RestID, N'Đồ uống');

DECLARE @CatID INT = (SELECT TOP 1 CategoryID FROM MenuCategories WHERE RestaurantID = @RestID);

INSERT INTO MenuItems (RestaurantID, CategoryID, SKU, ItemName, Description, Price, IsAvailable)
VALUES 
(@RestID, @CatID, 'CN-01', N'Cơm sườn', N'Ngon', 75000, 1),
(@RestID, @CatID, 'CN-02', N'Cơm cá', N'Ngon', 65000, 1);

--------------------------------------------------
-- 5. TABLE
--------------------------------------------------
INSERT INTO RestaurantTables (RestaurantID, TableNumber, Capacity)
VALUES 
(@RestID, 'T01', 4),
(@RestID, 'T02', 2);

--------------------------------------------------
-- 6. ORDER
--------------------------------------------------
INSERT INTO Orders 
(RestaurantID, CustomerID, OrderType, OrderStatus, TotalAmount, DiscountAmount, DeliveryFee, FinalAmount, PaymentStatus, IsClosed)
VALUES 
(@RestID, @CustomerID, 'Online', 'Completed', 140000, 0, 15000, 155000, 'Success', 1);

DECLARE @OrderID INT = SCOPE_IDENTITY();

--------------------------------------------------
-- 7. ORDER ITEMS
--------------------------------------------------
INSERT INTO OrderItems (OrderID, ItemID, Quantity, UnitPrice)
VALUES 
(@OrderID, (SELECT TOP 1 ItemID FROM MenuItems WHERE SKU='CN-01'), 1, 75000),
(@OrderID, (SELECT TOP 1 ItemID FROM MenuItems WHERE SKU='CN-02'), 1, 65000);

--------------------------------------------------
-- 8. DELIVERY INFO (PHẢI CÓ PHONE)
--------------------------------------------------
INSERT INTO DeliveryInfo (OrderID, ReceiverName, Phone, Address, DeliveryStatus)
VALUES 
(@OrderID, N'Customer', '0900000003', N'Hà Nội', 'Delivered');

--------------------------------------------------
-- 9. REVIEW
--------------------------------------------------
INSERT INTO Reviews (RestaurantID, CustomerID, Rating, Comment, OrderID)
VALUES 
(@RestID, @CustomerID, 5, N'Rất ngon', @OrderID);

PRINT 'DONE';
GO