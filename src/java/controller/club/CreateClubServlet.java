package controller.club;

import dal.ClubDAO;
import model.Club;
import model.Category;

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
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String categoryIdStr = request.getParameter("categoryId");
            String createdByUserIdStr = request.getParameter("createdByUserId");
            String supervisorIdStr = request.getParameter("supervisorId");

            // Validation
            if (name == null || name.trim().isEmpty()) {
                throw new IllegalArgumentException("Tên CLB không được để trống");
            }
            if (description == null || description.trim().isEmpty()) {
                throw new IllegalArgumentException("Mô tả CLB không được để trống");
            }
            if (categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Vui long chon the loai CLB");
            }
            if (createdByUserIdStr == null || createdByUserIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Mã sinh viên không được để trống");
            }
            if (supervisorIdStr == null || supervisorIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Mã giảng viên giám sát không được để trống");
            }

            int categoryId = Integer.parseInt(categoryIdStr);
            int createdByUserId = Integer.parseInt(createdByUserIdStr);
            int supervisorId = Integer.parseInt(supervisorIdStr);

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

            String logoUrl = UPLOAD_DIR + "/" + uniqueFileName;

            // ✅ Create Club object
            Club newClub = new Club();
            newClub.setName(name.trim());
            newClub.setDescription(description.trim());
            newClub.setLogoUrl(logoUrl);
            newClub.setCategoryId(categoryId);
            newClub.setCreatedByUserId(createdByUserId);
            newClub.setApprovedByUserId(supervisorId); // Use supervisorId as approvedByUserId
            newClub.setStatus("Pending");
            newClub.setCreatedAt(new Timestamp(System.currentTimeMillis()));

            // ✅ Save to database
            ClubDAO dao = new ClubDAO();
            boolean success = dao.insertClub(newClub);

            if (success) {
                // Success - redirect with success message
                request.getSession().setAttribute("successMessage", "Tao CLB thanh cong! CLB dang cho phe duyet tu giang vien.");
                response.sendRedirect(request.getContextPath() + "/viewAllClubs");
            } else {
                // Database error - delete uploaded file and show error
                try {
                    Files.deleteIfExists(new File(filePath).toPath());
                } catch (Exception ex) {
                    System.err.println("Could not delete uploaded file: " + ex.getMessage());
                }
                throw new Exception("Lỗi khi lưu thông tin CLB vào cơ sở dữ liệu");
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
