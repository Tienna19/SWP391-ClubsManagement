<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    
</head>
<body class="ttr-opened-sidebar ttr-pinned-sidebar">
    
    <!-- Header start -->
    <jsp:include page="../layout/header.jsp"/>
    <!-- Header end -->
    
    <!-- Left sidebar menu start -->
    <div class="ttr-sidebar">
        <div class="ttr-sidebar-wrapper content-scroll">
            <!-- side menu logo start -->
            <div class="ttr-sidebar-logo">
                <a href="${pageContext.request.contextPath}/home">
                    <img alt="" src="${pageContext.request.contextPath}/assets/images/logo.png" width="122" height="27">
                </a>
                <div class="ttr-sidebar-toggle-button">
                    <i class="ti-arrow-left"></i>
                </div>
            </div>
            <!-- side menu logo end -->
            <!-- sidebar menu start -->
            <nav class="ttr-sidebar-navi">
                <ul>
                    <li>
                        <a href="${pageContext.request.contextPath}/home" class="ttr-material-button">
                            <span class="ttr-icon"><i class="ti-home"></i></span>
                            <span class="ttr-label">Trang chủ</span>
                        </a>
                    </li>
                    <li class="show">
                        <a href="${pageContext.request.contextPath}/viewAllClubs" class="ttr-material-button">
                            <span class="ttr-icon"><i class="ti-layout-list-post"></i></span>
                            <span class="ttr-label">Danh sách CLB</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/listEvents" class="ttr-material-button">
                            <span class="ttr-icon"><i class="ti-calendar"></i></span>
                            <span class="ttr-label">Sự kiện</span>
                        </a>
                    </li>
                    <c:if test="${sessionScope.roleId == 1 || sessionScope.roleId == 2}">
                    <li>
                        <a href="${pageContext.request.contextPath}/createClub" class="ttr-material-button">
                            <span class="ttr-icon"><i class="ti-plus"></i></span>
                            <span class="ttr-label">Tạo CLB mới</span>
                        </a>
                    </li>
                    </c:if>
                    <li class="ttr-seperate"></li>
                </ul>
            </nav>
            <!-- sidebar menu end -->
        </div>
    </div>
    <!-- Left sidebar menu end -->

    <!--Main container start -->
    <main class="ttr-wrapper">
        <div class="container-fluid">
            <div class="db-breadcrumb">
                <h4 class="breadcrumb-title">Danh sách Câu Lạc Bộ</h4>
                <ul class="db-breadcrumb-list">
                    <li><a href="${pageContext.request.contextPath}/home"><i class="fa fa-home"></i>Trang chủ</a></li>
                    <li>Danh sách CLB</li>
                </ul>
                <!-- Add New Club Button (for logged-in users) -->
                <c:if test="${not empty sessionScope.userId}">
                    <div style="position: absolute; right: 30px; top: 50%; transform: translateY(-50%);">
                        <a href="${pageContext.request.contextPath}/createClub" 
                           class="btn btn-primary" 
                           style="padding: 8px 20px; border-radius: 4px; text-decoration: none; display: inline-flex; align-items: center; gap: 8px;">
                            <i class="fa fa-plus-circle"></i>
                            <span>Tạo CLB mới</span>
                        </a>
                    </div>
                </c:if>
            </div>    
            
            <!-- Filters -->
            <div class="row">
                <div class="col-lg-12 m-b30">
                    <div class="widget-box">
                        <div class="wc-title">
                            <h4>Bộ lọc tìm kiếm</h4>
                        </div>
                        <div class="widget-inner">
                            <form action="${pageContext.request.contextPath}/viewAllClubs" method="GET" class="edit-profile">
                                <div class="row">
                                    <div class="col-12 col-sm-4 m-b30">
                                        <div class="form-group">
                                            <label class="col-form-label">Tìm kiếm</label>
                                            <div>
                                                <input class="form-control" type="text" name="search" 
                                                       value="${param.search}" placeholder="Nhập tên CLB...">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-3 m-b30">
                                        <div class="form-group">
                                            <label class="col-form-label">Loại CLB</label>
                                            <div>
                                                <select class="form-control" name="category">
                                                    <option value="">Tất cả</option>
                                                    <c:forEach items="${categories}" var="cat">
                                                        <option value="${cat.id}" 
                                                                ${param.category == cat.id ? 'selected' : ''}>
                                                            ${cat.name}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-3 m-b30">
                                        <div class="form-group">
                                            <label class="col-form-label">Trạng thái</label>
                                            <div>
                                                <select class="form-control" name="status">
                                                    <option value="">Tất cả</option>
                                                    <option value="Active" ${param.status == 'Active' ? 'selected' : ''}>Active</option>
                                                    <option value="Inactive" ${param.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-2 m-b30">
                                        <div class="form-group">
                                            <label class="col-form-label">&nbsp;</label>
                                            <div>
                                                <button type="submit" class="btn btn-primary btn-block">
                                                    <i class="fa fa-search"></i> Tìm kiếm
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Clubs List -->
            <div class="row">
                <div class="col-lg-12 m-b30">
                    <div class="widget-box">
                        <div class="wc-title">
                            <h4>Kết quả: ${totalClubs} CLB</h4>
                        </div>
                        <div class="widget-inner">
                            
                            <c:if test="${not empty clubs}">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th width="60">Logo</th>
                                                <th>Tên CLB</th>
                                                <th>Loại</th>
                                                <th>Mô tả</th>
                                                <th width="100">Trạng thái</th>
                                                <th width="150">Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${clubs}" var="club">
                                                <tr>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty club.logo}">
                                                                <img src="${pageContext.request.contextPath}/${club.logo}" 
                                                                     alt="${club.clubName}" width="50" height="50" 
                                                                     class="rounded">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="d-flex align-items-center justify-content-center bg-light rounded" 
                                                                     style="width: 50px; height: 50px;">
                                                                    <i class="fa fa-users fa-2x text-muted"></i>
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <strong>${club.clubName}</strong>
                                                        <br>
                                                        <small class="text-muted">
                                                            <i class="fa fa-calendar"></i> ${club.createdAt}
                                                        </small>
                                                    </td>
                                                    <td>
                                                        <span class="badge badge-info">${club.clubTypes}</span>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty club.description}">
                                                                ${club.description.length() > 100 ? 
                                                                  club.description.substring(0, 100).concat('...') : 
                                                                  club.description}
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">Chưa có mô tả</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${club.status == 'Active'}">
                                                                <span class="badge badge-success">Active</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge badge-secondary">Inactive</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/clubDetail?clubId=${club.clubId}" 
                                                           class="btn btn-primary btn-sm" title="Xem chi tiết">
                                                            <i class="fa fa-eye"></i>
                                                        </a>
                                                        
                                                        <c:if test="${sessionScope.roleId == 1 || sessionScope.roleId == 2}">
                                                            <a href="${pageContext.request.contextPath}/updateClub?clubId=${club.clubId}" 
                                                               class="btn btn-warning btn-sm" title="Chỉnh sửa">
                                                                <i class="fa fa-edit"></i>
                                                            </a>
                                                        </c:if>
                                                        
                                                        <c:if test="${club.status == 'Active'}">
                                                            <a href="${pageContext.request.contextPath}/joinClub?clubId=${club.clubId}" 
                                                               class="btn btn-success btn-sm" title="Tham gia">
                                                                <i class="fa fa-user-plus"></i>
                                                            </a>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                                
                                <!-- Pagination -->
                                <c:if test="${totalPages > 1}">
                                    <div class="pagination-bx text-center m-t30">
                                        <ul class="pagination">
                                            <c:if test="${currentPage > 1}">
                                                <li class="page-item">
                                                    <a href="?page=${currentPage - 1}&search=${param.search}&category=${param.category}&status=${param.status}" 
                                                       class="page-link">
                                                        <i class="ti-arrow-left"></i> Trước
                                                    </a>
                                                </li>
                                            </c:if>
                                            
                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                <c:choose>
                                                    <c:when test="${currentPage eq i}">
                                                        <li class="page-item active">
                                                            <span class="page-link">${i}</span>
                                                        </li>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <li class="page-item">
                                                            <a href="?page=${i}&search=${param.search}&category=${param.category}&status=${param.status}" 
                                                               class="page-link">${i}</a>
                                                        </li>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                            
                                            <c:if test="${currentPage < totalPages}">
                                                <li class="page-item">
                                                    <a href="?page=${currentPage + 1}&search=${param.search}&category=${param.category}&status=${param.status}" 
                                                       class="page-link">
                                                        Sau <i class="ti-arrow-right"></i>
                                                    </a>
                                                </li>
                                            </c:if>
                                        </ul>
                                    </div>
                                </c:if>
                            </c:if>
                            
                            <c:if test="${empty clubs}">
                                <div class="text-center p-5">
                                    <i class="fa fa-search fa-3x text-muted mb-3"></i>
                                    <p class="text-muted">Không tìm thấy CLB nào phù hợp</p>
                                    <a href="${pageContext.request.contextPath}/viewAllClubs" class="btn btn-primary">
                                        Xem tất cả CLB
                                    </a>
                                </div>
                            </c:if>
                            
                        </div>
                    </div>
                </div>
            </div>
            
        </div>
    </main>
    <div class="ttr-overlay"></div>

    <!-- External JavaScripts -->
    <script src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/popper.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap-select/bootstrap-select.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/scroll/scrollbar.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/functions.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/admin.js"></script>
</body>
</html>

