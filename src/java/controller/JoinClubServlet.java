package controller;

import dal.JoinClubRequestDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Function: Request to Join a Club
 * Description: Handles student requests to join a specific club.
 */
@WebServlet(name = "JoinClubServlet", urlPatterns = {"/JoinClubServlet"})
public class JoinClubServlet extends HttpServlet {

    private final JoinClubRequestDAO dao = new JoinClubRequestDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward đến form join club
        request.getRequestDispatcher("joinClub.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            //️ Lấy dữ liệu từ form
            int userId = Integer.parseInt(request.getParameter("userId"));
            int clubId = Integer.parseInt(request.getParameter("clubId"));            
            String reason = request.getParameter("reason");
            
            // Kiểm tra tình trạng hiện tại
            if (dao.isAlreadyMember(userId, clubId)) {
                request.setAttribute("message", "You are already a member of this club.");
            } else if (dao.hasPendingRequest(userId, clubId)) {
                request.setAttribute("message", "You already have a pending join request for this club.");
            } else {
                // Gửi yêu cầu tham gia mới
                dao.createJoinRequest(userId, clubId, reason);
                request.setAttribute("message", "Your join request has been submitted successfully!");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("message", "Invalid input data.");
        } catch (Exception e) {
            request.setAttribute("message", "System error: " + e.getMessage());
        }

        // Quay lại form sau khi xử lý
        request.getRequestDispatcher("joinClub.jsp").forward(request, response);
    }
}

