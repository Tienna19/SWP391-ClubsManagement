<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">

<!-- Student Club Management System - Event Detail Page -->
<head>

	<!-- META ============================================= -->
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
	<!-- DESCRIPTION -->
	<meta name="description" content="Hệ thống Quản lý Câu lạc bộ Sinh viên - Chi tiết sự kiện" />
	
	<!-- FAVICONS ICON ============================================= -->
	<link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" type="image/x-icon" />
	<link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" />

	<!-- PAGE TITLE HERE ============================================= -->
	<title>Chi tiết Sự kiện - ${event.eventName}</title>

	<!-- MOBILE SPECIFIC ============================================= -->
	<meta name="viewport" content="width=device-width, initial-scale=1">

	<!--[if lt IE 9]>
	<script src="assets/js/html5shiv.min.js"></script>
	<script src="assets/js/respond.min.js"></script>
	<![endif]-->

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
	
	<!-- Custom styles for event detail -->
	<style>
		.event-detail-hero {
			position: relative;
			padding: 80px 0 50px;
			background: #6f42c1;
			color: #fff;
			overflow: hidden;
		}
		
		.event-detail-hero .container {
			position: relative;
			z-index: 1;
		}
		
		.event-image-wrapper {
			width: 100%;
			height: 400px;
			border-radius: 12px;
			overflow: hidden;
			box-shadow: 0 20px 50px rgba(0,0,0,0.3);
			margin-bottom: 30px;
		}
		
		.event-image-wrapper img {
			width: 100%;
			height: 100%;
			object-fit: cover;
		}
		
		.event-image-placeholder {
			width: 100%;
			height: 100%;
			background: #6f42c1;
			display: flex;
			align-items: center;
			justify-content: center;
			color: #fff;
			font-size: 48px;
		}
		
		.status-badge {
			display: inline-block;
			padding: 6px 14px;
			border-radius: 20px;
			font-size: 13px;
			font-weight: 600;
			text-transform: uppercase;
			margin-bottom: 15px;
		}
		
		.status-draft { background-color: #6c757d; color: white; }
		.status-pending { background-color: #ffc107; color: #212529; }
		.status-published { background-color: #6f42c1; color: white; }
		.status-completed { background-color: #28a745; color: white; }
		.status-cancelled { background-color: #dc3545; color: white; }
		
		.event-info-card {
			background: white;
			border-radius: 12px;
			padding: 30px;
			box-shadow: 0 2px 10px rgba(0,0,0,0.1);
			margin-bottom: 30px;
		}
		
		.event-feature-item {
			display: flex;
			align-items: center;
			padding: 15px 0;
			border-bottom: 1px solid #eee;
		}
		
		.event-feature-item:last-child {
			border-bottom: none;
		}
		
		.event-feature-item i {
			width: 40px;
			height: 40px;
			display: flex;
			align-items: center;
			justify-content: center;
			background: #f0f0f0;
			border-radius: 8px;
			margin-right: 15px;
			color: #6f42c1;
			font-size: 18px;
		}
		
		.event-feature-item .label {
			font-weight: 600;
			color: #333;
			margin-right: 10px;
			min-width: 120px;
		}
		
		.event-feature-item .value {
			color: #666;
			flex: 1;
		}
		
		.registration-info {
			background: #6f42c1;
			color: white;
			border-radius: 12px;
			padding: 25px;
			margin-bottom: 30px;
		}
		
		.registration-info h4 {
			color: white;
			margin-bottom: 15px;
		}
		
		.registration-stats {
			display: flex;
			justify-content: space-around;
			margin-top: 20px;
		}
		
		.registration-stat {
			text-align: center;
		}
		
		.registration-stat .number {
			font-size: 32px;
			font-weight: bold;
			display: block;
		}
		
		.registration-stat .label {
			font-size: 14px;
			opacity: 0.9;
			margin-top: 5px;
		}
		
		.club-info-card {
			background: white;
			border-radius: 12px;
			padding: 25px;
			box-shadow: 0 2px 10px rgba(0,0,0,0.1);
			margin-bottom: 30px;
		}
		
		.club-logo-small {
			width: 60px;
			height: 60px;
			border-radius: 8px;
			object-fit: cover;
			margin-right: 15px;
		}
		
		.creator-info {
			display: flex;
			align-items: center;
			padding: 15px;
			background: #f8f9fa;
			border-radius: 8px;
			margin-top: 15px;
		}
		
		.creator-avatar {
			width: 50px;
			height: 50px;
			border-radius: 50%;
			background: #6f42c1;
			display: flex;
			align-items: center;
			justify-content: center;
			color: white;
			font-weight: 600;
			margin-right: 15px;
		}
		
		.breadcrumb-custom {
			background: transparent;
			padding: 0;
			margin-bottom: 20px;
		}
		
		.breadcrumb-custom a {
			color: rgba(255,255,255,0.8);
			text-decoration: none;
		}
		
		.breadcrumb-custom a:hover {
			color: white;
		}
		
		.breadcrumb-custom .active {
			color: white;
		}
		
		.description-content {
			line-height: 1.8;
			color: #555;
		}
		
		.action-buttons {
			display: flex;
			gap: 10px;
			margin-top: 20px;
		}
		
		.btn-register {
			background: #28a745;
			border: none;
			color: white;
			padding: 12px 30px;
			border-radius: 6px;
			font-weight: 600;
			transition: all 0.3s;
		}
		
		.btn-register:hover {
			background: #218838;
			transform: translateY(-2px);
			box-shadow: 0 4px 12px rgba(40,167,69,0.4);
		}
		
		.btn-registered {
			background: #6c757d;
			border: none;
			color: white;
			padding: 12px 30px;
			border-radius: 6px;
			font-weight: 600;
			cursor: not-allowed;
		}
		
		/* Ensure FontAwesome icons use FontAwesome font in admin sidebar */
		body.admin-theme-loaded .ttr-sidebar [class*="fa-"],
		body.admin-theme-loaded .ttr-sidebar .fa,
		body.admin-theme-loaded .ttr-arrow-icon [class*="fa-"],
		body.admin-theme-loaded .ttr-arrow-icon .fa {
			font-family: 'FontAwesome' !important;
		}
	</style>
	
</head>
<body class="ttr-opened-sidebar ttr-pinned-sidebar <c:if test='${sessionScope.account.roleId == 4}'>admin-theme-loaded</c:if>">

<c:choose>
	<c:when test="${sessionScope.account.roleId == 4}">
		<%@ include file="/WEB-INF/jspf/admin-layout.jspf" %>
	</c:when>
	<c:otherwise>
		<%@ include file="/WEB-INF/jspf/leader-layout.jspf" %>
	</c:otherwise>
</c:choose>

	<!--Main container start -->
	<main class="ttr-wrapper">
		<div class="container-fluid">
			<div class="db-breadcrumb">
				<div class="d-flex align-items-center justify-content-between" style="width: 100%;">
					<div class="d-flex align-items-center">
						<h4 class="breadcrumb-title" style="margin: 0; margin-right: 20px;">Chi tiết Sự kiện</h4>
						<ul class="db-breadcrumb-list" style="margin: 0;">
							<li><a href="${pageContext.request.contextPath}/home"><i class="fa fa-home"></i>Trang chủ</a></li>
							<li><a href="${pageContext.request.contextPath}/listEvents">Sự kiện</a></li>
							<li>Chi tiết sự kiện</li>
						</ul>
					</div>
					<a href="${pageContext.request.contextPath}/listEvents" class="btn btn-secondary" style="margin-left: auto;">
						<i class="fa fa-arrow-left"></i> Quay lại
					</a>
				</div>
			</div>
			
			<!-- Event Detail Content -->
			<div class="row m-b30">
				<div class="col-12">
					<div class="widget-box">
						<div class="wc-title" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
							<h4 style="margin: 0;">${event.eventName}</h4>
							<span class="status-badge status-${fn:toLowerCase(event.status)}">${event.status}</span>
						</div>
						<div class="widget-inner">
							<div class="row">
								<div class="col-lg-8 col-md-7 col-sm-12">
									<!-- Event Image -->
									<div class="event-image-wrapper">
											<c:choose>
												<c:when test="${not empty event.image}">
													<img src="${pageContext.request.contextPath}/${event.image}" alt="${event.eventName}">
												</c:when>
												<c:otherwise>
													<div class="event-image-placeholder">
														<i class="fa fa-calendar"></i>
													</div>
												</c:otherwise>
											</c:choose>
										</div>
										
										<!-- Event Description -->
										<div class="event-info-card">
											<h4 class="mb-4">Mô tả sự kiện</h4>
											<div class="description-content">
												<c:choose>
													<c:when test="${not empty event.description}">
														${event.description}
													</c:when>
													<c:otherwise>
														<p class="text-muted">Chưa có mô tả cho sự kiện này.</p>
													</c:otherwise>
												</c:choose>
											</div>
										</div>
										
										<!-- Event Details -->
										<div class="event-info-card">
											<h4 class="mb-4">Thông tin chi tiết</h4>
											<div class="event-feature-item">
												<i class="fa fa-calendar"></i>
												<span class="label">Ngày bắt đầu:</span>
												<span class="value">
													<fmt:formatDate value="${event.startDate}" pattern="dd/MM/yyyy HH:mm" />
												</span>
											</div>
											<div class="event-feature-item">
												<i class="fa fa-calendar-check-o"></i>
												<span class="label">Ngày kết thúc:</span>
												<span class="value">
													<fmt:formatDate value="${event.endDate}" pattern="dd/MM/yyyy HH:mm" />
												</span>
											</div>
											<div class="event-feature-item">
												<i class="fa fa-map-marker"></i>
												<span class="label">Địa điểm:</span>
												<span class="value">
													<c:choose>
														<c:when test="${not empty event.location}">
															${event.location}
														</c:when>
														<c:otherwise>
															<span class="text-muted">Chưa cập nhật</span>
														</c:otherwise>
													</c:choose>
												</span>
											</div>
											<div class="event-feature-item">
												<i class="fa fa-users"></i>
												<span class="label">Sức chứa:</span>
												<span class="value">${event.capacity} người</span>
											</div>
											<div class="event-feature-item">
												<i class="fa fa-clock-o"></i>
												<span class="label">Bắt đầu đăng ký:</span>
												<span class="value">
													<fmt:formatDate value="${event.registrationStart}" pattern="dd/MM/yyyy HH:mm" />
												</span>
											</div>
											<div class="event-feature-item">
												<i class="fa fa-clock-o"></i>
												<span class="label">Kết thúc đăng ký:</span>
												<span class="value">
													<fmt:formatDate value="${event.registrationEnd}" pattern="dd/MM/yyyy HH:mm" />
												</span>
											</div>
										</div>
									</div>
									
									<!-- Sidebar -->
									<div class="col-lg-4 col-md-5 col-sm-12">
										<!-- Registration Info -->
										<div class="registration-info">
											<h4>Thông tin đăng ký</h4>
											<div class="registration-stats">
												<div class="registration-stat">
													<span class="number">${registrationCount}</span>
													<span class="label">Đã đăng ký</span>
												</div>
												<div class="registration-stat">
													<span class="number">${availableSlots}</span>
													<span class="label">Còn trống</span>
												</div>
												<div class="registration-stat">
													<span class="number">${event.capacity}</span>
													<span class="label">Tổng số</span>
												</div>
											</div>
											
											<c:if test="${not empty sessionScope.account}">
												<div class="action-buttons">
													<c:choose>
														<c:when test="${isRegistered}">
															<button class="btn btn-registered" disabled>
																<i class="fa fa-check"></i> Đã đăng ký
															</button>
														</c:when>
														<c:when test="${event.status == 'Published' && availableSlots > 0}">
															<button class="btn btn-register" onclick="registerEvent(<c:out value='${event.eventID}'/>)">
																<i class="fa fa-user-plus"></i> Đăng ký tham gia
															</button>
														</c:when>
														<c:otherwise>
															<button class="btn btn-registered" disabled>
																<i class="fa fa-ban"></i> Không thể đăng ký
															</button>
														</c:otherwise>
													</c:choose>
												</div>
											</c:if>
										</div>
										
										<!-- Club Info -->
										<c:if test="${not empty club}">
											<div class="club-info-card">
												<h5 class="mb-3">Câu lạc bộ tổ chức</h5>
												<div class="d-flex align-items-center mb-3">
													<c:choose>
														<c:when test="${not empty club.logo}">
															<img src="${pageContext.request.contextPath}/${club.logo}" alt="${club.clubName}" class="club-logo-small">
														</c:when>
														<c:otherwise>
															<div class="club-logo-small" style="background: #6f42c1; display: flex; align-items: center; justify-content: center; color: white; font-weight: 600;">
																${fn:substring(club.clubName, 0, 1)}
															</div>
														</c:otherwise>
													</c:choose>
													<div>
														<h6 class="mb-0">${club.clubName}</h6>
														<small class="text-muted">${club.clubTypes}</small>
													</div>
												</div>
												<a href="${pageContext.request.contextPath}/clubDetail?clubId=${club.clubId}" class="btn btn-sm btn-outline-primary">
													Xem chi tiết CLB <i class="fa fa-arrow-right"></i>
												</a>
											</div>
										</c:if>
										
										<!-- Creator Info -->
										<c:if test="${not empty creator}">
											<div class="club-info-card">
												<h5 class="mb-3">Người tạo sự kiện</h5>
												<div class="creator-info">
													<div class="creator-avatar">
														${fn:substring(creator.fullName, 0, 1)}
													</div>
													<div>
														<h6 class="mb-0">${creator.fullName}</h6>
														<small class="text-muted">${creator.email}</small>
													</div>
												</div>
											</div>
										</c:if>
										
										<!-- Action Buttons for Admin/Club Leader -->
										<c:if test="${not empty sessionScope.account and (sessionScope.account.roleId == 4 or (sessionScope.account.roleId == 3 and sessionScope.account.userId == event.createdBy))}">
											<div class="club-info-card">
												<h5 class="mb-3">Quản lý sự kiện</h5>
												<div class="action-buttons">
													<a href="${pageContext.request.contextPath}/editEvent?eventId=${event.eventID}" class="btn btn-warning btn-sm">
														<i class="fa fa-edit"></i> Chỉnh sửa
													</a>
													<a href="${pageContext.request.contextPath}/listEvents" class="btn btn-secondary btn-sm">
														<i class="fa fa-arrow-left"></i> Quay lại
													</a>
												</div>
											</div>
										</c:if>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- Event Detail Content END -->
		</div>
	</main>
	<!--Main container end -->
	
	<!-- External JavaScripts -->
	<script src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>
	<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/popper.min.js"></script>
	<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
	<script src="${pageContext.request.contextPath}/assets/js/functions.js"></script>
	
	<script>
		function registerEvent(eventId) {
			if (confirm('Bạn có chắc chắn muốn đăng ký tham gia sự kiện này?')) {
				// TODO: Implement event registration functionality
				alert('Chức năng đăng ký sự kiện sẽ được triển khai sau.');
			}
		}
	</script>
	
</body>
</html>

