<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.shashi.service.impl.SizeServiceImpl, com.shashi.beans.SizeBean, java.util.List, java.util.HashMap, java.util.Map, java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<title>Textileshop - Розміри</title>
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
    .size-container {
        background-color: white;
        border-radius: 10px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        padding: 25px;
        margin-top: 30px;
        margin-bottom: 30px;
    }
    .size-header {
        color: #2c3e50;
        margin-bottom: 25px;
        padding-bottom: 15px;
        border-bottom: 2px solid #f1f1f1;
    }
    .size-table {
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
        background-color: #219955;
        transform: translateY(-1px);
    }
    .no-items {
        background-color: #f8f9fa;
        color: #7f8c8d;
        font-style: italic;
    }
    .dimension {
        font-weight: 600;
        color: #2c3e50;
    }
    .category-section {
        margin-bottom: 40px;
        border-bottom: 1px solid #eee;
        padding-bottom: 20px;
    }
    .category-title {
        color: #2c3e50;
        margin-bottom: 15px;
        font-size: 20px;
        font-weight: bold;
    }
    .category-description {
        color: #7f8c8d;
        margin-bottom: 15px;
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
        <div class="size-container">
            <div class="size-header">
                <h2>Список розмірів</h2>
                <p class="text-muted">Перегляд та управління розмірами продукції</p>
            </div>
            
            <div class="text-right" style="margin-bottom: 20px;">
                <a href="addSize.jsp" class="btn btn-success btn-add">
                    <span class="glyphicon glyphicon-plus"></span> Додати розмір
                </a>
            </div>

            <%
            SizeServiceImpl sizeService = new SizeServiceImpl();
            List<SizeBean> allSizes = sizeService.getAllSizes();
            
            // Групуємо розміри за категоріями товарів
            Map<String, List<SizeBean>> sizesByCategory = new HashMap<>();
            
            for (SizeBean size : allSizes) {
                String category = size.getProductType();
                if (!sizesByCategory.containsKey(category)) {
                    sizesByCategory.put(category, new ArrayList<>());
                }
                sizesByCategory.get(category).add(size);
            }
            
            if (sizesByCategory.isEmpty()) {
            %>
            <div class="no-items text-center">
                Не знайдено жодного розміру
            </div>
            <%
            } else {
                for (Map.Entry<String, List<SizeBean>> entry : sizesByCategory.entrySet()) {
                    String category = entry.getKey();
                    List<SizeBean> sizes = entry.getValue();
            %>
            <div class="category-section">
                <div class="category-title"><%=category%></div>
                <p class="category-description">Розміри для категорії "<%=category%>"</p>
                
                <div class="table-responsive size-table">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Назва</th>
                                <th>Довжина (см)</th>
                                <th>Ширина (см)</th>
                                <th>Дії</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            if (sizes.isEmpty()) {
                            %>
                            <tr class="no-items">
                                <td colspan="5" class="text-center">Не знайдено розмірів для цієї категорії</td>
                            </tr>
                            <%
                            } else {
                                for (SizeBean size : sizes) {
                            %>
                            <tr>
                                <td><%=size.getSizeId()%></td>
                                <td><%=size.getSizeName()%></td>
								<td class="dimension"><%=size.getLength() != null ? String.format("%.1f", size.getLength()) : "N/A"%></td>
								<td class="dimension"><%=size.getWidth() != null ? String.format("%.1f", size.getWidth()) : "N/A"%></td>
                                <td>
                                    <a href="updateSize.jsp?sizeId=<%=size.getSizeId()%>" 
                                       class="btn btn-primary btn-action btn-edit">Змінити</a>
                                    <a href="./RemoveSizeSrv?sizeId=<%=size.getSizeId()%>" 
                                       class="btn btn-danger btn-action btn-delete"
                                       onclick="return confirm('Ви впевнені, що хочете видалити цей розмір?')">Видалити</a>
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

    <%@ include file="footer.html" %>

    <script>
    $(document).ready(function() {
        // Ініціалізація всіх dropdown-меню
        $('.dropdown-toggle').dropdown();
    });
    </script>

</body>
</html>