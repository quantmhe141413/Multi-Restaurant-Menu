package models;

public class TopDish {
    private int restaurantId;
    private int itemId;
    private String itemName;
    private int totalSold;

    public TopDish() {
    }

    public TopDish(int restaurantId, int itemId, String itemName, int totalSold) {
        this.restaurantId = restaurantId;
        this.itemId = itemId;
        this.itemName = itemName;
        this.totalSold = totalSold;
    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
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
}
