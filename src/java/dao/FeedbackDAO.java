package dao;

import context.DBContext;
import entity.Feedback;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException; // Nên import cụ thể
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    /**
     * THAY ĐỔI: Thêm feedback mới từ một user đã đăng nhập.
     * Xóa name, email và thay bằng userId.
     */
    public boolean insertFeedback(int userId, String subject, String message) {
        String query = "INSERT INTO feedback (user_id, subject, message, status) VALUES (?, ?, ?, 'new')";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, userId);
            ps.setString(2, subject);
            ps.setString(3, message);
            int result = ps.executeUpdate();
            return result > 0; // Trả về true nếu thêm thành công
            
        } catch (Exception e) {
            e.printStackTrace();
            return false; // Trả về false nếu có lỗi
        }
    }
    
    /**
     * THAY ĐỔI: Lấy tất cả feedback và JOIN với bảng users.
     */
    public List<Feedback> getAllFeedback() {
        List<Feedback> list = new ArrayList<>();
        // SỬA CÂU QUERY: JOIN với bảng users để lấy fullname và email
        String query = "SELECT f.*, u.fullname, u.email "
                     + "FROM feedback f "
                     + "LEFT JOIN users u ON f.user_id = u.id " // Dùng LEFT JOIN phòng trường hợp user bị xóa
                     + "ORDER BY f.received_date DESC";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Feedback fb = new Feedback();
                fb.setId(rs.getInt("id"));
                fb.setUserId(rs.getInt("user_id"));
                fb.setSubject(rs.getString("subject"));
                fb.setMessage(rs.getString("message"));
                fb.setReceivedDate(rs.getTimestamp("received_date"));
                fb.setStatus(rs.getString("status"));
                
                // Lấy thông tin từ bảng users (các trường "ảo")
                fb.setUserName(rs.getString("fullname"));
                fb.setUserEmail(rs.getString("email"));
                
                list.add(fb);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Giữ nguyên phương thức cập nhật trạng thái
    public void updateFeedbackStatus(int id, String status) {
        String query = "UPDATE feedback SET status = ? WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}