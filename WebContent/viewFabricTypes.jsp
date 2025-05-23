<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page
    import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Textileshop - Типи тканин</title>
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
    .fabric-link {
        color: #3498db;
        font-weight: 500;
    }
    .fabric-link:hover {
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
    }
    .btn-edit {
        background-color: #3498db;
        border: none;
    }
    .btn-edit:hover {
        background-color: #2980b9;
        transform: translateY(-1px);
    }
    .btn-delete {
        background-color: #e74c3c;
        border: none;
    }
    .btn-delete:hover {
        background-color: #c0392b;
        transform: translateY(-1px);
    }
    .no-items {
        background-color: #f8f9fa;
        color: #7f8c8d;
        font-style: italic;
    }
    body {
        background-color: #f5f7fa;
    }
    .price-highlight {
        font-weight: 600;
        color: #27ae60;
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
                <h2>Типи тканин</h2>
                <p class="text-muted">Перегляд та управління типами тканин</p>
            </div>
            
                <div class="text-right" style="margin-top: 20px;">
                    <a href="addFabricType.jsp" class="btn btn-success">
                        <span class="glyphicon glyphicon-plus"></span> Додати новий тип
                    </a>
                </div>
            
            <div class="table-responsive fabric-table">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Назва типу</th>
                            <th>Ціна за метр (грн)</th>
                            <th style="text-align: center;">Дії</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        FabricTypeServiceImpl fabricTypeDao = new FabricTypeServiceImpl();
                        List<FabricTypeBean> fabricTypes = fabricTypeDao.getAllFabricTypes();
                        
                        for (FabricTypeBean fabricType : fabricTypes) {
                            String typeName = fabricType.getFabricTypeName();
                        %>
                        <tr>
                            <td><%=typeName%></td>
                            <td class="price-highlight">
                                <%=String.format("%.2f", fabricType.getPricePerMeter())%>
                            </td>
                            <td>
                                <a href="updateFabricType.jsp?type=<%=typeName%>"
                                    class="btn btn-primary btn-action btn-edit">
                                    Змінити
                                </a>
                                <a href="./DeleteFabricTypeSrv?type=<%=typeName%>"
                                    class="btn btn-danger btn-action btn-delete"
                                    onclick="return confirm('Ви впевнені, що хочете видалити цей тип тканини?')">
                                    Видалити
                                </a>
                            </td>
                        </tr>
                        <%
                        }
                        
                        if (fabricTypes.isEmpty()) {
                        %>
                        <tr class="no-items">
                            <td colspan="3" class="text-center">Не знайдено жодного типу тканини</td>
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