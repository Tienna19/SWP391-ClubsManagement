package controller.club;

import dal.ClubDAO;
import dal.MembershipDAO;
import dal.CreateClubRequestDAO;
import model.Club;
import model.Category;
import model.CreateClubRequest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.sql.Timestamp;
import java.util.List;
import java.util.UUID;

// @WebServlet annotation removed - servlet is configured in web.xml
@MultipartConfig(
    maxFileSize = 5 * 1024 * 1024, // 5MB max file size
    maxRequestSize = 10 * 1024 * 1024 // 10MB max request size
)
public class CreateClubServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads";
    private static final String[] ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif", ".webp"};
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            ClubDAO dao = new ClubDAO();
            List<Category> categoryList = dao.getAllCategories();

            request.setAttribute("categoryList", categoryList);
            request.getRequestDispatcher("/view/club/createClubs.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tải trang tạo CLB: " + e.getMessage());
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {
            // ✅ Validate input parameters
            String clubName = request.getParameter("clubName");
            String description = request.getParameter("description");
            String clubTypes = request.getParameter("clubTypes");
            String createdByStr = request.getParameter("createdBy");

            // Validation
            if (clubName == null || clubName.trim().isEmpty()) {
                throw new IllegalArgumentException("Tên CLB không được để trống");
            }
            if (description == null || description.trim().isEmpty()) {
                throw new IllegalArgumentException("Mô tả CLB không được để trống");
            }
            if (clubTypes == null || clubTypes.trim().isEmpty()) {
                throw new IllegalArgumentException("Vui lòng chọn thể loại CLB");
            }
            if (createdByStr == null || createdByStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Mã người tạo không được để trống");
            }

            int createdBy = Integer.parseInt(createdByStr);

            // ✅ Validate file upload
            Part filePart = request.getPart("logo");
            if (filePart == null || filePart.getSize() == 0) {
                throw new IllegalArgumentException("Vui long chon logo cho CLB");
            }

            String fileName = filePart.getSubmittedFileName();
            if (fileName == null || fileName.trim().isEmpty()) {
                throw new IllegalArgumentException("Tên file không hợp lệ");
            }

            // Validate file extension
            if (!isValidFileExtension(fileName)) {
                throw new IllegalArgumentException("Chỉ chấp nhận file ảnh: JPG, JPEG, PNG, GIF, WEBP");
            }

            // Validate file size
            if (filePart.getSize() > MAX_FILE_SIZE) {
                throw new IllegalArgumentException("Kích thước file không được vượt quá 5MB");
            }

            // ✅ Process file upload with unique name
            String uniqueFileName = generateUniqueFileName(fileName);
            String uploadPath = getServletContext().getRealPath("/" + UPLOAD_DIR);
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String filePath = uploadPath + File.separator + uniqueFileName;
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, new File(filePath).toPath());
            }

            String logo = UPLOAD_DIR + "/" + uniqueFileName;

            // ✅ Create Club Request object (NOT directly creating Club)
            CreateClubRequest clubRequest = new CreateClubRequest(
                clubName.trim(),
                description.trim(),
                logo,
                clubTypes.trim(),
                createdBy
            );

            // ✅ Save to CreateClubRequests table (Pending status)
            CreateClubRequestDAO requestDAO = new CreateClubRequestDAO();
            int requestId = requestDAO.insertRequest(clubRequest);

            if (requestId > 0) {
                // Success - redirect with success message
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", 
                    "Yêu cầu tạo CLB đã được gửi! Admin sẽ xem xét và phê duyệt.");
                response.sendRedirect(request.getContextPath() + "/home");
            } else {
                // Database error - delete uploaded file and show error
                try {
                    Files.deleteIfExists(new File(filePath).toPath());
                } catch (Exception ex) {
                    System.err.println("Could not delete uploaded file: " + ex.getMessage());
                }
                throw new Exception("Lỗi khi gửi yêu cầu tạo CLB");
            }

        } catch (NumberFormatException e) {
            handleError(request, response, "Dữ liệu không hợp lệ: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            handleError(request, response, e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            handleError(request, response, "Lỗi khi tạo CLB: " + e.getMessage());
        }
    }

    /**
     * Check if file extension is allowed
     */
    private boolean isValidFileExtension(String fileName) {
        if (fileName == null) return false;
        
        String extension = fileName.toLowerCase();
        for (String allowedExt : ALLOWED_EXTENSIONS) {
            if (extension.endsWith(allowedExt)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Generate unique file name to avoid conflicts
     */
    private String generateUniqueFileName(String originalFileName) {
        String extension = "";
        int lastDotIndex = originalFileName.lastIndexOf('.');
        if (lastDotIndex > 0) {
            extension = originalFileName.substring(lastDotIndex);
        }
        
        String uniqueId = UUID.randomUUID().toString();
        return uniqueId + extension;
    }

    /**
     * Handle errors by forwarding to create form with error message
     */
    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage) 
            throws ServletException, IOException {
        try {
            // Reload categories for the form
            ClubDAO dao = new ClubDAO();
            List<Category> categoryList = dao.getAllCategories();
            request.setAttribute("categoryList", categoryList);
            
            // Set error message
            request.setAttribute("errorMessage", errorMessage);
            
            // Forward back to create form
            request.getRequestDispatcher("/view/club/createClubs.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }
}
