package controller.admin;

import dal.ClubDAO;
import dal.EventDAO;
import dal.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Club;
import model.Event;
import model.User;
import java.util.List;

/**
 * Admin Dashboard - Màn hình quản lý hệ thống cho Admin
 */
public class AdminDashboardServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // TODO: Uncomment this when login is implemented
        /*
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Check if user is admin
        User user = (User) session.getAttribute("user");
        if (user.getRoleID() != 1) { // Assuming roleID 1 is Admin
            request.setAttribute("error", "Bạn không có quyền truy cập trang này.");
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
            return;
        }
        */
        
        try {
            // Initialize DAOs
            ClubDAO clubDAO = new ClubDAO();
            EventDAO eventDAO = new EventDAO();
            UserDAO userDAO = new UserDAO();
            
            // Get system statistics
            // 1. Total clubs
            List<Club> allClubs = clubDAO.getAllClubs();
            int totalClubs = allClubs.size();
            int activeClubs = (int) allClubs.stream()
                    .filter(c -> "Active".equals(c.getStatus()))
                    .count();
            int inactiveClubs = totalClubs - activeClubs;
            
            // 2. Total events
            List<Event> allEvents = eventDAO.getAllEvents();
            int totalEvents = allEvents.size();
            int publishedEvents = (int) allEvents.stream()
                    .filter(e -> "Published".equals(e.getStatus()))
                    .count();
            int draftEvents = (int) allEvents.stream()
                    .filter(e -> "Draft".equals(e.getStatus()))
                    .count();
            
            // 3. Total users (TODO: implement getAllUsers in UserDAO)
            int totalUsers = 0; // Placeholder
            
            // 4. Get recent clubs (last 5)
            List<Club> recentClubs = allClubs.size() > 5 ? 
                    allClubs.subList(0, 5) : allClubs;
            
            // 5. Get recent events (last 5)
            List<Event> recentEvents = allEvents.size() > 5 ?
                    allEvents.subList(0, 5) : allEvents;
            
            // 6. Get recent users (placeholder - implement later)
            List<User> recentUsers = new java.util.ArrayList<>();
            
            // Set attributes for JSP
            request.setAttribute("totalClubs", totalClubs);
            request.setAttribute("activeClubs", activeClubs);
            request.setAttribute("inactiveClubs", inactiveClubs);
            
            request.setAttribute("totalEvents", totalEvents);
            request.setAttribute("publishedEvents", publishedEvents);
            request.setAttribute("draftEvents", draftEvents);
            
            request.setAttribute("totalUsers", totalUsers);
            
            request.setAttribute("recentClubs", recentClubs);
            request.setAttribute("recentEvents", recentEvents);
            request.setAttribute("recentUsers", recentUsers);
            
            // Forward to admin dashboard JSP
            request.getRequestDispatcher("/view/admin/admin-dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }
}

