package models;

import java.sql.Timestamp;

public class RestaurantUser {
    private int restaurantUserID;
    private int restaurantID;
    private int userID;
    private String restaurantRole;
    private Timestamp createdAt;

    public RestaurantUser() {
    }

    public int getRestaurantUserID() {
        return restaurantUserID;
    }

    public void setRestaurantUserID(int restaurantUserID) {
        this.restaurantUserID = restaurantUserID;
    }

    public int getRestaurantID() {
        return restaurantID;
    }

    public void setRestaurantID(int restaurantID) {
        this.restaurantID = restaurantID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getRestaurantRole() {
        return restaurantRole;
    }

    public void setRestaurantRole(String restaurantRole) {
        this.restaurantRole = restaurantRole;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
