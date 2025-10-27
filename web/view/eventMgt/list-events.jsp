<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<!-- Student Club Management System - Events List Page -->
<head>

	<!-- META ============================================= -->
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
	<!-- DESCRIPTION -->
	<meta name="description" content="Hệ thống Quản lý Câu lạc bộ Sinh viên - Danh sách sự kiện" />
	
	<!-- FAVICONS ICON ============================================= -->
	<link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" type="image/x-icon" />
	<link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" />

	<!-- PAGE TITLE HERE ============================================= -->
	<title>Danh sách Sự kiện - Hệ thống Quản lý CLB Sinh viên</title>

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
	
	<!-- Custom styles for events list -->
	<style>
		.event-card {
			transition: box-shadow 0.2s ease-in-out;
		}
		
		.event-card:hover {
			box-shadow: 0 2px 8px rgba(0,0,0,0.1);
		}
		
		.status-badge {
			font-size: 12px;
			padding: 4px 8px;
			border-radius: 4px;
			font-weight: 600;
			text-transform: uppercase;
		}
		
		.status-draft { background-color: #6c757d; color: white; }
		.status-pending { background-color: #ffc107; color: #212529; }
		.status-approved { background-color: #28a745; color: white; }
		.status-rejected { background-color: #dc3545; color: white; }
		.status-published { background-color: #6f42c1; color: white; }
		
		.event-date {
			background: #6f42c1;
			border: 1px solid #5a32a3;
			color: white;
			text-align: center;
			padding: 15px;
			border-radius: 8px;
			min-width: 80px;
		}
		
		.event-date .day {
			font-size: 24px;
			font-weight: bold;
			line-height: 1;
		}
		
		.event-date .month {
			font-size: 12px;
			text-transform: uppercase;
			opacity: 0.9;
		}
		
		.event-info h4 {
			color: #333;
			font-weight: 600;
			margin-bottom: 8px;
		}
		
		.event-meta {
			color: #666;
			font-size: 14px;
			margin-bottom: 10px;
		}
		
		.event-meta i {
			margin-right: 5px;
			color: #999;
		}
		
		.event-description {
			color: #666;
			font-size: 14px;
			line-height: 1.5;
			margin-bottom: 15px;
		}
		
		.event-actions {
			display: flex;
			gap: 10px;
			flex-wrap: wrap;
		}
		
		.btn-sm {
			padding: 6px 12px;
			font-size: 12px;
		}
		
		.btn-primary {
			background-color: #6f42c1;
			border-color: #5a32a3;
			color: white !important;
		}
		
		.btn-primary:hover {
			background-color: #5a32a3;
			border-color: #4a2a8a;
			color: white !important;
		}
		
		.btn-primary:focus {
			background-color: #5a32a3;
			border-color: #4a2a8a;
			color: white !important;
		}
		
		.btn-primary:active {
			background-color: #4a2a8a;
			border-color: #3d2266;
			color: white !important;
		}
		
		.btn-success {
			background-color: #28a745;
			border-color: #1e7e34;
			color: white !important;
		}
		
		.btn-success:hover {
			background-color: #1e7e34;
			border-color: #155724;
			color: white !important;
		}
		
		.pagination .page-link {
			color: #6f42c1;
			border-color: #dee2e6;
		}
		
		.pagination .page-link:hover {
			color: #5a32a3;
			background-color: #f8f9fa;
			border-color: #6f42c1;
		}
		
		.pagination .page-item.active .page-link {
			background-color: #6f42c1;
			border-color: #6f42c1;
			color: white;
		}
		
		.pagination .page-item.disabled .page-link {
			color: #6c757d;
			background-color: #fff;
			border-color: #dee2e6;
		}
		
		.no-events {
			text-align: center;
			padding: 60px 20px;
			color: #666;
		}
		
		.no-events i {
			font-size: 48px;
			color: #ddd;
			margin-bottom: 20px;
		}
		
		.search-filter-bar {
			background: white;
			padding: 20px;
			border-radius: 8px;
			border: 1px solid #dee2e6;
			margin-bottom: 30px;
		}
		
		.search-filter-bar .form-group {
			margin-bottom: 0;
			padding-right: 10px;
		}
		
		.search-filter-bar .form-group:last-child {
			padding-right: 0;
		}
		
		.search-filter-bar .form-control,
		.search-filter-bar .btn {
			height: 40px;
			line-height: 1.5;
			width: 100%;
		}
		
		.search-filter-bar .row {
			margin-left: -10px;
			margin-right: -10px;
		}
		
		.search-filter-bar .row > [class*="col-"] {
			padding-left: 10px;
			padding-right: 10px;
		}
		
		.stats-card {
			background: #6f42c1;
			border: 1px solid #5a32a3;
			color: white;
			padding: 20px;
			border-radius: 8px;
			text-align: center;
		}
		
		.stats-card h3 {
			font-size: 32px;
			font-weight: bold;
			margin-bottom: 5px;
		}
		
		.stats-card p {
			margin: 0;
			opacity: 0.9;
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
								<a href="${pageContext.request.contextPath}/addNewEvent" class="ttr-material-button">
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
				<h4 class="breadcrumb-title">Quản lý Sự kiện</h4>
				<ul class="db-breadcrumb-list">
					<li><a href="${pageContext.request.contextPath}/home"><i class="fa fa-home"></i>Trang chủ</a></li>
					<li>Sự kiện</li>
					<li>Danh sách sự kiện</li>
				</ul>
			</div>	
			
			<!-- Success/Error Message Display -->
			<c:if test="${not empty message}">
				<div class="row m-b30">
					<div class="col-12">
						<div class="alert alert-${messageType} alert-dismissible fade show" role="alert" style="border-radius: 10px; border: none; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
							<div class="d-flex align-items-center">
								<c:choose>
									<c:when test="${messageType == 'success'}">
										<i class="fa fa-check-circle" style="font-size: 20px; color: #28a745; margin-right: 15px;"></i>
									</c:when>
									<c:when test="${messageType == 'danger'}">
										<i class="fa fa-exclamation-circle" style="font-size: 20px; color: #dc3545; margin-right: 15px;"></i>
									</c:when>
									<c:when test="${messageType == 'warning'}">
										<i class="fa fa-exclamation-triangle" style="font-size: 20px; color: #ffc107; margin-right: 15px;"></i>
									</c:when>
									<c:otherwise>
										<i class="fa fa-info-circle" style="font-size: 20px; color: #17a2b8; margin-right: 15px;"></i>
									</c:otherwise>
								</c:choose>
								<div>
									<strong>
										<c:choose>
											<c:when test="${messageType == 'success'}">Success!</c:when>
											<c:when test="${messageType == 'danger'}">Error!</c:when>
											<c:when test="${messageType == 'warning'}">Warning!</c:when>
											<c:otherwise>Info</c:otherwise>
										</c:choose>
									</strong>
									<br>
									<span style="font-size: 14px;">${message}</span>
								</div>
							</div>
							<button type="button" class="close" data-dismiss="alert" aria-label="Close">
								<span aria-hidden="true">&times;</span>
							</button>
						</div>
					</div>
				</div>
			</c:if>
			
			<!-- Statistics Cards -->
			<!-- <div class="row m-b30">
				<div class="col-lg-3 col-md-6 col-sm-6 col-12">
					<div class="stats-card">
						<h3>${totalEvents}</h3>
						<p>Total Events</p>
					</div>
				</div>
				<div class="col-lg-3 col-md-6 col-sm-6 col-12">
					<div class="stats-card">
						<h3>${publishedEvents}</h3>
						<p>Published</p>
					</div>
				</div>
				<div class="col-lg-3 col-md-6 col-sm-6 col-12">
					<div class="stats-card">
						<h3>${pendingEvents}</h3>
						<p>Pending</p>
					</div>
				</div>
				<div class="col-lg-3 col-md-6 col-sm-6 col-12">
					<div class="stats-card">
						<h3>${draftEvents}</h3>
						<p>Draft</p>
					</div>
				</div>
			</div> -->
			
			<!-- Search and Filter Bar -->
			<div class="search-filter-bar">
				<form method="get" action="listEvents" id="searchFilterForm">
					<div class="row">
						<div class="col-lg-5 col-md-5 col-sm-12">
							<div class="form-group">
								<input type="text" class="form-control" name="search" id="searchInput" 
									   placeholder="Tìm kiếm sự kiện theo tên, mô tả, hoặc địa điểm..." 
									   value="${searchTerm}">
							</div>
						</div>
						<div class="col-lg-2 col-md-2 col-sm-6 col-12">
							<div class="form-group">
								<select class="form-control" name="status" id="statusFilter">
									<option value="">Tất cả trạng thái</option>
									<option value="Draft" ${statusFilter == 'Draft' ? 'selected' : ''}>Bản nháp</option>
									<option value="Pending" ${statusFilter == 'Pending' ? 'selected' : ''}>Đang chờ</option>
									<option value="Approved" ${statusFilter == 'Approved' ? 'selected' : ''}>Đã duyệt</option>
									<option value="Rejected" ${statusFilter == 'Rejected' ? 'selected' : ''}>Từ chối</option>
									<option value="Published" ${statusFilter == 'Published' ? 'selected' : ''}>Đã công bố</option>
								</select>
							</div>
						</div>
						<div class="col-lg-2 col-md-2 col-sm-6 col-12">
							<div class="form-group">
								<button type="submit" class="btn btn-primary btn-block">
									<i class="fa fa-search"></i> Tìm kiếm
								</button>
							</div>
						</div>
						<div class="col-lg-3 col-md-3 col-sm-12">
							<div class="form-group">
								<a href="${pageContext.request.contextPath}/addNewEvent" class="btn btn-success btn-block">
									<i class="fa fa-plus"></i> Tạo sự kiện mới
								</a>
							</div>
						</div>
					</div>
					<!-- Clear Filters Row (only show when filters are active) -->
					<c:if test="${not empty searchTerm or not empty statusFilter}">
						<div class="row" style="margin-top: 10px;">
							<div class="col-lg-12">
								<div class="form-group">
									<a href="${pageContext.request.contextPath}/listEvents" class="btn btn-secondary">
										<i class="fa fa-refresh"></i> Xóa bộ lọc
									</a>
								</div>
							</div>
						</div>
					</c:if>
				</form>
			</div>
			
			<!-- Pending Approval Events Section -->
			<c:if test="${not empty pendingEvents}">
			<div class="row m-b30">
				<div class="col-lg-12">
					<div class="widget-box">
						<div class="wc-title">
							<h4>Sự kiện đang chờ phê duyệt</h4>
						</div>
						<div class="widget-inner">
							<c:forEach var="event" items="${pendingEvents}">
								<div class="card-courses-list admin-courses event-card">
									<div class="card-courses-media">
										<c:choose>
											<c:when test="${not empty event.image}">
												<img src="${pageContext.request.contextPath}/${event.image}" alt="${event.eventName}" style="width: 100%; height: 150px; object-fit: cover;">
											</c:when>
											<c:otherwise>
												<div style="background: #f0f0f0; height: 150px; display: flex; align-items: center; justify-content: center;">
													<i class="fa fa-calendar" style="font-size: 48px; color: #ccc;"></i>
												</div>
											</c:otherwise>
										</c:choose>
									</div>
									<div class="card-courses-full-dec">
										<div class="card-courses-title">
											<h4>${event.eventName}</h4>
											<span class="status-badge status-pending">Đang chờ duyệt</span>
										</div>
										<div class="card-courses-list-bx">
											<ul class="card-courses-view">
												<li>
													<h5>Bắt đầu</h5>
													<h4><fmt:formatDate value="${event.startDate}" pattern="dd/MM/yyyy HH:mm" /></h4>
												</li>
												<li>
													<h5>Kết thúc</h5>
													<h4><fmt:formatDate value="${event.endDate}" pattern="dd/MM/yyyy HH:mm" /></h4>
												</li>
												<li>
													<h5>Địa điểm</h5>
													<h4>${not empty event.location ? event.location : 'Chưa cập nhật'}</h4>
												</li>
											</ul>
										</div>
										<div class="row card-courses-dec">
											<div class="col-md-12">
												<div class="event-actions">
													<a href="viewEvent?eventId=${event.eventID}" class="btn btn-info btn-sm">
														<i class="fa fa-eye"></i> Xem chi tiết
													</a>
													<!-- Show edit button if: (Admin) OR (Club Leader created this event) -->
													<c:if test="${sessionScope.account.roleId == 4 or (sessionScope.account.roleId == 3 and sessionScope.account.userId == event.createdBy)}">
														<a href="editEvent?eventId=${event.eventID}" class="btn btn-warning btn-sm">
															<i class="fa fa-edit"></i> Chỉnh sửa
														</a>
													</c:if>
												</div>
											</div>
										</div>
									</div>
								</div>
							</c:forEach>
						</div>
					</div>
				</div>
			</div>
			</c:if>
			
			<div class="row">
				<!-- Events List -->
				<div class="col-lg-12 m-b30">
					<div class="widget-box">
						<div class="wc-title">
							<h4>Tất cả Sự kiện</h4>
						</div>
						<div class="widget-inner">
							<c:choose>
								<c:when test="${not empty events}">
									<div id="eventsContainer">
										<c:forEach var="event" items="${events}">
											<div class="card-courses-list admin-courses event-card" data-title="${event.eventName}" data-status="${event.status}" data-description="${event.description}">
												<div class="card-courses-media">
													<c:choose>
														<c:when test="${not empty event.image}">
															<img src="${pageContext.request.contextPath}/${event.image}" alt="${event.eventName}" style="width: 100%; height: 200px; object-fit: cover;">
															<!-- <div class="event-date" style="position: absolute; top: 10px; left: 10px; background: rgba(255,255,255,0.9); padding: 10px; border-radius: 5px;">
																<div class="day">
																	<fmt:formatDate value="${event.startDate}" pattern="dd" />
																</div>
																<div class="month">
																	<fmt:formatDate value="${event.startDate}" pattern="MMM" />
																</div>
															</div> -->
														</c:when>
														<c:otherwise>
															<div class="event-date">
																<div class="day">
																	<fmt:formatDate value="${event.startDate}" pattern="dd" />
																</div>
																<div class="month">
																	<fmt:formatDate value="${event.startDate}" pattern="MMM" />
																</div>
															</div>
														</c:otherwise>
													</c:choose>
												</div>
												<div class="card-courses-full-dec">
													<div class="card-courses-title">
														<h4>${event.eventName}</h4>
														<span class="status-badge status-${event.status.toLowerCase()}">${event.status}</span>
													</div>
													<div class="card-courses-list-bx">
														<ul class="card-courses-view">
															<li class="card-courses-user">
																<div class="card-courses-user-pic">
																	<i class="fa fa-calendar" style="font-size: 24px; color: #666;"></i>
																</div>
																<div class="card-courses-user-info">
																	<h5>Start Date</h5>
																	<h4><fmt:formatDate value="${event.startDate}" pattern="MMM dd, yyyy" /></h4>
																</div>
															</li>
															<li class="card-courses-categories">
																<h5>End Date</h5>
																<h4><fmt:formatDate value="${event.endDate}" pattern="MMM dd, yyyy" /></h4>
															</li>
															<li class="card-courses-review">
																<h5>Location</h5>
																<h4>${not empty event.location ? event.location : 'TBD'}</h4>
															</li>
															<li class="card-courses-stats">
																<h5>Capacity</h5>
																<h4>${event.capacity}</h4>
															</li>
															<li class="card-courses-price">
																<h5>Status</h5>
																<h4>${event.status}</h4>
															</li>
														</ul>
													</div>
													<div class="row card-courses-dec">
														<div class="col-md-12">
															<h6 class="m-b10">Mô tả sự kiện</h6>
															<p class="event-description">${not empty event.description ? event.description : 'Chưa có mô tả.'}</p>	
														</div>
														<div class="col-md-12">
															<div class="event-actions">
																<a href="viewEvent?eventId=${event.eventID}" class="btn btn-info btn-sm">
																	<i class="fa fa-eye"></i> Xem chi tiết
																</a>
																<!-- Show action buttons if: (Admin) OR (Club Leader created this event) -->
																<c:if test="${sessionScope.account.roleId == 4 or (sessionScope.account.roleId == 3 and sessionScope.account.userId == event.createdBy)}">
																	<a href="editEvent?eventId=${event.eventID}" class="btn btn-warning btn-sm">
																		<i class="fa fa-edit"></i> Chỉnh sửa
																	</a>
																	<c:if test="${event.status == 'Draft' or event.status == 'Pending'}">
																		<a href="publishEvent?eventId=${event.eventID}" class="btn btn-success btn-sm">
																			<i class="fa fa-check"></i> Công bố
																		</a>
																	</c:if>
																	<c:if test="${event.status == 'Upcoming' or event.status == 'Published'}">
																		<button type="button" class="btn btn-warning btn-sm" onclick="showCancelEventModal(${event.eventID})">
																			<i class="fa fa-times"></i> Hủy sự kiện
																		</button>
																	</c:if>
																	<a href="deleteEvent?eventId=${event.eventID}" class="btn btn-danger btn-sm" onclick="return confirm('Bạn có chắc chắn muốn xóa sự kiện này?')">
																		<i class="fa fa-trash"></i> Xóa
																	</a>
																</c:if>
															</div>
														</div>
													</div>
												</div>
											</div>
										</c:forEach>
									</div>
								</c:when>
								<c:otherwise>
										<div class="no-events">
										<i class="fa fa-calendar-times-o"></i>
										<h3>Không tìm thấy sự kiện</h3>
										<p>Hiện tại không có sự kiện nào để hiển thị.</p>
										<a href="${pageContext.request.contextPath}/addNewEvent" class="btn btn-primary">
											<i class="fa fa-plus"></i> Tạo sự kiện đầu tiên
										</a>
									</div>
								</c:otherwise>
							</c:choose>
							
							<!-- Pagination -->
							<c:if test="${totalPages > 1}">
								<div class="pagination-container" style="margin-top: 30px; text-align: center;">
									<nav aria-label="Events pagination">
										<ul class="pagination justify-content-center">
											<!-- Previous button -->
											<c:choose>
												<c:when test="${currentPage > 1}">
													<li class="page-item">
														<a class="page-link" href="listEvents?page=${currentPage - 1}&search=${searchTerm}&status=${statusFilter}">
															<i class="fa fa-chevron-left"></i> Trước
														</a>
													</li>
												</c:when>
												<c:otherwise>
													<li class="page-item disabled">
														<span class="page-link">
															<i class="fa fa-chevron-left"></i> Trước
														</span>
													</li>
												</c:otherwise>
											</c:choose>
											
											<!-- Page numbers -->
											<c:forEach begin="1" end="${totalPages}" var="i">
												<c:choose>
													<c:when test="${i == currentPage}">
														<li class="page-item active">
															<span class="page-link">${i}</span>
														</li>
													</c:when>
													<c:otherwise>
														<li class="page-item">
															<a class="page-link" href="listEvents?page=${i}&search=${searchTerm}&status=${statusFilter}">${i}</a>
														</li>
													</c:otherwise>
												</c:choose>
											</c:forEach>
											
											<!-- Next button -->
											<c:choose>
												<c:when test="${currentPage < totalPages}">
													<li class="page-item">
														<a class="page-link" href="listEvents?page=${currentPage + 1}&search=${searchTerm}&status=${statusFilter}">
															Sau <i class="fa fa-chevron-right"></i>
														</a>
													</li>
												</c:when>
												<c:otherwise>
													<li class="page-item disabled">
														<span class="page-link">
															Sau <i class="fa fa-chevron-right"></i>
														</span>
													</li>
												</c:otherwise>
											</c:choose>
										</ul>
									</nav>
									
									<!-- Pagination info -->
									<div class="pagination-info" style="margin-top: 15px; color: #666; font-size: 14px;">
										Hiển thị ${(currentPage - 1) * recordsPerPage + 1} đến ${currentPage * recordsPerPage > totalRecords ? totalRecords : currentPage * recordsPerPage} 
										trong tổng số ${totalRecords} sự kiện
										<c:if test="${not empty searchTerm or not empty statusFilter}">
											(kết quả đã lọc)
										</c:if>
									</div>
								</div>
							</c:if>
						</div>
					</div>
				</div>
				<!-- Events List END-->
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
    // Auto-submit form when status filter changes
    $('#statusFilter').on('change', function() {
        $('#searchFilterForm').submit();
    });
    
    // Auto-submit form when search input loses focus (after user stops typing)
    var searchTimeout;
    $('#searchInput').on('keyup', function() {
        clearTimeout(searchTimeout);
        var $form = $('#searchFilterForm');
        var $input = $(this);
        
        searchTimeout = setTimeout(function() {
            $form.submit();
        }, 1000); // Submit after 1 second of no typing
    });
    
    // Handle Enter key in search input
    $('#searchInput').on('keypress', function(e) {
        if (e.which === 13) { // Enter key
            e.preventDefault();
            clearTimeout(searchTimeout);
            $('#searchFilterForm').submit();
        }
    });
    
    // Initialize counter animation
    $('.counter').counterUp({
        delay: 10,
        time: 1000
    });
    
    // Add loading animation to action buttons
    $('.event-actions a').on('click', function() {
        var $btn = $(this);
        var originalText = $btn.html();
        $btn.html('<i class="fa fa-spinner fa-spin"></i> Loading...');
        
        // Reset button text after 3 seconds if still loading
        setTimeout(function() {
            $btn.html(originalText);
        }, 3000);
    });
    
    // Add loading state to search form
    $('#searchFilterForm').on('submit', function() {
        var $submitBtn = $(this).find('button[type="submit"]');
        var originalText = $submitBtn.html();
        $submitBtn.html('<i class="fa fa-spinner fa-spin"></i> Searching...');
        $submitBtn.prop('disabled', true);
        
        // Reset button if form doesn't submit (shouldn't happen, but just in case)
        setTimeout(function() {
            $submitBtn.html(originalText);
            $submitBtn.prop('disabled', false);
        }, 5000);
    });
});

// Cancel Event Modal Functions
function showCancelEventModal(eventId, eventName) {
    $('#cancelEventId').val(eventId);
    $('#cancelEventName').text(eventName);
    $('#cancelEventModal').modal('show');
}

function confirmCancelEvent() {
    var eventId = $('#cancelEventId').val();
    var eventName = $('#cancelEventName').text();
    
    // Show loading state
    $('#cancelConfirmBtn').html('<i class="fa fa-spinner fa-spin"></i> Cancelling...');
    $('#cancelConfirmBtn').prop('disabled', true);
    
    // Create form and submit
    var form = $('<form>', {
        'method': 'POST',
        'action': 'cancelEvent'
    });
    
    form.append($('<input>', {
        'type': 'hidden',
        'name': 'eventId',
        'value': eventId
    }));
    
    $('body').append(form);
    form.submit();
}
</script>

<!-- Cancel Event Confirmation Modal -->
<div class="modal fade" id="cancelEventModal" tabindex="-1" role="dialog" aria-labelledby="cancelEventModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header" style="background: linear-gradient(135deg, #ff6b6b, #ee5a24); border: none;">
                <h5 class="modal-title text-white" id="cancelEventModalLabel">
                    <i class="fa fa-exclamation-triangle"></i> Cancel Event
                </h5>
                <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body" style="padding: 30px;">
                <div class="text-center mb-4">
                    <div class="warning-icon" style="font-size: 48px; color: #ff6b6b; margin-bottom: 20px;">
                        <i class="fa fa-exclamation-triangle"></i>
                    </div>
                    <h4 style="color: #333; margin-bottom: 15px;">Are you sure you want to cancel this event?</h4>
                    <p style="color: #666; font-size: 16px; margin-bottom: 20px;">
                        You are about to cancel the event: <strong id="cancelEventName"></strong>
                    </p>
                    <div class="alert alert-warning" style="border-left: 4px solid #ff6b6b; background-color: #fff3cd; border-color: #ffeaa7;">
                        <i class="fa fa-info-circle"></i>
                        <strong>Important:</strong> This action will notify all registered participants about the event cancellation. 
                        This action cannot be undone.
                    </div>
                </div>
            </div>
            <div class="modal-footer" style="border: none; padding: 20px 30px; background-color: #f8f9fa;">
                <button type="button" class="btn btn-secondary" data-dismiss="modal" style="padding: 10px 25px;">
                    <i class="fa fa-times"></i> Keep Event
                </button>
                <button type="button" class="btn btn-danger" id="cancelConfirmBtn" onclick="confirmCancelEvent()" style="padding: 10px 25px; background: linear-gradient(135deg, #ff6b6b, #ee5a24); border: none;">
                    <i class="fa fa-times"></i> Yes, Cancel Event
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Hidden input to store event ID -->
<input type="hidden" id="cancelEventId" value="">

</body>

<!-- Student Club Management System - Events List Page -->
</html>
