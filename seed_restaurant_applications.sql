USE MultiRestaurantOrderingDB;
GO

DECLARE @AdminEmail NVARCHAR(255) = 'admin.platform@example.com';
DECLARE @Owner1Email NVARCHAR(255) = 'owner1@example.com';
DECLARE @Owner2Email NVARCHAR(255) = 'owner2@example.com';
DECLARE @Owner3Email NVARCHAR(255) = 'owner3@example.com';

IF NOT EXISTS (SELECT 1 FROM Users WHERE Email = @AdminEmail)
BEGIN
    INSERT INTO Users (FullName, Email, PasswordHash, Phone, RoleID, IsActive, CreatedAt)
    VALUES ('Platform Admin', @AdminEmail, '123456', '0900000000', 1, 1, GETDATE());
END

IF NOT EXISTS (SELECT 1 FROM Users WHERE Email = @Owner1Email)
BEGIN
    INSERT INTO Users (FullName, Email, PasswordHash, Phone, RoleID, IsActive, CreatedAt)
    VALUES ('Owner One', @Owner1Email, '123456', '0900000001', 2, 1, GETDATE());
END

IF NOT EXISTS (SELECT 1 FROM Users WHERE Email = @Owner2Email)
BEGIN
    INSERT INTO Users (FullName, Email, PasswordHash, Phone, RoleID, IsActive, CreatedAt)
    VALUES ('Owner Two', @Owner2Email, '123456', '0900000002', 2, 1, GETDATE());
END

IF NOT EXISTS (SELECT 1 FROM Users WHERE Email = @Owner3Email)
BEGIN
    INSERT INTO Users (FullName, Email, PasswordHash, Phone, RoleID, IsActive, CreatedAt)
    VALUES ('Owner Three', @Owner3Email, '123456', '0900000003', 2, 1, GETDATE());
END

DECLARE @Owner1Id INT = (SELECT TOP 1 UserID FROM Users WHERE Email = @Owner1Email);
DECLARE @Owner2Id INT = (SELECT TOP 1 UserID FROM Users WHERE Email = @Owner2Email);
DECLARE @Owner3Id INT = (SELECT TOP 1 UserID FROM Users WHERE Email = @Owner3Email);

IF NOT EXISTS (SELECT 1 FROM Restaurants WHERE LicenseNumber = 'LIC-PEN-001')
BEGIN
    INSERT INTO Restaurants (OwnerID, Name, Address, LicenseNumber, LogoUrl, ThemeColor, IsOpen, DeliveryFee, CommissionRate, Status, CreatedAt)
    VALUES (@Owner1Id, 'Pending Pizza House', '123 Main St, District 1', 'LIC-PEN-001', 'https://images.unsplash.com/photo-1590947132387-155cc02f3212', '#6366f1', 0, 15000, 0.10, 'Pending', GETDATE());
END

IF NOT EXISTS (SELECT 1 FROM Restaurants WHERE LicenseNumber = 'LIC-PEN-002')
BEGIN
    INSERT INTO Restaurants (OwnerID, Name, Address, LicenseNumber, LogoUrl, ThemeColor, IsOpen, DeliveryFee, CommissionRate, Status, CreatedAt)
    VALUES (@Owner2Id, 'Pending Sushi Bar', '456 River Rd, District 3', 'LIC-PEN-002', 'https://images.unsplash.com/photo-1553621042-f6e147245754', '#8b5cf6', 0, 20000, 0.12, 'Pending', DATEADD(DAY, -1, GETDATE()));
END

IF NOT EXISTS (SELECT 1 FROM Restaurants WHERE LicenseNumber = 'LIC-PEN-003')
BEGIN
    INSERT INTO Restaurants (OwnerID, Name, Address, LicenseNumber, LogoUrl, ThemeColor, IsOpen, DeliveryFee, CommissionRate, Status, CreatedAt)
    VALUES (@Owner3Id, 'Pending Coffee & Bakery', '789 Sunset Blvd, District 7', 'LIC-PEN-003', 'https://images.unsplash.com/photo-1509042239860-f550ce710b93', '#10b981', 0, 10000, 0.08, 'Pending', DATEADD(DAY, -2, GETDATE()));
END

IF NOT EXISTS (SELECT 1 FROM Restaurants WHERE LicenseNumber = 'LIC-APP-001')
BEGIN
    INSERT INTO Restaurants (OwnerID, Name, Address, LicenseNumber, LogoUrl, ThemeColor, IsOpen, DeliveryFee, CommissionRate, Status, CreatedAt)
    VALUES (@Owner1Id, 'Approved Noodle Kitchen', '22 Nguyen Hue, District 1', 'LIC-APP-001', 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe', '#3b82f6', 1, 15000, 0.10, 'Approved', DATEADD(DAY, -10, GETDATE()));
END

IF NOT EXISTS (SELECT 1 FROM Restaurants WHERE LicenseNumber = 'LIC-REJ-001')
BEGIN
    INSERT INTO Restaurants (OwnerID, Name, Address, LicenseNumber, LogoUrl, ThemeColor, IsOpen, DeliveryFee, CommissionRate, Status, CreatedAt)
    VALUES (@Owner2Id, 'Rejected Burger Corner', '88 Le Loi, District 1', 'LIC-REJ-001', 'https://images.unsplash.com/photo-1550547660-d9450f859349', '#ef4444', 0, 18000, 0.11, 'Rejected', DATEADD(DAY, -7, GETDATE()));
END
GO
