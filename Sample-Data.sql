USE [MultiRestaurantOrderingDB_Merged]
GO

-----------------------------------------------------------------------
-- 1. CLEAN DATA
-----------------------------------------------------------------------
DELETE FROM OrderItems;
DELETE FROM Orders;
DELETE FROM DeliveryInfo;
DELETE FROM Payments;
DELETE FROM Invoices;
DELETE FROM Reviews;
DELETE FROM TableReservations;
DELETE FROM EmployeeShifts;
DELETE FROM MenuItems;
DELETE FROM MenuCategories;
DELETE FROM BusinessHours;
DELETE FROM RestaurantTables;
DELETE FROM RestaurantUsers;
DELETE FROM Restaurants;
DELETE FROM Users;
DELETE FROM Roles;

DBCC CHECKIDENT ('Roles', RESEED, 0);
DBCC CHECKIDENT ('Users', RESEED, 0);
DBCC CHECKIDENT ('Restaurants', RESEED, 0);
DBCC CHECKIDENT ('MenuCategories', RESEED, 0);
DBCC CHECKIDENT ('MenuItems', RESEED, 0);
DBCC CHECKIDENT ('Orders', RESEED, 0);

-----------------------------------------------------------------------
-- 2. ROLES
-----------------------------------------------------------------------
INSERT INTO Roles (RoleName)
VALUES (N'SuperAdmin'), (N'Owner'), (N'Manager'), (N'Staff'), (N'Customer');

-----------------------------------------------------------------------
-- 3. USERS
-----------------------------------------------------------------------
INSERT INTO Users (FullName, Email, PasswordHash, Phone, RoleID)
SELECT N'Admin', 'admin@system.com', '123456', '0900000001', RoleID FROM Roles WHERE RoleName='SuperAdmin';

INSERT INTO Users (FullName, Email, PasswordHash, Phone, RoleID)
SELECT N'Owner A', 'owner1@test.com', '123456', '0900000002', RoleID FROM Roles WHERE RoleName='Owner';

INSERT INTO Users (FullName, Email, PasswordHash, Phone, RoleID)
SELECT N'Owner B', 'owner2@test.com', '123456', '0900000003', RoleID FROM Roles WHERE RoleName='Owner';

INSERT INTO Users (FullName, Email, PasswordHash, Phone, RoleID)
SELECT N'Manager A', 'manager1@test.com', '123456', '0900000004', RoleID FROM Roles WHERE RoleName='Manager';

INSERT INTO Users (FullName, Email, PasswordHash, Phone, RoleID)
SELECT N'Staff A', 'staff1@test.com', '123456', '0900000005', RoleID FROM Roles WHERE RoleName='Staff';

INSERT INTO Users (FullName, Email, PasswordHash, Phone, RoleID)
SELECT N'Customer A', 'customer1@test.com', '123456', '0900000006', RoleID FROM Roles WHERE RoleName='Customer';

INSERT INTO Users (FullName, Email, PasswordHash, Phone, RoleID)
SELECT N'Customer B', 'customer2@test.com', '123456', '0900000007', RoleID FROM Roles WHERE RoleName='Customer';

-----------------------------------------------------------------------
-- 4. RESTAURANTS
-----------------------------------------------------------------------
DECLARE @OwnerA INT = (SELECT UserID FROM Users WHERE Email='owner1@test.com');
DECLARE @OwnerB INT = (SELECT UserID FROM Users WHERE Email='owner2@test.com');

INSERT INTO Restaurants (OwnerID, Name, Address, Status)
VALUES (@OwnerA, N'Restaurant A', N'Hà Nội', 'Approved');

DECLARE @Res1 INT = SCOPE_IDENTITY();

INSERT INTO Restaurants (OwnerID, Name, Address, Status)
VALUES (@OwnerB, N'Restaurant B', N'HCM', 'Approved');

DECLARE @Res2 INT = SCOPE_IDENTITY();

-----------------------------------------------------------------------
-- 5. TABLES
-----------------------------------------------------------------------
INSERT INTO RestaurantTables (RestaurantID, TableNumber, Capacity)
VALUES (@Res1, 'T1', 4), (@Res1, 'T2', 2), (@Res2, 'T1', 6);

-----------------------------------------------------------------------
-- 6. BUSINESS HOURS
-----------------------------------------------------------------------
INSERT INTO BusinessHours (RestaurantID, DayOfWeek, OpeningTime, ClosingTime)
VALUES (@Res1, 'Monday', '08:00', '22:00'),
       (@Res2, 'Monday', '09:00', '23:00');

-----------------------------------------------------------------------
-- 7. MENU
-----------------------------------------------------------------------
INSERT INTO MenuCategories (RestaurantID, CategoryName)
VALUES (@Res1, N'Món chính'),
       (@Res1, N'Nước'),
       (@Res2, N'Fast Food');

DECLARE @Cat1 INT = (SELECT CategoryID FROM MenuCategories WHERE CategoryName=N'Món chính');
DECLARE @Cat2 INT = (SELECT CategoryID FROM MenuCategories WHERE CategoryName=N'Nước');
DECLARE @Cat3 INT = (SELECT CategoryID FROM MenuCategories WHERE CategoryName=N'Fast Food');

INSERT INTO MenuItems (RestaurantID, CategoryID, ItemName, Price, SKU)
VALUES
(@Res1, @Cat1, N'Phở bò', 50000, 'SKU001'),
(@Res1, @Cat2, N'Trà đá', 5000, 'SKU002'),
(@Res2, @Cat3, N'Burger', 70000, 'SKU003');

-----------------------------------------------------------------------
-- 8. RESTAURANT USERS
-----------------------------------------------------------------------
DECLARE @Manager INT = (SELECT UserID FROM Users WHERE Email='manager1@test.com');
DECLARE @Staff INT = (SELECT UserID FROM Users WHERE Email='staff1@test.com');

INSERT INTO RestaurantUsers (RestaurantID, UserID, RestaurantRole)
VALUES
(@Res1, @OwnerA, 'Owner'),
(@Res1, @Manager, 'Manager'),
(@Res1, @Staff, 'Staff'),
(@Res2, @OwnerB, 'Owner');

-----------------------------------------------------------------------
-- 9. ORDERS
-----------------------------------------------------------------------
DECLARE @Cus1 INT = (SELECT UserID FROM Users WHERE Email='customer1@test.com');
DECLARE @Cus2 INT = (SELECT UserID FROM Users WHERE Email='customer2@test.com');

INSERT INTO Orders (RestaurantID, CustomerID, OrderStatus, TotalAmount, FinalAmount)
VALUES (@Res1, @Cus1, 'Completed', 55000, 55000);

DECLARE @Order1 INT = SCOPE_IDENTITY();

INSERT INTO Orders (RestaurantID, CustomerID, OrderStatus, TotalAmount, FinalAmount)
VALUES (@Res1, @Cus2, 'Completed', 50000, 50000);

DECLARE @Order2 INT = SCOPE_IDENTITY();

-----------------------------------------------------------------------
-- 10. ORDER ITEMS
-----------------------------------------------------------------------
DECLARE @Pho INT = (SELECT ItemID FROM MenuItems WHERE ItemName=N'Phở bò');
DECLARE @Tra INT = (SELECT ItemID FROM MenuItems WHERE ItemName=N'Trà đá');
DECLARE @Burger INT = (SELECT ItemID FROM MenuItems WHERE ItemName=N'Burger');

INSERT INTO OrderItems (OrderID, ItemID, Quantity, UnitPrice)
VALUES
(@Order1, @Pho, 1, 50000),
(@Order1, @Tra, 1, 5000),
(@Order2, @Burger, 1, 70000);

-----------------------------------------------------------------------
-- 11. DELIVERY
-----------------------------------------------------------------------
INSERT INTO DeliveryInfo (OrderID, Address)
VALUES (@Order1, N'Hà Nội'), (@Order2, N'HCM');

-----------------------------------------------------------------------
-- 12. PAYMENTS
-----------------------------------------------------------------------
INSERT INTO Payments (OrderID, PaymentType, PaymentStatus, CustomerID, Amount)
VALUES
(@Order1, 'Cash', 'Success', @Cus1, 55000),
(@Order2, 'Cash', 'Success', @Cus2, 50000);

-----------------------------------------------------------------------
-- 13. INVOICES
-----------------------------------------------------------------------
INSERT INTO Invoices (OrderID, InvoiceNumber, Subtotal, FinalAmount)
VALUES
(@Order1, 'INV001', 55000, 55000),
(@Order2, 'INV002', 50000, 50000);

-----------------------------------------------------------------------
-- 14. REVIEWS
-----------------------------------------------------------------------
INSERT INTO Reviews (RestaurantID, CustomerID, Rating)
VALUES
(@Res1, @Cus1, 5),
(@Res1, @Cus2, 4);

-----------------------------------------------------------------------
-- 15. RESERVATION
-----------------------------------------------------------------------
DECLARE @Table1 INT = (SELECT TOP 1 TableID FROM RestaurantTables WHERE RestaurantID=@Res1);

INSERT INTO TableReservations (RestaurantID, TableID, CustomerID, ReservationDate, StartTime, EndTime)
VALUES (@Res1, @Table1, @Cus1, GETDATE(), '18:00', '20:00');

-----------------------------------------------------------------------
-- 16. SHIFT
-----------------------------------------------------------------------
INSERT INTO ShiftTemplates (RestaurantID, ShiftName, StartTime, EndTime)
VALUES (@Res1, 'Morning', '08:00', '14:00');

DECLARE @Shift INT = SCOPE_IDENTITY();

INSERT INTO EmployeeShifts (RestaurantID, StaffID, ShiftDate, TemplateID)
VALUES (@Res1, @Staff, GETDATE(), @Shift);

PRINT '=== FULL INIT PRO SUCCESS ===';
GO