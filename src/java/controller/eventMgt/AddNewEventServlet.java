/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.eventMgt;

import dal.EventDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
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
        // Forward to the add event HTML form
        request.getRequestDispatcher("/eventMgt/add-event.html").forward(request, response);
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
        response.setContentType("text/html;charset=UTF-8");

        try (PrintWriter out = response.getWriter()) {
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

            // If there are validation errors, display them
            if (errors.length() > 0) {
                displayErrorPage(out, "Validation Errors", errors.toString());
                return;
            }

            // Create Event object
            Event event = new Event(clubId, title, description, location, startTime, endTime, status);

            // Insert event into database
            int eventId = eventDAO.insertEvent(event);

            if (eventId > 0) {
                // Success - display success page
                displaySuccessPage(out, eventId, title);
            } else {
                // Database error
                displayErrorPage(out, "Database Error", "Failed to create event. Please try again.");
            }

        } catch (Exception e) {
            // Handle unexpected errors
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            try (PrintWriter out = response.getWriter()) {
                displayErrorPage(out, "System Error", "An unexpected error occurred: " + e.getMessage());
            }
            e.printStackTrace();
        }
    }

    /**
     * Display success page after event creation
     */
    private void displaySuccessPage(PrintWriter out, int eventId, String title) {
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Event Created Successfully</title>");
        out.println("<meta charset='UTF-8'>");
        out.println("<meta name='viewport' content='width=device-width, initial-scale=1'>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; margin: 40px; background-color: #f8f9fa; }");
        out.println(".container { max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }");
        out.println(".success { color: #28a745; text-align: center; }");
        out.println(".btn { display: inline-block; padding: 10px 20px; margin: 10px 5px; text-decoration: none; border-radius: 5px; }");
        out.println(".btn-primary { background-color: #007bff; color: white; }");
        out.println(".btn-secondary { background-color: #6c757d; color: white; }");
        out.println(".btn:hover { opacity: 0.8; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<div class='container'>");
        out.println("<div class='success'>");
        out.println("<h1>✅ Event Created Successfully!</h1>");
        out.println("<p><strong>Event ID:</strong> " + eventId + "</p>");
        out.println("<p><strong>Title:</strong> " + escapeHtml(title) + "</p>");
        out.println("<p>Your event has been created and saved to the database.</p>");
        out.println("</div>");
        out.println("<div style='text-align: center; margin-top: 30px;'>");
        out.println("<a href='addNewEvent' class='btn btn-primary'>Add Another Event</a>");
        out.println("<a href='../index.html' class='btn btn-secondary'>Back to Dashboard</a>");
        out.println("</div>");
        out.println("</div>");
        out.println("</body>");
        out.println("</html>");
    }

    /**
     * Display error page with error details
     */
    private void displayErrorPage(PrintWriter out, String errorTitle, String errorMessage) {
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Error - " + escapeHtml(errorTitle) + "</title>");
        out.println("<meta charset='UTF-8'>");
        out.println("<meta name='viewport' content='width=device-width, initial-scale=1'>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; margin: 40px; background-color: #f8f9fa; }");
        out.println(".container { max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }");
        out.println(".error { color: #dc3545; }");
        out.println(".btn { display: inline-block; padding: 10px 20px; margin: 10px 5px; text-decoration: none; border-radius: 5px; }");
        out.println(".btn-primary { background-color: #007bff; color: white; }");
        out.println(".btn-secondary { background-color: #6c757d; color: white; }");
        out.println(".btn:hover { opacity: 0.8; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<div class='container'>");
        out.println("<div class='error'>");
        out.println("<h1>❌ " + escapeHtml(errorTitle) + "</h1>");
        out.println("<div>" + errorMessage + "</div>");
        out.println("</div>");
        out.println("<div style='text-align: center; margin-top: 30px;'>");
        out.println("<a href='javascript:history.back()' class='btn btn-primary'>Go Back</a>");
        out.println("<a href='addNewEvent' class='btn btn-secondary'>Try Again</a>");
        out.println("</div>");
        out.println("</div>");
        out.println("</body>");
        out.println("</html>");
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
