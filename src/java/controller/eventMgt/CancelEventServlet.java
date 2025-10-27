/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.eventMgt;

import dal.EventDAO;
import dal.CreateEventRequestDAO;
import dal.ClubDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Event;
import model.User;
import model.CreateEventRequest;

/**
 * Servlet for handling Cancel Event functionality
 * @author admin
 */
public class CancelEventServlet extends HttpServlet {

    private EventDAO eventDAO;
    private CreateEventRequestDAO createEventRequestDAO;
    private ClubDAO clubDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        eventDAO = new EventDAO();
        createEventRequestDAO = new CreateEventRequestDAO();
        clubDAO = new ClubDAO();
    }

    /**
     * Handles the HTTP <code>POST</code> method - cancels an event
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Get event ID from request
            String eventIdStr = request.getParameter("eventId");
            if (eventIdStr == null || eventIdStr.trim().isEmpty()) {
                request.setAttribute("message", "Event ID is required");
                request.setAttribute("messageType", "danger");
                request.getRequestDispatcher("/view/eventMgt/list-events.jsp").forward(request, response);
                return;
            }

            int eventId = Integer.parseInt(eventIdStr);
            
            // Get the event to cancel
            Event event = eventDAO.getEventById(eventId);
            if (event == null) {
                request.setAttribute("message", "Event not found");
                request.setAttribute("messageType", "danger");
                request.getRequestDispatcher("/view/eventMgt/list-events.jsp").forward(request, response);
                return;
            }

            // Check if event can be cancelled (only upcoming events can be cancelled)
            if (!"Upcoming".equals(event.getStatus()) && !"Published".equals(event.getStatus())) {
                request.setAttribute("message", "Only upcoming or published events can be cancelled");
                request.setAttribute("messageType", "warning");
                request.getRequestDispatcher("/view/eventMgt/list-events.jsp").forward(request, response);
                return;
            }

            // Update event status to Cancelled
            boolean success = eventDAO.updateEventStatus(eventId, "Cancelled");

            if (success) {
                // Success - redirect to list events with success message
                request.setAttribute("message", "Event '" + escapeHtml(event.getEventName()) + "' has been cancelled successfully");
                request.setAttribute("messageType", "success");
            } else {
                // Database error
                request.setAttribute("message", "Failed to cancel event. Please try again.");
                request.setAttribute("messageType", "danger");
            }

            // Reload events data and forward back to list events
            reloadEventsData(request);
            request.getRequestDispatcher("/view/eventMgt/list-events.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("message", "Invalid event ID format");
            request.setAttribute("messageType", "danger");
            reloadEventsData(request);
            request.getRequestDispatcher("/view/eventMgt/list-events.jsp").forward(request, response);
        } catch (Exception e) {
            // Handle unexpected errors
            request.setAttribute("message", "An unexpected error occurred: " + e.getMessage());
            request.setAttribute("messageType", "danger");
            reloadEventsData(request);
            request.getRequestDispatcher("/view/eventMgt/list-events.jsp").forward(request, response);
            e.printStackTrace();
        }
    }

    /**
     * Reload events data for the list page
     */
    private void reloadEventsData(HttpServletRequest request) {
        try {
            // Get current user from session
            HttpSession session = request.getSession(false);
            User currentUser = null;
            if (session != null) {
                currentUser = (User) session.getAttribute("account");
            }
            
            // Get filtered events from the database
            List<Event> allEvents = eventDAO.getAllEvents();
            
            // Also get event requests from CreateEventRequests table and convert to Event format
            List<CreateEventRequest> eventRequests = createEventRequestDAO.getAllEventRequests();
            
            // Separate Pending events first - they will be displayed in separate section
            List<Event> pendingEventsList = new ArrayList<>();
            List<Event> otherEvents = new ArrayList<>();
            
            // Process event requests and separate Pending from others
            for (CreateEventRequest eventRequest : eventRequests) {
                String status = eventRequest.getStatus();
                if (status == null || status.trim().isEmpty()) {
                    status = "Pending";
                }
                
                Event event = convertRequestToEvent(eventRequest);
                
                // Separate Pending events
                if ("Pending".equals(status)) {
                    // Apply creator filter for Pending events
                    if (currentUser != null && currentUser.getUserId() == eventRequest.getUserID()) {
                        pendingEventsList.add(event);
                    }
                } else {
                    otherEvents.add(event);
                }
            }
            
            // Add non-Pending event requests to allEvents
            for (Event evt : otherEvents) {
                allEvents.add(evt);
            }
            
            // Filter events based on status and user role (simplified for cancel)
            // Just pass all events to the view
            
            // Set attributes for the JSP
            request.setAttribute("events", allEvents);
            request.setAttribute("pendingEvents", pendingEventsList); // List for iteration
            request.setAttribute("totalEvents", allEvents.size());
            request.setAttribute("publishedEvents", 0); // Simplified stats
            request.setAttribute("pendingEventsCount", pendingEventsList.size());
            request.setAttribute("draftEvents", 0);
            request.setAttribute("approvedEvents", 0);
            request.setAttribute("rejectedEvents", 0);
            
            // Pagination defaults
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 1);
            request.setAttribute("totalRecords", allEvents.size());
            request.setAttribute("recordsPerPage", 10);
            
        } catch (Exception e) {
            // If there's an error loading events, set empty list
            request.setAttribute("events", new ArrayList<Event>());
            request.setAttribute("pendingEvents", new ArrayList<Event>());
            request.setAttribute("totalEvents", 0);
            request.setAttribute("publishedEvents", 0);
            request.setAttribute("pendingEventsCount", 0);
            request.setAttribute("draftEvents", 0);
            request.setAttribute("approvedEvents", 0);
            request.setAttribute("rejectedEvents", 0);
            e.printStackTrace();
        }
    }
    
    /**
     * Convert CreateEventRequest to Event object
     */
    private Event convertRequestToEvent(CreateEventRequest request) {
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
            request.getUserID(),
            status,
            request.getImage()
        );
        // Set a special eventID to identify it as a request
        event.setEventID(-request.getRequestID() - 1000000);
        return event;
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
        return "Servlet for cancelling events in the club management system";
    }
}
