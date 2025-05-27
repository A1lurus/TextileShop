package com.shashi.service.impl;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.shashi.beans.CartBean;
import com.shashi.beans.DemandBean;
import com.shashi.beans.ProductBean;
import com.shashi.service.CartService;
import com.shashi.utility.DBUtil;

public class CartServiceImpl implements CartService {

    @Override
    public String addProductToCart(String userId, String prodId, int prodQty, String fid) {
        String status = "Failed to Add into Cart";
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null, ps2 = null;
        ResultSet rs = null;

        try {
            ps = con.prepareStatement("select * from usercart where username=? and prodid=? and fid=?");
            ps.setString(1, userId);
            ps.setString(2, prodId);
            ps.setString(3, fid);
            rs = ps.executeQuery();

            if (rs.next()) {
                int cartQuantity = rs.getInt("quantity");
                ProductBean product = new ProductServiceImpl().getProductDetails(prodId);
                int availableQty = product.getProdQuantity();

                prodQty += cartQuantity;

                if (availableQty < prodQty) {
                    status = updateProductToCart(userId, prodId, availableQty, fid);
                    status = "Only " + availableQty + " no of " + product.getProdName()
                            + " are available. Added only " + availableQty + " to your cart.";

                    DemandBean demandBean = new DemandBean(userId, product.getProdId(), prodQty - availableQty);
                    boolean flag = new DemandServiceImpl().addProduct(demandBean);

                    if (flag)
                        status += " We'll notify you when " + product.getProdName() + " is available.";
                } else {
                    status = updateProductToCart(userId, prodId, prodQty, fid);
                }
            } else {
                ps2 = con.prepareStatement("insert into usercart(username, prodid, quantity, fid) values(?,?,?,?)");
                ps2.setString(1, userId);
                ps2.setString(2, prodId);
                ps2.setInt(3, prodQty);
                ps2.setString(4, fid);

                int k = ps2.executeUpdate();
                if (k > 0)
                    status = "Product Successfully Added to Cart!";
            }
        } catch (SQLException e) {
            status = "Error: " + e.getMessage();
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(rs);
            DBUtil.closeConnection(ps2);
        }
        return status;
    }

    @Override
    public List<CartBean> getAllCartItems(String userId) {
        List<CartBean> items = new ArrayList<>();
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            ps = con.prepareStatement("select * from usercart where username=?");
            ps.setString(1, userId);
            rs = ps.executeQuery();

            while (rs.next()) {
                CartBean cart = new CartBean();
                cart.setUserId(rs.getString("username"));
                cart.setProdId(rs.getString("prodid"));
                cart.setQuantity(rs.getInt("quantity"));
                cart.setFabricId(rs.getString("fid"));
                items.add(cart);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(rs);
        }

        return items;
    }

    @Override
    public int getCartCount(String userId) {
        int count = 0;
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            ps = con.prepareStatement("select sum(quantity) from usercart where username=?");
            ps.setString(1, userId);
            rs = ps.executeQuery();

            if (rs.next() && !rs.wasNull())
                count = rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(rs);
        }
        return count;
    }

    @Override
    public String removeProductFromCart(String userId, String prodId, String fid) {
        String status = "Product Removal Failed";
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null, ps2 = null;
        ResultSet rs = null;

        try {
            ps = con.prepareStatement("select * from usercart where username=? and prodid=? and fid=?");
            ps.setString(1, userId);
            ps.setString(2, prodId);
            ps.setString(3, fid);
            rs = ps.executeQuery();

            if (rs.next()) {
                int prodQuantity = rs.getInt("quantity");
                prodQuantity -= 1;

                if (prodQuantity > 0) {
                    ps2 = con.prepareStatement("update usercart set quantity=? where username=? and prodid=? and fid=?");
                    ps2.setInt(1, prodQuantity);
                    ps2.setString(2, userId);
                    ps2.setString(3, prodId);
                    ps2.setString(4, fid);

                    int k = ps2.executeUpdate();
                    if (k > 0)
                        status = "Product Successfully removed from the Cart!";
                } else {
                    ps2 = con.prepareStatement("delete from usercart where username=? and prodid=? and fid=?");
                    ps2.setString(1, userId);
                    ps2.setString(2, prodId);
                    ps2.setString(3, fid);

                    int k = ps2.executeUpdate();
                    if (k > 0)
                        status = "Product Successfully removed from the Cart!";
                }
            } else {
                status = "Product Not Available in the cart!";
            }
        } catch (SQLException e) {
            status = "Error: " + e.getMessage();
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(rs);
            DBUtil.closeConnection(ps2);
        }

        return status;
    }

    @Override
    public boolean removeAProduct(String userId, String prodId, String fid) {
        boolean flag = false;
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;

        try {
            ps = con.prepareStatement("delete from usercart where username=? and prodid=? and fid=?");
            ps.setString(1, userId);
            ps.setString(2, prodId);
            ps.setString(3, fid);

            int k = ps.executeUpdate();
            if (k > 0)
                flag = true;
        } catch (SQLException e) {
            flag = false;
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
        }

        return flag;
    }

    @Override
    public String updateProductToCart(String userId, String prodId, int prodQty, String fid) {
        String status = "Failed to Add into Cart";
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null, ps2 = null;
        ResultSet rs = null;

        try {
            ps = con.prepareStatement("select * from usercart where username=? and prodid=? and fid=?");
            ps.setString(1, userId);
            ps.setString(2, prodId);
            ps.setString(3, fid);
            rs = ps.executeQuery();

            if (rs.next()) {
                if (prodQty > 0) {
                    ps2 = con.prepareStatement("update usercart set quantity=? where username=? and prodid=? and fid=?");
                    ps2.setInt(1, prodQty);
                    ps2.setString(2, userId);
                    ps2.setString(3, prodId);
                    ps2.setString(4, fid);

                    int k = ps2.executeUpdate();
                    if (k > 0)
                        status = "Product Successfully Updated to Cart!";
                } else if (prodQty == 0) {
                    ps2 = con.prepareStatement("delete from usercart where username=? and prodid=? and fid=?");
                    ps2.setString(1, userId);
                    ps2.setString(2, prodId);
                    ps2.setString(3, fid);

                    int k = ps2.executeUpdate();
                    if (k > 0)
                        status = "Product Successfully Updated in Cart!";
                }
            } else {
                ps2 = con.prepareStatement("insert into usercart(username, prodid, quantity, fid) values(?,?,?,?)");
                ps2.setString(1, userId);
                ps2.setString(2, prodId);
                ps2.setInt(3, prodQty);
                ps2.setString(4, fid);

                int k = ps2.executeUpdate();
                if (k > 0)
                    status = "Product Successfully Updated to Cart!";
            }
        } catch (SQLException e) {
            status = "Error: " + e.getMessage();
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(rs);
            DBUtil.closeConnection(ps2);
        }

        return status;
    }

    public int getProductCount(String userId, String prodId, String fid) {
        int count = 0;
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            ps = con.prepareStatement("select sum(quantity) from usercart where username=? and prodid=? and fid=?");
            ps.setString(1, userId);
            ps.setString(2, prodId);
            ps.setString(3, fid);
            rs = ps.executeQuery();

            if (rs.next() && !rs.wasNull())
                count = rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(rs);
        }

        return count;
    }

    @Override
    public int getCartItemCount(String userId, String itemId, String fid) {
        int count = 0;
        if (userId == null || itemId == null)
            return 0;

        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            ps = con.prepareStatement("select quantity from usercart where username=? and prodid=? and fid=?");
            ps.setString(1, userId);
            ps.setString(2, itemId);
            ps.setString(3, fid);
            rs = ps.executeQuery();

            if (rs.next() && !rs.wasNull())
                count = rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(rs);
        }

        return count;
    }
}
