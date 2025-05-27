package com.shashi.beans;

import java.io.Serializable;

@SuppressWarnings("serial")
public class CartBean implements Serializable {

	public CartBean() {
	}

	public String userId;

	public String prodId;

	public int quantity;
	
	public String fabricid;

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getProdId() {
		return prodId;
	}

	public void setProdId(String prodId) {
		this.prodId = prodId;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	
	public String getFabricId() {
		return fabricid;
	}

	public void setFabricId(String fabricid) {
		this.fabricid = fabricid;
	}

	public CartBean(String userId, String prodId, int quantity, String fabricid) {
		super();
		this.userId = userId;
		this.prodId = prodId;
		this.quantity = quantity;
		this.fabricid=fabricid;
	}

}