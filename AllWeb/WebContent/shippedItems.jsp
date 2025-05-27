<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page
    import="com.shashi.service.impl.*, com.shashi.beans.*,com.shashi.service.*,java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Textileshop - Адмінпанель</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<link rel="stylesheet" href="css/changes.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
<style>
    .admin-container {
        background-color: white;
        border-radius: 10px;
        box-shadow: 0 0 20px rgba(0,0,0,0.1);
        padding: 25px;
        margin-top: 30px;
        margin-bottom: 30px;
    }
    .admin-header {
        color: #2c3e50;
        margin-bottom: 30px;
        text-align: center;
    }
    .admin-table {
        margin-top: 20px;
    }
    .table thead {
        background-color: #3498db;
        color: white;
    }
    .table th {
        font-weight: 500;
        font-size: 16px;
    }
    .table td {
        vertical-align: middle;
        text-align: center;
    }
    .status-shipped {
        color: #27ae60;
        font-weight: bold;
    }
    .no-items {
        background-color: #f8f9fa !important;
        color: #7f8c8d !important;
        font-style: italic;
    }
    .product-link {
        color: #3498db;
        font-weight: 500;
    }
    .product-link:hover {
        color: #2980b9;
        text-decoration: none;
    }
    body {
        background-color: #f5f7fa;
    }
</style>
</head>
<body>

<div style="height: 40px;"></div>
<%
    /* Перевірка авторизації */
    String userType = (String) session.getAttribute("usertype");
    String userName = (String) session.getAttribute("username");
    String password = (String) session.getAttribute("password");

    if (userType == null || !userType.equals("admin")) {
        response.sendRedirect("login.jsp?message=Доступ заборонено! Увійдіть як адміністратор");
    } else if (userName == null || password == null) {
        response.sendRedirect("login.jsp?message=Сесія закінчилась, увійдіть знову");
    }
%>

<jsp:include page="header.jsp" />

<div class="container admin-container">
    <div class="admin-header">
        <h2>Відправлені замовлення</h2>
        <p class="text-muted">Перелік усіх оброблених замовлень</p>
    </div>

    <div class="table-responsive admin-table">
        <table class="table table-hover">
            <thead>
                <tr>
                    <th>ID транзакції</th>
                    <th>ID товару</th>
                    <th>Код тканини</th>
                    <th>Користувач</th>
                    <th>Адреса</th>
                    <th>Кількість</th>
                    <th>Сума</th>
                </tr>
            </thead>
            <tbody>
                <%
                OrderServiceImpl orderdao = new OrderServiceImpl();
                List<OrderBean> orders = orderdao.getAllOrders();
                int count = 0;

                for (OrderBean order : orders) {
                    // Перевіряємо, що shipped = 1 (відправлено)
                    if (order.getShipped() == 1) { 
                        count++;
                        String transId = order.getTransactionId();
                        String prodId = order.getProductId();
                        String fabricId = order.getFabricId();  // Додаємо код тканини
                        int quantity = order.getQuantity();

                        String userId = new TransServiceImpl().getUserId(transId);
                        String userAddr = new UserServiceImpl().getUserAddr(userId);
                %>
                <tr>
                    <td><%= transId %></td>
                    <td>
                        <a href="./updateProduct.jsp?prodid=<%= prodId %>" class="product-link">
                            <%= prodId %>
                        </a>
                    </td>
                    <td><%= fabricId %></td>
                    <td><%= userId %></td>
                    <td><%= userAddr %></td>
                    <td><%= quantity %></td>
                    <td><%= String.format("%.2f грн", order.getAmount()) %></td>
                </tr>
                <%
                    }
                }

                if (count == 0) {
                %>
                <tr class="no-items">
                    <td colspan="8" class="text-center">Немає відправлених замовлень</td>
                </tr>
                <%
                }
                %>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="footer.html"%>
</body>
</html>