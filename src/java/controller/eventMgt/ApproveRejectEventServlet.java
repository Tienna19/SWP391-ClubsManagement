/*
 * Servlet for handling Approve/Reject Event functionality for Admin
 * Admin can approve/reject events created by Club Leaders
 * When approved, event moves from CreateEventRequests to Events table with Published status
 */
package controller.eventMgt;

import dal.CreateEventRequestDAO;
import dal.EventDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CreateEventRequest;
import model.Event;
import model.User;

/**
 * Servlet for handling Approve/Reject Event functionality
 * @author admin
 */
public class ApproveRejectEventServlet extends HttpServlet {

    private CreateEventRequestDAO createEventRequestDAO;
    private EventDAO eventDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        createEventRequestDAO = new CreateEventRequestDAO();
        eventDAO = new EventDAO();
    }

    /**
     * Handles the HTTP <code>POST</code> method - approves or rejects an event request
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Get user from session
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("account") == null) {
                request.setAttribute("message", "You must be logged in to approve/reject events.");
                request.setAttribute("messageType", "danger");
                request.getRequestDispatcher("/view/eventMgt/list-events.jsp").forward(request, response);
                return;
            }
            
            User user = (User) session.getAttribute("account");
            int userRoleId = user.getRoleId();
            
            // Only Admin (role 4) can approve/reject events
            if (userRoleId != 4) {
                request.setAttribute("message", "Bạn không có quyền thực hiện hành động này.");
                request.setAttribute("messageType", "danger");
                request.getRequestDispatcher(determineEventListView(request)).forward(request, response);
                return;
            }
            
            // Get request ID and action
            String requestIdStr = request.getParameter("requestId");
            String action = request.getParameter("action"); // "approve" or "reject"
            
            if (requestIdStr == null || requestIdStr.trim().isEmpty() || action == null || action.trim().isEmpty()) {
                request.setAttribute("message", "Thiếu thông tin cần thiết để xử lý yêu cầu.");
                request.setAttribute("messageType", "danger");
                request.getRequestDispatcher(determineEventListView(request)).forward(request, response);
                return;
            }
            
            if (action == null || (!action.equals("approve") && !action.equals("reject"))) {
                request.setAttribute("message", "Invalid action. Must be 'approve' or 'reject'");
                request.setAttribute("messageType", "danger");
                request.getRequestDispatcher(determineEventListView(request)).forward(request, response);
                return;
            }
            
            int requestId = Integer.parseInt(requestIdStr);
            
            // Get the event request
            CreateEventRequest eventRequest = createEventRequestDAO.getRequestById(requestId);
            if (eventRequest == null) {
                request.setAttribute("message", "Không tìm thấy yêu cầu sự kiện");
                request.setAttribute("messageType", "danger");
                request.getRequestDispatcher(determineEventListView(request)).forward(request, response);
                return;
            }
            
            // Debug: Log all values from CreateEventRequest
            System.out.println("=== CreateEventRequest retrieved from database ===");
            System.out.println("RequestID: " + eventRequest.getRequestID());
            System.out.println("EventName: " + eventRequest.getEventName());
            System.out.println("RegistrationStart from DB: " + eventRequest.getRegistrationStart());
            System.out.println("RegistrationEnd from DB: " + eventRequest.getRegistrationEnd());
            System.out.println("StartDate: " + eventRequest.getStartDate());
            System.out.println("EndDate: " + eventRequest.getEndDate());
            System.out.println("==================================================");
            
            // Check if request is in Pending status
            if (!"Pending".equals(eventRequest.getStatus())) {
                request.setAttribute("message", "Only Pending event requests can be approved/rejected");
                request.setAttribute("messageType", "warning");
                request.getRequestDispatcher(determineEventListView(request)).forward(request, response);
                return;
            }
            
            if ("approve".equals(action)) {
                // APPROVE: Move event from CreateEventRequests to Events table with Published status
                handleApproval(eventRequest, user.getUserId());
                request.setAttribute("message", "Sự kiện đã được phê duyệt thành công.");
                request.setAttribute("messageType", "success");
            } else if ("reject".equals(action)) {
                // REJECT: Just update status in CreateEventRequests
                handleRejection(eventRequest, user.getUserId());
                request.setAttribute("message", "Yêu cầu sự kiện đã được cập nhật trạng thái thành công.");
                request.setAttribute("messageType", "success");
            }
            
            // Redirect back to list events
            response.sendRedirect(request.getContextPath() + "/listEvents");
            
        } catch (NumberFormatException e) {
            request.setAttribute("message", "Invalid event ID format.");
            request.setAttribute("messageType", "danger");
            request.getRequestDispatcher(determineEventListView(request)).forward(request, response);
        } catch (Exception e) {
            // Handle unexpected errors
            request.setAttribute("message", "Có lỗi xảy ra: " + e.getMessage());
            request.setAttribute("messageType", "danger");
            request.getRequestDispatcher(determineEventListView(request)).forward(request, response);
            e.printStackTrace();
        }
    }
    
    /**
     * Handle approval: Move event from CreateEventRequests to Events table with Published status
     */
    private void handleApproval(CreateEventRequest eventRequest, int adminId) throws Exception {
        System.out.println("=== Starting approval process for Request ID: " + eventRequest.getRequestID() + " ===");
        System.out.println("Event Name: " + eventRequest.getEventName());
        System.out.println("Club ID: " + eventRequest.getClubID());
        System.out.println("User ID (Creator): " + eventRequest.getUserID());
        
        // Handle null values for RegistrationStart and RegistrationEnd
        // Database requires NOT NULL, so set defaults if null
        java.sql.Timestamp registrationStart = eventRequest.getRegistrationStart();
        java.sql.Timestamp registrationEnd = eventRequest.getRegistrationEnd();
        
        System.out.println("Original RegistrationStart: " + registrationStart);
        System.out.println("Original RegistrationEnd: " + registrationEnd);
        
        // Only set defaults if values are actually null (not provided in the request)
        // If values exist in database, use them as-is
        if (registrationStart == null) {
            System.out.println("WARNING: RegistrationStart is null, setting default to current time");
            // Default to current time if not provided
            registrationStart = new java.sql.Timestamp(System.currentTimeMillis());
        }
        
        if (registrationEnd == null) {
            System.out.println("WARNING: RegistrationEnd is null, setting default to 7 days from now");
            // Default to 7 days from now if not provided
            long sevenDaysInMillis = 7L * 24 * 60 * 60 * 1000;
            registrationEnd = new java.sql.Timestamp(System.currentTimeMillis() + sevenDaysInMillis);
        }
        
        // Validate and adjust registration dates if needed
        // Ensure registration dates are before event start date
        if (registrationStart != null && eventRequest.getStartDate() != null && registrationStart.after(eventRequest.getStartDate())) {
            System.out.println("WARNING: RegistrationStart is after event StartDate, adjusting to 1 day before event start");
            // If registration start is after event start, set it to 1 day before event start
            long oneDayInMillis = 24L * 60 * 60 * 1000;
            registrationStart = new java.sql.Timestamp(eventRequest.getStartDate().getTime() - oneDayInMillis);
        }
        
        if (registrationEnd != null && eventRequest.getStartDate() != null && registrationEnd.after(eventRequest.getStartDate())) {
            System.out.println("WARNING: RegistrationEnd is after event StartDate, adjusting to 1 day before event start");
            // If registration end is after event start, set it to 1 day before event start
            long oneDayInMillis = 24L * 60 * 60 * 1000;
            registrationEnd = new java.sql.Timestamp(eventRequest.getStartDate().getTime() - oneDayInMillis);
        }
        
        // Ensure registration end is after registration start
        if (registrationStart != null && registrationEnd != null && 
            (registrationEnd.before(registrationStart) || registrationEnd.equals(registrationStart))) {
            System.out.println("WARNING: RegistrationEnd is before or equal to RegistrationStart, adjusting to 1 day after registration start");
            // Set registration end to 1 day after registration start
            long oneDayInMillis = 24L * 60 * 60 * 1000;
            registrationEnd = new java.sql.Timestamp(registrationStart.getTime() + oneDayInMillis);
        }
        
        // 1. Create Event in Events table with Published status
        Event event = new Event(
            eventRequest.getClubID(),
            eventRequest.getEventName(),
            eventRequest.getDescription(), // Can be null
            eventRequest.getLocation(), // Can be null
            eventRequest.getCapacity(),
            eventRequest.getStartDate(),
            eventRequest.getEndDate(),
            registrationStart, // Now guaranteed to be not null
            registrationEnd, // Now guaranteed to be not null
            eventRequest.getUserID(), // Keep original creator
            "Published", // Status is Published when approved
            eventRequest.getImage() // Can be null
        );
        
        System.out.println("Attempting to insert event into Events table...");
        System.out.println("Final RegistrationStart: " + registrationStart);
        System.out.println("Final RegistrationEnd: " + registrationEnd);
        
        int eventId = eventDAO.insertEvent(event);
        if (eventId <= 0) {
            System.err.println("ERROR: Failed to insert event. EventDAO.insertEvent() returned: " + eventId);
            throw new Exception("Failed to create event in Events table. Please check the server logs for details.");
        }
        
        System.out.println("✅ Event created successfully with ID: " + eventId);
        
        // 2. Update request status to Approved
        boolean updated = createEventRequestDAO.updateRequestStatus(
            eventRequest.getRequestID(),
            "Approved",
            adminId
        );
        
        if (!updated) {
            throw new Exception("Failed to update event request status");
        }
        
        System.out.println("✅ Event request " + eventRequest.getRequestID() + 
                          " approved. Event created with ID: " + eventId);
    }
    
    /**
     * Handle rejection: Just update status in CreateEventRequests
     */
    private void handleRejection(CreateEventRequest eventRequest, int adminId) throws Exception {
        boolean updated = createEventRequestDAO.updateRequestStatus(
            eventRequest.getRequestID(),
            "Rejected",
            adminId
        );
        
        if (!updated) {
            throw new Exception("Failed to update event request status");
        }
        
        System.out.println("❌ Event request " + eventRequest.getRequestID() + " rejected");
    }
    
    /**
     * Escape HTML characters to prevent XSS
     */
    private String escapeHtml(String input) {
        if (input == null) return "";
        return input.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#x27;");
    }

    /**
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet for approving/rejecting event requests in the club management system";
    }

    private String determineEventListView(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Object roleObj = session.getAttribute("roleId");
            if (roleObj instanceof Integer && ((Integer) roleObj) == 4) {
                return "/view/admin/admin-event-list.jsp";
            }
        }
        return "/view/eventMgt/list-events.jsp";
    }
}

