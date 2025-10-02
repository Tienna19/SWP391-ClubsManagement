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
            
            // Get filtered clubs directly from DAO
            List<Club> filteredClubs = dao.getFilteredClubs(categoryId, statusFilter, searchQuery);
            
            // Get all clubs for statistics
            List<Club> allClubs = dao.getAllClubs();
            
            // Get all categories for dropdown
            List<Category> categories = dao.getAllCategories();
            
            // Set attributes for JSP
            request.setAttribute("clubs", filteredClubs);
            request.setAttribute("allClubs", allClubs);
            request.setAttribute("categories", categories);
            request.setAttribute("totalClubs", filteredClubs.size());
            request.setAttribute("searchQuery", searchQuery);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("categoryFilter", categoryFilter);
            
            // Count clubs by status
            long activeClubs = filteredClubs.stream().filter(Club::isActive).count();
            long pendingClubs = filteredClubs.stream().filter(Club::isPending).count();
            
            request.setAttribute("activeClubs", activeClubs);
            request.setAttribute("pendingClubs", pendingClubs);
            
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
    
    // Filtering is now handled by DAO's getFilteredClubs method
}
