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

    /* Стилі для вибору опису/варіанту */
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
</head>
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
                placeholder="Пошук товарів" value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>" required>
            <div class="input-group-btn">
                <input type="submit" class="btn btn-primary" value="Пошук" />
            </div>
        </div>
    </form>
    <p align="center" id="message"></p>
</div>

<%
String userName = (String) session.getAttribute("username");
ProductServiceImpl prodDao = new ProductServiceImpl();
SizeServiceImpl sizeService = new SizeServiceImpl();
// FabricServiceImpl fabricService = new FabricServiceImpl(); // Видалено, оскільки функціонал тканини не використовується

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
    products = prodDao.getAllProducts(); // Повернути всі товари, якщо нічого не знайдено
}
%>

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
            // Групуємо товари за назвою
            Map<String, List<ProductBean>> groupedProducts = products.stream()
                .collect(Collectors.groupingBy(ProductBean::getProdName));

            for (Map.Entry<String, List<ProductBean>> entry : groupedProducts.entrySet()) {
                List<ProductBean> sameNameProducts = entry.getValue();
                ProductBean firstProduct = sameNameProducts.get(0); // Беремо перший товар для відображення загальної інформації
                // List<SizeBean> sizes = sizeService.getSizesByProductType(firstProduct.getProdType()); // Можна використовувати, якщо потрібно вивести розміри в HTML

            %>
            <div class="product-row" data-product-name="<%=firstProduct.getProdName()%>">
                <div class="product-image-container">
                    <img src="./ShowImage?pid=<%=firstProduct.getProdId()%>" alt="<%=firstProduct.getProdName()%>" class="product-image">
                </div>

                <div class="product-info-container">
                    <h3 class="product-title"><%=firstProduct.getProdName()%></h3>

                    <div class="description-selector">
                        <span class="option-label">Оберіть варіант:</span>
                        <div class="description-options">
                            <% for (int i = 0; i < sameNameProducts.size(); i++) {
                                ProductBean product = sameNameProducts.get(i);
                                boolean isOutOfStock = product.getProdQuantity() <= 0;
                                String sizeName = prodDao.getSizeNameById(product.getSize());
                            %>
                            <div class="description-option <%= i == 0 ? "selected" : "" %> <%= isOutOfStock ? "out-of-stock" : "" %>"
                                 data-product-id="<%=product.getProdId()%>"
                                 data-description="<%=product.getProdInfo()%>"
                                 data-price="<%=product.getProdPrice()%>"
                                 data-image="./ShowImage?pid=<%=product.getProdId()%>"
                                 data-in-stock="<%=!isOutOfStock%>"
                                 data-size-id="<%=product.getSize()%>">
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
                            <span class="out-of-stock-label">Немає в наявності</span>
                        <% } %>
                    </div>

                    <div class="options-row">
                        <span class="option-label">Колір:</span>
                        <select class="form-control option-select" name="color_selection" <%= firstProduct.getProdQuantity() <= 0 ? "disabled" : "" %>>
                            <option value="red">Червоний</option>
                            <option value="blue">Синій</option>
                            <option value="green">Зелений</option>
                            <option value="yellow">Жовтий</option>
                            <option value="purple">Фіолетовий</option>
                            <option value="black">Чорний</option>
                            </select>
                    </div>

                    <div class="actions-row">
                        <form method="post" class="product-form" data-product-id="<%=firstProduct.getProdId()%>">
                            <input type="hidden" name="pid" value="<%=firstProduct.getProdId()%>">
                            <input type="hidden" name="uid" value="<%=userName%>">
                            <input type="hidden" name="size" id="sizeInput_<%=firstProduct.getProdId()%>" value="<%=firstProduct.getSize()%>">
                            <%-- Видалено: Поле для fabricId, оскільки функціонал тканини не використовується --%>
                            <%-- <input type="hidden" name="fabricId" id="formFabricId_<%=firstProduct.getProdId()%>" value=""> --%>

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
            %>
        </div>
    <% } %>
</div>

<%@ include file="footer.html"%>

<script>
$(document).ready(function() {
    // Ініціалізація при завантаженні сторінки
    $('.product-row').each(function() {
        const row = $(this);
        const selectedOption = row.find('.description-option.selected');
        const sizeId = selectedOption.data('size-id');
        row.find('input[name="size"]').val(sizeId);
    });

    $('.description-option').click(function() {
        const productRow = $(this).closest('.product-row');
        const productId = $(this).data('product-id');
        const description = $(this).data('description');
        const price = $(this).data('price');
        const imageSrc = $(this).data('image');
        const inStock = $(this).data('in-stock');
        const sizeId = $(this).data('size-id');
        // Видалено: const fabricType = $(this).data('fabric-type'); // Більше не використовується

        productRow.find('.description-option').removeClass('selected');
        $(this).addClass('selected');

        productRow.find('.product-description').text(description.length > 150 ?
            description.substring(0, 150) + "..." : description);

        productRow.find('.product-price').text(price + ' грн');
        if (!inStock) {
            productRow.find('.product-price').addClass('out-of-stock');
            productRow.find('.out-of-stock-label').remove();
            productRow.find('.product-price').append('<span class="out-of-stock-label">Немає в наявності</span>');
        } else {
            productRow.find('.product-price').removeClass('out-of-stock');
            productRow.find('.out-of-stock-label').remove();
        }

        productRow.find('.product-image').attr('src', imageSrc);

        const form = productRow.find('.product-form');
        form.data('product-id', productId);
        form.find('input[name="pid"]').val(productId);
        form.find('input[name="size"]').val(sizeId);

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

        const size = form.find('input[name="size"]').val();
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