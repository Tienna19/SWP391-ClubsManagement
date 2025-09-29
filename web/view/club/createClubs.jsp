<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Tạo Câu Lạc Bộ Mới</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendors/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        body {
            background-color: #f7f6fb;
        }
        .form-container {
            background: #fff;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            max-width: 600px;
            margin: 40px auto;
        }
        h2 {
            text-align: center;
            color: #5B2C8E;
            font-weight: bold;
            margin-bottom: 25px;
        }
        label {
            font-weight: 500;
            margin-bottom: 6px;
        }
        .btn-primary {
            background-color: #5B2C8E;
            border: none;
        }
        .btn-primary:hover {
            background-color: #4a2476;
        }
        a.back-link {
            display: block;
            margin-top: 15px;
            text-align: center;
            color: #5B2C8E;
            text-decoration: none;
        }
        a.back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>

<body>

    <%@ include file="/view/layout/header.jsp" %>

    <div class="form-container">
        <h2>Tạo CLB Mới</h2>

        <!-- ⚙️ Form upload có enctype -->
        <form action="${pageContext.request.contextPath}/createClub" 
              method="post" enctype="multipart/form-data">

            <!-- Tên CLB -->
            <div class="mb-3">
                <label for="name" class="form-label">Tên CLB:</label>
                <input type="text" id="name" name="name" class="form-control" placeholder="Nhập tên CLB" required>
            </div>

            <!-- Mô tả -->
            <div class="mb-3">
                <label for="description" class="form-label">Mô tả:</label>
                <textarea id="description" name="description" rows="4" class="form-control" placeholder="Giới thiệu ngắn gọn về CLB"></textarea>
            </div>

            <!-- Logo -->
            <div class="mb-3">
                <label for="logo" class="form-label">Logo CLB:</label>
                <input type="file" id="logo" name="logo" class="form-control" accept="image/*" required>
            </div>

            <!-- Danh mục -->
            <div class="mb-3">
                <label for="categoryId" class="form-label">Danh mục:</label>
                <select id="categoryId" name="categoryId" class="form-select" required>
                    <option value="">-- Chọn danh mục --</option>
                    <c:forEach var="c" items="${categoryList}">
                        <option value="${c.id}">${c.name}</option>
                    </c:forEach>
                </select>
            </div>

            <!-- Mã sinh viên -->
            <div class="mb-3">
                <label for="createdByUserId" class="form-label">Mã sinh viên:</label>
                <input type="text" id="createdByUserId" name="createdByUserId" class="form-control" placeholder="Nhập mã sinh viên của bạn" required>
            </div>

            <!-- Nút submit -->
            <div class="text-center">
                <button type="submit" class="btn btn-primary px-5">Tạo CLB</button>
            </div>
        </form>

        <a href="${pageContext.request.contextPath}/viewAllClubs" class="back-link">⬅ Quay lại danh sách CLB</a>
    </div>

    <%@ include file="/view/layout/footer.jsp" %>

    <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
