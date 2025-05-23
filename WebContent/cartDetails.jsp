<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.shashi.service.impl.*, com.shashi.service.*, com.shashi.beans.*, java.util.*" %>

<%
String addParam = request.getParameter("add");
if (addParam != null) {
    String uid = request.getParameter("uid");
    String pid = request.getParameter("pid");
    String fabricId = request.getParameter("fabricId");
    int avail = Integer.parseInt(request.getParameter("avail"));
    int qty = Integer.parseInt(request.getParameter("qty"));

    CartServiceImpl cartService = new CartServiceImpl();

    if ("1".equals(addParam)) {
        if (qty < avail) {
            cartService.updateProductToCart(uid, pid, qty + 1, fabricId);
        } else {
            session.setAttribute("message", "Максимальна доступна кількість: " + avail);
        }
    } else if ("0".equals(addParam)) {
        if (qty > 1) {
            cartService.updateProductToCart(uid, pid, qty - 1, fabricId);
        } else {
            cartService.removeAProduct(uid, pid, fabricId);
        }
    }

    response.sendRedirect("cartDetails.jsp");
    return;
}

String userName = (String) session.getAttribute("username");
String password = (String) session.getAttribute("password");

if (userName == null || password == null) {
    response.sendRedirect("login.jsp?message=Сесія закінчилась, увійдіть знову!!");
    return;
}

String message = (String) session.getAttribute("message");
if (message != null) {
    session.removeAttribute("message");
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Textileshop - Деталі кошика</title>
    <meta charset="utf-8">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <style>
        body { background-color: #f5f7fa; }
        .cart-container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            padding: 25px;
            margin-top: 30px;
            margin-bottom: 30px;
        }
        .cart-header {
            text-align: center;
            margin-bottom: 30px;
            color: #2c3e50;
        }
        .table thead {
            background-color: #3498db;
            color: white;
        }
        .table th, .table td {
            text-align: center;
            vertical-align: middle;
        }
        .quantity-control {
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .quantity-btn {
            background: none;
            border: none;
            color: #3498db;
            font-size: 18px;
            padding: 0 10px;
            cursor: pointer;
        }
        .quantity-input {
            width: 50px;
            text-align: center;
            margin: 0 5px;
        }
        .product-image {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 5px; /* Додано для естетики */
        }
        /* Стилі для мініатюр тканини в таблиці кошика */
        .fabric-cart-thumbnail {
            width: 40px; /* Трохи більший розмір, ніж в адмінпанелі */
            height: 40px;
            object-fit: cover;
            border-radius: 3px;
            vertical-align: middle;
            margin-right: 5px;
        }
        .fabric-info-cell {
            display: flex;
            align-items: center;
            justify-content: center; /* Центрування вмісту */
            white-space: nowrap; /* Щоб уникнути переносів */
        }
        .total-row {
            background-color: #3498db;
            color: white;
            font-weight: bold;
        }
        .action-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
        .cancel-btn {
            background-color: #2c3e50;
            color: white;
            border-radius: 5px;
            padding: 10px 20px;
            transition: background-color 0.3s ease;
        }
        .cancel-btn:hover {
            background-color: #3f51b5;
            color: white;
        }
        .pay-btn {
            background-color: #27ae60;
            color: white;
            border-radius: 5px;
            padding: 10px 20px;
            transition: background-color 0.3s ease;
        }
        .pay-btn:hover {
            background-color: #1e8449;
            color: white;
        }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container cart-container">
    <div class="cart-header">
        <h2>Товари у кошику</h2>
    </div>

    <% if (message != null) { %>
        <div class="alert alert-info text-center"><%= message %></div>
    <% } %>

    <div class="table-responsive">
        <table class="table table-hover">
            <thead>
                <tr>
                    <th>Зображення товару</th>
                    <th>Товар</th>
                    <th>Тканина</th> <th>Ціна</th>
                    <th>Кількість</th>
                    <th>Сума</th>
                </tr>
            </thead>
            <tbody>
                <%
                CartServiceImpl cart = new CartServiceImpl();
                ProductServiceImpl productService = new ProductServiceImpl(); // Додаємо ProductService
                FabricServiceImpl fabricService = new FabricServiceImpl(); // Додаємо FabricService
                
                List<CartBean> cartItems = cart.getAllCartItems(userName);
                double totAmount = 0;
                
                if (cartItems.isEmpty()) {
                %>
                    <tr>
                        <td colspan="6" class="text-center text-muted" style="padding: 20px;">Ваш кошик порожній.</td>
                    </tr>
                <%
                } else {
                    for (CartBean item : cartItems) {
                        ProductBean product = productService.getProductDetails(item.getProdId());
                        FabricBean fabric = null;
                        
                        // Отримуємо інформацію про тканину
                        if (item.getFabricId() != null && !item.getFabricId().isEmpty()) {
                            fabric = fabricService.getFabricDetails(item.getFabricId());
                        }

                        int qty = item.getQuantity();
                        double currAmount = (product != null) ? product.getProdPrice() * qty : 0; // Перевірка на null
                        totAmount += currAmount;
                %>
                <tr>
                    <td>
                        <% if (product != null) { %>
                            <img src="./ShowImage?pid=<%=product.getProdId()%>" alt="<%=product.getProdName()%>" class="product-image">
                        <% } else { %>
                            <img src="images/noimage.jpg" alt="Невідомий товар" class="product-image">
                        <% } %>
                    </td>
                    <td><%= (product != null) ? product.getProdName() : "Невідомий товар" %></td>
                    <td class="fabric-info-cell">
                        <% if (fabric != null) { %>
                            <img src="./ShowImage?fabricId=<%=fabric.getFabricId()%>" alt="<%=fabric.getColor()%>" class="fabric-cart-thumbnail">
                            <%=fabric.getColor()%>
                        <% } else { %>
                            –
                        <% } %>
                    </td>
                    <td><%= (product != null) ? product.getProdPrice() + " грн" : "0.00 грн" %></td>
                    <td>
                        <div class="quantity-control">
                            <a href="cartDetails.jsp?add=0&uid=<%=userName%>&pid=<%=item.getProdId()%>&fabricId=<%=item.getFabricId()%>&avail=<%= (product != null) ? product.getProdQuantity() : 0 %>&qty=<%=qty%>" class="quantity-btn"><i class="fa fa-minus"></i></a>
                            <input type="number" value="<%=qty%>" class="quantity-input" readonly>
                            <a href="cartDetails.jsp?add=1&uid=<%=userName%>&pid=<%=item.getProdId()%>&fabricId=<%=item.getFabricId()%>&avail=<%= (product != null) ? product.getProdQuantity() : 0 %>&qty=<%=qty%>" class="quantity-btn"><i class="fa fa-plus"></i></a>
                        </div>
                    </td>
                    <td><%=String.format("%.2f грн", currAmount)%></td>
                </tr>
                <% 
                    } // Кінець циклу for
                } // Кінець if (cartItems.isEmpty())
                %>
                <tr class="total-row">
                    <td colspan="5">Загальна сума до сплати:</td>
                    <td><%=String.format("%.2f грн", totAmount)%></td>
                </tr>
            </tbody>
        </table>
    </div>

    <% if (totAmount > 0) { %>
    <div class="action-buttons">
        <form method="post" class="form-inline">
            <button formaction="userHome.jsp" class="btn cancel-btn">Продовжити покупки</button>
            <button formaction="payment.jsp?amount=<%=totAmount%>" class="btn pay-btn">Перейти до оплати</button>
        </form>
    </div>
    <% } %>
</div>

<jsp:include page="footer.html" />

</body>
</html>