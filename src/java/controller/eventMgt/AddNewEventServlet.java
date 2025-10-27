/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.eventMgt;

import dal.EventDAO;
import dal.ClubDAO;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Event;
import model.Club;

/**
 * Servlet for handling Add New Event functionality
 * @author admin
 */
public class AddNewEventServlet extends HttpServlet {

    private EventDAO eventDAO;
    private ClubDAO clubDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        eventDAO = new EventDAO();
        clubDAO = new ClubDAO();
    }

    /**
     * Handles the HTTP <code>GET</code> method - forwards to the add event form
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Get all clubs for dropdown
            List<Club> clubs = clubDAO.getAllClubs();
            request.setAttribute("clubs", clubs);
            
            // Forward to the add event JSP form
            request.getRequestDispatcher("/eventMgt/add-event.jsp").forward(request, response);
        } catch (Exception e) {
            // Handle error
            request.setAttribute("error", "Error loading clubs: " + e.getMessage());
            request.getRequestDispatcher("/eventMgt/add-event.jsp").forward(request, response);
            e.printStackTrace();
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method - processes form submission
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Get form parameters
            String eventName = request.getParameter("eventName");
            String clubIdStr = request.getParameter("clubId");
            String status = request.getParameter("status");
            String description = request.getParameter("description");
            String location = request.getParameter("location");
            String capacityStr = request.getParameter("capacity");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            String registrationStartStr = request.getParameter("registrationStart");
            String registrationEndStr = request.getParameter("registrationEnd");

            // Validate required fields
            StringBuilder errors = new StringBuilder();

            if (eventName == null || eventName.trim().isEmpty()) {
                errors.append("Event title is required.<br>");
            }

            if (clubIdStr == null || clubIdStr.trim().isEmpty()) {
                errors.append("Club selection is required.<br>");
            }

            if (location == null || location.trim().isEmpty()) {
                errors.append("Location is required.<br>");
            }

            if (capacityStr == null || capacityStr.trim().isEmpty()) {
                errors.append("Capacity is required.<br>");
            }

            if (startDateStr == null || startDateStr.trim().isEmpty()) {
                errors.append("Start date is required.<br>");
            }

            if (endDateStr == null || endDateStr.trim().isEmpty()) {
                errors.append("End date is required.<br>");
            }


            // Parse and validate data types
            int clubId = 1; // Default hardcoded club ID as requested
            int capacity = 0;
            Timestamp startDate = null;
            Timestamp endDate = null;
            Timestamp registrationStart = null;
            Timestamp registrationEnd = null;

            try {
                if (clubIdStr != null && !clubIdStr.trim().isEmpty()) {
                    clubId = Integer.parseInt(clubIdStr);
                }
            } catch (NumberFormatException e) {
                errors.append("Invalid club ID format.<br>");
            }

            try {
                if (capacityStr != null && !capacityStr.trim().isEmpty()) {
                    capacity = Integer.parseInt(capacityStr);
                    if (capacity <= 0) {
                        errors.append("Capacity must be greater than 0.<br>");
                    }
                }
            } catch (NumberFormatException e) {
                errors.append("Invalid capacity format.<br>");
            }

            try {
                if (startDateStr != null && !startDateStr.trim().isEmpty()) {
                    LocalDateTime startDateTime = LocalDateTime.parse(startDateStr);
                    startDate = Timestamp.valueOf(startDateTime);
                }
            } catch (DateTimeParseException e) {
                errors.append("Invalid start date format.<br>");
            }

            try {
                if (endDateStr != null && !endDateStr.trim().isEmpty()) {
                    LocalDateTime endDateTime = LocalDateTime.parse(endDateStr);
                    endDate = Timestamp.valueOf(endDateTime);
                }
            } catch (DateTimeParseException e) {
                errors.append("Invalid end date format.<br>");
            }

            try {
                if (registrationStartStr != null && !registrationStartStr.trim().isEmpty()) {
                    LocalDateTime regStartDateTime = LocalDateTime.parse(registrationStartStr);
                    registrationStart = Timestamp.valueOf(regStartDateTime);
                } else {
                    // Default to current time if not provided
                    registrationStart = Timestamp.valueOf(LocalDateTime.now());
                }
            } catch (DateTimeParseException e) {
                errors.append("Invalid registration start date format.<br>");
            }

            try {
                if (registrationEndStr != null && !registrationEndStr.trim().isEmpty()) {
                    LocalDateTime regEndDateTime = LocalDateTime.parse(registrationEndStr);
                    registrationEnd = Timestamp.valueOf(regEndDateTime);
                } else {
                    // Default to 7 days from now if not provided
                    registrationEnd = Timestamp.valueOf(LocalDateTime.now().plusDays(7));
                }
            } catch (DateTimeParseException e) {
                errors.append("Invalid registration end date format.<br>");
            }

            // Validate date logic
            if (startDate != null && endDate != null && startDate.after(endDate)) {
                errors.append("Start date must be before end date.<br>");
            }

            if (registrationStart != null && registrationEnd != null && registrationStart.after(registrationEnd)) {
                errors.append("Registration start date must be before registration end date.<br>");
            }


            // Set default values for optional fields
            if (status == null || status.trim().isEmpty()) {
                status = "Upcoming"; // Use database default status
            }

            if (description == null) {
                description = "";
            }

            if (location == null) {
                location = "";
            }

            // If there are validation errors, forward back to JSP with error message
            if (errors.length() > 0) {
                request.setAttribute("message", errors.toString());
                request.setAttribute("messageType", "danger");
                request.getRequestDispatcher("/eventMgt/add-event.jsp").forward(request, response);
                return;
            }

            // Create Event object
            Event event = new Event(clubId, eventName, description, location, capacity, 
                                  startDate, endDate, registrationStart, registrationEnd, 1, status);

            // Insert event into database
            int eventId = eventDAO.insertEvent(event);

            if (eventId > 0) {
                // Success - redirect to success page or show success message
                request.setAttribute("message", "Event '" + escapeHtml(eventName) + "' has been created successfully with ID: " + eventId);
                request.setAttribute("messageType", "success");
                request.setAttribute("eventId", eventId);
                request.getRequestDispatcher("/eventMgt/add-event.jsp").forward(request, response);
            } else {
                // Database error
                request.setAttribute("message", "Failed to create event. Please try again.");
                request.setAttribute("messageType", "danger");
                request.getRequestDispatcher("/eventMgt/add-event.jsp").forward(request, response);
            }

        } catch (Exception e) {
            // Handle unexpected errors
            request.setAttribute("message", "An unexpected error occurred: " + e.getMessage());
            request.setAttribute("messageType", "danger");
            request.getRequestDispatcher("/eventMgt/add-event.jsp").forward(request, response);
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
        return "Servlet for adding new events to the club management system";
    }
}

