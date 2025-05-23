<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.shashi.service.impl.FabricServiceImpl, com.shashi.beans.FabricBean, 
                 com.shashi.service.impl.FabricTypeServiceImpl, com.shashi.beans.FabricTypeBean,
                 java.util.List" %>
<!DOCTYPE html>
<html>
<head>
<title>Textileshop - Оновити тканину</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<link rel="stylesheet" href="css/changes.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<script>
    // Removed validateForm() function as availableMeters field is removed
    /*
    function validateForm() {
        var meters = document.getElementById("availableMeters").value;
        
        if(meters < 0) {
            alert("Кількість метрів не може бути від'ємною");
            return false;
        }
        return true;
    }
    */
</script>
<style>
    body {
        padding-top: 40px;
        background-color: #E6F9E6;
    }
    .update-form-container {
        background-color: white;
        border-radius: 10px;
        box-shadow: 0 0 15px rgba(0,0,0,0.1);
        padding: 25px;
        margin-top: 30px;
        margin-bottom: 30px;
    }
    .form-header {
        color: #0066cc;
        margin-bottom: 25px;
        text-align: center;
    }
    .current-image {
        max-height: 150px;
        margin-bottom: 15px;
        border-radius: 5px;
        border: 1px solid #ddd;
    }
    .btn-update {
        background-color: #0066cc;
        border: none;
        padding: 10px 25px;
        font-weight: bold;
    }
    .btn-update:hover {
        background-color: #0055aa;
    }
    .btn-cancel {
        background-color: #dc3545;
        border: none;
        padding: 10px 25px;
        font-weight: bold;
    }
    .message-box {
        margin: 15px 0;
        padding: 10px;
        border-radius: 5px;
    }
    .error-message {
        color: #dc3545;
        font-size: 0.9em;
        margin-top: 5px;
    }
    .has-error {
        border-color: #dc3545;
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
</style>
</head>
<body>

    <%
    /* Перевірка авторизації адміністратора */
    String userType = (String) session.getAttribute("usertype");
    String userName = (String) session.getAttribute("username");
    String password = (String) session.getAttribute("password");
    
    String fabricId = request.getParameter("fabricId");
    FabricServiceImpl service = new FabricServiceImpl();
    FabricBean fabric = service.getFabricDetails(fabricId);
    
    /* Отримання списку типів тканин */
    FabricTypeServiceImpl fabricTypeService = new FabricTypeServiceImpl();
    List<FabricTypeBean> fabricTypes = fabricTypeService.getAllFabricTypes();

    if (fabric == null) {
        response.sendRedirect("viewFabrics.jsp?error=Тканину не знайдено");
        return;
    }
    else if (userType == null || !userType.equals("admin")) {
        response.sendRedirect("login.jsp?message=Доступ заборонено, увійдіть як адміністратор!!");
        return;
    }
    else if (userName == null || password == null) {
        response.sendRedirect("login.jsp?message=Сесія закінчилась, увійдіть знову!!");
        return;
    }
    %>

    <jsp:include page="header.jsp" />

    <%
    String message = request.getParameter("message");
    String error = request.getParameter("error");
    %>
    
    <div class="container">
        <div class="row">
            <div class="col-md-8 col-md-offset-2 update-form-container">
                <form action="./UpdateFabricSrv" method="post" enctype="multipart/form-data"> <%-- Removed onsubmit="return validateForm()" --%>
                    <div class="form-header">
                        <img src="./ShowImage?fabricId=<%=fabric.getFabricId()%>"
                            alt="Поточне зображення тканини" class="current-image">
                        <h2>Форма оновлення тканини</h2>
                        <hr>
                        
                        <%
                        if (message != null) {
                        %>
                        <div class="alert alert-success message-box">
                            <%=message%>
                        </div>
                        <%
                        }
                        if (error != null) {
                        %>
                        <div class="alert alert-danger message-box">
                            <%=error%>
                        </div>
                        <%
                        }
                        %>
                    </div>
                    
                    <input type="hidden" name="fabricId" value="<%=fabric.getFabricId()%>">
                    
                    <div class="form-group">
                        <label for="fabricTypeName">Тип тканини *</label>
                        <select class="form-control" id="fabricTypeName" name="fabricTypeName" required>
                            <option value="" disabled>Оберіть тип тканини</option>
                            <%
                            for (FabricTypeBean fabricType : fabricTypes) {
                                boolean isSelected = fabricType.getFabricTypeName().equals(fabric.getFabricTypeName());
                            %>
                            <option value="<%=fabricType.getFabricTypeName()%>" <%=isSelected ? "selected" : ""%>>
                                <%=fabricType.getFabricTypeName()%>
                            </option>
                            <%
                            }
                            %>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="color">Колір *</label>
                        <input type="text" class="form-control" id="color" 
                            name="color" placeholder="Введіть колір тканини"
                            value="<%=fabric.getColor()%>" required>
                    </div>
                    
                    <%-- Removed the "Доступно метрів" field --%>
                    <%--
                    <div class="form-group">
                        <label for="availableMeters">Доступно метрів *</label>
                        <input type="number" class="form-control" id="availableMeters" 
                            name="availableMeters" placeholder="0.0" min="0" step="0.1"
                            value="<%=fabric.getAvailableMeters()%>" required>
                        <div class="error-message" id="metersError"></div>
                    </div>
                    --%>
                    
                    <div class="form-group">
                        <label>Поточне зображення</label>
                        <p class="text-muted">Завантажте нове зображення, якщо потрібно оновити</p>
                        <label for="fabricImage" class="file-input-label">
                            <input type="file" class="file-input" id="fabricImage" 
                                   name="image" accept="image/*">
                            <span id="file-name">Виберіть нове зображення</span>
                        </label>
                    </div>
                    
                    <div class="action-buttons">
                        <a href="viewFabrics.jsp" class="btn btn-cancel">Скасувати</a>
                        <button type="submit" class="btn btn-update">Оновити тканину</button>
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
        $('#fabricImage').change(function(e) {
            var fileName = e.target.files[0] ? e.target.files[0].name : "Виберіть нове зображення";
            $('#file-name').text(fileName);
        });
    });
    </script>

</body>
</html>