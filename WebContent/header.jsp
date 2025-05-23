<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="com.shashi.service.impl.*, com.shashi.service.*" %>

<!DOCTYPE html>
<html>
<head>
<title>Textileshop - Вихід</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
    href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<link rel="stylesheet" href="css/changes.css">
<script
    src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
    src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
<link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body style="background-color: #E6F9E6;">
 <div style="height: 20px;"></div>

    <%
    /* Перевірка авторизації користувача */
    String userType = (String) session.getAttribute("usertype");
    if (userType == null) { //Користувач не авторизований
    %>

    <!-- Початок навігаційної панелі -->
    <nav class="navbar navbar-default navbar-fixed-top">
        <div class="container-fluid">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse"
                    data-target="#myNavbar">
                    <span class="icon-bar"></span> <span class="icon-bar"></span> <span
                        class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="index.jsp"><span
                    class="glyphicon glyphicon-home">&nbsp;</span>Textileshop</a>
            </div>
            <div class="collapse navbar-collapse" id="myNavbar">
                <ul class="nav navbar-nav navbar-right">
                    <li><a href="index.jsp">Товари</a></li>
                    <li><a href="login.jsp">Увійти</a></li>
                </ul>
            </div>
        </div>
    </nav>
    <%
    } else if ("customer".equalsIgnoreCase(userType)) { //Заголовок для покупця

    int notf = new CartServiceImpl().getCartCount((String) session.getAttribute("username"));
    %>
    <nav class="navbar navbar-default navbar-fixed-top">

        <div class="container-fluid">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse"
                    data-target="#myNavbar">
                    <span class="icon-bar"></span> <span class="icon-bar"></span> <span
                        class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="userHome.jsp"><span
                    class="glyphicon glyphicon-home">&nbsp;</span>Textileshop</a>
            </div>

            <div class="collapse navbar-collapse" id="myNavbar">
                <ul class="nav navbar-nav navbar-right">
                    <li><a href="userHome.jsp"><span>Товари</span></a></li>
                    <%
                    if (notf == 0) {
                    %>
                    <li><a href="cartDetails.jsp"> <span
                            class="glyphicon glyphicon-shopping-cart"></span>Кошик
                    </a></li>

                    <%
                    } else {
                    %>
                    <li><a href="cartDetails.jsp"
                        style="margin: 0px; padding: 0px;" id="mycart"><i
                            data-count="<%=notf%>"
                            class="fa fa-shopping-cart fa-3x icon-white badge"
                            style="background-color: #0066cc; margin: 0px; padding: 0px; padding-bottom: 0px; padding-top: 5px;">
                        </i></a></li>
                    <%
                    }
                    %>
                    <li><a href="orderDetails.jsp">Замовлення</a></li>
                    <li><a href="userProfile.jsp">Профіль</a></li>
                    <li><a href="./LogoutSrv">Вийти</a></li>
                </ul>
            </div>
        </div>
    </nav>
    <%
    } else { //Заголовок для адміністратора
    %>
    <nav class="navbar navbar-default navbar-fixed-top">
        <div class="container-fluid">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse"
                    data-target="#myNavbar">
                    <span class="icon-bar"></span> <span class="icon-bar"></span> <span
                        class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="adminViewProduct.jsp"><span
                    class="glyphicon glyphicon-home">&nbsp;</span>Textileshop</a>
            </div>
            <div class="collapse navbar-collapse" id="myNavbar">
                <ul class="nav navbar-nav navbar-right">
                    <li class="dropdown"><a class="dropdown-toggle"
                        data-toggle="dropdown" href="#">Склад <span class="caret"></span>
                    </a>
                        <ul class="dropdown-menu">
                            <li><a href="adminStock.jsp">Товари</a></li>
                            <li><a href="viewFabrics.jsp">Тканини</a></li>
                            <li><a href="viewFabricTypes.jsp">Тип тканини</a></li>
                            <li><a href="viewSizes.jsp">Розміри</a></li>
                        </ul></li>
                    <li><a href="shippedItems.jsp">Відправлення</a></li>
                    <li><a href="unshippedItems.jsp">Замовлення</a></li>
                    <li><a href="./LogoutSrv">Вийти</a></li>
                </ul>
            </div>
        </div>
    </nav>
    <%
    }
    %>
    <!-- Кінець навігаційної панелі -->
</body>
</html>