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
            
            // Set user information in session
            session.setAttribute("account", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("roleId", user.getRoleId());
            session.setAttribute("fullName", user.getFullName());
            session.setAttribute("email", user.getEmail());
            
            // Check for redirect parameter (for guest → login → back to page)
            String redirect = request.getParameter("redirect");
            String clubId = request.getParameter("clubId");
            String eventId = request.getParameter("eventId");
            
            if ("clubDetail".equals(redirect) && clubId != null) {
                // Redirect back to club detail page
                String redirectUrl = "clubDetail?clubId=" + clubId;
                if (eventId != null) {
                    redirectUrl += "&eventId=" + eventId;
                }
                response.sendRedirect(redirectUrl);
            } else {
                // Default redirect to home
                response.sendRedirect("home");
            }
        } else {
            request.setAttribute("error", "Sai tài khoản hoặc mật khẩu!");
            request.getRequestDispatcher("view/auth/login.jsp").forward(request, response);
        }
    }
}
