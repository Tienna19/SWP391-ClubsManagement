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
 * Servlet for handling Events List functionality
 * @author admin
 */
public class ViewListEventsServlet extends HttpServlet {

    private EventDAO eventDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        eventDAO = new EventDAO();
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
            
            // Calculate statistics for all events (not just filtered)
            int totalEvents = allEvents.size();
            int publishedEvents = 0;
            int pendingEvents = 0;
            int draftEvents = 0;
            int approvedEvents = 0;
            int rejectedEvents = 0;
            
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
                }
            }
            
            // Set attributes for the JSP
            request.setAttribute("events", eventsForPage);
            request.setAttribute("totalEvents", totalEvents);
            request.setAttribute("publishedEvents", publishedEvents);
            request.setAttribute("pendingEvents", pendingEvents);
            request.setAttribute("draftEvents", draftEvents);
            request.setAttribute("approvedEvents", approvedEvents);
            request.setAttribute("rejectedEvents", rejectedEvents);
            
            // Pagination attributes
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalRecords", totalRecords);
            request.setAttribute("recordsPerPage", recordsPerPage);
            
            // Search and filter attributes (to maintain state)
            request.setAttribute("searchTerm", searchTerm);
            request.setAttribute("statusFilter", statusFilter);
            
            // Forward to the events list JSP
            request.getRequestDispatcher("/eventMgt/list-events.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Handle unexpected errors
            request.setAttribute("error", "An error occurred while loading events: " + e.getMessage());
            request.getRequestDispatcher("/eventMgt/list-events.jsp").forward(request, response);
            e.printStackTrace();
        }
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
