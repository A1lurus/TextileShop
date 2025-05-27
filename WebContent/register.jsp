<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Textileshop - Реєстрація</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<link rel="stylesheet" href="css/changes.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
<style>
    .register-container {
        max-width: 700px;
        margin: 40px auto;
        padding: 40px;
        background: white;
        border-radius: 12px;
        box-shadow: 0 6px 30px rgba(0, 0, 0, 0.08);
    }
    .register-header {
        color: #2c3e50;
        text-align: center;
        margin-bottom: 30px;
    }
    .register-header h2 {
        font-weight: 600;
        margin-bottom: 10px;
    }
    .register-logo {
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
        border: 1px solid #e0e0e0;
        padding: 10px 15px;
        transition: border 0.3s;
    }
    .form-control:focus {
        border-color: #3498db;
        box-shadow: 0 0 0 0.2rem rgba(52, 152, 219, 0.25);
    }
    textarea.form-control {
        min-height: 100px;
        resize: vertical;
    }
    .btn-register {
        background-color: #3498db;
        border: none;
        border-radius: 8px;
        padding: 12px 0;
        font-weight: 600;
        width: 100%;
        transition: all 0.3s;
    }
    .btn-register:hover {
        background-color: #2980b9;
        transform: translateY(-2px);
    }
    .btn-reset {
        background-color: #f39c12;
        border: none;
        border-radius: 8px;
        padding: 12px 0;
        font-weight: 600;
        width: 100%;
        transition: all 0.3s;
    }
    .btn-reset:hover {
        background-color: #e67e22;
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
    .password-hint {
        font-size: 12px;
        color: #7f8c8d;
        margin-top: 5px;
    }
</style>
</head>
<body>

<%@ include file="header.jsp"%>

<%
String message = request.getParameter("message");
%>

<div class="container">
    <div class="register-container">
        <div class="register-header">
            <h2>Створення облікового запису</h2>
            <p class="text-muted">Заповніть форму для реєстрації</p>
            
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
        
        <form action="./RegisterSrv" method="post">
            <div class="row">
                <div class="col-md-6 form-group">
                    <label for="username">Ім'я користувача</label>
                    <input type="text" class="form-control" id="username" 
                           name="username" placeholder="Ваше ім'я" required>
                </div>
                <div class="col-md-6 form-group">
                    <label for="email">Електронна пошта</label>
                    <input type="email" class="form-control" id="email" 
                           name="email" placeholder="example@example.com" required>
                </div>
            </div>
            
            <div class="form-group">
                <label for="address">Адреса доставки</label>
                <textarea class="form-control" id="address" 
                          name="address" placeholder="Вулиця, будинок, квартира" required></textarea>
            </div>
            
            <div class="row">
                <div class="col-md-6 form-group">
                    <label for="mobile">Номер телефону</label>
                    <input type="tel" class="form-control" id="mobile" 
                           name="mobile" placeholder="+380XXXXXXXXX" required>
                </div>
                <div class="col-md-6 form-group">
                    <label for="pincode">Поштовий індекс</label>
                    <input type="text" class="form-control" id="pincode" 
                           name="pincode" placeholder="XXXXX" required>
                </div>
            </div>
            
            <div class="row">
                <div class="col-md-6 form-group">
                    <label for="password">Пароль</label>
                    <input type="password" class="form-control" id="password" 
                           name="password" placeholder="Не менше 6 символів" required>
                    <p class="password-hint">Пароль має містити щонайменше 6 символів</p>
                </div>
                <div class="col-md-6 form-group">
                    <label for="confirmPassword">Підтвердження паролю</label>
                    <input type="password" class="form-control" id="confirmPassword" 
                           name="confirmPassword" placeholder="Повторіть пароль" required>
                </div>
            </div>
            
            <div class="row" style="margin-top: 20px;">
                <div class="col-md-6" style="margin-bottom: 15px;">
                    <button type="reset" class="btn btn-reset">Очистити форму</button>
                </div>
                <div class="col-md-6">
                    <button type="submit" class="btn btn-register">Зареєструватися</button>
                </div>
            </div>
            
            <div class="text-center" style="margin-top: 20px;">
                <p class="text-muted">Вже є акаунт? 
                    <a href="login.jsp" style="color: #3498db;">Увійти</a>
                </p>
            </div>
        </form>
    </div>
</div>

<%@ include file="footer.html"%>

</body>
</html>