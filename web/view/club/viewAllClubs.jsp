<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách Câu Lạc Bộ</title>
    <style>
        body {
            font-family: 'Roboto', Arial, sans-serif;
            margin: 0;
            background: #f9f9fb;
            color: #333;
        }
        .container {
            max-width: 1200px;
            margin: 40px auto;
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 6px 16px rgba(0,0,0,0.08);
        }
        h2 {
            margin-bottom: 20px;
            color: #5E35B1;
            font-size: 24px;
        }

        /* Bộ lọc */
        .filter-bar {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-bottom: 25px;
        }
        .filter-bar select,
        .filter-bar input[type="text"] {
            padding: 8px 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            min-width: 180px;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .filter-bar select:focus,
        .filter-bar input:focus {
            border-color: #5E35B1;
            box-shadow: 0 0 0 2px rgba(94,53,177,0.2);
            outline: none;
        }
        .filter-bar button {
            background-color: #5E35B1;
            color: #fff;
            border: none;
            padding: 9px 18px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            transition: background-color 0.2s;
        }
        .filter-bar button:hover {
            background-color: #4527A0;
        }

        /* Bảng CLB */
        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 10px;
            border-radius: 8px;
            overflow: hidden;
        }
        th, td {
            padding: 12px 16px;
            text-align: left;
        }
        th {
            background: #5E35B1;
            color: white;
            font-weight: 600;
        }
        tr:nth-child(even) {
            background: #f8f6fc;
        }
        tr:hover {
            background: #ede7f6;
            transition: background 0.2s;
        }
        img {
            border-radius: 6px;
            max-height: 50px;
        }

        /* Button */
        a.button {
            display: inline-block;
            margin-top: 25px;
            padding: 10px 18px;
            background-color: #43a047;
            color: #fff;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 500;
            transition: background-color 0.2s;
        }
        a.button:hover {
            background-color: #2e7d32;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .filter-bar {
                flex-direction: column;
                align-items: stretch;
            }
            table, th, td {
                font-size: 14px;
            }
        }
    </style>
</head>
<body>

    <!-- ✅ Include header -->
    <jsp:include page="../layout/header.jsp" />

    <div class="container">
        <h2>📋 Danh sách Câu Lạc Bộ</h2>

        <!-- 🔍 Bộ lọc -->
        <form method="get" action="${pageContext.request.contextPath}/viewAllClubs" class="filter-bar">
            <!-- Lọc theo Category -->
            <select name="category">
                <option value="">-- Tất cả Categories --</option>
                <c:forEach var="cat" items="${categories}">
                    <option value="${cat.id}" <c:if test="${param.category eq cat.id}">selected</c:if>>
                        ${cat.name}
                    </option>
                </c:forEach>
            </select>

            <!-- Lọc theo Status -->
            <select name="status">
                <option value="">-- Tất cả Trạng thái --</option>
                <option value="Pending" <c:if test="${param.status eq 'Pending'}">selected</c:if>>Pending</option>
                <option value="Approved" <c:if test="${param.status eq 'Approved'}">selected</c:if>>Approved</option>
                <option value="Rejected" <c:if test="${param.status eq 'Rejected'}">selected</c:if>>Rejected</option>
            </select>

            <!-- Ô tìm kiếm -->
            <input type="text" name="search" placeholder="Tìm kiếm theo tên CLB..."
                   value="${param.search != null ? param.search : ''}"/>

            <button type="submit">Lọc</button>
        </form>

        <!-- 📋 Danh sách CLB -->
        <table>
            <tr>
                <th>ID</th>
                <th>Tên CLB</th>
                <th>Mô tả</th>
                <th>Logo</th>
                <th>Thể loại  </th>
                <th>Thành lập bởi</th>
                <th>Trạng thái</th>
                <th>Thành lập ngày</th>
            </tr>

            <c:choose>
                <c:when test="${not empty clubs}">
                    <c:forEach var="c" items="${clubs}">
                        <tr>
                            <td>${c.clubId}</td>
                            <td>${c.name}</td>
                            <td>${c.description}</td>
                            <td>
                                <c:if test="${not empty c.logoUrl}">
                                    <img src="${c.logoUrl}" alt="logo"/>
                                </c:if>
                                <c:if test="${empty c.logoUrl}">
                                    <span style="color:#999;">Chưa có</span>
                                </c:if>
                            </td>
                            <td>${c.categoryName}</td>
                            <td>${c.createdByUserId}</td>
                            <td>${c.status}</td>
                            <td>${c.createdAt}</td>
                            
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="9" style="text-align:center; color:#999; font-style:italic;">
                            Không có CLB nào.
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </table>

        <a href="${pageContext.request.contextPath}/createClub" class="button">+ Tạo CLB mới</a>
    </div>

    <!-- ✅ Include footer -->
    <jsp:include page="../layout/footer.jsp" />

</body>
</html>
