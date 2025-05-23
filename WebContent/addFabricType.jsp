<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Textileshop - Додати тип тканини</title>
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
    .fabric-form-container {
        background-color: white;
        border-radius: 10px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        padding: 30px;
        margin-top: 30px;
        margin-bottom: 30px;
    }
    .form-header {
        color: #2c3e50;
        margin-bottom: 25px;
        text-align: center;
        border-bottom: 2px solid #f1f1f1;
        padding-bottom: 15px;
    }
    .form-header h2 {
        font-weight: 600;
    }
    .form-group label {
        font-weight: 500;
        color: #34495e;
        margin-bottom: 8px;
    }
    .form-control {
        height: 38px;
        border-radius: 4px;
        border: 1px solid #ddd;
        padding: 6px 12px;
        transition: border 0.3s;
    }
    .form-control:focus {
        border-color: #3498db;
        box-shadow: 0 0 0 0.2rem rgba(52, 152, 219, 0.25);
    }
    .btn-submit {
        background-color: #27ae60;
        border: none;
        border-radius: 4px;
        padding: 6px 12px;
        font-size: 14px;
        font-weight: 600;
        transition: all 0.3s;
        line-height: 1.4;
    }
    .btn-submit:hover {
        background-color: #219653;
    }
    .btn-reset {
        background-color: #e74c3c;
        border: none;
        border-radius: 4px;
        padding: 6px 12px;
        font-size: 14px;
        font-weight: 600;
        transition: all 0.3s;
        line-height: 1.4;
    }
    .btn-reset:hover {
        background-color: #c0392b;
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
    }
    .action-buttons {
        margin-top: 20px;
        text-align: center;
    }
    .btn {
        min-height: 32px;
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
        <div class="row">
            <div class="col-md-8 col-md-offset-2 fabric-form-container">
                <form action="./AddFabricTypeSrv" method="post">
                    <div class="form-header">
                        <h2>Додати новий тип тканини</h2>
                        <p class="text-muted">Заповніть форму для додавання нового типу тканини</p>
                        
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
                    
                    <div class="form-group">
                        <label for="fabric_type_name">Назва типу тканини</label>
                        <input type="text" class="form-control" id="fabric_type_name" 
                               name="fabric_type_name" placeholder="Введіть назву типу тканини" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="price_per_meter">Ціна за метр (грн)</label>
                        <input type="number" class="form-control" id="price_per_meter" 
                               name="price_per_meter" placeholder="0.00" min="0" step="0.01" required>
                    </div>
                    
                    <div class="action-buttons">
                        <button type="reset" class="btn btn-reset">
                            Очистити
                        </button>
                        <button type="submit" class="btn btn-submit">
                            Додати тип тканини
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%@ include file="footer.html"%>

</body>
</html>