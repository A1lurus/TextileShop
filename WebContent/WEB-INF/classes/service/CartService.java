package com.shashi.service;

import java.util.List;
import com.shashi.beans.CartBean;

public interface CartService {
    String addProductToCart(String userId, String prodId, int prodQty, String fid);

    List<CartBean> getAllCartItems(String userId);

    int getCartCount(String userId);

    String removeProductFromCart(String userId, String prodId, String fid);

    boolean removeAProduct(String userId, String prodId, String fid);

    String updateProductToCart(String userId, String prodId, int prodQty, String fid);

    int getProductCount(String userId, String prodId, String fid);

    int getCartItemCount(String userId, String itemId, String fid);
}
