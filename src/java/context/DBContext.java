package context;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Lớp này chịu trách nhiệm quản lý và cung cấp kết nối đến cơ sở dữ liệu.
 */
public class DBContext {

    // Thay đổi các thông số này nếu cấu hình XAMPP của bạn khác
    private static final String DB_URL = "jdbc:mysql://localhost:3306/shop_fashion";
    private static final String USER = "root";
    private static final String PASS = "";
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    /**
     * Phương thức tĩnh để lấy kết nối đến CSDL.
     * @return một đối tượng Connection hoặc null nếu có lỗi.
     * @throws ClassNotFoundException
     * @throws SQLException
     */
    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName(DRIVER);
        return DriverManager.getConnection(DB_URL, USER, PASS);
    }
}