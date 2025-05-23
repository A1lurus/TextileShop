<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page
    import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Textileshop - Перегляд товарів</title>
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
    .product-row {
        display: flex;
        margin-bottom: 30px;
        border: 1px solid #eee;
        border-radius: 5px;
        padding: 20px;
        background-color: white;
    }
    .product-image-container {
        flex: 0 0 30%;
        padding: 15px;
        text-align: center;
    }
    .product-image {
        max-height: 200px;
        max-width: 100%;
        object-fit: contain;
    }
    .product-info-container {
        flex: 0 0 70%;
        padding: 15px;
    }
    .product-title {
        font-size: 20px;
        font-weight: bold;
        margin-bottom: 15px;
        color: #333;
    }
    .product-id {
        color: #777;
        font-size: 14px;
    }
    .product-description {
        font-size: 14px;
        color: #666;
        margin-bottom: 15px;
        line-height: 1.5;
    }
    .product-price {
        font-size: 18px;
        font-weight: bold;
        color: #e74c3c;
        margin-bottom: 20px;
    }
    .btn-action {
        padding: 8px 15px;
        margin-right: 10px;
        min-width: 140px;
    }
    @media (max-width: 768px) {
        .product-row {
            flex-direction: column;
        }
        .product-image-container,
        .product-info-container {
            flex: 0 0 100%;
        }
        .btn-action {
            width: 100%;
            margin-bottom: 10px;
            margin-right: 0;
        }
    }
</style>
</head>
<body style="background-color: #E6F9E6;">

<!--Заголовок компанії -->
    <div class="container-fluid text-center"
        style="margin-top: 45px; background-color: #0066cc; color: white; padding: 5px;">
        <h2>Textileshop</h2>
        <h6>Спеціалізуємося на текстильних виробах</h6>
        <form class="form-inline" action="index.jsp" method="get">
            <div class="input-group">
                <input type="text" class="form-control" size="50" name="search"
                    placeholder="Пошук товарів" required>
                <div class="input-group-btn">
                    <input type="submit" class="btn btn-primary" value="Пошук" />
                </div>
            </div>
        </form>
        <p align="center"
            style="color: white; font-weight: bold; margin-top: 5px; margin-bottom: 5px;"
            id="message"></p>
    </div>
    <!-- Кінець заголовка компанії -->
    <%
    // Перевірка авторизації адміністратора
    String userName = (String) session.getAttribute("username");
    String password = (String) session.getAttribute("password");
    String userType = (String) session.getAttribute("usertype");

    if (userType == null || !userType.equals("admin")) {
        response.sendRedirect("login.jsp?message=Доступ заборонено, увійдіть як адміністратор!!");
        return;
    }
    else if (userName == null || password == null) {
        response.sendRedirect("login.jsp?message=Сесія закінчилась, увійдіть знову!!");
        return;
    }

    ProductServiceImpl prodDao = new ProductServiceImpl();
    List<ProductBean> products = new ArrayList<ProductBean>();

    String search = request.getParameter("search");
    String type = request.getParameter("type");
    String message = "Всі товари";
    if (search != null) {
        products = prodDao.searchAllProducts(search);
        message = "Результати пошуку: '" + search + "'";
    } else if (type != null) {
        products = prodDao.getAllProductsByType(type);
        message = "Категорія: '" + type + "'";
    } else {
        products = prodDao.getAllProducts();
    }
    if (products.isEmpty()) {
        message = "За запитом '" + (search != null ? search : type) + "' нічого не знайдено";
        products = prodDao.getAllProducts();
    }
    %>

    <jsp:include page="header.jsp" />

    <div class="container" style="margin-top: 20px;">
        <div class="text-center" style="color: black; font-size: 16px; font-weight: bold; margin: 15px 0;">
            <%=message%>
        </div>
        
        <!-- Список товарів -->
        <div class="product-list">
            <%
            for (ProductBean product : products) {
            %>
            <div class="product-row">
                <!-- Фото товару -->
                <div class="product-image-container">
                    <img src="./ShowImage?pid=<%=product.getProdId()%>" alt="<%=product.getProdName()%>" class="product-image">
                </div>
                
                <!-- Інформація про товар -->
                <div class="product-info-container">
                    <h3 class="product-title">
                        <%=product.getProdName()%>
                        <span class="product-id">(ID: <%=product.getProdId()%>)</span>
                    </h3>
                    
                    <p class="product-description">
                        <%=product.getProdInfo()%>
                    </p>
                    
                    <div class="product-price">
                        <%=product.getProdPrice()%> грн
                    </div>
                    
                    <!-- Кнопки дій -->
                    <div class="actions-row">
                        <form method="post">
                            <button type="submit"
                                formaction="./RemoveProductSrv?prodid=<%=product.getProdId()%>"
                                class="btn btn-danger btn-action">
                                <span class="glyphicon glyphicon-trash"></span> Видалити
                            </button>
                            <button type="submit"
                                formaction="updateProduct.jsp?prodid=<%=product.getProdId()%>"
                                class="btn btn-primary btn-action">
                                <span class="glyphicon glyphicon-edit"></span> Редагувати
                            </button>
                        </form>
                    </div>
                </div>
            </div>
            <%
            }
            %>
        </div>
    </div>

    <%@ include file="footer.html"%>

</body>
</html>