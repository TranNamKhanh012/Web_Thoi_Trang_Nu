package dao;

import context.DBContext;
import entity.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // Kiểm tra đăng nhập
    public User checkLogin(String email, String password) {
        String query = "SELECT * FROM users WHERE email = ? AND password = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, email);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setFullname(rs.getString("fullname"));
                    user.setEmail(rs.getString("email"));
                    user.setRole(rs.getString("role"));
                    return user;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Kiểm tra email đã tồn tại chưa
    public boolean checkUserExist(String email) {
        String query = "SELECT count(*) FROM users WHERE email = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Đăng ký tài khoản mới
    public void registerUser(String fullname, String email, String phone, String password, String address) {
        String query = "INSERT INTO users (fullname, email, phone_number, password, role, address) VALUES (?, ?, ?, ?, 'customer',?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, fullname);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, password);
            ps.setString(5, address);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    // Dán vào bên trong class UserDAO
    public int countTotalUsers() {
        String query = "SELECT COUNT(*) FROM users";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
    // Dán vào class UserDAO

// Tìm user bằng email
public User findByEmail(String email) {
    String query = "SELECT * FROM users WHERE email = ?";
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {
        ps.setString(1, email);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setEmail(rs.getString("email"));
                // Lấy các trường khác nếu cần
                return user;
            }
        }
    } catch (Exception e) { e.printStackTrace(); }
    return null;
}

// Lưu token và thời gian hết hạn (ví dụ: 1 giờ)
    public void updateResetToken(String email, String token) {
        // Thời gian hết hạn = thời gian hiện tại + 1 giờ
        Timestamp expiryTime = new Timestamp(System.currentTimeMillis() + 3600 * 1000); // 3600 giây * 1000 ms
        String query = "UPDATE users SET reset_token = ?, reset_token_expiry = ? WHERE email = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, token);
            ps.setTimestamp(2, expiryTime);
            ps.setString(3, email);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // Tìm user bằng token và kiểm tra hạn
    public User findByResetToken(String token) {
        String query = "SELECT * FROM users WHERE reset_token = ? AND reset_token_expiry > NOW()"; // Chỉ lấy token còn hạn
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setEmail(rs.getString("email"));
                    // Lấy các trường khác nếu cần
                    return user;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // Cập nhật mật khẩu mới và xóa token
    public void updatePasswordAndClearToken(int userId, String newPassword) {
        String query = "UPDATE users SET password = ?, reset_token = NULL, reset_token_expiry = NULL WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, newPassword);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
    // Dán vào bên trong class UserDAO

    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String query = "SELECT id, fullname, email, phone_number, role, created_date FROM users ORDER BY id ASC"; // Lấy các cột cần thiết
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setFullname(rs.getString("fullname"));
                user.setEmail(rs.getString("email"));
                user.setPhoneNumber(rs.getString("phone_number"));
                user.setRole(rs.getString("role"));
                // Lấy created_date nếu cần hiển thị
                list.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void deleteUser(int userId) {
        // Lưu ý: Cần xử lý cẩn thận nếu user có đơn hàng hoặc giỏ hàng (khóa ngoại)
        // Có thể cần cập nhật đơn hàng để user_id = NULL hoặc không cho xóa
        String query = "DELETE FROM users WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            // Nên bắt SQLException cụ thể để thông báo lỗi khóa ngoại
            e.printStackTrace();
        }
    }
    // Dán vào bên trong class UserDAO

    // Lấy thông tin user theo ID (để sửa)
    public User getUserById(int userId) {
        String query = "SELECT id, fullname, email, phone_number, address, role FROM users WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setFullname(rs.getString("fullname"));
                    user.setEmail(rs.getString("email"));
                    user.setPhoneNumber(rs.getString("phone_number"));
                    user.setAddress(rs.getString("address"));
                    user.setRole(rs.getString("role"));
                    return user;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // Thêm người dùng mới (chú ý xử lý mật khẩu - nên mã hóa)
    public void addUser(String fullname, String email, String phone, String password, String address, String role) {
        // Cần kiểm tra email tồn tại trước khi thêm!
        if (checkUserExist(email)) {
            System.err.println("Email already exists: " + email);
            return; // Hoặc ném Exception
        }
        String query = "INSERT INTO users (fullname, email, phone_number, password, role, address) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, fullname);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, password); // Nên mã hóa mật khẩu trước khi lưu
            ps.setString(5, role);
            ps.setString(6, address);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // Cập nhật thông tin người dùng (không cập nhật mật khẩu ở đây)
    public void updateUser(int userId, String fullname, String email, String phone, String address, String role) {
        // Cần kiểm tra email mới (nếu thay đổi) có bị trùng không!
        String query = "UPDATE users SET fullname = ?, email = ?, phone_number = ?, address = ?, role = ? WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, fullname);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, address);
            ps.setString(5, role);
            ps.setInt(6, userId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // Cập nhật mật khẩu (nếu cần trang riêng)
    public void updateUserPassword(int userId, String newPassword) {
        String query = "UPDATE users SET password = ? WHERE id = ?";
         try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, newPassword); // Nên mã hóa mật khẩu
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
    // Dán vào bên trong class UserDAO

    /**
     * Tìm kiếm người dùng theo tên hoặc email.
     * @param keyword Từ khóa tìm kiếm.
     * @return Danh sách User khớp với từ khóa.
     */
    public List<User> searchUsers(String keyword) {
        List<User> list = new ArrayList<>();
        // Tìm kiếm trong cả fullname và email
        String query = "SELECT id, fullname, email, phone_number, role, created_date FROM users "
                     + "WHERE fullname LIKE ? OR email LIKE ? "
                     + "ORDER BY id ASC";
        String keywordLike = "%" + keyword + "%"; // Chuẩn bị keyword cho LIKE

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, keywordLike); // Gán vào fullname LIKE ?
            ps.setString(2, keywordLike); // Gán vào email LIKE ?

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setFullname(rs.getString("fullname"));
                    user.setEmail(rs.getString("email"));
                    user.setPhoneNumber(rs.getString("phone_number"));
                    user.setRole(rs.getString("role"));
                    list.add(user);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}