package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "GoogleLoginServlet", urlPatterns = {"/google-login"})
public class GoogleLoginServlet extends HttpServlet {

    private String CLIENT_ID;
    private final String REDIRECT_URI = "http://localhost:9999/SWP391-ClubsManagement/google-callback";

    @Override
    public void init() throws ServletException {
        CLIENT_ID = getServletContext().getInitParameter("GOOGLE_CLIENT_ID");

        if (CLIENT_ID == null) {
            throw new ServletException("Không tìm thấy cấu hình Google Client ID/Secret trong web.xml");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String encodedRedirectURI = URLEncoder.encode(REDIRECT_URI, StandardCharsets.UTF_8);

        // URL chuẩn của Google OAuth 2.0
        String url = "https://accounts.google.com/o/oauth2/v2/auth"
                + "?scope=" + URLEncoder.encode("email profile openid", StandardCharsets.UTF_8)
                + "&access_type=offline"
                + "&include_granted_scopes=true"
                + "&response_type=code"
                + "&redirect_uri=" + encodedRedirectURI
                + "&client_id=" + CLIENT_ID
                + "&prompt=consent";

        response.sendRedirect(url);
    }
}
