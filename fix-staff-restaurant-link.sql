-- Script to check and fix Staff user restaurant linkage

-- 1. Check if Staff users have RestaurantUsers records
SELECT u.UserID, u.FullName, u.Email, u.RoleID, ru.RestaurantID
FROM Users u
LEFT JOIN RestaurantUsers ru ON u.UserID = ru.UserID
WHERE u.RoleID = 3 -- Staff role
ORDER BY u.UserID;

-- 2. If Staff user (UserID = 7) doesn't have a RestaurantUsers record, insert one
-- Replace RestaurantID = 5 with the actual restaurant ID you want to link
IF NOT EXISTS (SELECT 1 FROM RestaurantUsers WHERE UserID = 7)
BEGIN
    INSERT INTO RestaurantUsers (UserID, RestaurantID, IsActive, CreatedAt)
    VALUES (7, 5, 1, GETDATE());
    PRINT 'Inserted RestaurantUsers record for Staff user 7';
END
ELSE
BEGIN
    PRINT 'RestaurantUsers record already exists for Staff user 7';
END

-- 3. Verify the insertion
SELECT u.UserID, u.FullName, u.Email, u.RoleID, ru.RestaurantID, ru.IsActive
FROM Users u
INNER JOIN RestaurantUsers ru ON u.UserID = ru.UserID
WHERE u.RoleID = 3 -- Staff role
ORDER BY u.UserID;
