package entity;

import java.util.HashMap;
import java.util.Map;

public class Cart {
    // THAY ĐỔI TỪ Map<Integer, CartItem>
    private Map<String, CartItem> items;
    private static final int PROMO_QUANTITY_THRESHOLD = 3; // Mua từ 3 sản phẩm
    private static final double PROMO_AMOUNT = 50000;
    public Cart() {
        items = new HashMap<>();
    }
    
    public Map<String, CartItem> getItems() {
        return items;
    }

    // Tạo key
    private String getKey(CartItem item) {
        return item.getProduct().getId() + "_" + item.getSize();
    }

    public void addItem(CartItem newItem) {
        String key = getKey(newItem);
        if (items.containsKey(key)) {
            CartItem existingItem = items.get(key);
            existingItem.setQuantity(existingItem.getQuantity() + newItem.getQuantity());
        } else {
            items.put(key, newItem);
        }
    }

    public void removeItem(int productId, String size) {
        String key = productId + "_" + size;
        if (items.containsKey(key)) {
            items.remove(key);
        }
    }

    public void updateItem(int productId, String size, int quantity) {
        String key = productId + "_" + size;
        if (items.containsKey(key)) {
            if (quantity > 0) {
                items.get(key).setQuantity(quantity);
            } else {
                removeItem(productId, size);
            }
        }
    }

    public int getTotalQuantity() {
        int total = 0;
        for (CartItem item : items.values()) {
            total += item.getQuantity();
        }
        return total;
    }

    public double getTotalMoney() {
        double total = 0;
        for (CartItem item : items.values()) {
            total += item.getTotalPrice();
        }
        return total;
    }
    // --- PHƯƠNG THỨC MỚI 1: TÍNH GIẢM GIÁ ---
    /**
     * Tính toán số tiền được giảm giá.
     * @return 50000 nếu tổng số lượng >= 3, ngược lại trả về 0.
     */
    public double getDiscount() {
        if (getTotalQuantity() >= PROMO_QUANTITY_THRESHOLD) {
            return PROMO_AMOUNT;
        }
        return 0;
    }
    
    // --- PHƯƠNG THỨC MỚI 2: TÍNH TỔNG TIỀN CUỐI CÙNG ---
    /**
     * Lấy tổng tiền cuối cùng sau khi đã áp dụng giảm giá.
     * @return Tổng tiền (đảm bảo không bị âm).
     */
    public double getFinalTotal() {
        double subtotal = getTotalMoney();
        double discount = getDiscount();
        double finalTotal = subtotal - discount;
        
        // Đảm bảo tổng tiền không bao giờ âm
        return Math.max(0, finalTotal); 
    }
}