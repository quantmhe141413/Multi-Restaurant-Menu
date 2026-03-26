package models;

import java.sql.Date;

/**
 * RestaurantDeliveryZone class
 * 
 * This class represents a delivery zone assigned to a restaurant.
 * It is typically used to define where a restaurant can deliver orders.
 * 
 * This model is often used in:
 * - Admin management (create/update delivery zones)
 * - Order processing (check if delivery is available in a zone)
 * - Reporting or display purposes
 */
public class RestaurantDeliveryZone {

    // Unique identifier for the delivery zone
    private Integer zoneId;

    // ID of the restaurant that owns this delivery zone (foreign key)
    private Integer restaurantId;

    // Restaurant name (used for display purposes, usually from JOIN query)
    private String restaurantName;

    // Name of the delivery zone (e.g., "District 1", "Downtown Area")
    private String zoneName;

    // Detailed definition of the zone (could be description, coordinates, or boundaries)
    private String zoneDefinition;

    // Indicates whether the zone is currently active (true = available for delivery)
    private Boolean isActive;

    // Timestamp when the zone was created
    private Date createdAt;

    /**
     * Default constructor
     * 
     * Required for frameworks like Hibernate, Spring, or JSP
     * to instantiate objects dynamically.
     */
    public RestaurantDeliveryZone() {
    }

    /**
     * Parameterized constructor
     * 
     * Used when creating a fully initialized object (e.g., from database query)
     * 
     * @param zoneId          unique zone ID
     * @param restaurantId    restaurant ID (foreign key)
     * @param zoneName        name of the zone
     * @param zoneDefinition  description or boundary of the zone
     * @param isActive        status of the zone
     * @param createdAt       creation date
     */
    public RestaurantDeliveryZone(Integer zoneId, Integer restaurantId, String zoneName,
                                   String zoneDefinition, Boolean isActive, Date createdAt) {
        this.zoneId = zoneId;
        this.restaurantId = restaurantId;
        this.zoneName = zoneName;
        this.zoneDefinition = zoneDefinition;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }

    /**
     * Get zone ID
     */
    public Integer getZoneId() {
        return zoneId;
    }

    /**
     * Set zone ID
     */
    public void setZoneId(Integer zoneId) {
        this.zoneId = zoneId;
    }

    /**
     * Get restaurant ID
     */
    public Integer getRestaurantId() {
        return restaurantId;
    }

    /**
     * Set restaurant ID
     */
    public void setRestaurantId(Integer restaurantId) {
        this.restaurantId = restaurantId;
    }

    /**
     * Get restaurant name (for display/UI)
     */
    public String getRestaurantName() {
        return restaurantName;
    }

    /**
     * Set restaurant name (usually populated from JOIN query)
     */
    public void setRestaurantName(String restaurantName) {
        this.restaurantName = restaurantName;
    }

    /**
     * Get zone name
     */
    public String getZoneName() {
        return zoneName;
    }

    /**
     * Set zone name
     */
    public void setZoneName(String zoneName) {
        this.zoneName = zoneName;
    }

    /**
     * Get zone definition
     * 
     * This may include:
     * - Text description
     * - Address range
     * - Coordinates (if using map-based system)
     */
    public String getZoneDefinition() {
        return zoneDefinition;
    }

    /**
     * Set zone definition
     */
    public void setZoneDefinition(String zoneDefinition) {
        this.zoneDefinition = zoneDefinition;
    }

    /**
     * Get active status of the zone
     * 
     * @return true if the zone is active, false otherwise
     */
    public Boolean getIsActive() {
        return isActive;
    }

    /**
     * Set active status of the zone
     */
    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    /**
     * Get creation date
     */
    public Date getCreatedAt() {
        return createdAt;
    }

    /**
     * Set creation date
     */
    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    /**
     * Override toString() method
     * 
     * Useful for debugging and logging purposes.
     * Converts object data into readable string format.
     */
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