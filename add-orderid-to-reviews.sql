-- Migration script to add OrderID column to Reviews table
-- Run this script in SQL Server Management Studio

-- Step 1: Add OrderID column
ALTER TABLE [dbo].[Reviews] 
ADD [OrderID] INT NULL;

-- Step 2: Add foreign key constraint
ALTER TABLE [dbo].[Reviews] 
ADD CONSTRAINT FK_Reviews_Orders 
FOREIGN KEY (OrderID) REFERENCES Orders(OrderID);

PRINT 'Migration completed successfully!';
PRINT 'OrderID column and foreign key constraint have been added to Reviews table.';

