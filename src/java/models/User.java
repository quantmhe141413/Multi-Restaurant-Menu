package models;

import java.sql.Timestamp;

public class User {
    private int userId;
    private String username;
    private String password;
    private String role; // reader, librarian, admin
    private String fullName;
    private String email;
    private String phone;
    private boolean status;
    private Timestamp createdDate;

    // Constructors
    public User() {
    }

    public User(int userId, String username, String password, String role, String fullName, 
                String email, String phone, boolean status, Timestamp createdDate) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.role = role;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.status = status;
        this.createdDate = createdDate;
    }

    // Getters and Setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    // Helper methods
    public boolean isAdmin() {
        return "admin".equalsIgnoreCase(this.role);
    }

    public boolean isLibrarian() {
        return "librarian".equalsIgnoreCase(this.role);
    }

    public boolean isReader() {
        return "reader".equalsIgnoreCase(this.role);
    }

    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", username='" + username + '\'' +
                ", role='" + role + '\'' +
                ", fullName='" + fullName + '\'' +
                ", status=" + status +
                '}';
    }
}
