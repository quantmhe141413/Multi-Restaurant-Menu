USE [MultiRestaurantOrderingDB];
GO

-- 1. Ensure VerificationToken exists
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND name = 'VerificationToken')
BEGIN
    ALTER TABLE [dbo].[Users] ADD [VerificationToken] NVARCHAR(255) NULL;
END
GO

-- 2. Ensure IsEmailVerified exists
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND name = 'IsEmailVerified')
BEGIN
    ALTER TABLE [dbo].[Users] ADD [IsEmailVerified] BIT NOT NULL DEFAULT 1;
END
GO

-- 3. Mark everyone as verified (using dynamic SQL to avoid parse errors)
EXEC('UPDATE [dbo].[Users] SET [IsEmailVerified] = 1');
GO

-- 4. Final verification
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Users' AND COLUMN_NAME IN ('VerificationToken', 'IsEmailVerified');
