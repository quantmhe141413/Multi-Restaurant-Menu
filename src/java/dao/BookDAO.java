package dao;

import dal.DBContext;
import models.Book;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {
    
    public List<Book> getAllBooks() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.*, c.category_name FROM Books b " +
                     "LEFT JOIN Categories c ON b.category_id = c.category_id " +
                     "ORDER BY b.title";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting all books: " + e.getMessage());
        }
        return books;
    }
    
    public List<Book> getAvailableBooks() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.*, c.category_name FROM Books b " +
                     "LEFT JOIN Categories c ON b.category_id = c.category_id " +
                     "WHERE b.available_quantity > 0 ORDER BY b.title";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting available books: " + e.getMessage());
        }
        return books;
    }
    
    // Get visible books only (for readers)
    public List<Book> getVisibleBooks() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.*, c.category_name FROM Books b " +
                     "LEFT JOIN Categories c ON b.category_id = c.category_id " +
                     "WHERE b.is_hidden = 0 ORDER BY b.title";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting visible books: " + e.getMessage());
        }
        return books;
    }
    
    public Book getBookById(int bookId) {
        String sql = "SELECT b.*, c.category_name FROM Books b " +
                     "LEFT JOIN Categories c ON b.category_id = c.category_id " +
                     "WHERE b.book_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, bookId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBook(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting book by ID: " + e.getMessage());
        }
        return null;
    }
    
    public List<Book> searchBooks(String keyword) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.*, c.category_name FROM Books b " +
                     "LEFT JOIN Categories c ON b.category_id = c.category_id " +
                     "WHERE b.title LIKE ? OR b.author LIKE ? OR b.description LIKE ? " +
                     "ORDER BY b.title";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error searching books: " + e.getMessage());
        }
        return books;
    }
    
    // Search visible books only (for readers)
    public List<Book> searchVisibleBooks(String keyword) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.*, c.category_name FROM Books b " +
                     "LEFT JOIN Categories c ON b.category_id = c.category_id " +
                     "WHERE (b.title LIKE ? OR b.author LIKE ? OR b.description LIKE ?) " +
                     "AND b.is_hidden = 0 ORDER BY b.title";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error searching visible books: " + e.getMessage());
        }
        return books;
    }
    
    public List<Book> getBooksByCategory(int categoryId) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.*, c.category_name FROM Books b " +
                     "LEFT JOIN Categories c ON b.category_id = c.category_id " +
                     "WHERE b.category_id = ? ORDER BY b.title";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, categoryId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting books by category: " + e.getMessage());
        }
        return books;
    }
    
    // Get visible books by category (for readers)
    public List<Book> getVisibleBooksByCategory(int categoryId) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.*, c.category_name FROM Books b " +
                     "LEFT JOIN Categories c ON b.category_id = c.category_id " +
                     "WHERE b.category_id = ? AND b.is_hidden = 0 ORDER BY b.title";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, categoryId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting visible books by category: " + e.getMessage());
        }
        return books;
    }
    
    public boolean createBook(Book book) {
        String sql = "INSERT INTO Books (title, author, publisher, publish_year, isbn, " +
                     "quantity, available_quantity, category_id, location, description, image_url) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, book.getTitle());
            ps.setString(2, book.getAuthor());
            ps.setString(3, book.getPublisher());
            ps.setInt(4, book.getPublishYear());
            ps.setString(5, book.getIsbn());
            ps.setInt(6, book.getQuantity());
            ps.setInt(7, book.getAvailableQuantity());
            ps.setInt(8, book.getCategoryId());
            ps.setString(9, book.getLocation());
            ps.setString(10, book.getDescription());
            ps.setString(11, book.getImageUrl());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error creating book: " + e.getMessage());
            return false;
        }
    }
    
    public boolean updateBook(Book book) {
        String sql = "UPDATE Books SET title = ?, author = ?, publisher = ?, publish_year = ?, " +
                     "isbn = ?, quantity = ?, available_quantity = ?, category_id = ?, location = ?, " +
                     "description = ?, image_url = ?, updated_date = GETDATE() WHERE book_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, book.getTitle());
            ps.setString(2, book.getAuthor());
            ps.setString(3, book.getPublisher());
            ps.setInt(4, book.getPublishYear());
            ps.setString(5, book.getIsbn());
            ps.setInt(6, book.getQuantity());
            ps.setInt(7, book.getAvailableQuantity());
            ps.setInt(8, book.getCategoryId());
            ps.setString(9, book.getLocation());
            ps.setString(10, book.getDescription());
            ps.setString(11, book.getImageUrl());
            ps.setInt(12, book.getBookId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating book: " + e.getMessage());
            return false;
        }
    }
    
    public boolean deleteBook(int bookId) {
        String sql = "DELETE FROM Books WHERE book_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, bookId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting book: " + e.getMessage());
            return false;
        }
    }
    
    public boolean updateAvailableQuantity(int bookId, int change) {
        String sql = "UPDATE Books SET available_quantity = available_quantity + ? WHERE book_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, change);
            ps.setInt(2, bookId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating available quantity: " + e.getMessage());
            return false;
        }
    }
    
    public boolean hideBook(int bookId) {
        String sql = "UPDATE Books SET is_hidden = 1, updated_date = GETDATE() WHERE book_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, bookId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error hiding book: " + e.getMessage());
            return false;
        }
    }
    
    public boolean unhideBook(int bookId) {
        String sql = "UPDATE Books SET is_hidden = 0, updated_date = GETDATE() WHERE book_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, bookId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error unhiding book: " + e.getMessage());
            return false;
        }
    }
    
    // Pagination methods
    public int getTotalBooks(boolean includeHidden) {
        String sql = includeHidden ? 
                     "SELECT COUNT(*) FROM Books" : 
                     "SELECT COUNT(*) FROM Books WHERE is_hidden = 0";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error getting total books: " + e.getMessage());
        }
        return 0;
    }
    
    public List<Book> getBooksPaginated(int page, int pageSize, boolean includeHidden) {
        List<Book> books = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        String sql = includeHidden ?
                     "SELECT b.*, c.category_name FROM Books b " +
                     "LEFT JOIN Categories c ON b.category_id = c.category_id " +
                     "ORDER BY b.title OFFSET ? ROWS FETCH NEXT ? ROWS ONLY" :
                     "SELECT b.*, c.category_name FROM Books b " +
                     "LEFT JOIN Categories c ON b.category_id = c.category_id " +
                     "WHERE b.is_hidden = 0 " +
                     "ORDER BY b.title OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting paginated books: " + e.getMessage());
        }
        return books;
    }
    
    public int getTotalSearchResults(String keyword, boolean includeHidden) {
        String sql = includeHidden ?
                     "SELECT COUNT(*) FROM Books WHERE title LIKE ? OR author LIKE ? OR isbn LIKE ?" :
                     "SELECT COUNT(*) FROM Books WHERE (title LIKE ? OR author LIKE ? OR isbn LIKE ?) AND is_hidden = 0";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting total search results: " + e.getMessage());
        }
        return 0;
    }
    
    public List<Book> searchBooksPaginated(String keyword, int page, int pageSize, boolean includeHidden) {
        List<Book> books = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        String sql = includeHidden ?
                     "SELECT b.*, c.category_name FROM Books b " +
                     "LEFT JOIN Categories c ON b.category_id = c.category_id " +
                     "WHERE b.title LIKE ? OR b.author LIKE ? OR b.isbn LIKE ? " +
                     "ORDER BY b.title OFFSET ? ROWS FETCH NEXT ? ROWS ONLY" :
                     "SELECT b.*, c.category_name FROM Books b " +
                     "LEFT JOIN Categories c ON b.category_id = c.category_id " +
                     "WHERE (b.title LIKE ? OR b.author LIKE ? OR b.isbn LIKE ?) AND b.is_hidden = 0 " +
                     "ORDER BY b.title OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setInt(4, offset);
            ps.setInt(5, pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error searching paginated books: " + e.getMessage());
        }
        return books;
    }
    
    public int getTotalBooksByCategory(int categoryId, boolean includeHidden) {
        String sql = includeHidden ?
                     "SELECT COUNT(*) FROM Books WHERE category_id = ?" :
                     "SELECT COUNT(*) FROM Books WHERE category_id = ? AND is_hidden = 0";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, categoryId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting total books by category: " + e.getMessage());
        }
        return 0;
    }
    
    public List<Book> getBooksByCategoryPaginated(int categoryId, int page, int pageSize, boolean includeHidden) {
        List<Book> books = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        String sql = includeHidden ?
                     "SELECT b.*, c.category_name FROM Books b " +
                     "LEFT JOIN Categories c ON b.category_id = c.category_id " +
                     "WHERE b.category_id = ? " +
                     "ORDER BY b.title OFFSET ? ROWS FETCH NEXT ? ROWS ONLY" :
                     "SELECT b.*, c.category_name FROM Books b " +
                     "LEFT JOIN Categories c ON b.category_id = c.category_id " +
                     "WHERE b.category_id = ? AND b.is_hidden = 0 " +
                     "ORDER BY b.title OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, categoryId);
            ps.setInt(2, offset);
            ps.setInt(3, pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting paginated books by category: " + e.getMessage());
        }
        return books;
    }
    
    private Book mapResultSetToBook(ResultSet rs) throws SQLException {
        Book book = new Book();
        book.setBookId(rs.getInt("book_id"));
        book.setTitle(rs.getString("title"));
        book.setAuthor(rs.getString("author"));
        book.setPublisher(rs.getString("publisher"));
        book.setPublishYear(rs.getInt("publish_year"));
        book.setIsbn(rs.getString("isbn"));
        book.setQuantity(rs.getInt("quantity"));
        book.setAvailableQuantity(rs.getInt("available_quantity"));
        book.setCategoryId(rs.getInt("category_id"));
        book.setLocation(rs.getString("location"));
        book.setDescription(rs.getString("description"));
        book.setImageUrl(rs.getString("image_url"));
        book.setHidden(rs.getBoolean("is_hidden"));
        book.setCreatedDate(rs.getTimestamp("created_date"));
        book.setUpdatedDate(rs.getTimestamp("updated_date"));
        
        // Set category name if available
        try {
            book.setCategoryName(rs.getString("category_name"));
        } catch (SQLException e) {
            // Category name might not be in the result set
        }
        
        return book;
    }
}
