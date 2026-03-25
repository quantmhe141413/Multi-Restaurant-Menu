package models;

import java.math.BigDecimal;

public class MenuItemStat {
    private int itemId;
    private String itemName;
    private int totalSold;
    private BigDecimal totalRevenue;

    public MenuItemStat() {
    }

    public MenuItemStat(int itemId, String itemName, int totalSold, BigDecimal totalRevenue) {
        this.itemId = itemId;
        this.itemName = itemName;
        this.totalSold = totalSold;
        this.totalRevenue = totalRevenue;
    }

    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public int getTotalSold() {
        return totalSold;
    }

    public void setTotalSold(int totalSold) {
        this.totalSold = totalSold;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }
}
