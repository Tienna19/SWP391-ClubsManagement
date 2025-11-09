<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <!-- META ============================================= -->
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <!-- FAVICONS ICON ============================================= -->
    <link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" type="image/x-icon" />
    
    <!-- PAGE TITLE ============================================= -->
    <title>Danh sách Câu Lạc Bộ - Student Club Management</title>
    
    <!-- All PLUGINS CSS ============================================= -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/assets.css">
    
    <!-- TYPOGRAPHY ============================================= -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/typography.css">
    
    <!-- SHORTCODES ============================================= -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/shortcodes.css">
    
    <!-- STYLESHEETS ============================================= -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">
    
    <style>
        :root {
            --primary-color: #5E35B1;
            --primary-dark: #4527A0;
            --accent-color: #f8b500;
            --card-shadow: 0 18px 35px rgba(80, 63, 205, 0.08);
        }
        .page-banner {
            position: relative;
            padding: 90px 0;
            background-position: center;
            background-size: cover;
            overflow: hidden;
        }
        .page-banner::before {
            content: "";
            position: absolute;
            inset: 0;
            background: linear-gradient(120deg, rgba(94,53,177,0.85) 0%, rgba(69,39,160,0.9) 50%, rgba(63,81,181,0.85) 100%);
        }
        .page-banner-entry {
            position: relative;
            z-index: 1;
        }
        .btn-create {
            background: var(--accent-color);
            border: none;
            color: #1f1b2d;
            font-weight: 600;
            border-radius: 50px;
            padding: 12px 26px;
            box-shadow: 0 10px 20px rgba(248, 181, 0, 0.35);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .btn-create:hover {
            transform: translateY(-2px);
            box-shadow: 0 16px 32px rgba(248, 181, 0, 0.45);
        }
        .filter-card {
            background: #fff;
            border-radius: 18px;
            padding: 24px;
            box-shadow: var(--card-shadow);
            margin-bottom: 22px;
            position: sticky;
            top: 110px;
        }
        .filter-card h5 {
            text-transform: uppercase;
            font-size: 14px;
            letter-spacing: 1.5px;
            color: #673ab7;
            margin-bottom: 18px;
        }
        .search-pill {
            border: 1px solid rgba(94, 53, 177, 0.15);
            border-radius: 50px;
            padding: 10px 14px;
            display: flex;
            align-items: center;
            gap: 10px;
            box-shadow: inset 0 1px 3px rgba(94, 53, 177, 0.05);
            transition: box-shadow 0.2s ease;
        }
        .search-pill:focus-within {
            box-shadow: 0 10px 25px rgba(94, 53, 177, 0.18);
        }
        .search-pill input {
            border: none;
            outline: none;
            width: 100%;
        }
        .search-pill button {
            background: var(--primary-color);
            border: none;
            color: #fff;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: transform 0.2s ease;
        }
        .search-pill button:hover {
            transform: rotate(-8deg);
        }
        .filter-list {
            list-style: none;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .filter-list li a {
            display: block;
            padding: 10px 14px;
            border-radius: 12px;
            color: #57607a;
            font-weight: 500;
            transition: all 0.2s ease;
        }
        .filter-list li.active a,
        .filter-list li a:hover {
            background: rgba(94,53,177,0.12);
            color: var(--primary-dark);
        }
        .quick-links a {
            border-radius: 14px;
            padding: 12px 18px;
            font-weight: 600;
            box-shadow: var(--card-shadow);
            transition: transform 0.2s ease;
        }
        .quick-links a:hover {
            transform: translateY(-2px);
        }
        .club-card {
            background: #fff;
            border-radius: 20px;
            box-shadow: var(--card-shadow);
            overflow: hidden;
            height: 100%;
            display: flex;
            flex-direction: column;
            transition: transform 0.25s ease, box-shadow 0.25s ease;
        }
        .club-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 20px 45px rgba(80, 63, 205, 0.18);
        }
        .club-card .action-box {
            border-radius: 20px 20px 0 0;
            overflow: hidden;
        }
        .club-card img {
            height: 180px;
            width: 100%;
            object-fit: cover;
        }
        .club-card .badge-status {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
        }
        .badge-success-light {
            background: rgba(56, 142, 60, 0.12);
            color: #388E3C;
        }
        .badge-secondary-light {
            background: rgba(117, 117, 117, 0.12);
            color: #616161;
        }
        .club-card .info-bx {
            padding: 20px 22px 0;
        }
        .club-card .info-bx h5 {
            font-weight: 700;
            color: #2b2350;
        }
        .club-card .info-bx span {
            font-size: 13px;
            color: #6f7896;
        }
        .club-card .meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 18px 22px 0;
            font-size: 13px;
            color: #8289a1;
        }
        .club-card .description {
            padding: 14px 22px 20px;
            flex: 1;
            color: #555c75;
        }
        .club-card .actions {
            padding: 18px 22px 22px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
        }
        .club-card .btn-outline-primary {
            border-radius: 50px;
            padding: 8px 16px;
        }
        .club-card .btn-sm {
            border-radius: 50px;
            padding: 8px 18px;
        }
        .active-filters {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 12px;
        }
        .filter-chip {
            background: rgba(94,53,177,0.12);
            color: var(--primary-dark);
            padding: 6px 12px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .empty-state {
            background: rgba(94,53,177,0.05);
            border-radius: 18px;
            padding: 50px 30px;
            box-shadow: inset 0 0 0 1px rgba(94,53,177,0.08);
        }
        @media (max-width: 991px) {
            .page-banner {
                padding: 70px 0;
            }
            .filter-card {
                position: static;
                margin-bottom: 30px;
            }
        }
    </style>
</head>
<body id="bg">
<div class="page-wraper">
<div id="loading-icon-bx"></div>

    <%@ include file="../layout/header.jsp" %>

    <!-- Content -->
    <div class="page-content bg-white">
        <div class="page-banner ovbl-dark" style="background-image:url(${pageContext.request.contextPath}/assets/images/banner/banner3.jpg);">
            <div class="container">
                <div class="page-banner-entry d-flex align-items-center justify-content-between flex-wrap">
                    <div>
                        <h1 class="text-white">Danh sách Câu Lạc Bộ</h1>
                        <p class="text-white-50 mb-0">Quản lí và khám phá cộng đồng StuClubManagement</p>
                    </div>
                    <c:if test="${not empty sessionScope.userId}">
                        <a href="${pageContext.request.contextPath}/createClub" class="btn btn-create">
                            <i class="fa fa-plus-circle mr-2"></i>Tạo CLB mới
                        </a>
                    </c:if>
                </div>
            </div>
        </div>

        <div class="breadcrumb-row">
            <div class="container">
                <ul class="list-inline">
                    <li><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                    <li>Danh sách CLB</li>
                </ul>
            </div>
        </div>

        <div class="content-block">
            <div class="section-area section-sp2">
                <div class="container">
                    <div class="row">
                        <!-- Filter Sidebar -->
                        <div class="col-lg-3 col-md-4 col-sm-12 m-b30">
                            <div class="filter-card">
                                <form action="${pageContext.request.contextPath}/viewAllClubs" method="GET">
                                    <div class="form-group m-b20">
                                        <h5>Tìm kiếm CLB</h5>
                                        <div class="search-pill">
                                            <input name="search" type="text" value="${param.search}" placeholder="Nhập tên câu lạc bộ...">
                                            <button type="submit"><i class="fa fa-search"></i></button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                            <div class="filter-card">
                                <h5>Thể loại CLB</h5>
                                <ul class="filter-list">
                                    <li class="${empty param.category ? 'active' : ''}">
                                        <a href="${pageContext.request.contextPath}/viewAllClubs${empty param.search && empty param.status ? '' : '?'}${empty param.search ? '' : 'search='}${param.search}${empty param.status ? '' : (empty param.search ? '' : '&')}${empty param.status ? '' : 'status='}${param.status}">
                                            <i class="fa fa-circle mr-2 text-muted small"></i>Tất cả
                                        </a>
                                    </li>
                                    <c:forEach items="${categories}" var="cat">
                                        <li class="${param.category == cat.id ? 'active' : ''}">
                                            <a href="${pageContext.request.contextPath}/viewAllClubs?category=${cat.id}${empty param.search ? '' : '&search='}${param.search}${empty param.status ? '' : '&status='}${param.status}">
                                                <i class="fa fa-circle mr-2 text-muted small"></i>${cat.name}
                                            </a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                            <div class="filter-card">
                                <h5>Trạng thái</h5>
                                <ul class="filter-list">
                                    <li class="${empty param.status ? 'active' : ''}">
                                        <a href="${pageContext.request.contextPath}/viewAllClubs${empty param.search && empty param.category ? '' : '?'}${empty param.search ? '' : 'search='}${param.search}${empty param.category ? '' : (empty param.search ? '' : '&')}${empty param.category ? '' : 'category='}${param.category}">
                                            <i class="fa fa-circle mr-2 text-muted small"></i>Tất cả
                                        </a>
                                    </li>
                                    <li class="${param.status == 'Active' ? 'active' : ''}">
                                        <a href="${pageContext.request.contextPath}/viewAllClubs?status=Active${empty param.search ? '' : '&search='}${param.search}${empty param.category ? '' : '&category='}${param.category}">
                                            <i class="fa fa-circle mr-2 text-success small"></i>Hoạt động
                                        </a>
                                    </li>
                                    <li class="${param.status == 'Inactive' ? 'active' : ''}">
                                        <a href="${pageContext.request.contextPath}/viewAllClubs?status=Inactive${empty param.search ? '' : '&search='}${param.search}${empty param.category ? '' : '&category='}${param.category}">
                                            <i class="fa fa-circle mr-2 text-muted small"></i>Tạm ngưng
                                        </a>
                                    </li>
                                </ul>
                            </div>
                            <div class="filter-card quick-links">
                                <div class="d-flex flex-column gap-3">
                                    <a href="${pageContext.request.contextPath}/viewAllEvents" class="btn btn-block text-white" style="background: var(--primary-dark);">
                                        <i class="fa fa-calendar mr-2"></i>Xem sự kiện
                                    </a>
                                    <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-primary btn-block">
                                        <i class="fa fa-home mr-2"></i>Về trang chủ
                                    </a>
                                </div>
                            </div>
                        </div>
                        <!-- /Filter Sidebar -->

                        <!-- Club Grid -->
                        <div class="col-lg-9 col-md-8 col-sm-12">
                            <c:set var="selectedCategoryName" value="" />
                            <c:if test="${not empty param.category}">
                                <c:forEach items="${categories}" var="cat">
                                    <c:if test="${param.category == cat.id}">
                                        <c:set var="selectedCategoryName" value="${cat.name}" />
                                    </c:if>
                                </c:forEach>
                            </c:if>
                            <div class="d-flex justify-content-between align-items-center flex-wrap m-b30">
                                <div>
                                    <h4 class="m-b0">Có ${totalClubs} câu lạc bộ phù hợp</h4>
                                    <span class="text-muted">
                                        <c:choose>
                                            <c:when test="${empty param.search && empty param.category && empty param.status}">
                                                Tất cả CLB trong hệ thống
                                            </c:when>
                                            <c:otherwise>
                                                Kết quả theo bộ lọc hiện tại
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                    <div class="active-filters">
                                        <c:if test="${not empty param.search}">
                                            <span class="filter-chip"><i class="fa fa-search"></i>Từ khóa: "${param.search}"</span>
                                        </c:if>
                                        <c:if test="${not empty selectedCategoryName}">
                                            <span class="filter-chip"><i class="fa fa-folder-open"></i>Thể loại: ${selectedCategoryName}</span>
                                        </c:if>
                                        <c:if test="${not empty param.status}">
                                            <span class="filter-chip"><i class="fa fa-check-circle"></i>Trạng thái: ${param.status == 'Active' ? 'Hoạt động' : 'Tạm ngưng'}</span>
                                        </c:if>
                                    </div>
                                </div>
                                <c:if test="${not empty param.search || not empty param.category || not empty param.status}">
                                    <a href="${pageContext.request.contextPath}/viewAllClubs" class="btn btn-light">
                                        <i class="fa fa-undo mr-1"></i>Đặt lại bộ lọc
                                    </a>
                                </c:if>
                            </div>

                            <div class="row">
                                <c:choose>
                                    <c:when test="${not empty clubs}">
                                        <c:forEach items="${clubs}" var="club" varStatus="loop">
                                            <div class="col-md-6 col-lg-4 col-sm-6 m-b30">
                                                <div class="club-card">
                                                    <c:set var="logoSrc" value="" />
                                                    <c:if test="${not empty club.logo}">
                                                        <c:choose>
                                                            <c:when test="${fn:startsWith(club.logo, 'http')}">
                                                                <c:set var="logoSrc" value="${club.logo}" />
                                                            </c:when>
                                                            <c:when test="${fn:startsWith(club.logo, '/')}">
                                                                <c:set var="logoSrc" value="${pageContext.request.contextPath}${club.logo}" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:set var="logoSrc" value="${pageContext.request.contextPath}/${club.logo}" />
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:if>
                                                    <c:if test="${empty logoSrc}">
                                                        <c:set var="logoSrc" value="${pageContext.request.contextPath}/assets/images/courses/pic1.jpg" />
                                                    </c:if>
                                                    <div class="action-box">
                                                        <img src="${logoSrc}" alt="${club.clubName}" loading="lazy">
                                                    </div>
                                                    <div class="info-bx">
                                                        <div class="d-flex justify-content-between align-items-start">
                                                            <div>
                                                                <h5><a href="${pageContext.request.contextPath}/clubDetail?clubId=${club.clubId}">${club.clubName}</a></h5>
                                                                <span><i class="fa fa-tag mr-1"></i>${club.clubTypes != null ? club.clubTypes : 'Đang cập nhật'}</span>
                                                            </div>
                                                            <span class="badge-status ${club.status == 'Active' ? 'badge-success-light' : 'badge-secondary-light'}">
                                                                <i class="fa ${club.status == 'Active' ? 'fa-check-circle' : 'fa-clock-o'}"></i>
                                                                ${club.status == null ? 'Đang cập nhật' : (club.status == 'Active' ? 'Hoạt động' : 'Tạm ngưng')}
                                                            </span>
                                                        </div>
                                                    </div>
                                                    <div class="meta">
                                                        <span><i class="fa fa-calendar mr-1"></i>${club.createdAt != null ? club.createdAt : 'N/A'}</span>
                                                        <span><i class="fa fa-hashtag mr-1"></i>CLB #${club.clubId}</span>
                                                    </div>
                                                    <div class="description">
                                                        <c:choose>
                                                            <c:when test="${not empty club.description}">
                                                                ${club.description.length() > 130 ? club.description.substring(0, 130).concat('...') : club.description}
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">CLB chưa cập nhật mô tả chi tiết.</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div class="actions">
                                                        <a href="${pageContext.request.contextPath}/clubDetail?clubId=${club.clubId}" class="btn btn-sm text-white" style="background: var(--primary-color);">Chi tiết</a>
                                                        <c:if test="${club.status == 'Active'}">
                                                            <a href="${pageContext.request.contextPath}/joinClub?clubId=${club.clubId}" class="btn btn-sm btn-outline-primary">
                                                                <i class="fa fa-user-plus mr-1"></i>Tham gia
                                                            </a>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="col-12">
                                            <div class="empty-state text-center">
                                                <i class="fa fa-search fa-3x text-muted mb-3"></i>
                                                <h5>Không tìm thấy câu lạc bộ phù hợp</h5>
                                                <p class="text-muted m-b20">Hãy thử thay đổi từ khóa hoặc chọn bộ lọc khác.</p>
                                                <a href="${pageContext.request.contextPath}/viewAllClubs" class="btn button-md">Đặt lại bộ lọc</a>
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
                        <!-- /Club Grid -->
                    </div>
                </div>
            </div>
        </div>
        <!-- Content END -->
    </div>

    <%@ include file="../layout/footer.jsp" %>
    <button class="back-to-top fa fa-chevron-up" ></button>
</div>

<!-- External JavaScripts -->
<script src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/popper.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap-select/bootstrap-select.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/magnific-popup/magnific-popup.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/counter/waypoints-min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/counter/counterup.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/imagesloaded/imagesloaded.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/masonry/masonry.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/masonry/filter.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/owl-carousel/owl.carousel.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/functions.js"></script>
</body>
</html>

