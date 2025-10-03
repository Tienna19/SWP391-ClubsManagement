package controller;

import dal.MemberDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Member;

/**
 *
 * @author ADMIN
 */
public class ViewMembersServlet extends HttpServlet {

    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        
        String sortBy = request.getParameter("sortBy");
        String order = request.getParameter("order");
        
        
        if (sortBy == null || sortBy.isEmpty()) sortBy = "memberName";  
        if (order == null || order.isEmpty()) order = "ASC";  

        
        MemberDAO memberDAO = new MemberDAO();
        List<Member> members = memberDAO.getAllMembers(sortBy, order);

       
        request.setAttribute("members", members);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("order", order);
        

     
        request.getRequestDispatcher("memberList.jsp").forward(request, response);
    }

    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet để xem danh sách thành viên với tính năng sắp xếp và lọc";
    }
}
