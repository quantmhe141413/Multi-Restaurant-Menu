package models;

import java.sql.Date;

public class Restaurant {
    private Integer restaurantId;
    private Integer ownerId;
    private String name;
    private String address;
    private String licenseNumber;
    private String logoUrl;
    private String themeColor;
    private Boolean isOpen;
    private Double deliveryFee;
    private Double commissionRate;
    private String status;
<<<<<<< HEAD
    private Timestamp createdAt;
    private String cuisine;
=======
    private Date createdAt;
>>>>>>> 0aad6e27f51f6d74006f3bfab0b19f6752935075

    public Restaurant() {
    }

    public Restaurant(Integer restaurantId, Integer ownerId, String name, String address, 
                     String licenseNumber, String logoUrl, String themeColor, Boolean isOpen, 
                     Double deliveryFee, Double commissionRate, String status, Date createdAt) {
        this.restaurantId = restaurantId;
        this.ownerId = ownerId;
        this.name = name;
        this.address = address;
        this.licenseNumber = licenseNumber;
        this.logoUrl = logoUrl;
        this.themeColor = themeColor;
        this.isOpen = isOpen;
        this.deliveryFee = deliveryFee;
        this.commissionRate = commissionRate;
        this.status = status;
        this.createdAt = createdAt;
    }

    public Integer getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(Integer restaurantId) {
        this.restaurantId = restaurantId;
    }

    public Integer getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(Integer ownerId) {
        this.ownerId = ownerId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getLicenseNumber() {
        return licenseNumber;
    }

    public void setLicenseNumber(String licenseNumber) {
        this.licenseNumber = licenseNumber;
    }

    public String getLogoUrl() {
        return logoUrl;
    }

    public void setLogoUrl(String logoUrl) {
        this.logoUrl = logoUrl;
    }

    public String getThemeColor() {
        return themeColor;
    }

    public void setThemeColor(String themeColor) {
        this.themeColor = themeColor;
    }

    public Boolean getIsOpen() {
        return isOpen;
    }

    public void setIsOpen(Boolean isOpen) {
        this.isOpen = isOpen;
    }

    public Double getDeliveryFee() {
        return deliveryFee;
    }

    public void setDeliveryFee(Double deliveryFee) {
        this.deliveryFee = deliveryFee;
    }

    public Double getCommissionRate() {
        return commissionRate;
    }

    public void setCommissionRate(Double commissionRate) {
        this.commissionRate = commissionRate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

<<<<<<< HEAD
    public String getCuisine() {
        return cuisine;
    }

    public void setCuisine(String cuisine) {
        this.cuisine = cuisine;
=======
    @Override
    public String toString() {
        return "Restaurant{" +
                "restaurantId=" + restaurantId +
                ", ownerId=" + ownerId +
                ", name='" + name + '\'' +
                ", address='" + address + '\'' +
                ", status='" + status + '\'' +
                '}';
>>>>>>> 0aad6e27f51f6d74006f3bfab0b19f6752935075
    }
}
