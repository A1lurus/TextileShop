<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.shashi.service.impl.FabricServiceImpl, com.shashi.beans.FabricBean, java.util.List, java.util.HashMap, java.util.Map, java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<title>Textileshop - Тканини</title>
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
    .fabric-container {
        background-color: white;
        border-radius: 10px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        padding: 25px;
        margin-top: 30px;
        margin-bottom: 30px;
    }
    .fabric-header {
        color: #2c3e50;
        margin-bottom: 25px;
        padding-bottom: 15px;
        border-bottom: 2px solid #f1f1f1;
    }
    .fabric-table {
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
    .fabric-img {
        width: 70px;
        height: 70px;
        object-fit: cover;
        border-radius: 4px;
        border: 1px solid #eee;
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
    .stock-low {
        color: #e74c3c;
        font-weight: 600;
    }
    .stock-medium {
        color: #f39c12;
        font-weight: 600;
    }
    .stock-high {
        color: #27ae60;
        font-weight: 600;
    }
    .no-items {
        background-color: #f8f9fa;
        color: #7f8c8d;
        font-style: italic;
    }
    .fabric-type-section {
        margin-bottom: 30px;
        border-bottom: 1px solid #eee;
        padding-bottom: 15px;
    }
    .fabric-type-title {
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
        <div class="fabric-container">
            <div class="fabric-header">
                <h2>Список тканин</h2>
                <p class="text-muted">Перегляд та управління тканинами за типами</p>
            </div>
            
            <div class="text-right" style="margin-bottom: 20px;">
                <a href="addFabric.jsp" class="btn btn-success btn-add">
                    <span class="glyphicon glyphicon-plus"></span> Додати тканину
                </a>
            </div>

            <%
            FabricServiceImpl fabricService = new FabricServiceImpl();
            List<FabricBean> allFabrics = fabricService.getAllFabrics();
            
            // Групуємо тканини за типами
            Map<String, List<FabricBean>> fabricsByType = new HashMap<>();
            
            for (FabricBean fabric : allFabrics) {
                String type = fabric.getFabricTypeName();
                if (!fabricsByType.containsKey(type)) {
                    fabricsByType.put(type, new ArrayList<>());
                }
                fabricsByType.get(type).add(fabric);
            }
            
            if (fabricsByType.isEmpty()) {
            %>
            <div class="no-items text-center">
                Не знайдено жодної тканини
            </div>
            <%
            } else {
                for (Map.Entry<String, List<FabricBean>> entry : fabricsByType.entrySet()) {
                    String fabricType = entry.getKey();
                    List<FabricBean> fabrics = entry.getValue();
            %>
            <div class="fabric-type-section">
                <div class="fabric-type-title"><%=fabricType%></div>
                
                <div class="table-responsive fabric-table">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Зображення</th>
                                <th>ID</th>
                                <th>Колір</th>
                                <%-- Removed "Доступно (м)" column --%>
                                <%-- <th>Доступно (м)</th> --%>
                                <th>Дії</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            if (fabrics.isEmpty()) {
                            %>
                            <tr class="no-items">
                                <td colspan="4" class="text-center">Не знайдено тканин цього типу</td> <%-- Changed colspan from 5 to 4 --%>
                            </tr>
                            <%
                            } else {
                                for (FabricBean fabric : fabrics) {
                                    // Removed stockClass logic as availableMeters is removed
                                    // String stockClass = fabric.getAvailableMeters() < 5 ? "stock-low" : 
                                    //                   fabric.getAvailableMeters() < 20 ? "stock-medium" : "stock-high";
                            %>
                            <tr>
                                <td>
                                    <img src="./ShowImage?fabricId=<%=fabric.getFabricId()%>" 
                                        class="fabric-img" alt="<%=fabric.getFabricTypeName()%>">
                                </td>
                                <td><%=fabric.getFabricId()%></td>
                                <td><%=fabric.getColor()%></td>
                                <%-- Removed availableMeters display --%>
                                <%-- <td class="<%=stockClass%>"><%=String.format("%.1f", fabric.getAvailableMeters())%></td> --%>
                                <td>
                                    <a href="updateFabric.jsp?fabricId=<%=fabric.getFabricId()%>" 
                                       class="btn btn-primary btn-action btn-edit">Змінити</a>
                                    <a href="./RemoveFabricSrv?fabricId=<%=fabric.getFabricId()%>" 
                                       class="btn btn-danger btn-action btn-delete"
                                       onclick="return confirm('Ви впевнені, що хочете видалити цю тканину?')">Видалити</a>
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