<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page
    import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,java.util.stream.Collectors,javax.servlet.ServletOutputStream,java.io.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Textileshop - Інтернет магазин</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
    href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<link rel="stylesheet" href="css/changes.css">
<script
    src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
    src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
  
    <% // Підготовки та отримання даних, які потім будуть відображені на веб-сторінці
 	
	String userName = (String) session.getAttribute("username");
	ProductServiceImpl prodDao = new ProductServiceImpl();
	SizeServiceImpl sizeService = new SizeServiceImpl();
	FabricServiceImpl fabricService = new FabricServiceImpl();
	
	List<ProductBean> products = new ArrayList<ProductBean>();
	String search = request.getParameter("search");
	String type = request.getParameter("type");
	String message = "Всі товари";
	
	List<String> categories = prodDao.getAllProductTypes();
	
	if (search != null) {
	    products = prodDao.searchAllProducts(search);
	    message = "Результати пошуку: '" + search + "'";
	} else if (type != null) {
	    products = prodDao.getAllProductsByType(type);
	    message = "Категорія: '" + type + "'";
	} else {
	    products = prodDao.getAllProducts();
	}
	
	if (products.isEmpty()) {
	    message = "За запитом '" + (search != null ? search : type) + "' нічого не знайдено";
	    products = prodDao.getAllProducts();
	}
	
	// Отримуємо всі тканини один раз
	List<FabricBean> allFabrics = fabricService.getAllFabrics();
	Map<String, List<FabricBean>> fabricsByType = allFabrics.stream()
	    .collect(Collectors.groupingBy(FabricBean::getFabricTypeName));
	%>
<style>
    body {
        background-color: #E6F9E6;
        font-family: 'Arial', sans-serif;
    }

    .company-header {
        margin-top: 50px;
        background-color: #0066cc;
        color: white;
        padding: 15px 0;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }

    .company-header h2 {
        margin-top: 0;
        font-weight: bold;
    }

    .search-form {
        margin: 15px auto;
        max-width: 600px;
    }

    .product-row {
        display: flex;
        margin-bottom: 30px;
        border: 1px solid #eee;
        border-radius: 8px;
        padding: 20px;
        background-color: white;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        transition: all 0.3s ease;
    }

    .product-row:hover {
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    }

    .category-tile {
        background-color: rgba(255, 255, 255, 0.8);
        border: 1px solid #ddd;
        border-radius: 8px;
        padding: 20px;
        margin-bottom: 20px;
        text-align: center;
        cursor: pointer;
        transition: all 0.3s ease;
        height: 200px;
        display: flex;
        align-items: center;
        justify-content: center;
        position: relative;
        overflow: hidden;
        box-shadow: 0 3px 6px rgba(0,0,0,0.1);
    }

    .category-tile::before {
        content: "";
        background-image: var(--category-bg);
        background-size: cover;
        background-position: center;
        opacity: 0.6;
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        z-index: -1;
        transition: opacity 0.3s ease;
    }

    .category-tile:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 20px rgba(0,0,0,0.15);
    }

    .category-tile:hover::before {
        opacity: 0.8;
    }

    .category-tile h3 {
        margin: 0;
        color: #0066cc;
        text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
        font-size: 22px;
        font-weight: bold;
        z-index: 1;
        background-color: rgba(255,255,255,0.8);
        padding: 10px 25px;
        border-radius: 30px;
    }

    .product-image-container {
        flex: 0 0 40%;
        padding: 15px;
        text-align: center;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .product-image {
        max-height: 250px;
        max-width: 100%;
        object-fit: contain;
        border-radius: 5px;
    }

    .product-info-container {
        flex: 0 0 60%;
        padding: 15px;
    }

    .product-title {
        font-size: 24px;
        font-weight: bold;
        margin-bottom: 15px;
        color: #333;
    }

    .product-description {
        font-size: 15px;
        color: #666;
        margin-bottom: 20px;
        line-height: 1.6;
    }

    .product-price {
        font-size: 22px;
        font-weight: bold;
        color: #000;
        margin-bottom: 20px;
    }

    .product-price.out-of-stock {
        color: #808080;
    }

    .out-of-stock-label {
        color: #ff0000;
        font-weight: bold;
        margin-left: 10px;
    }

    .options-row {
        margin-bottom: 15px;
    }

    .option-label {
        font-weight: bold;
        margin-bottom: 8px;
        display: block;
        color: #444;
    }

    .option-select {
        width: 200px;
        display: inline-block;
        border-radius: 4px;
        border: 1px solid #ddd;
        padding: 8px 12px;
    }

    .fabric-selector {
        margin-top: 15px;
        background-color: #f8f9fa;
        border-radius: 5px;
        padding: 15px;
    }

    .fabric-options {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
    }

    /* Стилі для мініатюр тканин - ЗМЕНШЕНІ РОЗМІРИ */
    .fabric-thumbnail {
        max-width: 50px; /* Зменшена ширина фото */
        max-height: 50px; /* Зменшена висота фото */
        object-fit: cover; /* Забезпечує, щоб зображення покривало всю область, обрізаючи його за необхідності */
        border-radius: 4px; /* Трохи округлити кути для приємнішого вигляду */
        margin-bottom: 5px; /* Невеликий відступ знизу */
    }

    .fabric-option {
        display: flex;
        flex-direction: column;
        align-items: center;
        border: 2px solid #ddd;
        border-radius: 6px;
        padding: 5px; /* Зменшено padding */
        cursor: pointer;
        transition: all 0.2s ease;
        width: 65px; /* Зменшено ширину контейнера */
        text-align: center;
    }

    .fabric-option:hover:not(.disabled) {
        border-color: #0066cc;
        transform: translateY(-2px);
    }

    .fabric-option.selected {
        background-color: #0066cc;
        color: white;
        border-color: #0066cc;
    }

    .fabric-option.selected .fabric-name {
        color: white;
    }

    .fabric-option.disabled {
        opacity: 0.5;
        cursor: not-allowed;
    }

    .btn-action {
        padding: 10px 20px;
        margin-right: 10px;
        margin-bottom: 10px;
        min-width: 140px;
        border-radius: 4px;
        font-weight: bold;
        transition: all 0.2s ease;
    }

    .btn-action:hover {
        transform: translateY(-2px);
        box-shadow: 0 3px 6px rgba(0,0,0,0.1);
    }

    .btn-disabled {
        opacity: 0.5;
        cursor: not-allowed;
    }

    .back-to-categories {
        margin-bottom: 25px;
    }

    .message-title {
        color: black;
        font-size: 18px;
        font-weight: bold;
        margin: 20px 0;
        padding-bottom: 10px;
        border-bottom: 2px solid #0066cc;
    }

    .description-selector {
        margin-bottom: 15px;
    }

    .description-options {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
        margin-top: 10px;
    }

    .description-option {
        padding: 8px 12px;
        border: 1px solid #ddd;
        border-radius: 4px;
        cursor: pointer;
        transition: all 0.2s ease;
    }

    .description-option:hover {
        background-color: #f0f0f0;
    }

    .description-option.selected {
        background-color: #0066cc;
        color: white;
        border-color: #0066cc;
    }

    .description-option.out-of-stock {
        opacity: 0.6;
        text-decoration: line-through;
    }

    .cart-count {
        background-color: #ff5722;
        color: white;
        border-radius: 50%;
        padding: 2px 6px;
        font-size: 12px;
        margin-left: 5px;
    }

    @media (max-width: 768px) {
        .product-row {
            flex-direction: column;
        }

        .product-image-container,
        .product-info-container {
            flex: 0 0 100%;
        }

        .option-select {
            width: 100%;
        }

        .btn-action {
            width: 100%;
            margin-right: 0;
        }

        .category-tile {
            height: 150px;
        }
    }
</style>
<head>
<body>

<div id="header-container">
    <jsp:include page="header.jsp"/>
</div>

<div class="container-fluid text-center company-header">
    <h2>Textileshop</h2>
    <h6>Спеціалізуємося на текстильних виробах</h6>
    <form class="form-inline search-form" action="index.jsp" method="get">
        <div class="input-group">
            <input type="text" class="form-control" size="50" name="search"
                placeholder="Пошук товарів" required>
            <div class="input-group-btn">
                <input type="submit" class="btn btn-primary" value="Пошук" />
            </div>
        </div>
    </form>
    <p align="center" id="message"></p>
</div>



<script>
// Передаємо дані про тканини в JavaScript
var allFabricsData = {
    <%
    // Перевіряємо, чи є якісь типи тканин, щоб уникнути помилок синтаксису JavaScript
    if (!fabricsByType.isEmpty()) {
        boolean firstType = true;
        for (Map.Entry<String, List<FabricBean>> entry : fabricsByType.entrySet()) {
            if (!firstType) { out.println(","); }
            firstType = false;
    %>
        '<%= entry.getKey() %>': [
            <%
            boolean firstFabric = true;
            for (FabricBean fabric : entry.getValue()) {
                if (!firstFabric) { out.println(","); }
                firstFabric = false;
            %>
                {
                    fabricId: '<%= fabric.getFabricId() %>',
                    fabricTypeName: '<%= fabric.getFabricTypeName() %>',
                    color: '<%= fabric.getColor() %>',
                    imageUrl: './ShowImage?fabricId=<%= fabric.getFabricId() %>'
                }
            <% } %>
        ]
    <%
        }
    }
    %>
};
</script>

<div class="container" style="margin-top: 25px;">
    <% if (type != null) { %>
        <div class="back-to-categories">
            <a href="index.jsp" class="btn btn-primary">
                <span class="glyphicon glyphicon-arrow-left"></span> Повернутись до категорій
            </a>
        </div>
    <% } %>

    <div class="message-title text-center">
        <%=message%>
    </div>

    <% if (type == null && search == null) { %>
        <div class="row">
            <% for (String category : categories) { %>
                <div class="col-md-4 col-sm-6">
                    <div class="category-tile" onclick="window.location.href='index.jsp?type=<%=category%>'"
                         data-category="<%=category%>">
                        <h3><%=category%></h3>
                    </div>
                </div>
            <% } %>
        </div>
    <% } else { %>
        <div class="product-list">
            <%
            // Групуємо товари спочатку за назвою, потім за типом тканини
            // Використовуємо LinkedHashMap для збереження порядку додавання
            Map<String, Map<String, List<ProductBean>>> groupedProducts = new LinkedHashMap<>();

            for (ProductBean product : products) {
                groupedProducts
                    .computeIfAbsent(product.getProdName(), k -> new LinkedHashMap<>())
                    .computeIfAbsent(product.getFabricType(), k -> new ArrayList<>())
                    .add(product);
            }

            for (Map.Entry<String, Map<String, List<ProductBean>>> nameEntry : groupedProducts.entrySet()) {
                String productName = nameEntry.getKey();
                Map<String, List<ProductBean>> productsByFabricType = nameEntry.getValue();

                for (Map.Entry<String, List<ProductBean>> fabricTypeEntry : productsByFabricType.entrySet()) {
                    String fabricTypeName = fabricTypeEntry.getKey();
                    List<ProductBean> sameNameAndFabricProducts = fabricTypeEntry.getValue();
                    ProductBean firstProduct = sameNameAndFabricProducts.get(0); // Беремо перший товар для відображення загальної інформації
                    List<SizeBean> sizes = sizeService.getSizesByProductType(firstProduct.getProdType());
            %>
            <div class="product-row" data-product-name="<%=firstProduct.getProdName()%>" data-fabric-type-group="<%=fabricTypeName%>">
                <div class="product-image-container">
                    <img src="./ShowImage?pid=<%=firstProduct.getProdId()%>" alt="<%=firstProduct.getProdName()%>" class="product-image">
                </div>

                <div class="product-info-container">
                    <h3 class="product-title"><%=firstProduct.getProdName()%></h3>
                    
                    <div class="description-selector">
                        <span class="option-label">Оберіть варіант:</span>
                        <div class="description-options">
                            <% for (int i = 0; i < sameNameAndFabricProducts.size(); i++) {
                                ProductBean product = sameNameAndFabricProducts.get(i);
                                boolean isOutOfStock = product.getProdQuantity() <= 0;
                                String sizeName = prodDao.getSizeNameById(product.getSize());
                            %>
                            <div class="description-option <%= i == 0 ? "selected" : "" %> <%= isOutOfStock ? "out-of-stock" : "" %>"
                                 data-product-id="<%=product.getProdId()%>"
                                 data-description="<%=product.getProdInfo()%>"
                                 data-price="<%=product.getProdPrice()%>"
                                 data-image="./ShowImage?pid=<%=product.getProdId()%>"
                                 data-in-stock="<%=!isOutOfStock%>"
                                 data-fabric-type="<%=product.getFabricType()%>"
                                 data-size-id="<%=product.getSize()%>"
                                 data-product-name="<%=product.getProdName()%>">
                                <%=sizeName%>
                            </div>
                            <% } %>
                        </div>
                    </div>
                    
                    <p class="product-description">
                        <%
                        String description = firstProduct.getProdInfo();
                        description = description.length() > 150 ? description.substring(0, 150) + "..." : description;
                        %>
                        <%=description%>
                    </p>
                    
                    <div class="product-price <%= firstProduct.getProdQuantity() <= 0 ? "out-of-stock" : "" %>">
                        <%=firstProduct.getProdPrice()%> грн
                        <% if (firstProduct.getProdQuantity() <= 0) { %>
                            <span class="out-of-stock-label">Закриті замовлення</span>
                        <% } %>
                    </div>
                    
                    <div class="fabric-selector">
                        <div class="option-label">Оберіть тканину:</div>
                        <div class="fabric-options"></div>
                        <input type="hidden" name="selectedFabric" class="selected-fabric-input" value="">
                    </div>
                    
                    <div class="actions-row">
                        <form method="post" class="product-form">
                            <input type="hidden" name="pid" class="product-id-input" value="<%=firstProduct.getProdId()%>">
                            <input type="hidden" name="uid" value="<%=userName%>">
                            <input type="hidden" name="fabricId" class="form-fabric-id-input" value="">
                            <input type="hidden" name="size" class="size-input" value="<%=firstProduct.getSize()%>">
                            
                            <button type="submit" name="action" value="add"
                                class="btn btn-success btn-action <%= firstProduct.getProdQuantity() <= 0 ? "btn-disabled" : "" %>"
                                <%= firstProduct.getProdQuantity() <= 0 ? "disabled" : "" %>>
                                <span class="glyphicon glyphicon-shopping-cart"></span> В кошик
                            </button>
                            <button type="submit" name="action" value="buy"
                                class="btn btn-primary btn-action <%= firstProduct.getProdQuantity() <= 0 ? "btn-disabled" : "" %>"
                                <%= firstProduct.getProdQuantity() <= 0 ? "disabled" : "" %>>
                                Купити зараз
                            </button>
                        </form>
                    </div>
                </div>
            </div>
            <%
                }
            }
            %>
        </div>
    <% } %>
</div>

<%@ include file="footer.html"%>

<script>
$(document).ready(function() {
    // Об'єкт для зберігання останньої обраної тканини для КОЖНОГО ТИПУ ЗГРУПОВАНОГО ТОВАРУ
    // Ключ: prodName + '_' + fabricType
    const sharedSelectedFabrics = {};

    // Ініціалізація при завантаженні сторінки
    $('.product-row').each(function() {
        const row = $(this);
        const productName = row.data('product-name');
        const fabricType = row.data('fabric-type-group');
        const uniqueKey = productName + '_' + fabricType;

        // Обираємо перший варіант товару як активний для ініціалізації
        const firstDescriptionOption = row.find('.description-option').first();
        const productId = firstDescriptionOption.data('product-id');
        const sizeId = firstDescriptionOption.data('size-id');
        
        row.find('.size-input').val(sizeId);
        row.find('.product-id-input').val(productId);
        
        // Оновлюємо тканини для цього згрупованого товару
        updateFabricsForGroup(row, productName, fabricType, uniqueKey);
    });

    // Обробник для кліку на варіант товару (розмір/опис)
    $('.description-option').click(function() {
        const productRow = $(this).closest('.product-row');
        const productId = $(this).data('product-id');
        const description = $(this).data('description');
        const price = $(this).data('price');
        const imageSrc = $(this).data('image');
        const inStock = $(this).data('in-stock');
        const fabricType = $(this).data('fabric-type');
        const sizeId = $(this).data('size-id');
        const productName = $(this).data('product-name');
        const uniqueKey = productName + '_' + fabricType;

        // Очищаємо всі selected опції в поточному product-row та встановлюємо для поточної
        productRow.find('.description-option').removeClass('selected');
        $(this).addClass('selected');

        productRow.find('.product-description').text(description.length > 150 ?
            description.substring(0, 150) + "..." : description);

        productRow.find('.product-price').text(price + ' грн');
        if (!inStock) {
            productRow.find('.product-price').addClass('out-of-stock');
            productRow.find('.out-of-stock-label').remove();
            productRow.find('.product-price').append('<span class="out-of-stock-label">Закриті замовлення</span>');
            productRow.find('.btn-action').prop('disabled', true).addClass('btn-disabled');
        } else {
            productRow.find('.product-price').removeClass('out-of-stock');
            productRow.find('.out-of-stock-label').remove();
            productRow.find('.btn-action').prop('disabled', false).removeClass('btn-disabled');
        }

        productRow.find('.product-image').attr('src', imageSrc);

        const form = productRow.find('.product-form');
        form.find('.product-id-input').val(productId);
        form.find('.size-input').val(sizeId);

        // Оновлюємо тканини для цього згрупованого товару
        updateFabricsForGroup(productRow, productName, fabricType, uniqueKey);
    });

    // Функція для оновлення варіантів тканини для групи товарів
    function updateFabricsForGroup(productRow, productName, fabricType, uniqueKey) {
        const fabricContainer = productRow.find('.fabric-options');
        const selectedFabricInput = productRow.find('.selected-fabric-input');
        const formFabricInput = productRow.find('.form-fabric-id-input');
        
        fabricContainer.empty();

        if (allFabricsData[fabricType] && allFabricsData[fabricType].length > 0) {
            let preselectedFabricId = sharedSelectedFabrics[uniqueKey];

            allFabricsData[fabricType].forEach(function(fabric) {
                const isDisabled = false; // Тканина завжди доступна, якщо її тип існує

                const isSelected = !isDisabled && preselectedFabricId === fabric.fabricId;
                const fabricOption = $(
                    '<div class="fabric-option ' +
                    (isDisabled ? 'disabled' : '') +
                    (isSelected ? ' selected' : '') + '" ' +
                    'data-fabric-id="' + fabric.fabricId + '" ' +
                    'data-unique-key="' + uniqueKey + '" ' +
                    'title="' + (isDisabled ? "Закриті замовлення" : fabric.color) + '">' +
                    '<img src="' + fabric.imageUrl + '" ' +
                    'alt="' + fabric.color + '" class="fabric-thumbnail">' +
                    '<span class="fabric-name">' + fabric.color + '</span>' +
                    '</div>'
                );

                if (!isDisabled) {
                    fabricOption.click(function() {
                        const clickedUniqueKey = $(this).data('unique-key');
                        
                        // Оновлюємо "selected" стан для ВСІХ fabric-option з однаковим uniqueKey
                        $('.fabric-option[data-unique-key="' + clickedUniqueKey + '"]').removeClass('selected');
                        $(this).addClass('selected');
                        
                        // Оновлюємо значення полів введення тканини для ВСІХ відповідних product-row
                        $('.product-row[data-product-name="' + productName + '"][data-fabric-type-group="' + fabricType + '"]')
                            .find('.selected-fabric-input').val(fabric.fabricId);
                        $('.product-row[data-product-name="' + productName + '"][data-fabric-type-group="' + fabricType + '"]')
                            .find('.form-fabric-id-input').val(fabric.fabricId);
                        
                        // Зберігаємо обрану тканину для загального ключа
                        sharedSelectedFabrics[clickedUniqueKey] = fabric.fabricId;
                    });
                }

                fabricContainer.append(fabricOption);
            });

            // Якщо тканина не була попередньо обрана або обрана недоступна, вибираємо першу доступну
            if (!preselectedFabricId || !fabricContainer.find('.fabric-option.selected').length) {
                const firstAvailable = fabricContainer.find('.fabric-option:not(.disabled)').first();
                if (firstAvailable.length) {
                    firstAvailable.click();
                } else {
                    // Якщо немає доступних тканин
                    selectedFabricInput.val('');
                    formFabricInput.val('');
                    sharedSelectedFabrics[uniqueKey] = '';
                }
            }
        } else {
            fabricContainer.html('<p class="text-muted">Для цього товару немає доступних тканин типу: ' + fabricType + '</p>');
            selectedFabricInput.val('');
            formFabricInput.val('');
            sharedSelectedFabrics[uniqueKey] = '';
        }
    }

    $('.product-form').on('submit', function(e) {
        e.preventDefault();
        const form = $(this);
        const clickedBtn = $(document.activeElement);
        const action = clickedBtn.val() || 'add';
        
        // Перевіряємо, чи користувач увійшов в систему
        const isLoggedIn = <%= userName != null %>;
        
        if (!isLoggedIn) {
            // Перенаправляємо на сторінку входу з URL для повернення
            window.location.href = 'login.jsp?returnUrl=' + encodeURIComponent(window.location.pathname + window.location.search);
            return false;
        }

        const fabricId = form.find('.form-fabric-id-input').val();
        const size = form.find('.size-input').val();

        if (!fabricId) {
            alert('Будь ласка, оберіть тканину');
            return false;
        }
        if (!size) {
            alert('Будь ласка, оберіть розмір');
            return false;
        }

        clickedBtn.prop('disabled', true);

        $.ajax({
            url: './AddtoCart',
            type: 'POST',
            data: form.serialize() + '&action=' + action,
            success: function(response) {
                if (action === 'buy') {
                    window.location.href = 'cartDetails.jsp';
                } else {
                    updateCartCount();
                    showSuccessMessage('Товар додано до кошика');
                }
                clickedBtn.prop('disabled', false);
            },
            error: function() {
                alert('Сталася помилка при додаванні товару');
                clickedBtn.prop('disabled', false);
            }
        });
    });

    function updateCartCount() {
        $.ajax({
            url: './header.jsp',
            type: 'GET',
            success: function(response) {
                $('#header-container').html(response);
            }
        });
    }

    function showSuccessMessage(message) {
        const alert = $('<div class="alert alert-success alert-dismissible" style="position: fixed; top: 45px; right: 20px; z-index: 1000;">' +
                        '<button type="button" class="close" data-dismiss="alert">&times;</button>' +
                        message +
                        '</div>');
        $('body').append(alert);
        setTimeout(function() {
            alert.fadeOut('slow', function() {
                $(this).remove();
            });
        }, 3000);
    }
});

$(document).ready(function() {
    // Встановлюємо фонові зображення для категорій
    const categoryImages = {
        'Подушка': 'podushka.jpg',
        'Ковдра': 'kovdr.jpg',
        'Крісла': 'krislo.jpg',
        'Постільна білизна': 'postil.jpg',
        'Пледи': 'speaker.jpg',
        'Рушники': 'rushnik.jpg'
    };
    
    $('.category-tile').each(function() {
        const category = $(this).data('category');
        const imageFile = categoryImages[category] || 'noimage.jpg';
        $(this).css('--category-bg', 'url(images/' + imageFile + ')');
    });
});
</script>

</body>
</html>