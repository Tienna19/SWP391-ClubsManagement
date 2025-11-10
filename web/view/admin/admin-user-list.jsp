<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Danh sách người dùng - Admin</title>

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/assets.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/typography.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/shortcodes.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">

    <style>
        .role-chip {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
        }
        .role-admin { background: rgba(111,66,193,0.15); color: #6f42c1; }
        .role-leader { background: rgba(0,123,255,0.15); color: #0d6efd; }
        .role-member { background: rgba(40,167,69,0.18); color: #2b8a3e; }
        .role-user { background: rgba(108,117,125,0.15); color: #495057; }
    </style>
</head>
<body class="ttr-opened-sidebar ttr-pinned-sidebar admin-theme-loaded">
<%@ include file="/WEB-INF/jspf/admin-layout.jspf" %>

<main class="ttr-wrapper">
    <div class="container-fluid">
        <div class="db-breadcrumb">
            <h4 class="breadcrumb-title">Danh sách người dùng</h4>
            <ul class="db-breadcrumb-list">
                <li><a href="${pageContext.request.contextPath}/adminDashboard"><i class="fa fa-home"></i>Dashboard</a></li>
                <li>Người dùng</li>
                <li>Danh sách</li>
            </ul>
        </div>

        <div class="card shadow-sm">
            <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                <h5 class="mb-0"><i class="fa fa-users mr-2"></i>Tất cả người dùng</h5>
                <span>${fn:length(users)} người dùng</span>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="thead-light">
                            <tr>
                                <th>Tên đầy đủ</th>
                                <th>Email</th>
                                <th>Vai trò</th>
                                <th>Ngày tạo</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty users}">
                                    <tr>
                                        <td colspan="4" class="text-center py-4 text-muted">Chưa có người dùng nào.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${users}" var="user">
                                        <tr>
                                            <td>
                                                <strong>${user.fullName}</strong>
                                            </td>
                                            <td>${user.email}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${user.roleId == 4}"><span class="badge badge-primary">Admin</span></c:when>
                                                    <c:when test="${user.roleId == 3}"><span class="badge badge-info">Club Leader</span></c:when>
                                                    <c:when test="${user.roleId == 2}"><span class="badge badge-success">Member</span></c:when>
                                                    <c:otherwise><span class="badge badge-secondary">User</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:if test="${user.createdAt != null}">
                                                    <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</main>
<div class="ttr-overlay"></div>

<script src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/popper.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap-select/bootstrap-select.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/scroll/scrollbar.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/functions.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin.js"></script>
<script>
    (function () {
        function adjustSidebar() {
            if (window.innerWidth <= 1024) {
                document.body.classList.remove('ttr-opened-sidebar');
                document.body.classList.remove('ttr-pinned-sidebar');
            } else {
                document.body.classList.add('ttr-opened-sidebar');
                document.body.classList.add('ttr-pinned-sidebar');
            }
        }
        adjustSidebar();
        window.addEventListener('resize', adjustSidebar);
    })();
</script>
</body>
</html>
