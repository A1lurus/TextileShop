package com.shashi.service.impl;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import com.shashi.beans.FabricBean;
import com.shashi.service.FabricService;
import com.shashi.utility.DBUtil;
import com.shashi.utility.IDUtil;

public class FabricServiceImpl implements FabricService {

    @Override
    public String addFabric(String fabricTypeName, String color, InputStream image) { 
        // ОНОВЛЕНО: Генеруємо ID та додаємо префікс "F"
        String fabricId = "F" + IDUtil.generateId(); 
        FabricBean fabric = new FabricBean(fabricId, fabricTypeName, color, image); 
        return addFabric(fabric);
    }

    @Override
    public String addFabric(FabricBean fabric) {
        String status = "Fabric Addition Failed!";
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;

        try {
            // ОНОВЛЕНО: Перевіряємо, чи ID вже має префікс "F", якщо ні - додаємо.
            // Це забезпечує, що якщо FabricBean створюється напряму без виклику першого addFabric,
            // ID все одно буде мати правильний формат.
            if (fabric.getFabricId() == null || !fabric.getFabricId().startsWith("F")) {
                fabric.setFabricId("F" + IDUtil.generateId());
            }

            // Змінено: тепер 4 знаки питання замість 5, оскільки available_meters видалено
            ps = con.prepareStatement("INSERT INTO fabrics VALUES(?,?,?,?)"); 
            ps.setString(1, fabric.getFabricId());
            ps.setString(2, fabric.getFabricTypeName());
            ps.setString(3, fabric.getColor());
            ps.setBlob(4, fabric.getImage()); 

            int k = ps.executeUpdate();
            if (k > 0) {
                status = "Fabric Added Successfully with ID: " + fabric.getFabricId();
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
    public String removeFabric(String fabricId) {
        String status = "Fabric Removal Failed!";
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;

        try {
            ps = con.prepareStatement("DELETE FROM fabrics WHERE fabric_id=?");
            ps.setString(1, fabricId);
            int k = ps.executeUpdate();
            if (k > 0) {
                status = "Fabric Removed Successfully!";
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
    public String updateFabric(FabricBean fabric) {
        String status = "Fabric Update Failed!";
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;

        try {
            // Змінено: available_meters видалено з UPDATE запиту
            ps = con.prepareStatement(
                "UPDATE fabrics SET fabric_type_name=?, color=?, image=? WHERE fabric_id=?"); 
            
            ps.setString(1, fabric.getFabricTypeName());
            ps.setString(2, fabric.getColor());
            ps.setBlob(3, fabric.getImage()); 
            ps.setString(4, fabric.getFabricId()); 

            int k = ps.executeUpdate();
            if (k > 0) {
                status = "Fabric Updated Successfully!";
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
    public List<FabricBean> getAllFabrics() {
        List<FabricBean> fabrics = new ArrayList<>();
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            ps = con.prepareStatement("SELECT * FROM fabrics");
            rs = ps.executeQuery();

            while (rs.next()) {
                FabricBean fabric = new FabricBean();
                fabric.setFabricId(rs.getString("fabric_id"));
                fabric.setFabricTypeName(rs.getString("fabric_type_name"));
                fabric.setColor(rs.getString("color"));
                // fabric.setAvailableMeters(rs.getDouble("available_meters")); // available_meters видалено
                fabric.setImage(rs.getBinaryStream("image"));
                fabrics.add(fabric);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(rs);
        }
        return fabrics;
    }

    @Override
    public FabricBean getFabricDetails(String fabricId) {
        FabricBean fabric = null;
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            ps = con.prepareStatement("SELECT * FROM fabrics WHERE fabric_id=?");
            ps.setString(1, fabricId);
            rs = ps.executeQuery();

            if (rs.next()) {
                fabric = new FabricBean();
                fabric.setFabricId(rs.getString("fabric_id"));
                fabric.setFabricTypeName(rs.getString("fabric_type_name"));
                fabric.setColor(rs.getString("color"));
                // fabric.setAvailableMeters(rs.getDouble("available_meters")); // available_meters видалено
                fabric.setImage(rs.getBinaryStream("image"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(rs);
        }
        return fabric;
    }

    @Override
    public byte[] getFabricImage(String fabricId) {
        byte[] image = null;
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            ps = con.prepareStatement("SELECT image FROM fabrics WHERE fabric_id=?");
            ps.setString(1, fabricId);
            rs = ps.executeQuery();

            if (rs.next()) {
                image = rs.getBytes("image");
            }
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
    public List<FabricBean> getFabricsByType(String fabricType) {
        List<FabricBean> fabrics = new ArrayList<>();
        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            ps = con.prepareStatement("SELECT * FROM fabrics WHERE fabric_type_name = ?");
            ps.setString(1, fabricType);
            rs = ps.executeQuery();

            while (rs.next()) {
                FabricBean fabric = new FabricBean();
                fabric.setFabricId(rs.getString("fabric_id"));
                fabric.setFabricTypeName(rs.getString("fabric_type_name"));
                fabric.setColor(rs.getString("color"));
                // fabric.setAvailableMeters(rs.getDouble("available_meters")); // available_meters видалено
                fabric.setImage(rs.getBinaryStream("image"));
                fabrics.add(fabric);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(con);
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(rs);
        }

        return fabrics;
    }
}
