package dao;

import context.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class QrDAO {

    // 1. Tạo token mới (trạng thái PENDING)
    public void createToken(String token) {
        String sql = "INSERT INTO qr_tokens (token, status) VALUES (?, 'PENDING')";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 2. Kiểm tra trạng thái Token (Dành cho máy tính hỏi liên tục)
    // Trả về chuỗi: "PENDING" hoặc "CONFIRMED:userId"
    public String checkStatus(String token) {
        String sql = "SELECT status, user_id FROM qr_tokens WHERE token = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String status = rs.getString("status");
                int userId = rs.getInt("user_id");
                if ("CONFIRMED".equals(status)) {
                    return "CONFIRMED:" + userId; // Trả về kèm ID người dùng
                }
                return status;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return "ERROR";
    }

    // 3. Xác nhận Token (Dành cho điện thoại quét)
    public void confirmToken(String token, int userId) {
        String sql = "UPDATE qr_tokens SET status = 'CONFIRMED', user_id = ? WHERE token = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, token);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}