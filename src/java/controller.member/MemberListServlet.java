package controller.member;



import dal.MemberDAO;
import model.MemberDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "MemberListServlet", urlPatterns = {"/member/list"})
public class MemberListServlet extends HttpServlet {

    
    private static final int CLUB_ID = 1;
    private MemberDAO memberDAO;

    @Override
    public void init() {
        memberDAO = new MemberDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<MemberDTO> members = memberDAO.findMembersByClub(CLUB_ID);

        request.setAttribute("members", members);
        
        request.getRequestDispatcher("/view/member/member-list.jsp").forward(request, response);

    }
}
