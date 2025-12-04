package dao;

import context.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class SettingDAO {

    // Lấy giá trị setting theo key
    public String getValue(String key) {
        String query = "SELECT value FROM settings WHERE key_name = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, key);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("value");
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // Cập nhật setting
    public void updateValue(String key, String value) {
        String query = "UPDATE settings SET value = ? WHERE key_name = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, value);
            ps.setString(2, key);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}