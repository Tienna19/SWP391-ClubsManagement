/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.eventMgt;

import dal.EventDAO;
import dal.ClubDAO;
import dal.CreateEventRequestDAO;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Event;
import model.Club;
import model.CreateEventRequest;
import model.User;

/**
 * Servlet for handling Edit Event functionality
 * @author admin
 */
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class EditEventServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads/events";
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    private static final String[] ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif"};

    private EventDAO eventDAO;
    private ClubDAO clubDAO;
    private CreateEventRequestDAO createEventRequestDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        eventDAO = new EventDAO();
        clubDAO = new ClubDAO();
        createEventRequestDAO = new CreateEventRequestDAO();
    }

    /**
     * Handles the HTTP <code>GET</code> method - shows the edit event form
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
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
            
            // Get the event to edit
            Event event = null;
            
            // Check if this is an event from CreateEventRequests table (eventID is negative)
            // CreateEventRequests table contains both Draft and Pending events
            // Events table only contains: Draft, Published, Completed, Cancelled (NO Pending)
            if (eventId < 0) {
                // Extract real request ID from negative eventID
                // Formula: eventID = -requestID - 1000000
                // So: requestID = -(eventID + 1000000)
                int requestId = -(eventId + 1000000);
                
                System.out.println("Editing event request with ID: " + requestId + " from CreateEventRequests table");
                CreateEventRequest eventRequest = createEventRequestDAO.getRequestById(requestId);
                if (eventRequest != null) {
                    System.out.println("Found event request - Status: " + eventRequest.getStatus());
                    // Convert CreateEventRequest to Event format
                    event = convertRequestToEvent(eventRequest);
                }
            } else {
                // This is an event from Events table (eventID is positive)
                System.out.println("Editing event with ID: " + eventId + " from Events table");
                event = eventDAO.getEventById(eventId);
            }
            
            if (event == null) {
                request.setAttribute("message", "Event not found");
                request.setAttribute("messageType", "danger");
                request.getRequestDispatcher("/view/eventMgt/list-events.jsp").forward(request, response);
                return;
            }

            // Get all clubs for dropdown
            List<Club> clubs = clubDAO.getAllClubs();
            
            // Set attributes for JSP
            request.setAttribute("event", event);
            request.setAttribute("clubs", clubs);
            
            // Forward to the edit event JSP form
            request.getRequestDispatcher("/view/eventMgt/edit-event.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("message", "Invalid event ID format");
            request.setAttribute("messageType", "danger");
            request.getRequestDispatcher("/view/eventMgt/list-events.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("message", "Error loading event: " + e.getMessage());
            request.setAttribute("messageType", "danger");
            request.getRequestDispatcher("/view/eventMgt/list-events.jsp").forward(request, response);
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
            // Get event ID from request
            String eventIdStr = request.getParameter("eventId");
            if (eventIdStr == null || eventIdStr.trim().isEmpty()) {
                request.setAttribute("message", "Event ID is required");
                request.setAttribute("messageType", "danger");
                request.getRequestDispatcher("/view/eventMgt/list-events.jsp").forward(request, response);
                return;
            }

            int eventId = Integer.parseInt(eventIdStr);

            // Get existing event/request to preserve image if not updated
            Event existingEvent = null;
            CreateEventRequest existingRequest = null;
            boolean isFromCreateEventRequests = false;
            
            if (eventId < 0) {
                // This is an event request from CreateEventRequests table
                int requestId = -(eventId + 1000000);
                existingRequest = createEventRequestDAO.getRequestById(requestId);
                if (existingRequest != null) {
                    existingEvent = convertRequestToEvent(existingRequest);
                    isFromCreateEventRequests = true;
                }
            } else {
                // This is an event from Events table
                existingEvent = eventDAO.getEventById(eventId);
            }
            
            if (existingEvent == null) {
                request.setAttribute("message", "Event not found");
                request.setAttribute("messageType", "danger");
                request.getRequestDispatcher("/view/eventMgt/list-events.jsp").forward(request, response);
                return;
            }

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

            // Handle image upload
            String imagePath = existingEvent.getImage(); // Preserve existing image by default
            Part filePart = request.getPart("eventImage");
            if (filePart != null && filePart.getSize() > 0) {
                try {
                    String fileName = getSubmittedFileName(filePart);

                    // Validate file extension
                    if (!isValidFileExtension(fileName)) {
                        throw new IllegalArgumentException("Chỉ chấp nhận file ảnh định dạng: JPG, JPEG, PNG, GIF");
                    }

                    // Validate file size
                    if (filePart.getSize() > MAX_FILE_SIZE) {
                        throw new IllegalArgumentException("Kích thước file không được vượt quá 5MB");
                    }

                    // Generate unique filename
                    String uniqueFileName = generateUniqueFileName(fileName);
                    String uploadPath = getServletContext().getRealPath("/" + UPLOAD_DIR);
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }

                    String filePath = uploadPath + File.separator + uniqueFileName;
                    try (InputStream input = filePart.getInputStream()) {
                        Files.copy(input, new File(filePath).toPath(), StandardCopyOption.REPLACE_EXISTING);
                    }

                    // Store relative path for database
                    imagePath = UPLOAD_DIR + "/" + uniqueFileName;

                } catch (IllegalArgumentException e) {
                    request.setAttribute("message", e.getMessage());
                    request.setAttribute("messageType", "danger");
                    request.setAttribute("event", existingEvent);
                    request.getRequestDispatcher("/view/eventMgt/edit-event.jsp").forward(request, response);
                    return;
                } catch (Exception e) {
                    request.setAttribute("message", "Lỗi khi tải ảnh lên: " + e.getMessage());
                    request.setAttribute("messageType", "danger");
                    request.setAttribute("event", existingEvent);
                    request.getRequestDispatcher("/view/eventMgt/edit-event.jsp").forward(request, response);
                    return;
                }
            }

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
                
                // Re-populate form data
                request.setAttribute("eventName", eventName);
                request.setAttribute("clubId", clubIdStr);
                request.setAttribute("status", status);
                request.setAttribute("description", description);
                request.setAttribute("location", location);
                request.setAttribute("capacity", capacityStr);
                request.setAttribute("startDate", startDateStr);
                request.setAttribute("endDate", endDateStr);
                request.setAttribute("registrationStart", registrationStartStr);
                request.setAttribute("registrationEnd", registrationEndStr);
                
                // Get clubs for dropdown
                List<Club> clubs = clubDAO.getAllClubs();
                request.setAttribute("clubs", clubs);
                
                request.getRequestDispatcher("/view/eventMgt/edit-event.jsp").forward(request, response);
                return;
            }

            // Update event/request in database
            boolean success = false;
            
            if (isFromCreateEventRequests) {
                // Update CreateEventRequest
                CreateEventRequest eventRequest = new CreateEventRequest(
                    clubId,
                    existingRequest.getUserID(),
                    eventName,
                    description,
                    location,
                    capacity,
                    startDate,
                    endDate,
                    registrationStart,
                    registrationEnd,
                    imagePath
                );
                eventRequest.setRequestID(existingRequest.getRequestID());
                eventRequest.setStatus(existingRequest.getStatus()); // Keep original status
                eventRequest.setCreatedAt(existingRequest.getCreatedAt());
                
                success = createEventRequestDAO.updateEventRequest(eventRequest);
            } else {
                // Update Event
                Event event = new Event(eventId, clubId, eventName, description, location, capacity,
                                      startDate, endDate, registrationStart, registrationEnd, existingEvent.getCreatedBy(), status, imagePath);
                success = eventDAO.updateEvent(event);
            }

            if (success) {
                // Success - redirect back to edit form with success message
                request.setAttribute("message", "Event '" + escapeHtml(eventName) + "' has been updated successfully");
                request.setAttribute("messageType", "success");
                
                // Re-load the updated event/request and clubs for the form
                Event updatedEvent = null;
                
                if (isFromCreateEventRequests) {
                    int requestId = -(eventId + 1000000);
                    CreateEventRequest updatedRequest = createEventRequestDAO.getRequestById(requestId);
                    if (updatedRequest != null) {
                        updatedEvent = convertRequestToEvent(updatedRequest);
                    }
                } else {
                    updatedEvent = eventDAO.getEventById(eventId);
                }
                
                List<Club> clubs = clubDAO.getAllClubs();
                request.setAttribute("event", updatedEvent);
                request.setAttribute("clubs", clubs);
                
                request.getRequestDispatcher("/view/eventMgt/edit-event.jsp").forward(request, response);
            } else {
                //.r
                request.setAttribute("message", "Failed to update event. Please try again.");
                request.setAttribute("messageType", "danger");
                
                // Re-populate form data
                request.setAttribute("eventName", eventName);
                request.setAttribute("clubId", clubIdStr);
                request.setAttribute("status", status);
                request.setAttribute("description", description);
                request.setAttribute("location", location);
                request.setAttribute("capacity", capacityStr);
                request.setAttribute("startDate", startDateStr);
                request.setAttribute("endDate", endDateStr);
                request.setAttribute("registrationStart", registrationStartStr);
                request.setAttribute("registrationEnd", registrationEndStr);
                
                // Get clubs for dropdown
                List<Club> clubs = clubDAO.getAllClubs();
                request.setAttribute("clubs", clubs);
                
                request.getRequestDispatcher("/view/eventMgt/edit-event.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("message", "Invalid event ID format");
            request.setAttribute("messageType", "danger");
            request.getRequestDispatcher("/view/eventMgt/list-events.jsp").forward(request, response);
        } catch (Exception e) {
            // Handle unexpected errors
            request.setAttribute("message", "An unexpected error occurred: " + e.getMessage());
            request.setAttribute("messageType", "danger");
            request.getRequestDispatcher("/view/eventMgt/list-events.jsp").forward(request, response);
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
     * Get submitted file name from Part
     */
    private String getSubmittedFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] tokens = contentDisposition.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }

    /**
     * Validate file extension
     */
    private boolean isValidFileExtension(String fileName) {
        if (fileName == null || fileName.isEmpty()) {
            return false;
        }
        String lowerCaseFileName = fileName.toLowerCase();
        for (String ext : ALLOWED_EXTENSIONS) {
            if (lowerCaseFileName.endsWith(ext)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Generate unique file name
     */
    private String generateUniqueFileName(String originalFileName) {
        String extension = "";
        int lastDotIndex = originalFileName.lastIndexOf(".");
        if (lastDotIndex > 0) {
            extension = originalFileName.substring(lastDotIndex);
        }
        return System.currentTimeMillis() + "_" + originalFileName.replaceAll("[^a-zA-Z0-9.]", "_");
    }

    /**
     * Convert CreateEventRequest to Event object
     * @param request CreateEventRequest object
     * @return Event object
     */
    private Event convertRequestToEvent(CreateEventRequest request) {
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
            request.getStatus(),
            request.getImage()
        );
        // Set a special eventID to identify it as a request
        event.setEventID(-request.getRequestID() - 1000000);
        return event;
    }

    /**
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet for editing events in the club management system";
    }
}
