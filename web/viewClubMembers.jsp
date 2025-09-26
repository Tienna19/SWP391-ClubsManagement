<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Membership" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Thành Viên Câu Lạc Bộ</title>
</head>
<body>
    <h1>Danh sách thành viên của câu lạc bộ</h1>

    <% 
        // Lấy danh sách thành viên từ request
        List<Membership> members = (List<Membership>) request.getAttribute("members");
        
        // Kiểm tra xem có thành viên nào không
        if (members != null && !members.isEmpty()) {
    %>
        <table border="1" cellpadding="5" cellspacing="0" style="border-collapse: collapse;">
            <thead>
                <tr>
                    <th>MembershipID</th>
                    <th>ClubID</th>
                    <th>ClubName</th>
                    <th>UserID</th>
                    <th>MemberName</th>
                    <th>Role</th>
                    <th>Status</th>
                    <th>RequestedAt</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    // Duyệt qua danh sách thành viên và hiển thị thông tin
                    for (Membership member : members) {
                %>
                    <tr>
                        <td><%= member.getMembershipID() %></td>
                        <td><%= member.getClubID() %></td>
                        <td><%= member.getClubName() %></td>
                        <td><%= member.getUserID() %></td>
                        <td><%= member.getFullName() %></td>
                        <td><%= member.getRole() %></td>
                        <td><%= member.getStatus() %></td>
                        <td><%= member.getRequestedAt() %></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    <% 
        } else {
    %>
        <p>Không có thành viên nào trong câu lạc bộ.</p>
    <% } %>

</body>
</html>
