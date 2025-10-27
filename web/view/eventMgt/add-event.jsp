<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<!-- Student Club Management System - Add Event Page -->
<head>

	<!-- META ============================================= -->
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
	<!-- DESCRIPTION -->
	<meta name="description" content="Hệ thống Quản lý Câu lạc bộ Sinh viên - Tạo sự kiện mới" />
	
	<!-- FAVICONS ICON ============================================= -->
	<link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" type="image/x-icon" />
	<link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" />

	<!-- PAGE TITLE HERE ============================================= -->
	<title>Tạo Sự kiện Mới - Hệ thống Quản lý CLB Sinh viên</title>

	<!-- MOBILE SPECIFIC ============================================= -->
	<meta name="viewport" content="width=device-width, initial-scale=1">

	<!--[if lt IE 9]>
	<script src="assets/js/html5shiv.min.js"></script>
	<script src="assets/js/respond.min.js"></script>
	<![endif]-->

	<!-- All PLUGINS CSS ============================================= -->
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/assets.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/vendors/calendar/fullcalendar.css">

	<!-- TYPOGRAPHY ============================================= -->
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/typography.css">

	<!-- SHORTCODES ============================================= -->
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/shortcodes.css">

	<!-- STYLESHEETS ============================================= -->
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
	<link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">
	
	<!-- Custom styles for event form -->
	<style>
		.form-control.is-invalid {
			border-color: #dc3545;
			box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25);
		}
		
		.text-danger {
			color: #dc3545 !important;
		}
			
			/* Smaller error text directly under form fields */
			.form-control + .text-danger {
				font-size: 12px;
				margin-top: 4px;
			}
		
		.alert {
			margin-bottom: 20px;
		}
		
		.btn {
			margin-right: 10px;
		}
		
		.seperator {
			height: 1px;
			background-color: #e9ecef;
			margin: 20px 0;
		}
		
		.form-group label {
			font-weight: 600;
			margin-bottom: 5px;
		}
		
		.widget-box {
			box-shadow: 0 0 20px rgba(0,0,0,0.1);
			border-radius: 8px;
		}
		
		.wc-title h4 {
			color: #333;
			font-weight: 600;
		}
		
		.alert-info {
			background-color: #d1ecf1;
			border-color: #bee5eb;
			color: #0c5460;
		}
	</style>
	
</head>
<body class="ttr-opened-sidebar ttr-pinned-sidebar">
	
	<!-- header start -->
    <header class="ttr-header">
        <div class="ttr-header-wrapper">
            <!--sidebar menu toggler start -->
            <div class="ttr-toggle-sidebar ttr-material-button">
                <i class="ti-close ttr-open-icon"></i>
                <i class="ti-menu ttr-close-icon"></i>
            </div>
            <!--sidebar menu toggler end -->
            <!--logo start -->
            <div class="ttr-logo-box">
                <div>
                    <a href="${pageContext.request.contextPath}/home" class="ttr-logo">
                        <img class="ttr-logo-mobile" alt="" src="${pageContext.request.contextPath}/assets/images/logo-mobile.png" width="30" height="30">
                        <img class="ttr-logo-desktop" alt="" src="${pageContext.request.contextPath}/assets/images/logo-white.png" width="160" height="27">
                    </a>
                </div>
            </div>
            <!--logo end -->
            <div class="ttr-header-menu">
                <!-- header left menu start -->
                <ul class="ttr-header-navigation">
                    <li>
                        <a href="${pageContext.request.contextPath}/home" class="ttr-material-button ttr-submenu-toggle">TRANG CHỦ</a>
                    </li>
                    <li>
                        <a href="#" class="ttr-material-button ttr-submenu-toggle">MENU NHANH <i class="fa fa-angle-down"></i></a>
                        <div class="ttr-header-submenu">
                            <ul>
                                <li><a href="${pageContext.request.contextPath}/viewAllClubs">Các CLB</a></li>
                                <li><a href="${pageContext.request.contextPath}/listEvents">Sự kiện</a></li>
                                <c:if test="${not empty club}">
                                <li><a href="${pageContext.request.contextPath}/clubDetail?clubId=${club.clubId}">Chi tiết CLB</a></li>
                                </c:if>
                            </ul>
                        </div>
                    </li>
                </ul>
                <!-- header left menu end -->
            </div>
            <div class="ttr-header-right ttr-with-seperator">
                <!-- header right menu start -->
                <ul class="ttr-header-navigation">
                    <li>
                        <a href="#" class="ttr-material-button ttr-search-toggle"><i class="fa fa-search"></i></a>
                    </li>
                    <li>
                        <a href="#" class="ttr-material-button ttr-submenu-toggle">
                            <span class="ttr-user-avatar">
                                <img alt="" src="${pageContext.request.contextPath}/assets/images/testimonials/pic3.jpg" width="32" height="32">
                            </span>
                        </a>
                        <div class="ttr-header-submenu">
                            <ul>
                                <li><a href="${pageContext.request.contextPath}/profile">Hồ sơ của tôi</a></li>
                                <c:if test="${not empty club}">
                                <li><a href="${pageContext.request.contextPath}/clubDetail?clubId=${club.clubId}">Chi tiết CLB</a></li>
                                </c:if>
                                <li><a href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                            </ul>
                        </div>
                    </li>
                </ul>
                <!-- header right menu end -->
            </div>
            <!--header search panel start -->
            <div class="ttr-search-bar">
                <form class="ttr-search-form">
                    <div class="ttr-search-input-wrapper">
                        <input type="text" name="qq" placeholder="Tìm kiếm..." class="ttr-search-input">
                        <button type="submit" name="search" class="ttr-search-submit"><i class="ti-arrow-right"></i></button>
                    </div>
                    <span class="ttr-search-close ttr-search-toggle">
                        <i class="ti-close"></i>
                    </span>
                </form>
            </div>
            <!--header search panel end -->
        </div>
    </header>
    <!-- header end -->
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
                    <li class="ttr-seperate"></li>
                    <li>
                        <a href="${pageContext.request.contextPath}/clubDashboard" class="ttr-material-button">
                            <span class="ttr-icon"><i class="ti-home"></i></span>
                            <span class="ttr-label">Dashboard</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/clubDetail?clubId=${club.clubId}" class="ttr-material-button">
                            <span class="ttr-icon"><i class="ti-info-alt"></i></span>
                            <span class="ttr-label">Thông tin CLB</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/updateClub?clubId=${club.clubId}" class="ttr-material-button">
                            <span class="ttr-icon"><i class="ti-pencil"></i></span>
                            <span class="ttr-label">Chỉnh sửa CLB</span>
                        </a>
                    </li>
                    <li>
                        <a href="#" class="ttr-material-button">
                            <span class="ttr-icon"><i class="ti-user"></i></span>
                            <span class="ttr-label">Thành viên</span>
                            <span class="ttr-arrow-icon"><i class="fa fa-angle-down"></i></span>
                        </a>
                        <ul>
                            <li>
                                <a href="${pageContext.request.contextPath}/memberList?clubId=${club.clubId}" class="ttr-material-button">
                                    <span class="ttr-label">Danh sách TV</span>
                                </a>
                            </li>
                            <li>
                                <a href="${pageContext.request.contextPath}/addMember?clubId=${club.clubId}" class="ttr-material-button">
                                    <span class="ttr-label">Thêm thành viên</span>
                                </a>
                            </li>
                        </ul>
                    </li>
                    <li class="show">
                        <a href="#" class="ttr-material-button">
                            <span class="ttr-icon"><i class="ti-calendar"></i></span>
                            <span class="ttr-label">Sự kiện</span>
                            <span class="ttr-arrow-icon"><i class="fa fa-angle-down"></i></span>
                        </a>
                        <ul>
                            <li>
                                <a href="${pageContext.request.contextPath}/listEvents" class="ttr-material-button">
                                    <span class="ttr-label">Danh sách sự kiện</span>
                                </a>
                            </li>
                            <li>
                                <a href="${pageContext.request.contextPath}/addNewEvent" class="ttr-material-button active">
                                    <span class="ttr-label">Tạo sự kiện mới</span>
                                </a>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/clubStatistics?clubId=${club.clubId}" class="ttr-material-button">
                            <span class="ttr-icon"><i class="ti-bar-chart"></i></span>
                            <span class="ttr-label">Thống kê</span>
                        </a>
                    </li>
                    <li class="ttr-seperate"></li>
                </ul>
                <!-- sidebar menu end -->
            </nav>
            <!-- sidebar menu end -->
        </div>
    </div>
    <!-- Left sidebar menu end -->

	<!--Main container start -->
	<main class="ttr-wrapper">
		<div class="container-fluid">
			<div class="db-breadcrumb">
				<h4 class="breadcrumb-title">Tạo Sự kiện Mới</h4>
				<ul class="db-breadcrumb-list">
					<li><a href="${pageContext.request.contextPath}/home"><i class="fa fa-home"></i>Trang chủ</a></li>
					<li>Sự kiện</li>
					<li>Tạo sự kiện mới</li>
				</ul>
			</div>	
			<div class="row">
				<!-- Your Profile Views Chart -->
				<div class="col-lg-12 m-b30">
					<div class="widget-box">
						<div class="wc-title">
							<h4>Tạo Sự kiện Mới</h4>
						</div>
						<div class="widget-inner">
							<!-- Display success/error messages if any at the top of the form -->
							<c:if test="${not empty message}">
								<div class="alert alert-${messageType} alert-dismissible fade show" role="alert">
									${message}
									<button type="button" class="close" data-dismiss="alert" aria-label="Close">
										<span aria-hidden="true">&times;</span>
									</button>
								</div>
							</c:if>
							<form class="edit-profile m-b30" id="addEventForm" action="addNewEvent" method="post" enctype="multipart/form-data" novalidate>
								<div class="row">
									<div class="col-12">
										<div class="ml-auto">
											<h3>1. Thông tin cơ bản</h3>
										</div>
									</div>
									<div class="form-group col-12">
										<label class="col-form-label">Tên sự kiện <span class="text-danger">*</span></label>
										<div>
								<input class="form-control" type="text" name="eventName" id="eventTitle" required maxlength="200" placeholder="Nhập tên sự kiện" value="${param.eventName}">
								<div class="text-danger" id="eventTitleError"></div>
										</div>
									</div>
									<div class="form-group col-6">
										<label class="col-form-label">Câu lạc bộ <span class="text-danger">*</span></label>
										<div>
											<select class="form-control" name="clubId" id="clubId" required>
												<option value="">Chọn câu lạc bộ</option>
												<c:forEach var="club" items="${clubs}">
													<option value="${club.clubId}" ${(param.clubId == club.clubId || selectedClubId == club.clubId) ? 'selected' : ''}>
														${club.clubName}
													</option>
												</c:forEach>
											</select>
								<div class="text-danger" id="clubIdError"></div>
										</div>
									</div>
									<div class="form-group col-6">
										<label class="col-form-label">Trạng thái</label>
										<div>
											<select class="form-control" name="status" id="eventStatus">
												<option value="Draft" ${param.status == 'Draft' ? 'selected' : ''}>Bản nháp</option>
												<option value="Published" ${param.status == 'Published' ? 'selected' : ''}>Công bố</option>
											</select>
										</div>
									</div>
									<div class="seperator"></div>
									
									<div class="col-12 m-t20">
										<div class="ml-auto m-b5">
											<h3>2. Chi tiết sự kiện</h3>
										</div>
									</div>
									<div class="form-group col-12">
										<label class="col-form-label">Mô tả</label>
										<div>
											<textarea class="form-control" name="description" id="eventDescription" rows="4" maxlength="1000" placeholder="Nhập mô tả sự kiện">${param.description}</textarea>
										</div>
									</div>
									<div class="form-group col-6">
										<label class="col-form-label">Địa điểm <span class="text-danger">*</span></label>
										<div>
											<input class="form-control" type="text" name="location" id="eventLocation" maxlength="300" placeholder="Nhập địa điểm sự kiện" value="${param.location}" required>
											<div class="text-danger" id="locationError"></div>
										</div>
									</div>
									<div class="form-group col-6">
										<label class="col-form-label">Sức chứa <span class="text-danger">*</span></label>
										<div>
											<input class="form-control" type="number" name="capacity" id="eventCapacity" min="1" max="1000" placeholder="Nhập sức chứa" value="${param.capacity}" required>
											<div class="text-danger" id="capacityError"></div>
										</div>
									</div>
									<div class="seperator"></div>
									
									<div class="col-12 m-t20">
										<div class="ml-auto m-b5">
											<h3>3. Ngày giờ</h3>
										</div>
									</div>
									<div class="form-group col-6">
										<label class="col-form-label">Bắt đầu <span class="text-danger">*</span></label>
										<div>
											<input class="form-control" type="datetime-local" name="startDate" id="startTime" required value="${param.startDate}">
											<div class="text-danger" id="startTimeError"></div>
										</div>
									</div>
									<div class="form-group col-6">
										<label class="col-form-label">Kết thúc <span class="text-danger">*</span></label>
										<div>
											<input class="form-control" type="datetime-local" name="endDate" id="endTime" required value="${param.endDate}">
											<div class="text-danger" id="endTimeError"></div>
										</div>
									</div>
									<div class="col-12 m-t20">
										<div class="ml-auto m-b5">
											<h3>4. Thời gian đăng ký</h3>
										</div>
									</div>
									<div class="form-group col-6">
										<label class="col-form-label">Bắt đầu đăng ký</label>
										<div>
											<input class="form-control" type="datetime-local" name="registrationStart" id="regStartTime" value="${param.registrationStart}">
											<div class="text-danger" id="regStartTimeError"></div>
										</div>
									</div>
									<div class="form-group col-6">
										<label class="col-form-label">Kết thúc đăng ký</label>
										<div>
											<input class="form-control" type="datetime-local" name="registrationEnd" id="regEndTime" value="${param.registrationEnd}">
											<div class="text-danger" id="regEndTimeError"></div>
										</div>
									</div>
									<div class="col-12 m-t20">
										<div class="ml-auto m-b5">
											<h3>5. Hình ảnh sự kiện</h3>
										</div>
									</div>
									<div class="form-group col-12">
										<label class="col-form-label">Hình ảnh</label>
										<div>
											<input class="form-control" type="file" name="eventImage" id="eventImage" accept="image/*">
											<small class="form-text text-muted">Chấp nhận file ảnh định dạng: JPG, JPEG, PNG, GIF. Kích thước tối đa: 5MB</small>
											<div id="imagePreview" style="margin-top: 10px;"></div>
										</div>
									</div>
									<div class="col-12">
							<div class="alert alert-info">
								<i class="fa fa-info-circle"></i> <strong>Lưu ý:</strong> Ngày sự kiện phải cách ngày hiện tại ít nhất 3 ngày.
							</div>
									</div>
									<div class="col-12 m-t20">
										<button type="submit" class="btn btn-primary m-r5"><i class="fa fa-save"></i> Tạo sự kiện</button>
										<button type="reset" class="btn btn-secondary"><i class="fa fa-refresh"></i> Đặt lại</button>
										<a href="${pageContext.request.contextPath}/listEvents" class="btn btn-outline-secondary"><i class="fa fa-arrow-left"></i> Về danh sách</a>
									</div>
								</div>
							</form>
						</div>
					</div>
				</div>
				<!-- Your Profile Views Chart END-->
			</div>
		</div>
	</main>
	<div class="ttr-overlay"></div>

<!-- External JavaScripts -->
<script src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/popper.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap-select/bootstrap-select.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap-touchspin/jquery.bootstrap-touchspin.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/magnific-popup/magnific-popup.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/counter/waypoints-min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/counter/counterup.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/imagesloaded/imagesloaded.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/masonry/masonry.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/masonry/filter.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/owl-carousel/owl.carousel.js"></script>
<script src='${pageContext.request.contextPath}/assets/vendors/scroll/scrollbar.min.js'></script>
<script src="${pageContext.request.contextPath}/assets/js/functions.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/chart/chart.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin.js"></script>
<script src='${pageContext.request.contextPath}/assets/vendors/switcher/switcher.js'></script>
<script>
$(document).ready(function() {
    // Form validation and submission
    $('#addEventForm').on('submit', function(e) {
        // Validate form before submission
        if (!validateEventForm()) {
            e.preventDefault(); // Only prevent submission if validation fails
            return false;
        }
        // If validation passes, allow normal form submission to servlet
    });
    
    // Real-time validation
    $('#startTime').on('change input blur', function() {
        validateEventDate();
        validateRegistrationDates(); // Re-validate registration dates when event start changes
    });

    $('#endTime').on('change input blur', function() {
        validateEndDate();
    });

    $('#regStartTime, #regEndTime').on('change input blur', function() {
        validateRegistrationDates();
    });

    // Real-time validation for title and club
    $('#eventTitle').on('input blur', function() {
        if (!$(this).val().trim()) {
            $('#eventTitle').addClass('is-invalid');
            $('#eventTitleError').text('Tên sự kiện là bắt buộc');
        } else {
            $('#eventTitle').removeClass('is-invalid');
            $('#eventTitleError').text('');
        }
    });

    $('#clubId').on('change blur', function() {
        if (!$(this).val()) {
            $('#clubId').addClass('is-invalid');
            $('#clubIdError').text('Vui lòng chọn câu lạc bộ');
        } else {
            $('#clubId').removeClass('is-invalid');
            $('#clubIdError').text('');
        }
    });

    $('#eventLocation').on('input blur', function() {
        if (!$(this).val().trim()) {
            $('#eventLocation').addClass('is-invalid');
            $('#locationError').text('Địa điểm là bắt buộc');
        } else {
            $('#eventLocation').removeClass('is-invalid');
            $('#locationError').text('');
        }
    });

    $('#eventCapacity').on('input blur', function() {
        var capacity = parseInt($(this).val());
        if (!$(this).val() || capacity <= 0) {
            $('#eventCapacity').addClass('is-invalid');
            $('#capacityError').text('Sức chứa phải lớn hơn 0');
        } else {
            $('#eventCapacity').removeClass('is-invalid');
            $('#capacityError').text('');
        }
    });
    
    // Clubs are loaded from server via servlet
});

function validateEventForm() {
    var isValid = true;
    var errors = [];
    
    // Clear previous inline errors
    $('#eventTitleError').text('');
    $('#clubIdError').text('');
    $('#startTimeError').text('');
    $('#endTimeError').text('');
    $('#locationError').text('');
    $('#capacityError').text('');
    $('#regStartTimeError').text('');
    $('#regEndTimeError').text('');
    
    // Check required fields
    if (!$('#eventTitle').val().trim()) {
        $('#eventTitle').addClass('is-invalid');
        $('#eventTitleError').text('Tên sự kiện là bắt buộc');
        isValid = false;
    } else {
        $('#eventTitle').removeClass('is-invalid');
        $('#eventTitleError').text('');
    }
    
    if (!$('#clubId').val()) {
        $('#clubId').addClass('is-invalid');
        $('#clubIdError').text('Vui lòng chọn câu lạc bộ');
        isValid = false;
    } else {
        $('#clubId').removeClass('is-invalid');
        $('#clubIdError').text('');
    }
    
    if (!$('#eventLocation').val().trim()) {
        $('#eventLocation').addClass('is-invalid');
        $('#locationError').text('Địa điểm là bắt buộc');
        isValid = false;
    } else {
        $('#eventLocation').removeClass('is-invalid');
        $('#locationError').text('');
    }
    
    var capacity = parseInt($('#eventCapacity').val());
    if (!$('#eventCapacity').val() || capacity <= 0) {
        $('#eventCapacity').addClass('is-invalid');
        $('#capacityError').text('Sức chứa phải lớn hơn 0');
        isValid = false;
    } else {
        $('#eventCapacity').removeClass('is-invalid');
        $('#capacityError').text('');
    }
    
    if (!$('#startTime').val()) {
        $('#startTime').addClass('is-invalid');
        $('#startTimeError').text('Ngày bắt đầu là bắt buộc');
        isValid = false;
    } else {
        // Check event date >= today + 3 days
        var eventDate = new Date($('#startTime').val());
        var now = new Date();
        var minDate = new Date(now.getFullYear(), now.getMonth(), now.getDate());
        minDate.setDate(minDate.getDate() + 3);

        if (eventDate < minDate) {
            $('#startTime').addClass('is-invalid');
            $('#startTimeError').text('Ngày bắt đầu phải cách ngày hiện tại ít nhất 3 ngày');
            isValid = false;
        } else {
            $('#startTime').removeClass('is-invalid');
            $('#startTimeError').text('');
        }
    }
    
    if (!$('#endTime').val()) {
        $('#endTime').addClass('is-invalid');
        $('#endTimeError').text('Ngày kết thúc là bắt buộc');
        isValid = false;
    } else {
        var endDate = new Date($('#endTime').val());
        var startDate = new Date($('#startTime').val());
        
        if (endDate <= startDate) {
            $('#endTime').addClass('is-invalid');
            $('#endTimeError').text('Ngày kết thúc phải sau ngày bắt đầu');
            isValid = false;
        } else {
            $('#endTime').removeClass('is-invalid');
            $('#endTimeError').text('');
        }
    }
    
    // Validate registration dates if provided
    if ($('#regStartTime').val() || $('#regEndTime').val()) {
        var startDate = new Date($('#startTime').val());
        var now = new Date();
        var regStart = $('#regStartTime').val() ? new Date($('#regStartTime').val()) : null;
        var regEnd = $('#regEndTime').val() ? new Date($('#regEndTime').val()) : null;
        
        // Validate registration start
        if (regStart) {
            if (regStart <= now) {
                $('#regStartTime').addClass('is-invalid');
                $('#regStartTimeError').text('Thời gian bắt đầu đăng ký phải sau hôm nay');
                isValid = false;
            } else if (regStart >= startDate) {
                $('#regStartTime').addClass('is-invalid');
                $('#regStartTimeError').text('Thời gian bắt đầu đăng ký phải trước ngày sự kiện');
                isValid = false;
            } else {
                $('#regStartTime').removeClass('is-invalid');
                $('#regStartTimeError').text('');
            }
        }
        
        // Validate registration end
        if (regEnd) {
            if (regEnd <= now) {
                $('#regEndTime').addClass('is-invalid');
                $('#regEndTimeError').text('Thời gian kết thúc đăng ký phải sau hôm nay');
                isValid = false;
            } else if (regEnd >= startDate) {
                $('#regEndTime').addClass('is-invalid');
                $('#regEndTimeError').text('Thời gian kết thúc đăng ký phải trước ngày sự kiện');
                isValid = false;
            } else {
                $('#regEndTime').removeClass('is-invalid');
                $('#regEndTimeError').text('');
            }
        }
        
        // Cross-validation: reg start should be before reg end
        if (regStart && regEnd && regStart >= regEnd) {
            $('#regEndTime').addClass('is-invalid');
            $('#regEndTimeError').text('Thời gian kết thúc đăng ký phải sau thời gian bắt đầu');
            isValid = false;
        }
    }
    
    return isValid;
}

function validateEventDate() {
    if (!$('#startTime').val()) {
        return;
    }
    var eventDate = new Date($('#startTime').val());
    var now = new Date();
    var minDate = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    minDate.setDate(minDate.getDate() + 3);

    if (eventDate < minDate) {
        $('#startTime').addClass('is-invalid');
        $('#startTimeError').text('Ngày bắt đầu phải cách ngày hiện tại ít nhất 3 ngày');
    } else {
        $('#startTime').removeClass('is-invalid');
        $('#startTimeError').text('');
    }
}

function validateEndDate() {
    if (!$('#endTime').val() || !$('#startTime').val()) {
        return;
    }
    var endDate = new Date($('#endTime').val());
    var startDate = new Date($('#startTime').val());
    
    if (endDate <= startDate) {
        $('#endTime').addClass('is-invalid');
        $('#endTimeError').text('Ngày kết thúc phải sau ngày bắt đầu');
    } else {
        $('#endTime').removeClass('is-invalid');
        $('#endTimeError').text('');
    }
}

function validateRegistrationDates() {
    if (!$('#startTime').val()) {
        return;
    }
    
    var startDate = new Date($('#startTime').val());
    var now = new Date();
    var regStart = $('#regStartTime').val() ? new Date($('#regStartTime').val()) : null;
    var regEnd = $('#regEndTime').val() ? new Date($('#regEndTime').val()) : null;
    
    // Validate registration start
    if (regStart) {
        // Check if registration start is after today
        if (regStart <= now) {
            $('#regStartTime').addClass('is-invalid');
            $('#regStartTimeError').text('Thời gian bắt đầu đăng ký phải sau hôm nay');
        } else if (regStart >= startDate) {
            $('#regStartTime').addClass('is-invalid');
            $('#regStartTimeError').text('Thời gian bắt đầu đăng ký phải trước ngày sự kiện');
        } else {
            $('#regStartTime').removeClass('is-invalid');
            $('#regStartTimeError').text('');
        }
    }
    
    // Validate registration end
    if (regEnd) {
        // Check if registration end is after today
        if (regEnd <= now) {
            $('#regEndTime').addClass('is-invalid');
            $('#regEndTimeError').text('Thời gian kết thúc đăng ký phải sau hôm nay');
        } else if (regEnd >= startDate) {
            $('#regEndTime').addClass('is-invalid');
            $('#regEndTimeError').text('Thời gian kết thúc đăng ký phải trước ngày sự kiện');
        } else {
            $('#regEndTime').removeClass('is-invalid');
            $('#regEndTimeError').text('');
        }
    }
    
    // Cross-validation: reg start should be before reg end
    if (regStart && regEnd && regStart >= regEnd) {
        $('#regEndTime').addClass('is-invalid');
        $('#regEndTimeError').text('Thời gian kết thúc đăng ký phải sau thời gian bắt đầu');
    }
}


function showAlert(message, type) {
    var alertClass = type === 'success' ? 'alert-success' :
                    type === 'error' ? 'alert-danger' :
                    type === 'warning' ? 'alert-warning' : 'alert-info';

    var alertHtml = '<div class="alert ' + alertClass + ' alert-dismissible fade show" role="alert">' +
                   message +
                   '<button type="button" class="close" data-dismiss="alert" aria-label="Close">' +
                   '<span aria-hidden="true">&times;</span>' +
                   '</button>' +
                   '</div>';

    // Remove existing alerts
    $('.alert').remove();

    // Add new alert
    $('#addEventForm').before(alertHtml);

    // Auto-hide after 5 seconds for success messages
    if (type === 'success') {
        setTimeout(function() {
            $('.alert').fadeOut();
        }, 5000);
    }
}

// Image preview functionality
document.getElementById('eventImage').addEventListener('change', function(e) {
    const file = e.target.files[0];
    const preview = document.getElementById('imagePreview');

    if (file) {
        // Validate file size (5MB)
        if (file.size > 5 * 1024 * 1024) {
            alert('Kích thước file không được vượt quá 5MB');
            e.target.value = '';
            preview.innerHTML = '';
            return;
        }

        // Validate file type
        const validTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];
        if (!validTypes.includes(file.type)) {
            alert('Chỉ chấp nhận file ảnh định dạng: JPG, JPEG, PNG, GIF');
            e.target.value = '';
            preview.innerHTML = '';
            return;
        }

        // Show preview
        const reader = new FileReader();
        reader.onload = function(e) {
            preview.innerHTML = '<img src="' + e.target.result + '" style="max-width: 300px; max-height: 300px; border: 1px solid #ddd; border-radius: 4px; padding: 5px;">';
        };
        reader.readAsDataURL(file);
    } else {
        preview.innerHTML = '';
    }
});
</script>
</body>

<!-- Student Club Management System - Add Event Page -->
</html>
