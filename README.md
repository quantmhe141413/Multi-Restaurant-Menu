# 🏛️ Library Management System

## 📖 Mô tả dự án
Hệ thống quản lý thư viện toàn diện với các chức năng quản lý sách, độc giả, mượn/trả sách và phân quyền theo vai trò (Reader, Librarian, Admin).

Dự án được phát triển bằng Java Web với kiến trúc MVC, sử dụng Servlet/JSP, kết nối SQL Server qua JDBC.

## 🎯 Các tính năng chính

### 👤 Phân quyền người dùng
**1. Reader (Người đọc)**
- Tìm kiếm sách theo danh mục, từ khóa (tiêu đề, tác giả)
- Xem thông tin chi tiết sách
- Xem số lượng sách có sẵn

**2. Librarian (Thủ thư)**
- Tất cả quyền của Reader
- Quản lý sách: Thêm, sửa, xem thông tin sách
- Quản lý độc giả: Tạo thẻ thư viện, cập nhật thông tin
- Quản lý mượn/trả: Tạo phiếu mượn, xử lý trả sách, theo dõi quá hạn

**3. Admin (Quản trị viên)**
- Tất cả quyền của Librarian
- Xóa sách
- Quản lý danh mục sách
- Quản lý nhân viên và phân quyền
- Xem báo cáo hệ thống

## 🧱 Kiến trúc hệ thống

### Models
- `User` - Thông tin người dùng và vai trò
- `Book` - Thông tin sách
- `Category` - Danh mục sách
- `Reader` - Thông tin độc giả
- `BorrowSlip` - Phiếu mượn sách
- `BorrowDetail` - Chi tiết sách trong phiếu mượn
- `Staff` - Thông tin nhân viên thư viện

### DAL & DAO
- `DBContext` - Quản lý kết nối database
- `UserDAO` - Xác thực và quản lý người dùng
- `BookDAO` - CRUD operations cho sách
- `CategoryDAO` - Quản lý danh mục
- `ReaderDAO` - Quản lý độc giả
- `BorrowSlipDAO` - Quản lý mượn/trả sách

### Controllers (Servlets)
- `LoginController` - Xác thực đăng nhập
- `LogoutController` - Đăng xuất
- `HomeController` - Trang chủ, tìm kiếm sách
- `BookController` - Quản lý sách
- `BorrowController` - Quản lý mượn/trả

### Filters
- `AuthenticationFilter` - Kiểm tra đăng nhập
- `AuthorizationFilter` - Kiểm tra quyền truy cập

### Views (JSP)
- `login.jsp` - Trang đăng nhập
- `home.jsp` - Trang chủ hiển thị sách
- `books/list.jsp` - Danh sách quản lý sách
- `books/add.jsp` - Thêm sách mới
- `borrow/list.jsp` - Danh sách phiếu mượn

## 🗄️ Database Schema

### Bảng chính
- **Users**: Lưu thông tin đăng nhập và vai trò
- **Books**: Thông tin sách và số lượng
- **Categories**: Danh mục sách
- **Readers**: Thông tin độc giả và thẻ thư viện
- **BorrowSlips**: Phiếu mượn sách
- **BorrowDetails**: Chi tiết sách trong mỗi phiếu mượn
- **Staff**: Thông tin nhân viên

## 💻 Yêu cầu hệ thống
- **JDK**: 8 hoặc cao hơn
- **Application Server**: Apache Tomcat 8.5+
- **Database**: Microsoft SQL Server 2012+
- **JDBC Driver**: mssql-jdbc-x.x.x.jre8.jar

## 🚀 Hướng dẫn cài đặt

### Bước 1: Cấu hình Database

1. Mở SQL Server Management Studio
2. Chạy script `database_schema.sql` trong thư mục gốc project
3. Script sẽ tự động:
   - Tạo database `LibraryDB`
   - Tạo tất cả bảng cần thiết
   - Insert dữ liệu mẫu

### Bước 2: Cấu hình kết nối Database

Chỉnh sửa file `src/java/dal/DBContext.java`:

```java
private static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=LibraryDB;encrypt=false";
private static final String USER = "sa";
private static final String PASS = "12345"; // Thay bằng mật khẩu SQL Server của bạn
```

### Bước 3: Thêm JDBC Driver

1. Download JDBC Driver từ [Microsoft](https://docs.microsoft.com/en-us/sql/connect/jdbc/download-microsoft-jdbc-driver-for-sql-server)
2. Thêm JAR file vào project:
   - **NetBeans**: Right-click project → Properties → Libraries → Add JAR/Folder
   - **Hoặc**: Copy vào `<TOMCAT_HOME>/lib`

### Bước 4: Build và Deploy

**Sử dụng NetBeans:**
1. Right-click project → Clean and Build
2. Right-click project → Run
3. Truy cập: `http://localhost:8080/WS1`

**Sử dụng command line:**
```bash
# Build project
ant clean
ant compile
ant dist

# Deploy WAR file vào Tomcat
copy dist/WS1.war <TOMCAT_HOME>/webapps/
```

## 🔐 Tài khoản đăng nhập mẫu

| Role | Username | Password | Mô tả |
|------|----------|----------|-------|
| Admin | admin | 123456 | Quản trị viên hệ thống |
| Librarian | librarian1 | 123456 | Thủ thư |
| Librarian | librarian2 | 123456 | Thủ thư |
| Reader | reader1 | 123456 | Độc giả |
| Reader | reader2 | 123456 | Độc giả |

## 📁 Cấu trúc thư mục

```
WS1/
├── database_schema.sql          # SQL script tạo database
├── README.md
├── src/
│   └── java/
│       ├── models/              # Model classes
│       │   ├── User.java
│       │   ├── Book.java
│       │   ├── Category.java
│       │   ├── Reader.java
│       │   ├── BorrowSlip.java
│       │   ├── BorrowDetail.java
│       │   └── Staff.java
│       ├── dal/
│       │   └── DBContext.java   # Database connection
│       ├── dao/                 # Data Access Objects
│       │   ├── UserDAO.java
│       │   ├── BookDAO.java
│       │   ├── CategoryDAO.java
│       │   ├── ReaderDAO.java
│       │   └── BorrowSlipDAO.java
│       ├── controllers/         # Servlets
│       │   ├── LoginController.java
│       │   ├── LogoutController.java
│       │   ├── HomeController.java
│       │   ├── BookController.java
│       │   └── BorrowController.java
│       └── filters/             # Security filters
│           ├── AuthenticationFilter.java
│           └── AuthorizationFilter.java
└── web/
    ├── WEB-INF/
    │   └── web.xml             # Servlet configuration
    └── views/
        ├── login.jsp
        ├── home.jsp
        ├── books/
        │   ├── list.jsp
        │   ├── add.jsp
        │   ├── edit.jsp
        │   └── view.jsp
        ├── borrow/
        │   ├── list.jsp
        │   ├── new.jsp
        │   └── view.jsp
        └── common/
            └── navbar.jsp
```

## 🛠️ Công nghệ sử dụng

### Backend
- **Java Servlet 3.1**
- **JSP & JSTL**
- **JDBC** - Database connectivity
- **MVC Pattern** - Architectural pattern

### Frontend
- **Bootstrap 5.3** - UI Framework
- **Bootstrap Icons** - Icon library
- **Responsive Design** - Mobile-friendly

### Database
- **Microsoft SQL Server**
- **T-SQL** - Stored procedures & views

## 📊 Các chức năng chi tiết

### 1. Authentication & Authorization
- Đăng nhập với username/password
- Session management (timeout 30 phút)
- Filter-based security
- Role-based access control

### 2. Book Management
- Thêm sách mới với đầy đủ thông tin
- Cập nhật thông tin sách
- Xóa sách (chỉ Admin)
- Tìm kiếm sách theo từ khóa
- Lọc sách theo danh mục
- Hiển thị số lượng có sẵn

### 3. Borrow Management
- Tạo phiếu mượn với nhiều sách
- Tự động trừ số lượng sách có sẵn
- Xem danh sách phiếu mượn (All/Active/Overdue)
- Xử lý trả sách
- Tự động cộng lại số lượng khi trả
- Theo dõi trạng thái và ngày quá hạn

### 4. Reader Management
- Tạo thẻ thư viện cho độc giả
- Cập nhật thông tin độc giả
- Xem lịch sử mượn sách
- Quản lý thời hạn thẻ

## 🎨 Giao diện

- **Modern UI**: Gradient design với màu sắc hiện đại
- **Responsive**: Tương thích mọi thiết bị
- **Bootstrap 5**: Components đẹp mắt, chuyên nghiệp
- **Icons**: Bootstrap Icons cho trải nghiệm trực quan

## ⚠️ Lưu ý

1. **Database**: Đảm bảo SQL Server đang chạy trước khi start application
2. **Port**: Mặc định SQL Server sử dụng port 1433
3. **Firewall**: Mở port 1433 nếu cần thiết
4. **Password**: Trong môi trường production, nên mã hóa password
5. **Session**: Session timeout mặc định 30 phút, có thể điều chỉnh trong web.xml

## 🔧 Troubleshooting

### Lỗi kết nối database
```
Error: Database connection error
Solution: Kiểm tra SQL Server đang chạy và thông tin kết nối trong DBContext.java
```

### Lỗi jakarta.servlet not found
```
Error: jakarta.servlet cannot be resolved
Solution: Đảm bảo Tomcat libraries được thêm vào project build path
```

### Lỗi 404 Not Found
```
Error: HTTP 404
Solution: Kiểm tra URL mapping trong web.xml và deploy đúng context path
```

## 📝 Tác giả & Liên hệ

Dự án được phát triển theo yêu cầu bài tập Java Web với đầy đủ tính năng quản lý thư viện.

## 📄 License

Dự án này được tạo ra cho mục đích học tập và demo.
