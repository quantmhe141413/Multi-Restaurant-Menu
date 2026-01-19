package models;

import java.sql.Timestamp;

public class Reader {
    private int readerId;
    private String cardNumber;
    private String fullName;
    private String phone;
    private String email;
    private String address;
    private Integer userId; // nullable - some readers may not have user accounts
    private Timestamp createdDate;
    private Timestamp expiryDate;
    private boolean status;

    // Constructors
    public Reader() {
    }

    public Reader(int readerId, String cardNumber, String fullName, String phone, 
                  String email, String address, Integer userId, Timestamp createdDate, 
                  Timestamp expiryDate, boolean status) {
        this.readerId = readerId;
        this.cardNumber = cardNumber;
        this.fullName = fullName;
        this.phone = phone;
        this.email = email;
        this.address = address;
        this.userId = userId;
        this.createdDate = createdDate;
        this.expiryDate = expiryDate;
        this.status = status;
    }

    // Getters and Setters
    public int getReaderId() {
        return readerId;
    }

    public void setReaderId(int readerId) {
        this.readerId = readerId;
    }

    public String getCardNumber() {
        return cardNumber;
    }

    public void setCardNumber(String cardNumber) {
        this.cardNumber = cardNumber;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Integer getUserID() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    public Timestamp getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Timestamp expiryDate) {
        this.expiryDate = expiryDate;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    // Helper methods
    public boolean isExpired() {
        if (expiryDate == null) return false;
        return expiryDate.before(new Timestamp(System.currentTimeMillis()));
    }

    public boolean isActive() {
        return status && !isExpired();
    }

    @Override
    public String toString() {
        return "Reader{" +
                "readerId=" + readerId +
                ", cardNumber='" + cardNumber + '\'' +
                ", fullName='" + fullName + '\'' +
                ", status=" + status +
                '}';
    }
}
