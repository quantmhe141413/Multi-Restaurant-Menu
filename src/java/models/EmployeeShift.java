package models;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

public class EmployeeShift {
    private Integer shiftId;
    private Integer restaurantId;
    private Integer staffId;
    private Integer templateId;
    private String staffName; // For display purposes
    private Date shiftDate;
    
    // Template details (from JOIN with ShiftTemplates)
    private String shiftName;
    private Time startTime;
    private Time endTime;
    private String position;
    
    private Timestamp createdAt;
    
    // Attendance fields
    private String attendanceStatus;
    private Integer markedBy;
    private String markedByName;
    private Timestamp markedAt;
    private String note;
    
    public EmployeeShift() {
    }

    public EmployeeShift(Integer shiftId, Integer restaurantId, Integer staffId, 
                        Integer templateId, Date shiftDate, Timestamp createdAt) {
        this.shiftId = shiftId;
        this.restaurantId = restaurantId;
        this.staffId = staffId;
        this.templateId = templateId;
        this.shiftDate = shiftDate;
        this.createdAt = createdAt;
    }

    public Integer getShiftId() {
        return shiftId;
    }

    public void setShiftId(Integer shiftId) {
        this.shiftId = shiftId;
    }

    public Integer getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(Integer restaurantId) {
        this.restaurantId = restaurantId;
    }

    public Integer getStaffId() {
        return staffId;
    }

    public void setStaffId(Integer staffId) {
        this.staffId = staffId;
    }

    public String getStaffName() {
        return staffName;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }

    public Integer getTemplateId() {
        return templateId;
    }

    public void setTemplateId(Integer templateId) {
        this.templateId = templateId;
    }

    public String getShiftName() {
        return shiftName;
    }

    public void setShiftName(String shiftName) {
        this.shiftName = shiftName;
    }

    public Date getShiftDate() {
        return shiftDate;
    }

    public void setShiftDate(Date shiftDate) {
        this.shiftDate = shiftDate;
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

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getAttendanceStatus() {
        return attendanceStatus;
    }

    public void setAttendanceStatus(String attendanceStatus) {
        this.attendanceStatus = attendanceStatus;
    }

    public Integer getMarkedBy() {
        return markedBy;
    }

    public void setMarkedBy(Integer markedBy) {
        this.markedBy = markedBy;
    }

    public String getMarkedByName() {
        return markedByName;
    }

    public void setMarkedByName(String markedByName) {
        this.markedByName = markedByName;
    }

    public Timestamp getMarkedAt() {
        return markedAt;
    }

    public void setMarkedAt(Timestamp markedAt) {
        this.markedAt = markedAt;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    @Override
    public String toString() {
        return "EmployeeShift{" +
                "shiftId=" + shiftId +
                ", restaurantId=" + restaurantId +
                ", staffId=" + staffId +
                ", templateId=" + templateId +
                ", staffName='" + staffName + '\'' +
                ", shiftDate=" + shiftDate +
                ", shiftName='" + shiftName + '\'' +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                ", position='" + position + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
