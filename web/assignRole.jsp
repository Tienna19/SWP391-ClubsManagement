<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý vai trò thành viên</title>

    <c:set var="ctx" value="${pageContext.request.contextPath}"/>

    <!-- CSS -->
    <link rel="stylesheet" href="${ctx}/assets/css/assets.css">
    <link rel="stylesheet" href="${ctx}/assets/css/typography.css">
    <link rel="stylesheet" href="${ctx}/assets/css/shortcodes/shortcodes.css">
    <link rel="stylesheet" href="${ctx}/assets/css/style.css">
    <link rel="stylesheet" href="${ctx}/assets/css/dashboard.css">
    <link rel="stylesheet" href="${ctx}/assets/css/color/color-1.css">

    <style>
        .badge-role {
            border-radius: 12px;
            padding: 3px 10px;
            font-size: 11px;
            font-weight: 600;
        }
        .badge-status {
            border-radius: 12px;
            padding: 3px 10px;
            font-size: 11px;
            font-weight: 600;
        }
        .badge-status.active { background:#e8f5e9; color:#2e7d32; }
        .badge-status.inactive { background:#eeeeee; color:#757575; }

        .table td, .table th {
            vertical-align: middle !important;
        }
    </style>
</head>

<body class="ttr-opened-sidebar ttr-pinned-sidebar admin-theme-loaded">

<%@ include file="/WEB-INF/jspf/admin-layout.jspf" %>

<main class="ttr-wrapper">
    <div class="container-fluid">

        <!-- Breadcrumb -->
        <div class="db-breadcrumb">
            <h4 class="breadcrumb-title">Vai trò thành viên</h4>
            <ul class="db-breadcrumb-list">
                <li><a href="${ctx}/adminDashboard"><i class="fa fa-home"></i>Dashboard</a></li>
                <li>Người dùng</li>
                <li>Vai trò</li>
            </ul>
        </div>

        <!-- Alerts -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${error}
                <button type="button" class="close" data-dismiss="alert">
                    <span>&times;</span>
                </button>
            </div>
        </c:if>

        <c:if test="${not empty message}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${message}
                <button type="button" class="close" data-dismiss="alert">
                    <span>&times;</span>
                </button>
            </div>
        </c:if>

        <!-- Filter section -->
        <div class="card shadow-sm m-b30">
            <div class="card-body">
                <form action="${ctx}/AssignRoleNew" method="get" class="row g-3 align-items-end">

                    <!-- Select club -->
                    <div class="col-md-4">
                        <label class="form-label font-weight-bold">Chọn CLB</label>
                        <select class="form-control" name="clubId" onchange="this.form.submit()">
                            <option value="">-- Chọn CLB --</option>
                            <c:forEach var="c" items="${clubs}">
                                <option value="${c.clubId}"
                                        ${selectedClubId == c.clubId ? 'selected' : ''}>
                                    ${c.clubName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Search -->
                    <div class="col-md-4">
                        <label class="form-label">Tìm kiếm</label>
                        <input type="text"
                               name="keyword"
                               class="form-control"
                               placeholder="Tên hoặc Email"
                               value="${keyword}">
                    </div>

                    <!-- Filter role -->
                    <div class="col-md-3">
                        <label class="form-label">Lọc vai trò</label>
                        <select name="roleFilter" class="form-control">
                            <option value="">-- Tất cả --</option>
                            <c:forEach var="r" items="${clubRoles}">
                                <option value="${r}"
                                        ${roleFilter == r ? 'selected' : ''}>
                                    ${r}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Submit -->
                    <div class="col-md-1 text-right mt-4">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="fa fa-filter mr-1"></i>Lọc
                        </button>
                    </div>

                </form>
            </div>
        </div>

        <div class="row">

            <!-- LEFT COLUMN — Member list -->
            <div class="col-lg-7 col-md-12">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fa fa-users mr-2"></i>Danh sách thành viên</h5>
                    </div>

                    <div class="card-body p-0">

                        <c:choose>
                            <c:when test="${empty members}">
                                <div class="p-4 text-muted">Không có thành viên nào hoặc chưa chọn CLB.</div>
                            </c:when>

                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0">
                                        <thead class="thead-light">
                                        <tr>
                                            <th>ID</th>
                                            <th>Họ tên</th>
                                            <th>Email</th>
                                            <th>Vai trò CLB</th>
                                            <th>Status</th>
                                            <th class="text-right">Chọn</th>
                                        </tr>
                                        </thead>

                                        <tbody>
                                        <c:forEach var="m" items="${members}">
                                            <tr>
                                                <td>${m.membershipId}</td>
                                                <td>${m.fullName}</td>
                                                <td>${m.email}</td>

                                                <!-- ROLE BADGE -->
                                                <td>
                                                    <span class="badge-role" style="
                                                        background:#e3f2fd;
                                                        color:#0d47a1;">
                                                        ${m.roleInClub}
                                                    </span>
                                                </td>

                                                <!-- STATUS BADGE -->
                                                <td>
                                                    <c:set var="st" value="${fn:toLowerCase(m.membershipStatus)}" />
                                                    <span class="badge-status ${st}">
                                                        ${m.membershipStatus}
                                                    </span>
                                                </td>

                                                <td class="text-right">
                                                    <a class="btn btn-sm btn-outline-primary"
                                                       href="${ctx}/AssignRoleNew?clubId=${selectedClubId}&membershipId=${m.membershipId}">
                                                        Chỉnh sửa
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Pagination -->
                                <c:if test="${totalPages > 1}">
                                    <div class="card-footer">
                                        <nav>
                                            <ul class="pagination justify-content-end mb-0">

                                                <c:if test="${currentPage > 1}">
                                                    <li class="page-item">
                                                        <a class="page-link"
                                                           href="${ctx}/AssignRoleNew?clubId=${selectedClubId}&page=${currentPage - 1}&keyword=${keyword}&roleFilter=${roleFilter}">
                                                            Trước
                                                        </a>
                                                    </li>
                                                </c:if>

                                                <c:forEach begin="1" end="${totalPages}" var="i">
                                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                        <a class="page-link"
                                                           href="${ctx}/AssignRoleNew?clubId=${selectedClubId}&page=${i}&keyword=${keyword}&roleFilter=${roleFilter}">
                                                            ${i}
                                                        </a>
                                                    </li>
                                                </c:forEach>

                                                <c:if test="${currentPage < totalPages}">
                                                    <li class="page-item">
                                                        <a class="page-link"
                                                           href="${ctx}/AssignRoleNew?clubId=${selectedClubId}&page=${currentPage + 1}&keyword=${keyword}&roleFilter=${roleFilter}">
                                                            Sau
                                                        </a>
                                                    </li>
                                                </c:if>

                                            </ul>
                                        </nav>
                                    </div>
                                </c:if>

                            </c:otherwise>
                        </c:choose>

                    </div>
                </div>
            </div>

            <!-- RIGHT COLUMN — Edit form -->
            <div class="col-lg-5 col-md-12">
                <div class="card shadow-sm">
                    <div class="card-header bg-white">
                        <h5 class="mb-0">
                            <i class="fa fa-pencil mr-2"></i>Chỉnh sửa vai trò
                        </h5>
                    </div>

                    <div class="card-body">

                        <c:if test="${empty detail}">
                            <p class="text-muted">
                                <i>Chọn một thành viên ở bảng bên trái để chỉnh sửa vai trò.</i>
                            </p>
                        </c:if>

                        <c:if test="${not empty detail}">
                            <form method="post" action="${ctx}/AssignRoleNew">

                                <input type="hidden" name="membershipId" value="${detail.membershipId}"/>

                                <div class="form-group">
                                    <label>Thành viên:</label>
                                    <p><strong>${detail.fullName}</strong> <span class="text-muted">(${detail.email})</span></p>
                                </div>

                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label>Vai trò CLB hiện tại</label>
                                        <p><b>${detail.roleInClub}</b></p>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label>System Role hiện tại</label>
                                        <p><b>${detail.systemRoleId}</b></p>
                                    </div>
                                </div>

                                <!-- NEW ROLE -->
                                <div class="form-group">
                                    <label>Vai trò CLB mới</label>
                                    <select name="newClubRole" class="form-control">
                                        <c:forEach var="r" items="${clubRoles}">
                                            <option value="${r}"
                                                ${detail.roleInClub == r ? 'selected' : ''}>
                                                ${r}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <!-- Membership Status -->
                                <div class="form-group">
                                    <label>Membership Status</label>
                                    <select name="membershipStatus" class="form-control">
                                        <option value="Active"
                                            ${detail.membershipStatus == 'Active' ? 'selected' : ''}>
                                            Active
                                        </option>
                                        <option value="Inactive"
                                            ${detail.membershipStatus == 'Inactive' ? 'selected' : ''}>
                                            Inactive
                                        </option>
                                    </select>
                                </div>

                                <!-- System roles (Admin only) -->
                                <c:if test="${isAdmin}">
                                    <div class="form-group">
                                        <label>System Role</label>
                                        <select name="systemRoleId" class="form-control">
                                            <option value="">-- Giữ nguyên --</option>
                                            <c:forEach var="r" items="${systemRoles}">
                                                <option value="${r.roleId}"
                                                        ${detail.systemRoleId == r.roleId ? 'selected' : ''}>
                                                    ${r.roleName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="form-group">
                                        <label>User Status</label>
                                        <select name="systemStatus" class="form-control">
                                            <option value="Active"
                                                ${detail.systemStatus == 'Active' ? 'selected' : ''}>Active</option>
                                            <option value="Inactive"
                                                ${detail.systemStatus == 'Inactive' ? 'selected' : ''}>Inactive</option>
                                        </select>
                                    </div>
                                </c:if>

                                <div class="text-right">
                                    <button class="btn btn-primary">
                                        <i class="fa fa-save mr-1"></i> Lưu thay đổi
                                    </button>
                                </div>

                            </form>
                        </c:if>

                    </div>
                </div>
            </div>

        </div><!-- row -->

    </div>
</main>

<!-- JS -->
<script src="${ctx}/assets/js/jquery.min.js"></script>
<script src="${ctx}/assets/vendors/bootstrap/js/popper.min.js"></script>
<script src="${ctx}/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
<script src="${ctx}/assets/js/functions.js"></script>

</body>
</html>
