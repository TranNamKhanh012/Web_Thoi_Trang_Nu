package entity;

import java.sql.Timestamp;
import java.util.List;

public class Product {
    private int id;
    private String name;
    private String description;
    private double originalPrice;
    private double salePrice;
    private String imageUrl;
    private int stockQuantity;
    private int soldQuantity;
    private Timestamp createdDate;
    private int categoryId;
    private int totalStock;

    // Constructors
    public Product() {}

    public Product(int id, String name, String description, double originalPrice, double salePrice, String imageUrl, int stockQuantity, int soldQuantity, Timestamp createdDate, int categoryId, int totalStock) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.originalPrice = originalPrice;
        this.salePrice = salePrice;
        this.imageUrl = imageUrl;
        this.stockQuantity = stockQuantity;
        this.soldQuantity = soldQuantity;
        this.createdDate = createdDate;
        this.categoryId = categoryId;
        this.totalStock = totalStock;
    }

    public int getTotalStock() {
        return totalStock;
    }

    public void setTotalStock(int totalStock) {
        this.totalStock = totalStock;
    }
    
    // Getters and Setters (Bạn có thể dùng Alt + Insert trong NetBeans để tạo nhanh)
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public double getOriginalPrice() { return originalPrice; }
    public void setOriginalPrice(double originalPrice) { this.originalPrice = originalPrice; }
    public double getSalePrice() { return salePrice; }
    public void setSalePrice(double salePrice) { this.salePrice = salePrice; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }
    public int getSoldQuantity() { return soldQuantity; }
    public void setSoldQuantity(int soldQuantity) { this.soldQuantity = soldQuantity; }
    public Timestamp getCreatedDate() { return createdDate; }
    public void setCreatedDate(Timestamp createdDate) { this.createdDate = createdDate; }
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
}