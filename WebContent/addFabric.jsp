<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.shashi.service.impl.FabricTypeServiceImpl, com.shashi.beans.FabricTypeBean, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
<title>Textileshop - Додати тканину</title>
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
        color: white;
        border: none;
        border-radius: 4px;
        padding: 8px 16px;
        font-size: 14px;
        font-weight: 600;
        transition: all 0.3s;
    }
    .btn-submit:hover {
        background-color: #219653;
        transform: translateY(-1px);
    }
    .btn-cancel {
        background-color: #95a5a6;
        color: white;
        border: none;
        border-radius: 4px;
        padding: 8px 16px;
        font-size: 14px;
        font-weight: 600;
        transition: all 0.3s;
    }
    .btn-cancel:hover {
        background-color: #7f8c8d;
        transform: translateY(-1px);
    }
    .file-input-label {
        display: block;
        padding: 8px 12px;
        background-color: #f8f9fa;
        border: 1px solid #ddd;
        border-radius: 4px;
        text-align: center;
        cursor: pointer;
        transition: all 0.3s;
        font-size: 14px;
    }
    .file-input-label:hover {
        background-color: #eaf2f8;
        border-color: #3498db;
    }
    .file-input {
        display: none;
    }
    .action-buttons {
        margin-top: 25px;
        text-align: center;
    }
    .message-box {
        background-color: #f8f9fa;
        border-left: 4px solid #3498db;
        padding: 12px;
        margin-bottom: 20px;
        border-radius: 4px;
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
        response.sendRedirect("login.jsp?message=Доступ заборонено, увійдіть як адміністратор!!");
    }
    else if (userName == null || password == null) {
        response.sendRedirect("login.jsp?message=Сесія закінчилась, увійдіть знову!!");
    }
    
    /* Отримання списку типів тканин */
    FabricTypeServiceImpl fabricTypeService = new FabricTypeServiceImpl();
    List<FabricTypeBean> fabricTypes = fabricTypeService.getAllFabricTypes();
    %>

    <jsp:include page="header.jsp" />

    <%
    String message = request.getParameter("message");
    %>
    <div class="container">
        <div class="row">
            <div class="col-md-8 col-md-offset-2 fabric-form-container">
                <form action="./AddFabricSrv" method="post" enctype="multipart/form-data">
                    <div class="form-header">
                        <h2>Додати нову тканину</h2>
                        <p class="text-muted">Заповніть форму для додавання нової тканини</p>
                        
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
                        <label for="fabric_type">Тип тканини</label>
                        <select class="form-control" id="fabric_type" name="fabricTypeName" required>
                            <option value="" disabled selected>Оберіть тип тканини</option>
                            <%
                            for (FabricTypeBean fabricType : fabricTypes) {
                            %>
                            <option value="<%=fabricType.getFabricTypeName()%>"><%=fabricType.getFabricTypeName()%></option>
                            <%
                            }
                            %>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="fabric_color">Колір</label>
                        <input type="text" class="form-control" id="fabric_color" 
                               name="color" placeholder="Введіть колір тканини" required>
                    </div>
                    
                    <%-- Removed the "Доступно метрів" field --%>
                    <%--
                    <div class="form-group">
                        <label for="fabric_meters">Доступно метрів</label>
                        <input type="number" class="form-control" id="fabric_meters" 
                               name="availableMeters" placeholder="0.0" min="0" step="0.1" required>
                    </div>
                    --%>
                    
                    <div class="form-group">
                        <label>Зображення тканини</label>
                        <label for="fabric_image" class="file-input-label">
                            <input type="file" class="file-input" id="fabric_image" 
                                   name="image" accept="image/*" required>
                            <span id="file-name">Виберіть файл</span>
                        </label>
                    </div>
                    
                    <div class="action-buttons">
                        <a href="viewFabrics.jsp" class="btn btn-cancel">Скасувати</a>
                        <button type="submit" class="btn btn-submit">Додати тканину</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%@ include file="footer.html"%>

    <script>
    $(document).ready(function() {
        // Ініціалізація всіх dropdown-меню
        $('.dropdown-toggle').dropdown();
        
        // Обробник вибору файлу
        $('#fabric_image').change(function(e) {
            var fileName = e.target.files[0] ? e.target.files[0].name : "Виберіть файл";
            $('#file-name').text(fileName);
        });
    });
    </script>

</body>
</html>