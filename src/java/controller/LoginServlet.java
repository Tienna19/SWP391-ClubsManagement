package controller;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("view/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String passwordHash = request.getParameter("passwordHash"); 

        UserDAO dao = new UserDAO();
        User user = dao.getUserByEmail(email);

        if (user != null && BCrypt.checkpw(passwordHash, user.getPasswordHash())) {
            HttpSession session = request.getSession();
            session.setAttribute("account", user);
            response.sendRedirect("home");
        } else {
            request.setAttribute("error", "Sai tài khoản hoặc mật khẩu!");
            request.getRequestDispatcher("view/auth/login.jsp").forward(request, response);
        }
    }
}
