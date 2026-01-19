package models;

import java.sql.Timestamp;
import java.util.List;

public class BorrowSlip {
    private int slipId;
    private int readerId;
    private Integer librarianId; // nullable
    private Timestamp borrowDate;
    private Timestamp dueDate;
    private Timestamp returnDate;
    private String status; // borrowed, returned, overdue
    private String notes;
    
    // Additional fields for display
    private String readerName;
    private String readerCardNumber;
    private String librarianName; // for display
    private List<BorrowDetail> borrowDetails; // details list
    private int totalQuantity; // for per-book aggregation when needed
    private boolean finePaid; // whether overdue fine has been paid

    // Constructors
    public BorrowSlip() {
    }

    public BorrowSlip(int slipId, int readerId, Integer librarianId, Timestamp borrowDate, 
                      Timestamp dueDate, Timestamp returnDate, String status, String notes) {
        this.slipId = slipId;
        this.readerId = readerId;
        this.librarianId = librarianId;
        this.borrowDate = borrowDate;
        this.dueDate = dueDate;
        this.returnDate = returnDate;
        this.status = status;
        this.notes = notes;
    }

    // Getters and Setters
    public int getSlipId() {
        return slipId;
    }

    public void setSlipId(int slipId) {
        this.slipId = slipId;
    }

    public int getReaderId() {
        return readerId;
    }

    public void setReaderId(int readerId) {
        this.readerId = readerId;
    }

    public Integer getLibrarianId() {
        return librarianId;
    }

    public void setLibrarianId(Integer librarianId) {
        this.librarianId = librarianId;
    }

    public Timestamp getBorrowDate() {
        return borrowDate;
    }

    public void setBorrowDate(Timestamp borrowDate) {
        this.borrowDate = borrowDate;
    }

    public Timestamp getDueDate() {
        return dueDate;
    }

    public void setDueDate(Timestamp dueDate) {
        this.dueDate = dueDate;
    }

    public Timestamp getReturnDate() {
        return returnDate;
    }

    public void setReturnDate(Timestamp returnDate) {
        this.returnDate = returnDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getReaderName() {
        return readerName;
    }

    public void setReaderName(String readerName) {
        this.readerName = readerName;
    }

    public String getReaderCardNumber() {
        return readerCardNumber;
    }

    public void setReaderCardNumber(String readerCardNumber) {
        this.readerCardNumber = readerCardNumber;
    }

    public String getLibrarianName() {
        return librarianName;
    }

    public void setLibrarianName(String librarianName) {
        this.librarianName = librarianName;
    }

    public List<BorrowDetail> getBorrowDetails() {
        return borrowDetails;
    }

    public void setBorrowDetails(List<BorrowDetail> borrowDetails) {
        this.borrowDetails = borrowDetails;
    }

    public int getTotalQuantity() {
        return totalQuantity;
    }

    public void setTotalQuantity(int totalQuantity) {
        this.totalQuantity = totalQuantity;
    }

    public boolean isFinePaid() {
        return finePaid;
    }

    public void setFinePaid(boolean finePaid) {
        this.finePaid = finePaid;
    }

    // Helper methods
    public boolean isOverdue() {
        if (returnDate != null || dueDate == null) return false;
        return dueDate.before(new Timestamp(System.currentTimeMillis()));
    }

    public boolean isReturned() {
        return "returned".equalsIgnoreCase(status);
    }

    public boolean isBorrowed() {
        return "borrowed".equalsIgnoreCase(status);
    }

    @Override
    public String toString() {
        return "BorrowSlip{" +
                "slipId=" + slipId +
                ", readerId=" + readerId +
                ", status='" + status + '\'' +
                ", dueDate=" + dueDate +
                '}';
    }
}
