<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Textileshop - Додати розмір</title>
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
        background-color: #27ae60;
        border: none;
        padding: 10px 20px;
        font-size: 16px;
        transition: all 0.3s;
    }
    .btn-submit:hover {
        background-color: #219955;
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
</style>
</head>
<body>

    <%@ include file="header.jsp" %>
    
    <div class="container">
        <div class="form-container">
            <div class="form-header">
                <h2>Додати новий розмір</h2>
                <p class="text-muted">Заповніть форму для додавання нового розміру</p>
            </div>
            
            <form action="./AddSizeSrv" method="post">
                <div class="form-group">
                    <label for="sizeName">Назва розміру:</label>
                    <input type="text" class="form-control" id="sizeName" name="sizeName" required>
                </div>
                
				<div class="form-group">
				    <label for="productType">Тип продукту:</label>
				    <select class="form-control" id="productType" name="productType" required>
				        <option value="">-- Оберіть тип --</option>
				        <option value="Постільна білизна">Постільна білизна</option>
				        <option value="Ковдра">Ковдра</option>
				        <option value="Плед">Плед</option>
				        <option value="Рушники">Рушники</option>
				        <option value="Крісла">Крісла</option>
				        <option value="Подушка">Подушка</option>
				    </select>
				</div>
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="length">Довжина (см):</label>
                            <input type="number" step="0.1" class="form-control" id="length" name="length" min="0" required>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="width">Ширина (см):</label>
                            <input type="number" step="0.1" class="form-control" id="width" name="width" min="0" required>
                        </div>
                    </div>
                </div>
                
                <div class="form-group text-right">
                    <a href="viewSizes.jsp" class="btn btn-back">Назад</a>
                    <button type="submit" class="btn btn-submit">Додати розмір</button>
                </div>
            </form>
        </div>
    </div>
    
    <%@ include file="footer.html" %>

</body>
</html>