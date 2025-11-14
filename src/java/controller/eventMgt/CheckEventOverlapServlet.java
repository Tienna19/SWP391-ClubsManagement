/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package controller.eventMgt;

import dal.EventDAO;
import dal.MemberDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.List;
import model.User;

/**
 * Servlet for checking event overlap via AJAX
 */
@WebServlet(name = "CheckEventOverlapServlet", urlPatterns = {"/checkEventOverlap"})
public class CheckEventOverlapServlet extends HttpServlet {

    private EventDAO eventDAO;

    @Override
    public void init() {
        eventDAO = new EventDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            sendJsonResponse(response, false, "Bạn cần đăng nhập để thực hiện thao tác này.");
            return;
        }
        
        User user = (User) session.getAttribute("account");
        int userRoleId = user.getRoleId();
        
        // Only check for club leaders
        if (userRoleId != 3) {
            sendJsonResponse(response, true, ""); // No overlap for non-club-leaders
            return;
        }
        
        // Get parameters
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        String eventIdStr = request.getParameter("eventId"); // Optional, for edit operations
        
        // Validate required parameters
        if (startDateStr == null || startDateStr.trim().isEmpty() ||
            endDateStr == null || endDateStr.trim().isEmpty()) {
            sendJsonResponse(response, true, ""); // No error if dates are not provided yet
            return;
        }
        
        // Parse dates
        Timestamp startDate = null;
        Timestamp endDate = null;
        
        try {
            LocalDateTime startDateTime = LocalDateTime.parse(startDateStr);
            startDate = Timestamp.valueOf(startDateTime);
        } catch (DateTimeParseException e) {
            sendJsonResponse(response, true, ""); // Invalid format, let form validation handle it
            return;
        }
        
        try {
            LocalDateTime endDateTime = LocalDateTime.parse(endDateStr);
            endDate = Timestamp.valueOf(endDateTime);
        } catch (DateTimeParseException e) {
            sendJsonResponse(response, true, ""); // Invalid format, let form validation handle it
            return;
        }
        
        // Validate date logic
        if (startDate.after(endDate)) {
            sendJsonResponse(response, true, ""); // Invalid date range, let form validation handle it
            return;
        }
        
        // Get club IDs where user is a leader
        MemberDAO memberDAO = new MemberDAO();
        List<Integer> clubIds = memberDAO.getClubsWhereUserIsLeader(user.getUserId());
        
        if (clubIds.isEmpty()) {
            sendJsonResponse(response, true, ""); // No clubs, no overlap
            return;
        }
        
        // Determine exclude event ID
        int excludeEventId = -1;
        if (eventIdStr != null && !eventIdStr.trim().isEmpty()) {
            try {
                excludeEventId = Integer.parseInt(eventIdStr);
                // If eventId < 0, it's from CreateEventRequests table, so don't exclude
                if (excludeEventId < 0) {
                    excludeEventId = -1;
                }
            } catch (NumberFormatException e) {
                // Ignore, use -1
            }
        }
        
        // Check for overlap
        boolean hasOverlap = eventDAO.hasOverlappingEvents(clubIds, startDate, endDate, excludeEventId);
        
        if (hasOverlap) {
            sendJsonResponse(response, false, "Bạn đã có sự kiện khác diễn ra trong khoảng thời gian này. Một club leader không thể có 2 sự kiện diễn ra cùng lúc.");
        } else {
            sendJsonResponse(response, true, "");
        }
    }
    
    private void sendJsonResponse(HttpServletResponse response, boolean isValid, String message) 
            throws IOException {
        PrintWriter out = response.getWriter();
        out.print("{\"valid\":" + isValid + ",\"message\":\"" + escapeJson(message) + "\"}");
        out.flush();
    }
    
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}

