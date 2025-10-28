package dao;

import java.sql.*;
import context.DBContext;
import entity.Feedback;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    public boolean addFeedback(String name, String email, String subject, String message) {
        String query = "INSERT INTO feedback (name, email, subject, message) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, subject);
            ps.setString(4, message);
            int result = ps.executeUpdate();
            return result > 0; // Trả về true nếu thêm thành công
        } catch (Exception e) {
            e.printStackTrace();
            return false; // Trả về false nếu có lỗi
        }
    }
    
    // *** THÊM PHƯƠNG THỨC MỚI ***
    public List<Feedback> getAllFeedback() {
        List<Feedback> list = new ArrayList<>();
        // Sắp xếp theo ngày mới nhất lên đầu
        String query = "SELECT * FROM feedback ORDER BY received_date DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Feedback fb = new Feedback();
                fb.setId(rs.getInt("id"));
                fb.setName(rs.getString("name"));
                fb.setEmail(rs.getString("email"));
                fb.setSubject(rs.getString("subject"));
                fb.setMessage(rs.getString("message"));
                fb.setReceivedDate(rs.getTimestamp("received_date"));
                fb.setStatus(rs.getString("status"));
                list.add(fb);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Thêm phương thức cập nhật trạng thái (để dùng sau này)
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