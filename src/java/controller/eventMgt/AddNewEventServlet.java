/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.eventMgt;

import dal.EventDAO;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Event;

/**
 * Servlet for handling Add New Event functionality
 * @author admin
 */
public class AddNewEventServlet extends HttpServlet {

    private EventDAO eventDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        eventDAO = new EventDAO();
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
        // Forward to the add event JSP form
        request.getRequestDispatcher("/eventMgt/add-event.jsp").forward(request, response);
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
            String title = request.getParameter("title");
            String clubIdStr = request.getParameter("clubId");
            String status = request.getParameter("status");
            String description = request.getParameter("description");
            String location = request.getParameter("location");
            String startTimeStr = request.getParameter("startTime");
            String endTimeStr = request.getParameter("endTime");

            // Validate required fields
            StringBuilder errors = new StringBuilder();

            if (title == null || title.trim().isEmpty()) {
                errors.append("Event title is required.<br>");
            }

            if (clubIdStr == null || clubIdStr.trim().isEmpty()) {
                errors.append("Club selection is required.<br>");
            }

            if (startTimeStr == null || startTimeStr.trim().isEmpty()) {
                errors.append("Start time is required.<br>");
            }

            if (endTimeStr == null || endTimeStr.trim().isEmpty()) {
                errors.append("End time is required.<br>");
            }

            // Parse and validate data types
            int clubId = 1; // Default hardcoded club ID as requested
            Timestamp startTime = null;
            Timestamp endTime = null;

            try {
                if (clubIdStr != null && !clubIdStr.trim().isEmpty()) {
                    clubId = Integer.parseInt(clubIdStr);
                }
            } catch (NumberFormatException e) {
                errors.append("Invalid club ID format.<br>");
            }

            try {
                if (startTimeStr != null && !startTimeStr.trim().isEmpty()) {
                    LocalDateTime startDateTime = LocalDateTime.parse(startTimeStr);
                    startTime = Timestamp.valueOf(startDateTime);
                }
            } catch (DateTimeParseException e) {
                errors.append("Invalid start time format.<br>");
            }

            try {
                if (endTimeStr != null && !endTimeStr.trim().isEmpty()) {
                    LocalDateTime endDateTime = LocalDateTime.parse(endTimeStr);
                    endTime = Timestamp.valueOf(endDateTime);
                }
            } catch (DateTimeParseException e) {
                errors.append("Invalid end time format.<br>");
            }

            // Validate that end time is after start time
            if (startTime != null && endTime != null && !endTime.after(startTime)) {
                errors.append("End time must be after start time.<br>");
            }

            // Set default values for optional fields
            if (status == null || status.trim().isEmpty()) {
                status = "Draft";
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
            Event event = new Event(clubId, title, description, location, startTime, endTime, status);

            // Insert event into database
            int eventId = eventDAO.insertEvent(event);

            if (eventId > 0) {
                // Success - redirect to success page or show success message
                request.setAttribute("message", "Event '" + escapeHtml(title) + "' has been created successfully with ID: " + eventId);
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
