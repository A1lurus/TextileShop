<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page
    import="com.shashi.service.impl.ProductServiceImpl,
                 com.shashi.service.impl.FabricTypeServiceImpl,
                 com.shashi.service.impl.SizeServiceImpl,
                 com.shashi.beans.FabricTypeBean,
                 com.shashi.beans.SizeBean,
                 com.shashi.beans.ProductBean,
                 java.util.List,
                 java.util.HashSet" %>
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
<style>
    .update-form-container {
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
    .btn-update {
        background-color: #3498db;
        color: white;
        border: none;
        border-radius: 4px;
        padding: 10px 20px;
        font-size: 16px;
        font-weight: 600;
        transition: all 0.3s;
    }
    .btn-update:hover {
        background-color: #2185d0;
        color: white;
    }
    .btn-cancel {
        background-color: #95a5a6;
        color: white;
        border: none;
        border-radius: 4px;
        padding: 10px 20px;
        font-size: 16px;
        font-weight: 600;
        transition: all 0.3s;
    }
    .btn-cancel:hover {
        background-color: #7f8c8d;
        color: white;
    }
    .product-image {
        max-height: 150px;
        margin-bottom: 15px;
        border-radius: 5px;
        border: 1px solid #ddd;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }
    .message-box {
        background-color: #f8f9fa;
        border-left: 4px solid #3498db;
        padding: 12px;
        margin-bottom: 20px;
        border-radius: 4px;
    }
    .alert-success {
        border-color: #28a745;
        color: #155724;
        background-color: #d4edda;
    }
    .alert-danger {
        border-color: #dc3545;
        color: #721c24;
        background-color: #f8d7da;
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
    .status-select {
        height: 38px;
        border-radius: 4px;
        border: 1px solid #ddd;
        padding: 6px 12px;
        transition: border 0.3s;
        width: 100%; /* Ensure it takes full width */
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
    String prodid = request.getParameter("prodid");

    // Перевірка наявності ID продукту та його коректності
    if (prodid == null || prodid.trim().isEmpty()) {
        response.sendRedirect("adminViewProduct.jsp?message=Будь ласка, оберіть товар для оновлення.");
        return;
    }

    ProductServiceImpl productService = new ProductServiceImpl();
    ProductBean product = productService.getProductDetails(prodid);

    // Завантаження списків розмірів і типів тканин
    SizeServiceImpl sizeService = new SizeServiceImpl();
    FabricTypeServiceImpl fabricTypeService = new FabricTypeServiceImpl();

    List<SizeBean> sizes = sizeService.getAllSizes();
    List<FabricTypeBean> fabricTypes = fabricTypeService.getAllFabricTypes();

    // Перевірка авторизації та існування продукту
    if (userType == null || !userType.equals("admin")) {
        response.sendRedirect("login.jsp?message=Доступ заборонено, увійдіть як адміністратор!");
        return;
    } else if (userName == null || password == null) {
        response.sendRedirect("login.jsp?message=Сесія закінчилась, увійдіть знову!");
        return;
    } else if (product == null) {
        response.sendRedirect("adminViewProduct.jsp?message=Товар з ID " + prodid + " не знайдено.");
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
                        <h2>Оновити інформацію про товар</h2>
                        <p class="text-muted">Редагування деталей товару з ID: <%=product.getProdId()%></p>

                        <%
                        if (message != null) {
                        %>
                        <div class="message-box alert alert-success">
                            <%=message%>
                        </div>
                        <%
                        }
                        if (error != null) {
                        %>
                        <div class="message-box alert alert-danger">
                            <%=error%>
                        </div>
                        <%
                        }
                        %>
                    </div>

                    <input type="hidden" name="pid" value="<%=product.getProdId()%>">

                    <div class="form-group">
                        <label for="productName">Назва товару</label>
                        <input type="text" placeholder="Введіть назву товару"
                            name="name" class="form-control"
                            value="<%=product.getProdName() != null ? product.getProdName() : ""%>"
                            id="productName" required>
                    </div>

                    <div class="form-group">
                        <%
                        String ptype = product.getProdType() != null ? product.getProdType() : "Подушка";
                        %>
                        <label for="productType">Категорія товару</label>
                        <select name="type" id="productType" class="form-control" required
                                onchange="updateSizesByType(this.value, '<%=product.getSize()%>')">
                            <option value="Подушка" <%="Подушка".equalsIgnoreCase(ptype) ? "selected" : ""%>>Подушка</option>
                            <option value="Постільна білизна" <%="Постільна білизна".equalsIgnoreCase(ptype) ? "selected" : ""%>>Постільна білизна</option>
                            <option value="Ковдра" <%="Ковдра".equalsIgnoreCase(ptype) ? "selected" : ""%>>Ковдра</option>
                            <option value="Плед" <%="Плед".equalsIgnoreCase(ptype) ? "selected" : ""%>>Плед</option>
                            <option value="Рушники" <%="Рушники".equalsIgnoreCase(ptype) ? "selected" : ""%>>Рушники</option>
                            <option value="Крісла" <%="Крісла".equalsIgnoreCase(ptype) ? "selected" : ""%>>Крісла</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="productDescription">Опис товару</label>
                        <textarea name="info" class="form-control"
                            id="productDescription" placeholder="Детальний опис товару..." required><%=product.getProdInfo() != null ? product.getProdInfo() : ""%></textarea>
                    </div>

                    <div class="row">
                        <div class="col-md-4 form-group">
                            <label for="productPrice">Ціна (грн)</label>
                            <input type="number" step="0.01" min="0.01"
                                value="<%=String.format("%.2f", product.getProdPrice())%>"
                                placeholder="0.00" name="price"
                                class="form-control" id="productPrice" required>
                        </div>
                        <div class="col-md-4 form-group">
                            <label for="productQuantity">Кількість на складі</label>
                            <input type="number" min="0"
                                value="<%=product.getProdQuantity()%>"
                                placeholder="0" class="form-control"
                                id="productQuantity" name="quantity" required>
                        </div>
                        <div class="col-md-4 form-group">
                            <label for="productSize">Розмір</label>
                            <select class="form-control" id="productSize" name="size" required>
                                <% for (SizeBean size : sizes) { %>
                                    <option value="<%= size.getSizeId() %>"
                                            data-type="<%= size.getProductType() %>">
                                        <%= size.getSizeName() %> (<%= size.getLength() %>x<%= size.getWidth() %>)
                                    </option>
                                <% } %>
                            </select>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 form-group">
                            <label for="fabricType">Тип тканини</label>
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
                            <label for="productStatus">Статус товару</label>
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

                    <div class="action-buttons">
                        <a href="adminStock.jsp" class="btn btn-cancel">
                            Скасувати
                        </a>
                        <button type="submit" class="btn btn-update">
                            Оновити товар
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
    // Функція валідації форми
    function validateForm() {
        var price = parseFloat(document.getElementById("productPrice").value);
        var quantity = parseInt(document.getElementById("productQuantity").value);
        var sizeSelect = document.getElementById("productSize");
        var fabricTypeSelect = document.getElementById("fabricType");

        if (isNaN(price) || price <= 0) {
            alert("Ціна повинна бути числом більше 0.");
            return false;
        }
        if (isNaN(quantity) || quantity < 0) {
            alert("Кількість не може бути від'ємною або недійсною.");
            return false;
        }
        if (sizeSelect.value.trim() === "") {
            alert("Будь ласка, оберіть розмір.");
            return false;
        }
        if (fabricTypeSelect.value.trim() === "") {
            alert("Будь ласка, оберіть тип тканини.");
            return false;
        }
        return true;
    }

    // Функція для оновлення розмірів на основі типу продукту
    function updateSizesByType(productType, currentSizeId) {
        var sizeSelect = document.getElementById('productSize');
        var options = sizeSelect.options;
        var firstVisibleOptionIndex = -1;
        var foundCurrentSize = false;

        // Приховуємо всі опції
        for (var i = 0; i < options.length; i++) {
            options[i].style.display = 'none';
            options[i].selected = false; // Знімаємо виділення з усіх
        }

        // Відображаємо релевантні опції та шукаємо перший доступний
        for (var i = 0; i < options.length; i++) {
            var option = options[i];
            if (option.getAttribute('data-type') === productType) {
                option.style.display = '';
                if (firstVisibleOptionIndex === -1) {
                    firstVisibleOptionIndex = i;
                }
                // Якщо поточний розмір збігається, вибираємо його
                if (option.value === currentSizeId) {
                    option.selected = true;
                    foundCurrentSize = true;
                }
            }
        }

        // Якщо поточний розмір не знайдено серед доступних, або його не було, вибираємо перший доступний
        if (!foundCurrentSize && firstVisibleOptionIndex !== -1) {
            options[firstVisibleOptionIndex].selected = true;
        } else if (firstVisibleOptionIndex === -1) {
             // Якщо немає доступних розмірів для обраного типу
             // Можна додати опцію "Оберіть розмір" або просто залишити порожнім
             var noOption = document.createElement('option');
             noOption.value = "";
             noOption.textContent = "Немає доступних розмірів";
             sizeSelect.appendChild(noOption);
             sizeSelect.value = ""; // Встановлюємо порожнє значення
        }
    }

    // Ініціалізувати розміри при завантаженні сторінки
    document.addEventListener('DOMContentLoaded', function() {
        var defaultType = document.getElementById('productType').value;
        var currentProductSizeId = '<%= product.getSize() %>'; // Отримуємо поточний розмір продукту
        updateSizesByType(defaultType, currentProductSizeId);
    });
    </script>

    <%@ include file="footer.html"%>
</body>
</html>