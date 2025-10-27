package controller.club;

import dal.ClubDAO;
import dal.EventDAO;
import dal.MemberDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Club;
import model.Event;
import com.app.model.MemberDTO;
import java.util.List;

/**
 * View Club Detail Servlet - Xem chi tiết CLB
 */
public class ViewClubDetailServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get clubId from parameter
            String clubIdParam = request.getParameter("clubId");
            
            if (clubIdParam == null || clubIdParam.isEmpty()) {
                request.setAttribute("error", "Club ID không hợp lệ.");
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
                return;
            }
            
            int clubId = Integer.parseInt(clubIdParam);
            
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
            
            // Get club members
            List<MemberDTO> members = memberDAO.findMembersByClub(clubId);
            
            // Get club events
            List<Event> events = eventDAO.getEventsByClubId(clubId);
            
            // Check user role from session
            HttpSession session = request.getSession(false);
            Integer userRoleId = null;
            Integer userId = null;
            boolean isLeaderOrAdmin = false;
            boolean isGuest = (session == null); // Guest = not logged in
            
            if (session != null) {
                userRoleId = (Integer) session.getAttribute("roleId");
                userId = (Integer) session.getAttribute("userId");
                
                // RoleID: 1=Admin, 2=ClubLeader, 3=Member, 4=User
                if (userRoleId != null) {
                    if (userRoleId == 1 || userRoleId == 2) {
                        isLeaderOrAdmin = true;
                    } else if (userRoleId == 3 && userId != null) {
                        // Check if this member is a leader of this club
                        isLeaderOrAdmin = memberDAO.isClubLeader(userId, clubId);
                    }
                }
            }
            
            // Set attributes
            request.setAttribute("club", club);
            request.setAttribute("members", members);
            request.setAttribute("events", events);
            request.setAttribute("totalMembers", members.size());
            request.setAttribute("totalEvents", events.size());
            request.setAttribute("isLeaderOrAdmin", isLeaderOrAdmin);
            request.setAttribute("isGuest", isGuest);
            request.setAttribute("userRoleId", userRoleId);
            
            // Forward to detail page
            request.getRequestDispatcher("/view/club/club-detail.jsp").forward(request, response);
            
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

