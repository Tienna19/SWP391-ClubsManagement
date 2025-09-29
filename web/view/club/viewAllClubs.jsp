<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, model.Club" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Danh sách Câu Lạc Bộ</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 40px;
            }
            table {
                border-collapse: collapse;
                width: 100%;
            }
            th, td {
                border: 1px solid #999;
                padding: 8px 12px;
                text-align: left;
            }
            th {
                background-color: #f2f2f2;
            }
            img {
                border-radius: 4px;
            }
            a.button {
                display: inline-block;
                margin-top: 20px;
                padding: 10px 15px;
                background-color: #007bff;
                color: #fff;
                text-decoration: none;
                border-radius: 4px;
            }
            a.button:hover {
                background-color: #0056b3;
            }
        </style>
    </head>
    <body>

        <!-- ✅ Include header -->
        <jsp:include page="../layout/header.jsp" />

        <div class="container mt-5">
            <h2>📋 Danh sách Câu Lạc Bộ</h2>

            <table>
                <tr>
                    <th>ID</th>
                    <th>Tên CLB</th>
                    <th>Mô tả</th>
                    <th>Logo</th>
                    <th>Category ID</th>
                    <th>Created By</th>
                    <th>Status</th>
                    <th>Created At</th>
                    <th>Approved By</th>
                </tr>

                <%
                    List<Club> clubs = (List<Club>) request.getAttribute("clubs");
                    if (clubs != null && !clubs.isEmpty()) {
                        for (Club c : clubs) {
                %>
                <tr>
                    <td><%= c.getClubId() %></td>
                    <td><%= c.getName() %></td>
                    <td><%= c.getDescription() %></td>
                    <td>
                        <% if (c.getLogoUrl() != null && !c.getLogoUrl().isEmpty()) { %>
                        <img src="<%= c.getLogoUrl() %>" alt="logo" width="60">
                        <% } else { %>
                        <span>Chưa có</span>
                        <% } %>
                    </td>
                    <td><%= c.getCategoryId() %></td>
                    <td><%= c.getCreatedByUserId() %></td>
                    <td><%= c.getStatus() %></td>
                    <td><%= c.getCreatedAt() %></td>
                    <td><%= c.getApprovedByUserId() != null ? c.getApprovedByUserId() : "N/A" %></td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="9" style="text-align:center;">Không có CLB nào.</td>
                </tr>
                <% } %>
            </table>

            <a href="<%= request.getContextPath() %>/createClub" class="button">+ Tạo CLB mới</a>
        </div>

        <!-- ✅ Include footer -->
        <jsp:include page="../layout/footer.jsp" />

    </body>
</html>
