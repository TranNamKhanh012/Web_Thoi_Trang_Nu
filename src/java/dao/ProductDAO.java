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
     * @param limit Số lượng sản phẩm tối đa muốn lấy.
     * @return Danh sách các đối tượng Product.
     */
        public List<Product> getTopSellingProducts(int limit) {
        List<Product> list = new ArrayList<>();
        // Sắp xếp theo sold_quantity. COALESCE(sold_quantity, 0) sẽ coi NULL là 0.
        String query = "SELECT * FROM products ORDER BY COALESCE(sold_quantity, 0) DESC LIMIT ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

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
 * @return Danh sách tất cả Product.
 */
public List<Product> getAllProducts() {
    List<Product> list = new ArrayList<>();
    // Thêm subquery để tính tổng stock từ product_sizes
    String query = "SELECT p.*, c.name as category_name, "
                 + "(SELECT SUM(ps.stock) FROM product_sizes ps WHERE ps.product_id = p.id) as total_stock "
                 + "FROM products p "
                 + "LEFT JOIN categories c ON p.category_id = c.id "
                 + "ORDER BY p.id DESC";
    
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(query);
         ResultSet rs = ps.executeQuery()) {
        
        while (rs.next()) {
            Product p = new Product();
            p.setId(rs.getInt("id"));
            p.setName(rs.getString("name"));
            p.setOriginalPrice(rs.getDouble("original_price"));
            p.setSalePrice(rs.getDouble("sale_price"));
            p.setImageUrl(rs.getString("image_url"));
            p.setSoldQuantity(rs.getInt("sold_quantity"));
            p.setCategoryId(rs.getInt("category_id"));
            // Lấy tổng tồn kho từ subquery và gán vào trường mới
            p.setTotalStock(rs.getInt("total_stock"));
            // p.setCategoryName(rs.getString("category_name")); // Nếu có
            list.add(p);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}

/**
 * Lấy tất cả sản phẩm thuộc về một danh mục cụ thể.
 * @param categoryId ID của danh mục cần lọc.
 * @return Danh sách Product thuộc danh mục đó.
 */
public List<Product> getProductsByCategoryId(int categoryId) {
    List<Product> list = new ArrayList<>();
    String query = "SELECT * FROM products WHERE category_id = ?";
    
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {
        
        ps.setInt(1, categoryId);
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

/**
 * Lấy thông tin chi tiết của một sản phẩm bằng ID.
 * @param productId ID của sản phẩm cần tìm.
 * @return một đối tượng Product chứa đầy đủ thông tin, hoặc null nếu không tìm thấy.
 */
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
                    
                    return p;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    // Dán vào bên trong class ProductDAO

/**
 * Lấy ra các sản phẩm mới nhất, sắp xếp theo ngày tạo giảm dần.
 * @param limit Số lượng sản phẩm tối đa muốn lấy.
 * @return Danh sách các đối tượng Product.
 */
    public List<Product> getLatestProducts(int limit) {
        List<Product> list = new ArrayList<>();
        // Sắp xếp giảm dần theo created_date để lấy sản phẩm mới nhất
        String query = "SELECT * FROM products ORDER BY created_date DESC LIMIT ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

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
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); } catch (SQLException ex) { ex.printStackTrace(); }
        }
    }
    // Dán vào bên trong class ProductDAO

    /**
     * Tìm kiếm sản phẩm theo tên.
     * @param keyword Từ khóa tìm kiếm.
     * @return Danh sách sản phẩm có tên chứa từ khóa.
     */
    public List<Product> searchByName(String keyword) {
        List<Product> list = new ArrayList<>();
        // Dùng LIKE %...% để tìm kiếm GẦN ĐÚNG
        String query = "SELECT * FROM products WHERE name LIKE ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

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
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int sumTotalSoldQuantity() {
        String query = "SELECT SUM(COALESCE(sold_quantity, 0)) FROM products";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
    public void deleteProduct(int productId) {
    // Nên xóa cả trong product_sizes trước (do có khóa ngoại ON DELETE CASCADE thì không cần)
    String query = "DELETE FROM products WHERE id = ?";
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {
        ps.setInt(1, productId);
        ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
}
    /**
    * Thêm sản phẩm mới và size/số lượng vào database (dùng transaction).
    * @param product Chi tiết sản phẩm (tên, giá,...).
    * @param sizes Danh sách các đối tượng ProductSize chứa size và số lượng tồn.
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
                       psSize.addBatch(); // Thêm vào batch
                   }
                   psSize.executeBatch(); // Thực thi tất cả cùng lúc
               }
           }

           conn.commit(); // Commit transaction nếu thành công

       } catch (Exception e) {
           productId = -1; // Reset ID nếu lỗi
           if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
           e.printStackTrace();
       } finally {
           if (conn != null) try { conn.setAutoCommit(true); } catch (SQLException ex) { ex.printStackTrace(); }
       }
       return productId;
   }

   /**
    * Cập nhật sản phẩm và size/số lượng (dùng transaction).
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

           // 2. Xóa các size cũ của sản phẩm này
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

    /**
     * Tìm kiếm sản phẩm cho trang admin (bao gồm cả tổng tồn kho).
     * @param keyword Từ khóa tìm kiếm (tên).
     * @return Danh sách sản phẩm khớp.
     */
    public List<Product> searchProductsAdmin(String keyword) {
        List<Product> list = new ArrayList<>();
        String query = "SELECT p.*, c.name as category_name, "
                     + "(SELECT SUM(ps.stock) FROM product_sizes ps WHERE ps.product_id = p.id) as total_stock "
                     + "FROM products p "
                     + "LEFT JOIN categories c ON p.category_id = c.id "
                     + "WHERE p.name LIKE ? " // Chỉ tìm theo tên
                     + "ORDER BY p.id DESC";
        String keywordLike = "%" + keyword + "%";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, keywordLike);
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
                    // p.setCategoryName(rs.getString("category_name")); // Nếu có
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    // Dán vào bên trong class ProductDAO.java

/**
 * Lấy danh sách các sản phẩm đang được giảm giá.
 * Giảm giá khi sale_price > 0 VÀ sale_price < original_price.
 * @return Danh sách Product đang giảm giá, sắp xếp theo ID mới nhất.
 */
public List<Product> getOnSaleProducts() {
    List<Product> list = new ArrayList<>();
    String query = "SELECT p.*, "
                 + "(SELECT SUM(ps.stock) FROM product_sizes ps WHERE ps.product_id = p.id) as total_stock " // Lấy tổng tồn kho
                 + "FROM products p "
                 + "WHERE p.sale_price IS NOT NULL AND p.sale_price > 0 AND p.sale_price < p.original_price "
                 + "ORDER BY p.id DESC"; // Sắp xếp theo ID mới nhất

    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(query);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            Product p = new Product();
            p.setId(rs.getInt("id"));
            p.setName(rs.getString("name"));
            p.setOriginalPrice(rs.getDouble("original_price"));
            p.setSalePrice(rs.getDouble("sale_price"));
            p.setImageUrl(rs.getString("image_url"));
            p.setSoldQuantity(rs.getInt("sold_quantity"));
            p.setCategoryId(rs.getInt("category_id"));
            p.setTotalStock(rs.getInt("total_stock")); // Lấy tổng tồn kho
            list.add(p);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}
}