package controller.club;

import dal.ClubDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Club;
import model.Category;

// @WebServlet annotation removed - servlet is configured in web.xml
public class ViewAllClubServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            request.setAttribute("activeMenu", "clubs");
            request.setAttribute("activeSubMenu", "clubs-list");
            ClubDAO dao = new ClubDAO();
            
            // Get parameters for filtering and searching
            String searchQuery = request.getParameter("search");
            String statusFilter = request.getParameter("status");
            String categoryFilter = request.getParameter("category");
            String sortBy = request.getParameter("sort");
            String sortOrder = request.getParameter("order");
            
            // Parse category filter
            Integer categoryId = null;
            if (categoryFilter != null && !categoryFilter.trim().isEmpty() && !"all".equals(categoryFilter)) {
                try {
                    categoryId = Integer.parseInt(categoryFilter);
                } catch (NumberFormatException e) {
                    categoryId = null;
                }
            }
            
            // Pagination parameters
            int currentPage = 1;
            int recordsPerPage = 10; // Số records per page
            
            try {
                String pageParam = request.getParameter("page");
                if (pageParam != null && !pageParam.trim().isEmpty()) {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) currentPage = 1;
                }
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
            
            // Get filtered clubs directly from DAO
            System.out.println("[ViewAllClubServlet] Fetching clubs with categoryId: " + categoryId + ", status: " + statusFilter + ", search: " + searchQuery);
            List<Club> allFilteredClubs = dao.getFilteredClubs(categoryId, statusFilter, searchQuery);
            System.out.println("[ViewAllClubServlet] Retrieved " + allFilteredClubs.size() + " clubs from DAO");
            
            // Calculate pagination
            int totalRecords = allFilteredClubs.size();
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
            
            // Adjust current page if it's beyond total pages
            if (currentPage > totalPages && totalPages > 0) {
                currentPage = totalPages;
            }
            
            // Apply sorting
            if (sortBy != null && sortBy.equals("id")) {
                if (sortOrder != null && sortOrder.equals("desc")) {
                    allFilteredClubs.sort((c1, c2) -> Integer.compare(c2.getClubId(), c1.getClubId()));
                } else {
                    allFilteredClubs.sort((c1, c2) -> Integer.compare(c1.getClubId(), c2.getClubId()));
                }
            }
            
            // Get paginated clubs
            List<Club> paginatedClubs = getPaginatedClubs(allFilteredClubs, currentPage, recordsPerPage);

            // Normalize logo paths for consistent rendering on JSP
            for (Club club : paginatedClubs) {
                String logo = club.getLogo();
                if (logo != null) {
                    club.setLogo(logo.trim().replace("\\", "/"));
                }
            }
            
            // Get all categories for dropdown
            List<Category> categories = dao.getAllCategories();
            
            // Set attributes for JSP
            boolean isAdminLayout = false;
            HttpSession session = request.getSession(false);
            if (session != null) {
                Object roleObj = session.getAttribute("roleId");
                if (roleObj instanceof Integer) {
                    isAdminLayout = ((Integer) roleObj) == 4;
                }
            }
            String targetJsp = isAdminLayout ? "/view/admin/admin-club-list.jsp" : "/view/club/viewAllClubs.jsp";

            request.setAttribute("clubs", paginatedClubs);
            request.setAttribute("categories", categories);
            request.setAttribute("totalClubs", totalRecords);
            request.setAttribute("searchQuery", searchQuery);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("categoryFilter", categoryFilter);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("sortOrder", sortOrder);
            
            // Pagination attributes
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("recordsPerPage", recordsPerPage);
            
            // Count clubs by status
            long activeClubs = allFilteredClubs.stream()
                .filter(c -> "Active".equalsIgnoreCase(c.getStatus()))
                .count();
            long inactiveClubs = allFilteredClubs.stream()
                .filter(c -> "Inactive".equalsIgnoreCase(c.getStatus()))
                .count();
            
            request.setAttribute("activeClubs", activeClubs);
            request.setAttribute("inactiveClubs", inactiveClubs);
            
            // Forward to view
            request.getRequestDispatcher(targetJsp).forward(request, response);
            
        } catch (Exception e) {
            // Log error and show error page
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while loading clubs: " + e.getMessage());
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    /**
     * Get paginated clubs from the list
     */
    private List<Club> getPaginatedClubs(List<Club> allClubs, int currentPage, int recordsPerPage) {
        if (allClubs == null || allClubs.isEmpty()) {
            return allClubs;
        }
        
        int startIndex = (currentPage - 1) * recordsPerPage;
        int endIndex = Math.min(startIndex + recordsPerPage, allClubs.size());
        
        if (startIndex >= allClubs.size()) {
            return new java.util.ArrayList<>();
        }
        
        return allClubs.subList(startIndex, endIndex);
    }
}
