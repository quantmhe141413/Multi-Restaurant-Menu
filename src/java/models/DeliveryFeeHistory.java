package models;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class DeliveryFeeHistory {
    private Integer historyId;
    private Integer feeId;
    private String oldFeeType;
    private String newFeeType;
    private BigDecimal oldFeeValue;
    private BigDecimal newFeeValue;
    private BigDecimal oldMinOrder;
    private BigDecimal newMinOrder;
    private BigDecimal oldMaxOrder;
    private BigDecimal newMaxOrder;
    private Timestamp changedAt;
    private Integer changedBy;
    private String changedByName; // for display

    public DeliveryFeeHistory() {
    }

    public Integer getHistoryId() { return historyId; }
    public void setHistoryId(Integer historyId) { this.historyId = historyId; }

    public Integer getFeeId() { return feeId; }
    public void setFeeId(Integer feeId) { this.feeId = feeId; }

    public String getOldFeeType() { return oldFeeType; }
    public void setOldFeeType(String oldFeeType) { this.oldFeeType = oldFeeType; }

    public String getNewFeeType() { return newFeeType; }
    public void setNewFeeType(String newFeeType) { this.newFeeType = newFeeType; }

    public BigDecimal getOldFeeValue() { return oldFeeValue; }
    public void setOldFeeValue(BigDecimal oldFeeValue) { this.oldFeeValue = oldFeeValue; }

    public BigDecimal getNewFeeValue() { return newFeeValue; }
    public void setNewFeeValue(BigDecimal newFeeValue) { this.newFeeValue = newFeeValue; }

    public BigDecimal getOldMinOrder() { return oldMinOrder; }
    public void setOldMinOrder(BigDecimal oldMinOrder) { this.oldMinOrder = oldMinOrder; }

    public BigDecimal getNewMinOrder() { return newMinOrder; }
    public void setNewMinOrder(BigDecimal newMinOrder) { this.newMinOrder = newMinOrder; }

    public BigDecimal getOldMaxOrder() { return oldMaxOrder; }
    public void setOldMaxOrder(BigDecimal oldMaxOrder) { this.oldMaxOrder = oldMaxOrder; }

    public BigDecimal getNewMaxOrder() { return newMaxOrder; }
    public void setNewMaxOrder(BigDecimal newMaxOrder) { this.newMaxOrder = newMaxOrder; }

    public Timestamp getChangedAt() { return changedAt; }
    public void setChangedAt(Timestamp changedAt) { this.changedAt = changedAt; }

    public Integer getChangedBy() { return changedBy; }
    public void setChangedBy(Integer changedBy) { this.changedBy = changedBy; }

    public String getChangedByName() { return changedByName; }
    public void setChangedByName(String changedByName) { this.changedByName = changedByName; }
}
