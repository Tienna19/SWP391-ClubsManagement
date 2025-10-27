package controller.club;

import dal.ClubDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Club;

/**
 * Update Club Servlet - Cập nhật thông tin CLB
 */
public class UpdateClubServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get clubId
            String clubIdParam = request.getParameter("clubId");
            
            if (clubIdParam == null || clubIdParam.isEmpty()) {
                request.setAttribute("error", "Club ID không hợp lệ.");
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
                return;
            }
            
            int clubId = Integer.parseInt(clubIdParam);
            ClubDAO clubDAO = new ClubDAO();
            Club club = clubDAO.getClubById(clubId);
            
            if (club == null) {
                request.setAttribute("error", "CLB không tồn tại.");
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
                return;
            }
            
            // TODO: Check if user is leader of this club (when login is implemented)
            
            // Set club for edit form
            request.setAttribute("club", club);
            request.getRequestDispatcher("/view/club/edit-club.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get form data
            int clubId = Integer.parseInt(request.getParameter("clubId"));
            String clubName = request.getParameter("clubName");
            String description = request.getParameter("description");
            String clubTypes = request.getParameter("clubTypes");
            String status = request.getParameter("status");
            
            // Validate
            if (clubName == null || clubName.trim().isEmpty()) {
                request.setAttribute("error", "Tên CLB không được để trống.");
                doGet(request, response);
                return;
            }
            
            // Get existing club
            ClubDAO clubDAO = new ClubDAO();
            Club club = clubDAO.getClubById(clubId);
            
            if (club == null) {
                request.setAttribute("error", "CLB không tồn tại.");
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
                return;
            }
            
            // Update club info
            club.setClubName(clubName);
            club.setDescription(description);
            club.setClubTypes(clubTypes);
            club.setStatus(status);
            
            // Update in database
            boolean success = clubDAO.updateClub(club);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/clubDetail?clubId=" + clubId + "&message=update_success");
            } else {
                request.setAttribute("error", "Cập nhật thất bại. Vui lòng thử lại.");
                request.setAttribute("club", club);
                request.getRequestDispatcher("/view/club/edit-club.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi cập nhật: " + e.getMessage());
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }
}

