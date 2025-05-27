<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Textileshop - Вхід</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<link rel="stylesheet" href="css/changes.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
<style>
    .login-container {
        max-width: 450px;
        margin: 40px auto;
        padding: 30px;
        background: white;
        border-radius: 12px;
        box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
    }
    .login-header {
        color: #2c3e50;
        text-align: center;
        margin-bottom: 30px;
    }
    .login-header h2 {
        font-weight: 600;
        margin-bottom: 15px;
    }
    .login-logo {
        width: 80px;
        margin-bottom: 15px;
    }
    .form-group label {
        font-weight: 500;
        color: #34495e;
        margin-bottom: 8px;
    }
    .form-control {
        height: 45px;
        border-radius: 8px;
        border: 1px solid #ddd;
        padding: 10px 15px;
    }
    .btn-login {
        background-color: #3498db;
        border: none;
        border-radius: 8px;
        padding: 12px 0;
        font-weight: 600;
        letter-spacing: 0.5px;
        width: 100%;
        margin-top: 10px;
        transition: all 0.3s;
    }
    .btn-login:hover {
        background-color: #2980b9;
        transform: translateY(-2px);
    }
    .message-box {
        background-color: #f8f9fa;
        border-left: 4px solid #3498db;
        padding: 12px;
        margin-bottom: 20px;
        border-radius: 4px;
    }
    body {
        background-color: #f5f7fa;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }
</style>
</head>
<body>

<%@ include file="header.jsp"%>

<%
String message = request.getParameter("message");
%>

<div class="container">
    <div class="login-container">
        <div class="login-header">
            <h2>Вхід до системи</h2>
            <p class="text-muted">Будь ласка, введіть ваші облікові дані</p>
            
            <%
            if (message != null) {
            %>
            <div class="message-box">
                <%=message%>
            </div>
            <%
            }
            %>
        </div>
        
        <form action="./LoginSrv" method="post">
            <div class="form-group">
                <label for="username">Електронна пошта</label>
                <input type="email" class="form-control" id="username" 
                       name="username" placeholder="Ваша електронна пошта" required>
            </div>
            
            <div class="form-group">
                <label for="password">Пароль</label>
                <input type="password" class="form-control" id="password" 
                       name="password" placeholder="Ваш пароль" required>
            </div>
            
            <div class="form-group text-center">
                <button type="submit" class="btn btn-primary btn-login">Увійти</button>
                <p class="text-muted mt-3">Ще не зареєстровані? 
                    <a href="register.jsp" style="color: #3498db;">Створити акаунт</a>
                </p>
            </div>
        </form>
    </div>
</div>

<%@ include file="footer.html"%>

</body>
</html>