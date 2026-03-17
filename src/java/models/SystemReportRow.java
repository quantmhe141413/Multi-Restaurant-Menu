package models;

import java.math.BigDecimal;
import java.sql.Date;

public class SystemReportRow {

    private Date reportDate;
    private int totalOrders;
    private int completedOrders;
    private BigDecimal revenue;
    private int newRestaurants;
    private int newUsers;
    private int newComplaints;

    public SystemReportRow() {
    }

    public Date getReportDate() {
        return reportDate;
    }

    public void setReportDate(Date reportDate) {
        this.reportDate = reportDate;
    }

    public int getTotalOrders() {
        return totalOrders;
    }

    public void setTotalOrders(int totalOrders) {
        this.totalOrders = totalOrders;
    }

    public int getCompletedOrders() {
        return completedOrders;
    }

    public void setCompletedOrders(int completedOrders) {
        this.completedOrders = completedOrders;
    }

    public BigDecimal getRevenue() {
        return revenue;
    }

    public void setRevenue(BigDecimal revenue) {
        this.revenue = revenue;
    }

    public int getNewRestaurants() {
        return newRestaurants;
    }

    public void setNewRestaurants(int newRestaurants) {
        this.newRestaurants = newRestaurants;
    }

    public int getNewUsers() {
        return newUsers;
    }

    public void setNewUsers(int newUsers) {
        this.newUsers = newUsers;
    }

    public int getNewComplaints() {
        return newComplaints;
    }

    public void setNewComplaints(int newComplaints) {
        this.newComplaints = newComplaints;
    }
}
