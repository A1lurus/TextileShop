package com.shashi.service.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.shashi.beans.CartBean;
import com.shashi.beans.OrderBean;
import com.shashi.beans.OrderDetails;
import com.shashi.beans.TransactionBean;
import com.shashi.service.OrderService;
import com.shashi.utility.DBUtil;
import com.shashi.utility.MailMessage;

public class OrderServiceImpl implements OrderService {

    @Override
    public String paymentSuccess(String userName, double paidAmount) {
        String status = "Order Placement Failed!";

        List<CartBean> cartItems = new ArrayList<CartBean>();
        cartItems = new CartServiceImpl().getAllCartItems(userName);

        if (cartItems.size() == 0)
            return status;

        TransactionBean transaction = new TransactionBean(userName, paidAmount);
        boolean ordered = false;

        String transactionId = transaction.getTransactionId();

        for (CartBean item : cartItems) {

            double amount = new ProductServiceImpl().getProductPrice(item.getProdId()) * item.getQuantity();

            // При створенні нового замовлення, shipped за замовчуванням 0
            OrderBean order = new OrderBean(transactionId, item.getProdId(), item.getQuantity(), amount, 0, item.getFabricId());

            ordered = addOrder(order);
            if (!ordered)
                break;
            else {
                ordered = new CartServiceImpl().removeAProduct(item.getUserId(), item.getProdId(), item.getFabricId());
            }

            if (!ordered)
                break;
            else
                ordered = new ProductServiceImpl().sellNProduct(item.getProdId(), item.getQuantity());

            if (!ordered)
                break;
        }

        if (ordered) {
            ordered = new OrderServiceImpl().addTransaction(transaction);
            if (ordered) {

                MailMessage.transactionSuccess(userName, new UserServiceImpl().getFName(userName),
                        transaction.getTransactionId(), transaction.getTransAmount());

                status = "Order Placed Successfully!";
            }
        }

        return status;
    }

    @Override
    public boolean addOrder(OrderBean order) {
        boolean flag = false;

        Connection con = DBUtil.provideConnection();

        PreparedStatement ps = null;

        try {
            ps = con.prepareStatement("insert into orders values(?,?,?,?,?,?)");

            ps.setString(1, order.getTransactionId());
            ps.setString(2, order.getProductId());
            ps.setInt(3, order.getQuantity());
            ps.setDouble(4, order.getAmount());
            // Встановлюємо shipped як 0 за замовчуванням для нових замовлень
            ps.setInt(5, 0);
            ps.setString(6, order.getFabricId());

            int k = ps.executeUpdate();

            if (k > 0)
                flag = true;

        } catch (SQLException e) {
            flag = false;
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(con);
        }

        return flag;
    }

    @Override
    public boolean addTransaction(TransactionBean transaction) {
        boolean flag = false;

        Connection con = DBUtil.provideConnection();

        PreparedStatement ps = null;

        try {
            ps = con.prepareStatement("insert into transactions values(?,?,?,?)");

            ps.setString(1, transaction.getTransactionId());
            ps.setString(2, transaction.getUserName());
            ps.setTimestamp(3, transaction.getTransDateTime());
            ps.setDouble(4, transaction.getTransAmount());

            int k = ps.executeUpdate();

            if (k > 0)
                flag = true;

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(con);
        }

        return flag;
    }

    @Override
    public int countSoldItem(String prodId) {
        int count = 0;

        Connection con = DBUtil.provideConnection();

        PreparedStatement ps = null;

        ResultSet rs = null;

        try {
            ps = con.prepareStatement("select sum(quantity) from orders where prodid=?");

            ps.setString(1, prodId);

            rs = ps.executeQuery();

            if (rs.next())
                count = rs.getInt(1);

        } catch (SQLException e) {
            count = 0;
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(rs);
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(con);
        }

        return count;
    }

    @Override
    public List<OrderBean> getAllOrders() {
        List<OrderBean> orderList = new ArrayList<OrderBean>();

        Connection con = DBUtil.provideConnection();

        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            ps = con.prepareStatement("select * from orders");

            rs = ps.executeQuery();

            while (rs.next()) {
                // Зчитуємо shipped як int
                int shippedStatus = rs.getInt("shipped"); 
                
                OrderBean order = new OrderBean(rs.getString("orderid"), rs.getString("prodid"), rs.getInt("quantity"),
                        rs.getDouble("amount"), shippedStatus, rs.getString("fabricId"));

                orderList.add(order);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(rs);
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(con);
        }

        return orderList;
    }

    @Override
    public List<OrderBean> getOrdersByUserId(String emailId) {
        List<OrderBean> orderList = new ArrayList<OrderBean>();

        Connection con = DBUtil.provideConnection();

        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            ps = con.prepareStatement(
                    "SELECT o.orderid, o.prodid, o.quantity, o.amount, o.shipped, o.fabricId FROM orders o inner join transactions t on o.orderid = t.transid where t.username=?");
            ps.setString(1, emailId);
            rs = ps.executeQuery();

            while (rs.next()) {
                // Зчитуємо shipped як int
                int shippedStatus = rs.getInt("shipped");
                
                OrderBean order = new OrderBean(rs.getString("orderid"), rs.getString("prodid"),
                        rs.getInt("quantity"), rs.getDouble("amount"), shippedStatus, rs.getString("fabricId"));

                orderList.add(order);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(rs);
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(con);
        }

        return orderList;
    }

    @Override
    public List<OrderDetails> getAllOrderDetails(String userEmailId) {
        List<OrderDetails> orderList = new ArrayList<>();

        Connection con = DBUtil.provideConnection();

        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            ps = con.prepareStatement(
                "SELECT p.pid as prodid, o.orderid as orderid, o.shipped as shipped, p.image as image, " +
                "p.pname as pname, o.quantity as qty, o.amount as amount, t.time as time, o.fabricId as fabricId " +
                "FROM orders o, product p, transactions t " +
                "WHERE o.orderid = t.transid AND p.pid = o.prodid AND t.username = ?"
            );
            ps.setString(1, userEmailId);
            rs = ps.executeQuery();

            while (rs.next()) {
                OrderDetails order = new OrderDetails();
                order.setOrderId(rs.getString("orderid"));
                order.setProdImage(rs.getAsciiStream("image"));
                order.setProdName(rs.getString("pname"));
                order.setQty(rs.getString("qty"));
                order.setAmount(rs.getString("amount"));
                order.setTime(rs.getTimestamp("time"));
                order.setProductId(rs.getString("prodid"));
                
                // Зчитуємо shipped як int
                order.setShipped(rs.getInt("shipped")); 

                order.setFabricId(rs.getString("fabricId"));
                orderList.add(order);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(rs);
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(con);
        }

        return orderList;
    }

    @Override
    public String shipNow(String orderId, String prodId) {
        String status = "FAILURE";

        Connection con = DBUtil.provideConnection();
        PreparedStatement ps = null;
        ResultSet rs = null; // Для отримання кількості товару
        
        try {
            // 1. Отримати кількість товару, який відправляється з таблиці orders
            int quantityToShip = 0;
            String selectQuantityQuery = "SELECT quantity FROM orders WHERE orderid = ? AND prodid = ?";
            ps = con.prepareStatement(selectQuantityQuery);
            ps.setString(1, orderId);
            ps.setString(2, prodId);
            rs = ps.executeQuery();

            if (rs.next()) {
                quantityToShip = rs.getInt("quantity");
            }
            DBUtil.closeConnection(rs); // Закрити ResultSet
            DBUtil.closeConnection(ps); // Закрити PreparedStatement

            if (quantityToShip > 0) {
                // 2. Збільшити кількість товару в ProductServiceImpl
                ProductServiceImpl prodService = new ProductServiceImpl();
                boolean productQtyUpdated = prodService.updateProductQty(prodId, quantityToShip); // ВИКЛИК ЗБІЛЬШЕННЯ КІЛЬКОСТІ

                if (!productQtyUpdated) {
                    return "Failed to update product quantity on shipment!";
                }
            }
            
            // 3. Оновити статус shipped в таблиці orders
            ps = con.prepareStatement("update orders set shipped=1 where orderid=? and prodid=? and shipped=0");

            ps.setString(1, orderId);
            ps.setString(2, prodId);

            int k = ps.executeUpdate();

            if (k > 0) {
                status = "Order Has been shipped successfully!!";
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeConnection(rs); // Переконайтеся, що закривається
            DBUtil.closeConnection(ps);
            DBUtil.closeConnection(con);
        }

        return status;
    }

    @Override 
    public boolean updateShippedStatus(String transactionId, String productId, int shippedStatus) { 
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean updated = false;

        try {
            con = DBUtil.provideConnection();

            // Якщо статус "скасовано" (shippedStatus == 2), повертаємо кількість товару на склад
            if (shippedStatus == 2) {
                int quantityToReturn = 0;
                // 1. Отримати кількість товару з таблиці orders для даного transactionId та productId
                String selectQuantityQuery = "SELECT quantity FROM orders WHERE orderid = ? AND prodid = ?";
                ps = con.prepareStatement(selectQuantityQuery);
                ps.setString(1, transactionId);
                ps.setString(2, productId);
                rs = ps.executeQuery();

                if (rs.next()) {
                    quantityToReturn = rs.getInt("quantity");
                }
                DBUtil.closeConnection(rs); 
                DBUtil.closeConnection(ps); 

                if (quantityToReturn > 0) {
                    // 2. Додати цю кількість до pquantity у таблиці product
                    ProductServiceImpl prodService = new ProductServiceImpl();
                    prodService.updateProductQty(productId, quantityToReturn); 
                }
            }

            // 3. Оновити статус замовлення в таблиці orders
            String updateOrderQuery = "UPDATE orders SET shipped = ? WHERE orderid = ? AND prodid = ?"; 
            ps = con.prepareStatement(updateOrderQuery);

            ps.setInt(1, shippedStatus); 
            ps.setString(2, transactionId);
            ps.setString(3, productId); 

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                updated = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Додайте логування помилок для налагодження
        } finally {
            DBUtil.closeConnection(rs); 
            DBUtil.closeConnection(ps); 
            DBUtil.closeConnection(con);
        }
        return updated;
    }
}