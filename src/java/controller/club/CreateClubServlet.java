package controller.club;

import dal.ClubDAO;
import dal.CreateClubRequestDAO;
import model.Category;
import model.CreateClubRequest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;

// @WebServlet annotation removed - servlet is configured in web.xml
@MultipartConfig(
    maxFileSize = 5 * 1024 * 1024, // 5MB max file size
    maxRequestSize = 10 * 1024 * 1024 // 10MB max request size
)
public class CreateClubServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "assets/images/Club";
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

        String savedLogoPath = null;
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
            savedLogoPath = storeLogoFile(filePart);
            String logo = savedLogoPath;

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
                deleteLogoFile(savedLogoPath);
                throw new Exception("Lỗi khi gửi yêu cầu tạo CLB");
            }

        } catch (NumberFormatException e) {
            handleError(request, response, "Dữ liệu không hợp lệ: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            handleError(request, response, e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            if (savedLogoPath != null) {
                deleteLogoFile(savedLogoPath);
            }
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

    private Path getSourceUploadDir() {
        return Paths.get(System.getProperty("user.dir"), "web", "assets", "images", "Club");
    }

    private Path getDeploymentUploadDir() {
        String realRoot = getServletContext().getRealPath("/");
        return Paths.get(realRoot, "assets", "images", "Club");
    }

    private void deleteLogoFile(String relativePath) {
        if (relativePath == null || relativePath.trim().isEmpty()) {
            return;
        }
        try {
            Path fileName = Paths.get(relativePath).getFileName();
            if (fileName == null) {
                return;
            }
            Path sourcePath = getSourceUploadDir().resolve(fileName);
            Files.deleteIfExists(sourcePath);
        } catch (Exception ignored) {
        }
        try {
            Path fileName = Paths.get(relativePath).getFileName();
            if (fileName == null) {
                return;
            }
            Path deployPath = getDeploymentUploadDir().resolve(fileName);
            Files.deleteIfExists(deployPath);
        } catch (Exception ignored) {
        }
    }

    private String storeLogoFile(Part filePart) throws IOException {
        String originalFileName = filePart.getSubmittedFileName();
        String[] nameParts = splitFileName(originalFileName);
        String baseName = nameParts[0];
        String extension = nameParts[1];

        Path sourceDir = getSourceUploadDir();
        Files.createDirectories(sourceDir);

        String availableFileName = resolveUniqueFileName(sourceDir, baseName, extension);
        Path sourceFile = sourceDir.resolve(availableFileName);

        try (InputStream inputStream = filePart.getInputStream()) {
            Files.copy(inputStream, sourceFile, StandardCopyOption.REPLACE_EXISTING);
        }

        Path deploymentDir = getDeploymentUploadDir();
        Files.createDirectories(deploymentDir);
        Files.copy(sourceFile, deploymentDir.resolve(availableFileName), StandardCopyOption.REPLACE_EXISTING);

        return UPLOAD_DIR + "/" + availableFileName;
    }

    private String[] splitFileName(String originalFileName) {
        String safeName = Paths.get(originalFileName).getFileName().toString();
        int dotIdx = safeName.lastIndexOf('.');
        String base = dotIdx > 0 ? safeName.substring(0, dotIdx) : safeName;
        String ext = dotIdx > 0 ? safeName.substring(dotIdx).toLowerCase() : "";

        base = base.replaceAll("[^a-zA-Z0-9-_]", "-").replaceAll("-+", "-");
        if (base.isBlank()) {
            base = "club-logo";
        }
        return new String[]{base, ext};
    }

    private String resolveUniqueFileName(Path directory, String baseName, String extension) throws IOException {
        String candidate = baseName + extension;
        int counter = 1;
        while (Files.exists(directory.resolve(candidate))) {
            candidate = baseName + "-" + counter + extension;
            counter++;
        }
        return candidate;
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
