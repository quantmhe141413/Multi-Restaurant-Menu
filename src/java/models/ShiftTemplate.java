package models;

import java.sql.Time;

public class ShiftTemplate {
    private Integer templateId;
    private Integer restaurantId;
    private String shiftName;
    private String position;
    private Time startTime;
    private Time endTime;
    private Boolean isActive;
    
    public ShiftTemplate() {
    }

    public ShiftTemplate(Integer templateId, Integer restaurantId, String shiftName, 
                        String position, Time startTime, Time endTime, Boolean isActive) {
        this.templateId = templateId;
        this.restaurantId = restaurantId;
        this.shiftName = shiftName;
        this.position = position;
        this.startTime = startTime;
        this.endTime = endTime;
        this.isActive = isActive;
    }

    public Integer getTemplateId() {
        return templateId;
    }

    public void setTemplateId(Integer templateId) {
        this.templateId = templateId;
    }

    public Integer getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(Integer restaurantId) {
        this.restaurantId = restaurantId;
    }

    public String getShiftName() {
        return shiftName;
    }

    public void setShiftName(String shiftName) {
        this.shiftName = shiftName;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public Time getStartTime() {
        return startTime;
    }

    public void setStartTime(Time startTime) {
        this.startTime = startTime;
    }

    public Time getEndTime() {
        return endTime;
    }

    public void setEndTime(Time endTime) {
        this.endTime = endTime;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    @Override
    public String toString() {
        return "ShiftTemplate{" +
                "templateId=" + templateId +
                ", restaurantId=" + restaurantId +
                ", shiftName='" + shiftName + '\'' +
                ", position='" + position + '\'' +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                ", isActive=" + isActive +
                '}';
    }
}
