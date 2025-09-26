package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Club;

public class ClubDAO extends DBContext {
    public List<Club> getAllClubs() {
        List<Club> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM Clubs";
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new Club(
                        rs.getInt("clubId"),
                        rs.getString("clubName"),
                        rs.getString("description")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
