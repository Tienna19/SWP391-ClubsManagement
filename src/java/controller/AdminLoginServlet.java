package controller;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet(name = "AdminLoginServlet", urlPatterns = {"/adminlogin"})
public class AdminLoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("view/club/adminLogin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String passwordHash = request.getParameter("passwordHash");

        UserDAO dao = new UserDAO();
        User user = dao.getUserByEmail(email);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("account", user);

            if (user.getRoleId() == 4 || user.getRoleId() == 3) {
                response.sendRedirect(request.getContextPath() + "/view/club/club-leader-dashboard.jsp");
            }
        } else {
            request.setAttribute("error", "Wrong account or password!");
            request.getRequestDispatcher("view/club/adminLogin.jsp").forward(request, response);
        }
    }
}
