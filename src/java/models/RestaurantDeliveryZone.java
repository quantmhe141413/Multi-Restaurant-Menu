package models;

import java.sql.Date;

public class RestaurantDeliveryZone {
    private Integer zoneId;
    private Integer restaurantId;
    private String restaurantName; // Restaurant name for display
    private String zoneName;
    private String zoneDefinition;
    private Boolean isActive;
    private Date createdAt;

    public RestaurantDeliveryZone() {
    }

    public RestaurantDeliveryZone(Integer zoneId, Integer restaurantId, String zoneName, 
                                   String zoneDefinition, Boolean isActive, Date createdAt) {
        this.zoneId = zoneId;
        this.restaurantId = restaurantId;
        this.zoneName = zoneName;
        this.zoneDefinition = zoneDefinition;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }

    public Integer getZoneId() {
        return zoneId;
    }

    public void setZoneId(Integer zoneId) {
        this.zoneId = zoneId;
    }

    public Integer getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(Integer restaurantId) {
        this.restaurantId = restaurantId;
    }

    public String getRestaurantName() {
        return restaurantName;
    }

    public void setRestaurantName(String restaurantName) {
        this.restaurantName = restaurantName;
    }

    public String getZoneName() {
        return zoneName;
    }

    public void setZoneName(String zoneName) {
        this.zoneName = zoneName;
    }

    public String getZoneDefinition() {
        return zoneDefinition;
    }

    public void setZoneDefinition(String zoneDefinition) {
        this.zoneDefinition = zoneDefinition;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "RestaurantDeliveryZone{" +
                "zoneId=" + zoneId +
                ", restaurantId=" + restaurantId +
                ", zoneName='" + zoneName + '\'' +
                ", zoneDefinition='" + zoneDefinition + '\'' +
                ", isActive=" + isActive +
                ", createdAt=" + createdAt +
                '}';
    }
}
