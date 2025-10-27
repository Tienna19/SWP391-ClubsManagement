package controller.club;

import dal.ClubDAO;
import dal.EventDAO;
import dal.MemberDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Club;
import model.Event;
import model.MemberDTO;
import java.util.List;

/**
 * Club Leader Dashboard - Màn hình quản lý cho Club Leader
 */
public class ClubLeaderDashboardServlet extends HttpServlet {
    
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
        
        // Get user info from session
        Integer userId = (Integer) session.getAttribute("userID");
        */
        
        try {
            // TEMPORARY: For testing without login - remove this when login is ready
            Integer userId = 1; // Mock user ID
            
            // Get clubId from parameter
            String clubIdParam = request.getParameter("clubId");
            Integer clubId = null;
            
            if (clubIdParam != null && !clubIdParam.isEmpty()) {
                clubId = Integer.parseInt(clubIdParam);
            }
            
            if (clubId == null) {
                request.setAttribute("error", "Vui lòng cung cấp clubId. Ví dụ: /clubDashboard?clubId=1");
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
                return;
            }
            
            // Initialize DAOs
            ClubDAO clubDAO = new ClubDAO();
            EventDAO eventDAO = new EventDAO();
            MemberDAO memberDAO = new MemberDAO();
            
            // Get club details
            Club club = clubDAO.getClubById(clubId);
            if (club == null) {
                request.setAttribute("error", "CLB không tồn tại.");
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
                return;
            }
            
            // TODO: Uncomment this when login is implemented
            /*
            // Verify user is leader of this club
            boolean isLeader = memberDAO.isClubLeader(userId, clubId);
            if (!isLeader) {
                request.setAttribute("error", "Bạn không có quyền quản lý CLB này.");
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
                return;
            }
            */
            
            // Get dashboard statistics
            // 1. Members count
            List<MemberDTO> members = memberDAO.findMembersByClub(clubId);
            int totalMembers = members.size();
            
            // 2. Events count
            List<Event> upcomingEvents = eventDAO.getEventsByClubId(clubId);
            int totalEvents = upcomingEvents.size();
            
            // Get recent events (limit 5)
            List<Event> recentEvents = upcomingEvents.size() > 5 ? 
                    upcomingEvents.subList(0, 5) : upcomingEvents;
            
            // 3. Pending requests count (if you have join requests feature)
            int pendingRequests = 0; // TODO: implement getPendingJoinRequests()
            
            // Set attributes for JSP
            request.setAttribute("club", club);
            request.setAttribute("totalMembers", totalMembers);
            request.setAttribute("totalEvents", totalEvents);
            request.setAttribute("pendingRequests", pendingRequests);
            request.setAttribute("members", members);
            request.setAttribute("recentEvents", recentEvents);
            
            // Forward to dashboard JSP
            request.getRequestDispatcher("/view/club/club-leader-dashboard.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Club ID không hợp lệ.");
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }
}

