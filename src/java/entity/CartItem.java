package entity;

import java.time.DayOfWeek;
import java.time.LocalDate;
import service.PromotionService;

public class CartItem {
    private Product product;
    private int quantity;
    private String size;

    public CartItem() {}

    public CartItem(Product product, int quantity, String size) {
        this.product = product;
        this.quantity = quantity;
        this.size = size;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    public double getEffectivePrice() {
        double price = product.getSalePrice();
        
       // GỌI SERVICE ĐỂ KIỂM TRA (Thay vì check DayOfWeek tại chỗ)
        if (PromotionService.isPromotionActive()) {
            double discountRate = PromotionService.getDiscountRate();
            return price * (1.0 - discountRate);
        }
        
        return price;
    }
    
    // Phương thức tính tổng tiền cho món hàng này
    public double getTotalPrice() {
        // CŨ (SAI): return product.getSalePrice() * quantity;
        
        // MỚI (ĐÚNG): Phải gọi getEffectivePrice() để lấy giá đã giảm
        return getEffectivePrice() * quantity;
    }
}