package dao;

import context.DBContext;
import entity.Product;
import entity.ProductSize;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

public class ProductDAO {

    /**
     * Lấy ra các sản phẩm bán chạy nhất, sắp xếp theo sold_quantity giảm dần.
     *
     * @param limit Số lượng sản phẩm tối đa muốn lấy.
     * @return Danh sách các đối tượng Product.
     */
    public List<Product> getTopSellingProducts(int limit) {
        List<Product> list = new ArrayList<>();
        // Sắp xếp theo sold_quantity. COALESCE(sold_quantity, 0) sẽ coi NULL là 0.
        String query = "SELECT * FROM products ORDER BY COALESCE(sold_quantity, 0) DESC LIMIT ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setId(rs.getInt("id"));
                    p.setName(rs.getString("name"));
                    p.setOriginalPrice(rs.getDouble("original_price"));
                    p.setSalePrice(rs.getDouble("sale_price"));
                    p.setImageUrl(rs.getString("image_url"));
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        // Dòng debug để kiểm tra trong console
        System.out.println("DEBUG: getTopSellingProducts() found " + list.size() + " products.");
        return list;
    }

    // Dán vào bên trong class ProductDAO
    /**
     * Lấy tất cả sản phẩm từ database.
     *
     * @return Danh sách tất cả Product.
     */
    /**
     * Lấy tất cả sản phẩm, hỗ trợ sắp xếp.
     *
     * @param sortBy Cột sắp xếp ("price", "date" hoặc null/trống cho mặc định).
     * @param sortOrder Thứ tự sắp xếp ("asc", "desc" hoặc null/trống cho mặc
     * định).
     * @return Danh sách Product.
     */
    public List<Product> getAllProducts(Double minPrice, Double maxPrice, String sortBy, String sortOrder, int pageSize, int offset) {
        List<Product> list = new ArrayList<>();
        String orderByClause = buildOrderByClause(sortBy, sortOrder);
        List<Object> params = new ArrayList<>();

        String priceWhere = buildPriceWhereClause(minPrice, maxPrice, params);

        String query = "SELECT p.*, (SELECT SUM(ps.stock) FROM product_sizes ps WHERE ps.product_id = p.id) as total_stock "
                + "FROM products p WHERE 1=1 " + priceWhere
                + orderByClause
                + " LIMIT ? OFFSET ?"; // Thêm LIMIT và OFFSET

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            int paramIndex = 1;
            for (Object param : params) { // Gán tham số giá
                ps.setObject(paramIndex++, param);
            }
            ps.setInt(paramIndex++, pageSize); // Gán LIMIT
            ps.setInt(paramIndex++, offset); // Gán OFFSET

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    // ... (gán giá trị như cũ) ...
                    p.setId(rs.getInt("id"));
                    p.setName(rs.getString("name"));
                    p.setOriginalPrice(rs.getDouble("original_price"));
                    p.setSalePrice(rs.getDouble("sale_price"));
                    p.setImageUrl(rs.getString("image_url"));
                    p.setSoldQuantity(rs.getInt("sold_quantity"));
                    p.setCategoryId(rs.getInt("category_id"));
                    p.setTotalStock(rs.getInt("total_stock"));
                    p.setTotalStock(rs.getInt("total_stock"));
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> getProductsByCategoryId(int categoryId, Double minPrice, Double maxPrice, String sortBy, String sortOrder, int pageSize, int offset) {
    List<Product> list = new ArrayList<>();
    String orderByClause = buildOrderByClause(sortBy, sortOrder);
    List<Object> params = new ArrayList<>();
    params.add(categoryId); // Tham số đầu tiên
    
    String priceWhere = buildPriceWhereClause(minPrice, maxPrice, params);

    String query = "SELECT p.*, (SELECT SUM(ps.stock) FROM product_sizes ps WHERE ps.product_id = p.id) as total_stock "
                 + "FROM products p WHERE p.category_id = ? " + priceWhere
                 + orderByClause
                 + " LIMIT ? OFFSET ?"; // Thêm LIMIT và OFFSET

    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {
        
        int paramIndex = 1;
        for (Object param : params) { // Gán tham số (cid, giá)
            ps.setObject(paramIndex++, param);
        }
        ps.setInt(paramIndex++, pageSize); // Gán LIMIT
        ps.setInt(paramIndex++, offset); // Gán OFFSET

        try (ResultSet rs = ps.executeQuery()) {
             while (rs.next()) {
                Product p = new Product();
                // ... (gán giá trị như cũ) ...
                p.setId(rs.getInt("id")); p.setName(rs.getString("name")); p.setOriginalPrice(rs.getDouble("original_price")); p.setSalePrice(rs.getDouble("sale_price")); p.setImageUrl(rs.getString("image_url")); p.setSoldQuantity(rs.getInt("sold_quantity")); p.setCategoryId(rs.getInt("category_id"));
                p.setTotalStock(rs.getInt("total_stock"));
                list.add(p);
            }
        }
    } catch (Exception e) { e.printStackTrace(); }
    return list;
}

    /**
     * Lấy thông tin chi tiết của một sản phẩm bằng ID.
     *
     * @param productId ID của sản phẩm cần tìm.
     * @return một đối tượng Product chứa đầy đủ thông tin, hoặc null nếu không
     * tìm thấy.
     */
    
    // =================== BẮT ĐẦU SỬA LỖI ===================
   // ... bên trong ProductDAO.java ...

    public Product getProductById(int productId) {
        String query = "SELECT * FROM products WHERE id = ?";
        try (Connection conn = DBContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Product p = new Product();
                    p.setId(rs.getInt("id"));
                    p.setName(rs.getString("name"));
                    p.setDescription(rs.getString("description"));
                    p.setOriginalPrice(rs.getDouble("original_price"));
                    p.setSalePrice(rs.getDouble("sale_price"));
                    p.setImageUrl(rs.getString("image_url"));

                    // ===========================================
                    // 2 DÒNG NÀY LÀ BẮT BUỘC (CODE CŨ CỦA BẠN BỊ THIẾU)
                    p.setCategoryId(rs.getInt("category_id"));
                    p.setSoldQuantity(rs.getInt("sold_quantity"));
                    // ===========================================
                    
                    return p;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
// ... các hàm khác ...
    // =================== KẾT THÚC SỬA LỖI ===================

    // Dán vào bên trong class ProductDAO

    /**
     * Lấy ra các sản phẩm mới nhất, sắp xếp theo ngày tạo giảm dần.
     *
     * @param limit Số lượng sản phẩm tối đa muốn lấy.
     * @return Danh sách các đối tượng Product.
     */
    public List<Product> getLatestProducts(int limit) {
        List<Product> list = new ArrayList<>();
        // Sắp xếp giảm dần theo created_date để lấy sản phẩm mới nhất
        String query = "SELECT * FROM products ORDER BY created_date DESC LIMIT ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setId(rs.getInt("id"));
                    p.setName(rs.getString("name"));
                    p.setOriginalPrice(rs.getDouble("original_price"));
                    p.setSalePrice(rs.getDouble("sale_price"));
                    p.setImageUrl(rs.getString("image_url"));
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Dán vào bên trong class ProductDAO
    // Dán vào bên trong class ProductDAO
    public void updateStockAfterOrder(int orderId) {
        // Lấy product_id, quantity, VÀ size từ order_details
        String getOrderDetails = "SELECT product_id, quantity, size FROM order_details WHERE order_id = ?";
        // Cập nhật bảng product_sizes, KHÔNG phải bảng products
        String updateProductSize = "UPDATE product_sizes SET stock = stock - ? WHERE product_id = ? AND size = ? AND stock >= ?";
        // Cập nhật sold_quantity trong bảng products (vẫn hữu ích cho Top Bán Chạy)
        String updateProductSold = "UPDATE products SET sold_quantity = sold_quantity + ? WHERE id = ?";

        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement psGet = conn.prepareStatement(getOrderDetails)) {
                psGet.setInt(1, orderId);
                try (ResultSet rs = psGet.executeQuery()) {
                    while (rs.next()) {
                        int productId = rs.getInt("product_id");
                        int quantity = rs.getInt("quantity");
                        String size = rs.getString("size");

                        // 1. Trừ kho của size
                        try (PreparedStatement psUpdateStock = conn.prepareStatement(updateProductSize)) {
                            psUpdateStock.setInt(1, quantity);
                            psUpdateStock.setInt(2, productId);
                            psUpdateStock.setString(3, size);
                            psUpdateStock.setInt(4, quantity); // Điều kiện stock >= ?
                            int rowsAffected = psUpdateStock.executeUpdate();
                            if (rowsAffected == 0) {
                                throw new SQLException("Sản phẩm ID " + productId + " size " + size + " đã hết hàng!");
                            }
                        }

                        // 2. Tăng số lượng đã bán của sản phẩm chính
                        try (PreparedStatement psUpdateSold = conn.prepareStatement(updateProductSold)) {
                            psUpdateSold.setInt(1, quantity);
                            psUpdateSold.setInt(2, productId);
                            psUpdateSold.executeUpdate();
                        }
                    }
                }
            }
            conn.commit(); // Hoàn tất transaction

        } catch (Exception e) {
            if (conn != null) try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            if (conn != null) try {
                conn.setAutoCommit(true);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
    // Dán vào bên trong class ProductDAO

    /**
     * Tìm kiếm sản phẩm theo tên.
     *
     * @param keyword Từ khóa tìm kiếm.
     * @return Danh sách sản phẩm có tên chứa từ khóa.
     */
    public List<Product> searchByName(String keyword) {
        List<Product> list = new ArrayList<>();
        // Dùng LIKE %...% để tìm kiếm GẦN ĐÚNG
        String query = "SELECT * FROM products WHERE name LIKE ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, "%" + keyword + "%"); // Gán từ khóa vào câu lệnh SQL
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setId(rs.getInt("id"));
                    p.setName(rs.getString("name"));
                    p.setOriginalPrice(rs.getDouble("original_price"));
                    p.setSalePrice(rs.getDouble("sale_price"));
                    p.setImageUrl(rs.getString("image_url"));
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Dán vào bên trong class ProductDAO
    public int countTotalProducts() {
        String query = "SELECT COUNT(*) FROM products";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int sumTotalSoldQuantity() {
        String query = "SELECT SUM(COALESCE(sold_quantity, 0)) FROM products";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public void deleteProduct(int productId) {
        // Nên xóa cả trong product_sizes trước (do có khóa ngoại ON DELETE CASCADE thì không cần)
        String query = "DELETE FROM products WHERE id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, productId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Thêm sản phẩm mới và size/số lượng vào database (dùng transaction).
     *
     * @param product Chi tiết sản phẩm (tên, giá,...).
     * @param sizes Danh sách các đối tượng ProductSize chứa size và số lượng
     * tồn.
     * @param categoryId ID của danh mục.
     * @return ID của sản phẩm mới tạo, hoặc -1 nếu thất bại.
     */
    public int addProduct(Product product, List<ProductSize> sizes, int categoryId) {
    String insertProductSQL = "INSERT INTO products (name, description, original_price, sale_price, image_url, category_id, sold_quantity) VALUES (?, ?, ?, ?, ?, ?, 0)";
    String insertSizeSQL = "INSERT INTO product_sizes (product_id, size, stock) VALUES (?, ?, ?)";
    Connection conn = null;
    int productId = -1;

    try {
        conn = DBContext.getConnection();
        conn.setAutoCommit(false); // Bắt đầu transaction

        // 1. Thêm vào bảng products
        try (PreparedStatement psProduct = conn.prepareStatement(insertProductSQL, Statement.RETURN_GENERATED_KEYS)) {
            psProduct.setString(1, product.getName());
            psProduct.setString(2, product.getDescription());
            psProduct.setDouble(3, product.getOriginalPrice());
            psProduct.setDouble(4, product.getSalePrice());
            psProduct.setString(5, product.getImageUrl());
            psProduct.setInt(6, categoryId);
            psProduct.executeUpdate();

            // Lấy ID sản phẩm vừa tạo
            try (ResultSet generatedKeys = psProduct.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    productId = generatedKeys.getInt(1);
                } else {
                    throw new SQLException("Tạo sản phẩm thất bại, không lấy được ID.");
                }
            }
        }

        // 2. Thêm vào bảng product_sizes
        if (productId != -1 && sizes != null && !sizes.isEmpty()) {
            try (PreparedStatement psSize = conn.prepareStatement(insertSizeSQL)) {
                for (ProductSize sizeInfo : sizes) {
                    psSize.setInt(1, productId);
                    psSize.setString(2, sizeInfo.getSize());
                    psSize.setInt(3, sizeInfo.getStock());
                    psSize.addBatch(); 
                }
                psSize.executeBatch(); 
            }
        }

        conn.commit(); // Commit transaction

    } catch (Exception e) {
        productId = -1; 
        if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
        e.printStackTrace();
    } finally {
        if (conn != null) try { conn.setAutoCommit(true); } catch (SQLException ex) { ex.printStackTrace(); }
    }
    return productId;
}

    /**
     * Cập nhật sản phẩm và size/số lượng (dùng transaction).
     *
     * @param product Chi tiết sản phẩm cần cập nhật.
     * @param sizes Danh sách ProductSize mới (sẽ ghi đè size cũ).
     * @param categoryId ID danh mục.
     */
    public void updateProduct(Product product, List<ProductSize> sizes, int categoryId) {
    String updateProductSQL = "UPDATE products SET name=?, description=?, original_price=?, sale_price=?, image_url=?, category_id=? WHERE id=?";
    String deleteSizesSQL = "DELETE FROM product_sizes WHERE product_id = ?";
    String insertSizeSQL = "INSERT INTO product_sizes (product_id, size, stock) VALUES (?, ?, ?)";
    Connection conn = null;

    try {
        conn = DBContext.getConnection();
        conn.setAutoCommit(false); // Bắt đầu transaction
        int productId = product.getId();

        // 1. Cập nhật bảng products
        try (PreparedStatement psProduct = conn.prepareStatement(updateProductSQL)) {
            psProduct.setString(1, product.getName());
            psProduct.setString(2, product.getDescription());
            psProduct.setDouble(3, product.getOriginalPrice());
            psProduct.setDouble(4, product.getSalePrice());
            psProduct.setString(5, product.getImageUrl());
            psProduct.setInt(6, categoryId);
            psProduct.setInt(7, productId);
            psProduct.executeUpdate();
        }

        // 2. Xóa các size cũ
        try (PreparedStatement psDelete = conn.prepareStatement(deleteSizesSQL)) {
            psDelete.setInt(1, productId);
            psDelete.executeUpdate();
        }

        // 3. Thêm các size mới
        if (sizes != null && !sizes.isEmpty()) {
            try (PreparedStatement psSize = conn.prepareStatement(insertSizeSQL)) {
                for (ProductSize sizeInfo : sizes) {
                    psSize.setInt(1, productId);
                    psSize.setString(2, sizeInfo.getSize());
                    psSize.setInt(3, sizeInfo.getStock());
                    psSize.addBatch();
                }
                psSize.executeBatch();
            }
        }
        conn.commit(); // Commit transaction
    } catch (Exception e) {
        if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
        e.printStackTrace();
    } finally {
        if (conn != null) try { conn.setAutoCommit(true); } catch (SQLException ex) { ex.printStackTrace(); }
    }
}
    // Dán vào bên trong class ProductDAO.java

    // Thay thế hàm searchProductsAdmin cũ
public List<Product> searchProductsAdmin(String keyword, int pageSize, int offset) {
    List<Product> list = new ArrayList<>();
    String query = "SELECT p.*, c.name as category_name, "
                 + "(SELECT SUM(ps.stock) FROM product_sizes ps WHERE ps.product_id = p.id) as total_stock "
                 + "FROM products p "
                 + "LEFT JOIN categories c ON p.category_id = c.id "
                 + "WHERE p.name LIKE ? "
                 + "ORDER BY p.id DESC "
                 + "LIMIT ? OFFSET ?"; // Thêm LIMIT OFFSET
    String keywordLike = "%" + keyword + "%";

    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {
        ps.setString(1, keywordLike);
        ps.setInt(2, pageSize);
        ps.setInt(3, offset);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setOriginalPrice(rs.getDouble("original_price"));
                p.setSalePrice(rs.getDouble("sale_price"));
                p.setImageUrl(rs.getString("image_url"));
                p.setSoldQuantity(rs.getInt("sold_quantity"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setTotalStock(rs.getInt("total_stock"));
                list.add(p);
            }
        }
    } catch (Exception e) { e.printStackTrace(); }
    return list;
}
    // Dán vào bên trong class ProductDAO.java

    /**
     * Lấy sản phẩm đang giảm giá, hỗ trợ sắp xếp.
     *
     * @param sortBy Cột sắp xếp.
     * @param sortOrder Thứ tự sắp xếp.
     * @return Danh sách Product.
     */
    // Lấy sản phẩm đang giảm giá (có lọc, sắp xếp, phân trang)
// Lấy sản phẩm đang giảm giá (có lọc, sắp xếp, phân trang)
public List<Product> getOnSaleProducts(Integer categoryId, Double minPrice, Double maxPrice, String sortBy, String sortOrder, int pageSize, int offset) {
    List<Product> list = new ArrayList<>();
    String orderByClause = buildOrderByClause(sortBy, sortOrder);
    List<Object> params = new ArrayList<>();

    // Điều kiện cơ bản: đang giảm giá
    StringBuilder whereClause = new StringBuilder(" WHERE p.sale_price IS NOT NULL AND p.sale_price > 0 AND p.sale_price < p.original_price ");
    
    // *** THÊM LỌC CATEGORY ***
    if (categoryId != null && categoryId > 0) {
        whereClause.append(" AND p.category_id = ? ");
        params.add(categoryId);
    }
    
    // Thêm điều kiện lọc giá
    whereClause.append(buildPriceWhereClause(minPrice, maxPrice, params));

    String query = "SELECT p.*, (SELECT SUM(ps.stock) FROM product_sizes ps WHERE ps.product_id = p.id) as total_stock "
                 + "FROM products p "
                 + whereClause.toString()
                 + orderByClause
                 + " LIMIT ? OFFSET ?";

    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {
        
         int paramIndex = 1;
         for (Object param : params) { // Gán tham số (category, giá)
             ps.setObject(paramIndex++, param);
         }
         ps.setInt(paramIndex++, pageSize); // Gán LIMIT
         ps.setInt(paramIndex++, offset); // Gán OFFSET

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Product p = new Product();
                // ... (gán giá trị như cũ) ...
                p.setId(rs.getInt("id")); p.setName(rs.getString("name")); p.setOriginalPrice(rs.getDouble("original_price")); p.setSalePrice(rs.getDouble("sale_price")); p.setImageUrl(rs.getString("image_url")); p.setSoldQuantity(rs.getInt("sold_quantity")); p.setCategoryId(rs.getInt("category_id"));
                p.setTotalStock(rs.getInt("total_stock"));
                list.add(p);
            }
        }
    } catch (Exception e) { e.printStackTrace(); }
    return list;
}

    // *** THÊM HÀM TRỢ GIÚP NÀY VÀO CUỐI CLASS ProductDAO ***
    /**
     * Hàm nội bộ để tạo mệnh đề ORDER BY dựa trên tham số.
     *
     * @param sortBy Cột muốn sắp xếp ("price", "date", null).
     * @param sortOrder Thứ tự ("asc", "desc", null).
     * @return Chuỗi ORDER BY tương ứng (ví dụ: " ORDER BY p.created_date
     * DESC").
     */
    // Thay thế hàm này trong ProductDAO.java
    private String buildOrderByClause(String sortBy, String sortOrder) {
        String column = "p.created_date"; // Mặc định sắp xếp theo ngày tạo (mới nhất)
        if ("price".equalsIgnoreCase(sortBy)) {
            column = "CASE WHEN p.sale_price IS NOT NULL AND p.sale_price > 0 THEN p.sale_price ELSE p.original_price END";
        }
        // Không cần trường hợp "date" vì nó là mặc định

        String order = "DESC"; // Mặc định giảm dần (mới nhất/giá cao nhất)
        if ("asc".equalsIgnoreCase(sortOrder)) {
            order = "ASC"; // Tăng dần (cũ nhất/giá thấp nhất)
        }

        return " ORDER BY " + column + " " + order;
    }

    // Dán vào class ProductDAO.java
// Hàm trợ giúp xây dựng WHERE (cần tạo nếu chưa có, hoặc điều chỉnh)
    private String buildPriceWhereClause(Double minPrice, Double maxPrice, List<Object> params) {
        StringBuilder whereClause = new StringBuilder();
        if (minPrice != null) {
            whereClause.append(" AND (CASE WHEN p.sale_price IS NOT NULL AND p.sale_price > 0 THEN p.sale_price ELSE p.original_price END) >= ? ");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            whereClause.append(" AND (CASE WHEN p.sale_price IS NOT NULL AND p.sale_price > 0 THEN p.sale_price ELSE p.original_price END) <= ? ");
            params.add(maxPrice);
        }
        return whereClause.toString();
    }

// Phương thức MỚI để đếm sản phẩm
    public int countProducts(Integer categoryId, Double minPrice, Double maxPrice) {
        List<Object> params = new ArrayList<>();
        StringBuilder queryBuilder = new StringBuilder("SELECT COUNT(*) FROM products p");

        if (categoryId != null && categoryId > 0) {
            queryBuilder.append(" WHERE p.category_id = ?");
            params.add(categoryId);
            queryBuilder.append(buildPriceWhereClause(minPrice, maxPrice, params));
        } else {
            queryBuilder.append(" WHERE 1=1 "); // Bắt đầu WHERE cho lọc giá
            queryBuilder.append(buildPriceWhereClause(minPrice, maxPrice, params));
        }

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(queryBuilder.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    // Dán vào class ProductDAO
public int countSearchProductsAdmin(String keyword) {
    String query = "SELECT COUNT(*) FROM products p WHERE p.name LIKE ?";
    String keywordLike = "%" + keyword + "%";
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {
        ps.setString(1, keywordLike);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
    } catch (Exception e) { e.printStackTrace(); }
    return 0;
}
// Đếm số sản phẩm đang giảm giá (có lọc)
public int countOnSaleProducts(Integer categoryId, Double minPrice, Double maxPrice) {
    List<Object> params = new ArrayList<>();
    StringBuilder queryBuilder = new StringBuilder("SELECT COUNT(*) FROM products p");
    
    // Điều kiện cơ bản: đang giảm giá
    queryBuilder.append(" WHERE p.sale_price IS NOT NULL AND p.sale_price > 0 AND p.sale_price < p.original_price ");
    
    // *** THÊM LỌC CATEGORY ***
    if (categoryId != null && categoryId > 0) {
        queryBuilder.append(" AND p.category_id = ? ");
        params.add(categoryId);
    }
    
    // Thêm điều kiện lọc giá
    queryBuilder.append(buildPriceWhereClause(minPrice, maxPrice, params));

    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(queryBuilder.toString())) {
        
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }
        
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
    } catch (Exception e) { e.printStackTrace(); }
    return 0;
}
/**
     * Lấy danh sách sản phẩm liên quan (cùng danh mục, trừ sản phẩm hiện tại).
     * @param categoryId ID của danh mục.
     * @param currentProductId ID của sản phẩm đang xem (để loại trừ nó).
     * @return Danh sách sản phẩm liên quan.
     */
    public List<Product> getRelatedProducts(int categoryId, int currentProductId) {
        List<Product> list = new ArrayList<>();
        // Lấy 4 sản phẩm ngẫu nhiên cùng danh mục
        String query = "SELECT * FROM products WHERE category_id = ? AND id != ? ORDER BY RAND() LIMIT 4";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, categoryId);
            ps.setInt(2, currentProductId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setId(rs.getInt("id"));
                    p.setName(rs.getString("name"));
                    p.setOriginalPrice(rs.getDouble("original_price"));
                    p.setSalePrice(rs.getDouble("sale_price"));
                    p.setImageUrl(rs.getString("image_url"));
                    // (Không cần lấy tất cả chi tiết, chỉ cần đủ để hiển thị card)
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}