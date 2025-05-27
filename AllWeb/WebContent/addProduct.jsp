<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.shashi.service.impl.ProductServiceImpl, 
                 com.shashi.service.impl.FabricTypeServiceImpl, 
                 com.shashi.service.impl.SizeServiceImpl,
                 com.shashi.beans.FabricTypeBean, 
                 com.shashi.beans.SizeBean,
                 com.shashi.beans.ProductBean,
                 java.util.List, java.util.HashSet" %>
<!DOCTYPE html>
<html>
<head>
<title>Textileshop - Додати товар</title>
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
    .product-form-container {
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
    textarea.form-control {
        min-height: 100px;
        resize: vertical;
    }
    .btn-submit {
        background-color: #27ae60;
        color: white;
        border: none;
        border-radius: 4px;
        padding: 10px 20px;
        font-size: 16px;
        font-weight: 600;
        transition: all 0.3s;
    }
    .btn-submit:hover {
        background-color: #219653;
        color: white;
    }
    .btn-reset {
        background-color: #e74c3c;
        color: white;
        border: none;
        border-radius: 4px;
        padding: 10px 20px;
        font-size: 16px;
        font-weight: 600;
        transition: all 0.3s;
    }
    .btn-reset:hover {
        background-color: #c0392b;
        color: white;
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
    .file-input-label {
        display: block;
        padding: 6px 12px;
        background-color: #f8f9fa;
        border: 1px solid #ddd;
        border-radius: 4px;
        text-align: center;
        cursor: pointer;
        transition: all 0.3s;
    }
    .file-input-label:hover {
        background-color: #eaf2f8;
        border-color: #3498db;
    }
    .file-input {
        display: none;
    }
    .action-buttons {
        margin-top: 20px;
        text-align: center;
    }
    .datalist-input {
        width: 100%;
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

    // Завантаження даних
    ProductServiceImpl productService = new ProductServiceImpl();
    SizeServiceImpl sizeService = new SizeServiceImpl();
    FabricTypeServiceImpl fabricTypeService = new FabricTypeServiceImpl();
    
    List<ProductBean> allProducts = productService.getAllProductsadmin();
    List<SizeBean> sizes = sizeService.getAllSizes();
    List<FabricTypeBean> fabricTypes = fabricTypeService.getAllFabricTypes();
    
    // Отримання унікальних назв товарів
    HashSet<String> uniqueProductNames = new HashSet<>();
    for (ProductBean product : allProducts) {
        uniqueProductNames.add(product.getProdName());
    }
    %>

    <jsp:include page="header.jsp" />

    <%
    String message = request.getParameter("message");
    %>
    <div class="container">
        <div class="row">
            <div class="col-md-8 col-md-offset-2 product-form-container">
                <form action="./AddProductSrv" method="post" enctype="multipart/form-data">
                    <div class="form-header">
                        <h2>Додати новий товар</h2>
                        <p class="text-muted">Заповніть форму для додавання товару до каталогу</p>
                        
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
                        <label for="product_name">Назва товару</label>
                        <input list="product_names" class="form-control datalist-input" id="product_name" 
                               name="name" placeholder="Введіть назву або оберіть зі списку" required>
                        <datalist id="product_names">
                            <% for (String name : uniqueProductNames) { %>
                                <option value="<%= name %>">
                            <% } %>
                        </datalist>
                    </div>
                    
                    <div class="form-group">
                        <label for="product_type">Категорія товару</label>
                        <select class="form-control" id="product_type" name="type" required
                                onchange="updateSizesByType(this.value)">
                            <option value="Подушка">Подушка</option>
                            <option value="Постільна білизна">Постільна білизна</option>
                            <option value="Ковдра">Ковдра</option>
                            <option value="Плед">Плед</option>
                            <option value="Рушники">Рушники</option>
                            <option value="Крісла">Крісла</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="product_description">Опис товару</label>
                        <textarea class="form-control" id="product_description" 
                                  name="info" placeholder="Детальний опис товару..." required></textarea>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-4 form-group">
                            <label for="product_price">Ціна (грн)</label>
                            <input type="number" class="form-control" id="product_price" 
                                   name="price" placeholder="0.00" min="0" step="0.01" required>
                        </div>
                        <div class="col-md-4 form-group">
                            <label for="product_quantity">Кількість яку можуть замовити</label>
                            <input type="number" class="form-control" id="product_quantity" 
                                   name="quantity" placeholder="0" min="0" required>
                        </div>
                        <div class="col-md-4 form-group">
                            <label for="product_size">Розмір</label>
                            <select class="form-control" id="product_size" name="size" required>
                                <% for (SizeBean size : sizes) { %>
                                    <option value="<%= size.getSizeId() %>" 
                                            data-type="<%= size.getProductType() %>">
                                        <%= size.getSizeName() %> (<%= size.getLength() %>x<%= size.getWidth() %>)
                                    </option>
                                <% } %>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="fabric_type">Тип тканини</label>
                        <select class="form-control" id="fabric_type" name="fabricType" required>
                            <% for (FabricTypeBean fabricType : fabricTypes) { %>
                                <option value="<%= fabricType.getFabricTypeName() %>">
                                    <%= fabricType.getFabricTypeName() %>
                                </option>
                            <% } %>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label>Зображення товару</label>
                        <label for="product_image" class="file-input-label">
                            <input type="file" class="file-input" id="product_image" 
                                   name="image" accept="image/*" required>
                            <span>Виберіть файл</span>
                        </label>
                    </div>
                    
                    <div class="action-buttons">
                        <button type="reset" class="btn btn-reset">
                            Очистити
                        </button>
                        <button type="submit" class="btn btn-submit">
                            Додати товар
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
    function updateSizesByType(productType) {
        var sizeSelect = document.getElementById('product_size');
        var options = sizeSelect.options;
        
        // Show all options if no specific type is selected
        if (!productType) {
            for (var i = 0; i < options.length; i++) {
                options[i].style.display = '';
            }
            return;
        }
        
        // Filter sizes by product type
        for (var i = 0; i < options.length; i++) {
            var option = options[i];
            if (option.getAttribute('data-type') === productType) {
                option.style.display = '';
            } else {
                option.style.display = 'none';
            }
        }
        
        // Select the first visible option
        for (var i = 0; i < options.length; i++) {
            if (options[i].style.display !== 'none') {
                sizeSelect.selectedIndex = i;
                break;
            }
        }
    }
    
    // Initialize sizes based on default product type
    document.addEventListener('DOMContentLoaded', function() {
        var defaultType = document.getElementById('product_type').value;
        updateSizesByType(defaultType);
    });
    </script>

    <%@ include file="footer.html"%>

</body>
</html>