package models;

public class BorrowDetail {
    private int detailId;
    private int slipId;
    private int bookId;
    private int quantity;
    private boolean returned;
    
    // Additional fields for display
    private String bookTitle;
    private String bookAuthor;

    // Constructors
    public BorrowDetail() {
    }

    public BorrowDetail(int detailId, int slipId, int bookId, int quantity, boolean returned) {
        this.detailId = detailId;
        this.slipId = slipId;
        this.bookId = bookId;
        this.quantity = quantity;
        this.returned = returned;
    }

    // Getters and Setters
    public int getDetailId() {
        return detailId;
    }

    public void setDetailId(int detailId) {
        this.detailId = detailId;
    }

    public int getSlipId() {
        return slipId;
    }

    public void setSlipId(int slipId) {
        this.slipId = slipId;
    }

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public boolean isReturned() {
        return returned;
    }

    public void setReturned(boolean returned) {
        this.returned = returned;
    }

    public String getBookTitle() {
        return bookTitle;
    }

    public void setBookTitle(String bookTitle) {
        this.bookTitle = bookTitle;
    }

    public String getBookAuthor() {
        return bookAuthor;
    }

    public void setBookAuthor(String bookAuthor) {
        this.bookAuthor = bookAuthor;
    }

    @Override
    public String toString() {
        return "BorrowDetail{" +
                "detailId=" + detailId +
                ", bookId=" + bookId +
                ", quantity=" + quantity +
                ", returned=" + returned +
                '}';
    }
}
