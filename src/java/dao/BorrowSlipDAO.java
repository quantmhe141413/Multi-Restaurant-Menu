package dao;

import dal.DBContext;
import models.BorrowSlip;
import models.BorrowDetail;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BorrowSlipDAO {
    
    public List<BorrowSlip> getAllBorrowSlips() {
        List<BorrowSlip> slips = new ArrayList<>();
        String sql = "SELECT bs.*, r.full_name as reader_name, r.card_number, u.full_name as librarian_name " +
                     "FROM BorrowSlips bs " +
                     "JOIN Readers r ON bs.reader_id = r.reader_id " +
                     "LEFT JOIN Users u ON bs.librarian_id = u.user_id " +
                     "ORDER BY bs.borrow_date DESC";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                slips.add(mapResultSetToBorrowSlip(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting all borrow slips: " + e.getMessage());
        }
        return slips;
    }

    // Check if a reader has any overdue borrow slips with unpaid fine
    public boolean hasUnpaidOverdueByReader(int readerId) {
        String sql = "SELECT COUNT(*) FROM BorrowSlips " +
                     "WHERE reader_id = ? AND status = 'borrowed' " +
                     "AND due_date < GETDATE() AND (fine_paid = 0 OR fine_paid IS NULL)";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, readerId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error checking unpaid overdue by reader: " + e.getMessage());
        }
        return false;
    }
    
    // Get active borrow slips that contain a specific book (for showing current borrowers of a book)
    public List<BorrowSlip> getActiveBorrowsByBook(int bookId) {
        List<BorrowSlip> slips = new ArrayList<>();
        String sql = "SELECT bs.*, r.full_name as reader_name, r.card_number, u.full_name as librarian_name, " +
                     "SUM(bd.quantity) as total_quantity " +
                     "FROM BorrowSlips bs " +
                     "JOIN Readers r ON bs.reader_id = r.reader_id " +
                     "LEFT JOIN Users u ON bs.librarian_id = u.user_id " +
                     "JOIN BorrowDetails bd ON bs.slip_id = bd.slip_id " +
                     "WHERE bs.status = 'borrowed' AND bd.book_id = ? AND bd.returned = 0 " +
                     "GROUP BY bs.slip_id, bs.reader_id, bs.librarian_id, bs.borrow_date, bs.due_date, bs.return_date, bs.status, bs.notes, " +
                     "r.full_name, r.card_number, u.full_name " +
                     "ORDER BY bs.due_date";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BorrowSlip slip = mapResultSetToBorrowSlip(rs);
                    slip.setTotalQuantity(rs.getInt("total_quantity"));
                    slips.add(slip);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting active borrows by book: " + e.getMessage());
        }
        return slips;
    }
    
    public List<BorrowSlip> getActiveBorrowSlips() {
        List<BorrowSlip> slips = new ArrayList<>();
        String sql = "SELECT bs.*, r.full_name as reader_name, r.card_number, u.full_name as librarian_name " +
                     "FROM BorrowSlips bs " +
                     "JOIN Readers r ON bs.reader_id = r.reader_id " +
                     "LEFT JOIN Users u ON bs.librarian_id = u.user_id " +
                     "WHERE bs.status = 'borrowed' " +
                     "ORDER BY bs.due_date";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                slips.add(mapResultSetToBorrowSlip(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting active borrow slips: " + e.getMessage());
        }
        return slips;
    }
    
    public List<BorrowSlip> getOverdueBorrowSlips() {
        List<BorrowSlip> slips = new ArrayList<>();
        String sql = "SELECT bs.*, r.full_name as reader_name, r.card_number, u.full_name as librarian_name " +
                     "FROM BorrowSlips bs " +
                     "JOIN Readers r ON bs.reader_id = r.reader_id " +
                     "LEFT JOIN Users u ON bs.librarian_id = u.user_id " +
                     "WHERE bs.status = 'borrowed' AND bs.due_date < GETDATE() " +
                     "ORDER BY bs.due_date";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                slips.add(mapResultSetToBorrowSlip(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting overdue borrow slips: " + e.getMessage());
        }
        return slips;
    }
    
    public BorrowSlip getBorrowSlipById(int slipId) {
        String sql = "SELECT bs.*, r.full_name as reader_name, r.card_number, u.full_name as librarian_name " +
                     "FROM BorrowSlips bs " +
                     "JOIN Readers r ON bs.reader_id = r.reader_id " +
                     "LEFT JOIN Users u ON bs.librarian_id = u.user_id " +
                     "WHERE bs.slip_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, slipId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBorrowSlip(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting borrow slip by ID: " + e.getMessage());
        }
        return null;
    }
    
    public List<BorrowSlip> getBorrowSlipsByReader(int readerId) {
        List<BorrowSlip> slips = new ArrayList<>();
        String sql = "SELECT bs.*, r.full_name as reader_name, r.card_number, u.full_name as librarian_name " +
                     "FROM BorrowSlips bs " +
                     "JOIN Readers r ON bs.reader_id = r.reader_id " +
                     "LEFT JOIN Users u ON bs.librarian_id = u.user_id " +
                     "WHERE bs.reader_id = ? " +
                     "ORDER BY bs.borrow_date DESC";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, readerId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    slips.add(mapResultSetToBorrowSlip(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting borrow slips by reader: " + e.getMessage());
        }
        return slips;
    }
    
    public int createBorrowSlip(BorrowSlip slip) {
        String sql = "INSERT INTO BorrowSlips (reader_id, librarian_id, borrow_date, due_date, status, notes) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, slip.getReaderId());
            
            if (slip.getLibrarianId() != null) {
                ps.setInt(2, slip.getLibrarianId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            
            ps.setTimestamp(3, slip.getBorrowDate());
            ps.setTimestamp(4, slip.getDueDate());
            ps.setString(5, slip.getStatus());
            ps.setString(6, slip.getNotes());
            
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Error creating borrow slip: " + e.getMessage());
        }
        return -1;
    }
    
    public boolean updateBorrowSlip(BorrowSlip slip) {
        String sql = "UPDATE BorrowSlips SET reader_id = ?, librarian_id = ?, due_date = ?, " +
                     "return_date = ?, status = ?, notes = ? WHERE slip_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, slip.getReaderId());
            
            if (slip.getLibrarianId() != null) {
                ps.setInt(2, slip.getLibrarianId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            
            ps.setTimestamp(3, slip.getDueDate());
            ps.setTimestamp(4, slip.getReturnDate());
            ps.setString(5, slip.getStatus());
            ps.setString(6, slip.getNotes());
            ps.setInt(7, slip.getSlipId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating borrow slip: " + e.getMessage());
            return false;
        }
    }

    public boolean markFinePaid(int slipId) {
        String sql = "UPDATE BorrowSlips SET fine_paid = 1 WHERE slip_id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, slipId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error marking fine as paid: " + e.getMessage());
            return false;
        }
    }
    
    public boolean returnBorrowSlip(int slipId) {
        String sql = "UPDATE BorrowSlips SET return_date = GETDATE(), status = 'returned' WHERE slip_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, slipId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error returning borrow slip: " + e.getMessage());
            return false;
        }
    }
    
    public boolean deleteBorrowSlip(int slipId) {
        String sql = "DELETE FROM BorrowSlips WHERE slip_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, slipId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting borrow slip: " + e.getMessage());
            return false;
        }
    }
    
    // BorrowDetails methods
    public List<BorrowDetail> getBorrowDetailsBySlipId(int slipId) {
        List<BorrowDetail> details = new ArrayList<>();
        String sql = "SELECT bd.*, b.title, b.author FROM BorrowDetails bd " +
                     "JOIN Books b ON bd.book_id = b.book_id " +
                     "WHERE bd.slip_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, slipId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    details.add(mapResultSetToBorrowDetail(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting borrow details: " + e.getMessage());
        }
        return details;
    }
    
    public boolean addBorrowDetail(BorrowDetail detail) {
        String sql = "INSERT INTO BorrowDetails (slip_id, book_id, quantity, returned) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, detail.getSlipId());
            ps.setInt(2, detail.getBookId());
            ps.setInt(3, detail.getQuantity());
            ps.setBoolean(4, detail.isReturned());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error adding borrow detail: " + e.getMessage());
            return false;
        }
    }
    
    public boolean returnBorrowDetail(int detailId) {
        String sql = "UPDATE BorrowDetails SET returned = 1 WHERE detail_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, detailId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error returning borrow detail: " + e.getMessage());
            return false;
        }
    }
    
    private BorrowSlip mapResultSetToBorrowSlip(ResultSet rs) throws SQLException {
        BorrowSlip slip = new BorrowSlip();
        slip.setSlipId(rs.getInt("slip_id"));
        slip.setReaderId(rs.getInt("reader_id"));
        
        int librarianId = rs.getInt("librarian_id");
        if (!rs.wasNull()) {
            slip.setLibrarianId(librarianId);
        }
        
        slip.setBorrowDate(rs.getTimestamp("borrow_date"));
        slip.setDueDate(rs.getTimestamp("due_date"));
        slip.setReturnDate(rs.getTimestamp("return_date"));
        slip.setStatus(rs.getString("status"));
        slip.setNotes(rs.getString("notes"));
        try {
            slip.setFinePaid(rs.getBoolean("fine_paid"));
        } catch (SQLException e) {
            // column may not exist in some result sets
        }
        
        // Additional display fields
        slip.setReaderName(rs.getString("reader_name"));
        slip.setReaderCardNumber(rs.getString("card_number"));
        slip.setLibrarianName(rs.getString("librarian_name"));
        
        return slip;
    }
    
    private BorrowDetail mapResultSetToBorrowDetail(ResultSet rs) throws SQLException {
        BorrowDetail detail = new BorrowDetail();
        detail.setDetailId(rs.getInt("detail_id"));
        detail.setSlipId(rs.getInt("slip_id"));
        detail.setBookId(rs.getInt("book_id"));
        detail.setQuantity(rs.getInt("quantity"));
        detail.setReturned(rs.getBoolean("returned"));
        
        // Additional display fields
        detail.setBookTitle(rs.getString("title"));
        detail.setBookAuthor(rs.getString("author"));
        
        return detail;
    }
}
