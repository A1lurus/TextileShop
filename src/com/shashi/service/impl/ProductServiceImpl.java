package com.shashi.service.impl;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.shashi.beans.DemandBean;
import com.shashi.beans.ProductBean;
import com.shashi.service.ProductService;
import com.shashi.utility.DBUtil;
import com.shashi.utility.IDUtil;
import com.shashi.utility.MailMessage;
import com.shashi.beans.SizeBean;

public class ProductServiceImpl implements ProductService {

    @Override
    public String addProduct(String prodName, String prodType, String prodInfo, double prodPrice, int prodQuantity,
            InputStream prodImage, String size, String fabricType) {
        String status = null;
        String prodId = IDUtil.generateId();

        ProductBean product = new ProductBean(prodId, prodName, prodType, prodInfo, prodPrice, prodQuantity, prodImage, false, size, fabricType);

        status = addProduct(product);

        return status;
    }

    @Override
    public String addProduct(ProductBean product) {
        String status = "Product Registration Failed!";

        if (product.getProdId() == null)
            product.setProdId(IDUtil.generateId());

        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;

        try {
            ps = con.prepareStatement("insert into product values(?,?,?,?,?,?,?,?,?,?)");
            ps.setString(1, product.getProdId());
            ps.setString(2, product.getProdName());
            ps.setString(3, product.getProdType());
            ps.setString(4, product.getProdInfo());
            ps.setDouble(5, product.getProdPrice());
            ps.setInt(6, product.getProdQuantity());
            ps.setBlob(7, product.getProdImage());
            ps.setBoolean(8, product.getHide());
            ps.setString(9, product.getSize());
            ps.setString(10, product.getFabricType());

            int k = ps.executeUpdate();

            if (k > 0) {
                status = "Product Added Successfully with Product Id: " + product.getProdId();
            }

        } catch (SQLException e) {
            status = "Error: " + e.getMessage();
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
        }

        return status;
    }

    // Додати цей метод до ProductServiceImpl.java
    public String getSizeNameById(String sizeId) {
        if (sizeId == null || sizeId.isEmpty()) {
            return "-";
        }
        
        SizeBean size = new SizeServiceImpl().getSizeDetails(sizeId);
        return size != null ? size.getSizeName() : sizeId; // Повертаємо назву або оригінальний ID, якщо розмір не знайдено
    }

    @Override
    public String removeProduct(String prodId) {
        String status = "Product Removal Failed!";

        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        PreparedStatement ps2 = null;

        try {
            ps = con.prepareStatement("delete from product where pid=?");
            ps.setString(1, prodId);

            int k = ps.executeUpdate();

            if (k > 0) {
                status = "Product Removed Successfully!";

                ps2 = con.prepareStatement("delete from usercart where prodid=?");
                ps2.setString(1, prodId);
                ps2.executeUpdate();
            }

        } catch (SQLException e) {
            status = "Error: " + e.getMessage();
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(ps2);
        }

        return status;
    }

    @Override
    public String updateProduct(ProductBean prevProduct, ProductBean updatedProduct) {
        String status = "Product Updation Failed!";

        if (!prevProduct.getProdId().equals(updatedProduct.getProdId())) {
            status = "Both Products are Different, Updation Failed!";
            return status;
        }

        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;

        try {
            ps = con.prepareStatement(
                    "update product set pname=?, ptype=?, pinfo=?, pprice=?, pquantity=?, image=?, hide=?, size=?, fabric_type=? where pid=?");

            ps.setString(1, updatedProduct.getProdName());
            ps.setString(2, updatedProduct.getProdType());
            ps.setString(3, updatedProduct.getProdInfo());
            ps.setDouble(4, updatedProduct.getProdPrice());
            ps.setInt(5, updatedProduct.getProdQuantity());
            ps.setBlob(6, updatedProduct.getProdImage());
            ps.setBoolean(7, updatedProduct.getHide());
            ps.setString(8, updatedProduct.getSize());
            ps.setString(9, updatedProduct.getFabricType());
            ps.setString(10, prevProduct.getProdId());

            int k = ps.executeUpdate();

            if (k > 0)
                status = "Product Updated Successfully!";

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
        }

        return status;
    }

    @Override
    public List<ProductBean> getAllProducts() {
        List<ProductBean> products = new ArrayList<>();
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            ps = con.prepareStatement("select * from product where hide = false");
            rs = ps.executeQuery();

            while (rs.next()) {
                ProductBean product = new ProductBean();
                product.setProdId(rs.getString("pid"));
                product.setProdName(rs.getString("pname"));
                product.setProdType(rs.getString("ptype"));
                product.setProdInfo(rs.getString("pinfo"));
                product.setProdPrice(rs.getDouble("pprice"));
                product.setProdQuantity(rs.getInt("pquantity"));
                product.setProdImage(rs.getAsciiStream("image"));
                product.setHide(rs.getBoolean("hide"));
                product.setSize(rs.getString("size"));
                product.setFabricType(rs.getString("fabric_type"));
                products.add(product);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(rs);
        }

        return products;
    }
    
    @Override
    public List<ProductBean> getAllProductsadmin() {
        List<ProductBean> products = new ArrayList<>();
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            ps = con.prepareStatement("select * from product");
            rs = ps.executeQuery();

            while (rs.next()) {
                ProductBean product = new ProductBean();
                product.setProdId(rs.getString("pid"));
                product.setProdName(rs.getString("pname"));
                product.setProdType(rs.getString("ptype"));
                product.setProdInfo(rs.getString("pinfo"));
                product.setProdPrice(rs.getDouble("pprice"));
                product.setProdQuantity(rs.getInt("pquantity"));
                product.setProdImage(rs.getAsciiStream("image"));
                product.setHide(rs.getBoolean("hide"));
                product.setSize(rs.getString("size"));
                product.setFabricType(rs.getString("fabric_type"));
                products.add(product);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(rs);
        }

        return products;
    }
    
    @Override
    public List<String> getAllProductTypes() {
        List<String> categories = new ArrayList<>();
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            ps = con.prepareStatement("SELECT DISTINCT ptype FROM product WHERE hide = false ORDER BY ptype");
            rs = ps.executeQuery();

            while (rs.next()) {
                categories.add(rs.getString("ptype"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(rs);
        }

        return categories;
    }

    @Override
    public List<ProductBean> getAllProductsByType(String type) {
        List<ProductBean> products = new ArrayList<>();
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            ps = con.prepareStatement("SELECT * FROM product WHERE lower(ptype) like ? and hide = false");
            ps.setString(1, "%" + type.toLowerCase() + "%");
            rs = ps.executeQuery();

            while (rs.next()) {
                ProductBean product = new ProductBean();
                product.setProdId(rs.getString("pid"));
                product.setProdName(rs.getString("pname"));
                product.setProdType(rs.getString("ptype"));
                product.setProdInfo(rs.getString("pinfo"));
                product.setProdPrice(rs.getDouble("pprice"));
                product.setProdQuantity(rs.getInt("pquantity"));
                product.setProdImage(rs.getAsciiStream("image"));
                product.setHide(rs.getBoolean("hide"));
                product.setSize(rs.getString("size"));
                product.setFabricType(rs.getString("fabric_type"));
                products.add(product);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(rs);
        }

        return products;
    }

    @Override
    public List<ProductBean> searchAllProducts(String search) {
        List<ProductBean> products = new ArrayList<>();
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            ps = con.prepareStatement(
                    "SELECT * FROM product WHERE (lower(ptype) like ? OR lower(pname) like ? OR lower(pinfo) like ?) AND hide = false");
            search = "%" + search.toLowerCase() + "%";
            ps.setString(1, search);
            ps.setString(2, search);
            ps.setString(3, search);
            rs = ps.executeQuery();

            while (rs.next()) {
                ProductBean product = new ProductBean();
                product.setProdId(rs.getString("pid"));
                product.setProdName(rs.getString("pname"));
                product.setProdType(rs.getString("ptype"));
                product.setProdInfo(rs.getString("pinfo"));
                product.setProdPrice(rs.getDouble("pprice"));
                product.setProdQuantity(rs.getInt("pquantity"));
                product.setProdImage(rs.getAsciiStream("image"));
                product.setHide(rs.getBoolean("hide"));
                product.setSize(rs.getString("size"));
                product.setFabricType(rs.getString("fabric_type"));
                products.add(product);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(rs);
        }

        return products;
    }

    @Override
    public byte[] getImage(String prodId) {
        byte[] image = null;
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            ps = con.prepareStatement("select image from product where pid=?");
            ps.setString(1, prodId);
            rs = ps.executeQuery();

            if (rs.next())
                image = rs.getBytes("image");

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(rs);
        }

        return image;
    }

    @Override
    public ProductBean getProductDetails(String prodId) {
        ProductBean product = null;
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            ps = con.prepareStatement("select * from product where pid=?");
            ps.setString(1, prodId);
            rs = ps.executeQuery();

            if (rs.next()) {
                product = new ProductBean();
                product.setProdId(rs.getString("pid"));
                product.setProdName(rs.getString("pname"));
                product.setProdType(rs.getString("ptype"));
                product.setProdInfo(rs.getString("pinfo"));
                product.setProdPrice(rs.getDouble("pprice"));
                product.setProdQuantity(rs.getInt("pquantity"));
                product.setProdImage(rs.getAsciiStream("image"));
                product.setHide(rs.getBoolean("hide"));
                product.setSize(rs.getString("size"));
                product.setFabricType(rs.getString("fabric_type"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(rs);
        }

        return product;
    }

    @Override
    public String updateProductWithoutImage(String prevProductId, ProductBean updatedProduct) {
        String status = "Product Updation Failed!";

        if (!prevProductId.equals(updatedProduct.getProdId())) {
            status = "Both Products are Different, Updation Failed!";
            return status;
        }

        int prevQuantity = getProductQuantity(prevProductId);
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;

        try {
            ps = con.prepareStatement(
                    "update product set pname=?, ptype=?, pinfo=?, pprice=?, pquantity=?, hide=?, size=?, fabric_type=? where pid=?");

            ps.setString(1, updatedProduct.getProdName());
            ps.setString(2, updatedProduct.getProdType());
            ps.setString(3, updatedProduct.getProdInfo());
            ps.setDouble(4, updatedProduct.getProdPrice());
            ps.setInt(5, updatedProduct.getProdQuantity());
            ps.setBoolean(6, updatedProduct.getHide());
            ps.setString(7, updatedProduct.getSize());
            ps.setString(8, updatedProduct.getFabricType());
            ps.setString(9, prevProductId);

            int k = ps.executeUpdate();

            if ((k > 0) && (prevQuantity < updatedProduct.getProdQuantity())) {
                status = "Product Updated Successfully!";
                List<DemandBean> demandList = new DemandServiceImpl().haveDemanded(prevProductId);

                for (DemandBean demand : demandList) {
                    String userFName = new UserServiceImpl().getFName(demand.getUserName());
                    try {
                        MailMessage.productAvailableNow(demand.getUserName(), userFName, 
                            updatedProduct.getProdName(), prevProductId);
                    } catch (Exception e) {
                        System.out.println("Mail Sending Failed: " + e.getMessage());
                    }
                    boolean flag = new DemandServiceImpl().removeProduct(demand.getUserName(), prevProductId);

                    if (flag)
                        status += " And Mail Send to the customers who were waiting for this product!";
                }
            } else if (k > 0) {
                status = "Product Updated Successfully!";
            } else {
                status = "Product Not available in the store!";
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
        }

        return status;
    }

    @Override
    public double getProductPrice(String prodId) {
        double price = 0;
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            ps = con.prepareStatement("select pprice from product where pid=?");
            ps.setString(1, prodId);
            rs = ps.executeQuery();

            if (rs.next()) {
                price = rs.getDouble("pprice");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(rs);
        }

        return price;
    }

    @Override
    public boolean sellNProduct(String prodId, int n) {
        boolean flag = false;
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;

        try {
            ps = con.prepareStatement("update product set pquantity=(pquantity - ?) where pid=?");

            ps.setInt(1, n);
            ps.setString(2, prodId);

            int k = ps.executeUpdate();
            flag = k > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
        }

        return flag;
    }

    @Override
    public int getProductQuantity(String prodId) {
        int quantity = 0;
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            ps = con.prepareStatement("select pquantity from product where pid=?");
            ps.setString(1, prodId);
            rs = ps.executeQuery();

            if (rs.next()) {
                quantity = rs.getInt("pquantity");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(rs);
        }

        return quantity;
    }
    @Override
    public boolean updateProductQty(String prodId, int qtyToAdd) {
        Connection con = null;
        PreparedStatement ps = null;
        boolean updated = false;

        try {
            con = DBUtil.provideConnection();
            String query = "UPDATE product SET pquantity = pquantity + ? WHERE pid = ?"; // Використовуємо pquantity
            ps = con.prepareStatement(query);
            ps.setInt(1, qtyToAdd);
            ps.setString(2, prodId);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                updated = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Тут також можна додати логування помилок для налагодження
        } finally {
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(con);
        }
        return updated;
    }
}