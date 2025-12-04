package service;

import dao.SettingDAO;
import java.time.DayOfWeek;
import java.time.LocalDate;

public class PromotionService {
    
    // Kiểm tra xem HÔM NAY có phải ngày khuyến mãi không
    public static boolean isPromotionActive() {
        SettingDAO dao = new SettingDAO();
        
        // 1. Kiểm tra có BẬT không
        String enable = dao.getValue("PROMO_ENABLE");
        if (enable == null || !enable.equals("1")) {
            return false; // Đang tắt
        }
        
        // 2. Kiểm tra NGÀY hiện tại
        String daysConfig = dao.getValue("PROMO_DAYS"); // Ví dụ: "SATURDAY,SUNDAY,FRIDAY"
        if (daysConfig == null || daysConfig.isEmpty()) {
            return false;
        }
        
        LocalDate today = LocalDate.now();
        String currentDay = today.getDayOfWeek().name(); // Lấy tên ngày hiện tại (ví dụ: FRIDAY)
        
        // Kiểm tra xem ngày hiện tại có trong chuỗi cấu hình không
        return daysConfig.contains(currentDay);
    }

    // Lấy % giảm giá (trả về số thập phân, ví dụ 0.10)
    public static double getDiscountRate() {
        SettingDAO dao = new SettingDAO();
        String percentStr = dao.getValue("PROMO_PERCENT");
        try {
            double percent = Double.parseDouble(percentStr);
            return percent / 100.0; // Chuyển 10 thành 0.1
        } catch (Exception e) {
            return 0.0;
        }
    }
}