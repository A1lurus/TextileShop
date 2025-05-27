<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Textileshop - Видалити товар</title>
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
    body {
        background-color: #f8f9fa;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }
    .delete-form-container {
        max-width: 500px;
        margin: 30px auto;
        padding: 25px;
        background-color: white;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        border: 1px solid #e0e0e0;
    }
    .form-title {
        color: #2c3e50;
        text-align: center;
        margin-bottom: 25px;
        font-weight: 600;
        border-bottom: 1px solid #eee;
        padding-bottom: 15px;
    }
    .form-group label {
        font-weight: 500;
        color: #495057;
        margin-bottom: 8px;
    }
    .form-control {
        height: 42px;
        border-radius: 4px;
        border: 1px solid #ced4da;
        transition: border-color 0.3s;
    }
    .form-control:focus {
        border-color: #80bdff;
        box-shadow: 0 0 0 0.2rem rgba(0,123,255,0.25);
    }
    .btn-cancel {
        background-color: #6c757d;
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 4px;
        font-weight: 500;
        transition: all 0.3s;
    }
    .btn-cancel:hover {
        background-color: #5a6268;
        color: white;
    }
    .btn-delete {
        background-color: #dc3545;
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 4px;
        font-weight: 500;
        transition: all 0.3s;
    }
    .btn-delete:hover {
        background-color: #c82333;
        color: white;
    }
    .message-text {
        color: #17a2b8;
        text-align: center;
        margin: 15px 0;
        font-weight: 500;
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
        response.sendRedirect("login.jsp?message=Доступ заборонено, увійдіть як адміністратор!!");
    }
    else if (userName == null || password == null) {
        response.sendRedirect("login.jsp?message=Сесія закінчилась, увійдіть знову!!");
    }
    %>

    <jsp:include page="header.jsp" />

    <%
    String message = request.getParameter("message");
    %>
    <div class="container">
        <div class="delete-form-container">
            <form action="./RemoveProductSrv" method="post">
                <div class="form-title">Форма видалення товару</div>
                <%
                if (message != null) {
                %>
                <div class="message-text">
                    <%=message%>
                </div>
                <%
                }
                %>
                <div class="form-group">
                    <label for="product_id">ID товару</label> 
                    <input type="text"
                        placeholder="Введіть ID товару" name="prodid" class="form-control"
                        id="product_id" required>
                </div>
                <div class="row" style="margin-top: 20px;">
                    <div class="col-md-6 text-center">
                        <a href="adminViewProduct.jsp" class="btn btn-cancel">
                            Скасувати
                        </a>
                    </div>
                    <div class="col-md-6 text-center">
                        <button type="submit" class="btn btn-delete">
                            Видалити
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <%@ include file="footer.html"%>
</body>
</html>