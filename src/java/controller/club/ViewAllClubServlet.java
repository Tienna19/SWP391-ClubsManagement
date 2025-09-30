package controller.club;

import dal.ClubDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;
import model.Category;
import model.Club;

@WebServlet("/clubs") // 🔹 mapping đồng bộ với JSP
public class ViewAllClubServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ClubDAO dao = new ClubDAO();

        // Lấy tham số filter từ JSP
        String categoryIdParam = request.getParameter("categoryId");
        String status = request.getParameter("status");
        String keyword = request.getParameter("keyword");

        Integer categoryId = (categoryIdParam != null && !categoryIdParam.isEmpty())
                ? Integer.parseInt(categoryIdParam) : null;

        // Gọi DAO để lấy danh sách clubs có filter
        List<Club> clubs = dao.getFilteredClubs(categoryId, status, keyword);

        // Lấy categories cho dropdown
        List<Category> categories = dao.getAllCategories();

        // Truyền dữ liệu sang JSP
        request.setAttribute("clubs", clubs);
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("/view/club/viewAllClubs.jsp").forward(request, response);
    }
}
