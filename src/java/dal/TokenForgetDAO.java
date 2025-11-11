/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import model.TokenForgetPassword;

/**
 *
 * @author HP
 */
public class TokenForgetDAO extends DBContext{
    
     public String getFormatDate(LocalDateTime myDateObj) {
        DateTimeFormatter myFormatObj = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");  
        String formattedDate = myDateObj.format(myFormatObj);  
        return formattedDate;
     }
    
public boolean insertTokenForget(TokenForgetPassword tokenForget) {
    String sql = "INSERT INTO TokenForgetPassword (Token, ExpiryTime, IsUsed, UserID) VALUES (?, ?, ?, ?)";
    try {
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setString(1, tokenForget.getToken());
        ps.setTimestamp(2, tokenForget.getExpiryTime());
        ps.setBoolean(3, tokenForget.isIsUsed());
        ps.setInt(4, tokenForget.getUserId());
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        System.out.println("❌ insertTokenForget error: " + e);
    }
    return false;
}

public TokenForgetPassword getTokenPassword(String token) {
    String sql = "SELECT * FROM TokenForgetPassword WHERE Token = ?";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setString(1, token);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            return new TokenForgetPassword(
                rs.getInt("ID"),
                rs.getInt("UserID"),
                rs.getBoolean("IsUsed"),
                rs.getString("Token"),
                rs.getTimestamp("ExpiryTime")
            );
        }
    } catch (SQLException e) {
        System.out.println("❌ getTokenPassword error: " + e);
    }
    return null;
}

    
    public void updateStatus(TokenForgetPassword token) {
        System.out.println("token = "+token);
        String sql = "UPDATE TokenForgetPassword SET IsUsed = ? WHERE Token = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setBoolean(1, token.isIsUsed());
            st.setString(2, token.getToken());
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }
    
}
