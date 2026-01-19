package models;

import java.sql.Timestamp;

public class Staff {
    private int staffId;
    private int userId;
    private String position;
    private String department;
    private Timestamp hireDate;
    
    // Additional fields for display
    private String fullName;
    private String username;

    // Constructors
    public Staff() {
    }

    public Staff(int staffId, int userId, String position, String department, Timestamp hireDate) {
        this.staffId = staffId;
        this.userId = userId;
        this.position = position;
        this.department = department;
        this.hireDate = hireDate;
    }

    // Getters and Setters
    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public int getUserID() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public Timestamp getHireDate() {
        return hireDate;
    }

    public void setHireDate(Timestamp hireDate) {
        this.hireDate = hireDate;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    @Override
    public String toString() {
        return "Staff{" +
                "staffId=" + staffId +
                ", position='" + position + '\'' +
                ", department='" + department + '\'' +
                '}';
    }
}
