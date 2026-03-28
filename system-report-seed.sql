USE [MultiRestaurantOrderingDB]
GO

SET NOCOUNT ON;
GO

/*
  Seed data for admin system report export.
  Safe to run multiple times (idempotent) by using unique markers.
*/

DECLARE @OwnerRoleID INT;
DECLARE @CustomerRoleID INT;
DECLARE @OwnerID INT;
DECLARE @CustomerID INT;
DECLARE @RestaurantID INT;
DECLARE @OrderPreparingID INT;

SELECT TOP 1 @OwnerRoleID = RoleID
FROM dbo.Roles
WHERE RoleName = N'Owner';

IF @OwnerRoleID IS NULL
    SET @OwnerRoleID = 2;

SELECT TOP 1 @CustomerRoleID = RoleID
FROM dbo.Roles
WHERE RoleName = N'Customer';

IF @CustomerRoleID IS NULL
    SET @CustomerRoleID = 4;

DECLARE @D1 DATE = DATEADD(DAY, -6, CAST(SYSUTCDATETIME() AS DATE));
DECLARE @D2 DATE = DATEADD(DAY, -5, CAST(SYSUTCDATETIME() AS DATE));
DECLARE @D3 DATE = DATEADD(DAY, -4, CAST(SYSUTCDATETIME() AS DATE));
DECLARE @D4 DATE = DATEADD(DAY, -3, CAST(SYSUTCDATETIME() AS DATE));
DECLARE @D5 DATE = DATEADD(DAY, -2, CAST(SYSUTCDATETIME() AS DATE));
DECLARE @D6 DATE = DATEADD(DAY, -1, CAST(SYSUTCDATETIME() AS DATE));
DECLARE @DT4A DATETIME2(0) = DATEADD(HOUR, 12, CAST(@D4 AS DATETIME2(0)));
DECLARE @DT4B DATETIME2(0) = DATEADD(HOUR, 15, CAST(@D4 AS DATETIME2(0)));
DECLARE @DT5A DATETIME2(0) = DATEADD(HOUR, 18, CAST(@D5 AS DATETIME2(0)));
DECLARE @DT6A DATETIME2(0) = DATEADD(HOUR, 11, CAST(@D6 AS DATETIME2(0)));

/* 1) Seed users (NewUsers metric) */
IF NOT EXISTS (
    SELECT 1
    FROM dbo.Users
    WHERE Email = N'seed.systemreport.owner@local'
)
BEGIN
    INSERT INTO dbo.Users (
        FullName, Email, PasswordHash, Phone, RoleID, IsActive, CreatedAt
    )
    VALUES (
        N'Seed Report Owner', N'seed.systemreport.owner@local',
        N'123456', N'0900000001', @OwnerRoleID, 1,
        DATEADD(HOUR, 9, CAST(@D1 AS DATETIME2(0)))
    );
END;

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Users
    WHERE Email = N'seed.systemreport.customer@local'
)
BEGIN
    INSERT INTO dbo.Users (
        FullName, Email, PasswordHash, Phone, RoleID, IsActive, CreatedAt
    )
    VALUES (
        N'Seed Report Customer', N'seed.systemreport.customer@local',
        N'123456', N'0900000002', @CustomerRoleID, 1,
        DATEADD(HOUR, 10, CAST(@D2 AS DATETIME2(0)))
    );
END;

SELECT @OwnerID = UserID
FROM dbo.Users
WHERE Email = N'seed.systemreport.owner@local';

SELECT @CustomerID = UserID
FROM dbo.Users
WHERE Email = N'seed.systemreport.customer@local';

/* 2) Seed restaurant (NewRestaurants metric) */
IF NOT EXISTS (
    SELECT 1
    FROM dbo.Restaurants
    WHERE Name = N'Seed Export Bistro'
)
BEGIN
    INSERT INTO dbo.Restaurants (
        OwnerID, Name, Address, LicenseNumber, LogoUrl, ThemeColor,
        IsOpen, DeliveryFee, CommissionRate, Status, CreatedAt
    )
    VALUES (
        @OwnerID, N'Seed Export Bistro', N'123 Seed Street',
        N'SEED-LICENSE-001', NULL, N'#4F46E5',
        1, 15000, 10, N'Approved',
        DATEADD(HOUR, 8, CAST(@D3 AS DATETIME2(0)))
    );
END;

SELECT TOP 1 @RestaurantID = RestaurantID
FROM dbo.Restaurants
WHERE Name = N'Seed Export Bistro'
ORDER BY RestaurantID DESC;

/* 3) Seed orders (TotalOrders, CompletedOrders, Revenue metrics) */
IF NOT EXISTS (
    SELECT 1
    FROM dbo.Orders
    WHERE RestaurantID = @RestaurantID
      AND CustomerID = @CustomerID
      AND OrderStatus = N'Completed'
      AND FinalAmount = 250000
      AND CreatedAt = @DT4A
)
BEGIN
    INSERT INTO dbo.Orders (
        RestaurantID, CustomerID, OrderType, TableID, OrderStatus, DiscountID,
        TotalAmount, DiscountAmount, FinalAmount, IsClosed, CreatedAt
    )
    VALUES (
        @RestaurantID, @CustomerID, N'Online', NULL, N'Completed', NULL,
        250000, 0, 250000, 1, @DT4A
    );
END;

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Orders
    WHERE RestaurantID = @RestaurantID
      AND CustomerID = @CustomerID
      AND OrderStatus = N'Preparing'
      AND FinalAmount = 180000
      AND CreatedAt = @DT4B
)
BEGIN
    INSERT INTO dbo.Orders (
        RestaurantID, CustomerID, OrderType, TableID, OrderStatus, DiscountID,
        TotalAmount, DiscountAmount, FinalAmount, IsClosed, CreatedAt
    )
    VALUES (
        @RestaurantID, @CustomerID, N'Online', NULL, N'Preparing', NULL,
        180000, 0, 180000, 0, @DT4B
    );
END;

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Orders
    WHERE RestaurantID = @RestaurantID
      AND CustomerID = @CustomerID
      AND OrderStatus = N'Completed'
      AND FinalAmount = 320000
      AND CreatedAt = @DT5A
)
BEGIN
    INSERT INTO dbo.Orders (
        RestaurantID, CustomerID, OrderType, TableID, OrderStatus, DiscountID,
        TotalAmount, DiscountAmount, FinalAmount, IsClosed, CreatedAt
    )
    VALUES (
        @RestaurantID, @CustomerID, N'Online', NULL, N'Completed', NULL,
        320000, 0, 320000, 1, @DT5A
    );
END;

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Orders
    WHERE RestaurantID = @RestaurantID
      AND CustomerID = @CustomerID
      AND OrderStatus = N'Cancelled'
      AND FinalAmount = 90000
      AND CreatedAt = @DT6A
)
BEGIN
    INSERT INTO dbo.Orders (
        RestaurantID, CustomerID, OrderType, TableID, OrderStatus, DiscountID,
        TotalAmount, DiscountAmount, FinalAmount, IsClosed, CreatedAt
    )
    VALUES (
        @RestaurantID, @CustomerID, N'Online', NULL, N'Cancelled', NULL,
        90000, 0, 90000, 1, @DT6A
    );
END;

SELECT TOP 1 @OrderPreparingID = OrderID
FROM dbo.Orders
WHERE RestaurantID = @RestaurantID
  AND CustomerID = @CustomerID
  AND OrderStatus = N'Preparing'
  AND FinalAmount = 180000
  AND CreatedAt = @DT4B
ORDER BY OrderID DESC;

/* 4) Seed complaints (NewComplaints metric) */
IF NOT EXISTS (
    SELECT 1
    FROM dbo.Complaints
    WHERE Description = N'SEED_EXPORT_COMPLAINT_1: order still preparing.'
)
BEGIN
    INSERT INTO dbo.Complaints (
        OrderID, CustomerID, Description, Status, CreatedAt
    )
    VALUES (
        @OrderPreparingID, @CustomerID,
        N'SEED_EXPORT_COMPLAINT_1: order still preparing.',
        N'Open', DATEADD(HOUR, 20, CAST(@D5 AS DATETIME2(0)))
    );
END;

IF NOT EXISTS (
    SELECT 1
    FROM dbo.Complaints
    WHERE Description = N'SEED_EXPORT_COMPLAINT_2: late support response.'
)
BEGIN
    INSERT INTO dbo.Complaints (
        OrderID, CustomerID, Description, Status, CreatedAt
    )
    VALUES (
        NULL, @CustomerID,
        N'SEED_EXPORT_COMPLAINT_2: late support response.',
        N'Open', DATEADD(HOUR, 9, CAST(@D6 AS DATETIME2(0)))
    );
END;

PRINT N'System report seed completed.';
PRINT N'Hint: set filter from ' + CONVERT(NVARCHAR(10), @D1, 23)
    + N' to ' + CONVERT(NVARCHAR(10), @D6, 23)
    + N' on /admin/system-report.';
GO
