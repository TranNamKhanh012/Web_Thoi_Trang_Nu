<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <%-- SỬA LỖI: Kiểm tra id > 0 thay vì 'empty' --%>
        <title>${product.id > 0 ? 'Sửa' : 'Thêm'} Sản phẩm</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
        <link rel="stylesheet" href="../css/admin_style.css" type="text/css"/>
        <style>
            .form-section {
                background: #fff;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
                max-width: 800px;
                margin: 0 auto;
            }
            .form-section h1 {
                margin-bottom: 20px;
                font-size: 24px;
            }
            .form-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
            }
            .form-group {
                margin-bottom: 15px;
            }
            .form-group.full-width {
                grid-column: 1 / -1;
            }
            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
            }
            .form-group input[type="text"],
            .form-group input[type="number"],
            .form-group textarea,
            .form-group select {
                width: 100%;
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 4px;
            }
            .form-group textarea {
                min-height: 100px;
                resize: vertical;
            }
            .btn-submit {
                padding: 12px 25px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-weight: bold;
            }
            .btn-save {
                background: #2ecc71;
                color: white;
            }
            .form-error {
                color: red;
                margin-bottom: 15px;
                font-weight: bold;
            }
            /* Style cho size/stock */
            .size-stock-section {
                margin-top: 20px;
                border-top: 1px solid #eee;
                padding-top: 20px;
            }
            .size-stock-row {
                display: flex;
                gap: 10px;
                margin-bottom: 10px;
                align-items: center;
            }
            .size-stock-row input {
                padding: 8px;
                border: 1px solid #ccc;
                border-radius: 4px;
            }
            .size-stock-row input[name="size[]"] {
                flex-basis: 100px;
                text-transform: uppercase;
            } /* Tự viết hoa */
            .size-stock-row input[name="stock[]"] {
                flex-basis: 80px;
            }
            .btn-remove-size {
                background: #e74c3c;
                color: white;
                border: none;
                padding: 5px 10px;
                cursor: pointer;
                border-radius: 4px;
            }
            .btn-add-size {
                background: #3498db;
                color: white;
                border: none;
                padding: 8px 15px;
                cursor: pointer;
                border-radius: 4px;
                margin-top: 10px;
            }
        </style>
    </head>
    <body>
        <div class="admin-layout">
            <%-- SIDEBAR --%>
            <aside class="admin-sidebar">
                <div class="sidebar-header"><h2>Fashion Admin</h2></div>
                <nav class="sidebar-nav">
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/admin" class="${activePage == 'dashboard' ? 'active' : ''}"><i class="fa-solid fa-gauge"></i> Dashboard</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/products" class="active"><i class="fa-solid fa-box"></i> Quản lý Sản phẩm</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/categories" class="${activePage == 'categories' ? 'active' : ''}"><i class="fa-solid fa-tags"></i> Quản lý Danh mục</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/users" class="${activePage == 'users' ? 'active' : ''}"><i class="fa-solid fa-users"></i> Quản lý Người dùng</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/orders" class="${activePage == 'orders' ? 'active' : ''}"><i class="fa-solid fa-receipt"></i> Quản lý Đơn hàng</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/articles" class="${activePage == 'articles' ? 'active' : ''}"><i class="fa-solid fa-newspaper"></i> Quản lý Bài viết</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/feedback" class="${activePage == 'feedback' ? 'active' : ''}"><i class="fa-solid fa-comment-dots"></i> Quản lý Phản hồi</a></li>
                        <li><a href="${pageContext.request.contextPath}/home"><i class="fa-solid fa-arrow-right-from-bracket"></i> Về trang chủ</a></li>
                    </ul>
                </nav>
            </aside>

            <%-- MAIN CONTENT --%>
            <main class="admin-main-content">
                <%-- SỬA LỖI: Kiểm tra id > 0 --%>
                <header class="admin-header"><h1>${product.id > 0 ? 'Chỉnh sửa Sản phẩm' : 'Thêm Sản phẩm mới'}</h1></header>

                <div class="form-section">
                    <%-- Hiển thị lỗi từ request (nếu có) --%>
                    <c:if test="${not empty formError}">
                        <p class="form-error">${formError}</p>
                    </c:if>
                    <%-- Giữ lại thông báo lỗi từ session (nếu có) --%>
                    <c:if test="${not empty sessionScope.adminErrorMsg}">
                        <p class="form-error">${sessionScope.adminErrorMsg}</p>
                        <c:remove var="adminErrorMsg" scope="session"/>
                    </c:if>

                    <form id="product-form" action="products" method="POST">
                        <input type="hidden" name="action" value="save">
                        <%-- SỬA LỖI: Chỉ gửi 'pid' nếu id > 0 (là form Sửa) --%>
                        <c:if test="${product.id > 0}">
                            <input type="hidden" name="pid" value="${product.id}">
                        </c:if>

                        <div class="form-grid">
                            <div class="form-group">
                                <label for="name">Tên sản phẩm *</label>
                                <input type="text" id="name" name="name" value="${product.name}" required>
                            </div>
                            <div class="form-group">
                                <label for="categoryId">Danh mục *</label>
                                <select id="categoryId" name="categoryId" required>
                                    <option value="">-- Chọn Danh mục --</option>
                                    <c:forEach items="${allCategories}" var="cat">
                                        <option value="${cat.id}" ${product.categoryId == cat.id ? 'selected' : ''}>${cat.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="originalPrice">Giá gốc *</label>
                                <input type="number" id="originalPrice" name="originalPrice" value="${product.originalPrice > 0 ? product.originalPrice : 0}" required step="1000" min="0">
                            </div>
                            <div class="form-group">
                                <label for="salePrice">Giá bán *</label>
                                <input type="number" id="salePrice" name="salePrice" value="${product.salePrice > 0 ? product.salePrice : 0}" step="1000" min="0">
                            </div>
                            <div class="form-group full-width">
                                <label for="imageUrl">URL Ảnh * (Vd: images/tenanh.jpg)</label>
                                <input type="text" id="imageUrl" name="imageUrl" value="${product.imageUrl}" required>
                            </div>
                            <div class="form-group full-width">
                                <label for="description">Mô tả</label>
                                <textarea id="description" name="description">${product.description}</textarea>
                            </div>

                            <%-- Phần quản lý Size và Stock --%>
                            <div class="form-group full-width size-stock-section">
                                <h4>Kích thước và Số lượng trong kho *</h4>
                                <div id="size-stock-container">
                                    <%-- Hiển thị productSizes nếu có (cho form Sửa hoặc form Thêm bị lỗi) --%>
                                    <c:if test="${not empty productSizes}">
                                        <c:forEach items="${productSizes}" var="psize" varStatus="loop">
                                            <div class="size-stock-row">
                                                <input type="text" name="size[]" placeholder="Size (VD: S, M)" value="${psize.size}" required>
                                                <input type="number" name="stock[]" placeholder="Số lượng" value="${psize.stock}" required min="0">
                                                <button type="button" class="btn-remove-size" onclick="removeSizeRow(this)" ${loop.index == 0 ? 'style="visibility:hidden;"' : ''}>Xóa</button>
                                            </div>
                                        </c:forEach>
                                    </c:if>
                                    <%-- Luôn có ít nhất 1 hàng, kể cả khi thêm mới (và productSizes rỗng) --%>
                                    <c:if test="${empty productSizes}">
                                        <div class="size-stock-row">
                                            <input type="text" name="size[]" placeholder="Size (VD: S, M)" value="" required>
                                            <input type="number" name="stock[]" placeholder="Số lượng" value="0" required min="0">
                                            <button type="button" class="btn-remove-size" onclick="removeSizeRow(this)" style="visibility:hidden;">Xóa</button>
                                        </div>
                                    </c:if>
                                </div>
                                <button type="button" class="btn-add-size" onclick="addSizeRow()">+ Thêm Size</button>
                            </div>
                        </div> 

                        <div style="margin-top: 20px;">
                            <button type="submit" class="btn-submit btn-save">Lưu Sản phẩm</button>
                            <a href="products" style="margin-left: 10px;">Hủy</a>
                        </div>
                    </form>
                </div>

                <%-- JavaScript validation (Đã sửa ở lần trước, giữ nguyên) --%>
                <script>
                    function addSizeRow() {
                        const container = document.getElementById('size-stock-container');
                        const newRow = document.createElement('div');
                        newRow.classList.add('size-stock-row');
                        newRow.innerHTML = `
                            <input type="text" name="size[]" placeholder="Size (VD: S, M)" value="" required>
                            <input type="number" name="stock[]" placeholder="Số lượng" value="0" required min="0">
                            <button type="button" class="btn-remove-size" onclick="removeSizeRow(this)">Xóa</button>
                        `;
                        container.appendChild(newRow);
                    }

                    function removeSizeRow(button) {
                        const row = button.parentElement;
                        if (document.querySelectorAll('.size-stock-row').length > 1) {
                            row.remove();
                        } else {
                            alert("Phải có ít nhất một size.");
                        }
                    }

                    document.getElementById('product-form').addEventListener('submit', function (event) {
                        const sizeRows = document.querySelectorAll('.size-stock-row');
                        if (sizeRows.length === 0) {
                            alert('Vui lòng nhập ít nhất một size cho sản phẩm.');
                            event.preventDefault();
                            return;
                        }
                        let hasValidRow = false;
                        let validationError = "";
                        for (const row of sizeRows) {
                            const sizeInput = row.querySelector('input[name="size[]"]');
                            const stockInput = row.querySelector('input[name="stock[]"]');
                            const size = sizeInput.value.trim();
                            const stock = stockInput.value.trim();
                            if (size !== '' && stock !== '') {
                                hasValidRow = true;
                                if (parseInt(stock) < 0) {
                                    validationError = "Số lượng không được âm.";
                                    break;
                                }
                            } else if (size !== '' && stock === '') {
                                validationError = "Bạn đã nhập size '" + size + "' nhưng quên nhập số lượng.";
                                break;
                            } else if (size === '' && stock !== '' && stock !== '0') {
                                validationError = "Bạn đã nhập số lượng '" + stock + "' nhưng quên nhập size.";
                                break;
                            }
                        }
                        if (validationError) {
                            alert(validationError);
                            event.preventDefault();
                        } else if (!hasValidRow) {
                            alert('Vui lòng nhập ít nhất một cặp Size/Số lượng hợp lệ.');
                            event.preventDefault();
                        }
                    });
                </script>
            </main>
        </div>
    </body>
</html>