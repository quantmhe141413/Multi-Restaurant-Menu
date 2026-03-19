USE [MultiRestaurantOrderingDB]
GO

SET QUOTED_IDENTIFIER ON
GO

-- Insert menu items for Restaurant 2 (Phở Hà Nội)
INSERT INTO [dbo].[MenuItems] ([RestaurantID], [CategoryID], [SKU], [ItemName], [Description], [Price], [IsAvailable], [CreatedAt])
VALUES
    (2, 1, N'PHO-001', N'Phở Bò Tái', N'Phở bò tái thơm ngon, nước dùng đậm đà', 75000.00, 1, GETDATE()),
    (2, 1, N'PHO-002', N'Phở Bò Chín', N'Phở bò chín mềm, nước dùng ngọt thanh', 70000.00, 1, GETDATE()),
    (2, 1, N'PHO-003', N'Phở Bò Tái Chín', N'Phở bò tái chín kết hợp', 80000.00, 1, GETDATE()),
    (2, 1, N'PHO-004', N'Phở Gà', N'Phở gà nóng hổi', 65000.00, 1, GETDATE()),
    (2, 2, N'BUN-001', N'Bún Chả', N'Bún chả Hà Nội đặc trưng', 65000.00, 1, GETDATE()),
    (2, 2, N'BUN-002', N'Bún Bò', N'Bún bò Nam Bộ', 70000.00, 1, GETDATE()),
    (2, 3, N'DRINK-001', N'Coca Cola', N'Coca Cola lạnh', 15000.00, 1, GETDATE()),
    (2, 3, N'DRINK-002', N'Pepsi', N'Pepsi lạnh', 15000.00, 1, GETDATE()),
    (2, 3, N'DRINK-003', N'Trà Đá', N'Trà đá mát lạnh', 10000.00, 1, GETDATE())
GO

PRINT 'Menu items inserted successfully!'
GO
