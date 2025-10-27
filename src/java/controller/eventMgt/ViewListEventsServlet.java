/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.eventMgt;

import dal.CreateEventRequestDAO;
import dal.EventDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CreateEventRequest;
import model.Event;
import model.User;

/**
 * Servlet for handling Events List functionality
 * 
 * EVENT VISIBILITY RULES:
 * =======================
 * 
 * PRIVATE STATUSES (Filter by Creator):
 * - Draft:    Only visible to creator (Club Leader or Admin)
 * - Pending:  Only visible to creator (waiting for admin approval)
 * - Rejected: Only visible to creator (was rejected by admin)
 * 
 * PUBLIC STATUSES (Visible to Everyone):
 * - Published: Visible to all users
 * - Approved:  Visible to all users
 * - Completed: Visible to all users
 * - Cancelled: Visible to all users
 * 
 * IMPLEMENTATION:
 * For Club Leaders (role 3) and Admins (role 4):
 * - They can see all PUBLIC events created by anyone
 * - They can only see their own PRIVATE events (Draft, Pending, Rejected)
 * 
 * @author admin
 */
public class ViewListEventsServlet extends HttpServlet {

    private EventDAO eventDAO;
    private CreateEventRequestDAO createEventRequestDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        eventDAO = new EventDAO();
        createEventRequestDAO = new CreateEventRequestDAO();
    }

    /**
     * Handles the HTTP <code>GET</code> method - displays the events list
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Get current user from session
            HttpSession session = request.getSession(false);
            User currentUser = null;
            if (session != null) {
                currentUser = (User) session.getAttribute("account");  // Use "account" not "user"
            }
            
            // Get search and filter parameters
            String searchTerm = request.getParameter("search");
            String statusFilter = request.getParameter("status");
            String pageParam = request.getParameter("page");
            
            // Set default values
            if (searchTerm == null) searchTerm = "";
            if (statusFilter == null) statusFilter = "";
            
            // Pagination parameters
            int currentPage = 1;
            int recordsPerPage = 5; // Number of events per page
            
            try {
                if (pageParam != null && !pageParam.isEmpty()) {
                    currentPage = Integer.parseInt(pageParam);
                }
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
            
            // Get filtered events from the database
            List<Event> allEvents = eventDAO.getAllEvents();
            
            // Also get event requests from CreateEventRequests table and convert to Event format
            List<CreateEventRequest> eventRequests = createEventRequestDAO.getAllEventRequests();
            System.out.println("Total event requests found: " + eventRequests.size());
            
            // Separate Pending events first - they will be displayed in separate section
            List<Event> pendingEventsList = new ArrayList<>();
            List<Event> otherEvents = new ArrayList<>();
            
            // Process event requests and separate Pending from others
            for (CreateEventRequest eventRequest : eventRequests) {
                String status = eventRequest.getStatus();
                if (status == null || status.trim().isEmpty()) {
                    status = "Pending";
                }
                
                System.out.println("=================================================================");
                System.out.println("Processing Event Request:");
                System.out.println("  Status: " + status);
                System.out.println("  EventName: " + eventRequest.getEventName());
                System.out.println("  RequestID: " + eventRequest.getRequestID());
                System.out.println("  UserID: " + eventRequest.getUserID());
                System.out.println("  Current User: " + (currentUser != null ? currentUser.getUserId() + " (Role: " + currentUser.getRoleId() + ")" : "null"));
                System.out.println("  Match? " + (currentUser != null && currentUser.getUserId() == eventRequest.getUserID()));
                
                Event event = convertRequestToEvent(eventRequest);
                
                // Separate Pending events
                if ("Pending".equals(status)) {
                    // Apply creator filter for Pending events
                    if (currentUser != null && currentUser.getUserId() == eventRequest.getUserID()) {
                        pendingEventsList.add(event);
                        System.out.println("  >>> ✓ ADDED to pendingEventsList <<<");
                    } else {
                        System.out.println("  >>> ✗ SKIPPED (not creator or no user session) <<<");
                    }
                } else {
                    otherEvents.add(event);
                    System.out.println("  >>> Added to otherEvents (Status: " + status + ") <<<");
                }
                System.out.println("=================================================================");
            }
            
            // Add non-Pending event requests to allEvents
            for (Event evt : otherEvents) {
                allEvents.add(evt);
            }
            
            System.out.println("");
            System.out.println("========== SUMMARY ==========");
            System.out.println("Total events after adding non-Pending requests: " + allEvents.size());
            System.out.println("Pending events separated: " + pendingEventsList.size());
            System.out.println("Current user: " + (currentUser != null ? currentUser.getUserId() + " (Role: " + currentUser.getRoleId() + ")" : "null"));
            
            // Print all pending events
            System.out.println("List of Pending Events in pendingEventsList:");
            for (Event e : pendingEventsList) {
                System.out.println("  - EventID: " + e.getEventID() + ", Name: " + e.getEventName() + ", CreatedBy: " + e.getCreatedBy());
            }
            System.out.println("=============================");
            System.out.println("");
            
            // Filter events based on status and user role
            // Private statuses: Draft, Pending, Rejected - only visible to creator
            // Public statuses: Published, Approved, Completed, Cancelled - visible to everyone
            // NOTE: Pending events are displayed separately in "Sự kiện đang chờ phê duyệt" section
            if (currentUser != null && (currentUser.getRoleId() == 3 || currentUser.getRoleId() == 4)) {
                List<Event> filteredEventsList = new ArrayList<>();
                for (Event event : allEvents) {
                    String status = event.getStatus();
                    // Handle null or empty status
                    if (status == null || status.trim().isEmpty()) {
                        status = "Draft"; // Default status
                    }
                    
                    // Private statuses - only show if created by current user
                    if ("Draft".equals(status) || "Pending".equals(status) || "Rejected".equals(status)) {
                        System.out.println("Private event - Status: " + status + ", CreatedBy: " + event.getCreatedBy() + ", CurrentUser: " + currentUser.getUserId());
                        if (event.getCreatedBy() == currentUser.getUserId()) {
                            // NOTE: Events table no longer has 'Pending' status
                            // 'Pending' events only exist in CreateEventRequests table
                            // Events table has: Draft, Published, Completed, Cancelled
                            if ("Pending".equals(status) && event.getEventID() > 0) {
                                // This should not happen anymore, but keeping for backward compatibility
                                pendingEventsList.add(event);
                                System.out.println("Added Pending event from Events table: " + event.getEventName());
                            } else if (!"Pending".equals(status)) {
                                // Other private statuses (Draft, Rejected) - add to filtered list
                                filteredEventsList.add(event);
                                System.out.println("Added private event: " + event.getEventName() + " (Status: " + status + ")");
                            } else {
                                System.out.println("Skipped Pending event (already in pending section): " + event.getEventName());
                            }
                        }
                    } else {
                        // Public statuses - show to everyone
                        filteredEventsList.add(event);
                        System.out.println("Added public event: " + event.getEventName() + " (Status: " + status + ")");
                    }
                }
                allEvents = filteredEventsList;
                System.out.println("Total events after filtering (excluding Pending): " + allEvents.size());
                System.out.println("Total Pending events (including from Events): " + pendingEventsList.size());
            }
            
            // Apply search filter
            List<Event> filteredEvents = new ArrayList<>();
            for (Event event : allEvents) {
                boolean matchesSearch = true;
                boolean matchesStatus = true;
                
                // Search filter
                if (!searchTerm.isEmpty()) {
                    String searchLower = searchTerm.toLowerCase();
                    matchesSearch = (event.getEventName().toLowerCase().contains(searchLower) ||
                                   (event.getDescription() != null && event.getDescription().toLowerCase().contains(searchLower)));
                }
                
                // Status filter
                if (!statusFilter.isEmpty()) {
                    matchesStatus = event.getStatus().equals(statusFilter);
                }
                
                if (matchesSearch && matchesStatus) {
                    filteredEvents.add(event);
                }
            }
            
            System.out.println("Events after search filter: " + filteredEvents.size() + " (searchTerm: '" + searchTerm + "', statusFilter: '" + statusFilter + "')");
            
            // Calculate pagination
            int totalRecords = filteredEvents.size();
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
            
            // Ensure current page is within valid range
            if (currentPage > totalPages && totalPages > 0) {
                currentPage = totalPages;
            }
            if (currentPage < 1) {
                currentPage = 1;
            }
            
            // Get events for current page
            int startIndex = (currentPage - 1) * recordsPerPage;
            int endIndex = Math.min(startIndex + recordsPerPage, totalRecords);
            
            List<Event> eventsForPage = new ArrayList<>();
            if (startIndex < totalRecords) {
                eventsForPage = filteredEvents.subList(startIndex, endIndex);
            }
            
            System.out.println("Events for current page: " + eventsForPage.size() + " (page " + currentPage + " of " + totalPages + ")");
            
            // Calculate statistics for all events (not just filtered, excluding Pending which are shown separately)
            int totalEvents = allEvents.size();
            int publishedEvents = 0;
            int draftEvents = 0;
            int approvedEvents = 0;
            int rejectedEvents = 0;
            
            // Note: pendingEventsList was already populated above from event requests
            int pendingEvents = pendingEventsList.size();
            
            // Calculate statistics from allEvents (excluding Pending)
            for (Event event : allEvents) {
                switch (event.getStatus()) {
                    case "Published":
                        publishedEvents++;
                        break;
                    case "Draft":
                        draftEvents++;
                        break;
                    case "Approved":
                        approvedEvents++;
                        break;
                    case "Rejected":
                        rejectedEvents++;
                        break;
                }
            }
            
            // Set attributes for the JSP
            System.out.println("");
            System.out.println("========== SETTING ATTRIBUTES ==========");
            System.out.println("Setting 'events' (main list): " + eventsForPage.size() + " events");
            System.out.println("Setting 'pendingEvents' (pending list): " + pendingEventsList.size() + " events");
            request.setAttribute("events", eventsForPage);
            request.setAttribute("pendingEvents", pendingEventsList); // List of pending events
            request.setAttribute("totalEvents", totalEvents);
            request.setAttribute("publishedEvents", publishedEvents);
            request.setAttribute("pendingEventsCount", pendingEvents); // Count only
            request.setAttribute("draftEvents", draftEvents);
            request.setAttribute("approvedEvents", approvedEvents);
            request.setAttribute("rejectedEvents", rejectedEvents);
            System.out.println("==========================================");
            System.out.println("");
            
            // Pagination attributes
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalRecords", totalRecords);
            request.setAttribute("recordsPerPage", recordsPerPage);
            
            // Search and filter attributes (to maintain state)
            request.setAttribute("searchTerm", searchTerm);
            request.setAttribute("statusFilter", statusFilter);
            
            // Forward to the events list JSP
            request.getRequestDispatcher("/view/eventMgt/list-events.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Handle unexpected errors
            request.setAttribute("error", "An error occurred while loading events: " + e.getMessage());
            request.getRequestDispatcher("/view/eventMgt/list-events.jsp").forward(request, response);
            e.printStackTrace();
        }
    }

    /**
     * Convert CreateEventRequest to Event object for unified display
     * @param request CreateEventRequest object
     * @return Event object with data from request
     */
    private Event convertRequestToEvent(CreateEventRequest request) {
        // Use negative ID to distinguish from actual Events (could also use different prefix)
        // This helps identify that this came from CreateEventRequests table
        
        // Handle null or empty status - default to 'Pending'
        String status = request.getStatus();
        if (status == null || status.trim().isEmpty()) {
            status = "Pending";
        }
        
        Event event = new Event(
            request.getClubID(),
            request.getEventName(),
            request.getDescription(),
            request.getLocation(),
            request.getCapacity(),
            request.getStartDate(),
            request.getEndDate(),
            request.getRegistrationStart(),
            request.getRegistrationEnd(),
            request.getUserID(), // createdBy
            status,
            request.getImage()
        );
        // Set a special eventID to identify it as a request
        // Using negative to avoid conflicts with real Events
        event.setEventID(-request.getRequestID() - 1000000);
        return event;
    }
    
    /**
     * Handles the HTTP <code>POST</code> method - handles search and filter requests
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // For now, just redirect to GET method
        // In the future, this could handle AJAX search/filter requests
        doGet(request, response);
    }

    /**
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet for displaying and managing events list in the club management system";
    }
}
