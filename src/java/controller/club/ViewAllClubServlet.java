package controller.club;

import dal.ClubDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;
import model.Club;

@WebServlet("/viewAllClubs")
public class ViewAllClubServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ClubDAO dao = new ClubDAO();
        List<Club> list = dao.getAllClubs();

        request.setAttribute("clubs", list);
        // forward tới đúng view
        request.getRequestDispatcher("/view/club/viewAllClubs.jsp").forward(request, response);
    }
}
