-- Script to insert test restaurants for pagination testing
-- This will create 15 restaurants to test pagination (6 per page = 3 pages)

-- Insert test restaurants
INSERT INTO Restaurants (Name, Address, Phone, Email, LogoUrl, Status, CommissionRate, CreatedAt)
VALUES 
('Nhà hàng Phố Cổ', '123 Hàng Bạc, Hoàn Kiếm, Hà Nội', '0901234567', 'phoco@restaurant.com', 'https://chuphinhmonan.com/wp-content/uploads/2017/03/15190142704_6ba141723c_z.jpg', 'Approved', 10.00, GETDATE()),
('Quán Ăn Sài Gòn', '456 Nguyễn Huệ, Quận 1, TP.HCM', '0901234568', 'saigon@restaurant.com', 'https://chuphinhmonan.com/wp-content/uploads/2017/03/15190142704_6ba141723c_z.jpg', 'Approved', 10.00, GETDATE()),
('Bún Chả Hà Nội', '789 Hàng Mã, Hoàn Kiếm, Hà Nội', '0901234569', 'buncha@restaurant.com', 'https://chuphinhmonan.com/wp-content/uploads/2017/03/15190142704_6ba141723c_z.jpg', 'Approved', 10.00, GETDATE()),
('Phở Bò Nam Định', '321 Trần Hưng Đạo, Hoàn Kiếm, Hà Nội', '0901234570', 'phobo@restaurant.com', 'https://chuphinhmonan.com/wp-content/uploads/2017/03/15190142704_6ba141723c_z.jpg', 'Approved', 10.00, GETDATE()),
('Cơm Tấm Sườn Nướng', '654 Lê Lợi, Quận 1, TP.HCM', '0901234571', 'comtam@restaurant.com', 'https://chuphinhmonan.com/wp-content/uploads/2017/03/15190142704_6ba141723c_z.jpg', 'Approved', 10.00, GETDATE()),
('Bánh Mì Hội An', '987 Trần Phú, Hội An, Quảng Nam', '0901234572', 'banhmi@restaurant.com', 'https://chuphinhmonan.com/wp-content/uploads/2017/03/15190142704_6ba141723c_z.jpg', 'Approved', 10.00, GETDATE()),
('Lẩu Thái Tomyum', '147 Hai Bà Trưng, Quận 3, TP.HCM', '0901234573', 'lauthai@restaurant.com', 'https://chuphinhmonan.com/wp-content/uploads/2017/03/15190142704_6ba141723c_z.jpg', 'Approved', 10.00, GETDATE()),
('Gà Rán KFC Style', '258 Nguyễn Trãi, Thanh Xuân, Hà Nội', '0901234574', 'garan@restaurant.com', 'https://chuphinhmonan.com/wp-content/uploads/2017/03/15190142704_6ba141723c_z.jpg', 'Approved', 10.00, GETDATE()),
('Sushi Tokyo', '369 Lê Thánh Tôn, Quận 1, TP.HCM', '0901234575', 'sushi@restaurant.com', 'https://chuphinhmonan.com/wp-content/uploads/2017/03/15190142704_6ba141723c_z.jpg', 'Approved', 10.00, GETDATE()),
('Pizza Italia', '741 Trường Chinh, Đống Đa, Hà Nội', '0901234576', 'pizza@restaurant.com', 'https://chuphinhmonan.com/wp-content/uploads/2017/03/15190142704_6ba141723c_z.jpg', 'Approved', 10.00, GETDATE()),
('Bò Né 3 Ngon', '852 Phan Xích Long, Phú Nhuận, TP.HCM', '0901234577', 'bone@restaurant.com', 'https://chuphinhmonan.com/wp-content/uploads/2017/03/15190142704_6ba141723c_z.jpg', 'Approved', 10.00, GETDATE()),
('Chè Bưởi Miền Tây', '963 Nguyễn Văn Cừ, Long Biên, Hà Nội', '0901234578', 'chebuoi@restaurant.com', 'https://chuphinhmonan.com/wp-content/uploads/2017/03/15190142704_6ba141723c_z.jpg', 'Approved', 10.00, GETDATE()),
('Hủ Tiếu Nam Vang', '159 Lý Thường Kiệt, Quận 10, TP.HCM', '0901234579', 'hutieu@restaurant.com', 'https://chuphinhmonan.com/wp-content/uploads/2017/03/15190142704_6ba141723c_z.jpg', 'Approved', 10.00, GETDATE()),
('Bánh Xèo Miền Trung', '357 Lê Duẩn, Đà Nẵng', '0901234580', 'banhxeo@restaurant.com', 'https://chuphinhmonan.com/wp-content/uploads/2017/03/15190142704_6ba141723c_z.jpg', 'Approved', 10.00, GETDATE()),
('Mì Quảng Đà Nẵng', '486 Nguyễn Văn Linh, Đà Nẵng', '0901234581', 'miquang@restaurant.com', 'https://chuphinhmonan.com/wp-content/uploads/2017/03/15190142704_6ba141723c_z.jpg', 'Approved', 10.00, GETDATE());

PRINT 'Inserted 15 test restaurants successfully!';
PRINT 'You should now see 3 pages with 6 restaurants per page.';
