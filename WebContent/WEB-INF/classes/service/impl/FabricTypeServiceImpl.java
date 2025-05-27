package com.shashi.service.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.shashi.beans.FabricTypeBean;
import com.shashi.service.FabricTypeService;
import com.shashi.utility.DBUtil;

public class FabricTypeServiceImpl implements FabricTypeService {

    @Override
    public String addFabricType(String fabricTypeName, double pricePerMeter) {
        String status = "Fabric Type Registration Failed!";
        
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;

        try {
            ps = con.prepareStatement("insert into fabric_types values(?,?)");
            ps.setString(1, fabricTypeName);
            ps.setDouble(2, pricePerMeter);

            int k = ps.executeUpdate();

            if (k > 0) {
                status = "Fabric Type Added Successfully!";
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
    public String removeFabricType(String fabricTypeName) {
        String status = "Fabric Type Removal Failed!";

        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;

        try {
            ps = con.prepareStatement("delete from fabric_types where fabric_type_name=?");
            ps.setString(1, fabricTypeName);

            int k = ps.executeUpdate();

            if (k > 0) {
                status = "Fabric Type Removed Successfully!";
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
    public String updateFabricType(String oldFabricTypeName, FabricTypeBean updatedFabricType) {
        String status = "Fabric Type Updation Failed!";

        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;

        try {
            ps = con.prepareStatement(
                    "update fabric_types set fabric_type_name=?, price_per_meter=? where fabric_type_name=?");

            ps.setString(1, updatedFabricType.getFabricTypeName());
            ps.setDouble(2, updatedFabricType.getPricePerMeter());
            ps.setString(3, oldFabricTypeName);

            int k = ps.executeUpdate();

            if (k > 0)
                status = "Fabric Type Updated Successfully!";

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
        }

        return status;
    }

    @Override
    public List<FabricTypeBean> getAllFabricTypes() {
        List<FabricTypeBean> fabricTypes = new ArrayList<>();
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            ps = con.prepareStatement("select * from fabric_types");
            rs = ps.executeQuery();

            while (rs.next()) {
                FabricTypeBean fabricType = new FabricTypeBean();
                fabricType.setFabricTypeName(rs.getString("fabric_type_name"));
                fabricType.setPricePerMeter(rs.getDouble("price_per_meter"));
                fabricTypes.add(fabricType);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(rs);
        }

        return fabricTypes;
    }

    @Override
    public FabricTypeBean getFabricTypeDetails(String fabricTypeName) {
        FabricTypeBean fabricType = null;
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            ps = con.prepareStatement("select * from fabric_types where fabric_type_name=?");
            ps.setString(1, fabricTypeName);
            rs = ps.executeQuery();

            if (rs.next()) {
                fabricType = new FabricTypeBean();
                fabricType.setFabricTypeName(rs.getString("fabric_type_name"));
                fabricType.setPricePerMeter(rs.getDouble("price_per_meter"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(rs);
        }

        return fabricType;
    }

    @Override
    public double getPricePerMeter(String fabricTypeName) {
        double price = 0;
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            ps = con.prepareStatement("select price_per_meter from fabric_types where fabric_type_name=?");
            ps.setString(1, fabricTypeName);
            rs = ps.executeQuery();

            if (rs.next()) {
                price = rs.getDouble("price_per_meter");
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
}