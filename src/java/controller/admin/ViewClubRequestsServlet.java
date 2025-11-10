package controller.admin;

import dal.CreateClubRequestDAO;
import model.CreateClubRequest;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * View Club Requests Servlet - Admin xem danh sách yêu cầu tạo CLB
 */
public class ViewClubRequestsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // ✅ Check if user is Admin
        HttpSession session = request.getSession(false);
        request.setAttribute("activeMenu", "clubs");
        request.setAttribute("activeSubMenu", "club-requests");
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=login_required");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        Integer roleId = (Integer) session.getAttribute("roleId");
        String fullName = (String) session.getAttribute("fullName");
        
        // DEBUG: Log session info
        System.out.println("=== VIEW CLUB REQUESTS - SESSION INFO ===");
        System.out.println("User ID: " + userId);
        System.out.println("Role ID: " + roleId);
        System.out.println("Full Name: " + fullName);
        System.out.println("=========================================");
        
        if (roleId == null || roleId != 4) {  // RoleID 4 = Admin
            System.err.println("❌ ACCESS DENIED - Role ID: " + roleId + " (expected: 4)");
            request.setAttribute("error", "Chỉ Admin mới có quyền xem danh sách yêu cầu tạo CLB.");
            request.setAttribute("errorCode", "403");
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
            return;
        }
        
        System.out.println("✅ Admin access granted - Role ID: " + roleId);

        try {
            CreateClubRequestDAO dao = new CreateClubRequestDAO();
            
            String statusFilter = request.getParameter("status");
            if (statusFilter != null) {
                statusFilter = statusFilter.trim();
            }
            if (statusFilter == null || statusFilter.isEmpty()) {
                statusFilter = "Pending";
            }
            
            List<CreateClubRequest> allRequests = dao.getAllRequests();
            if (allRequests == null) {
                allRequests = new java.util.ArrayList<>();
            }
            
            List<CreateClubRequest> pendingRequests = new java.util.ArrayList<>();
            List<CreateClubRequest> approvedRequests = new java.util.ArrayList<>();
            List<CreateClubRequest> rejectedRequests = new java.util.ArrayList<>();
            
            for (CreateClubRequest req : allRequests) {
                // normalize status and logo
                String status = req.getStatus();
                if (status != null) {
                    status = status.trim();
                    req.setStatus(status);
                }
                String normalizedLogo = normalizeLogoPath(req.getLogo());
                req.setLogo(normalizedLogo);

                if (status == null || status.isEmpty()) {
                    continue;
                }
                if (status.equalsIgnoreCase("Pending")) {
                    pendingRequests.add(req);
                } else if (status.equalsIgnoreCase("Approved")) {
                    approvedRequests.add(req);
                } else if (status.equalsIgnoreCase("Rejected")) {
                    rejectedRequests.add(req);
                }
            }
            
            List<CreateClubRequest> requests;
            switch (statusFilter.toLowerCase()) {
                case "pending":
                    requests = pendingRequests;
                    statusFilter = "Pending";
                    break;
                case "approved":
                    requests = approvedRequests;
                    statusFilter = "Approved";
                    break;
                case "rejected":
                    requests = rejectedRequests;
                    statusFilter = "Rejected";
                    break;
                default:
                    requests = allRequests;
                    statusFilter = "All";
                    break;
            }
            
            System.out.println("Fetched " + requests.size() + " club requests for filter: " + statusFilter);
            for (CreateClubRequest req : requests) {
                System.out.println(" - Request " + req.getRequestId() + ": status=" + req.getStatus() + ", club=" + req.getClubName());
            }
            
            int pendingCount = pendingRequests.size();
            int approvedCount = approvedRequests.size();
            int rejectedCount = rejectedRequests.size();
            
            // Set attributes
            request.setAttribute("requests", requests);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("approvedCount", approvedCount);
            request.setAttribute("rejectedCount", rejectedCount);

            // Forward to JSP
            request.getRequestDispatcher("/view/admin/admin-club-requests.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải danh sách yêu cầu: " + e.getMessage());
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }

    private String normalizeLogoPath(String logo) {
        if (logo == null || logo.trim().isEmpty()) {
            return null;
        }
        String normalized = logo.trim().replace("\\", "/");
        if (normalized.startsWith("http://") || normalized.startsWith("https://")) {
            return normalized;
        }
        int webIndex = normalized.indexOf("/web/");
        if (webIndex >= 0) {
            normalized = normalized.substring(webIndex + 4);
        }
        if (normalized.startsWith("/")) {
            normalized = normalized.substring(1);
        }
        if (normalized.contains("assets/")) {
            normalized = normalized.substring(normalized.indexOf("assets/"));
        } else if (normalized.contains("uploads/")) {
            normalized = normalized.substring(normalized.indexOf("uploads/"));
        }
        if (!normalized.startsWith("assets/") && !normalized.startsWith("uploads/")) {
            normalized = normalized.startsWith("/") ? normalized.substring(1) : normalized;
        }
        if (!normalized.startsWith("/")) {
            normalized = "/" + normalized;
        }
        return normalized;
    }
}

