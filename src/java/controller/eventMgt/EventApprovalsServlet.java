/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package controller.eventMgt;

import dal.CreateEventRequestDAO;
import dal.ClubDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.CreateEventRequest;
import model.User;
import model.Club;

/**
 * Servlet for displaying event approval requests (Pending events from CreateEventRequests table)
 * Only accessible by Admin (roleId == 4)
 */
@WebServlet(name = "EventApprovalsServlet", urlPatterns = {"/eventApprovals"})
public class EventApprovalsServlet extends HttpServlet {

    private CreateEventRequestDAO createEventRequestDAO;
    private ClubDAO clubDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        createEventRequestDAO = new CreateEventRequestDAO();
        clubDAO = new ClubDAO();
        userDAO = new UserDAO();
    }

    /**
     * Handles the HTTP <code>GET</code> method - displays pending event requests
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Check if user is logged in
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("account") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            User user = (User) session.getAttribute("account");
            int userRoleId = user.getRoleId();
            
            // Only Admin (role 4) can access this page
            if (userRoleId != 4) {
                request.setAttribute("message", "Bạn không có quyền truy cập trang này.");
                request.setAttribute("messageType", "danger");
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
                return;
            }
            
            // Get all pending event requests
            List<CreateEventRequest> pendingRequests = createEventRequestDAO.getAllPendingRequests();
            
            // Get club information for each request
            Map<Integer, Club> clubsMap = new HashMap<>();
            // Map to store eventId for each requestID (for viewEvent link)
            Map<Integer, Integer> eventIdMap = new HashMap<>();
            for (CreateEventRequest req : pendingRequests) {
                if (!clubsMap.containsKey(req.getClubID())) {
                    Club club = clubDAO.getClubById(req.getClubID());
                    if (club != null) {
                        clubsMap.put(req.getClubID(), club);
                    }
                }
                // Calculate eventId for viewEvent: eventId = -(requestID + 1000000)
                int eventId = -(req.getRequestID() + 1000000);
                eventIdMap.put(req.getRequestID(), eventId);
            }
            
            // Get flash messages from session
            Object flashMessage = session.getAttribute("flashMessage");
            Object flashType = session.getAttribute("flashType");
            if (flashMessage != null) {
                request.setAttribute("flashMessage", flashMessage);
                request.setAttribute("flashType", flashType);
                session.removeAttribute("flashMessage");
                session.removeAttribute("flashType");
            }
            
            // Set attributes for JSP
            request.setAttribute("pendingRequests", pendingRequests);
            request.setAttribute("clubsMap", clubsMap);
            request.setAttribute("eventIdMap", eventIdMap);
            request.setAttribute("activeMenu", "events");
            request.setAttribute("activeSubMenu", "events-requests");
            request.setAttribute("pageTitle", "Yêu cầu sự kiện");
            
            // Forward to JSP
            request.getRequestDispatcher("/view/eventMgt/event-approvals.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("message", "Có lỗi xảy ra khi tải danh sách yêu cầu sự kiện: " + e.getMessage());
            request.setAttribute("messageType", "danger");
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
            e.printStackTrace();
        }
    }
}

