package controller;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.User;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        User sessionUser = (User) session.getAttribute("account");

        if (sessionUser == null) {
            response.sendRedirect("login");
            return;
        }

        UserDAO dao = new UserDAO();
        User user = dao.getBasicUserInfoById(sessionUser.getUserId());

        if (user == null) {
            session.invalidate();
            response.sendRedirect("login");
            return;
        }

        request.setAttribute("userInfo", user);

        String message = request.getParameter("message");
        if (message != null && !message.isEmpty()) {
            request.setAttribute("message", message);
        }

        request.getRequestDispatcher("view/user/profile.jsp").forward(request, response);
    }
}
