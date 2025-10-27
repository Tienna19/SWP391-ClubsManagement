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
import model.User;
import model.CreateEventRequest;

/**
 * Servlet for handling Add New Event functionality
 * @author admin
 */
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class AddNewEventServlet extends HttpServlet {

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
            // Get clubId parameter if provided
            String clubIdParam = request.getParameter("clubId");
            
            // Get all clubs for dropdown
            List<Club> clubs = clubDAO.getAllClubs();
            request.setAttribute("clubs", clubs);
            
            // Set selected club ID if provided
            if (clubIdParam != null && !clubIdParam.trim().isEmpty()) {
                request.setAttribute("selectedClubId", clubIdParam);
            }
            
            // Forward to the add event JSP form
            request.getRequestDispatcher("/view/eventMgt/add-event.jsp").forward(request, response);
        } catch (Exception e) {
            // Handle error
            request.setAttribute("error", "Error loading clubs: " + e.getMessage());
            request.getRequestDispatcher("/view/eventMgt/add-event.jsp").forward(request, response);
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
            // Get user from session
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("account") == null) {
                request.setAttribute("message", "You must be logged in to create events.");
                request.setAttribute("messageType", "danger");
                request.getRequestDispatcher("/view/eventMgt/add-event.jsp").forward(request, response);
                return;
            }
            
            User user = (User) session.getAttribute("account");
            int userRoleId = user.getRoleId();
            
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
            String imagePath = null;
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
                    request.getRequestDispatcher("/view/eventMgt/add-event.jsp").forward(request, response);
                    return;
                } catch (Exception e) {
                    request.setAttribute("message", "Lỗi khi tải ảnh lên: " + e.getMessage());
                    request.setAttribute("messageType", "danger");
                    request.getRequestDispatcher("/view/eventMgt/add-event.jsp").forward(request, response);
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
                request.getRequestDispatcher("/view/eventMgt/add-event.jsp").forward(request, response);
                return;
            }

            // Check user role and route accordingly
            // RoleID 4 = Admin, RoleID 3 = ClubLeader
            if (userRoleId == 4) {
                // Admin creates event directly in Events table
                // Admin can choose status: Draft or Published
                String eventStatus = (status != null && !status.trim().isEmpty()) ? status : "Published";
                Event event = new Event(clubId, eventName, description, location, capacity,
                                      startDate, endDate, registrationStart, registrationEnd, user.getUserId(), eventStatus, imagePath);

                int eventId = eventDAO.insertEvent(event);

                if (eventId > 0) {
                    String message;
                    if ("Draft".equals(eventStatus)) {
                        message = "Event '" + escapeHtml(eventName) + "' has been saved as draft successfully with ID: " + eventId;
                    } else {
                        message = "Event '" + escapeHtml(eventName) + "' has been published successfully with ID: " + eventId;
                    }
                    request.setAttribute("message", message);
                    request.setAttribute("messageType", "success");
                    request.setAttribute("eventId", eventId);
                    request.getRequestDispatcher("/view/eventMgt/add-event.jsp").forward(request, response);
                } else {
                    request.setAttribute("message", "Failed to create event. Please try again.");
                    request.setAttribute("messageType", "danger");
                    request.getRequestDispatcher("/view/eventMgt/add-event.jsp").forward(request, response);
                }
            } else if (userRoleId == 3) {
                // ClubLeader creates request in CreateEventRequests table
                // Determine final status:
                // - If user selects "Draft" → save as "Draft" (no admin approval needed)
                // - If user selects "Published" → save as "Pending" (needs admin approval)
                String finalStatus;
                if ("Draft".equals(status)) {
                    finalStatus = "Draft";
                } else if ("Published".equals(status)) {
                    finalStatus = "Pending";
                } else {
                    finalStatus = "Draft"; // Default to Draft
                }
                
                CreateEventRequest eventRequest = new CreateEventRequest(
                    clubId,
                    user.getUserId(),
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
                
                // Set the correct status
                eventRequest.setStatus(finalStatus);

                int requestId = createEventRequestDAO.insertEventRequest(eventRequest);

                if (requestId > 0) {
                    String message;
                    if ("Draft".equals(finalStatus)) {
                        message = "Event '" + escapeHtml(eventName) + "' has been saved as draft successfully.";
                    } else {
                        message = "Your event request '" + escapeHtml(eventName) + "' has been submitted successfully and is pending admin approval.";
                    }
                    request.setAttribute("message", message);
                    request.setAttribute("messageType", "success");
                    request.setAttribute("requestId", requestId);
                    request.getRequestDispatcher("/view/eventMgt/add-event.jsp").forward(request, response);
                } else {
                    request.setAttribute("message", "Failed to submit event request. Please try again.");
                    request.setAttribute("messageType", "danger");
                    request.getRequestDispatcher("/view/eventMgt/add-event.jsp").forward(request, response);
                }
            } else {
                // Unauthorized user
                request.setAttribute("message", "You do not have permission to create events.");
                request.setAttribute("messageType", "danger");
                request.getRequestDispatcher("/view/eventMgt/add-event.jsp").forward(request, response);
            }

        } catch (Exception e) {
            // Handle unexpected errors
            request.setAttribute("message", "An unexpected error occurred: " + e.getMessage());
            request.setAttribute("messageType", "danger");
            request.getRequestDispatcher("/view/eventMgt/add-event.jsp").forward(request, response);
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
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet for adding new events to the club management system";
    }
}

