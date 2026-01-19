-- Library Management System Database Schema
-- Drop existing database if exists and create new one
USE master;
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'LibraryDB')
BEGIN
    ALTER DATABASE LibraryDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE LibraryDB;
END
GO

CREATE DATABASE LibraryDB;
GO

USE LibraryDB;
GO

-- Table: Users (for authentication and authorization)
CREATE TABLE Users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('reader', 'librarian', 'admin')),
    full_name NVARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    status BIT DEFAULT 1, -- 1: active, 0: inactive
    created_date DATETIME DEFAULT GETDATE()
);
GO

-- Table: Categories (book categories)
CREATE TABLE Categories (
    category_id INT PRIMARY KEY IDENTITY(1,1),
    category_name NVARCHAR(100) NOT NULL UNIQUE,
    description NVARCHAR(500)
);
GO

-- Table: Books
CREATE TABLE Books (
    book_id INT PRIMARY KEY IDENTITY(1,1),
    title NVARCHAR(255) NOT NULL,
    author NVARCHAR(200) NOT NULL,
    publisher NVARCHAR(200),
    publish_year INT,
    isbn VARCHAR(20),
    quantity INT NOT NULL DEFAULT 0,
    available_quantity INT NOT NULL DEFAULT 0,
    category_id INT REFERENCES Categories(category_id),
    description NVARCHAR(1000),
    image_url VARCHAR(500),
    is_hidden BIT DEFAULT 0, -- 0: visible, 1: hidden
    created_date DATETIME DEFAULT GETDATE(),
    updated_date DATETIME DEFAULT GETDATE()
);
GO

-- Table: Readers (library card holders)
CREATE TABLE Readers (
    reader_id INT PRIMARY KEY IDENTITY(1,1),
    card_number VARCHAR(20) UNIQUE NOT NULL,
    full_name NVARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    address NVARCHAR(300),
    user_id INT REFERENCES Users(user_id), -- link to user account
    created_date DATETIME DEFAULT GETDATE(),
    expiry_date DATETIME, -- library card expiry
    status BIT DEFAULT 1 -- 1: active, 0: inactive
);
GO

-- Table: BorrowSlips (loan records)
CREATE TABLE BorrowSlips (
    slip_id INT PRIMARY KEY IDENTITY(1,1),
    reader_id INT NOT NULL REFERENCES Readers(reader_id),
    librarian_id INT REFERENCES Users(user_id), -- who processed the borrow
    borrow_date DATETIME DEFAULT GETDATE(),
    due_date DATETIME NOT NULL,
    return_date DATETIME,
    status VARCHAR(20) NOT NULL DEFAULT 'borrowed' CHECK (status IN ('borrowed', 'returned', 'overdue')),
    notes NVARCHAR(500)
);
GO

-- Table: BorrowDetails (books in each borrow slip)
CREATE TABLE BorrowDetails (
    detail_id INT PRIMARY KEY IDENTITY(1,1),
    slip_id INT NOT NULL REFERENCES BorrowSlips(slip_id) ON DELETE CASCADE,
    book_id INT NOT NULL REFERENCES Books(book_id),
    quantity INT NOT NULL DEFAULT 1,
    returned BIT DEFAULT 0 -- track individual book return status
);
GO

-- Table: Staff (librarian and admin details)
CREATE TABLE Staff (
    staff_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL REFERENCES Users(user_id),
    position NVARCHAR(100),
    department NVARCHAR(100),
    hire_date DATETIME DEFAULT GETDATE()
);
GO

-- Insert Sample Categories
INSERT INTO Categories (category_name, description) VALUES
(N'Khoa học máy tính', N'Sách về lập trình, thuật toán, AI, etc.'),
(N'Văn học', N'Tiểu thuyết, truyện ngắn, thơ ca'),
(N'Kinh tế', N'Sách về kinh tế học, tài chính, quản trị'),
(N'Lịch sử', N'Sách lịch sử Việt Nam và thế giới'),
(N'Khoa học tự nhiên', N'Vật lý, hóa học, sinh học'),
(N'Triết học', N'Triết học phương Đông và phương Tây'),
(N'Tâm lý học', N'Sách về tâm lý và phát triển bản thân'),
(N'Ngoại ngữ', N'Sách học tiếng Anh, tiếng Nhật, etc.');
GO

-- Insert Sample Books
INSERT INTO Books (title, author, publisher, publish_year, isbn, quantity, available_quantity, category_id, description) VALUES
(N'Clean Code', 'Robert C. Martin', 'Prentice Hall', 2008, '9780132350884', 10, 8, 1, N'A handbook of agile software craftsmanship'),
(N'Introduction to Algorithms', 'Thomas H. Cormen', 'MIT Press', 2009, '9780262033848', 5, 3, 1, N'Comprehensive text on computer algorithms'),
(N'Design Patterns', 'Erich Gamma', 'Addison-Wesley', 1994, '9780201633610', 7, 7, 1, N'Elements of Reusable Object-Oriented Software'),
(N'Số đỏ', N'Vũ Trọng Phụng', N'NXB Văn học', 2010, '8934567890123', 15, 12, 2, N'Tiểu thuyết nổi tiếng của Việt Nam'),
(N'Tôi thấy hoa vàng trên cỏ xanh', N'Nguyễn Nhật Ánh', N'NXB Trẻ', 2015, '8934567890456', 20, 15, 2, N'Truyện dài về tuổi thơ'),
(N'Thinking Fast and Slow', 'Daniel Kahneman', 'Farrar, Straus and Giroux', 2011, '9780374533557', 8, 6, 7, N'Nobel Prize winner on thinking and decision making'),
(N'Sapiens', 'Yuval Noah Harari', 'Harper', 2015, '9780062316097', 12, 9, 4, N'A brief history of humankind'),
(N'The Lean Startup', 'Eric Ries', 'Crown Business', 2011, '9780307887894', 6, 5, 3, N'How to build successful startups');
GO

-- Insert Sample Users
-- Password: 123456 (in production, should be hashed)
INSERT INTO Users (username, password, role, full_name, email, phone, status) VALUES
('admin', '123456', 'admin', N'Nguyễn Văn Admin', 'admin@library.com', '0901234567', 1),
('librarian1', '123456', 'librarian', N'Trần Thị Lan', 'lan.librarian@library.com', '0902345678', 1),
('librarian2', '123456', 'librarian', N'Lê Văn Hùng', 'hung.librarian@library.com', '0903456789', 1),
('reader1', '123456', 'reader', N'Phạm Minh Tuấn', 'tuan@email.com', '0904567890', 1),
('reader2', '123456', 'reader', N'Hoàng Thị Mai', 'mai@email.com', '0905678901', 1);
GO

-- Insert Staff records for librarians and admin
INSERT INTO Staff (user_id, position, department) VALUES
(1, N'Quản trị viên hệ thống', N'Quản lý'),
(2, N'Thủ thư', N'Mượn trả sách'),
(3, N'Thủ thư', N'Quản lý kho');
GO

-- Insert Sample Readers
INSERT INTO Readers (card_number, full_name, phone, email, address, user_id, expiry_date, status) VALUES
('RD001', N'Phạm Minh Tuấn', '0904567890', 'tuan@email.com', N'123 Lê Lợi, Hà Nội', 4, DATEADD(YEAR, 1, GETDATE()), 1),
('RD002', N'Hoàng Thị Mai', '0905678901', 'mai@email.com', N'456 Trần Hưng Đạo, TP.HCM', 5, DATEADD(YEAR, 1, GETDATE()), 1),
('RD003', N'Nguyễn Văn An', '0906789012', 'an@email.com', N'789 Nguyễn Huệ, Đà Nẵng', NULL, DATEADD(YEAR, 1, GETDATE()), 1);
GO

-- Insert Sample Borrow Slips
INSERT INTO BorrowSlips (reader_id, librarian_id, borrow_date, due_date, return_date, status, notes) VALUES
(1, 2, DATEADD(DAY, -10, GETDATE()), DATEADD(DAY, 4, GETDATE()), NULL, 'borrowed', N'Mượn 2 sách về lập trình'),
(2, 2, DATEADD(DAY, -5, GETDATE()), DATEADD(DAY, 9, GETDATE()), NULL, 'borrowed', N'Mượn sách văn học'),
(1, 3, DATEADD(DAY, -20, GETDATE()), DATEADD(DAY, -6, GETDATE()), DATEADD(DAY, -5, GETDATE()), 'returned', N'Đã trả đúng hạn');
GO

-- Insert Sample Borrow Details
INSERT INTO BorrowDetails (slip_id, book_id, quantity, returned) VALUES
(1, 1, 1, 0), -- Clean Code
(1, 2, 1, 0), -- Intro to Algorithms
(2, 4, 1, 0), -- Số đỏ
(2, 5, 1, 0), -- Tôi thấy hoa vàng
(3, 6, 1, 1); -- Thinking Fast and Slow (returned)
GO

-- Create Indexes for better performance
CREATE INDEX idx_books_category ON Books(category_id);
CREATE INDEX idx_books_title ON Books(title);
CREATE INDEX idx_readers_cardnumber ON Readers(card_number);
CREATE INDEX idx_borrowslips_reader ON BorrowSlips(reader_id);
CREATE INDEX idx_borrowslips_status ON BorrowSlips(status);
CREATE INDEX idx_borrowdetails_slip ON BorrowDetails(slip_id);
GO

-- Create Views for common queries
CREATE VIEW vw_AvailableBooks AS
SELECT b.book_id, b.title, b.author, b.publisher, b.publish_year, 
       b.quantity, b.available_quantity, c.category_name, b.description
FROM Books b
LEFT JOIN Categories c ON b.category_id = c.category_id
WHERE b.available_quantity > 0;
GO

CREATE VIEW vw_ActiveBorrowSlips AS
SELECT bs.slip_id, r.card_number, r.full_name AS reader_name, 
       u.full_name AS librarian_name, bs.borrow_date, bs.due_date, 
       bs.status, bs.notes
FROM BorrowSlips bs
JOIN Readers r ON bs.reader_id = r.reader_id
LEFT JOIN Users u ON bs.librarian_id = u.user_id
WHERE bs.status = 'borrowed';
GO

-- Create Stored Procedures
-- Procedure to borrow books (reduces available quantity)
CREATE PROCEDURE sp_BorrowBook
    @slip_id INT,
    @book_id INT,
    @quantity INT
AS
BEGIN
    DECLARE @available INT;
    SELECT @available = available_quantity FROM Books WHERE book_id = @book_id;
    
    IF @available >= @quantity
    BEGIN
        UPDATE Books 
        SET available_quantity = available_quantity - @quantity
        WHERE book_id = @book_id;
        
        INSERT INTO BorrowDetails (slip_id, book_id, quantity, returned)
        VALUES (@slip_id, @book_id, @quantity, 0);
        
        SELECT 'Success' AS Result;
    END
    ELSE
    BEGIN
        SELECT 'Insufficient books available' AS Result;
    END
END
GO

-- Procedure to return books (increases available quantity)
CREATE PROCEDURE sp_ReturnBook
    @detail_id INT
AS
BEGIN
    DECLARE @book_id INT, @quantity INT;
    
    SELECT @book_id = book_id, @quantity = quantity 
    FROM BorrowDetails 
    WHERE detail_id = @detail_id AND returned = 0;
    
    IF @book_id IS NOT NULL
    BEGIN
        UPDATE Books 
        SET available_quantity = available_quantity + @quantity
        WHERE book_id = @book_id;
        
        UPDATE BorrowDetails
        SET returned = 1
        WHERE detail_id = @detail_id;
        
        SELECT 'Success' AS Result;
    END
    ELSE
    BEGIN
        SELECT 'Book already returned or not found' AS Result;
    END
END
GO

PRINT 'Database schema created successfully!';
PRINT 'Sample data inserted.';
PRINT '';
PRINT 'Login credentials:';
PRINT 'Admin - username: admin, password: 123456';
PRINT 'Librarian - username: librarian1, password: 123456';
PRINT 'Reader - username: reader1, password: 123456';
GO
