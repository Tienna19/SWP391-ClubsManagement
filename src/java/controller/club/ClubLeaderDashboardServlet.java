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
import model.User;
import com.app.model.MemberDTO;
import java.util.List;

/**
 * Club Leader Dashboard - Màn hình quản lý cho Club Leader
 */
public class ClubLeaderDashboardServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            HttpSession session = request.getSession(false);
            
            // Check if user is logged in
            if (session == null || session.getAttribute("account") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            // Get user from session
            User user = (User) session.getAttribute("account");
            
            // Try to get clubId from session first (set by login), then from parameter
            Integer clubId = null;
            Object currentClubId = session.getAttribute("currentClubId");
            if (currentClubId != null) {
                clubId = (Integer) currentClubId;
            } else {
                String clubIdParam = request.getParameter("clubId");
                if (clubIdParam != null && !clubIdParam.isEmpty()) {
                    clubId = Integer.parseInt(clubIdParam);
                }
            }
            
            // If still no clubId, try to get from user's clubs
            if (clubId == null) {
                MemberDAO memberDAO = new MemberDAO();
                List<Integer> clubIds = memberDAO.getClubsWhereUserIsLeader(user.getUserId());
                
                if (!clubIds.isEmpty()) {
                    clubId = clubIds.get(0); // Use first club
                    session.setAttribute("currentClubId", clubId);
                }
            }
            
            if (clubId == null) {
                request.setAttribute("error", "Bạn chưa có CLB nào để quản lý.");
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
            request.getRequestDispatcher("/view/club/club-leader-dashboard-new.jsp").forward(request, response);
            
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

