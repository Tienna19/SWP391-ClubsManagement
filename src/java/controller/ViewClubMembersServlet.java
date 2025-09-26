package controller;

import dal.MembershipDAO;
import model.Membership;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ViewClubMembersServlet", urlPatterns = {"/viewClubMembers"})
public class ViewClubMembersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String clubIdParam = request.getParameter("clubId");
        
        if (clubIdParam != null && !clubIdParam.isEmpty()) {
            try {
                int clubId = Integer.parseInt(clubIdParam);  

             
                MembershipDAO membershipDAO = new MembershipDAO();
                List<Membership> members = membershipDAO.getClubMembers(clubId);

                if (members != null && !members.isEmpty()) {
                    
                    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                    List<String> formattedDates = new ArrayList<>();
                    
                  
                    for (Membership member : members) {
                        String formattedDate = dateFormat.format(member.getRequestedAt());
                        formattedDates.add(formattedDate);
                    }

                   
                    request.setAttribute("members", members);
                    request.setAttribute("formattedDates", formattedDates);
                    
                    
                    request.getRequestDispatcher("/viewClubMembers.jsp").forward(request, response);
                } else {
                    
                    request.setAttribute("error", "Không có thành viên trong câu lạc bộ.");
                    request.getRequestDispatcher("/errorPage.jsp").forward(request, response);
                }

            } catch (NumberFormatException e) {
                
                request.setAttribute("error", "ID câu lạc bộ không hợp lệ.");
                request.getRequestDispatcher("/errorPage.jsp").forward(request, response);
            }
        } else {
           
            request.setAttribute("error", "Thiếu ID câu lạc bộ.");
            request.getRequestDispatcher("/errorPage.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet hiển thị danh sách thành viên của câu lạc bộ.";
    }
}
