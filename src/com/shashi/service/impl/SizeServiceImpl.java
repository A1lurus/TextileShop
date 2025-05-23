package com.shashi.service.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import com.shashi.beans.SizeBean;
import com.shashi.service.SizeService;
import com.shashi.utility.DBUtil;
import com.shashi.utility.IDUtil;

public class SizeServiceImpl implements SizeService {

	@Override
	public String addSize(String sizeName, String productType, Double length, Double width) {  // Змінити на Double
	    String sizeId = IDUtil.generateId();
	    SizeBean size = new SizeBean(sizeId, sizeName, productType, length, width);
	    return addSize(size);
	}

    @Override
    public String addSize(SizeBean size) {
        String status = "Size Addition Failed!";
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;

        try {
            ps = con.prepareStatement("INSERT INTO sizes VALUES(?,?,?,?,?)");
            ps.setString(1, size.getSizeId());
            ps.setString(2, size.getSizeName());
            ps.setString(3, size.getProductType());
            ps.setDouble(4, size.getLength());
            ps.setDouble(5, size.getWidth());

            int k = ps.executeUpdate();
            if (k > 0) {
                status = "Size Added Successfully with ID: " + size.getSizeId();
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

    @Override
    public String removeSize(String sizeId) {
        String status = "Size Removal Failed!";
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;

        try {
            ps = con.prepareStatement("DELETE FROM sizes WHERE size_id=?");
            ps.setString(1, sizeId);
            int k = ps.executeUpdate();
            if (k > 0) {
                status = "Size Removed Successfully!";
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

    @Override
    public String updateSize(SizeBean size) {
        String status = "Size Update Failed!";
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;

        try {
            ps = con.prepareStatement(
                "UPDATE sizes SET size_name=?, product_type=?, length=?, width=? WHERE size_id=?");
            
            ps.setString(1, size.getSizeName());
            ps.setString(2, size.getProductType());
            ps.setDouble(3, size.getLength());
            ps.setDouble(4, size.getWidth());
            ps.setString(5, size.getSizeId());

            int k = ps.executeUpdate();
            if (k > 0) {
                status = "Size Updated Successfully!";
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

    @Override
    public List<SizeBean> getAllSizes() {
        List<SizeBean> sizes = new ArrayList<>();
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            ps = con.prepareStatement("SELECT * FROM sizes");
            rs = ps.executeQuery();

            while (rs.next()) {
                SizeBean size = new SizeBean();
                size.setSizeId(rs.getString("size_id"));
                size.setSizeName(rs.getString("size_name"));
                size.setProductType(rs.getString("product_type"));
                size.setLength(rs.getDouble("length"));
                size.setWidth(rs.getDouble("width"));
                sizes.add(size);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(rs);
        }
        return sizes;
    }
    
    @Override
    public List<SizeBean> getSizesByProductType(String productType) {
        List<SizeBean> sizes = new ArrayList<>();
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            ps = con.prepareStatement("SELECT * FROM sizes WHERE product_type=?");
            ps.setString(1, productType);
            rs = ps.executeQuery();

            while (rs.next()) {
                SizeBean size = new SizeBean();
                size.setSizeId(rs.getString("size_id"));
                size.setSizeName(rs.getString("size_name"));
                size.setProductType(rs.getString("product_type"));
                size.setLength(rs.getDouble("length"));
                size.setWidth(rs.getDouble("width"));
                sizes.add(size);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(rs);
        }
        return sizes;
    }

    @Override
    public SizeBean getSizeDetails(String sizeId) {
        SizeBean size = null;
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            ps = con.prepareStatement("SELECT * FROM sizes WHERE size_id=?");
            ps.setString(1, sizeId);
            rs = ps.executeQuery();

            if (rs.next()) {
                size = new SizeBean();
                size.setSizeId(rs.getString("size_id"));
                size.setSizeName(rs.getString("size_name"));
                size.setProductType(rs.getString("product_type"));
                size.setLength(rs.getDouble("length"));
                size.setWidth(rs.getDouble("width"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(rs);
        }
        return size;
    }
}