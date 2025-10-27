package controller.club;

import dal.ClubDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Club;

/**
 * Delete Club Servlet - Xóa/Vô hiệu hóa CLB
 */
public class DeleteClubServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get clubId
            String clubIdParam = request.getParameter("clubId");
            String action = request.getParameter("action"); // "deactivate" or "delete"
            
            if (clubIdParam == null || clubIdParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/viewAllClubs?error=invalid_id");
                return;
            }
            
            int clubId = Integer.parseInt(clubIdParam);
            ClubDAO clubDAO = new ClubDAO();
            Club club = clubDAO.getClubById(clubId);
            
            if (club == null) {
                response.sendRedirect(request.getContextPath() + "/viewAllClubs?error=club_not_found");
                return;
            }
            
            // ✅ CHECK PERMISSIONS: Only Admin or Club Leader can delete
            HttpSession session = request.getSession(false);
            
            // Check if user is logged in
            if (session == null || session.getAttribute("userId") == null) {
                response.sendRedirect(request.getContextPath() + "/login?error=login_required");
                return;
            }
            
            Integer userId = (Integer) session.getAttribute("userId");
            Integer roleId = (Integer) session.getAttribute("roleId");
            
            // Check permissions
            boolean hasPermission = false;
            if (roleId == 1) {
                hasPermission = true; // Admin can delete any club
            } else if (roleId == 2 || roleId == 3) {
                if (club.getCreatedBy() == userId) {
                    hasPermission = true; // Club Leader can delete their own club
                }
            }
            
            if (!hasPermission) {
                response.sendRedirect(request.getContextPath() + "/clubDetail?clubId=" + clubId + "&error=no_permission");
                return;
            }
            
            if ("deactivate".equals(action)) {
                // Vô hiệu hóa CLB (set status = Inactive)
                boolean success = clubDAO.updateClubStatus(clubId, "Inactive");
                
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/viewAllClubs?message=deactivated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/clubDetail?clubId=" + clubId + "&error=deactivate_failed");
                }
                
            } else if ("delete".equals(action)) {
                // Xóa hoàn toàn CLB (hard delete)
                // Note: May fail if there are foreign key constraints
                boolean success = clubDAO.deleteClub(clubId);
                
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/viewAllClubs?message=deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/clubDetail?clubId=" + clubId + "&error=delete_failed");
                }
                
            } else {
                response.sendRedirect(request.getContextPath() + "/viewAllClubs?error=invalid_action");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/viewAllClubs?error=system_error");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect to POST for security
        response.sendRedirect(request.getContextPath() + "/viewAllClubs");
    }
}

