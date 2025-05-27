package com.shashi.beans;

import java.io.Serializable;

@SuppressWarnings("serial")
public class OrderBean implements Serializable {

    private String transactionId;  // залишено як є
    private String productId;
    private int quantity;
    private Double amount;
    private int shipped;
    private String fabricId;       // додано

    public OrderBean() {
        super();
    }

    public OrderBean(String transactionId, String productId, int quantity, Double amount, String fabricId) {
        super();
        this.transactionId = transactionId;
        this.productId = productId;
        this.quantity = quantity;
        this.amount = amount;
        this.shipped = 0;
        this.fabricId = fabricId;
    }

    public OrderBean(String transactionId, String productId, int quantity, Double amount, int shipped, String fabricId) {
        super();
        this.transactionId = transactionId;
        this.productId = productId;
        this.quantity = quantity;
        this.amount = amount;
        this.shipped = shipped;
        this.fabricId = fabricId;
    }

    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Double getAmount() {
        return amount;
    }

    public void setAmount(Double amount) {
        this.amount = amount;
    }

    public int getShipped() {
        return shipped;
    }

    public void setShipped(int shipped) {
        this.shipped = shipped;
    }

    public String getFabricId() {
        return fabricId;
    }

    public void setFabricId(String fabricId) {
        this.fabricId = fabricId;
    }
}
