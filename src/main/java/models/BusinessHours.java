package models;

import java.sql.Time;

public class BusinessHours {
    private Integer hoursId;
    private Integer restaurantId;
    private String dayOfWeek; // Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
    private Time openingTime;
    private Time closingTime;
    private Boolean isOpen; // true if restaurant is open on this day
    
    public BusinessHours() {
    }

    public BusinessHours(Integer hoursId, Integer restaurantId, String dayOfWeek, 
                        Time openingTime, Time closingTime, Boolean isOpen) {
        this.hoursId = hoursId;
        this.restaurantId = restaurantId;
        this.dayOfWeek = dayOfWeek;
        this.openingTime = openingTime;
        this.closingTime = closingTime;
        this.isOpen = isOpen;
    }

    public Integer getHoursId() {
        return hoursId;
    }

    public void setHoursId(Integer hoursId) {
        this.hoursId = hoursId;
    }

    public Integer getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(Integer restaurantId) {
        this.restaurantId = restaurantId;
    }

    public String getDayOfWeek() {
        return dayOfWeek;
    }

    public void setDayOfWeek(String dayOfWeek) {
        this.dayOfWeek = dayOfWeek;
    }

    public Time getOpeningTime() {
        return openingTime;
    }

    public void setOpeningTime(Time openingTime) {
        this.openingTime = openingTime;
    }

    public Time getClosingTime() {
        return closingTime;
    }

    public void setClosingTime(Time closingTime) {
        this.closingTime = closingTime;
    }

    public Boolean getIsOpen() {
        return isOpen;
    }

    public void setIsOpen(Boolean isOpen) {
        this.isOpen = isOpen;
    }

    @Override
    public String toString() {
        return "BusinessHours{" +
                "hoursId=" + hoursId +
                ", restaurantId=" + restaurantId +
                ", dayOfWeek='" + dayOfWeek + '\'' +
                ", openingTime=" + openingTime +
                ", closingTime=" + closingTime +
                ", isOpen=" + isOpen +
                '}';
    }
}
