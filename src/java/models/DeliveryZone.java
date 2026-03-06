package models;

public class DeliveryZone {
    private int zoneID;
    private int restaurantID;
    private String zoneName;
    private String zoneDefinition;
    private boolean isActive;

    public DeliveryZone() {
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

    public String getZoneDefinition() {
        return zoneDefinition;
    }

    public void setZoneDefinition(String zoneDefinition) {
        this.zoneDefinition = zoneDefinition;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }
}
