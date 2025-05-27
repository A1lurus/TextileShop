package com.shashi.beans;

import java.io.Serializable;

@SuppressWarnings("serial")
public class FabricTypeBean implements Serializable {

    public FabricTypeBean() {
    }

    private String fabricTypeName;
    private double pricePerMeter;
    
    // Конструктори
    public FabricTypeBean(String fabricTypeName, double pricePerMeter) {
        this.fabricTypeName = fabricTypeName;
        this.pricePerMeter = pricePerMeter;
    }
    
    // Геттери та сеттери
    public String getFabricTypeName() {
        return fabricTypeName;
    }

    public void setFabricTypeName(String fabricTypeName) {
        this.fabricTypeName = fabricTypeName;
    }

    public double getPricePerMeter() {
        return pricePerMeter;
    }

    public void setPricePerMeter(double pricePerMeter) {
        this.pricePerMeter = pricePerMeter;
    }
}