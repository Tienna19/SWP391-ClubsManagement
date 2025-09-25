/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.DBContext to edit this template
 */
package DBContext;

/**
 *
 * @author admin
 */
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=ClubManagement73;encrypt=true;trustServerCertificate=true";
    private static final String USER = "sa"; // đổi thành user của bạn
    private static final String PASSWORD = "hung123"; // đổi thành password thật

    public static Connection getConnection() throws SQLException {
        try {
            // Load driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            // Kết nối
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Không tìm thấy JDBC Driver", e);
        }
    }
}
