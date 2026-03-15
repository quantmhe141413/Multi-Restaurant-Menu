package models;

import java.sql.Timestamp;

public class PaymentTransaction {
    private int paymentID;
    private int orderID;
    private int customerID;
    private String paymentType;
    private String txnRef;
    private long amount;
    private String bankCode;
    private String cardType;
    private String payDate;
    private String responseCode;
    private String transactionNo;
    private String transactionStatus;
    private String secureHash;
    private String paymentStatus;
    private Timestamp paidAt;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public PaymentTransaction() {
    }

    public PaymentTransaction(int paymentID, int orderID, int customerID, String paymentType,
                             String txnRef, long amount, String bankCode, String cardType, String payDate,
                             String responseCode, String transactionNo, String transactionStatus,
                             String secureHash, String paymentStatus, Timestamp paidAt,
                             Timestamp createdAt, Timestamp updatedAt) {
        this.paymentID = paymentID;
        this.orderID = orderID;
        this.customerID = customerID;
        this.paymentType = paymentType;
        this.txnRef = txnRef;
        this.amount = amount;
        this.bankCode = bankCode;
        this.cardType = cardType;
        this.payDate = payDate;
        this.responseCode = responseCode;
        this.transactionNo = transactionNo;
        this.transactionStatus = transactionStatus;
        this.secureHash = secureHash;
        this.paymentStatus = paymentStatus;
        this.paidAt = paidAt;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getPaymentID() {
        return paymentID;
    }

    public void setPaymentID(int paymentID) {
        this.paymentID = paymentID;
    }

    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public String getPaymentType() {
        return paymentType;
    }

    public void setPaymentType(String paymentType) {
        this.paymentType = paymentType;
    }

    public String getTxnRef() {
        return txnRef;
    }

    public void setTxnRef(String txnRef) {
        this.txnRef = txnRef;
    }

    public long getAmount() {
        return amount;
    }

    public void setAmount(long amount) {
        this.amount = amount;
    }

    public String getBankCode() {
        return bankCode;
    }

    public void setBankCode(String bankCode) {
        this.bankCode = bankCode;
    }

    public String getCardType() {
        return cardType;
    }

    public void setCardType(String cardType) {
        this.cardType = cardType;
    }

    public String getPayDate() {
        return payDate;
    }

    public void setPayDate(String payDate) {
        this.payDate = payDate;
    }

    public String getResponseCode() {
        return responseCode;
    }

    public void setResponseCode(String responseCode) {
        this.responseCode = responseCode;
    }

    public String getTransactionNo() {
        return transactionNo;
    }

    public void setTransactionNo(String transactionNo) {
        this.transactionNo = transactionNo;
    }

    public String getTransactionStatus() {
        return transactionStatus;
    }

    public void setTransactionStatus(String transactionStatus) {
        this.transactionStatus = transactionStatus;
    }

    public String getSecureHash() {
        return secureHash;
    }

    public void setSecureHash(String secureHash) {
        this.secureHash = secureHash;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public Timestamp getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(Timestamp paidAt) {
        this.paidAt = paidAt;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "PaymentTransaction{" +
                "paymentID=" + paymentID +
                ", orderID=" + orderID +
                ", customerID=" + customerID +
                ", paymentType='" + paymentType + '\'' +
                ", txnRef='" + txnRef + '\'' +
                ", amount=" + amount +
                ", paymentStatus='" + paymentStatus + '\'' +
                ", responseCode='" + responseCode + '\'' +
                '}';
    }
}
