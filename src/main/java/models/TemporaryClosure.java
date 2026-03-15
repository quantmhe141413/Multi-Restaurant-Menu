package models;

import java.sql.Timestamp;

public class TemporaryClosure {
    private Integer closureId;
    private Integer restaurantId;
    private Timestamp startDateTime;
    private Timestamp endDateTime;
    private String reason;
    private Boolean isActive;
    private Timestamp createdAt;
    
    public TemporaryClosure() {
    }

    public TemporaryClosure(Integer closureId, Integer restaurantId, Timestamp startDateTime, 
                           Timestamp endDateTime, String reason, Boolean isActive, Timestamp createdAt) {
        this.closureId = closureId;
        this.restaurantId = restaurantId;
        this.startDateTime = startDateTime;
        this.endDateTime = endDateTime;
        this.reason = reason;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }

    public Integer getClosureId() {
        return closureId;
    }

    public void setClosureId(Integer closureId) {
        this.closureId = closureId;
    }

    public Integer getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(Integer restaurantId) {
        this.restaurantId = restaurantId;
    }

    public Timestamp getStartDateTime() {
        return startDateTime;
    }

    public void setStartDateTime(Timestamp startDateTime) {
        this.startDateTime = startDateTime;
    }

    public Timestamp getEndDateTime() {
        return endDateTime;
    }

    public void setEndDateTime(Timestamp endDateTime) {
        this.endDateTime = endDateTime;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "TemporaryClosure{" +
                "closureId=" + closureId +
                ", restaurantId=" + restaurantId +
                ", startDateTime=" + startDateTime +
                ", endDateTime=" + endDateTime +
                ", reason='" + reason + '\'' +
                ", isActive=" + isActive +
                ", createdAt=" + createdAt +
                '}';
    }
}
