package models;

public class TopDish {
    private int restaurantId;
    private int itemId;
    private String itemName;
    private int totalSold;

    public TopDish(int restaurantId, int itemId, String itemName, int totalSold) {
        this.restaurantId = restaurantId;
        this.itemId = itemId;
        this.itemName = itemName;
        this.totalSold = totalSold;
    }

    public int getRestaurantId() {
        return restaurantId;
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
}
