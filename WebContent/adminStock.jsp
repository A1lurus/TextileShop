<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page
    import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
    <%
ProductServiceImpl productService = new ProductServiceImpl();
%>
<!DOCTYPE html>
<html>
<head>
<title>Textileshop - Склад товарів</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<link rel="stylesheet" href="css/changes.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<style>
    body {
        padding-top: 40px;
        background-color: #f5f7fa;
    }
    .stock-container {
        background-color: white;
        border-radius: 10px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        padding: 25px;
        margin-top: 30px;
        margin-bottom: 30px;
    }
    .stock-header {
        color: #2c3e50;
        margin-bottom: 25px;
        padding-bottom: 15px;
        border-bottom: 2px solid #f1f1f1;
    }
    .stock-table {
        margin-top: 20px;
    }
    .table thead {
        background-color: #3498db;
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
    .product-img {
        width: 70px;
        height: 70px;
        object-fit: contain;
        border-radius: 4px;
        border: 1px solid #eee;
    }
    .product-link {
        color: #3498db;
        font-weight: 500;
    }
    .product-link:hover {
        color: #2980b9;
        text-decoration: none;
    }
    .btn-action {
        min-width: 100px;
        margin: 2px;
        padding: 8px 12px;
        font-size: 14px;
        border-radius: 6px;
        transition: all 0.3s;
        border: none;
    }
    .btn-edit {
        background-color: #3498db;
    }
    .btn-edit:hover {
        background-color: #2980b9;
        transform: translateY(-1px);
    }
    .btn-delete {
        background-color: #e74c3c;
    }
    .btn-delete:hover {
        background-color: #c0392b;
        transform: translateY(-1px);
    }
    .btn-add {
        background-color: #27ae60;
        border: none;
    }
    .btn-add:hover {
        background-color: #219653;
        transform: translateY(-1px);
    }
    .no-items {
        background-color: #f8f9fa;
        color: #7f8c8d;
        font-style: italic;
    }
    .stock-indicator {
        font-weight: 600;
    }
    .low-stock {
        color: #e74c3c;
    }
    .medium-stock {
        color: #f39c12;
    }
    .high-stock {
        color: #27ae60;
    }
    .hidden-status {
        font-weight: 600;
    }
    .hidden-true {
        color: #e74c3c;
    }
    .hidden-false {
        color: #27ae60;
    }
    .category-section {
        margin-bottom: 30px;
        border-bottom: 1px solid #eee;
        padding-bottom: 15px;
    }
    .category-title {
        font-size: 20px;
        font-weight: bold;
        color: #2c3e50;
        margin-bottom: 15px;
        padding-bottom: 10px;
        border-bottom: 2px solid #f1f1f1;
    }
</style>
</head>
<body>

    <%
    /* Перевірка авторизації адміністратора */
    String userType = (String) session.getAttribute("usertype");
    String userName = (String) session.getAttribute("username");
    String password = (String) session.getAttribute("password");

    if (userType == null || !userType.equals("admin")) {
        response.sendRedirect("login.jsp?message=Доступ заборонено! Увійдіть як адміністратор");
    }
    else if (userName == null || password == null) {
        response.sendRedirect("login.jsp?message=Сесія закінчилась, увійдіть знову");
    }
    %>

    <jsp:include page="header.jsp" />

    <div class="container">
        <div class="stock-container">
            <div class="stock-header">
                <h2>Склад товарів</h2>
                <p class="text-muted">Перегляд та управління товарами</p>
            </div>
            
            <div class="text-right" style="margin-bottom: 20px;">
                <a href="addProduct.jsp" class="btn btn-success btn-add">
                    <span class="glyphicon glyphicon-plus"></span> Додати новий товар
                </a>
            </div>

            <%
            ProductServiceImpl productDao = new ProductServiceImpl();
            List<ProductBean> allProducts = productDao.getAllProductsadmin();
            
            // Групуємо товари за категоріями
            Map<String, List<ProductBean>> productsByCategory = new HashMap<>();
            
            for (ProductBean product : allProducts) {
                String category = product.getProdType().toUpperCase();
                if (!productsByCategory.containsKey(category)) {
                    productsByCategory.put(category, new ArrayList<>());
                }
                productsByCategory.get(category).add(product);
            }
            
            if (productsByCategory.isEmpty()) {
            %>
            <div class="no-items text-center">
                Немає товарів
            </div>
            <%
            } else {
                for (Map.Entry<String, List<ProductBean>> entry : productsByCategory.entrySet()) {
                    String category = entry.getKey();
                    List<ProductBean> products = entry.getValue();
            %>
            <div class="category-section">
                <div class="category-title"><%=category%></div>
                
                <div class="table-responsive stock-table">
                    <table class="table table-hover">
    <thead>
        <tr>
            <th>Зображення</th>
            <th>ID</th>
            <th>Назва</th>
            <th>Ціна (грн)</th>
            <th>Тип тканини</th>
            <th>Розмір</th>
            <th>Продано</th>
            <th>Можливо замовити</th>
            <th>Статус</th>
            <th>Дії</th>
        </tr>
    </thead>
    <tbody>
        <%
        if (products.isEmpty()) {
        %>
        <tr class="no-items">
            <td colspan="10" class="text-center">Немає товарів у цій категорії</td>
        </tr>
        <%
        } else {
            for (ProductBean product : products) {
                String name = product.getProdName();
                name = name.length() > 25 ? name.substring(0, 25) + "..." : name;
                int stock = product.getProdQuantity();
                String stockClass = stock < 5 ? "low-stock" : 
                                 stock < 15 ? "medium-stock" : "high-stock";
                boolean isHidden = product.getHide();
        %>
        <tr>
            <td>
                <img src="./ShowImage?pid=<%=product.getProdId()%>" 
                    class="product-img" alt="<%=product.getProdName()%>">
            </td>
            <td>
                <a href="./updateProduct.jsp?prodid=<%=product.getProdId()%>" 
                    class="product-link">
                    <%=product.getProdId()%>
                </a>
            </td>
            <td><%=name%></td>
            <td><%=String.format("%.2f", product.getProdPrice())%></td>
            <td><%=product.getFabricType() != null ? product.getFabricType() : "-"%></td>
            <td><%= productService.getSizeNameById(product.getSize()) %></td>
            <td><%=new OrderServiceImpl().countSoldItem(product.getProdId())%></td>
            <td class="stock-indicator <%=stockClass%>">
                <%=stock%>
            </td>
            <td class="hidden-status <%=isHidden ? "hidden-true" : "hidden-false"%>">
                <%=isHidden ? "Приховано" : "Відображається"%>
            </td>
            <td>
                <a href="updateProduct.jsp?prodid=<%=product.getProdId()%>"
                    class="btn btn-primary btn-action btn-edit">
                    Змінити
                </a>
                <a href="./RemoveProductSrv?prodid=<%=product.getProdId()%>"
                   class="btn btn-danger btn-action btn-delete"
                   onclick="return confirm('Ви впевнені, що хочете видалити цей товар?')">
                   Видалити
                </a>
            </td>
        </tr>
        <% 
            }
        }
        %>
    </tbody>
</table>
                </div>
            </div>
            <%
                }
            }
            %>
        </div>
    </div>

    <%@ include file="footer.html"%>

    <script>
    $(document).ready(function() {
        // Ініціалізація всіх dropdown-меню
        $('.dropdown-toggle').dropdown();
    });
    </script>

</body>
</html>