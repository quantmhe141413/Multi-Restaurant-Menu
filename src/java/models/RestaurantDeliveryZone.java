package models;

import java.sql.Timestamp;

public class RestaurantDeliveryZone {
    private int zoneID;
    private int restaurantID;
    private String zoneName;
    private double radiusKm;
    private double baseDeliveryFee;
    private Timestamp createdAt;

    public RestaurantDeliveryZone() {
    }

    public int getZoneID() {
        return zoneID;
    }

    public void setZoneID(int zoneID) {
        this.zoneID = zoneID;
    }

    public int getRestaurantID() {
        return restaurantID;
    }

    public void setRestaurantID(int restaurantID) {
        this.restaurantID = restaurantID;
    }

    public String getZoneName() {
        return zoneName;
    }

    public void setZoneName(String zoneName) {
        this.zoneName = zoneName;
    }

    public double getRadiusKm() {
        return radiusKm;
    }

    public void setRadiusKm(double radiusKm) {
        this.radiusKm = radiusKm;
    }

    public double getBaseDeliveryFee() {
        return baseDeliveryFee;
    }

    public void setBaseDeliveryFee(double baseDeliveryFee) {
        this.baseDeliveryFee = baseDeliveryFee;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
