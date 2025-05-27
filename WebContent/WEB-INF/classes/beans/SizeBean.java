package com.shashi.beans;

import java.io.Serializable;
//import java.util.Objects;

public class SizeBean implements Serializable {
    private static final long serialVersionUID = 1L;

    private String sizeId;          // size_id VARCHAR(45)
    private String sizeName;        // size_name VARCHAR(50)
    private String productType;     // product_type VARCHAR(20) - припускаючи довжину
    private Double length;          // length DECIMAL(10,2)
    private Double width;           // width DECIMAL(10,2)

    // Конструктори
    public SizeBean() {}

    public SizeBean(String sizeId, String sizeName, String productType) {
        this.sizeId = sizeId;
        this.sizeName = sizeName;
        this.productType = productType;
    }

    public SizeBean(String sizeId, String sizeName, String productType, 
                   Double length, Double width) {
        this(sizeId, sizeName, productType);
        this.length = length;
        this.width = width;
    }

    // Геттери та сеттери
    public String getSizeId() {
        return sizeId;
    }

    public void setSizeId(String sizeId) {
        this.sizeId = sizeId;
    }

    public String getSizeName() {
        return sizeName;
    }

    public void setSizeName(String sizeName) {
        this.sizeName = sizeName;
    }

    public String getProductType() {
        return productType;
    }

    public void setProductType(String productType) {
        this.productType = productType;
    }

    public Double getLength() {
        return length;
    }

    public void setLength(Double length) {
        this.length = length;
    }

    public Double getWidth() {
        return width;
    }

    public void setWidth(Double width) {
        this.width = width;
    }

    @Override
    public String toString() {
        return "SizeBean{" +
                "sizeId='" + sizeId + '\'' +
                ", sizeName='" + sizeName + '\'' +
                ", productType='" + productType + '\'' +
                ", length=" + length +
                ", width=" + width +
                '}';
    }
}