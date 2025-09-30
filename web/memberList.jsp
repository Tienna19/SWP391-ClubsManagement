<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Danh Sách Thành Viên Câu Lạc Bộ</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        td {
            background-color: #fff;
        }
        .no-members {
            text-align: center;
            font-size: 18px;
            color: #ff0000;
        }
    </style>
</head>
<body>

    <h2>Danh Sách Thành Viên Câu Lạc Bộ</h2>

    <c:if test="${not empty members}">
        <table>
            <thead>
                <tr>
                    <th>Tên</th>
                    <th>Vai trò</th>
                    <th>Ngày Gia Nhập</th>
                    <th>Trạng Thái</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="user" items="${members}">
                    <tr>
                        <td>${user.memberName}</td>
                        <td>${user.role}</td>
                        <td>${user.joinDate}</td>
                        <td>${user.status}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>

    <c:if test="${empty members}">
        <div class="no-members">Câu lạc bộ này chưa có thành viên.</div>
    </c:if>

</body>
</html>
