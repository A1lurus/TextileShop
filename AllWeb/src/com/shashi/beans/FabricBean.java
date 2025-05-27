package com.shashi.beans;

import java.io.InputStream;
import java.io.Serializable;

@SuppressWarnings("serial")
public class FabricBean implements Serializable {

    public FabricBean() {
    }

    private String fabricId;
    private String fabricTypeName;
    private String color;
    private InputStream image;
    
    // Конструктори
    public FabricBean(String fabricId, String fabricTypeName, String color, 
                     InputStream image) { // Updated constructor
        this.fabricId = fabricId;
        this.fabricTypeName = fabricTypeName;
        this.color = color;
        this.image = image;
    }
    
    // Геттери та сеттери
    public String getFabricId() {
        return fabricId;
    }

    public void setFabricId(String fabricId) {
        this.fabricId = fabricId;
    }

    public String getFabricTypeName() {
        return fabricTypeName;
    }

    public void setFabricTypeName(String fabricTypeName) {
        this.fabricTypeName = fabricTypeName;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public InputStream getImage() {
        return image;
    }

    public void setImage(InputStream image) {
        this.image = image;
    }

    @Override
    public String toString() {
        return "FabricBean [fabricId=" + fabricId + ", fabricTypeName=" + fabricTypeName + ", color=" + color
                + ", image=" + image + "]";
    }
}