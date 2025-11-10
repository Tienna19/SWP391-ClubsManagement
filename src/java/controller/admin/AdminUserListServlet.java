package controller.admin;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.User;

public class AdminUserListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("roleId") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=login_required");
            return;
        }

        Integer roleId = (Integer) session.getAttribute("roleId");
        if (roleId == null || roleId != 4) {
            request.setAttribute("error", "Chỉ Admin mới có quyền xem danh sách người dùng.");
            request.setAttribute("errorCode", "403");
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        List<User> users = userDAO.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/view/admin/admin-user-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
