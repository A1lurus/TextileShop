<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.shashi.service.impl.*, com.shashi.service.*, com.shashi.beans.*, java.util.*, javax.servlet.ServletOutputStream, java.io.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Textileshop - Деталі замовлення</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
    href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<script
    src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
    src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="css/changes.css">
<style>
    /* Стилі для мініатюр тканин у таблиці замовлень */
    .fabric-order-thumbnail {
        width: 30px; /* Зменшений розмір для таблиці */
        height: 30px;
        object-fit: cover;
        border-radius: 3px;
        vertical-align: middle; /* Вирівнювання по центру з текстом */
        margin-right: 5px;
    }
    .fabric-info-cell {
        display: flex;
        align-items: center;
        white-space: nowrap; /* Щоб уникнути переносів, якщо назва коротка */
    }
</style>
</head>
<body style="background-color: #E6F9E6;">
<div style="height: 40px;"></div>
<%
    String userName = (String) session.getAttribute("username");
    String password = (String) session.getAttribute("password");

    if (userName == null || password == null) {
        response.sendRedirect("login.jsp?message=Сесія закінчилась, увійдіть знову!!");
        return;
    }

    OrderService orderDao = new OrderServiceImpl(); // Змінено назву, щоб уникнути конфлікту
    FabricService fabricDao = new FabricServiceImpl(); // Додаємо FabricService
    List<OrderDetails> orders = orderDao.getAllOrderDetails(userName);
%>

<jsp:include page="header.jsp" />

<div class="text-center"
    style="color: green; font-size: 24px; font-weight: bold;">
    Деталі замовлення
</div>

<div class="container">
    <div class="table-responsive">
        <table class="table table-hover table-sm">
            <thead style="background-color: black; color: white; font-size: 14px; font-weight: bold;">
                <tr>
                    <th>Зображення товару</th>
                    <th>Назва товару</th>
                    <th>ID замовлення</th>
                    <th>Кількість</th>
                    <th>Ціна</th>
                    <th>Тканина</th> <%-- Змінено заголовок --%>
                    <th>Час</th>
                    <th>Статус</th>
                </tr>
            </thead>
            <tbody style="background-color: white; font-size: 15px; font-weight: bold;">
                <%
                for (OrderDetails order : orders) {
                    String statusText;
                    String statusClass;
                    if (order.getShipped() == 0) {
                        statusText = "ЗАМОВЛЕНО";
                        statusClass = "text-success"; // Зелений колір
                    } else if (order.getShipped() == 1) {
                        statusText = "ВІДПРАВЛЕНО";
                        statusClass = "text-primary"; // Синій колір
                    } else if (order.getShipped() == 2) {
                        statusText = "СКАСОВАНО";
                        statusClass = "text-danger"; // Червоний колір
                    } else {
                        statusText = "НЕВІДОМО";
                        statusClass = "text-muted"; // Сірий колір
                    }

                    // Отримуємо інформацію про тканину
                    FabricBean fabric = null;
                    if (order.getFabricId() != null && !order.getFabricId().isEmpty()) {
                        fabric = fabricDao.getFabricDetails(order.getFabricId());
                    }
                %>
                <tr>
                    <td><img src="./ShowImage?pid=<%=order.getProductId()%>" style="width: 50px; height: 50px;"></td>
                    <td><%=order.getProdName()%></td>
                    <td><%=order.getOrderId()%></td>
                    <td><%=order.getQty()%></td>
                    <td><%=order.getAmount()%></td>
                    <td class="fabric-info-cell"> <%-- Новий клас для стилізації --%>
                        <% if (fabric != null) { %>
                            <img src="./ShowImage?fabricId=<%=fabric.getFabricId()%>" alt="<%=fabric.getColor()%>" class="fabric-order-thumbnail">
                            <%=fabric.getColor()%>
                        <% } else { %>
                            – <%-- або можна вивести "Тканина не вказана" --%>
                        <% } %>
                    </td>
                    <td><%=order.getTime()%></td>
                    <td class="<%=statusClass%>"><%=statusText%></td>
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