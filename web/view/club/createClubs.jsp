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
    <title>Tạo CLB mới - Student Club Management</title>
    
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
            <div class="ttr-sidebar-logo">
                <a href="${pageContext.request.contextPath}/home">
                    <img alt="" src="${pageContext.request.contextPath}/assets/images/logo.png" width="122" height="27">
                </a>
                <div class="ttr-sidebar-toggle-button">
                    <i class="ti-arrow-left"></i>
                </div>
            </div>
            <nav class="ttr-sidebar-navi">
                <ul>
                    <li>
                        <a href="${pageContext.request.contextPath}/home" class="ttr-material-button">
                            <span class="ttr-icon"><i class="ti-home"></i></span>
                            <span class="ttr-label">Trang chủ</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/viewAllClubs" class="ttr-material-button">
                            <span class="ttr-icon"><i class="ti-layout-list-post"></i></span>
                            <span class="ttr-label">Danh sách CLB</span>
                        </a>
                    </li>
                    <li class="show">
                        <a href="${pageContext.request.contextPath}/createClub" class="ttr-material-button">
                            <span class="ttr-icon"><i class="ti-plus"></i></span>
                            <span class="ttr-label">Tạo CLB mới</span>
                        </a>
                    </li>
                    <li class="ttr-seperate"></li>
                </ul>
            </nav>
        </div>
    </div>
    <!-- Left sidebar menu end -->

    <!--Main container start -->
    <main class="ttr-wrapper">
        <div class="container-fluid">
            <div class="db-breadcrumb">
                <h4 class="breadcrumb-title">Tạo Câu Lạc Bộ mới</h4>
                <ul class="db-breadcrumb-list">
                    <li><a href="${pageContext.request.contextPath}/home"><i class="fa fa-home"></i>Trang chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/viewAllClubs">Danh sách CLB</a></li>
                    <li>Tạo mới</li>
                </ul>
            </div>    
            
            <!-- Create Club Form -->
            <div class="row">
                <div class="col-lg-12 m-b30">
                    <div class="widget-box">
                        <div class="wc-title">
                            <h4>Thông tin CLB</h4>
                        </div>
                        <div class="widget-inner">
                            
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger alert-dismissible fade show">
                                    <i class="fa fa-exclamation-circle"></i> ${error}
                                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                            </c:if>
                            
                            <c:if test="${not empty success}">
                                <div class="alert alert-success alert-dismissible fade show">
                                    <i class="fa fa-check-circle"></i> ${success}
                                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                            </c:if>
                            
                            <form action="${pageContext.request.contextPath}/createClub" method="POST" enctype="multipart/form-data" class="edit-profile">
                                
                                <!-- Hidden field for CreatedBy (from session) -->
                                <input type="hidden" name="createdBy" value="${sessionScope.userId}">
                                
                                <div class="row">
                                    <div class="col-12 col-sm-6 m-b30">
                                        <div class="form-group">
                                            <label class="col-form-label">Tên CLB <span class="text-danger">*</span></label>
                                            <div>
                                                <input class="form-control" type="text" name="clubName" 
                                                       value="${param.clubName}" required 
                                                       placeholder="Nhập tên câu lạc bộ">
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="col-12 col-sm-6 m-b30">
                                        <div class="form-group">
                                            <label class="col-form-label">Loại CLB <span class="text-danger">*</span></label>
                                            <div>
                                                <select class="form-control" name="clubTypes" required>
                                                    <option value="">-- Chọn loại CLB --</option>
                                                    <option value="Thể thao" ${param.clubTypes == 'Thể thao' ? 'selected' : ''}>Thể thao</option>
                                                    <option value="Văn hóa" ${param.clubTypes == 'Văn hóa' ? 'selected' : ''}>Văn hóa</option>
                                                    <option value="Học thuật" ${param.clubTypes == 'Học thuật' ? 'selected' : ''}>Học thuật</option>
                                                    <option value="Nghệ thuật" ${param.clubTypes == 'Nghệ thuật' ? 'selected' : ''}>Nghệ thuật</option>
                                                    <option value="Công nghệ" ${param.clubTypes == 'Công nghệ' ? 'selected' : ''}>Công nghệ</option>
                                                    <option value="Tình nguyện" ${param.clubTypes == 'Tình nguyện' ? 'selected' : ''}>Tình nguyện</option>
                                                    <option value="Khác" ${param.clubTypes == 'Khác' ? 'selected' : ''}>Khác</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="col-12 m-b30">
                                        <div class="form-group">
                                            <label class="col-form-label">Mô tả CLB <span class="text-danger">*</span></label>
                                            <div>
                                                <textarea class="form-control" name="description" rows="6" 
                                                          required placeholder="Mô tả về câu lạc bộ, mục đích, hoạt động...">${param.description}</textarea>
                                                <small class="form-text text-muted">
                                                    Mô tả chi tiết về mục đích, hoạt động và thành tựu của CLB
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="col-12 col-sm-6 m-b30">
                                        <div class="form-group">
                                            <label class="col-form-label">Logo CLB <span class="text-danger">*</span></label>
                                            <div>
                                                <input class="form-control" type="file" name="logo" 
                                                       accept="image/jpeg,image/jpg,image/png,image/gif,image/webp" 
                                                       required>
                                                <small class="form-text text-muted">
                                                    Upload ảnh logo (JPG, PNG, GIF, WEBP). Tối đa 5MB.
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="col-12 col-sm-6 m-b30">
                                        <div class="form-group">
                                            <label class="col-form-label">Trạng thái</label>
                                            <div>
                                                <select class="form-control" name="status">
                                                    <option value="Active" ${param.status == 'Active' || empty param.status ? 'selected' : ''}>Active</option>
                                                    <option value="Inactive" ${param.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                                                </select>
                                                <small class="form-text text-muted">
                                                    Chọn "Active" để CLB hiển thị công khai
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="col-12">
                                        <div class="seperator"></div>
                                    </div>
                                    
                                    <div class="col-12">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fa fa-save"></i> Tạo CLB
                                        </button>
                                        <a href="${pageContext.request.contextPath}/viewAllClubs" 
                                           class="btn btn-secondary">
                                            <i class="fa fa-times"></i> Hủy
                                        </a>
                                    </div>
                                    
                                </div>
                                
                            </form>
                            
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Info Card -->
            <div class="row">
                <div class="col-lg-12 m-b30">
                    <div class="widget-box">
                        <div class="wc-title">
                            <h4>Hướng dẫn</h4>
                        </div>
                        <div class="widget-inner">
                            <div class="noti-box-list">
                                <ul>
                                    <li>
                                        <span class="notification-icon dashbg-primary">
                                            <i class="fa fa-info"></i>
                                        </span>
                                        <span class="notification-text">
                                            <strong>Tên CLB:</strong> Đặt tên ngắn gọn, dễ nhớ và thể hiện được mục đích của CLB
                                        </span>
                                    </li>
                                    <li>
                                        <span class="notification-icon dashbg-green">
                                            <i class="fa fa-check"></i>
                                        </span>
                                        <span class="notification-text">
                                            <strong>Mô tả:</strong> Giới thiệu rõ ràng về mục đích, hoạt động chính và lợi ích khi tham gia CLB
                                        </span>
                                    </li>
                                    <li>
                                        <span class="notification-icon dashbg-yellow">
                                            <i class="fa fa-image"></i>
                                        </span>
                                        <span class="notification-text">
                                            <strong>Logo CLB:</strong> Upload ảnh logo đẹp, rõ ràng. Kích thước tối đa 5MB. Định dạng: JPG, PNG, GIF, WEBP
                                        </span>
                                    </li>
                                    <li>
                                        <span class="notification-icon dashbg-gray">
                                            <i class="fa fa-lightbulb-o"></i>
                                        </span>
                                        <span class="notification-text">
                                            <strong>Loại CLB:</strong> Chọn đúng loại để dễ dàng tìm kiếm và quản lý
                                        </span>
                                    </li>
                                    <li>
                                        <span class="notification-icon dashbg-red">
                                            <i class="fa fa-eye"></i>
                                        </span>
                                        <span class="notification-text">
                                            <strong>Trạng thái:</strong> Chọn "Active" để CLB hiển thị công khai cho sinh viên
                                        </span>
                                    </li>
                                </ul>
                            </div>
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

