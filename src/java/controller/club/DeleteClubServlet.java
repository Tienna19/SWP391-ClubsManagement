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
            
            // TODO: Check if user is leader or admin (when login is implemented)
            
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

