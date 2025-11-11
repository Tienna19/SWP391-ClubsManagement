package controller.club;

import dal.ClubDAO;
import dal.MemberDAO;
import dal.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import model.Club;
import model.User;

/**
 * Update Club Servlet - Cập nhật thông tin CLB
 */
@MultipartConfig(
    maxFileSize = 5 * 1024 * 1024,      // 5MB
    maxRequestSize = 10 * 1024 * 1024   // 10MB
)
public class UpdateClubServlet extends HttpServlet {
    
    private static final String UPLOAD_DIR = "assets/images/Club";
    private static final String[] ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif", ".webp"};
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get clubId
            String clubIdParam = request.getParameter("clubId");
            
            if (clubIdParam == null || clubIdParam.isEmpty()) {
                request.setAttribute("error", "Club ID không hợp lệ.");
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
                return;
            }
            
            int clubId = Integer.parseInt(clubIdParam);
            ClubDAO clubDAO = new ClubDAO();
            Club club = clubDAO.getClubById(clubId);
            
            if (club == null) {
                request.setAttribute("error", "CLB không tồn tại.");
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
                return;
            }
            
            // ✅ CHECK PERMISSIONS: Only Admin or Club Leader can edit
            HttpSession session = request.getSession(false);
            
            // Check if user is logged in
            if (session == null || session.getAttribute("userId") == null) {
                response.sendRedirect(request.getContextPath() + "/login?error=login_required&redirect=updateClub&clubId=" + clubId);
                return;
            }
            
            Integer userId = (Integer) session.getAttribute("userId");
            Integer roleId = (Integer) session.getAttribute("roleId");
            
            MemberDAO memberDAO = new MemberDAO();
            
            // Check permissions:
            // RoleID: 4 = Admin, 3 = ClubLeader, 2 = Member, 1 = User
            boolean hasPermission = false;
            
            if (roleId == 4) {
                // Admin can edit any club
                hasPermission = true;
            } else if (roleId == 3) {
                // Club Leader: verify leader membership
                hasPermission = memberDAO.isClubLeader(userId, clubId);
            }
            
            if (!hasPermission) {
                request.setAttribute("error", "Bạn không có quyền chỉnh sửa CLB này. Chỉ Admin hoặc Club Leader mới có quyền.");
                request.setAttribute("errorCode", "403");
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
                return;
            }
            
            // Load all users for leader dropdown
            UserDAO userDAO = new UserDAO();
            List<User> allUsers = userDAO.getAllUsers();
            
            // Set attributes
            request.setAttribute("club", club);
            request.setAttribute("allUsers", allUsers);
            request.setAttribute("activeMenu", "club-edit");
            
            request.getRequestDispatcher("/view/club/edit-club.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String uploadedLogoPath = null;
        try {
            // Get form data
            int clubId = Integer.parseInt(request.getParameter("clubId"));
            String clubName = request.getParameter("clubName");
            String description = request.getParameter("description");
            String clubTypes = request.getParameter("clubTypes");
            String status = request.getParameter("status");
            String newLeaderIdParam = request.getParameter("newLeaderId");
            String currentLogo = request.getParameter("currentLogo");
            
            // ✅ CHECK PERMISSIONS FIRST
            HttpSession session = request.getSession(false);
            
            // Check if user is logged in
            if (session == null || session.getAttribute("userId") == null) {
                response.sendRedirect(request.getContextPath() + "/login?error=login_required");
                return;
            }
            
            Integer currentUserId = (Integer) session.getAttribute("userId");
            Integer roleId = (Integer) session.getAttribute("roleId");
            
            // Validate
            if (clubName == null || clubName.trim().isEmpty()) {
                request.setAttribute("error", "Tên CLB không được để trống.");
                request.setAttribute("activeMenu", "club-edit");
                doGet(request, response);
                return;
            }
            
            // Get existing club
            ClubDAO clubDAO = new ClubDAO();
            Club club = clubDAO.getClubById(clubId);
            
            if (club == null) {
                request.setAttribute("error", "CLB không tồn tại.");
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
                return;
            }
            
            // ✅ Verify permission again (double check)
            boolean hasPermission = false;
            if (roleId == 4) {
                hasPermission = true; // Admin
            } else if (roleId == 3) {
                MemberDAO memberDAO = new MemberDAO();
                hasPermission = memberDAO.isClubLeader(currentUserId, clubId);
            }
            
            if (!hasPermission) {
                request.setAttribute("error", "Bạn không có quyền chỉnh sửa CLB này.");
                request.setAttribute("errorCode", "403");
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
                return;
            }
            
            // Handle logo upload
            Part filePart = request.getPart("logo");
            String newLogo = currentLogo; // Default to current logo
            
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = filePart.getSubmittedFileName();
                
                // Validate file
                if (!isValidFileExtension(fileName)) {
                    request.setAttribute("error", "Chỉ chấp nhận file ảnh: JPG, JPEG, PNG, GIF, WEBP");
                request.setAttribute("activeMenu", "club-edit");
                    doGet(request, response);
                    return;
                }
                
                if (filePart.getSize() > MAX_FILE_SIZE) {
                    request.setAttribute("error", "Kích thước file không được vượt quá 5MB");
                request.setAttribute("activeMenu", "club-edit");
                    doGet(request, response);
                    return;
                }
                
                // Save new logo
                uploadedLogoPath = storeLogoFile(filePart);

                if (currentLogo != null && !currentLogo.trim().isEmpty()) {
                    deleteExistingLogo(currentLogo);
                }

                newLogo = uploadedLogoPath;
            }
            
            // Handle leader change
            if (newLeaderIdParam != null && !newLeaderIdParam.trim().isEmpty()) {
                int newLeaderId = Integer.parseInt(newLeaderIdParam);
                if (newLeaderId != club.getCreatedBy()) {
                    club.setCreatedBy(newLeaderId);
                }
            }
            
            // Update club info
            club.setClubName(clubName.trim());
            club.setDescription(description.trim());
            club.setClubTypes(clubTypes);
            club.setStatus(status);
            club.setLogo(newLogo);
            
            // Update in database
            boolean success = clubDAO.updateClub(club);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/clubDashboard?clubId=" + clubId + "&message=update_success");
            } else {
                request.setAttribute("error", "Cập nhật thất bại. Vui lòng thử lại.");
                request.setAttribute("club", club);
                doGet(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ: " + e.getMessage());
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            if (uploadedLogoPath != null) {
                deleteExistingLogo(uploadedLogoPath);
            }
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
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

    private void deleteExistingLogo(String logoPath) {
        if (logoPath == null || logoPath.trim().isEmpty()) {
            return;
        }
        Path fileName = Paths.get(logoPath).getFileName();
        if (fileName == null) {
            return;
        }
        try {
            Files.deleteIfExists(getDeploymentUploadDir().resolve(fileName));
        } catch (Exception ignored) {
        }
        try {
            Files.deleteIfExists(getSourceUploadDir().resolve(fileName));
        } catch (Exception ignored) {
        }
    }

    private String storeLogoFile(Part part) throws IOException {
        String[] nameParts = splitFileName(part.getSubmittedFileName());
        String baseName = nameParts[0];
        String extension = nameParts[1];

        Path sourceDir = getSourceUploadDir();
        Files.createDirectories(sourceDir);
        String availableFileName = resolveUniqueFileName(sourceDir, baseName, extension);

        Path sourceFile = sourceDir.resolve(availableFileName);
        try (InputStream inputStream = part.getInputStream()) {
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
}

