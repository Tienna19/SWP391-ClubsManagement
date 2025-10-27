package controller.club;

import dal.ClubDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
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
            ClubDAO dao = new ClubDAO();
            
            // Get parameters for filtering and searching
            String searchQuery = request.getParameter("search");
            String statusFilter = request.getParameter("status");
            String categoryFilter = request.getParameter("category");
            String clubIdParam = request.getParameter("clubId");
            String sortBy = request.getParameter("sort");
            String sortOrder = request.getParameter("order");
            
            // If clubId is provided, show club details
            if (clubIdParam != null && !clubIdParam.trim().isEmpty()) {
                handleClubDetails(request, response, dao, clubIdParam);
                return;
            }
            
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
            
            // Get all categories for dropdown
            List<Category> categories = dao.getAllCategories();
            
            // Set attributes for JSP
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
            request.getRequestDispatcher("/view/club/viewAllClubs.jsp").forward(request, response);
            
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
     * Handle club details view
     */
    private void handleClubDetails(HttpServletRequest request, HttpServletResponse response, 
                                 ClubDAO dao, String clubIdParam) 
            throws ServletException, IOException {
        try {
            int clubId = Integer.parseInt(clubIdParam);
            
            // Get specific club by ID
            Club selectedClub = dao.getClubById(clubId);
            List<Club> allClubs = dao.getAllClubs();
            
            if (selectedClub != null) {
                request.setAttribute("selectedClub", selectedClub);
                request.setAttribute("clubs", allClubs);
                request.getRequestDispatcher("/view/club/clubDetails.jsp").forward(request, response);
            } else {
                // Club not found, redirect back to all clubs
                response.sendRedirect("viewAllClubs?error=Club not found");
            }
            
        } catch (NumberFormatException e) {
            // Invalid club ID, redirect back to all clubs
            response.sendRedirect("viewAllClubs?error=Invalid club ID");
        }
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
