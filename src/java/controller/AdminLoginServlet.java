package controller;

import dal.MemberDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet(name = "AdminLoginServlet", urlPatterns = {"/admin-login"})
public class AdminLoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("view/auth/adminLogin.jsp").forward(request, response);
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
            
            // Check user role and redirect accordingly
            int roleId = user.getRoleId();
            
            if ("clubDetail".equals(redirect) && clubId != null) {
                // Redirect back to club detail page
                String redirectUrl = "clubDetail?clubId=" + clubId;
                if (eventId != null) {
                    redirectUrl += "&eventId=" + eventId;
                }
                response.sendRedirect(redirectUrl);
            } else if (roleId == 3) {
                // RoleID 3 = ClubLeader - redirect to club leader dashboard
                // Store club ID in session
                MemberDAO memberDAO = new MemberDAO();
                List<Integer> clubIds = memberDAO.getClubsWhereUserIsLeader(user.getUserId());
                
                if (!clubIds.isEmpty()) {
                    // Store first club ID in session
                    session.setAttribute("currentClubId", clubIds.get(0));
                    System.out.println("Redirecting ClubLeader to dashboard with club: " + clubIds.get(0));
                    response.sendRedirect("clubDashboard");
                } else {
                    // No clubs found, redirect to home
                    System.out.println("ClubLeader has no clubs, redirecting to home");
                    response.sendRedirect("home");
                }
            } else {
                // Default redirect to home for other roles
                response.sendRedirect("home");
            }
        } else {
            request.setAttribute("error", "Sai tài khoản hoặc mật khẩu!");
            request.getRequestDispatcher("view/auth/adminLogin.jsp").forward(request, response);
        }
    }
}
