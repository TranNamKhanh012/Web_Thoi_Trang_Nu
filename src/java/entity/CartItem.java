package entity;

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
    
    // Phương thức tính tổng tiền cho món hàng này
    public double getTotalPrice() {
        // Giá bán thực tế có thể là sale_price hoặc original_price
        double price = product.getSalePrice();
        if (price <= 0) {
            price = product.getOriginalPrice();
        }
        return price * quantity;
    }
}