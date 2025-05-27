package com.shashi.service;

import java.io.InputStream;
import java.util.List;

import com.shashi.beans.ProductBean;

public interface ProductService {

    public String addProduct(String prodName, String prodType, String prodInfo, double prodPrice, int prodQuantity,
            InputStream prodImage, String size, String fabricType);

    public String addProduct(ProductBean product);

    public String removeProduct(String prodId);

    public String updateProduct(ProductBean prevProduct, ProductBean updatedProduct);

    public String updateProductWithoutImage(String prevProductId, ProductBean updatedProduct);

    public List<ProductBean> getAllProducts();

    public List<ProductBean> getAllProductsadmin();

    public List<String> getAllProductTypes();

    public List<ProductBean> getAllProductsByType(String type);

    public List<ProductBean> searchAllProducts(String search);

    public byte[] getImage(String prodId);

    public ProductBean getProductDetails(String prodId);

    public double getProductPrice(String prodId);

    public boolean sellNProduct(String prodId, int n);

    public int getProductQuantity(String prodId);
    
    public String getSizeNameById(String sizeId);
    
    public boolean updateProductQty(String prodId, int qtyToAdd);
}