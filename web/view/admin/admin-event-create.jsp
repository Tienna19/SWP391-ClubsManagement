<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Tạo sự kiện mới - Admin</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/assets.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/typography.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/shortcodes.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">
</head>
<body class="ttr-opened-sidebar ttr-pinned-sidebar admin-theme-loaded">
<%@ include file="/WEB-INF/jspf/admin-layout.jspf" %>

<main class="ttr-wrapper">
    <div class="container-fluid">
        <div class="db-breadcrumb">
            <h4 class="breadcrumb-title">Tạo sự kiện mới</h4>
            <ul class="db-breadcrumb-list">
                <li><a href="${pageContext.request.contextPath}/adminDashboard"><i class="fa fa-home"></i>Dashboard</a></li>
                <li>Quản lý sự kiện</li>
                <li>Tạo sự kiện mới</li>
            </ul>
        </div>

        <c:if test="${not empty message}">
            <div class="alert alert-${not empty messageType ? messageType : 'info'} alert-dismissible fade show" role="alert">
                ${message}
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
        </c:if>

        <div class="card shadow-sm">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/addNewEvent" method="post" enctype="multipart/form-data" class="row g-3">
                    <div class="col-lg-6">
                        <label class="form-label">Tên sự kiện <span class="text-danger">*</span></label>
                        <input type="text" name="eventName" class="form-control" placeholder="Nhập tên sự kiện" required>
                    </div>
                    <div class="col-lg-6">
                        <label class="form-label">CLB tổ chức <span class="text-danger">*</span></label>
                        <select name="clubId" class="form-control" required>
                            <option value="">-- Chọn CLB --</option>
                            <c:forEach items="${clubs}" var="club">
                                <option value="${club.clubId}"<c:if test="${selectedClubId eq club.clubId}"> selected="selected"</c:if>>${club.clubName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-lg-4">
                        <label class="form-label">Trạng thái</label>
                        <select name="status" class="form-control">
                            <option value="Published">Published</option>
                            <option value="Draft">Draft</option>
                        </select>
                    </div>
                    <div class="col-lg-4">
                        <label class="form-label">Địa điểm <span class="text-danger">*</span></label>
                        <input type="text" name="location" class="form-control" placeholder="Nhập địa điểm" required>
                    </div>
                    <div class="col-lg-4">
                        <label class="form-label">Sức chứa <span class="text-danger">*</span></label>
                        <input type="number" name="capacity" class="form-control" min="1" placeholder="Số lượng tối đa" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Thời gian bắt đầu <span class="text-danger">*</span></label>
                        <input type="datetime-local" name="startDate" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Thời gian kết thúc <span class="text-danger">*</span></label>
                        <input type="datetime-local" name="endDate" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Mở đăng ký</label>
                        <input type="datetime-local" name="registrationStart" class="form-control">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Đóng đăng ký</label>
                        <input type="datetime-local" name="registrationEnd" class="form-control">
                    </div>
                    <div class="col-12">
                        <label class="form-label">Mô tả chi tiết</label>
                        <textarea name="description" class="form-control" rows="5" placeholder="Thông tin chi tiết về sự kiện..."></textarea>
                    </div>
                    <div class="col-12">
                        <label class="form-label">Ảnh đại diện</label>
                        <input type="file" name="eventImage" accept="image/*" class="form-control">
                        <small class="text-muted">Hỗ trợ các định dạng JPG, JPEG, PNG, GIF (tối đa 5MB).</small>
                    </div>
                    <div class="col-12 text-right">
                        <button type="submit" class="btn btn-primary"><i class="fa fa-save mr-1"></i>Lưu sự kiện</button>
                        <a href="${pageContext.request.contextPath}/admin-event-list" class="btn btn-outline-secondary">Hủy</a>
                    </div>
                </form>
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
<script src="${pageContext.request.contextPath}/assets/vendors/file-upload/imageuploadify.min.js"></script>
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
