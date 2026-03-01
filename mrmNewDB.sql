USE [master]
GO
/****** Object:  Database [MultiRestaurantOrderingDB]    Script Date: 1/22/2026 12:24:43 AM ******/
-- Create database in instance default data path (portable across SQL Server installations)
CREATE DATABASE [MultiRestaurantOrderingDB]
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MultiRestaurantOrderingDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET  ENABLE_BROKER 
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET RECOVERY FULL 
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET  MULTI_USER 
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'MultiRestaurantOrderingDB', N'ON'
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET QUERY_STORE = ON
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [MultiRestaurantOrderingDB]
GO
/****** Object:  Table [dbo].[MenuItems]    Script Date: 1/22/2026 12:24:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenuItems](
	[ItemID] [int] IDENTITY(1,1) NOT NULL,
	[RestaurantID] [int] NOT NULL,
	[CategoryID] [int] NOT NULL,
	[SKU] [nvarchar](50) NULL,
	[ItemName] [nvarchar](150) NOT NULL,
	[Description] [nvarchar](255) NULL,
	[Price] [decimal](10, 2) NOT NULL,
	[IsAvailable] [bit] NOT NULL,
    [ImageUrl] [nvarchar](255),
	[AverageRating]  AS (CONVERT([decimal](4,2),NULL)) PERSISTED,
	[CreatedAt] [datetime2](0) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 1/22/2026 12:24:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
	[RestaurantID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[OrderType] [nvarchar](20) NOT NULL,
	[TableID] [int] NULL,
	[OrderStatus] [nvarchar](30) NOT NULL,
	[DiscountID] [int] NULL,
	[TotalAmount] [decimal](10, 2) NOT NULL,
	[DiscountAmount] [decimal](10, 2) NOT NULL,
	[FinalAmount] [decimal](10, 2) NOT NULL,
	[PaymentMethod] [nvarchar](50) NULL,
	[PaymentStatus] [nvarchar](30) NOT NULL DEFAULT 'Pending',
	[PaidAt] [datetime2](0) NULL,
	[IsClosed] [bit] NOT NULL,
	[CreatedAt] [datetime2](0) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderItems]    Script Date: 1/22/2026 12:24:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderItems](
	[OrderItemID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NOT NULL,
	[ItemID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[UnitPrice] [decimal](10, 2) NOT NULL,
	[Note] [nvarchar](255) NULL,
	[CreatedAt] [datetime2](0) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_TopDishes]    Script Date: 1/22/2026 12:24:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- US19: Top dishes by quantity
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
/****** Object:  View [dbo].[vw_RevenueByDish]    Script Date: 1/22/2026 12:24:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- US19: Revenue by dish
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
/****** Object:  Table [dbo].[Restaurants]    Script Date: 1/22/2026 12:24:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Restaurants](
	[RestaurantID] [int] IDENTITY(1,1) NOT NULL,
	[OwnerID] [int] NOT NULL,
	[Name] [nvarchar](150) NOT NULL,
	[Address] [nvarchar](255) NULL,
	[LicenseNumber] [nvarchar](50) NULL,
	[LogoUrl] [nvarchar](255) NULL,
	[ThemeColor] [nvarchar](20) NULL,
	[IsOpen] [bit] NOT NULL,
	[DeliveryFee] [decimal](10, 2) NULL,
	[CommissionRate] [decimal](5, 2) NULL,
	[Status] [nvarchar](20) NOT NULL,
	[CreatedAt] [datetime2](0) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RestaurantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_RestaurantAnalytics]    Script Date: 1/22/2026 12:24:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- System-wide admin dashboard (US17)
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
/****** Object:  Table [dbo].[Users]    Script Date: 1/22/2026 12:24:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[FullName] [nvarchar](100) NOT NULL,
	[Email] [nvarchar](100) NOT NULL,
	[PasswordHash] [nvarchar](255) NOT NULL,
	[Phone] [nvarchar](20) NULL,
	[RoleID] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime2](0) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeliveryInfo]    Script Date: 1/22/2026 12:24:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliveryInfo](
	[DeliveryID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NOT NULL,
	[ReceiverName] [nvarchar](100) NULL,
	[Phone] [nvarchar](20) NULL,
	[Address] [nvarchar](255) NOT NULL,
	[Latitude] [decimal](10, 6) NULL,
	[Longitude] [decimal](10, 6) NULL,
	[DeliveryNote] [nvarchar](255) NULL,
	[DeliveryStatus] [nvarchar](30) NULL,
	[ShippedAt] [datetime2](0) NULL,
	[DeliveredAt] [datetime2](0) NULL,
PRIMARY KEY CLUSTERED 
(
	[DeliveryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Payments]    Script Date: 1/22/2026 12:24:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payments](
	[PaymentID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[PaymentType] [nvarchar](30) NOT NULL,
	[PaymentStatus] [nvarchar](30) NOT NULL,
	[Amount] [bigint] NOT NULL,
	[TransactionRef] [nvarchar](100) NULL,
	[BankCode] [nvarchar](50) NULL,
	[CardType] [nvarchar](50) NULL,
	[PayDate] [nvarchar](14) NULL,
	[ResponseCode] [nvarchar](10) NULL,
	[TransactionNo] [nvarchar](50) NULL,
	[TransactionStatus] [nvarchar](10) NULL,
	[SecureHash] [nvarchar](255) NULL,
	[PaidAt] [datetime2](0) NULL,
	[CreatedAt] [datetime2](0) NOT NULL,
	[UpdatedAt] [datetime2](0) NULL,
PRIMARY KEY CLUSTERED 
(
	[PaymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Invoices]    Script Date: 1/22/2026 12:24:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoices](
	[InvoiceID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NOT NULL,
	[InvoiceNumber] [nvarchar](50) NOT NULL,
	[IssuedDate] [datetime2](0) NOT NULL,
	[Subtotal] [decimal](10, 2) NOT NULL,
	[TaxAmount] [decimal](10, 2) NOT NULL,
	[FinalAmount] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[InvoiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_InvoiceData]    Script Date: 1/22/2026 12:24:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- US20: Invoice export dataset (for PDF/Excel)
CREATE VIEW [dbo].[vw_InvoiceData] AS
SELECT
    o.OrderID,
    o.CreatedAt AS OrderDateUTC,
    r.RestaurantID,
    r.Name AS RestaurantName,
    u.UserID AS CustomerID,
    u.FullName AS CustomerName,

    o.OrderType,
    o.OrderStatus,
    o.TotalAmount,
    o.DiscountAmount,
    o.FinalAmount,
    o.PaymentMethod,
    o.PaymentStatus AS OrderPaymentStatus,
    o.PaidAt AS OrderPaidAt,

    p.PaymentType,
    p.PaymentStatus,
    p.TransactionRef,
    p.PaidAt,
    p.Amount,
    p.BankCode,
    p.ResponseCode,

    di.Address AS DeliveryAddress,
    di.DeliveryStatus,
    inv.InvoiceNumber,
    inv.IssuedDate,
    inv.TaxAmount
FROM dbo.Orders o
JOIN dbo.Restaurants r ON o.RestaurantID = r.RestaurantID
JOIN dbo.Users u ON o.CustomerID = u.UserID
LEFT JOIN dbo.Payments p ON o.OrderID = p.OrderID
LEFT JOIN dbo.DeliveryInfo di ON o.OrderID = di.OrderID
LEFT JOIN dbo.Invoices inv ON o.OrderID = inv.OrderID;
GO
/****** Object:  View [dbo].[vw_PeakHours]    Script Date: 1/22/2026 12:24:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* =========================================================
   14) Views for US19 (Analytics) + US20 (Invoice Export)
   ========================================================= */

-- US19: Peak hours
CREATE VIEW [dbo].[vw_PeakHours] AS
SELECT
    RestaurantID,
    DATEPART(HOUR, CreatedAt) AS OrderHour,
    COUNT(*) AS TotalOrders
FROM dbo.Orders
WHERE OrderStatus = 'Completed'
GROUP BY RestaurantID, DATEPART(HOUR, CreatedAt);
GO
/****** Object:  Table [dbo].[Complaints]    Script Date: 1/22/2026 12:24:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Complaints](
	[ComplaintID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NULL,
	[CustomerID] [int] NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[Status] [nvarchar](30) NOT NULL,
	[CreatedAt] [datetime2](0) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ComplaintID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeliveryFees]    Script Date: 1/22/2026 12:24:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliveryFees](
	[FeeID] [int] IDENTITY(1,1) NOT NULL,
	[ZoneID] [int] NOT NULL,
	[FeeType] [nvarchar](30) NOT NULL,
	[FeeValue] [decimal](10, 2) NOT NULL,
	[MinOrderAmount] [decimal](10, 2) NULL,
	[MaxOrderAmount] [decimal](10, 2) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime2](0) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Discounts]    Script Date: 1/22/2026 12:24:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Discounts](
	[DiscountID] [int] IDENTITY(1,1) NOT NULL,
	[RestaurantID] [int] NULL,
	[Code] [nvarchar](50) NOT NULL,
	[DiscountType] [nvarchar](20) NOT NULL,
	[DiscountValue] [decimal](10, 2) NOT NULL,
	[ExpiryDate] [datetime2](0) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime2](0) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DiscountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeShifts]    Script Date: 1/22/2026 12:24:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeShifts](
	[ShiftID] [int] IDENTITY(1,1) NOT NULL,
	[RestaurantID] [int] NOT NULL,
	[StaffID] [int] NOT NULL,
	[ShiftDate] [date] NOT NULL,
	[StartTime] [time](7) NOT NULL,
	[EndTime] [time](7) NOT NULL,
	[Position] [nvarchar](50) NULL,
	[CreatedAt] [datetime2](0) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ShiftID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ItemOptions]    Script Date: 1/22/2026 12:24:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ItemOptions](
	[OptionID] [int] IDENTITY(1,1) NOT NULL,
	[ItemID] [int] NOT NULL,
	[OptionName] [nvarchar](100) NOT NULL,
	[AdditionalPrice] [decimal](10, 2) NOT NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[OptionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MenuCategories]    Script Date: 1/22/2026 12:24:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenuCategories](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[RestaurantID] [int] NOT NULL,
	[CategoryName] [nvarchar](100) NOT NULL,
	[DisplayOrder] [int] NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RestaurantDeliveryZones]    Script Date: 1/22/2026 12:24:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RestaurantDeliveryZones](
	[ZoneID] [int] IDENTITY(1,1) NOT NULL,
	[RestaurantID] [int] NOT NULL,
	[ZoneName] [nvarchar](100) NOT NULL,
	[ZoneDefinition] [nvarchar](max) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime2](0) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ZoneID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RestaurantTables]    Script Date: 1/22/2026 12:24:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RestaurantTables](
	[TableID] [int] IDENTITY(1,1) NOT NULL,
	[RestaurantID] [int] NOT NULL,
	[TableNumber] [nvarchar](20) NOT NULL,
	[Capacity] [int] NOT NULL,
	[TableStatus] [nvarchar](20) NOT NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TableID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RestaurantUsers]    Script Date: 1/22/2026 12:24:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RestaurantUsers](
	[RestaurantUserID] [int] IDENTITY(1,1) NOT NULL,
	[RestaurantID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[RestaurantRole] [nvarchar](20) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime2](0) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RestaurantUserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reviews]    Script Date: 1/22/2026 12:24:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reviews](
	[ReviewID] [int] IDENTITY(1,1) NOT NULL,
	[RestaurantID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[Rating] [int] NOT NULL,
	[Comment] [nvarchar](255) NULL,
	[CreatedAt] [datetime2](0) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ReviewID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE Reviews ADD OrderID INT NULL;
ALTER TABLE Reviews ADD CONSTRAINT FK_Reviews_Orders FOREIGN KEY (OrderID) REFERENCES Orders(OrderID);
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 1/22/2026 12:24:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[RoleID] [int] IDENTITY(1,1) NOT NULL,
	[RoleName] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TableReservations]    Script Date: 1/22/2026 12:24:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TableReservations](
	[ReservationID] [int] IDENTITY(1,1) NOT NULL,
	[RestaurantID] [int] NOT NULL,
	[TableID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[ReservationDate] [date] NOT NULL,
	[StartTime] [time](7) NOT NULL,
	[EndTime] [time](7) NOT NULL,
	[NumberOfGuests] [int] NULL,
	[Status] [nvarchar](30) NOT NULL,
	[CreatedAt] [datetime2](0) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ReservationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[DeliveryFees] ON 

INSERT [dbo].[DeliveryFees] ([FeeID], [ZoneID], [FeeType], [FeeValue], [MinOrderAmount], [MaxOrderAmount], [IsActive], [CreatedAt]) VALUES (1, 9, N'Flat', CAST(1212.00 AS Decimal(10, 2)), NULL, NULL, 0, CAST(N'2026-01-21T16:40:06.0000000' AS DateTime2))
INSERT [dbo].[DeliveryFees] ([FeeID], [ZoneID], [FeeType], [FeeValue], [MinOrderAmount], [MaxOrderAmount], [IsActive], [CreatedAt]) VALUES (2, 12, N'PercentageOfOrder', CAST(121.00 AS Decimal(10, 2)), NULL, NULL, 1, CAST(N'2026-01-21T16:40:23.0000000' AS DateTime2))
INSERT [dbo].[DeliveryFees] ([FeeID], [ZoneID], [FeeType], [FeeValue], [MinOrderAmount], [MaxOrderAmount], [IsActive], [CreatedAt]) VALUES (3, 11, N'FreeAboveAmount', CAST(1111.00 AS Decimal(10, 2)), NULL, NULL, 0, CAST(N'2026-01-21T16:40:34.0000000' AS DateTime2))
SET IDENTITY_INSERT [dbo].[DeliveryFees] OFF
GO
SET IDENTITY_INSERT [dbo].[RestaurantDeliveryZones] ON 

INSERT [dbo].[RestaurantDeliveryZones] ([ZoneID], [RestaurantID], [ZoneName], [ZoneDefinition], [IsActive], [CreatedAt]) VALUES (3, 2, N'213', N'123', 0, CAST(N'2026-01-21T16:21:23.0000000' AS DateTime2))
INSERT [dbo].[RestaurantDeliveryZones] ([ZoneID], [RestaurantID], [ZoneName], [ZoneDefinition], [IsActive], [CreatedAt]) VALUES (4, 2, N'123123123231123', N'123', 0, CAST(N'2026-01-21T16:22:01.0000000' AS DateTime2))
INSERT [dbo].[RestaurantDeliveryZones] ([ZoneID], [RestaurantID], [ZoneName], [ZoneDefinition], [IsActive], [CreatedAt]) VALUES (5, 3, N'213', N'123', 1, CAST(N'2026-01-21T16:25:08.0000000' AS DateTime2))
INSERT [dbo].[RestaurantDeliveryZones] ([ZoneID], [RestaurantID], [ZoneName], [ZoneDefinition], [IsActive], [CreatedAt]) VALUES (6, 2, N'test', N'123132311', 0, CAST(N'2026-01-21T16:25:28.0000000' AS DateTime2))
INSERT [dbo].[RestaurantDeliveryZones] ([ZoneID], [RestaurantID], [ZoneName], [ZoneDefinition], [IsActive], [CreatedAt]) VALUES (8, 4, N'test123', N'123', 1, CAST(N'2026-01-21T16:29:55.0000000' AS DateTime2))
INSERT [dbo].[RestaurantDeliveryZones] ([ZoneID], [RestaurantID], [ZoneName], [ZoneDefinition], [IsActive], [CreatedAt]) VALUES (9, 3, N'bun b?', N'123', 1, CAST(N'2026-01-21T16:30:10.0000000' AS DateTime2))
INSERT [dbo].[RestaurantDeliveryZones] ([ZoneID], [RestaurantID], [ZoneName], [ZoneDefinition], [IsActive], [CreatedAt]) VALUES (10, 3, N'test b?n', N'123', 1, CAST(N'2026-01-21T16:34:13.0000000' AS DateTime2))
INSERT [dbo].[RestaurantDeliveryZones] ([ZoneID], [RestaurantID], [ZoneName], [ZoneDefinition], [IsActive], [CreatedAt]) VALUES (11, 4, N'test c?m', N'', 1, CAST(N'2026-01-21T16:34:25.0000000' AS DateTime2))
INSERT [dbo].[RestaurantDeliveryZones] ([ZoneID], [RestaurantID], [ZoneName], [ZoneDefinition], [IsActive], [CreatedAt]) VALUES (12, 2, N'test ph?', N'', 1, CAST(N'2026-01-21T16:34:36.0000000' AS DateTime2))
SET IDENTITY_INSERT [dbo].[RestaurantDeliveryZones] OFF
GO
SET IDENTITY_INSERT [dbo].[Restaurants] ON 

INSERT [dbo].[Restaurants] ([RestaurantID], [OwnerID], [Name], [Address], [LicenseNumber], [LogoUrl], [ThemeColor], [IsOpen], [DeliveryFee], [CommissionRate], [Status], [CreatedAt]) VALUES (2, 3, N'Ph? H? N?i', N'123 Nguy?n Hu?, Qu?n 1, TP.HCM', N'LIC-001-2026', NULL, NULL, 1, CAST(15000.00 AS Decimal(10, 2)), CAST(10.00 AS Decimal(5, 2)), N'Approved', CAST(N'2026-01-21T16:20:34.0000000' AS DateTime2))
INSERT [dbo].[Restaurants] ([RestaurantID], [OwnerID], [Name], [Address], [LicenseNumber], [LogoUrl], [ThemeColor], [IsOpen], [DeliveryFee], [CommissionRate], [Status], [CreatedAt]) VALUES (3, 3, N'B?n B? Hu? Ngon', N'456 L? L?i, Qu?n 3, TP.HCM', N'LIC-002-2026', NULL, NULL, 1, CAST(20000.00 AS Decimal(10, 2)), CAST(10.00 AS Decimal(5, 2)), N'Approved', CAST(N'2026-01-21T16:20:34.0000000' AS DateTime2))
INSERT [dbo].[Restaurants] ([RestaurantID], [OwnerID], [Name], [Address], [LicenseNumber], [LogoUrl], [ThemeColor], [IsOpen], [DeliveryFee], [CommissionRate], [Status], [CreatedAt]) VALUES (4, 4, N'C?m T?m S?i G?n', N'789 Hai B? Tr?ng, Qu?n 1, TP.HCM', N'LIC-003-2026', NULL, NULL, 1, CAST(12000.00 AS Decimal(10, 2)), CAST(10.00 AS Decimal(5, 2)), N'Approved', CAST(N'2026-01-21T16:20:34.0000000' AS DateTime2))
SET IDENTITY_INSERT [dbo].[Restaurants] OFF
GO
SET IDENTITY_INSERT [dbo].[Roles] ON 

INSERT [dbo].[Roles] ([RoleID], [RoleName]) VALUES (4, N'Customer')
INSERT [dbo].[Roles] ([RoleID], [RoleName]) VALUES (2, N'Owner')
INSERT [dbo].[Roles] ([RoleID], [RoleName]) VALUES (3, N'Staff')
INSERT [dbo].[Roles] ([RoleID], [RoleName]) VALUES (1, N'SuperAdmin')
SET IDENTITY_INSERT [dbo].[Roles] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([UserID], [FullName], [Email], [PasswordHash], [Phone], [RoleID], [IsActive], [CreatedAt]) VALUES (2, N'System Admin', N'admin@mrm.com', N'admin123', N'0123456789', 1, 1, CAST(N'2026-01-21T16:20:25.0000000' AS DateTime2))
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [PasswordHash], [Phone], [RoleID], [IsActive], [CreatedAt]) VALUES (3, N'Restaurant Owner 1', N'owner1@restaurant.com', N'owner123', N'0987654321', 2, 1, CAST(N'2026-01-21T16:20:25.0000000' AS DateTime2))
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [PasswordHash], [Phone], [RoleID], [IsActive], [CreatedAt]) VALUES (4, N'Restaurant Owner 2', N'owner2@restaurant.com', N'owner123', N'0988888888', 2, 1, CAST(N'2026-01-21T16:20:25.0000000' AS DateTime2))
INSERT [dbo].[Users] ([UserID], [FullName], [Email], [PasswordHash], [Phone], [RoleID], [IsActive], [CreatedAt]) VALUES (5, N'Customer Demo', N'customer@example.com', N'customer123', N'0912345678', 4, 1, CAST(N'2026-01-21T16:20:25.0000000' AS DateTime2))
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
/****** Object:  Index [UQ__Delivery__C3905BAE17F26D2B]    Script Date: 1/22/2026 12:24:44 AM ******/
ALTER TABLE [dbo].[DeliveryInfo] ADD UNIQUE NONCLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Discount__A25C5AA73539FD14]    Script Date: 1/22/2026 12:24:44 AM ******/
ALTER TABLE [dbo].[Discounts] ADD UNIQUE NONCLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__Invoices__C3905BAE20C842C5]    Script Date: 1/22/2026 12:24:44 AM ******/
ALTER TABLE [dbo].[Invoices] ADD UNIQUE NONCLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Invoices__D776E98122E3FCDE]    Script Date: 1/22/2026 12:24:44 AM ******/
ALTER TABLE [dbo].[Invoices] ADD UNIQUE NONCLUSTERED 
(
	[InvoiceNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_MenuItems_Restaurant_SKU]    Script Date: 1/22/2026 12:24:44 AM ******/
ALTER TABLE [dbo].[MenuItems] ADD  CONSTRAINT [UQ_MenuItems_Restaurant_SKU] UNIQUE NONCLUSTERED 
(
	[RestaurantID] ASC,
	[SKU] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Restaurants_Status_Open]    Script Date: 1/22/2026 12:24:44 AM ******/
CREATE NONCLUSTERED INDEX [IX_Restaurants_Status_Open] ON [dbo].[Restaurants]
(
	[Status] ASC,
	[IsOpen] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_RestaurantTables]    Script Date: 1/22/2026 12:24:44 AM ******/
ALTER TABLE [dbo].[RestaurantTables] ADD  CONSTRAINT [UQ_RestaurantTables] UNIQUE NONCLUSTERED 
(
	[RestaurantID] ASC,
	[TableNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ_RestaurantUsers]    Script Date: 1/22/2026 12:24:44 AM ******/
ALTER TABLE [dbo].[RestaurantUsers] ADD  CONSTRAINT [UQ_RestaurantUsers] UNIQUE NONCLUSTERED 
(
	[RestaurantID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Roles__8A2B616055E8675C]    Script Date: 1/22/2026 12:24:44 AM ******/
ALTER TABLE [dbo].[Roles] ADD UNIQUE NONCLUSTERED 
(
	[RoleName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Users__A9D105344904A9E7]    Script Date: 1/22/2026 12:24:44 AM ******/
ALTER TABLE [dbo].[Users] ADD UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Complaints] ADD  CONSTRAINT [DF_Complaints_Status]  DEFAULT ('Open') FOR [Status]
GO
ALTER TABLE [dbo].[Complaints] ADD  CONSTRAINT [DF_Complaints_CreatedAt]  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[DeliveryFees] ADD  CONSTRAINT [DF_DeliveryFees_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[DeliveryFees] ADD  CONSTRAINT [DF_DeliveryFees_CreatedAt]  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Discounts] ADD  CONSTRAINT [DF_Discounts_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Discounts] ADD  CONSTRAINT [DF_Discounts_CreatedAt]  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[EmployeeShifts] ADD  CONSTRAINT [DF_EmployeeShifts_CreatedAt]  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Invoices] ADD  CONSTRAINT [DF_Invoices_IssuedDate]  DEFAULT (sysutcdatetime()) FOR [IssuedDate]
GO
ALTER TABLE [dbo].[Invoices] ADD  CONSTRAINT [DF_Invoices_Tax]  DEFAULT ((0)) FOR [TaxAmount]
GO
ALTER TABLE [dbo].[ItemOptions] ADD  CONSTRAINT [DF_ItemOptions_AdditionalPrice]  DEFAULT ((0)) FOR [AdditionalPrice]
GO
ALTER TABLE [dbo].[ItemOptions] ADD  CONSTRAINT [DF_ItemOptions_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[MenuCategories] ADD  CONSTRAINT [DF_MenuCategories_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[MenuItems] ADD  CONSTRAINT [DF_MenuItems_IsAvailable]  DEFAULT ((1)) FOR [IsAvailable]
GO
ALTER TABLE [dbo].[MenuItems] ADD  CONSTRAINT [DF_MenuItems_CreatedAt]  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[OrderItems] ADD  CONSTRAINT [DF_OrderItems_CreatedAt]  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_OrderType]  DEFAULT ('Online') FOR [OrderType]
GO
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_Status]  DEFAULT ('Preparing') FOR [OrderStatus]
GO
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_Total]  DEFAULT ((0)) FOR [TotalAmount]
GO
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_Discount]  DEFAULT ((0)) FOR [DiscountAmount]
GO
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_Final]  DEFAULT ((0)) FOR [FinalAmount]
GO
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_IsClosed]  DEFAULT ((0)) FOR [IsClosed]
GO
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_CreatedAt]  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Payments] ADD  CONSTRAINT [DF_Payments_Status]  DEFAULT ('Pending') FOR [PaymentStatus]
GO
ALTER TABLE [dbo].[Payments] ADD  CONSTRAINT [DF_Payments_CreatedAt]  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[RestaurantDeliveryZones] ADD  CONSTRAINT [DF_RestaurantDeliveryZones_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[RestaurantDeliveryZones] ADD  CONSTRAINT [DF_RestaurantDeliveryZones_CreatedAt]  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Restaurants] ADD  CONSTRAINT [DF_Restaurants_IsOpen]  DEFAULT ((1)) FOR [IsOpen]
GO
ALTER TABLE [dbo].[Restaurants] ADD  CONSTRAINT [DF_Restaurants_Status]  DEFAULT ('Pending') FOR [Status]
GO
ALTER TABLE [dbo].[Restaurants] ADD  CONSTRAINT [DF_Restaurants_CreatedAt]  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[RestaurantTables] ADD  CONSTRAINT [DF_RestaurantTables_Status]  DEFAULT ('Available') FOR [TableStatus]
GO
ALTER TABLE [dbo].[RestaurantTables] ADD  CONSTRAINT [DF_RestaurantTables_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[RestaurantUsers] ADD  CONSTRAINT [DF_RestaurantUsers_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[RestaurantUsers] ADD  CONSTRAINT [DF_RestaurantUsers_CreatedAt]  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Reviews] ADD  CONSTRAINT [DF_Reviews_CreatedAt]  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[TableReservations] ADD  CONSTRAINT [DF_TableReservations_Status]  DEFAULT ('Pending') FOR [Status]
GO
ALTER TABLE [dbo].[TableReservations] ADD  CONSTRAINT [DF_TableReservations_CreatedAt]  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_CreatedAt]  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Complaints]  WITH CHECK ADD  CONSTRAINT [FK_Complaints_Customers] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[Complaints] CHECK CONSTRAINT [FK_Complaints_Customers]
GO
ALTER TABLE [dbo].[Complaints]  WITH CHECK ADD  CONSTRAINT [FK_Complaints_Orders] FOREIGN KEY([OrderID])
REFERENCES [dbo].[Orders] ([OrderID])
GO
ALTER TABLE [dbo].[Complaints] CHECK CONSTRAINT [FK_Complaints_Orders]
GO
ALTER TABLE [dbo].[DeliveryFees]  WITH CHECK ADD  CONSTRAINT [FK_DeliveryFees_DeliveryZones] FOREIGN KEY([ZoneID])
REFERENCES [dbo].[RestaurantDeliveryZones] ([ZoneID])
GO
ALTER TABLE [dbo].[DeliveryFees] CHECK CONSTRAINT [FK_DeliveryFees_DeliveryZones]
GO
ALTER TABLE [dbo].[DeliveryInfo]  WITH CHECK ADD  CONSTRAINT [FK_DeliveryInfo_Orders] FOREIGN KEY([OrderID])
REFERENCES [dbo].[Orders] ([OrderID])
GO
ALTER TABLE [dbo].[DeliveryInfo] CHECK CONSTRAINT [FK_DeliveryInfo_Orders]
GO
ALTER TABLE [dbo].[Discounts]  WITH CHECK ADD  CONSTRAINT [FK_Discounts_Restaurants] FOREIGN KEY([RestaurantID])
REFERENCES [dbo].[Restaurants] ([RestaurantID])
GO
ALTER TABLE [dbo].[Discounts] CHECK CONSTRAINT [FK_Discounts_Restaurants]
GO
ALTER TABLE [dbo].[EmployeeShifts]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeShifts_Restaurants] FOREIGN KEY([RestaurantID])
REFERENCES [dbo].[Restaurants] ([RestaurantID])
GO
ALTER TABLE [dbo].[EmployeeShifts] CHECK CONSTRAINT [FK_EmployeeShifts_Restaurants]
GO
ALTER TABLE [dbo].[EmployeeShifts]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeShifts_Staff] FOREIGN KEY([StaffID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[EmployeeShifts] CHECK CONSTRAINT [FK_EmployeeShifts_Staff]
GO
ALTER TABLE [dbo].[Invoices]  WITH CHECK ADD  CONSTRAINT [FK_Invoices_Orders] FOREIGN KEY([OrderID])
REFERENCES [dbo].[Orders] ([OrderID])
GO
ALTER TABLE [dbo].[Invoices] CHECK CONSTRAINT [FK_Invoices_Orders]
GO
ALTER TABLE [dbo].[ItemOptions]  WITH CHECK ADD  CONSTRAINT [FK_ItemOptions_MenuItems] FOREIGN KEY([ItemID])
REFERENCES [dbo].[MenuItems] ([ItemID])
GO
ALTER TABLE [dbo].[ItemOptions] CHECK CONSTRAINT [FK_ItemOptions_MenuItems]
GO
ALTER TABLE [dbo].[MenuCategories]  WITH CHECK ADD  CONSTRAINT [FK_MenuCategories_Restaurants] FOREIGN KEY([RestaurantID])
REFERENCES [dbo].[Restaurants] ([RestaurantID])
GO
ALTER TABLE [dbo].[MenuCategories] CHECK CONSTRAINT [FK_MenuCategories_Restaurants]
GO
ALTER TABLE [dbo].[MenuItems]  WITH CHECK ADD  CONSTRAINT [FK_MenuItems_Categories] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[MenuCategories] ([CategoryID])
GO
ALTER TABLE [dbo].[MenuItems] CHECK CONSTRAINT [FK_MenuItems_Categories]
GO
ALTER TABLE [dbo].[MenuItems]  WITH CHECK ADD  CONSTRAINT [FK_MenuItems_Restaurants] FOREIGN KEY([RestaurantID])
REFERENCES [dbo].[Restaurants] ([RestaurantID])
GO
ALTER TABLE [dbo].[MenuItems] CHECK CONSTRAINT [FK_MenuItems_Restaurants]
GO
ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD  CONSTRAINT [FK_OrderItems_MenuItems] FOREIGN KEY([ItemID])
REFERENCES [dbo].[MenuItems] ([ItemID])
GO
ALTER TABLE [dbo].[OrderItems] CHECK CONSTRAINT [FK_OrderItems_MenuItems]
GO
ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD  CONSTRAINT [FK_OrderItems_Orders] FOREIGN KEY([OrderID])
REFERENCES [dbo].[Orders] ([OrderID])
GO
ALTER TABLE [dbo].[OrderItems] CHECK CONSTRAINT [FK_OrderItems_Orders]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Customers] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Customers]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Discounts] FOREIGN KEY([DiscountID])
REFERENCES [dbo].[Discounts] ([DiscountID])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Discounts]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Restaurants] FOREIGN KEY([RestaurantID])
REFERENCES [dbo].[Restaurants] ([RestaurantID])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Restaurants]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Table] FOREIGN KEY([TableID])
REFERENCES [dbo].[RestaurantTables] ([TableID])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Table]
GO
ALTER TABLE [dbo].[Payments]  WITH CHECK ADD  CONSTRAINT [FK_Payments_Orders] FOREIGN KEY([OrderID])
REFERENCES [dbo].[Orders] ([OrderID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Payments] CHECK CONSTRAINT [FK_Payments_Orders]
GO
ALTER TABLE [dbo].[Payments]  WITH CHECK ADD  CONSTRAINT [FK_Payments_Customers] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[Payments] CHECK CONSTRAINT [FK_Payments_Customers]
GO
ALTER TABLE [dbo].[RestaurantDeliveryZones]  WITH CHECK ADD  CONSTRAINT [FK_RestaurantDeliveryZones_Restaurants] FOREIGN KEY([RestaurantID])
REFERENCES [dbo].[Restaurants] ([RestaurantID])
GO
ALTER TABLE [dbo].[RestaurantDeliveryZones] CHECK CONSTRAINT [FK_RestaurantDeliveryZones_Restaurants]
GO
ALTER TABLE [dbo].[Restaurants]  WITH CHECK ADD  CONSTRAINT [FK_Restaurants_Owner] FOREIGN KEY([OwnerID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[Restaurants] CHECK CONSTRAINT [FK_Restaurants_Owner]
GO
ALTER TABLE [dbo].[RestaurantTables]  WITH CHECK ADD  CONSTRAINT [FK_RestaurantTables_Restaurants] FOREIGN KEY([RestaurantID])
REFERENCES [dbo].[Restaurants] ([RestaurantID])
GO
ALTER TABLE [dbo].[RestaurantTables] CHECK CONSTRAINT [FK_RestaurantTables_Restaurants]
GO
ALTER TABLE [dbo].[RestaurantUsers]  WITH CHECK ADD  CONSTRAINT [FK_RestaurantUsers_Restaurants] FOREIGN KEY([RestaurantID])
REFERENCES [dbo].[Restaurants] ([RestaurantID])
GO
ALTER TABLE [dbo].[RestaurantUsers] CHECK CONSTRAINT [FK_RestaurantUsers_Restaurants]
GO
ALTER TABLE [dbo].[RestaurantUsers]  WITH CHECK ADD  CONSTRAINT [FK_RestaurantUsers_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[RestaurantUsers] CHECK CONSTRAINT [FK_RestaurantUsers_Users]
GO
ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD  CONSTRAINT [FK_Reviews_Customers] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[Reviews] CHECK CONSTRAINT [FK_Reviews_Customers]
GO
ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD  CONSTRAINT [FK_Reviews_Restaurants] FOREIGN KEY([RestaurantID])
REFERENCES [dbo].[Restaurants] ([RestaurantID])
GO
ALTER TABLE [dbo].[Reviews] CHECK CONSTRAINT [FK_Reviews_Restaurants]
GO
ALTER TABLE [dbo].[TableReservations]  WITH CHECK ADD  CONSTRAINT [FK_TableReservations_Customers] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[TableReservations] CHECK CONSTRAINT [FK_TableReservations_Customers]
GO
ALTER TABLE [dbo].[TableReservations]  WITH CHECK ADD  CONSTRAINT [FK_TableReservations_Restaurants] FOREIGN KEY([RestaurantID])
REFERENCES [dbo].[Restaurants] ([RestaurantID])
GO
ALTER TABLE [dbo].[TableReservations] CHECK CONSTRAINT [FK_TableReservations_Restaurants]
GO
ALTER TABLE [dbo].[TableReservations]  WITH CHECK ADD  CONSTRAINT [FK_TableReservations_Tables] FOREIGN KEY([TableID])
REFERENCES [dbo].[RestaurantTables] ([TableID])
GO
ALTER TABLE [dbo].[TableReservations] CHECK CONSTRAINT [FK_TableReservations_Tables]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_Roles] FOREIGN KEY([RoleID])
REFERENCES [dbo].[Roles] ([RoleID])
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_Roles]
GO
ALTER TABLE [dbo].[Complaints]  WITH CHECK ADD CHECK  (([Status]='Rejected' OR [Status]='Resolved' OR [Status]='InProgress' OR [Status]='Open'))
GO
ALTER TABLE [dbo].[DeliveryFees]  WITH CHECK ADD CHECK  (([FeeType]='FreeAboveAmount' OR [FeeType]='Flat' OR [FeeType]='PercentageOfOrder'))
GO
ALTER TABLE [dbo].[DeliveryFees]  WITH CHECK ADD CHECK  (([FeeValue]>=(0)))
GO
ALTER TABLE [dbo].[DeliveryFees]  WITH CHECK ADD CHECK  (([MaxOrderAmount] IS NULL OR [MaxOrderAmount]>=(0)))
GO
ALTER TABLE [dbo].[DeliveryFees]  WITH CHECK ADD CHECK  (([MinOrderAmount] IS NULL OR [MinOrderAmount]>=(0)))
GO
ALTER TABLE [dbo].[DeliveryInfo]  WITH CHECK ADD CHECK  (([DeliveryStatus] IS NULL OR ([DeliveryStatus]='Cancelled' OR [DeliveryStatus]='Delivered' OR [DeliveryStatus]='OnTheWay' OR [DeliveryStatus]='Assigned')))
GO
ALTER TABLE [dbo].[Discounts]  WITH CHECK ADD CHECK  (([DiscountType]='Fixed' OR [DiscountType]='Percentage'))
GO
ALTER TABLE [dbo].[Discounts]  WITH CHECK ADD CHECK  (([DiscountValue]>=(0)))
GO
ALTER TABLE [dbo].[EmployeeShifts]  WITH CHECK ADD  CONSTRAINT [CK_EmployeeShifts_Time] CHECK  (([EndTime]>[StartTime]))
GO
ALTER TABLE [dbo].[EmployeeShifts] CHECK CONSTRAINT [CK_EmployeeShifts_Time]
GO
ALTER TABLE [dbo].[Invoices]  WITH CHECK ADD CHECK  (([FinalAmount]>=(0)))
GO
ALTER TABLE [dbo].[Invoices]  WITH CHECK ADD CHECK  (([Subtotal]>=(0)))
GO
ALTER TABLE [dbo].[Invoices]  WITH CHECK ADD CHECK  (([TaxAmount]>=(0)))
GO
ALTER TABLE [dbo].[ItemOptions]  WITH CHECK ADD CHECK  (([AdditionalPrice]>=(0)))
GO
ALTER TABLE [dbo].[MenuItems]  WITH CHECK ADD CHECK  (([Price]>=(0)))
GO
ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD CHECK  (([Quantity]>(0)))
GO
ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD CHECK  (([UnitPrice]>=(0)))
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD CHECK  (([DiscountAmount]>=(0)))
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD CHECK  (([FinalAmount]>=(0)))
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD CHECK  (([OrderStatus]='Cancelled' OR [OrderStatus]='Completed' OR [OrderStatus]='Delivering' OR [OrderStatus]='Preparing'))
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD CHECK  (([OrderType]='Pickup' OR [OrderType]='DineIn' OR [OrderType]='Online'))
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD CHECK  (([TotalAmount]>=(0)))
GO
ALTER TABLE [dbo].[Payments]  WITH CHECK ADD CHECK  (([PaymentStatus]='Cancelled' OR [PaymentStatus]='Refunded' OR [PaymentStatus]='Failed' OR [PaymentStatus]='Success' OR [PaymentStatus]='Pending'))
GO
ALTER TABLE [dbo].[Payments]  WITH CHECK ADD CHECK  (([PaymentType]='VNPay' OR [PaymentType]='Cash' OR [PaymentType]='COD'))
GO
ALTER TABLE [dbo].[Payments]  WITH CHECK ADD CHECK  (([Amount]>=(0)))
GO
/****** Object:  Index [IX_Payments_TransactionRef]    Script Date: 1/22/2026 12:24:44 AM ******/
CREATE NONCLUSTERED INDEX [IX_Payments_TransactionRef] ON [dbo].[Payments]([TransactionRef] ASC)
GO
/****** Object:  Index [IX_Payments_OrderID]    Script Date: 1/22/2026 12:24:44 AM ******/
CREATE NONCLUSTERED INDEX [IX_Payments_OrderID] ON [dbo].[Payments]([OrderID] ASC)
GO
/****** Object:  Index [IX_Payments_CustomerID]    Script Date: 1/22/2026 12:24:44 AM ******/
CREATE NONCLUSTERED INDEX [IX_Payments_CustomerID] ON [dbo].[Payments]([CustomerID] ASC)
GO
ALTER TABLE [dbo].[Restaurants]  WITH CHECK ADD CHECK  (([CommissionRate]>=(0) AND [CommissionRate]<=(100)))
GO
ALTER TABLE [dbo].[Restaurants]  WITH CHECK ADD CHECK  (([DeliveryFee]>=(0)))
GO
ALTER TABLE [dbo].[Restaurants]  WITH CHECK ADD CHECK  (([Status]='Rejected' OR [Status]='Approved' OR [Status]='Pending'))
GO
ALTER TABLE [dbo].[RestaurantTables]  WITH CHECK ADD CHECK  (([Capacity]>(0)))
GO
ALTER TABLE [dbo].[RestaurantTables]  WITH CHECK ADD CHECK  (([TableStatus]='Reserved' OR [TableStatus]='Occupied' OR [TableStatus]='Available'))
GO
ALTER TABLE [dbo].[RestaurantUsers]  WITH CHECK ADD CHECK  (([RestaurantRole]='Manager' OR [RestaurantRole]='Staff' OR [RestaurantRole]='Owner'))
GO
ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD CHECK  (([Rating]>=(1) AND [Rating]<=(5)))
GO
ALTER TABLE [dbo].[TableReservations]  WITH CHECK ADD CHECK  (([NumberOfGuests] IS NULL OR [NumberOfGuests]>(0)))
GO
ALTER TABLE [dbo].[TableReservations]  WITH CHECK ADD CHECK  (([Status]='Completed' OR [Status]='Cancelled' OR [Status]='Confirmed' OR [Status]='Pending'))
GO
ALTER TABLE [dbo].[TableReservations]  WITH CHECK ADD  CONSTRAINT [CK_TableReservations_Time] CHECK  (([EndTime]>[StartTime]))
GO
ALTER TABLE [dbo].[TableReservations] CHECK CONSTRAINT [CK_TableReservations_Time]
GO
USE [master]
GO
ALTER DATABASE [MultiRestaurantOrderingDB] SET  READ_WRITE 
GO
