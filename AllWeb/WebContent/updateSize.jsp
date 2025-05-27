<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.shashi.service.impl.SizeServiceImpl, com.shashi.beans.SizeBean" %>
<!DOCTYPE html>
<html>
<head>
<title>Textileshop - Оновити розмір</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<link rel="stylesheet" href="css/changes.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<style>
    .form-container {
        background-color: white;
        border-radius: 10px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        padding: 25px;
        margin-top: 30px;
        margin-bottom: 30px;
    }
    .form-header {
        color: #2c3e50;
        margin-bottom: 25px;
        padding-bottom: 15px;
        border-bottom: 2px solid #f1f1f1;
    }
    .form-group label {
        font-weight: 500;
        color: #34495e;
    }
    .btn-submit {
        background-color: #3498db;
        border: none;
        padding: 10px 20px;
        font-size: 16px;
        transition: all 0.3s;
    }
    .btn-submit:hover {
        background-color: #2980b9;
        transform: translateY(-2px);
    }
    .btn-back {
        background-color: #95a5a6;
        border: none;
        padding: 10px 20px;
        font-size: 16px;
        transition: all 0.3s;
    }
    .btn-back:hover {
        background-color: #7f8c8d;
        transform: translateY(-2px);
    }
    .id-display {
        font-weight: bold;
        color: #2c3e50;
        padding: 8px;
        background-color: #f8f9fa;
        border-radius: 4px;
    }
</style>
</head>
<body>

    <%@ include file="header.jsp" %>
    
    <%
    String sizeId = request.getParameter("sizeId");
    SizeServiceImpl sizeService = new SizeServiceImpl();
    SizeBean size = sizeService.getSizeDetails(sizeId);
    
    if(size == null) {
        response.sendRedirect("viewSizes.jsp?error=Розмір не знайдено");
        return;
    }
    %>
    
    <div class="container">
        <div class="form-container">
            <div class="form-header">
                <h2>Оновити розмір</h2>
                <p class="text-muted">Змініть необхідні поля для оновлення розміру</p>
            </div>
            
            <form action="./UpdateSizeSrv" method="post">
                <div class="form-group">
                    <label>ID розміру:</label>
                    <div class="id-display"><%=size.getSizeId()%></div>
                    <input type="hidden" name="sizeId" value="<%=size.getSizeId()%>">
                </div>
                
                <div class="form-group">
                    <label for="sizeName">Назва розміру:</label>
                    <input type="text" class="form-control" id="sizeName" name="sizeName" 
                           value="<%=size.getSizeName()%>" required>
                </div>
                
				<div class="form-group">
				    <label for="productType">Тип продукту:</label>
				    <select class="form-control" id="productType" name="productType" required>
				        <option value="Постільна білизна" <%=size.getProductType().equals("Постільна білизна") ? "selected" : ""%>>Постільна білизна</option>
				        <option value="Ковдра" <%=size.getProductType().equals("Ковдра") ? "selected" : ""%>>Ковдра</option>
				        <option value="Плед" <%=size.getProductType().equals("Плед") ? "selected" : ""%>>Плед</option>
				        <option value="Рушники" <%=size.getProductType().equals("Рушники") ? "selected" : ""%>>Рушники</option>
				        <option value="Крісла" <%=size.getProductType().equals("Крісла") ? "selected" : ""%>>Крісла</option>
				        <option value="Подушка" <%=size.getProductType().equals("Подушка") ? "selected" : ""%>>Подушка</option>
				    </select>
				</div>
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="length">Довжина (см):</label>
                            <input type="number" step="0.1" class="form-control" id="length" name="length" 
                                   min="0" value="<%=size.getLength()%>" required>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="width">Ширина (см):</label>
                            <input type="number" step="0.1" class="form-control" id="width" name="width" 
                                   min="0" value="<%=size.getWidth()%>" required>
                        </div>
                    </div>
                </div>
                
                <div class="form-group text-right">
                    <a href="viewSizes.jsp" class="btn btn-back">Назад</a>
                    <button type="submit" class="btn btn-submit">Оновити розмір</button>
                </div>
            </form>
        </div>
    </div>
    
    <%@ include file="footer.html" %>

</body>
</html>