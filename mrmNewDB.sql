USE [master];
GO

-- =====================================================
-- STEP 1: Drop và tạo lại database sạch
-- =====================================================
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'MultiRestaurantOrderingDB_Merged')
BEGIN
    ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [MultiRestaurantOrderingDB_Merged];
END
GO

CREATE DATABASE [MultiRestaurantOrderingDB_Merged];
GO

ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET COMPATIBILITY_LEVEL = 160;
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET ANSI_NULL_DEFAULT OFF;
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET ANSI_NULLS OFF;
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET ANSI_PADDING OFF;
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET ANSI_WARNINGS OFF;
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET ARITHABORT OFF;
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET AUTO_CLOSE OFF;
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET AUTO_SHRINK OFF;
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET AUTO_UPDATE_STATISTICS ON;
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET CURSOR_CLOSE_ON_COMMIT OFF;
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET CURSOR_DEFAULT GLOBAL;
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET CONCAT_NULL_YIELDS_NULL OFF;
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET NUMERIC_ROUNDABORT OFF;
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET QUOTED_IDENTIFIER OFF;
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET RECURSIVE_TRIGGERS OFF;
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET ENABLE_BROKER;
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET AUTO_UPDATE_STATISTICS_ASYNC OFF;
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET DATE_CORRELATION_OPTIMIZATION OFF;
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET TRUSTWORTHY OFF;
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET ALLOW_SNAPSHOT_ISOLATION OFF;
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET PARAMETERIZATION SIMPLE;
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET READ_COMMITTED_SNAPSHOT OFF;
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET HONOR_BROKER_PRIORITY OFF;
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET RECOVERY FULL;
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET MULTI_USER;
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET PAGE_VERIFY CHECKSUM;
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET DB_CHAINING OFF;
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET FILESTREAM(NON_TRANSACTED_ACCESS = OFF);
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET TARGET_RECOVERY_TIME = 60 SECONDS;
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET DELAYED_DURABILITY = DISABLED;
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET ACCELERATED_DATABASE_RECOVERY = OFF;
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET QUERY_STORE = ON;
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET QUERY_STORE (
    OPERATION_MODE = READ_WRITE,
    CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30),
    DATA_FLUSH_INTERVAL_SECONDS = 900,
    INTERVAL_LENGTH_MINUTES = 60,
    MAX_STORAGE_SIZE_MB = 1000,
    QUERY_CAPTURE_MODE = AUTO,
    SIZE_BASED_CLEANUP_MODE = AUTO,
    MAX_PLANS_PER_QUERY = 200,
    WAIT_STATS_CAPTURE_MODE = ON
);
GO

USE [MultiRestaurantOrderingDB_Merged];
GO

-- =====================================================
-- STEP 2: Tạo tất cả các bảng
-- =====================================================

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- Roles
CREATE TABLE [dbo].[Roles] (
    [RoleID]   INT           IDENTITY(1,1) NOT NULL,
    [RoleName] NVARCHAR(50)  NOT NULL,
    PRIMARY KEY CLUSTERED ([RoleID] ASC)
);
GO
ALTER TABLE [dbo].[Roles] ADD UNIQUE NONCLUSTERED ([RoleName] ASC);
GO

-- Users
CREATE TABLE [dbo].[Users] (
    [UserID]       INT            IDENTITY(1,1) NOT NULL,
    [FullName]     NVARCHAR(100)  NOT NULL,
    [Email]        NVARCHAR(100)  NOT NULL,
    [PasswordHash] NVARCHAR(255)  NOT NULL,
    [Phone]        NVARCHAR(20)   NULL,
    [RoleID]       INT            NOT NULL,
    [IsActive]     BIT            NOT NULL,
    [CreatedAt]    DATETIME2(0)   NOT NULL,
    PRIMARY KEY CLUSTERED ([UserID] ASC)
);
GO
ALTER TABLE [dbo].[Users] ADD UNIQUE NONCLUSTERED ([Email] ASC);
GO
ALTER TABLE [dbo].[Users] ADD CONSTRAINT [DF_Users_IsActive]  DEFAULT ((1)) FOR [IsActive];
GO
ALTER TABLE [dbo].[Users] ADD CONSTRAINT [DF_Users_CreatedAt] DEFAULT (sysutcdatetime()) FOR [CreatedAt];
GO
ALTER TABLE [dbo].[Users] WITH CHECK ADD CONSTRAINT [FK_Users_Roles]
    FOREIGN KEY ([RoleID]) REFERENCES [dbo].[Roles] ([RoleID]);
GO

-- Restaurants
CREATE TABLE [dbo].[Restaurants] (
    [RestaurantID]   INT             IDENTITY(1,1) NOT NULL,
    [OwnerID]        INT             NOT NULL,
    [Name]           NVARCHAR(150)   NOT NULL,
    [Address]        NVARCHAR(255)   NULL,
    [LicenseNumber]  NVARCHAR(50)    NULL,
    [LogoUrl]        NVARCHAR(255)   NULL,
    [ThemeColor]     NVARCHAR(20)    NULL,
    [IsOpen]         BIT             NOT NULL,
    [DeliveryFee]    DECIMAL(10, 2)  NULL,
    [CommissionRate] DECIMAL(5, 2)   NULL,
    [Status]         NVARCHAR(20)    NOT NULL,
    [CreatedAt]      DATETIME2(0)    NOT NULL,
    PRIMARY KEY CLUSTERED ([RestaurantID] ASC)
);
GO
ALTER TABLE [dbo].[Restaurants] ADD CONSTRAINT [DF_Restaurants_IsOpen]   DEFAULT ((1))              FOR [IsOpen];
GO
ALTER TABLE [dbo].[Restaurants] ADD CONSTRAINT [DF_Restaurants_Status]   DEFAULT ('Pending')         FOR [Status];
GO
ALTER TABLE [dbo].[Restaurants] ADD CONSTRAINT [DF_Restaurants_CreatedAt] DEFAULT (sysutcdatetime()) FOR [CreatedAt];
GO
ALTER TABLE [dbo].[Restaurants] WITH CHECK ADD CONSTRAINT [FK_Restaurants_Owner]
    FOREIGN KEY ([OwnerID]) REFERENCES [dbo].[Users] ([UserID]);
GO
ALTER TABLE [dbo].[Restaurants] WITH CHECK ADD CHECK (([CommissionRate] >= (0) AND [CommissionRate] <= (100)));
GO
ALTER TABLE [dbo].[Restaurants] WITH CHECK ADD CHECK (([DeliveryFee] >= (0)));
GO
ALTER TABLE [dbo].[Restaurants] WITH CHECK ADD CHECK (([Status] = 'Rejected' OR [Status] = 'Approved' OR [Status] = 'Pending'));
GO
CREATE NONCLUSTERED INDEX [IX_Restaurants_Status_Open] ON [dbo].[Restaurants] ([Status] ASC, [IsOpen] ASC);
GO

-- MenuCategories
CREATE TABLE [dbo].[MenuCategories] (
    [CategoryID]   INT           IDENTITY(1,1) NOT NULL,
    [RestaurantID] INT           NOT NULL,
    [CategoryName] NVARCHAR(100) NOT NULL,
    [DisplayOrder] INT           NULL,
    [IsActive]     BIT           NOT NULL,
    PRIMARY KEY CLUSTERED ([CategoryID] ASC)
);
GO
ALTER TABLE [dbo].[MenuCategories] ADD CONSTRAINT [DF_MenuCategories_IsActive] DEFAULT ((1)) FOR [IsActive];
GO
ALTER TABLE [dbo].[MenuCategories] WITH CHECK ADD CONSTRAINT [FK_MenuCategories_Restaurants]
    FOREIGN KEY ([RestaurantID]) REFERENCES [dbo].[Restaurants] ([RestaurantID]);
GO

-- MenuItems
CREATE TABLE [dbo].[MenuItems] (
    [ItemID]        INT            IDENTITY(1,1) NOT NULL,
    [RestaurantID]  INT            NOT NULL,
    [CategoryID]    INT            NOT NULL,
    [SKU]           NVARCHAR(50)   NULL,
    [ItemName]      NVARCHAR(150)  NOT NULL,
    [Description]   NVARCHAR(255)  NULL,
    [Price]         DECIMAL(10, 2) NOT NULL,
    [IsAvailable]   BIT            NOT NULL,
    [AverageRating] AS (CONVERT([decimal](4,2), NULL)) PERSISTED,
    [CreatedAt]     DATETIME2(0)   NOT NULL,
    [ImageUrl]      NVARCHAR(255)  NULL,
    PRIMARY KEY CLUSTERED ([ItemID] ASC)
);
GO
ALTER TABLE [dbo].[MenuItems] ADD CONSTRAINT [UQ_MenuItems_Restaurant_SKU]
    UNIQUE NONCLUSTERED ([RestaurantID] ASC, [SKU] ASC);
GO
ALTER TABLE [dbo].[MenuItems] ADD CONSTRAINT [DF_MenuItems_IsAvailable] DEFAULT ((1))              FOR [IsAvailable];
GO
ALTER TABLE [dbo].[MenuItems] ADD CONSTRAINT [DF_MenuItems_CreatedAt]   DEFAULT (sysutcdatetime()) FOR [CreatedAt];
GO
ALTER TABLE [dbo].[MenuItems] WITH CHECK ADD CONSTRAINT [FK_MenuItems_Categories]
    FOREIGN KEY ([CategoryID]) REFERENCES [dbo].[MenuCategories] ([CategoryID]);
GO
ALTER TABLE [dbo].[MenuItems] WITH CHECK ADD CONSTRAINT [FK_MenuItems_Restaurants]
    FOREIGN KEY ([RestaurantID]) REFERENCES [dbo].[Restaurants] ([RestaurantID]);
GO
ALTER TABLE [dbo].[MenuItems] WITH CHECK ADD CHECK (([Price] >= (0)));
GO

-- ItemOptions
CREATE TABLE [dbo].[ItemOptions] (
    [OptionID]        INT            IDENTITY(1,1) NOT NULL,
    [ItemID]          INT            NOT NULL,
    [OptionName]      NVARCHAR(100)  NOT NULL,
    [AdditionalPrice] DECIMAL(10, 2) NOT NULL,
    [IsActive]        BIT            NOT NULL,
    PRIMARY KEY CLUSTERED ([OptionID] ASC)
);
GO
ALTER TABLE [dbo].[ItemOptions] ADD CONSTRAINT [DF_ItemOptions_AdditionalPrice] DEFAULT ((0))  FOR [AdditionalPrice];
GO
ALTER TABLE [dbo].[ItemOptions] ADD CONSTRAINT [DF_ItemOptions_IsActive]         DEFAULT ((1))  FOR [IsActive];
GO
ALTER TABLE [dbo].[ItemOptions] WITH CHECK ADD CONSTRAINT [FK_ItemOptions_MenuItems]
    FOREIGN KEY ([ItemID]) REFERENCES [dbo].[MenuItems] ([ItemID]);
GO
ALTER TABLE [dbo].[ItemOptions] WITH CHECK ADD CHECK (([AdditionalPrice] >= (0)));
GO

-- Discounts
CREATE TABLE [dbo].[Discounts] (
    [DiscountID]       INT            IDENTITY(1,1) NOT NULL,
    [RestaurantID]     INT            NULL,
    [Code]             NVARCHAR(50)   NOT NULL,
    [DiscountType]     NVARCHAR(20)   NOT NULL,
    [DiscountValue]    DECIMAL(10, 2) NOT NULL,
    [ExpiryDate]       DATETIME2(0)   NULL,
    [IsActive]         BIT            NOT NULL,
    [CreatedAt]        DATETIME2(0)   NOT NULL,
    [Quantity]         INT            NOT NULL,
    [MinOrderAmount]   DECIMAL(10, 2) NOT NULL,
    [MaxDiscountAmount] DECIMAL(10, 2) NULL,
    [UsageLimitPerUser] INT           NOT NULL,
    PRIMARY KEY CLUSTERED ([DiscountID] ASC)
);
GO
ALTER TABLE [dbo].[Discounts] ADD UNIQUE NONCLUSTERED ([Code] ASC);
GO
ALTER TABLE [dbo].[Discounts] ADD CONSTRAINT [DF_Discounts_IsActive]              DEFAULT ((1))              FOR [IsActive];
GO
ALTER TABLE [dbo].[Discounts] ADD CONSTRAINT [DF_Discounts_CreatedAt]             DEFAULT (sysutcdatetime()) FOR [CreatedAt];
GO
ALTER TABLE [dbo].[Discounts] ADD CONSTRAINT [DF_Discounts_Quantity_Merge]        DEFAULT ((100))            FOR [Quantity];
GO
ALTER TABLE [dbo].[Discounts] ADD CONSTRAINT [DF_Discounts_MinOrderAmount_Merge]  DEFAULT ((0))              FOR [MinOrderAmount];
GO
ALTER TABLE [dbo].[Discounts] ADD CONSTRAINT [DF_Discounts_UsageLimitPerUser_Merge] DEFAULT ((1))            FOR [UsageLimitPerUser];
GO
ALTER TABLE [dbo].[Discounts] WITH CHECK ADD CONSTRAINT [FK_Discounts_Restaurants]
    FOREIGN KEY ([RestaurantID]) REFERENCES [dbo].[Restaurants] ([RestaurantID]);
GO
ALTER TABLE [dbo].[Discounts] WITH CHECK ADD CHECK (([DiscountType] = 'Fixed' OR [DiscountType] = 'Percentage'));
GO
ALTER TABLE [dbo].[Discounts] WITH CHECK ADD CHECK (([DiscountValue] >= (0)));
GO

-- RestaurantTables
CREATE TABLE [dbo].[RestaurantTables] (
    [TableID]      INT           IDENTITY(1,1) NOT NULL,
    [RestaurantID] INT           NOT NULL,
    [TableNumber]  NVARCHAR(20)  NOT NULL,
    [Capacity]     INT           NOT NULL,
    [TableStatus]  NVARCHAR(20)  NOT NULL,
    [IsActive]     BIT           NOT NULL,
    PRIMARY KEY CLUSTERED ([TableID] ASC)
);
GO
ALTER TABLE [dbo].[RestaurantTables] ADD CONSTRAINT [UQ_RestaurantTables]
    UNIQUE NONCLUSTERED ([RestaurantID] ASC, [TableNumber] ASC);
GO
ALTER TABLE [dbo].[RestaurantTables] ADD CONSTRAINT [DF_RestaurantTables_Status]   DEFAULT ('Available') FOR [TableStatus];
GO
ALTER TABLE [dbo].[RestaurantTables] ADD CONSTRAINT [DF_RestaurantTables_IsActive] DEFAULT ((1))         FOR [IsActive];
GO
ALTER TABLE [dbo].[RestaurantTables] WITH CHECK ADD CONSTRAINT [FK_RestaurantTables_Restaurants]
    FOREIGN KEY ([RestaurantID]) REFERENCES [dbo].[Restaurants] ([RestaurantID]);
GO
ALTER TABLE [dbo].[RestaurantTables] WITH CHECK ADD CHECK (([Capacity] > (0)));
GO
ALTER TABLE [dbo].[RestaurantTables] WITH CHECK ADD CHECK (([TableStatus] = 'Reserved' OR [TableStatus] = 'Occupied' OR [TableStatus] = 'Available'));
GO

-- Orders
CREATE TABLE [dbo].[Orders] (
    [OrderID]        INT            IDENTITY(1,1) NOT NULL,
    [RestaurantID]   INT            NOT NULL,
    [CustomerID]     INT            NOT NULL,
    [OrderType]      NVARCHAR(20)   NOT NULL,
    [TableID]        INT            NULL,
    [OrderStatus]    NVARCHAR(30)   NOT NULL,
    [DiscountID]     INT            NULL,
    [TotalAmount]    DECIMAL(10, 2) NOT NULL,
    [DiscountAmount] DECIMAL(10, 2) NOT NULL,
    [FinalAmount]    DECIMAL(10, 2) NOT NULL,
    [IsClosed]       BIT            NOT NULL,
    [CreatedAt]      DATETIME2(0)   NOT NULL,
    [DeliveryFee]    DECIMAL(10, 2) NOT NULL,
    [PaymentMethod]  NVARCHAR(50)   NULL,
    [PaymentStatus]  NVARCHAR(30)   NOT NULL,
    [PaidAt]         DATETIME2(0)   NULL,
    PRIMARY KEY CLUSTERED ([OrderID] ASC)
);
GO
ALTER TABLE [dbo].[Orders] ADD CONSTRAINT [DF_Orders_OrderType]             DEFAULT ('Online')         FOR [OrderType];
GO
ALTER TABLE [dbo].[Orders] ADD CONSTRAINT [DF_Orders_Status]                DEFAULT ('Preparing')      FOR [OrderStatus];
GO
ALTER TABLE [dbo].[Orders] ADD CONSTRAINT [DF_Orders_Total]                 DEFAULT ((0))              FOR [TotalAmount];
GO
ALTER TABLE [dbo].[Orders] ADD CONSTRAINT [DF_Orders_Discount]              DEFAULT ((0))              FOR [DiscountAmount];
GO
ALTER TABLE [dbo].[Orders] ADD CONSTRAINT [DF_Orders_Final]                 DEFAULT ((0))              FOR [FinalAmount];
GO
ALTER TABLE [dbo].[Orders] ADD CONSTRAINT [DF_Orders_IsClosed]              DEFAULT ((0))              FOR [IsClosed];
GO
ALTER TABLE [dbo].[Orders] ADD CONSTRAINT [DF_Orders_CreatedAt]             DEFAULT (sysutcdatetime()) FOR [CreatedAt];
GO
ALTER TABLE [dbo].[Orders] ADD CONSTRAINT [DF_Orders_DeliveryFee_Merge]     DEFAULT ((0))              FOR [DeliveryFee];
GO
ALTER TABLE [dbo].[Orders] ADD CONSTRAINT [DF_Orders_PaymentStatus_Merge]   DEFAULT ('Pending')        FOR [PaymentStatus];
GO
ALTER TABLE [dbo].[Orders] WITH CHECK ADD CONSTRAINT [FK_Orders_Customers]
    FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Users] ([UserID]);
GO
ALTER TABLE [dbo].[Orders] WITH CHECK ADD CONSTRAINT [FK_Orders_Discounts]
    FOREIGN KEY ([DiscountID]) REFERENCES [dbo].[Discounts] ([DiscountID]);
GO
ALTER TABLE [dbo].[Orders] WITH CHECK ADD CONSTRAINT [FK_Orders_Restaurants]
    FOREIGN KEY ([RestaurantID]) REFERENCES [dbo].[Restaurants] ([RestaurantID]);
GO
ALTER TABLE [dbo].[Orders] WITH CHECK ADD CONSTRAINT [FK_Orders_Table]
    FOREIGN KEY ([TableID]) REFERENCES [dbo].[RestaurantTables] ([TableID]);
GO
ALTER TABLE [dbo].[Orders] WITH CHECK ADD CHECK (([DiscountAmount] >= (0)));
GO
ALTER TABLE [dbo].[Orders] WITH CHECK ADD CHECK (([FinalAmount] >= (0)));
GO
ALTER TABLE [dbo].[Orders] WITH CHECK ADD CHECK (([OrderStatus] = 'Cancelled' OR [OrderStatus] = 'Completed' OR [OrderStatus] = 'Delivering' OR [OrderStatus] = 'Preparing'));
GO
ALTER TABLE [dbo].[Orders] WITH CHECK ADD CHECK (([OrderType] = 'Pickup' OR [OrderType] = 'DineIn' OR [OrderType] = 'Online'));
GO
ALTER TABLE [dbo].[Orders] WITH CHECK ADD CHECK (([TotalAmount] >= (0)));
GO
ALTER TABLE [dbo].[Orders] WITH NOCHECK ADD CONSTRAINT [CK_Orders_PaymentStatus_Merge]
    CHECK (([PaymentStatus] = 'Cancelled' OR [PaymentStatus] = 'Refunded' OR [PaymentStatus] = 'Failed' OR [PaymentStatus] = 'Success' OR [PaymentStatus] = 'Pending'));
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [CK_Orders_PaymentStatus_Merge];
GO

-- OrderItems
CREATE TABLE [dbo].[OrderItems] (
    [OrderItemID] INT            IDENTITY(1,1) NOT NULL,
    [OrderID]     INT            NOT NULL,
    [ItemID]      INT            NOT NULL,
    [Quantity]    INT            NOT NULL,
    [UnitPrice]   DECIMAL(10, 2) NOT NULL,
    [Note]        NVARCHAR(255)  NULL,
    [CreatedAt]   DATETIME2(0)   NOT NULL,
    PRIMARY KEY CLUSTERED ([OrderItemID] ASC)
);
GO
ALTER TABLE [dbo].[OrderItems] ADD CONSTRAINT [DF_OrderItems_CreatedAt] DEFAULT (sysutcdatetime()) FOR [CreatedAt];
GO
ALTER TABLE [dbo].[OrderItems] WITH CHECK ADD CONSTRAINT [FK_OrderItems_MenuItems]
    FOREIGN KEY ([ItemID]) REFERENCES [dbo].[MenuItems] ([ItemID]);
GO
ALTER TABLE [dbo].[OrderItems] WITH CHECK ADD CONSTRAINT [FK_OrderItems_Orders]
    FOREIGN KEY ([OrderID]) REFERENCES [dbo].[Orders] ([OrderID]);
GO
ALTER TABLE [dbo].[OrderItems] WITH CHECK ADD CHECK (([Quantity] > (0)));
GO
ALTER TABLE [dbo].[OrderItems] WITH CHECK ADD CHECK (([UnitPrice] >= (0)));
GO

-- Payments
CREATE TABLE [dbo].[Payments] (
    [PaymentID]         INT            IDENTITY(1,1) NOT NULL,
    [OrderID]           INT            NOT NULL,
    [PaymentType]       NVARCHAR(30)   NOT NULL,
    [PaymentStatus]     NVARCHAR(30)   NOT NULL,
    [IsPaid]            BIT            NOT NULL,
    [TransactionRef]    NVARCHAR(100)  NULL,
    [PaidAt]            DATETIME2(0)   NULL,
    [CreatedAt]         DATETIME2(0)   NOT NULL,
    [CustomerID]        INT            NOT NULL,
    [Amount]            BIGINT         NOT NULL,
    [BankCode]          NVARCHAR(50)   NULL,
    [CardType]          NVARCHAR(50)   NULL,
    [PayDate]           NVARCHAR(14)   NULL,
    [ResponseCode]      NVARCHAR(10)   NULL,
    [TransactionNo]     NVARCHAR(50)   NULL,
    [TransactionStatus] NVARCHAR(10)   NULL,
    [SecureHash]        NVARCHAR(255)  NULL,
    [UpdatedAt]         DATETIME2(0)   NULL,
    PRIMARY KEY CLUSTERED ([PaymentID] ASC)
);
GO
CREATE NONCLUSTERED INDEX [IX_Payments_CustomerID]    ON [dbo].[Payments] ([CustomerID] ASC);
GO
CREATE NONCLUSTERED INDEX [IX_Payments_OrderID]       ON [dbo].[Payments] ([OrderID] ASC);
GO
CREATE NONCLUSTERED INDEX [IX_Payments_TransactionRef] ON [dbo].[Payments] ([TransactionRef] ASC);
GO
ALTER TABLE [dbo].[Payments] ADD CONSTRAINT [DF_Payments_Status]   DEFAULT ('Pending')        FOR [PaymentStatus];
GO
ALTER TABLE [dbo].[Payments] ADD CONSTRAINT [DF_Payments_IsPaid]   DEFAULT ((0))              FOR [IsPaid];
GO
ALTER TABLE [dbo].[Payments] ADD CONSTRAINT [DF_Payments_CreatedAt] DEFAULT (sysutcdatetime()) FOR [CreatedAt];
GO
ALTER TABLE [dbo].[Payments] WITH NOCHECK ADD CONSTRAINT [FK_Payments_Customers_Merge]
    FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Users] ([UserID]);
GO
ALTER TABLE [dbo].[Payments] CHECK CONSTRAINT [FK_Payments_Customers_Merge];
GO
ALTER TABLE [dbo].[Payments] WITH CHECK ADD CONSTRAINT [FK_Payments_Orders]
    FOREIGN KEY ([OrderID]) REFERENCES [dbo].[Orders] ([OrderID]);
GO
ALTER TABLE [dbo].[Payments] WITH NOCHECK ADD CONSTRAINT [CK_Payments_Amount_Merge]
    CHECK (([Amount] >= (0)));
GO
ALTER TABLE [dbo].[Payments] CHECK CONSTRAINT [CK_Payments_Amount_Merge];
GO
ALTER TABLE [dbo].[Payments] WITH NOCHECK ADD CONSTRAINT [CK_Payments_PaymentStatus_Merge]
    CHECK (([PaymentStatus] = 'Cancelled' OR [PaymentStatus] = 'Refunded' OR [PaymentStatus] = 'Failed' OR [PaymentStatus] = 'Success' OR [PaymentStatus] = 'Pending'));
GO
ALTER TABLE [dbo].[Payments] CHECK CONSTRAINT [CK_Payments_PaymentStatus_Merge];
GO
ALTER TABLE [dbo].[Payments] WITH NOCHECK ADD CONSTRAINT [CK_Payments_PaymentType_Merge]
    CHECK (([PaymentType] = 'COD' OR [PaymentType] = 'Cash' OR [PaymentType] = 'VNPay'));
GO
ALTER TABLE [dbo].[Payments] CHECK CONSTRAINT [CK_Payments_PaymentType_Merge];
GO

-- Invoices
CREATE TABLE [dbo].[Invoices] (
    [InvoiceID]     INT            IDENTITY(1,1) NOT NULL,
    [OrderID]       INT            NOT NULL,
    [InvoiceNumber] NVARCHAR(50)   NOT NULL,
    [IssuedDate]    DATETIME2(0)   NOT NULL,
    [Subtotal]      DECIMAL(10, 2) NOT NULL,
    [TaxAmount]     DECIMAL(10, 2) NOT NULL,
    [FinalAmount]   DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY CLUSTERED ([InvoiceID] ASC)
);
GO
ALTER TABLE [dbo].[Invoices] ADD UNIQUE NONCLUSTERED ([OrderID] ASC);
GO
ALTER TABLE [dbo].[Invoices] ADD UNIQUE NONCLUSTERED ([InvoiceNumber] ASC);
GO
ALTER TABLE [dbo].[Invoices] ADD CONSTRAINT [DF_Invoices_IssuedDate] DEFAULT (sysutcdatetime()) FOR [IssuedDate];
GO
ALTER TABLE [dbo].[Invoices] ADD CONSTRAINT [DF_Invoices_Tax]        DEFAULT ((0))              FOR [TaxAmount];
GO
ALTER TABLE [dbo].[Invoices] WITH CHECK ADD CONSTRAINT [FK_Invoices_Orders]
    FOREIGN KEY ([OrderID]) REFERENCES [dbo].[Orders] ([OrderID]);
GO
ALTER TABLE [dbo].[Invoices] WITH CHECK ADD CHECK (([FinalAmount] >= (0)));
GO
ALTER TABLE [dbo].[Invoices] WITH CHECK ADD CHECK (([Subtotal] >= (0)));
GO
ALTER TABLE [dbo].[Invoices] WITH CHECK ADD CHECK (([TaxAmount] >= (0)));
GO

-- DeliveryInfo
CREATE TABLE [dbo].[DeliveryInfo] (
    [DeliveryID]   INT            IDENTITY(1,1) NOT NULL,
    [OrderID]      INT            NOT NULL,
    [ReceiverName] NVARCHAR(100)  NULL,
    [Phone]        NVARCHAR(20)   NULL,
    [Address]      NVARCHAR(255)  NOT NULL,
    [Latitude]     DECIMAL(10, 6) NULL,
    [Longitude]    DECIMAL(10, 6) NULL,
    [DeliveryNote] NVARCHAR(255)  NULL,
    [DeliveryStatus] NVARCHAR(30) NULL,
    [ShippedAt]    DATETIME2(0)   NULL,
    [DeliveredAt]  DATETIME2(0)   NULL,
    PRIMARY KEY CLUSTERED ([DeliveryID] ASC)
);
GO
ALTER TABLE [dbo].[DeliveryInfo] ADD UNIQUE NONCLUSTERED ([OrderID] ASC);
GO
ALTER TABLE [dbo].[DeliveryInfo] WITH CHECK ADD CONSTRAINT [FK_DeliveryInfo_Orders]
    FOREIGN KEY ([OrderID]) REFERENCES [dbo].[Orders] ([OrderID]);
GO
ALTER TABLE [dbo].[DeliveryInfo] WITH CHECK ADD CHECK (([DeliveryStatus] IS NULL OR ([DeliveryStatus] = 'Cancelled' OR [DeliveryStatus] = 'Delivered' OR [DeliveryStatus] = 'OnTheWay' OR [DeliveryStatus] = 'Assigned')));
GO

-- Reviews (bao gồm OrderID từ migration)
CREATE TABLE [dbo].[Reviews] (
    [ReviewID]     INT           IDENTITY(1,1) NOT NULL,
    [RestaurantID] INT           NOT NULL,
    [CustomerID]   INT           NOT NULL,
    [OrderID]      INT           NULL,
    [Rating]       INT           NOT NULL,
    [Comment]      NVARCHAR(255) NULL,
    [CreatedAt]    DATETIME2(0)  NOT NULL,
    PRIMARY KEY CLUSTERED ([ReviewID] ASC)
);
GO
ALTER TABLE [dbo].[Reviews] ADD CONSTRAINT [DF_Reviews_CreatedAt] DEFAULT (sysutcdatetime()) FOR [CreatedAt];
GO
ALTER TABLE [dbo].[Reviews] WITH CHECK ADD CONSTRAINT [FK_Reviews_Customers]
    FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Users] ([UserID]);
GO
ALTER TABLE [dbo].[Reviews] WITH CHECK ADD CONSTRAINT [FK_Reviews_Restaurants]
    FOREIGN KEY ([RestaurantID]) REFERENCES [dbo].[Restaurants] ([RestaurantID]);
GO
ALTER TABLE [dbo].[Reviews] WITH CHECK ADD CONSTRAINT [FK_Reviews_Orders]
    FOREIGN KEY ([OrderID]) REFERENCES [dbo].[Orders] ([OrderID]);
GO
ALTER TABLE [dbo].[Reviews] WITH CHECK ADD CHECK (([Rating] >= (1) AND [Rating] <= (5)));
GO

-- Complaints
CREATE TABLE [dbo].[Complaints] (
    [ComplaintID] INT           IDENTITY(1,1) NOT NULL,
    [OrderID]     INT           NULL,
    [CustomerID]  INT           NOT NULL,
    [Description] NVARCHAR(255) NOT NULL,
    [Status]      NVARCHAR(30)  NOT NULL,
    [CreatedAt]   DATETIME2(0)  NOT NULL,
    PRIMARY KEY CLUSTERED ([ComplaintID] ASC)
);
GO
ALTER TABLE [dbo].[Complaints] ADD CONSTRAINT [DF_Complaints_Status]    DEFAULT ('Open')            FOR [Status];
GO
ALTER TABLE [dbo].[Complaints] ADD CONSTRAINT [DF_Complaints_CreatedAt] DEFAULT (sysutcdatetime())  FOR [CreatedAt];
GO
ALTER TABLE [dbo].[Complaints] WITH CHECK ADD CONSTRAINT [FK_Complaints_Customers]
    FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Users] ([UserID]);
GO
ALTER TABLE [dbo].[Complaints] WITH CHECK ADD CONSTRAINT [FK_Complaints_Orders]
    FOREIGN KEY ([OrderID]) REFERENCES [dbo].[Orders] ([OrderID]);
GO
ALTER TABLE [dbo].[Complaints] WITH CHECK ADD CHECK (([Status] = 'Rejected' OR [Status] = 'Resolved' OR [Status] = 'InProgress' OR [Status] = 'Open'));
GO

-- BusinessHours
CREATE TABLE [dbo].[BusinessHours] (
    [HoursID]      INT           IDENTITY(1,1) NOT NULL,
    [RestaurantID] INT           NOT NULL,
    [DayOfWeek]    NVARCHAR(20)  NOT NULL,
    [OpeningTime]  TIME(7)       NULL,
    [ClosingTime]  TIME(7)       NULL,
    [IsOpen]       BIT           NOT NULL,
    PRIMARY KEY CLUSTERED ([HoursID] ASC)
);
GO
ALTER TABLE [dbo].[BusinessHours] ADD CONSTRAINT [UQ_BusinessHours_RestaurantDay]
    UNIQUE NONCLUSTERED ([RestaurantID] ASC, [DayOfWeek] ASC);
GO
ALTER TABLE [dbo].[BusinessHours] ADD CONSTRAINT [DF_BusinessHours_IsOpen] DEFAULT ((1)) FOR [IsOpen];
GO
ALTER TABLE [dbo].[BusinessHours] WITH CHECK ADD CONSTRAINT [FK_BusinessHours_Restaurants]
    FOREIGN KEY ([RestaurantID]) REFERENCES [dbo].[Restaurants] ([RestaurantID]);
GO
ALTER TABLE [dbo].[BusinessHours] WITH CHECK ADD CHECK (([DayOfWeek] = 'Sunday' OR [DayOfWeek] = 'Saturday' OR [DayOfWeek] = 'Friday' OR [DayOfWeek] = 'Thursday' OR [DayOfWeek] = 'Wednesday' OR [DayOfWeek] = 'Tuesday' OR [DayOfWeek] = 'Monday'));
GO

-- TemporaryClosures
CREATE TABLE [dbo].[TemporaryClosures] (
    [ClosureID]    INT           IDENTITY(1,1) NOT NULL,
    [RestaurantID] INT           NOT NULL,
    [StartDateTime] DATETIME2(0) NOT NULL,
    [EndDateTime]  DATETIME2(0)  NOT NULL,
    [Reason]       NVARCHAR(255) NULL,
    [IsActive]     BIT           NOT NULL,
    [CreatedAt]    DATETIME2(0)  NOT NULL,
    PRIMARY KEY CLUSTERED ([ClosureID] ASC)
);
GO
ALTER TABLE [dbo].[TemporaryClosures] ADD CONSTRAINT [DF_TemporaryClosures_IsActive]  DEFAULT ((1))              FOR [IsActive];
GO
ALTER TABLE [dbo].[TemporaryClosures] ADD CONSTRAINT [DF_TemporaryClosures_CreatedAt] DEFAULT (sysutcdatetime()) FOR [CreatedAt];
GO
ALTER TABLE [dbo].[TemporaryClosures] WITH CHECK ADD CONSTRAINT [FK_TemporaryClosures_Restaurants]
    FOREIGN KEY ([RestaurantID]) REFERENCES [dbo].[Restaurants] ([RestaurantID]);
GO
ALTER TABLE [dbo].[TemporaryClosures] WITH CHECK ADD CONSTRAINT [CK_TemporaryClosures_DateTime]
    CHECK (([EndDateTime] > [StartDateTime]));
GO
CREATE NONCLUSTERED INDEX [IX_TemporaryClosures_Active]
    ON [dbo].[TemporaryClosures] ([RestaurantID] ASC, [IsActive] ASC, [StartDateTime] ASC, [EndDateTime] ASC);
GO

-- TableReservations
CREATE TABLE [dbo].[TableReservations] (
    [ReservationID]  INT          IDENTITY(1,1) NOT NULL,
    [RestaurantID]   INT          NOT NULL,
    [TableID]        INT          NOT NULL,
    [CustomerID]     INT          NOT NULL,
    [ReservationDate] DATE        NOT NULL,
    [StartTime]      TIME(7)      NOT NULL,
    [EndTime]        TIME(7)      NOT NULL,
    [NumberOfGuests] INT          NULL,
    [Status]         NVARCHAR(30) NOT NULL,
    [CreatedAt]      DATETIME2(0) NOT NULL,
    PRIMARY KEY CLUSTERED ([ReservationID] ASC)
);
GO
ALTER TABLE [dbo].[TableReservations] ADD CONSTRAINT [DF_TableReservations_Status]    DEFAULT ('Pending')         FOR [Status];
GO
ALTER TABLE [dbo].[TableReservations] ADD CONSTRAINT [DF_TableReservations_CreatedAt] DEFAULT (sysutcdatetime())  FOR [CreatedAt];
GO
ALTER TABLE [dbo].[TableReservations] WITH CHECK ADD CONSTRAINT [FK_TableReservations_Customers]
    FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Users] ([UserID]);
GO
ALTER TABLE [dbo].[TableReservations] WITH CHECK ADD CONSTRAINT [FK_TableReservations_Restaurants]
    FOREIGN KEY ([RestaurantID]) REFERENCES [dbo].[Restaurants] ([RestaurantID]);
GO
ALTER TABLE [dbo].[TableReservations] WITH CHECK ADD CONSTRAINT [FK_TableReservations_Tables]
    FOREIGN KEY ([TableID]) REFERENCES [dbo].[RestaurantTables] ([TableID]);
GO
ALTER TABLE [dbo].[TableReservations] WITH CHECK ADD CHECK (([NumberOfGuests] IS NULL OR [NumberOfGuests] > (0)));
GO
ALTER TABLE [dbo].[TableReservations] WITH CHECK ADD CHECK (([Status] = 'Completed' OR [Status] = 'Cancelled' OR [Status] = 'Confirmed' OR [Status] = 'Pending'));
GO
ALTER TABLE [dbo].[TableReservations] WITH CHECK ADD CONSTRAINT [CK_TableReservations_Time]
    CHECK (([EndTime] > [StartTime]));
GO

-- RestaurantDeliveryZones
CREATE TABLE [dbo].[RestaurantDeliveryZones] (
    [ZoneID]         INT            IDENTITY(1,1) NOT NULL,
    [RestaurantID]   INT            NOT NULL,
    [ZoneName]       NVARCHAR(100)  NOT NULL,
    [ZoneDefinition] NVARCHAR(MAX)  NULL,
    [IsActive]       BIT            NOT NULL,
    [CreatedAt]      DATETIME2(0)   NOT NULL,
    PRIMARY KEY CLUSTERED ([ZoneID] ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
GO
ALTER TABLE [dbo].[RestaurantDeliveryZones] ADD CONSTRAINT [DF_RestaurantDeliveryZones_IsActive]  DEFAULT ((1))              FOR [IsActive];
GO
ALTER TABLE [dbo].[RestaurantDeliveryZones] ADD CONSTRAINT [DF_RestaurantDeliveryZones_CreatedAt] DEFAULT (sysutcdatetime()) FOR [CreatedAt];
GO
ALTER TABLE [dbo].[RestaurantDeliveryZones] WITH CHECK ADD CONSTRAINT [FK_RestaurantDeliveryZones_Restaurants]
    FOREIGN KEY ([RestaurantID]) REFERENCES [dbo].[Restaurants] ([RestaurantID]);
GO

-- DeliveryFees
CREATE TABLE [dbo].[DeliveryFees] (
    [FeeID]          INT            IDENTITY(1,1) NOT NULL,
    [ZoneID]         INT            NOT NULL,
    [FeeType]        NVARCHAR(30)   NOT NULL,
    [FeeValue]       DECIMAL(10, 2) NOT NULL,
    [MinOrderAmount] DECIMAL(10, 2) NULL,
    [MaxOrderAmount] DECIMAL(10, 2) NULL,
    [IsActive]       BIT            NOT NULL,
    [CreatedAt]      DATETIME2(0)   NOT NULL,
    PRIMARY KEY CLUSTERED ([FeeID] ASC)
);
GO
ALTER TABLE [dbo].[DeliveryFees] ADD CONSTRAINT [DF_DeliveryFees_IsActive]  DEFAULT ((1))              FOR [IsActive];
GO
ALTER TABLE [dbo].[DeliveryFees] ADD CONSTRAINT [DF_DeliveryFees_CreatedAt] DEFAULT (sysutcdatetime()) FOR [CreatedAt];
GO
ALTER TABLE [dbo].[DeliveryFees] WITH CHECK ADD CONSTRAINT [FK_DeliveryFees_DeliveryZones]
    FOREIGN KEY ([ZoneID]) REFERENCES [dbo].[RestaurantDeliveryZones] ([ZoneID]);
GO
ALTER TABLE [dbo].[DeliveryFees] WITH CHECK ADD CHECK (([FeeType] = 'FreeAboveAmount' OR [FeeType] = 'Flat' OR [FeeType] = 'PercentageOfOrder'));
GO
ALTER TABLE [dbo].[DeliveryFees] WITH CHECK ADD CHECK (([FeeValue] >= (0)));
GO
ALTER TABLE [dbo].[DeliveryFees] WITH CHECK ADD CHECK (([MaxOrderAmount] IS NULL OR [MaxOrderAmount] >= (0)));
GO
ALTER TABLE [dbo].[DeliveryFees] WITH CHECK ADD CHECK (([MinOrderAmount] IS NULL OR [MinOrderAmount] >= (0)));
GO

-- DeliveryFeeHistory
CREATE TABLE [dbo].[DeliveryFeeHistory] (
    [HistoryID]   INT            IDENTITY(1,1) NOT NULL,
    [FeeID]       INT            NOT NULL,
    [OldFeeType]  NVARCHAR(30)   NOT NULL,
    [NewFeeType]  NVARCHAR(30)   NOT NULL,
    [OldFeeValue] DECIMAL(10, 2) NOT NULL,
    [NewFeeValue] DECIMAL(10, 2) NOT NULL,
    [OldMinOrder] DECIMAL(10, 2) NULL,
    [NewMinOrder] DECIMAL(10, 2) NULL,
    [OldMaxOrder] DECIMAL(10, 2) NULL,
    [NewMaxOrder] DECIMAL(10, 2) NULL,
    [ChangedAt]   DATETIME2(0)   NOT NULL,
    [ChangedBy]   INT            NULL,
    PRIMARY KEY CLUSTERED ([HistoryID] ASC)
);
GO
ALTER TABLE [dbo].[DeliveryFeeHistory] ADD DEFAULT (sysutcdatetime()) FOR [ChangedAt];
GO
ALTER TABLE [dbo].[DeliveryFeeHistory] WITH CHECK ADD CONSTRAINT [FK_DeliveryFeeHistory_DeliveryFees]
    FOREIGN KEY ([FeeID]) REFERENCES [dbo].[DeliveryFees] ([FeeID]);
GO
ALTER TABLE [dbo].[DeliveryFeeHistory] WITH CHECK ADD CONSTRAINT [FK_DeliveryFeeHistory_Users]
    FOREIGN KEY ([ChangedBy]) REFERENCES [dbo].[Users] ([UserID]);
GO

-- RestaurantUsers
CREATE TABLE [dbo].[RestaurantUsers] (
    [RestaurantUserID] INT           IDENTITY(1,1) NOT NULL,
    [RestaurantID]     INT           NOT NULL,
    [UserID]           INT           NOT NULL,
    [RestaurantRole]   NVARCHAR(20)  NOT NULL,
    [IsActive]         BIT           NOT NULL,
    [CreatedAt]        DATETIME2(0)  NOT NULL,
    PRIMARY KEY CLUSTERED ([RestaurantUserID] ASC)
);
GO
ALTER TABLE [dbo].[RestaurantUsers] ADD CONSTRAINT [UQ_RestaurantUsers]
    UNIQUE NONCLUSTERED ([RestaurantID] ASC, [UserID] ASC);
GO
ALTER TABLE [dbo].[RestaurantUsers] ADD CONSTRAINT [DF_RestaurantUsers_IsActive]  DEFAULT ((1))              FOR [IsActive];
GO
ALTER TABLE [dbo].[RestaurantUsers] ADD CONSTRAINT [DF_RestaurantUsers_CreatedAt] DEFAULT (sysutcdatetime()) FOR [CreatedAt];
GO
ALTER TABLE [dbo].[RestaurantUsers] WITH CHECK ADD CONSTRAINT [FK_RestaurantUsers_Restaurants]
    FOREIGN KEY ([RestaurantID]) REFERENCES [dbo].[Restaurants] ([RestaurantID]);
GO
ALTER TABLE [dbo].[RestaurantUsers] WITH CHECK ADD CONSTRAINT [FK_RestaurantUsers_Users]
    FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID]);
GO
ALTER TABLE [dbo].[RestaurantUsers] WITH CHECK ADD CHECK (([RestaurantRole] = 'Manager' OR [RestaurantRole] = 'Staff' OR [RestaurantRole] = 'Owner'));
GO

-- ShiftTemplates
CREATE TABLE [dbo].[ShiftTemplates] (
    [TemplateID]   INT           IDENTITY(1,1) NOT NULL,
    [RestaurantID] INT           NOT NULL,
    [ShiftName]    NVARCHAR(100) NOT NULL,
    [Position]     NVARCHAR(50)  NULL,
    [StartTime]    TIME(7)       NOT NULL,
    [EndTime]      TIME(7)       NOT NULL,
    [IsActive]     BIT           NOT NULL,
    PRIMARY KEY CLUSTERED ([TemplateID] ASC)
);
GO
ALTER TABLE [dbo].[ShiftTemplates] ADD CONSTRAINT [DF_ShiftTemplates_IsActive] DEFAULT ((1)) FOR [IsActive];
GO
ALTER TABLE [dbo].[ShiftTemplates] WITH CHECK ADD CONSTRAINT [FK_ShiftTemplates_Restaurants]
    FOREIGN KEY ([RestaurantID]) REFERENCES [dbo].[Restaurants] ([RestaurantID]);
GO
ALTER TABLE [dbo].[ShiftTemplates] WITH CHECK ADD CONSTRAINT [CK_ShiftTemplates_Time]
    CHECK (([EndTime] > [StartTime]));
GO

-- EmployeeShifts
CREATE TABLE [dbo].[EmployeeShifts] (
    [ShiftID]          INT           IDENTITY(1,1) NOT NULL,
    [RestaurantID]     INT           NOT NULL,
    [StaffID]          INT           NOT NULL,
    [ShiftDate]        DATE          NOT NULL,
    [CreatedAt]        DATETIME2(0)  NOT NULL,
    [TemplateID]       INT           NOT NULL,
    [AttendanceStatus] NVARCHAR(20)  NULL,
    [MarkedBy]         INT           NULL,
    [MarkedAt]         DATETIME2(0)  NULL,
    [Note]             NVARCHAR(255) NULL,
    PRIMARY KEY CLUSTERED ([ShiftID] ASC)
);
GO
ALTER TABLE [dbo].[EmployeeShifts] ADD CONSTRAINT [DF_EmployeeShifts_CreatedAt] DEFAULT (sysutcdatetime()) FOR [CreatedAt];
GO
ALTER TABLE [dbo].[EmployeeShifts] WITH CHECK ADD CONSTRAINT [FK_EmployeeShifts_MarkedBy]
    FOREIGN KEY ([MarkedBy]) REFERENCES [dbo].[Users] ([UserID]);
GO
ALTER TABLE [dbo].[EmployeeShifts] WITH CHECK ADD CONSTRAINT [FK_EmployeeShifts_Restaurants]
    FOREIGN KEY ([RestaurantID]) REFERENCES [dbo].[Restaurants] ([RestaurantID]);
GO
ALTER TABLE [dbo].[EmployeeShifts] WITH CHECK ADD CONSTRAINT [FK_EmployeeShifts_Staff]
    FOREIGN KEY ([StaffID]) REFERENCES [dbo].[Users] ([UserID]);
GO
ALTER TABLE [dbo].[EmployeeShifts] WITH CHECK ADD CONSTRAINT [FK_EmployeeShifts_Template]
    FOREIGN KEY ([TemplateID]) REFERENCES [dbo].[ShiftTemplates] ([TemplateID]);
GO
ALTER TABLE [dbo].[EmployeeShifts] WITH CHECK ADD CONSTRAINT [CK_EmployeeShifts_AttendanceStatus]
    CHECK (([AttendanceStatus] = 'Excused' OR [AttendanceStatus] = 'Late' OR [AttendanceStatus] = 'Absent' OR [AttendanceStatus] = 'Present'));
GO

-- =====================================================
-- STEP 3: Tạo Views
-- =====================================================

GO
CREATE VIEW [dbo].[vw_TopDishes] AS
SELECT
    o.RestaurantID,
    mi.ItemID,
    mi.ItemName,
    SUM(oi.Quantity) AS TotalSold
FROM dbo.OrderItems oi
JOIN dbo.Orders o ON oi.OrderID = o.OrderID
JOIN dbo.MenuItems mi ON oi.ItemID = mi.ItemID
WHERE o.OrderStatus = 'Completed'
GROUP BY o.RestaurantID, mi.ItemID, mi.ItemName;
GO

CREATE VIEW [dbo].[vw_RevenueByDish] AS
SELECT
    o.RestaurantID,
    mi.ItemID,
    mi.ItemName,
    SUM(oi.Quantity * oi.UnitPrice) AS Revenue
FROM dbo.OrderItems oi
JOIN dbo.Orders o ON oi.OrderID = o.OrderID
JOIN dbo.MenuItems mi ON oi.ItemID = mi.ItemID
WHERE o.OrderStatus = 'Completed'
GROUP BY o.RestaurantID, mi.ItemID, mi.ItemName;
GO

CREATE VIEW [dbo].[vw_RestaurantAnalytics] AS
SELECT
    r.RestaurantID,
    r.Name AS RestaurantName,
    COUNT(o.OrderID) AS TotalOrders,
    SUM(CASE WHEN o.OrderStatus = 'Completed' THEN o.FinalAmount ELSE 0 END) AS TotalRevenue
FROM dbo.Restaurants r
LEFT JOIN dbo.Orders o ON r.RestaurantID = o.RestaurantID
GROUP BY r.RestaurantID, r.Name;
GO

CREATE VIEW [dbo].[vw_PeakHours] AS
SELECT
    RestaurantID,
    DATEPART(HOUR, CreatedAt) AS OrderHour,
    COUNT(*) AS TotalOrders
FROM dbo.Orders
WHERE OrderStatus = 'Completed'
GROUP BY RestaurantID, DATEPART(HOUR, CreatedAt);
GO

CREATE VIEW [dbo].[vw_InvoiceData] AS
SELECT
    o.OrderID,
    o.CreatedAt        AS OrderDateUTC,
    r.RestaurantID,
    r.Name             AS RestaurantName,
    u.UserID           AS CustomerID,
    u.FullName         AS CustomerName,
    o.OrderType,
    o.OrderStatus,
    o.TotalAmount,
    o.DiscountAmount,
    o.DeliveryFee,
    o.FinalAmount,
    o.PaymentMethod,
    o.PaymentStatus    AS OrderPaymentStatus,
    o.PaidAt           AS OrderPaidAt,
    p.PaymentType,
    p.PaymentStatus,
    p.IsPaid,
    p.TransactionRef,
    p.PaidAt,
    p.Amount,
    p.BankCode,
    p.ResponseCode,
    p.TransactionNo,
    p.TransactionStatus,
    di.Address         AS DeliveryAddress,
    di.DeliveryStatus,
    inv.InvoiceNumber,
    inv.IssuedDate,
    inv.Subtotal,
    inv.TaxAmount,
    inv.FinalAmount    AS InvoiceFinalAmount
FROM dbo.Orders o
JOIN dbo.Restaurants r    ON o.RestaurantID = r.RestaurantID
JOIN dbo.Users u          ON o.CustomerID   = u.UserID
LEFT JOIN dbo.Payments p  ON o.OrderID      = p.OrderID
LEFT JOIN dbo.DeliveryInfo di ON o.OrderID  = di.OrderID
LEFT JOIN dbo.Invoices inv    ON o.OrderID  = inv.OrderID;
GO

-- =====================================================
-- STEP 4: Insert dữ liệu mẫu
-- =====================================================

SET IDENTITY_INSERT [dbo].[Roles] ON;
INSERT [dbo].[Roles] ([RoleID], [RoleName]) VALUES (1, N'SuperAdmin');
INSERT [dbo].[Roles] ([RoleID], [RoleName]) VALUES (2, N'Owner');
INSERT [dbo].[Roles] ([RoleID], [RoleName]) VALUES (3, N'Staff');
INSERT [dbo].[Roles] ([RoleID], [RoleName]) VALUES (4, N'Customer');
SET IDENTITY_INSERT [dbo].[Roles] OFF;
GO

SET IDENTITY_INSERT [dbo].[Users] ON;
INSERT [dbo].[Users] ([UserID],[FullName],[Email],[PasswordHash],[Phone],[RoleID],[IsActive],[CreatedAt]) VALUES (2,N'System Admin',N'admin@mrm.com',N'admin123',N'0123456789',1,1,CAST(N'2026-01-21T16:20:25' AS DATETIME2));
INSERT [dbo].[Users] ([UserID],[FullName],[Email],[PasswordHash],[Phone],[RoleID],[IsActive],[CreatedAt]) VALUES (3,N'Restaurant Owner 1',N'owner1@restaurant.com',N'owner123',N'0987654321',2,1,CAST(N'2026-01-21T16:20:25' AS DATETIME2));
INSERT [dbo].[Users] ([UserID],[FullName],[Email],[PasswordHash],[Phone],[RoleID],[IsActive],[CreatedAt]) VALUES (4,N'Restaurant Owner 2',N'owner2@restaurant.com',N'owner123',N'0988888888',2,1,CAST(N'2026-01-21T16:20:25' AS DATETIME2));
INSERT [dbo].[Users] ([UserID],[FullName],[Email],[PasswordHash],[Phone],[RoleID],[IsActive],[CreatedAt]) VALUES (5,N'Customer Demo',N'customer@example.com',N'customer123',N'0912345678',4,1,CAST(N'2026-01-21T16:20:25' AS DATETIME2));
INSERT [dbo].[Users] ([UserID],[FullName],[Email],[PasswordHash],[Phone],[RoleID],[IsActive],[CreatedAt]) VALUES (6,N'Staff Phở Hà Nội',N'staff1@pho.com',N'staff123',N'0900000001',3,1,CAST(N'2026-02-11T15:56:10' AS DATETIME2));
INSERT [dbo].[Users] ([UserID],[FullName],[Email],[PasswordHash],[Phone],[RoleID],[IsActive],[CreatedAt]) VALUES (7,N'Staff Bún Bò Huế',N'staff2@bunbo.com',N'staff123',N'0900000002',3,1,CAST(N'2026-02-11T15:56:10' AS DATETIME2));
INSERT [dbo].[Users] ([UserID],[FullName],[Email],[PasswordHash],[Phone],[RoleID],[IsActive],[CreatedAt]) VALUES (8,N'Staff Cơm Tấm',N'staff3@comtam.com',N'staff123',N'0900000003',3,1,CAST(N'2026-02-11T15:56:10' AS DATETIME2));
INSERT [dbo].[Users] ([UserID],[FullName],[Email],[PasswordHash],[Phone],[RoleID],[IsActive],[CreatedAt]) VALUES (9,N'Staff Pho 01',N'pho_staff1@res.com',N'123456',N'0902000001',3,1,CAST(N'2026-02-11T16:40:02' AS DATETIME2));
INSERT [dbo].[Users] ([UserID],[FullName],[Email],[PasswordHash],[Phone],[RoleID],[IsActive],[CreatedAt]) VALUES (10,N'Staff Pho 02',N'pho_staff2@res.com',N'123456',N'0902000002',3,1,CAST(N'2026-02-11T16:40:02' AS DATETIME2));
INSERT [dbo].[Users] ([UserID],[FullName],[Email],[PasswordHash],[Phone],[RoleID],[IsActive],[CreatedAt]) VALUES (11,N'Staff Pho 03',N'pho_staff3@res.com',N'123456',N'0902000003',3,1,CAST(N'2026-02-11T16:40:02' AS DATETIME2));
INSERT [dbo].[Users] ([UserID],[FullName],[Email],[PasswordHash],[Phone],[RoleID],[IsActive],[CreatedAt]) VALUES (12,N'Staff BunBo 01',N'bunbo_staff1@res.com',N'123456',N'0903000001',3,1,CAST(N'2026-02-11T16:40:02' AS DATETIME2));
INSERT [dbo].[Users] ([UserID],[FullName],[Email],[PasswordHash],[Phone],[RoleID],[IsActive],[CreatedAt]) VALUES (13,N'Staff BunBo 02',N'bunbo_staff2@res.com',N'123456',N'0903000002',3,1,CAST(N'2026-02-11T16:40:02' AS DATETIME2));
INSERT [dbo].[Users] ([UserID],[FullName],[Email],[PasswordHash],[Phone],[RoleID],[IsActive],[CreatedAt]) VALUES (14,N'Staff BunBo 03',N'bunbo_staff3@res.com',N'123456',N'0903000003',3,1,CAST(N'2026-02-11T16:40:02' AS DATETIME2));
INSERT [dbo].[Users] ([UserID],[FullName],[Email],[PasswordHash],[Phone],[RoleID],[IsActive],[CreatedAt]) VALUES (15,N'Staff ComTam 01',N'comtam_staff1@res.com',N'123456',N'0904000001',3,1,CAST(N'2026-02-11T16:40:02' AS DATETIME2));
INSERT [dbo].[Users] ([UserID],[FullName],[Email],[PasswordHash],[Phone],[RoleID],[IsActive],[CreatedAt]) VALUES (16,N'Staff ComTam 02',N'comtam_staff2@res.com',N'123456',N'0904000002',3,1,CAST(N'2026-02-11T16:40:02' AS DATETIME2));
INSERT [dbo].[Users] ([UserID],[FullName],[Email],[PasswordHash],[Phone],[RoleID],[IsActive],[CreatedAt]) VALUES (17,N'Staff ComTam 03',N'comtam_staff3@res.com',N'123456',N'0904000003',3,1,CAST(N'2026-02-11T16:40:02' AS DATETIME2));
SET IDENTITY_INSERT [dbo].[Users] OFF;
GO

SET IDENTITY_INSERT [dbo].[Restaurants] ON;
INSERT [dbo].[Restaurants] ([RestaurantID],[OwnerID],[Name],[Address],[LicenseNumber],[LogoUrl],[ThemeColor],[IsOpen],[DeliveryFee],[CommissionRate],[Status],[CreatedAt]) VALUES (2,3,N'Phở Hà Nội',N'123 Nguyễn Huệ, Quận 1, TP.HCM',N'LIC-001-2026',NULL,NULL,1,15000.00,10.00,N'Approved',CAST(N'2026-01-21T16:20:34' AS DATETIME2));
INSERT [dbo].[Restaurants] ([RestaurantID],[OwnerID],[Name],[Address],[LicenseNumber],[LogoUrl],[ThemeColor],[IsOpen],[DeliveryFee],[CommissionRate],[Status],[CreatedAt]) VALUES (3,3,N'Bún Bò Huế Ngon',N'456 Lê Lợi, Quận 3, TP.HCM',N'LIC-002-2026',NULL,NULL,1,20000.00,10.00,N'Approved',CAST(N'2026-01-21T16:20:34' AS DATETIME2));
INSERT [dbo].[Restaurants] ([RestaurantID],[OwnerID],[Name],[Address],[LicenseNumber],[LogoUrl],[ThemeColor],[IsOpen],[DeliveryFee],[CommissionRate],[Status],[CreatedAt]) VALUES (4,4,N'Cơm Tấm Sài Gòn',N'789 Hai Bà Trưng, Quận 1, TP.HCM',N'LIC-003-2026',NULL,NULL,1,12000.00,10.00,N'Approved',CAST(N'2026-01-21T16:20:34' AS DATETIME2));
SET IDENTITY_INSERT [dbo].[Restaurants] OFF;
GO

SET IDENTITY_INSERT [dbo].[RestaurantUsers] ON;
INSERT [dbo].[RestaurantUsers] ([RestaurantUserID],[RestaurantID],[UserID],[RestaurantRole],[IsActive],[CreatedAt]) VALUES (1,2,3,N'Owner',1,CAST(N'2026-02-11T15:54:43' AS DATETIME2));
INSERT [dbo].[RestaurantUsers] ([RestaurantUserID],[RestaurantID],[UserID],[RestaurantRole],[IsActive],[CreatedAt]) VALUES (2,2,2,N'Manager',1,CAST(N'2026-02-11T15:54:43' AS DATETIME2));
INSERT [dbo].[RestaurantUsers] ([RestaurantUserID],[RestaurantID],[UserID],[RestaurantRole],[IsActive],[CreatedAt]) VALUES (3,3,3,N'Owner',1,CAST(N'2026-02-11T15:54:43' AS DATETIME2));
INSERT [dbo].[RestaurantUsers] ([RestaurantUserID],[RestaurantID],[UserID],[RestaurantRole],[IsActive],[CreatedAt]) VALUES (4,3,2,N'Manager',1,CAST(N'2026-02-11T15:54:43' AS DATETIME2));
INSERT [dbo].[RestaurantUsers] ([RestaurantUserID],[RestaurantID],[UserID],[RestaurantRole],[IsActive],[CreatedAt]) VALUES (5,4,4,N'Owner',1,CAST(N'2026-02-11T15:54:43' AS DATETIME2));
INSERT [dbo].[RestaurantUsers] ([RestaurantUserID],[RestaurantID],[UserID],[RestaurantRole],[IsActive],[CreatedAt]) VALUES (6,4,2,N'Manager',1,CAST(N'2026-02-11T15:54:43' AS DATETIME2));
INSERT [dbo].[RestaurantUsers] ([RestaurantUserID],[RestaurantID],[UserID],[RestaurantRole],[IsActive],[CreatedAt]) VALUES (7,2,6,N'Staff',1,CAST(N'2026-02-11T15:56:15' AS DATETIME2));
INSERT [dbo].[RestaurantUsers] ([RestaurantUserID],[RestaurantID],[UserID],[RestaurantRole],[IsActive],[CreatedAt]) VALUES (8,3,7,N'Staff',1,CAST(N'2026-02-11T15:56:15' AS DATETIME2));
INSERT [dbo].[RestaurantUsers] ([RestaurantUserID],[RestaurantID],[UserID],[RestaurantRole],[IsActive],[CreatedAt]) VALUES (9,4,8,N'Staff',1,CAST(N'2026-02-11T15:56:15' AS DATETIME2));
INSERT [dbo].[RestaurantUsers] ([RestaurantUserID],[RestaurantID],[UserID],[RestaurantRole],[IsActive],[CreatedAt]) VALUES (10,2,9,N'Staff',1,CAST(N'2026-02-11T16:40:07' AS DATETIME2));
INSERT [dbo].[RestaurantUsers] ([RestaurantUserID],[RestaurantID],[UserID],[RestaurantRole],[IsActive],[CreatedAt]) VALUES (11,2,10,N'Staff',1,CAST(N'2026-02-11T16:40:07' AS DATETIME2));
INSERT [dbo].[RestaurantUsers] ([RestaurantUserID],[RestaurantID],[UserID],[RestaurantRole],[IsActive],[CreatedAt]) VALUES (12,2,11,N'Staff',1,CAST(N'2026-02-11T16:40:07' AS DATETIME2));
INSERT [dbo].[RestaurantUsers] ([RestaurantUserID],[RestaurantID],[UserID],[RestaurantRole],[IsActive],[CreatedAt]) VALUES (13,3,12,N'Staff',1,CAST(N'2026-02-11T16:40:07' AS DATETIME2));
INSERT [dbo].[RestaurantUsers] ([RestaurantUserID],[RestaurantID],[UserID],[RestaurantRole],[IsActive],[CreatedAt]) VALUES (14,3,13,N'Staff',1,CAST(N'2026-02-11T16:40:07' AS DATETIME2));
INSERT [dbo].[RestaurantUsers] ([RestaurantUserID],[RestaurantID],[UserID],[RestaurantRole],[IsActive],[CreatedAt]) VALUES (15,3,14,N'Staff',1,CAST(N'2026-02-11T16:40:07' AS DATETIME2));
INSERT [dbo].[RestaurantUsers] ([RestaurantUserID],[RestaurantID],[UserID],[RestaurantRole],[IsActive],[CreatedAt]) VALUES (16,4,15,N'Staff',1,CAST(N'2026-02-11T16:40:07' AS DATETIME2));
INSERT [dbo].[RestaurantUsers] ([RestaurantUserID],[RestaurantID],[UserID],[RestaurantRole],[IsActive],[CreatedAt]) VALUES (17,4,16,N'Staff',1,CAST(N'2026-02-11T16:40:07' AS DATETIME2));
INSERT [dbo].[RestaurantUsers] ([RestaurantUserID],[RestaurantID],[UserID],[RestaurantRole],[IsActive],[CreatedAt]) VALUES (18,4,17,N'Staff',1,CAST(N'2026-02-11T16:40:07' AS DATETIME2));
SET IDENTITY_INSERT [dbo].[RestaurantUsers] OFF;
GO

SET IDENTITY_INSERT [dbo].[BusinessHours] ON;
INSERT [dbo].[BusinessHours] ([HoursID],[RestaurantID],[DayOfWeek],[OpeningTime],[ClosingTime],[IsOpen]) VALUES (2,2,N'Monday','09:00:00','19:00:00',1);
INSERT [dbo].[BusinessHours] ([HoursID],[RestaurantID],[DayOfWeek],[OpeningTime],[ClosingTime],[IsOpen]) VALUES (3,2,N'Tuesday','05:00:00','22:00:00',1);
INSERT [dbo].[BusinessHours] ([HoursID],[RestaurantID],[DayOfWeek],[OpeningTime],[ClosingTime],[IsOpen]) VALUES (4,2,N'Wednesday','09:00:00','22:00:00',1);
INSERT [dbo].[BusinessHours] ([HoursID],[RestaurantID],[DayOfWeek],[OpeningTime],[ClosingTime],[IsOpen]) VALUES (5,2,N'Thursday','09:00:00','22:00:00',1);
INSERT [dbo].[BusinessHours] ([HoursID],[RestaurantID],[DayOfWeek],[OpeningTime],[ClosingTime],[IsOpen]) VALUES (6,2,N'Friday','09:00:00','23:00:00',1);
INSERT [dbo].[BusinessHours] ([HoursID],[RestaurantID],[DayOfWeek],[OpeningTime],[ClosingTime],[IsOpen]) VALUES (7,2,N'Saturday','10:00:00','23:00:00',1);
INSERT [dbo].[BusinessHours] ([HoursID],[RestaurantID],[DayOfWeek],[OpeningTime],[ClosingTime],[IsOpen]) VALUES (8,2,N'Sunday','10:00:00','21:00:00',1);
INSERT [dbo].[BusinessHours] ([HoursID],[RestaurantID],[DayOfWeek],[OpeningTime],[ClosingTime],[IsOpen]) VALUES (9,3,N'Monday','09:00:00','22:00:00',1);
INSERT [dbo].[BusinessHours] ([HoursID],[RestaurantID],[DayOfWeek],[OpeningTime],[ClosingTime],[IsOpen]) VALUES (10,3,N'Tuesday','09:00:00','22:00:00',1);
INSERT [dbo].[BusinessHours] ([HoursID],[RestaurantID],[DayOfWeek],[OpeningTime],[ClosingTime],[IsOpen]) VALUES (11,3,N'Wednesday','09:00:00','22:00:00',1);
INSERT [dbo].[BusinessHours] ([HoursID],[RestaurantID],[DayOfWeek],[OpeningTime],[ClosingTime],[IsOpen]) VALUES (12,3,N'Thursday','09:00:00','22:00:00',1);
INSERT [dbo].[BusinessHours] ([HoursID],[RestaurantID],[DayOfWeek],[OpeningTime],[ClosingTime],[IsOpen]) VALUES (13,3,N'Friday','09:00:00','23:00:00',1);
INSERT [dbo].[BusinessHours] ([HoursID],[RestaurantID],[DayOfWeek],[OpeningTime],[ClosingTime],[IsOpen]) VALUES (14,3,N'Saturday','10:00:00','23:00:00',1);
INSERT [dbo].[BusinessHours] ([HoursID],[RestaurantID],[DayOfWeek],[OpeningTime],[ClosingTime],[IsOpen]) VALUES (15,3,N'Sunday','10:00:00','21:00:00',1);
INSERT [dbo].[BusinessHours] ([HoursID],[RestaurantID],[DayOfWeek],[OpeningTime],[ClosingTime],[IsOpen]) VALUES (16,4,N'Monday','09:00:00','22:00:00',1);
INSERT [dbo].[BusinessHours] ([HoursID],[RestaurantID],[DayOfWeek],[OpeningTime],[ClosingTime],[IsOpen]) VALUES (17,4,N'Tuesday','09:00:00','22:00:00',1);
INSERT [dbo].[BusinessHours] ([HoursID],[RestaurantID],[DayOfWeek],[OpeningTime],[ClosingTime],[IsOpen]) VALUES (18,4,N'Wednesday','09:00:00','22:00:00',1);
INSERT [dbo].[BusinessHours] ([HoursID],[RestaurantID],[DayOfWeek],[OpeningTime],[ClosingTime],[IsOpen]) VALUES (19,4,N'Thursday','09:00:00','22:00:00',1);
INSERT [dbo].[BusinessHours] ([HoursID],[RestaurantID],[DayOfWeek],[OpeningTime],[ClosingTime],[IsOpen]) VALUES (20,4,N'Friday','09:00:00','23:00:00',1);
INSERT [dbo].[BusinessHours] ([HoursID],[RestaurantID],[DayOfWeek],[OpeningTime],[ClosingTime],[IsOpen]) VALUES (21,4,N'Saturday','10:00:00','23:00:00',1);
INSERT [dbo].[BusinessHours] ([HoursID],[RestaurantID],[DayOfWeek],[OpeningTime],[ClosingTime],[IsOpen]) VALUES (22,4,N'Sunday','10:00:00','21:00:00',1);
SET IDENTITY_INSERT [dbo].[BusinessHours] OFF;
GO

SET IDENTITY_INSERT [dbo].[TemporaryClosures] ON;
INSERT [dbo].[TemporaryClosures] ([ClosureID],[RestaurantID],[StartDateTime],[EndDateTime],[Reason],[IsActive],[CreatedAt]) VALUES (4,2,CAST(N'2026-02-21T16:13:00' AS DATETIME2),CAST(N'2026-02-27T16:13:00' AS DATETIME2),N'122222',1,CAST(N'2026-02-11T09:13:33' AS DATETIME2));
SET IDENTITY_INSERT [dbo].[TemporaryClosures] OFF;
GO

SET IDENTITY_INSERT [dbo].[RestaurantTables] ON;
INSERT [dbo].[RestaurantTables] ([TableID],[RestaurantID],[TableNumber],[Capacity],[TableStatus],[IsActive]) VALUES (1,2,N'test',2123123,N'Available',1);
INSERT [dbo].[RestaurantTables] ([TableID],[RestaurantID],[TableNumber],[Capacity],[TableStatus],[IsActive]) VALUES (2,2,N'avád',2123,N'Available',1);
SET IDENTITY_INSERT [dbo].[RestaurantTables] OFF;
GO

SET IDENTITY_INSERT [dbo].[Discounts] ON;
INSERT [dbo].[Discounts] ([DiscountID],[RestaurantID],[Code],[DiscountType],[DiscountValue],[ExpiryDate],[IsActive],[CreatedAt],[Quantity],[MinOrderAmount],[MaxDiscountAmount],[UsageLimitPerUser]) VALUES (3,NULL,N'SP25',N'Percentage',11.00,CAST(N'2026-02-19T23:59:59' AS DATETIME2),0,CAST(N'2026-02-10T14:07:33' AS DATETIME2),100,0.00,NULL,1);
INSERT [dbo].[Discounts] ([DiscountID],[RestaurantID],[Code],[DiscountType],[DiscountValue],[ExpiryDate],[IsActive],[CreatedAt],[Quantity],[MinOrderAmount],[MaxDiscountAmount],[UsageLimitPerUser]) VALUES (5,NULL,N'joinus',N'Percentage',10.00,CAST(N'2026-02-21T23:59:59' AS DATETIME2),1,CAST(N'2026-02-10T14:27:13' AS DATETIME2),100,0.00,NULL,1);
SET IDENTITY_INSERT [dbo].[Discounts] OFF;
GO

SET IDENTITY_INSERT [dbo].[MenuCategories] ON;
INSERT [dbo].[MenuCategories] ([CategoryID],[RestaurantID],[CategoryName],[DisplayOrder],[IsActive]) VALUES (2,3,N'test',1,1);
INSERT [dbo].[MenuCategories] ([CategoryID],[RestaurantID],[CategoryName],[DisplayOrder],[IsActive]) VALUES (3,4,N'test11',2,1);
SET IDENTITY_INSERT [dbo].[MenuCategories] OFF;
GO

SET IDENTITY_INSERT [dbo].[MenuItems] ON;
INSERT [dbo].[MenuItems] ([ItemID],[RestaurantID],[CategoryID],[SKU],[ItemName],[Description],[Price],[IsAvailable],[CreatedAt],[ImageUrl]) VALUES (1,3,2,N'11',N'11111',N'111',50000.00,1,CAST(N'2026-02-10T14:51:15' AS DATETIME2),NULL);
SET IDENTITY_INSERT [dbo].[MenuItems] OFF;
GO

SET IDENTITY_INSERT [dbo].[ItemOptions] ON;
INSERT [dbo].[ItemOptions] ([OptionID],[ItemID],[OptionName],[AdditionalPrice],[IsActive]) VALUES (1,1,N'aaâ',10000.00,1);
SET IDENTITY_INSERT [dbo].[ItemOptions] OFF;
GO

SET IDENTITY_INSERT [dbo].[Orders] ON;
INSERT [dbo].[Orders] ([OrderID],[RestaurantID],[CustomerID],[OrderType],[TableID],[OrderStatus],[DiscountID],[TotalAmount],[DiscountAmount],[FinalAmount],[IsClosed],[CreatedAt],[DeliveryFee],[PaymentMethod],[PaymentStatus],[PaidAt]) VALUES (1,3,5,N'Online',NULL,N'Completed',NULL,100000.00,0.00,100000.00,1,CAST(N'2026-02-11T17:14:43' AS DATETIME2),0.00,N'VNPay',N'Pending',NULL);
INSERT [dbo].[Orders] ([OrderID],[RestaurantID],[CustomerID],[OrderType],[TableID],[OrderStatus],[DiscountID],[TotalAmount],[DiscountAmount],[FinalAmount],[IsClosed],[CreatedAt],[DeliveryFee],[PaymentMethod],[PaymentStatus],[PaidAt]) VALUES (2,3,5,N'Online',NULL,N'Completed',NULL,100000.00,0.00,100000.00,1,CAST(N'2026-02-11T17:15:50' AS DATETIME2),0.00,N'Cash',N'Pending',CAST(N'2026-02-11T17:15:50' AS DATETIME2));
INSERT [dbo].[Orders] ([OrderID],[RestaurantID],[CustomerID],[OrderType],[TableID],[OrderStatus],[DiscountID],[TotalAmount],[DiscountAmount],[FinalAmount],[IsClosed],[CreatedAt],[DeliveryFee],[PaymentMethod],[PaymentStatus],[PaidAt]) VALUES (3,3,5,N'Online',NULL,N'Completed',NULL,150000.00,0.00,150000.00,1,CAST(N'2026-03-17T17:22:26' AS DATETIME2),0.00,N'VNPay',N'Pending',NULL);
INSERT [dbo].[Orders] ([OrderID],[RestaurantID],[CustomerID],[OrderType],[TableID],[OrderStatus],[DiscountID],[TotalAmount],[DiscountAmount],[FinalAmount],[IsClosed],[CreatedAt],[DeliveryFee],[PaymentMethod],[PaymentStatus],[PaidAt]) VALUES (4,3,5,N'Online',NULL,N'Completed',NULL,200000.00,0.00,200000.00,1,CAST(N'2026-03-17T17:22:26' AS DATETIME2),0.00,N'VNPay',N'Pending',NULL);
INSERT [dbo].[Orders] ([OrderID],[RestaurantID],[CustomerID],[OrderType],[TableID],[OrderStatus],[DiscountID],[TotalAmount],[DiscountAmount],[FinalAmount],[IsClosed],[CreatedAt],[DeliveryFee],[PaymentMethod],[PaymentStatus],[PaidAt]) VALUES (7,3,5,N'Online',NULL,N'Completed',NULL,120000.00,0.00,120000.00,1,CAST(N'2026-03-12T17:24:10' AS DATETIME2),0.00,N'VNPay',N'Pending',NULL);
INSERT [dbo].[Orders] ([OrderID],[RestaurantID],[CustomerID],[OrderType],[TableID],[OrderStatus],[DiscountID],[TotalAmount],[DiscountAmount],[FinalAmount],[IsClosed],[CreatedAt],[DeliveryFee],[PaymentMethod],[PaymentStatus],[PaidAt]) VALUES (8,3,5,N'Online',NULL,N'Completed',NULL,250000.00,20000.00,230000.00,1,CAST(N'2026-03-13T17:24:10' AS DATETIME2),0.00,N'VNPay',N'Pending',NULL);
INSERT [dbo].[Orders] ([OrderID],[RestaurantID],[CustomerID],[OrderType],[TableID],[OrderStatus],[DiscountID],[TotalAmount],[DiscountAmount],[FinalAmount],[IsClosed],[CreatedAt],[DeliveryFee],[PaymentMethod],[PaymentStatus],[PaidAt]) VALUES (9,3,5,N'Online',NULL,N'Completed',NULL,90000.00,0.00,90000.00,1,CAST(N'2026-03-14T17:24:10' AS DATETIME2),0.00,N'VNPay',N'Pending',NULL);
INSERT [dbo].[Orders] ([OrderID],[RestaurantID],[CustomerID],[OrderType],[TableID],[OrderStatus],[DiscountID],[TotalAmount],[DiscountAmount],[FinalAmount],[IsClosed],[CreatedAt],[DeliveryFee],[PaymentMethod],[PaymentStatus],[PaidAt]) VALUES (10,3,5,N'Online',NULL,N'Completed',NULL,300000.00,50000.00,250000.00,1,CAST(N'2026-03-15T17:24:10' AS DATETIME2),0.00,N'VNPay',N'Pending',NULL);
INSERT [dbo].[Orders] ([OrderID],[RestaurantID],[CustomerID],[OrderType],[TableID],[OrderStatus],[DiscountID],[TotalAmount],[DiscountAmount],[FinalAmount],[IsClosed],[CreatedAt],[DeliveryFee],[PaymentMethod],[PaymentStatus],[PaidAt]) VALUES (11,3,5,N'Online',NULL,N'Completed',NULL,180000.00,0.00,180000.00,1,CAST(N'2026-03-16T17:24:10' AS DATETIME2),0.00,N'VNPay',N'Pending',NULL);
INSERT [dbo].[Orders] ([OrderID],[RestaurantID],[CustomerID],[OrderType],[TableID],[OrderStatus],[DiscountID],[TotalAmount],[DiscountAmount],[FinalAmount],[IsClosed],[CreatedAt],[DeliveryFee],[PaymentMethod],[PaymentStatus],[PaidAt]) VALUES (12,2,5,N'Online',NULL,N'Completed',NULL,130000.00,0.00,130000.00,1,CAST(N'2026-03-12T17:40:47' AS DATETIME2),0.00,N'VNPay',N'Pending',NULL);
INSERT [dbo].[Orders] ([OrderID],[RestaurantID],[CustomerID],[OrderType],[TableID],[OrderStatus],[DiscountID],[TotalAmount],[DiscountAmount],[FinalAmount],[IsClosed],[CreatedAt],[DeliveryFee],[PaymentMethod],[PaymentStatus],[PaidAt]) VALUES (13,2,5,N'Online',NULL,N'Completed',NULL,210000.00,10000.00,200000.00,1,CAST(N'2026-03-13T17:40:47' AS DATETIME2),0.00,N'VNPay',N'Pending',NULL);
INSERT [dbo].[Orders] ([OrderID],[RestaurantID],[CustomerID],[OrderType],[TableID],[OrderStatus],[DiscountID],[TotalAmount],[DiscountAmount],[FinalAmount],[IsClosed],[CreatedAt],[DeliveryFee],[PaymentMethod],[PaymentStatus],[PaidAt]) VALUES (14,2,5,N'Online',NULL,N'Completed',NULL,95000.00,0.00,95000.00,1,CAST(N'2026-03-14T17:40:47' AS DATETIME2),0.00,N'VNPay',N'Pending',NULL);
INSERT [dbo].[Orders] ([OrderID],[RestaurantID],[CustomerID],[OrderType],[TableID],[OrderStatus],[DiscountID],[TotalAmount],[DiscountAmount],[FinalAmount],[IsClosed],[CreatedAt],[DeliveryFee],[PaymentMethod],[PaymentStatus],[PaidAt]) VALUES (15,4,5,N'Online',NULL,N'Completed',NULL,175000.00,0.00,175000.00,1,CAST(N'2026-03-12T17:40:47' AS DATETIME2),0.00,N'VNPay',N'Pending',NULL);
INSERT [dbo].[Orders] ([OrderID],[RestaurantID],[CustomerID],[OrderType],[TableID],[OrderStatus],[DiscountID],[TotalAmount],[DiscountAmount],[FinalAmount],[IsClosed],[CreatedAt],[DeliveryFee],[PaymentMethod],[PaymentStatus],[PaidAt]) VALUES (16,4,5,N'Online',NULL,N'Completed',NULL,260000.00,20000.00,240000.00,1,CAST(N'2026-03-13T17:40:47' AS DATETIME2),0.00,N'VNPay',N'Pending',NULL);
INSERT [dbo].[Orders] ([OrderID],[RestaurantID],[CustomerID],[OrderType],[TableID],[OrderStatus],[DiscountID],[TotalAmount],[DiscountAmount],[FinalAmount],[IsClosed],[CreatedAt],[DeliveryFee],[PaymentMethod],[PaymentStatus],[PaidAt]) VALUES (17,4,5,N'Online',NULL,N'Completed',NULL,120000.00,0.00,120000.00,1,CAST(N'2026-03-15T17:40:47' AS DATETIME2),0.00,N'VNPay',N'Pending',NULL);
SET IDENTITY_INSERT [dbo].[Orders] OFF;
GO

SET IDENTITY_INSERT [dbo].[OrderItems] ON;
INSERT [dbo].[OrderItems] ([OrderItemID],[OrderID],[ItemID],[Quantity],[UnitPrice],[Note],[CreatedAt]) VALUES (1,1,1,2,50000.00,NULL,CAST(N'2026-02-11T17:14:48' AS DATETIME2));
INSERT [dbo].[OrderItems] ([OrderItemID],[OrderID],[ItemID],[Quantity],[UnitPrice],[Note],[CreatedAt]) VALUES (2,2,1,2,50000.00,NULL,CAST(N'2026-02-11T17:15:50' AS DATETIME2));
SET IDENTITY_INSERT [dbo].[OrderItems] OFF;
GO

SET IDENTITY_INSERT [dbo].[Payments] ON;
INSERT [dbo].[Payments] ([PaymentID],[OrderID],[PaymentType],[PaymentStatus],[IsPaid],[TransactionRef],[PaidAt],[CreatedAt],[CustomerID],[Amount],[BankCode],[CardType],[PayDate],[ResponseCode],[TransactionNo],[TransactionStatus],[SecureHash],[UpdatedAt]) VALUES (1,2,N'Cash',N'Completed',1,N'TXN-001',CAST(N'2026-02-11T17:15:50' AS DATETIME2),CAST(N'2026-02-11T17:15:50' AS DATETIME2),5,100000,NULL,NULL,NULL,NULL,NULL,NULL,NULL,CAST(N'2026-02-11T17:15:50' AS DATETIME2));
SET IDENTITY_INSERT [dbo].[Payments] OFF;
GO

SET IDENTITY_INSERT [dbo].[Invoices] ON;
INSERT [dbo].[Invoices] ([InvoiceID],[OrderID],[InvoiceNumber],[IssuedDate],[Subtotal],[TaxAmount],[FinalAmount]) VALUES (1,2,N'INV-2',CAST(N'2026-02-11T10:15:50' AS DATETIME2),100000.00,0.00,100000.00);
INSERT [dbo].[Invoices] ([InvoiceID],[OrderID],[InvoiceNumber],[IssuedDate],[Subtotal],[TaxAmount],[FinalAmount]) VALUES (7,3,N'INV-003',CAST(N'2026-03-17T17:22:30' AS DATETIME2),150000.00,15000.00,165000.00);
INSERT [dbo].[Invoices] ([InvoiceID],[OrderID],[InvoiceNumber],[IssuedDate],[Subtotal],[TaxAmount],[FinalAmount]) VALUES (8,4,N'INV-004',CAST(N'2026-03-17T17:22:30' AS DATETIME2),200000.00,20000.00,220000.00);
INSERT [dbo].[Invoices] ([InvoiceID],[OrderID],[InvoiceNumber],[IssuedDate],[Subtotal],[TaxAmount],[FinalAmount]) VALUES (9,1,N'INV-1',CAST(N'2026-02-11T17:14:43' AS DATETIME2),100000.00,10000.00,110000.00);
INSERT [dbo].[Invoices] ([InvoiceID],[OrderID],[InvoiceNumber],[IssuedDate],[Subtotal],[TaxAmount],[FinalAmount]) VALUES (10,7,N'INV-7',CAST(N'2026-03-12T17:24:10' AS DATETIME2),120000.00,12000.00,132000.00);
INSERT [dbo].[Invoices] ([InvoiceID],[OrderID],[InvoiceNumber],[IssuedDate],[Subtotal],[TaxAmount],[FinalAmount]) VALUES (11,8,N'INV-8',CAST(N'2026-03-13T17:24:10' AS DATETIME2),230000.00,23000.00,253000.00);
INSERT [dbo].[Invoices] ([InvoiceID],[OrderID],[InvoiceNumber],[IssuedDate],[Subtotal],[TaxAmount],[FinalAmount]) VALUES (12,9,N'INV-9',CAST(N'2026-03-14T17:24:10' AS DATETIME2),90000.00,9000.00,99000.00);
INSERT [dbo].[Invoices] ([InvoiceID],[OrderID],[InvoiceNumber],[IssuedDate],[Subtotal],[TaxAmount],[FinalAmount]) VALUES (13,10,N'INV-10',CAST(N'2026-03-15T17:24:10' AS DATETIME2),250000.00,25000.00,275000.00);
INSERT [dbo].[Invoices] ([InvoiceID],[OrderID],[InvoiceNumber],[IssuedDate],[Subtotal],[TaxAmount],[FinalAmount]) VALUES (14,11,N'INV-11',CAST(N'2026-03-16T17:24:10' AS DATETIME2),180000.00,18000.00,198000.00);
INSERT [dbo].[Invoices] ([InvoiceID],[OrderID],[InvoiceNumber],[IssuedDate],[Subtotal],[TaxAmount],[FinalAmount]) VALUES (15,12,N'INV-R2-12',CAST(N'2026-03-12T17:40:47' AS DATETIME2),130000.00,13000.00,143000.00);
INSERT [dbo].[Invoices] ([InvoiceID],[OrderID],[InvoiceNumber],[IssuedDate],[Subtotal],[TaxAmount],[FinalAmount]) VALUES (16,13,N'INV-R2-13',CAST(N'2026-03-13T17:40:47' AS DATETIME2),200000.00,20000.00,220000.00);
INSERT [dbo].[Invoices] ([InvoiceID],[OrderID],[InvoiceNumber],[IssuedDate],[Subtotal],[TaxAmount],[FinalAmount]) VALUES (17,14,N'INV-R2-14',CAST(N'2026-03-14T17:40:47' AS DATETIME2),95000.00,9500.00,104500.00);
INSERT [dbo].[Invoices] ([InvoiceID],[OrderID],[InvoiceNumber],[IssuedDate],[Subtotal],[TaxAmount],[FinalAmount]) VALUES (18,15,N'INV-R4-15',CAST(N'2026-03-12T17:40:47' AS DATETIME2),175000.00,17500.00,192500.00);
INSERT [dbo].[Invoices] ([InvoiceID],[OrderID],[InvoiceNumber],[IssuedDate],[Subtotal],[TaxAmount],[FinalAmount]) VALUES (19,16,N'INV-R4-16',CAST(N'2026-03-13T17:40:47' AS DATETIME2),240000.00,24000.00,264000.00);
INSERT [dbo].[Invoices] ([InvoiceID],[OrderID],[InvoiceNumber],[IssuedDate],[Subtotal],[TaxAmount],[FinalAmount]) VALUES (20,17,N'INV-R4-17',CAST(N'2026-03-15T17:40:47' AS DATETIME2),120000.00,12000.00,132000.00);
SET IDENTITY_INSERT [dbo].[Invoices] OFF;
GO

SET IDENTITY_INSERT [dbo].[RestaurantDeliveryZones] ON;
INSERT [dbo].[RestaurantDeliveryZones] ([ZoneID],[RestaurantID],[ZoneName],[ZoneDefinition],[IsActive],[CreatedAt]) VALUES (3,2,N'213',N'123',0,CAST(N'2026-01-21T16:21:23' AS DATETIME2));
INSERT [dbo].[RestaurantDeliveryZones] ([ZoneID],[RestaurantID],[ZoneName],[ZoneDefinition],[IsActive],[CreatedAt]) VALUES (4,2,N'123123123231123',N'123',1,CAST(N'2026-01-21T16:22:01' AS DATETIME2));
INSERT [dbo].[RestaurantDeliveryZones] ([ZoneID],[RestaurantID],[ZoneName],[ZoneDefinition],[IsActive],[CreatedAt]) VALUES (5,3,N'213',N'123',1,CAST(N'2026-01-21T16:25:08' AS DATETIME2));
INSERT [dbo].[RestaurantDeliveryZones] ([ZoneID],[RestaurantID],[ZoneName],[ZoneDefinition],[IsActive],[CreatedAt]) VALUES (6,2,N'test',N'123132311',1,CAST(N'2026-01-21T16:25:28' AS DATETIME2));
INSERT [dbo].[RestaurantDeliveryZones] ([ZoneID],[RestaurantID],[ZoneName],[ZoneDefinition],[IsActive],[CreatedAt]) VALUES (8,4,N'test123',N'123',1,CAST(N'2026-01-21T16:29:55' AS DATETIME2));
INSERT [dbo].[RestaurantDeliveryZones] ([ZoneID],[RestaurantID],[ZoneName],[ZoneDefinition],[IsActive],[CreatedAt]) VALUES (9,3,N'bun bò',N'123',1,CAST(N'2026-01-21T16:30:10' AS DATETIME2));
INSERT [dbo].[RestaurantDeliveryZones] ([ZoneID],[RestaurantID],[ZoneName],[ZoneDefinition],[IsActive],[CreatedAt]) VALUES (10,3,N'test bún',N'123',1,CAST(N'2026-01-21T16:34:13' AS DATETIME2));
INSERT [dbo].[RestaurantDeliveryZones] ([ZoneID],[RestaurantID],[ZoneName],[ZoneDefinition],[IsActive],[CreatedAt]) VALUES (11,4,N'test cơm',N'',1,CAST(N'2026-01-21T16:34:25' AS DATETIME2));
INSERT [dbo].[RestaurantDeliveryZones] ([ZoneID],[RestaurantID],[ZoneName],[ZoneDefinition],[IsActive],[CreatedAt]) VALUES (12,2,N'test phở',N'',1,CAST(N'2026-01-21T16:34:36' AS DATETIME2));
INSERT [dbo].[RestaurantDeliveryZones] ([ZoneID],[RestaurantID],[ZoneName],[ZoneDefinition],[IsActive],[CreatedAt]) VALUES (13,4,N'test pahan trang',N'',1,CAST(N'2026-01-21T17:28:20' AS DATETIME2));
INSERT [dbo].[RestaurantDeliveryZones] ([ZoneID],[RestaurantID],[ZoneName],[ZoneDefinition],[IsActive],[CreatedAt]) VALUES (14,4,N'bun bò paha tnragn',N'',1,CAST(N'2026-01-21T17:28:30' AS DATETIME2));
INSERT [dbo].[RestaurantDeliveryZones] ([ZoneID],[RestaurantID],[ZoneName],[ZoneDefinition],[IsActive],[CreatedAt]) VALUES (15,3,N'test cơm',N'123',1,CAST(N'2026-01-21T17:50:48' AS DATETIME2));
INSERT [dbo].[RestaurantDeliveryZones] ([ZoneID],[RestaurantID],[ZoneName],[ZoneDefinition],[IsActive],[CreatedAt]) VALUES (18,2,N'test cơm',N'',1,CAST(N'2026-01-21T18:11:10' AS DATETIME2));
INSERT [dbo].[RestaurantDeliveryZones] ([ZoneID],[RestaurantID],[ZoneName],[ZoneDefinition],[IsActive],[CreatedAt]) VALUES (19,3,N'111111',N'1',1,CAST(N'2026-02-10T14:42:22' AS DATETIME2));
SET IDENTITY_INSERT [dbo].[RestaurantDeliveryZones] OFF;
GO

SET IDENTITY_INSERT [dbo].[DeliveryFees] ON;
INSERT [dbo].[DeliveryFees] ([FeeID],[ZoneID],[FeeType],[FeeValue],[MinOrderAmount],[MaxOrderAmount],[IsActive],[CreatedAt]) VALUES (1,9,N'Flat',1212.00,NULL,NULL,1,CAST(N'2026-01-21T16:40:06' AS DATETIME2));
INSERT [dbo].[DeliveryFees] ([FeeID],[ZoneID],[FeeType],[FeeValue],[MinOrderAmount],[MaxOrderAmount],[IsActive],[CreatedAt]) VALUES (2,12,N'PercentageOfOrder',20.00,10000.00,50000.00,0,CAST(N'2026-01-21T16:40:23' AS DATETIME2));
INSERT [dbo].[DeliveryFees] ([FeeID],[ZoneID],[FeeType],[FeeValue],[MinOrderAmount],[MaxOrderAmount],[IsActive],[CreatedAt]) VALUES (3,11,N'FreeAboveAmount',1111.00,NULL,NULL,1,CAST(N'2026-01-21T16:40:34' AS DATETIME2));
INSERT [dbo].[DeliveryFees] ([FeeID],[ZoneID],[FeeType],[FeeValue],[MinOrderAmount],[MaxOrderAmount],[IsActive],[CreatedAt]) VALUES (5,14,N'Flat',123.00,123.00,123.00,1,CAST(N'2026-01-21T17:29:36' AS DATETIME2));
INSERT [dbo].[DeliveryFees] ([FeeID],[ZoneID],[FeeType],[FeeValue],[MinOrderAmount],[MaxOrderAmount],[IsActive],[CreatedAt]) VALUES (6,9,N'PercentageOfOrder',123.00,123.00,111111.00,0,CAST(N'2026-01-21T18:11:25' AS DATETIME2));
INSERT [dbo].[DeliveryFees] ([FeeID],[ZoneID],[FeeType],[FeeValue],[MinOrderAmount],[MaxOrderAmount],[IsActive],[CreatedAt]) VALUES (7,18,N'Flat',20.00,10000.00,NULL,1,CAST(N'2026-03-12T11:48:57' AS DATETIME2));
INSERT [dbo].[DeliveryFees] ([FeeID],[ZoneID],[FeeType],[FeeValue],[MinOrderAmount],[MaxOrderAmount],[IsActive],[CreatedAt]) VALUES (8,6,N'PercentageOfOrder',70.00,NULL,NULL,1,CAST(N'2026-03-12T13:27:41' AS DATETIME2));
SET IDENTITY_INSERT [dbo].[DeliveryFees] OFF;
GO

SET IDENTITY_INSERT [dbo].[DeliveryFeeHistory] ON;
INSERT [dbo].[DeliveryFeeHistory] ([HistoryID],[FeeID],[OldFeeType],[NewFeeType],[OldFeeValue],[NewFeeValue],[OldMinOrder],[NewMinOrder],[OldMaxOrder],[NewMaxOrder],[ChangedAt],[ChangedBy]) VALUES (1,2,N'PercentageOfOrder',N'PercentageOfOrder',121.00,121.00,NULL,10000.00,NULL,50000.00,CAST(N'2026-03-12T11:35:30' AS DATETIME2),3);
INSERT [dbo].[DeliveryFeeHistory] ([HistoryID],[FeeID],[OldFeeType],[NewFeeType],[OldFeeValue],[NewFeeValue],[OldMinOrder],[NewMinOrder],[OldMaxOrder],[NewMaxOrder],[ChangedAt],[ChangedBy]) VALUES (2,2,N'PercentageOfOrder',N'PercentageOfOrder',121.00,30.00,10000.00,10000.00,50000.00,50000.00,CAST(N'2026-03-12T11:36:14' AS DATETIME2),3);
INSERT [dbo].[DeliveryFeeHistory] ([HistoryID],[FeeID],[OldFeeType],[NewFeeType],[OldFeeValue],[NewFeeValue],[OldMinOrder],[NewMinOrder],[OldMaxOrder],[NewMaxOrder],[ChangedAt],[ChangedBy]) VALUES (3,2,N'PercentageOfOrder',N'PercentageOfOrder',30.00,20.00,10000.00,10000.00,50000.00,50000.00,CAST(N'2026-03-12T11:48:25' AS DATETIME2),3);
INSERT [dbo].[DeliveryFeeHistory] ([HistoryID],[FeeID],[OldFeeType],[NewFeeType],[OldFeeValue],[NewFeeValue],[OldMinOrder],[NewMinOrder],[OldMaxOrder],[NewMaxOrder],[ChangedAt],[ChangedBy]) VALUES (4,7,N'Flat',N'Flat',10.00,20.00,NULL,10000.00,NULL,NULL,CAST(N'2026-03-12T12:07:05' AS DATETIME2),3);
SET IDENTITY_INSERT [dbo].[DeliveryFeeHistory] OFF;
GO

SET IDENTITY_INSERT [dbo].[ShiftTemplates] ON;
INSERT [dbo].[ShiftTemplates] ([TemplateID],[RestaurantID],[ShiftName],[Position],[StartTime],[EndTime],[IsActive]) VALUES (2,2,N'Morning Shift',N'Server','09:00:00','15:00:00',1);
INSERT [dbo].[ShiftTemplates] ([TemplateID],[RestaurantID],[ShiftName],[Position],[StartTime],[EndTime],[IsActive]) VALUES (3,2,N'Evening Shift',N'Server','15:00:00','22:00:00',1);
INSERT [dbo].[ShiftTemplates] ([TemplateID],[RestaurantID],[ShiftName],[Position],[StartTime],[EndTime],[IsActive]) VALUES (4,2,N'Kitchen Morning',N'Chef','08:00:00','14:00:00',0);
INSERT [dbo].[ShiftTemplates] ([TemplateID],[RestaurantID],[ShiftName],[Position],[StartTime],[EndTime],[IsActive]) VALUES (5,2,N'Kitchen Evening',N'Chef','14:00:00','22:00:00',1);
INSERT [dbo].[ShiftTemplates] ([TemplateID],[RestaurantID],[ShiftName],[Position],[StartTime],[EndTime],[IsActive]) VALUES (6,3,N'Morning Shift',N'Server','09:00:00','15:00:00',1);
INSERT [dbo].[ShiftTemplates] ([TemplateID],[RestaurantID],[ShiftName],[Position],[StartTime],[EndTime],[IsActive]) VALUES (7,3,N'Evening Shift',N'Server','15:00:00','22:00:00',1);
INSERT [dbo].[ShiftTemplates] ([TemplateID],[RestaurantID],[ShiftName],[Position],[StartTime],[EndTime],[IsActive]) VALUES (8,3,N'Kitchen Morning',N'Chef','08:00:00','14:00:00',1);
INSERT [dbo].[ShiftTemplates] ([TemplateID],[RestaurantID],[ShiftName],[Position],[StartTime],[EndTime],[IsActive]) VALUES (9,3,N'Kitchen Evening',N'Chef','14:00:00','22:00:00',1);
INSERT [dbo].[ShiftTemplates] ([TemplateID],[RestaurantID],[ShiftName],[Position],[StartTime],[EndTime],[IsActive]) VALUES (10,4,N'Morning Shift',N'Server','09:00:00','15:00:00',1);
INSERT [dbo].[ShiftTemplates] ([TemplateID],[RestaurantID],[ShiftName],[Position],[StartTime],[EndTime],[IsActive]) VALUES (11,4,N'Evening Shift',N'Server','15:00:00','22:00:00',1);
INSERT [dbo].[ShiftTemplates] ([TemplateID],[RestaurantID],[ShiftName],[Position],[StartTime],[EndTime],[IsActive]) VALUES (12,4,N'Kitchen Morning',N'Chef','08:00:00','14:00:00',1);
INSERT [dbo].[ShiftTemplates] ([TemplateID],[RestaurantID],[ShiftName],[Position],[StartTime],[EndTime],[IsActive]) VALUES (13,4,N'Kitchen Evening',N'Chef','14:00:00','22:00:00',1);
INSERT [dbo].[ShiftTemplates] ([TemplateID],[RestaurantID],[ShiftName],[Position],[StartTime],[EndTime],[IsActive]) VALUES (14,2,N'123',N'123','13:17:00','18:18:00',1);
INSERT [dbo].[ShiftTemplates] ([TemplateID],[RestaurantID],[ShiftName],[Position],[StartTime],[EndTime],[IsActive]) VALUES (15,2,N'Kitchen Morning',N'Chef','07:50:00','18:50:00',1);
INSERT [dbo].[ShiftTemplates] ([TemplateID],[RestaurantID],[ShiftName],[Position],[StartTime],[EndTime],[IsActive]) VALUES (16,2,N'test',N'','05:27:00','17:27:00',1);
SET IDENTITY_INSERT [dbo].[ShiftTemplates] OFF;
GO

SET IDENTITY_INSERT [dbo].[EmployeeShifts] ON;
INSERT [dbo].[EmployeeShifts] ([ShiftID],[RestaurantID],[StaffID],[ShiftDate],[CreatedAt],[TemplateID],[AttendanceStatus],[MarkedBy],[MarkedAt],[Note]) VALUES (2,2,6,CAST(N'2026-02-21' AS DATE),CAST(N'2026-02-11T09:33:51' AS DATETIME2),14,N'Late',3,CAST(N'2026-03-25T13:49:28' AS DATETIME2),N'');
INSERT [dbo].[EmployeeShifts] ([ShiftID],[RestaurantID],[StaffID],[ShiftDate],[CreatedAt],[TemplateID],[AttendanceStatus],[MarkedBy],[MarkedAt],[Note]) VALUES (3,2,6,CAST(N'2026-02-15' AS DATE),CAST(N'2026-02-11T09:34:10' AS DATETIME2),14,N'Excused',3,CAST(N'2026-03-25T13:49:30' AS DATETIME2),N'');
INSERT [dbo].[EmployeeShifts] ([ShiftID],[RestaurantID],[StaffID],[ShiftDate],[CreatedAt],[TemplateID],[AttendanceStatus],[MarkedBy],[MarkedAt],[Note]) VALUES (4,2,10,CAST(N'2026-02-22' AS DATE),CAST(N'2026-02-11T09:40:51' AS DATETIME2),2,N'Present',3,CAST(N'2026-03-25T13:45:52' AS DATETIME2),N'');
INSERT [dbo].[EmployeeShifts] ([ShiftID],[RestaurantID],[StaffID],[ShiftDate],[CreatedAt],[TemplateID],[AttendanceStatus],[MarkedBy],[MarkedAt],[Note]) VALUES (5,4,8,CAST(N'2026-02-13' AS DATE),CAST(N'2026-02-11T09:43:29' AS DATETIME2),10,NULL,NULL,NULL,NULL);
INSERT [dbo].[EmployeeShifts] ([ShiftID],[RestaurantID],[StaffID],[ShiftDate],[CreatedAt],[TemplateID],[AttendanceStatus],[MarkedBy],[MarkedAt],[Note]) VALUES (6,2,10,CAST(N'2026-01-26' AS DATE),CAST(N'2026-02-11T09:49:21' AS DATETIME2),2,N'Absent',3,CAST(N'2026-03-25T13:49:35' AS DATETIME2),N'');
INSERT [dbo].[EmployeeShifts] ([ShiftID],[RestaurantID],[StaffID],[ShiftDate],[CreatedAt],[TemplateID],[AttendanceStatus],[MarkedBy],[MarkedAt],[Note]) VALUES (7,2,9,CAST(N'2026-03-29' AS DATE),CAST(N'2026-03-22T10:27:39' AS DATETIME2),16,N'Present',3,CAST(N'2026-03-25T13:45:15' AS DATETIME2),N'');
SET IDENTITY_INSERT [dbo].[EmployeeShifts] OFF;
GO

-- =====================================================
-- DONE
-- =====================================================
PRINT '========================================';
PRINT 'Database MultiRestaurantOrderingDB_Merged';
PRINT 'created successfully!';
PRINT 'Reviews.OrderID column included.';
PRINT '========================================';
GO

USE [master];
GO
ALTER DATABASE [MultiRestaurantOrderingDB_Merged] SET READ_WRITE;
GO