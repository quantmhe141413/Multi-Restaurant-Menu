package dao;

import dal.DBContext;
import models.Reader;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReaderDAO {
    
    public List<Reader> getAllReaders() {
        List<Reader> readers = new ArrayList<>();
        String sql = "SELECT * FROM Readers ORDER BY full_name";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                readers.add(mapResultSetToReader(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting all readers: " + e.getMessage());
        }
        return readers;
    }
    
    public List<Reader> getActiveReaders() {
        List<Reader> readers = new ArrayList<>();
        String sql = "SELECT * FROM Readers WHERE status = 1 AND (expiry_date IS NULL OR expiry_date >= GETDATE()) " +
                     "ORDER BY full_name";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                readers.add(mapResultSetToReader(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting active readers: " + e.getMessage());
        }
        return readers;
    }
    
    public Reader getReaderById(int readerId) {
        String sql = "SELECT * FROM Readers WHERE reader_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, readerId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToReader(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting reader by ID: " + e.getMessage());
        }
        return null;
    }
    
    public Reader getReaderByCardNumber(String cardNumber) {
        String sql = "SELECT * FROM Readers WHERE card_number = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, cardNumber);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToReader(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting reader by card number: " + e.getMessage());
        }
        return null;
    }
    
    public Reader getReaderByUserId(int userId) {
        String sql = "SELECT * FROM Readers WHERE user_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToReader(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting reader by user ID: " + e.getMessage());
        }
        return null;
    }
    
    public List<Reader> searchReaders(String keyword) {
        List<Reader> readers = new ArrayList<>();
        String sql = "SELECT * FROM Readers WHERE full_name LIKE ? OR card_number LIKE ? OR phone LIKE ? " +
                     "ORDER BY full_name";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    readers.add(mapResultSetToReader(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error searching readers: " + e.getMessage());
        }
        return readers;
    }
    
    public boolean createReader(Reader reader) {
        String sql = "INSERT INTO Readers (card_number, full_name, phone, email, address, " +
                     "user_id, expiry_date, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, reader.getCardNumber());
            ps.setString(2, reader.getFullName());
            ps.setString(3, reader.getPhone());
            ps.setString(4, reader.getEmail());
            ps.setString(5, reader.getAddress());
            
            if (reader.getUserID() != null) {
                ps.setInt(6, reader.getUserID());
            } else {
                ps.setNull(6, Types.INTEGER);
            }
            
            ps.setTimestamp(7, reader.getExpiryDate());
            ps.setBoolean(8, reader.isStatus());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error creating reader: " + e.getMessage());
            return false;
        }
    }
    
    public boolean updateReader(Reader reader) {
        String sql = "UPDATE Readers SET card_number = ?, full_name = ?, phone = ?, email = ?, " +
                     "address = ?, user_id = ?, expiry_date = ?, status = ? WHERE reader_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, reader.getCardNumber());
            ps.setString(2, reader.getFullName());
            ps.setString(3, reader.getPhone());
            ps.setString(4, reader.getEmail());
            ps.setString(5, reader.getAddress());
            
            if (reader.getUserID() != null) {
                ps.setInt(6, reader.getUserID());
            } else {
                ps.setNull(6, Types.INTEGER);
            }
            
            ps.setTimestamp(7, reader.getExpiryDate());
            ps.setBoolean(8, reader.isStatus());
            ps.setInt(9, reader.getReaderId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating reader: " + e.getMessage());
            return false;
        }
    }
    
    public boolean deleteReader(int readerId) {
        String sql = "DELETE FROM Readers WHERE reader_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, readerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting reader: " + e.getMessage());
            return false;
        }
    }
    
    private Reader mapResultSetToReader(ResultSet rs) throws SQLException {
        Reader reader = new Reader();
        reader.setReaderId(rs.getInt("reader_id"));
        reader.setCardNumber(rs.getString("card_number"));
        reader.setFullName(rs.getString("full_name"));
        reader.setPhone(rs.getString("phone"));
        reader.setEmail(rs.getString("email"));
        reader.setAddress(rs.getString("address"));
        
        int userId = rs.getInt("user_id");
        if (!rs.wasNull()) {
            reader.setUserId(userId);
        }
        
        reader.setCreatedDate(rs.getTimestamp("created_date"));
        reader.setExpiryDate(rs.getTimestamp("expiry_date"));
        reader.setStatus(rs.getBoolean("status"));
        
        return reader;
    }
}
