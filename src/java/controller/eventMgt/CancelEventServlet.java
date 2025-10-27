/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.eventMgt;

import dal.EventDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Event;

/**
 * Servlet for handling Cancel Event functionality
 * @author admin
 */
public class CancelEventServlet extends HttpServlet {

    private EventDAO eventDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        eventDAO = new EventDAO();
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
                request.getRequestDispatcher("/eventMgt/list-events.jsp").forward(request, response);
                return;
            }

            int eventId = Integer.parseInt(eventIdStr);
            
            // Get the event to cancel
            Event event = eventDAO.getEventById(eventId);
            if (event == null) {
                request.setAttribute("message", "Event not found");
                request.setAttribute("messageType", "danger");
                request.getRequestDispatcher("/eventMgt/list-events.jsp").forward(request, response);
                return;
            }

            // Check if event can be cancelled (only upcoming events can be cancelled)
            if (!"Upcoming".equals(event.getStatus()) && !"Published".equals(event.getStatus())) {
                request.setAttribute("message", "Only upcoming or published events can be cancelled");
                request.setAttribute("messageType", "warning");
                request.getRequestDispatcher("/eventMgt/list-events.jsp").forward(request, response);
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
            request.getRequestDispatcher("/eventMgt/list-events.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("message", "Invalid event ID format");
            request.setAttribute("messageType", "danger");
            reloadEventsData(request);
            request.getRequestDispatcher("/eventMgt/list-events.jsp").forward(request, response);
        } catch (Exception e) {
            // Handle unexpected errors
            request.setAttribute("message", "An unexpected error occurred: " + e.getMessage());
            request.setAttribute("messageType", "danger");
            reloadEventsData(request);
            request.getRequestDispatcher("/eventMgt/list-events.jsp").forward(request, response);
            e.printStackTrace();
        }
    }

    /**
     * Reload events data for the list page
     */
    private void reloadEventsData(HttpServletRequest request) {
        try {
            // Get all events from the database
            List<Event> allEvents = eventDAO.getAllEvents();
            
            // Calculate statistics for all events
            int totalEvents = allEvents.size();
            int publishedEvents = 0;
            int pendingEvents = 0;
            int draftEvents = 0;
            int approvedEvents = 0;
            int rejectedEvents = 0;
            int cancelledEvents = 0;
            
            for (Event event : allEvents) {
                switch (event.getStatus()) {
                    case "Published":
                        publishedEvents++;
                        break;
                    case "Pending":
                        pendingEvents++;
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
                    case "Cancelled":
                        cancelledEvents++;
                        break;
                }
            }
            
            // Set attributes for the JSP
            request.setAttribute("events", allEvents);
            request.setAttribute("totalEvents", totalEvents);
            request.setAttribute("publishedEvents", publishedEvents);
            request.setAttribute("pendingEvents", pendingEvents);
            request.setAttribute("draftEvents", draftEvents);
            request.setAttribute("approvedEvents", approvedEvents);
            request.setAttribute("rejectedEvents", rejectedEvents);
            request.setAttribute("cancelledEvents", cancelledEvents);
            
        } catch (Exception e) {
            // If there's an error loading events, set empty list
            request.setAttribute("events", new ArrayList<Event>());
            request.setAttribute("totalEvents", 0);
            request.setAttribute("publishedEvents", 0);
            request.setAttribute("pendingEvents", 0);
            request.setAttribute("draftEvents", 0);
            request.setAttribute("approvedEvents", 0);
            request.setAttribute("rejectedEvents", 0);
            request.setAttribute("cancelledEvents", 0);
            e.printStackTrace();
        }
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
