<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page
    import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Textileshop - Оновлення товару</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
    href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<link rel="stylesheet" href="css/changes.css">
<script
    src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
    src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
<script>
    function validateForm() {
        var price = document.getElementById("productPrice").value;
        var quantity = document.getElementById("productQuantity").value;
        var size = document.getElementById("productSize").value;
        var fabricType = document.getElementById("fabricType").value;
        
        if(price <= 0) {
            alert("Ціна повинна бути більше 0");
            return false;
        }
        if(quantity < 0) {
            alert("Кількість не може бути від'ємною");
            return false;
        }
        if(size.trim() === "") {
            alert("Будь ласка, оберіть розмір");
            return false;
        }
        if(fabricType.trim() === "") {
            alert("Будь ласка, оберіть тип тканини");
            return false;
        }
        return true;
    }
</script>
<style>
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
    .product-image {
        max-height: 150px;
        margin-bottom: 15px;
        border-radius: 5px;
        border: 1px solid #ddd;
    }
    .btn-update {
        background-color: #0066cc;
        color: white;
        border: none;
        padding: 10px 25px;
        font-weight: bold;
    }
    .btn-update:hover {
        background-color: #0055aa;
        color: white;
    }
    .btn-cancel {
        background-color: #dc3545;
        color: white;
        border: none;
        padding: 10px 25px;
        font-weight: bold;
    }
    textarea {
        min-height: 100px;
        resize: vertical;
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
    .status-select {
        width: 100%;
        padding: 8px;
        border-radius: 4px;
        border: 1px solid #ddd;
    }
    .status-visible {
        color: #27ae60;
    }
    .status-hidden {
        color: #e74c3c;
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
</style>
</head>
<body style="background-color: #E6F9E6;">
<div style="height: 40px;"></div>
    <%
    /* Перевірка авторизації */
    String utype = (String) session.getAttribute("usertype");
    String uname = (String) session.getAttribute("username");
    String pwd = (String) session.getAttribute("password");
    String prodid = request.getParameter("prodid");
    
    if (prodid == null || prodid.trim().isEmpty()) {
        response.sendRedirect("updateProductById.jsp?message=Будь ласка, введіть коректний ID товару");
        return;
    }
    
    ProductServiceImpl productService = new ProductServiceImpl();
    ProductBean product = productService.getProductDetails(prodid);
    
    // Завантаження списків розмірів і типів тканин
    SizeServiceImpl sizeService = new SizeServiceImpl();
    FabricTypeServiceImpl fabricTypeService = new FabricTypeServiceImpl();
    
    List<SizeBean> sizes = sizeService.getAllSizes();
    List<FabricTypeBean> fabricTypes = fabricTypeService.getAllFabricTypes();
    
    if (product == null) {
        response.sendRedirect("updateProductById.jsp?message=Товар з ID " + prodid + " не знайдено");
        return;
    } else if (utype == null || !utype.equals("admin")) {
        response.sendRedirect("login.jsp?message=Доступ заборонено, увійдіть як адміністратор!!");
        return;
    } else if (uname == null || pwd == null) {
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
                <form action="./UpdateProductSrv" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
                    <div class="form-header">
                        <img src="./ShowImage?pid=<%=product.getProdId()%>"
                            alt="Зображення товару" class="product-image">
                        <h2>Форма оновлення товару</h2>
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
                    
                    <input type="hidden" name="pid" value="<%=product.getProdId()%>">
                    
                    <div class="form-group">
                        <label for="productName">Назва товару *</label>
                        <input type="text" placeholder="Введіть назву товару" 
                            name="name" class="form-control"
                            value="<%=product.getProdName() != null ? product.getProdName() : ""%>" 
                            id="productName" required>
                    </div>
                    
                    <div class="form-group">
                        <%
                        String ptype = product.getProdType() != null ? product.getProdType() : "Інші товари";
                        %>
                        <label for="producttype">Тип товару *</label>
                        <select name="type" id="producttype" class="form-control" required>
                            <option value="Подушка" <%="Подушка".equalsIgnoreCase(ptype) ? "selected" : ""%>>Подушка</option>
                            <option value="Постільна білизна" <%="Постільна білизна".equalsIgnoreCase(ptype) ? "selected" : ""%>>Постільна білизна</option>
                            <option value="Ковдра" <%="Ковдра".equalsIgnoreCase(ptype) ? "selected" : ""%>>Ковдра</option>
                            <option value="Плед" <%="Плед".equalsIgnoreCase(ptype) ? "selected" : ""%>>Плед</option>
                            <option value="Рушники" <%="Рушники".equalsIgnoreCase(ptype) ? "selected" : ""%>>Рушники</option>
                            <option value="Крісла" <%="Крісла".equalsIgnoreCase(ptype) ? "selected" : ""%>>Крісла</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="productDescription">Опис товару *</label>
                        <textarea name="info" class="form-control"
                            id="productDescription" required><%=product.getProdInfo() != null ? product.getProdInfo() : ""%></textarea>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-4 form-group">
                            <label for="productPrice">Ціна за одиницю (₴) *</label>
                            <input type="number" step="0.01" min="0.01" 
                                value="<%=product.getProdPrice()%>"
                                placeholder="Введіть ціну" name="price" 
                                class="form-control" id="productPrice" required>
                            <div class="error-message" id="priceError"></div>
                        </div>
                        <div class="col-md-4 form-group">
                            <label for="productQuantity">Кількість яку можуть замовити *</label>
                            <input type="number" min="0" 
                                value="<%=product.getProdQuantity()%>"
                                placeholder="Введіть кількість" class="form-control"
                                id="productQuantity" name="quantity" required>
                            <div class="error-message" id="quantityError"></div>
                        </div>
                        <div class="col-md-4 form-group">
                            <label for="productSize">Розмір *</label>
                            <select class="form-control" id="productSize" name="size" required>
                                <% for (SizeBean size : sizes) { %>
                                    <option value="<%= size.getSizeId() %>" 
                                        <%= size.getSizeId().equals(product.getSize()) ? "selected" : "" %>>
                                        <%= size.getSizeName() %> (<%= size.getLength() %>x<%= size.getWidth() %>)
                                    </option>
                                <% } %>
                            </select>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 form-group">
                            <label for="fabricType">Тип тканини *</label>
                            <select class="form-control" id="fabricType" name="fabricType" required>
                                <% for (FabricTypeBean fabricType : fabricTypes) { %>
                                    <option value="<%= fabricType.getFabricTypeName() %>"
                                        <%= fabricType.getFabricTypeName().equals(product.getFabricType()) ? "selected" : "" %>>
                                        <%= fabricType.getFabricTypeName() %>
                                    </option>
                                <% } %>
                            </select>
                        </div>
                        <div class="col-md-6 form-group">
                            <label for="productStatus">Статус товару *</label>
                            <select name="hide" id="productStatus" class="form-control status-select" required>
                                <option value="false" <%=!product.getHide() ? "selected" : ""%>>Відображати товар</option>
                                <option value="true" <%=product.getHide() ? "selected" : ""%>>Приховати товар</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label>Замінити зображення товару</label>
                        <label for="productImage" class="file-input-label">
                            <input type="file" class="file-input" id="productImage" 
                                   name="image" accept="image/*">
                            <span>Виберіть нове зображення</span>
                        </label>
                        <p class="help-block">Залиште порожнім, щоб зберегти поточне зображення</p>
                    </div>
                    
                    <div class="row text-center" style="margin-top: 20px;">
                        <div class="col-md-6" style="margin-bottom: 10px;">
                            <a href="adminViewProduct.jsp" class="btn btn-cancel">
                                Скасувати
                            </a>
                        </div>
                        <div class="col-md-6">
                            <button type="submit" class="btn btn-update">
                                Оновити товар
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%@ include file="footer.html"%>
</body>
</html>