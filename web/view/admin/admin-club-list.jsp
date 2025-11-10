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
    <title>Quản lý CLB - Admin</title>

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/assets.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/typography.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/shortcodes.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">

    <style>
        .filter-panel .form-control { border-radius: 12px; }
        .filter-panel .btn { border-radius: 12px; }
        .club-admin-card {
            background: #ffffff;
            border-radius: 18px;
            box-shadow: 0 14px 32px rgba(94,53,177,0.08);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            height: 100%;
            transition: transform .2s ease, box-shadow .2s ease;
        }
        .club-admin-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 20px 45px rgba(94,53,177,0.18);
        }
        .club-admin-card img {
            width: 100%;
            height: 170px;
            object-fit: cover;
        }
        .club-admin-card .card-body { padding: 18px 20px 0; }
        .club-admin-card .card-footer { padding: 16px 20px 20px; background: transparent; border-top: none; }
        .status-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
        }
        .status-active { background: rgba(56, 142, 60, 0.12); color: #388E3C; }
        .status-inactive { background: rgba(117, 117, 117, 0.12); color: #616161; }
    </style>
</head>
<body class="ttr-opened-sidebar ttr-pinned-sidebar admin-theme-loaded">
<%@ include file="/WEB-INF/jspf/admin-layout.jspf" %>

<main class="ttr-wrapper">
    <div class="container-fluid">
        <div class="db-breadcrumb">
            <h4 class="breadcrumb-title">Danh sách Câu lạc bộ</h4>
            <ul class="db-breadcrumb-list">
                <li><a href="${pageContext.request.contextPath}/adminDashboard"><i class="fa fa-home"></i>Dashboard</a></li>
                <li>Quản lý CLB</li>
                <li>Danh sách</li>
            </ul>
        </div>

        <div class="row m-b30">
            <div class="col-12">
                <div class="card filter-panel shadow-sm">
                    <div class="card-body">
                        <form class="row align-items-end g-3" action="${pageContext.request.contextPath}/admin-club-list" method="get">
                            <div class="col-md-4">
                                <label class="form-label">Tìm kiếm</label>
                                <input type="text" name="search" class="form-control" value="${param.search}" placeholder="Nhập tên CLB">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Thể loại</label>
                                <select name="category" class="form-control">
                                    <option value="">Tất cả</option>
                                    <c:forEach items="${categories}" var="cat">
                                        <option value="${cat.id}"<c:if test="${param.category eq cat.id}"> selected="selected"</c:if>>${cat.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Trạng thái</label>
                                <select name="status" class="form-control">
                                    <option value="">Tất cả</option>
                                    <option value="Active"<c:if test="${param.status eq 'Active'}"> selected="selected"</c:if>>Hoạt động</option>
                                    <option value="Inactive"<c:if test="${param.status eq 'Inactive'}"> selected="selected"</c:if>>Tạm ngưng</option>
                                </select>
                            </div>
                            <div class="col-md-2 text-end">
                                <button type="submit" class="btn btn-primary w-100"><i class="fa fa-search me-2"></i>Lọc</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <div class="row m-b20">
            <div class="col-md-3">
                <div class="widget-card widget-bg1">
                    <div class="wc-item">
                        <h4 class="wc-title">Tổng CLB</h4>
                        <span class="wc-stats">${totalClubs}</span>
                        <span class="wc-des">CLB được tìm thấy</span>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="widget-card widget-bg2">
                    <div class="wc-item">
                        <h4 class="wc-title">Hoạt động</h4>
                        <span class="wc-stats">${activeClubs}</span>
                        <span class="wc-des">CLB đang hoạt động</span>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="widget-card widget-bg3">
                    <div class="wc-item">
                        <h4 class="wc-title">Tạm ngưng</h4>
                        <span class="wc-stats">${inactiveClubs}</span>
                        <span class="wc-des">CLB đang tạm ngưng</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <c:choose>
                <c:when test="${not empty clubs}">
                    <c:forEach items="${clubs}" var="club">
                        <div class="col-xl-4 col-lg-6 col-md-6">
                            <div class="club-admin-card">
                                <c:set var="logoSrc" value="${club.logo}" />
                                <c:choose>
                                    <c:when test="${empty logoSrc}">
                                        <c:set var="logoSrc" value="${pageContext.request.contextPath}/assets/images/courses/pic1.jpg" />
                                    </c:when>
                                    <c:when test="${not empty logoSrc && fn:startsWith(logoSrc, 'http')}">
                                        <!-- keep as is -->
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="logoSrc" value="${pageContext.request.contextPath}${logoSrc}" />
                                    </c:otherwise>
                                </c:choose>
                                <img src="${logoSrc}" alt="${club.clubName}">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div>
                                            <h5 class="mb-1"><a href="${pageContext.request.contextPath}/clubDetail?clubId=${club.clubId}">${club.clubName}</a></h5>
                                            <small class="text-muted"><i class="fa fa-tag me-1"></i>${club.clubTypes != null ? club.clubTypes : 'Đang cập nhật'}</small>
                                        </div>
                                        <span class="status-pill ${club.status == 'Active' ? 'status-active' : 'status-inactive'}">
                                            <i class="fa ${club.status == 'Active' ? 'fa-check-circle' : 'fa-clock-o'}"></i>
                                            ${club.status == null ? 'Đang cập nhật' : (club.status == 'Active' ? 'Hoạt động' : 'Tạm ngưng')}
                                        </span>
                                    </div>
                                    <p class="text-muted mt-3 mb-0" style="min-height:70px;">
                                        <c:choose>
                                            <c:when test="${not empty club.description}">
                                                ${club.description.length() > 140 ? club.description.substring(0, 140).concat('...') : club.description}
                                            </c:when>
                                            <c:otherwise>
                                                CLB chưa cập nhật mô tả chi tiết.
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                                <div class="card-footer d-flex justify-content-between align-items-center">
                                    <span class="text-muted small"><i class="fa fa-calendar me-1"></i>${club.createdAt != null ? club.createdAt : 'N/A'}</span>
                                    <div class="btn-group">
                                        <a href="${pageContext.request.contextPath}/clubDetail?clubId=${club.clubId}" class="btn btn-primary btn-sm">Chi tiết</a>
                                        <c:if test="${club.status == 'Active'}">
                                            <a href="${pageContext.request.contextPath}/joinClub?clubId=${club.clubId}" class="btn btn-outline-primary btn-sm">Tham gia</a>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-12">
                        <div class="alert alert-info text-center py-5">
                            <i class="fa fa-info-circle fa-3x mb-3"></i>
                            <h5>Không tìm thấy câu lạc bộ phù hợp</h5>
                            <p class="mb-3">Hãy thử thay đổi bộ lọc tìm kiếm.</p>
                            <a href="${pageContext.request.contextPath}/admin-club-list" class="btn btn-light">
                                        <i class="fa fa-undo mr-1"></i>Đặt lại bộ lọc
                                    </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <c:if test="${totalPages > 1}">
            <div class="pagination-bx rounded-sm gray clearfix">
                <ul class="pagination">
                    <c:if test="${currentPage > 1}">
                        <li class="previous"><a href="?page=${currentPage - 1}&search=${param.search}&category=${param.category}&status=${param.status}"><i class="ti-arrow-left"></i> Trước</a></li>
                    </c:if>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${currentPage eq i}">
                                <li class="active"><a href="javascript:;">${i}</a></li>
                            </c:when>
                            <c:otherwise>
                                <li><a href="?page=${i}&search=${param.search}&category=${param.category}&status=${param.status}">${i}</a></li>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    <c:if test="${currentPage < totalPages}">
                        <li class="next"><a href="?page=${currentPage + 1}&search=${param.search}&category=${param.category}&status=${param.status}">Sau <i class="ti-arrow-right"></i></a></li>
                    </c:if>
                </ul>
            </div>
        </c:if>
    </div>
</main>
<div class="ttr-overlay"></div>

<script src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/popper.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap-select/bootstrap-select.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/scroll/scrollbar.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/owl-carousel/owl.carousel.js"></script>
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
