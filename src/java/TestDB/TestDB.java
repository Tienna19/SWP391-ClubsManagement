package TestDB;

import java.sql.*;

public class TestDB {

    public static void main(String[] args) {
        String url = "jdbc:sqlserver://localhost:1433;databaseName=ClubManagement73;encrypt=true;trustServerCertificate=true;";
        String user = "sa"; // đổi thành user SQL Server của bạn
        String password = "hung123"; // đổi thành mật khẩu

        try {
            // Load driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            // Connect
            Connection con = DriverManager.getConnection(url, user, password);
            System.out.println("✅ Connected to SQL Server!");

            // In ClubCategories
            Statement st1 = con.createStatement();
            ResultSet rs1 = st1.executeQuery("SELECT TOP 5 * FROM ClubCategories");
            while (rs1.next()) {
                System.out.println("- ID: " + rs1.getInt("CategoryID") + " | Name: " + rs1.getString("Name"));
            }
            rs1.close();
            st1.close();

// In Clubs
            Statement st2 = con.createStatement();
            ResultSet rs2 = st2.executeQuery("SELECT TOP 5 * FROM Clubs");
            while (rs2.next()) {
                System.out.println("- ID: " + rs2.getInt("ClubID")
                        + " | Name: " + rs2.getString("Name")
                        + " | CategoryID: " + rs2.getInt("CategoryID"));
            }
            rs2.close();
            st2.close();

// In Events
            Statement st3 = con.createStatement();
            ResultSet rs3 = st3.executeQuery("SELECT TOP 5 * FROM Events");
            while (rs3.next()) {
                System.out.println("- ID: " + rs3.getInt("EventID")
                        + " | Title: " + rs3.getString("Title")
                        + " | StartTime: " + rs3.getTimestamp("StartTime"));
            }
            rs3.close();
            st3.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
