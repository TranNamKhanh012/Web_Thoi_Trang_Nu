package entity;

import java.util.HashMap;
import java.util.Map;

public class Cart {
    // THAY ĐỔI TỪ Map<Integer, CartItem>
    private Map<String, CartItem> items;

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
}