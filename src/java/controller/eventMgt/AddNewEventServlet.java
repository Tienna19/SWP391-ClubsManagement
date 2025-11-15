/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.eventMgt;

import dal.EventDAO;
import dal.ClubDAO;
import dal.CreateEventRequestDAO;
import dal.MemberDAO;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
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
        request.setAttribute("activeMenu", "events");
        request.setAttribute("activeSubMenu", "events-create");
        try {
            // Get user from session
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("account") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            User user = (User) session.getAttribute("account");
            int userRoleId = user.getRoleId();
            
            // Get clubId parameter if provided
            String clubIdParam = request.getParameter("clubId");
            
            // Get clubs based on user role
            List<Club> clubs;
            if (userRoleId == 4) {
                // Admin: show all clubs
                clubs = clubDAO.getAllClubs();
            } else if (userRoleId == 3) {
                // Club Leader: show only clubs where user is leader
                MemberDAO memberDAO = new MemberDAO();
                List<Integer> clubIds = memberDAO.getClubsWhereUserIsLeader(user.getUserId());
                clubs = new ArrayList<>();
                for (Integer clubId : clubIds) {
                    Club club = clubDAO.getClubById(clubId);
                    if (club != null) {
                        clubs.add(club);
                    }
                }
            } else {
                // Other roles: no clubs
                clubs = new ArrayList<>();
            }
            
            request.setAttribute("clubs", clubs);
            
            // Set selected club ID if provided
            if (clubIdParam != null && !clubIdParam.trim().isEmpty()) {
                request.setAttribute("selectedClubId", Integer.parseInt(clubIdParam));
            }
            
            request.getRequestDispatcher(determineAddEventView(request)).forward(request, response);
        } catch (Exception e) {
            // Handle error
            request.setAttribute("error", "Lỗi khi tải danh sách CLB: " + e.getMessage());
            request.getRequestDispatcher(determineAddEventView(request)).forward(request, response);
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
        request.setAttribute("activeMenu", "events");
        request.setAttribute("activeSubMenu", "events-create");
        try {
            // Get user from session
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("account") == null) {
                request.setAttribute("message", "You must be logged in to create events.");
                request.setAttribute("messageType", "danger");
                request.getRequestDispatcher(determineAddEventView(request)).forward(request, response);
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
                    request.getRequestDispatcher(determineAddEventView(request)).forward(request, response);
                    return;
                } catch (Exception e) {
                    request.setAttribute("message", "Lỗi khi tải ảnh lên: " + e.getMessage());
                    request.setAttribute("messageType", "danger");
                    request.getRequestDispatcher(determineAddEventView(request)).forward(request, response);
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
                errors.append("Ngày kết thúc là bắt buộc.<br>");
            }

            if (registrationStartStr == null || registrationStartStr.trim().isEmpty()) {
                errors.append("Thời gian bắt đầu đăng ký là bắt buộc.<br>");
            }

            if (registrationEndStr == null || registrationEndStr.trim().isEmpty()) {
                errors.append("Thời gian kết thúc đăng ký là bắt buộc.<br>");
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
                    request.setAttribute("selectedClubId", clubId);
                    if (clubId <= 0) {
                        errors.append("Club ID must be greater than 0.<br>");
                    }
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
                }
            } catch (DateTimeParseException e) {
                errors.append("Định dạng thời gian bắt đầu đăng ký không hợp lệ.<br>");
            }

            try {
                if (registrationEndStr != null && !registrationEndStr.trim().isEmpty()) {
                    LocalDateTime regEndDateTime = LocalDateTime.parse(registrationEndStr);
                    registrationEnd = Timestamp.valueOf(regEndDateTime);
                }
            } catch (DateTimeParseException e) {
                errors.append("Định dạng thời gian kết thúc đăng ký không hợp lệ.<br>");
            }

            // Validate date logic
            if (startDate != null && endDate != null && startDate.after(endDate)) {
                errors.append("Ngày bắt đầu phải trước ngày kết thúc.<br>");
            }

            // Validate that registration dates are not null after parsing (required fields)
            if (registrationStart == null) {
                errors.append("Thời gian bắt đầu đăng ký là bắt buộc và phải có định dạng hợp lệ.<br>");
            }
            
            if (registrationEnd == null) {
                errors.append("Thời gian kết thúc đăng ký là bắt buộc và phải có định dạng hợp lệ.<br>");
            }

            if (registrationStart != null && registrationEnd != null && registrationStart.after(registrationEnd)) {
                errors.append("Thời gian bắt đầu đăng ký phải trước thời gian kết thúc đăng ký.<br>");
            }

            // Check for overlapping events if user is a club leader
            if (userRoleId == 3 && startDate != null && endDate != null) {
                MemberDAO memberDAO = new MemberDAO();
                List<Integer> clubIds = memberDAO.getClubsWhereUserIsLeader(user.getUserId());
                
                if (!clubIds.isEmpty()) {
                    boolean hasOverlap = eventDAO.hasOverlappingEvents(clubIds, startDate, endDate, -1);
                    if (hasOverlap) {
                        errors.append("Bạn đã có sự kiện khác diễn ra trong khoảng thời gian này. Một club leader không thể có 2 sự kiện diễn ra cùng lúc.<br>");
                    }
                }
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
                request.getRequestDispatcher(determineAddEventView(request)).forward(request, response);
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
                        message = "Sự kiện '" + escapeHtml(eventName) + "' đã được lưu dưới dạng bản nháp thành công với ID: " + eventId;
                    } else {
                        message = "Sự kiện '" + escapeHtml(eventName) + "' đã được công bố thành công với ID: " + eventId;
                    }
                    request.setAttribute("message", message);
                    request.setAttribute("messageType", "success");
                    request.setAttribute("eventId", eventId);
                    request.getRequestDispatcher(determineAddEventView(request)).forward(request, response);
                } else {
                    request.setAttribute("message", "Tạo sự kiện thất bại. Vui lòng thử lại.");
                    request.setAttribute("messageType", "danger");
                    request.getRequestDispatcher(determineAddEventView(request)).forward(request, response);
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
                        message = "Sự kiện '" + escapeHtml(eventName) + "' đã được lưu dưới dạng bản nháp thành công.";
                    } else {
                        message = "Yêu cầu sự kiện '" + escapeHtml(eventName) + "' của bạn đã được gửi thành công và đang chờ phê duyệt từ quản trị viên.";
                    }
                    request.setAttribute("message", message);
                    request.setAttribute("messageType", "success");
                    request.setAttribute("requestId", requestId);
                    request.getRequestDispatcher(determineAddEventView(request)).forward(request, response);
                } else {
                    request.setAttribute("message", "Gửi yêu cầu sự kiện thất bại. Vui lòng thử lại.");
                    request.setAttribute("messageType", "danger");
                    request.getRequestDispatcher(determineAddEventView(request)).forward(request, response);
                }
            } else {
                // Unauthorized user
                request.setAttribute("message", "You do not have permission to create events.");
                request.setAttribute("messageType", "danger");
                request.getRequestDispatcher(determineAddEventView(request)).forward(request, response);
            }

        } catch (Exception e) {
            // Handle unexpected errors
            request.setAttribute("message", "An unexpected error occurred: " + e.getMessage());
            request.setAttribute("messageType", "danger");
            request.getRequestDispatcher(determineAddEventView(request)).forward(request, response);
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
        int lastDotIndex = originalFileName.lastIndexOf('.');
        String extension = "";
        if (lastDotIndex > 0) {
            extension = originalFileName.substring(lastDotIndex);
        }
        String uniqueId = UUID.randomUUID().toString();
        return uniqueId + extension;
    }

    /**
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet for adding new events to the club management system";
    }

    private String determineAddEventView(HttpServletRequest request) {
        // Always use add-event.jsp for both admin and club leader
        // The JSP will automatically choose the correct layout based on user role
        return "/view/eventMgt/add-event.jsp";
    }
}

