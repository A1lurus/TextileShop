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
<link rel="stylesheet"
    href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<link rel="stylesheet" href="css/changes.css">
<script
    src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
    src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
<style>
    .admin-container {
        background-color: white;
        border-radius: 10px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        padding: 25px;
        margin-top: 30px;
        margin-bottom: 30px;
    }
    .admin-header {
        color: #2c3e50;
        margin-bottom: 25px;
        padding-bottom: 15px;
        border-bottom: 2px solid #f1f1f1;
    }
    .admin-table {
        margin-top: 20px;
    }
    .table thead {
        background-color: #8e44ad;
        color: white;
    }
    .table th {
        font-weight: 500;
        font-size: 15px;
        text-align: center;
        vertical-align: middle;
    }
    .table td {
        vertical-align: middle;
        text-align: center;
    }
    .product-link {
        color: #3498db;
        font-weight: 500;
    }
    .product-link:hover {
        color: #2980b9;
        text-decoration: none;
    }
    .btn-ship {
        background-color: #27ae60;
        border: none;
        border-radius: 4px;
        padding: 6px 12px;
        font-size: 14px;
        min-width: 100px;
        transition: all 0.2s;
        color: black;
    }
    .btn-ship:hover {
        background-color: #219653;
    }
    .btn-cancel {
        background-color: #e74c3c;
        border: none;
        border-radius: 4px;
        padding: 6px 12px;
        font-size: 14px;
        min-width: 100px;
        transition: all 0.2s;
        color: white;
        margin-left: 5px;
    }
    .btn-cancel:hover {
        background-color: #c0392b;
    }
    .status-ready {
        color: #f39c12;
        font-weight: bold;
    }
    .status-canceled {
        color: #e74c3c;
        font-weight: bold;
    }
    .no-items {
        background-color: #f8f9fa;
        color: #7f8c8d;
        font-style: italic;
    }
    body {
        background-color: #f5f7fa;
    }

    /* Стилі для мініатюр тканини в таблиці */
    .fabric-admin-thumbnail {
        width: 30px; /* Менший розмір для адмінпанелі */
        height: 30px;
        object-fit: cover;
        border-radius: 3px;
        vertical-align: middle;
        margin-right: 5px;
    }
    .fabric-info-cell {
        display: flex;
        align-items: center;
        justify-content: center; /* Центрування вмісту */
        white-space: nowrap;
    }
</style>
</head>
<body>

<div style="height: 40px;"></div>
<%
    /* Перевірка авторизації адміністратора */
    String userType = (String) session.getAttribute("usertype");
    String userName = (String) session.getAttribute("username");
    String password = (String) session.getAttribute("password");

    if (userType == null || !userType.equals("admin")) {
        response.sendRedirect("loginFirst.jsp");
        return; // Додано return для запобігання подальшого виконання
    } else if (userName == null || password == null) {
        response.sendRedirect("loginFirst.jsp");
        return; // Додано return
    }

    OrderServiceImpl orderDao = new OrderServiceImpl();
    FabricService fabricDao = new FabricServiceImpl(); // Додаємо FabricService
    TransServiceImpl transService = new TransServiceImpl(); // Додаємо TransService
    UserServiceImpl userService = new UserServiceImpl(); // Додаємо UserService
    ProductServiceImpl prodDao = new ProductServiceImpl(); // Додаємо ProductService

    List<OrderBean> orders = orderDao.getAllOrders();
%>

<jsp:include page="header.jsp" />

<div class="container">
    <div class="admin-container">
        <div class="admin-header text-center">
            <h2>Необроблені замовлення</h2>
            <p class="text-muted">Замовлення, які очікують на відправку</p>
            <% String message = (String) request.getAttribute("message");
               if (message != null) { %>
               <div class="alert alert-info" role="alert" style="margin-top: 15px;">
                   <%= message %>
               </div>
            <% } %>
        </div>
        
        <div class="table-responsive admin-table">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>ID транзакції</th>
                        <th>Назва товару</th> <%-- Змінено заголовок --%>
                        <th>Тканина</th>
                        <th>Email клієнта</th>
                        <th>Адреса</th>
                        <th>Кількість</th>
                        <th>Дія</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    int unprocessedCount = 0;

                    for (OrderBean order : orders) {
                        if (order.getShipped() == 0) { // Перевіряємо, що shipped = 0 (очікує відправлення)
                            unprocessedCount++;
                            String transId = order.getTransactionId();
                            String prodId = order.getProductId();
                            String fabricId = order.getFabricId();
                            int quantity = order.getQuantity();

                            String userId = transService.getUserId(transId);
                            String userAddr = userService.getUserAddr(userId);

                            // Отримуємо назву товару
                            ProductBean product = prodDao.getProductDetails(prodId);
                            String productName = (product != null) ? product.getProdName() : "Невідомий товар";

                            // Отримуємо інформацію про тканину
                            FabricBean fabric = null;
                            if (fabricId != null && !fabricId.isEmpty()) {
                                fabric = fabricDao.getFabricDetails(fabricId);
                            }
                %>
                    <tr>
                        <td><%= transId %></td>
                        <td>
                            <a href="./updateProduct.jsp?prodid=<%= prodId %>" class="product-link">
                                <%= productName %> <%-- Відображаємо назву товару --%>
                            </a>
                        </td>
                        <td class="fabric-info-cell">
                            <% if (fabric != null) { %>
                                <img src="./ShowImage?fabricId=<%=fabric.getFabricId()%>" alt="<%=fabric.getColor()%>" class="fabric-admin-thumbnail">
                                <%=fabric.getColor()%>
                            <% } else { %>
                                –
                            <% } %>
                        </td>
                        <td><%= userId %></td>
                        <td><%= userAddr %></td>
                        <td><%= quantity %></td>
                        <td>
                            <a href="ShipmentServlet?orderid=<%= transId %>&amount=<%= order.getAmount() %>&userid=<%= userId %>&prodid=<%= prodId %>"
                               class="btn btn-ship">
                               Відправити
                            </a>
                            <form action="CancelOrderServlet" method="post" style="display:inline-block;">
                                <input type="hidden" name="orderid" value="<%= transId %>">
                                <input type="hidden" name="prodid" value="<%= prodId %>">
                                <button type="submit" class="btn btn-danger btn-cancel">
                                   Скасувати
                                </button>
                            </form>
                        </td>
                    </tr>
                <%
                        }
                    }
                    if (unprocessedCount == 0) {
                %>
                    <tr class="no-items">
                        <td colspan="7" class="text-center">Немає замовлень для обробки</td>
                    </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>

    ---

    <div class="admin-container" style="margin-top: 50px;">
        <div class="admin-header text-center">
            <h2 style="color: #e74c3c;">Скасовані замовлення</h2>
            <p class="text-muted">Замовлення, які були скасовані</p>
        </div>
        
        <div class="table-responsive admin-table">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>ID транзакції</th>
                        <th>Назва товару</th> <%-- Змінено заголовок --%>
                        <th>Тканина</th>
                        <th>Email клієнта</th>
                        <th>Адреса</th>
                        <th>Кількість</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    int canceledCount = 0;

                    for (OrderBean order : orders) {
                        if (order.getShipped() == 2) { // Перевіряємо, що shipped = 2 (скасовано)
                            canceledCount++;
                            String transId = order.getTransactionId();
                            String prodId = order.getProductId();
                            String fabricId = order.getFabricId();
                            int quantity = order.getQuantity();

                            String userId = transService.getUserId(transId);
                            String userAddr = userService.getUserAddr(userId);

                            // Отримуємо назву товару
                            ProductBean product = prodDao.getProductDetails(prodId);
                            String productName = (product != null) ? product.getProdName() : "Невідомий товар";

                            // Отримуємо інформацію про тканину
                            FabricBean fabric = null;
                            if (fabricId != null && !fabricId.isEmpty()) {
                                fabric = fabricDao.getFabricDetails(fabricId);
                            }
                %>
                    <tr>
                        <td><%= transId %></td>
                        <td>
                            <a href="./updateProduct.jsp?prodid=<%= prodId %>" class="product-link">
                                <%= productName %> <%-- Відображаємо назву товару --%>
                            </a>
                        </td>
                        <td class="fabric-info-cell">
                            <% if (fabric != null) { %>
                                <img src="./ShowImage?fabricId=<%=fabric.getFabricId()%>" alt="<%=fabric.getColor()%>" class="fabric-admin-thumbnail">
                                <%=fabric.getColor()%>
                            <% } else { %>
                                –
                            <% } %>
                        </td>
                        <td><%= userId %></td>
                        <td><%= userAddr %></td>
                        <td><%= quantity %></td>
                    </tr>
                <%
                        }
                    }
                    if (canceledCount == 0) {
                %>
                    <tr class="no-items">
                        <td colspan="6" class="text-center">Немає скасованих замовлень</td>
                    </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@ include file="footer.html"%>

</body>
</html>