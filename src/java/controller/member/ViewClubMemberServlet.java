/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.member;

import dal.MembershipDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.MembershipRole;

/**
 *
 * @author ADMIN
 */
public class ViewClubMemberServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ViewClubMemberServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ViewClubMemberServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Preconditions: đã đăng nhập
        Integer currentUserId = (Integer) req.getSession().getAttribute("userId");
        if (currentUserId == null) {
            resp.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Please log in first.");
            return;
        }

        // clubId từ URL
        String clubIdRaw = req.getParameter("clubId");
        if (clubIdRaw == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing clubId.");
            return;
        }
        int clubId;
        try {
            clubId = Integer.parseInt(clubIdRaw);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid clubId.");
            return;
        }

        // Sort optional
        String sortBy = req.getParameter("sortBy");   // name | role | joindate
        String order  = req.getParameter("order");    // ASC | DESC

        try {
            MembershipDAO dao = new MembershipDAO();
            List<MembershipRole> members = dao.listMembers(clubId, sortBy, order);

            req.setAttribute("members", members);
            req.setAttribute("clubId", clubId);
            req.setAttribute("sortBy", sortBy == null ? "name" : sortBy);
            req.setAttribute("order",  order  == null ? "ASC"  : order);

            req.getRequestDispatcher("/WEB-INF/views/club/myMemberList.jsp").forward(req, resp);
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
