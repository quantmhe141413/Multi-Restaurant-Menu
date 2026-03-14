package models;

import java.math.BigDecimal;

public class MenuItemStat {
    private int itemId;
    private String itemName;
    private int totalSold;
    private BigDecimal totalRevenue;

    public MenuItemStat(int itemId, String itemName, int totalSold, BigDecimal totalRevenue) {
        this.itemId = itemId;
        this.itemName = itemName;
        this.totalSold = totalSold;
        this.totalRevenue = totalRevenue;
    }

    public int getItemId() {
        return itemId;
    }

    public String getItemName() {
        return itemName;
    }

    public int getTotalSold() {
        return totalSold;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }
}
