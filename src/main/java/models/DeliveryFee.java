package models;

import java.math.BigDecimal;
import java.sql.Date;

public class DeliveryFee {
    private Integer feeId;
    private Integer zoneId;
    private String feeType;
    private BigDecimal feeValue;
    private BigDecimal minOrderAmount;
    private BigDecimal maxOrderAmount;
    private Boolean isActive;
    private Date createdAt;

    public DeliveryFee() {
    }

    public DeliveryFee(Integer feeId, Integer zoneId, String feeType, BigDecimal feeValue,
                       BigDecimal minOrderAmount, BigDecimal maxOrderAmount, 
                       Boolean isActive, Date createdAt) {
        this.feeId = feeId;
        this.zoneId = zoneId;
        this.feeType = feeType;
        this.feeValue = feeValue;
        this.minOrderAmount = minOrderAmount;
        this.maxOrderAmount = maxOrderAmount;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }

    public Integer getFeeId() {
        return feeId;
    }

    public void setFeeId(Integer feeId) {
        this.feeId = feeId;
    }

    public Integer getZoneId() {
        return zoneId;
    }

    public void setZoneId(Integer zoneId) {
        this.zoneId = zoneId;
    }

    public String getFeeType() {
        return feeType;
    }

    public void setFeeType(String feeType) {
        this.feeType = feeType;
    }

    public BigDecimal getFeeValue() {
        return feeValue;
    }

    public void setFeeValue(BigDecimal feeValue) {
        this.feeValue = feeValue;
    }

    public BigDecimal getMinOrderAmount() {
        return minOrderAmount;
    }

    public void setMinOrderAmount(BigDecimal minOrderAmount) {
        this.minOrderAmount = minOrderAmount;
    }

    public BigDecimal getMaxOrderAmount() {
        return maxOrderAmount;
    }

    public void setMaxOrderAmount(BigDecimal maxOrderAmount) {
        this.maxOrderAmount = maxOrderAmount;
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
        return "DeliveryFee{" +
                "feeId=" + feeId +
                ", zoneId=" + zoneId +
                ", feeType='" + feeType + '\'' +
                ", feeValue=" + feeValue +
                ", minOrderAmount=" + minOrderAmount +
                ", maxOrderAmount=" + maxOrderAmount +
                ", isActive=" + isActive +
                ", createdAt=" + createdAt +
                '}';
    }
}
