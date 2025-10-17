<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<!-- Student Club Management System - Events List Page -->
<head>

	<!-- META ============================================= -->
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="keywords" content="" />
	<meta name="author" content="" />
	<meta name="robots" content="" />
	
	<!-- DESCRIPTION -->
	<meta name="description" content="Student Club Management System - View and manage all events" />
	
	<!-- OG -->
	<meta property="og:title" content="Student Club Management System" />
	<meta property="og:description" content="Student Club Management System - View and manage all events" />
	<meta property="og:image" content="" />
	<meta name="format-detection" content="telephone=no">
	
	<!-- FAVICONS ICON ============================================= -->
	<link rel="icon" href="error-404.html" type="image/x-icon" />
	<link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon.png" />

	<!-- PAGE TITLE HERE ============================================= -->
	<title>Events List - Student Club Management System</title>

	<!-- MOBILE SPECIFIC ============================================= -->
	<meta name="viewport" content="width=device-width, initial-scale=1">

	<!--[if lt IE 9]>
	<script src="assets/js/html5shiv.min.js"></script>
	<script src="assets/js/respond.min.js"></script>
	<![endif]-->

	<!-- All PLUGINS CSS ============================================= -->
	<link rel="stylesheet" type="text/css" href="assets/css/assets.css">
	<link rel="stylesheet" type="text/css" href="assets/vendors/calendar/fullcalendar.css">

	<!-- TYPOGRAPHY ============================================= -->
	<link rel="stylesheet" type="text/css" href="assets/css/typography.css">

	<!-- SHORTCODES ============================================= -->
	<link rel="stylesheet" type="text/css" href="assets/css/shortcodes/shortcodes.css">

	<!-- STYLESHEETS ============================================= -->
	<link rel="stylesheet" type="text/css" href="assets/css/style.css">
	<link rel="stylesheet" type="text/css" href="assets/css/dashboard.css">
	<link class="skin" rel="stylesheet" type="text/css" href="assets/css/color/color-1.css">
	
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
					<a href="index.html" class="ttr-logo" style="text-decoration: none;">
						<div style="display: flex; align-items: center; color: white;">
							<div style="margin-right: 10px; font-size: 24px;">🎓</div>
							<div>
								<div style="font-size: 20px; font-weight: bold; line-height: 1;">Student Club</div>
								<div style="font-size: 14px; opacity: 0.9;">Management System</div>
							</div>
						</div>
					</a>
				</div>
			</div>
			<!--logo end -->
			<div class="ttr-header-menu">
				<!-- header left menu start -->
				<ul class="ttr-header-navigation">
					<li>
						<a href="index.html" class="ttr-material-button ttr-submenu-toggle">DASHBOARD</a>
					</li>
					<li>
						<a href="#" class="ttr-material-button ttr-submenu-toggle">CLUBS <i class="fa fa-angle-down"></i></a>
						<div class="ttr-header-submenu">
							<ul>
								<li><a href="clubs.html">All Clubs</a></li>
								<li><a href="my-clubs.html">My Clubs</a></li>
								<li><a href="create-club.html">Create Club</a></li>
							</ul>
						</div>
					</li>
					<li>
						<a href="#" class="ttr-material-button ttr-submenu-toggle">EVENTS <i class="fa fa-angle-down"></i></a>
						<div class="ttr-header-submenu">
							<ul>
								<li><a href="listEvents">All Events</a></li>
								<li><a href="addNewEvent">Add Event</a></li>
								<li><a href="my-events.html">My Events</a></li>
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
						<a href="#" class="ttr-material-button ttr-submenu-toggle"><i class="fa fa-bell"></i></a>
						<div class="ttr-header-submenu noti-menu">
							<div class="ttr-notify-header">
								<span class="ttr-notify-text-top">9 New</span>
								<span class="ttr-notify-text">User Notifications</span>
							</div>
							<div class="noti-box-list">
								<ul>
									<li>
										<span class="notification-icon dashbg-gray">
											<i class="fa fa-check"></i>
										</span>
										<span class="notification-text">
											<span>Sneha Jogi</span> sent you a message.
										</span>
										<span class="notification-time">
											<a href="#" class="fa fa-close"></a>
											<span> 02:14</span>
										</span>
									</li>
									<li>
										<span class="notification-icon dashbg-yellow">
											<i class="fa fa-shopping-cart"></i>
										</span>
										<span class="notification-text">
											<a href="#">Your order is placed</a> sent you a message.
										</span>
										<span class="notification-time">
											<a href="#" class="fa fa-close"></a>
											<span> 7 Min</span>
										</span>
									</li>
									<li>
										<span class="notification-icon dashbg-red">
											<i class="fa fa-bullhorn"></i>
										</span>
										<span class="notification-text">
											<span>Your item is shipped</span> sent you a message.
										</span>
										<span class="notification-time">
											<a href="#" class="fa fa-close"></a>
											<span> 2 May</span>
										</span>
									</li>
									<li>
										<span class="notification-icon dashbg-green">
											<i class="fa fa-comments-o"></i>
										</span>
										<span class="notification-text">
											<a href="#">Sneha Jogi</a> sent you a message.
										</span>
										<span class="notification-time">
											<a href="#" class="fa fa-close"></a>
											<span> 14 July</span>
										</span>
									</li>
									<li>
										<span class="notification-icon dashbg-primary">
											<i class="fa fa-file-word-o"></i>
										</span>
										<span class="notification-text">
											<span>Sneha Jogi</span> sent you a message.
										</span>
										<span class="notification-time">
											<a href="#" class="fa fa-close"></a>
											<span> 15 Min</span>
										</span>
									</li>
								</ul>
							</div>
						</div>
					</li>
					<li>
						<a href="#" class="ttr-material-button ttr-submenu-toggle"><span class="ttr-user-avatar"><img alt="" src="assets/images/testimonials/pic3.jpg" width="32" height="32"></span></a>
						<div class="ttr-header-submenu">
							<ul>
								<li><a href="user-profile.html">My Profile</a></li>
								<li><a href="my-clubs.html">My Clubs</a></li>
								<li><a href="my-events.html">My Events</a></li>
								<li><a href="settings.html">Settings</a></li>
								<li><a href="login.html">Logout</a></li>
							</ul>
						</div>
					</li>
					<li class="ttr-hide-on-mobile">
						<a href="#" class="ttr-material-button"><i class="ti-layout-grid3-alt"></i></a>
						<div class="ttr-header-submenu ttr-extra-menu">
							<a href="clubs.html">
								<i class="fa fa-users"></i>
								<span>Clubs</span>
							</a>
							<a href="listEvents">
								<i class="fa fa-calendar"></i>
								<span>Events</span>
							</a>
							<a href="members.html">
								<i class="fa fa-user"></i>
								<span>Members</span>
							</a>
							<a href="reports.html">
								<i class="fa fa-bar-chart"></i>
								<span>Reports</span>
							</a>
							<a href="settings.html">
								<i class="fa fa-cog"></i>
								<span>Settings</span>
							</a>
							<a href="help.html">
								<i class="fa fa-question-circle"></i>
								<span>Help</span>
							</a>
						</div>
					</li>
				</ul>
				<!-- header right menu end -->
			</div>
			<!--header search panel start -->
			<div class="ttr-search-bar">
				<form class="ttr-search-form">
					<div class="ttr-search-input-wrapper">
						<input type="text" name="qq" placeholder="search something..." class="ttr-search-input">
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
				<a href="#" style="text-decoration: none;">
					<div style="display: flex; align-items: center; color: #333;">
						<div style="margin-right: 8px; font-size: 20px;">🎓</div>
						<div>
							<div style="font-size: 16px; font-weight: bold; line-height: 1;">Student Club</div>
							<div style="font-size: 12px; opacity: 0.8;">Management</div>
						</div>
					</div>
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
						<a href="index.html" class="ttr-material-button">
							<span class="ttr-icon"><i class="ti-home"></i></span>
		                	<span class="ttr-label">Dashboard</span>
		                </a>
		            </li>
					<li>
						<a href="clubs.html" class="ttr-material-button">
							<span class="ttr-icon"><i class="ti-layout-grid2"></i></span>
		                	<span class="ttr-label">Clubs</span>
		                </a>
		            </li>
					<li>
						<a href="listEvents" class="ttr-material-button">
							<span class="ttr-icon"><i class="ti-calendar"></i></span>
		                	<span class="ttr-label">Events</span>
		                </a>
		            </li>
					<li>
						<a href="members.html" class="ttr-material-button">
							<span class="ttr-icon"><i class="ti-user"></i></span>
		                	<span class="ttr-label">Members</span>
		                </a>
		            </li>
					<li>
						<a href="#" class="ttr-material-button">
							<span class="ttr-icon"><i class="ti-calendar"></i></span>
		                	<span class="ttr-label">Calendar</span>
		                	<span class="ttr-arrow-icon"><i class="fa fa-angle-down"></i></span>
		                </a>
		                <ul>
		                	<li>
		                		<a href="basic-calendar.html" class="ttr-material-button"><span class="ttr-label">Basic Calendar</span></a>
		                	</li>
		                	<li>
		                		<a href="list-view-calendar.html" class="ttr-material-button"><span class="ttr-label">List View</span></a>
		                	</li>
		                </ul>
		            </li>
					<li>
						<a href="reports.html" class="ttr-material-button">
							<span class="ttr-icon"><i class="ti-bar-chart"></i></span>
		                	<span class="ttr-label">Reports</span>
		                </a>
		            </li>
					<li>
						<a href="settings.html" class="ttr-material-button">
							<span class="ttr-icon"><i class="ti-settings"></i></span>
		                	<span class="ttr-label">Settings</span>
		                </a>
		            </li>
					<li>
						<a href="addNewEvent" class="ttr-material-button">
							<span class="ttr-icon"><i class="ti-calendar"></i></span>
		                	<span class="ttr-label">Add Event</span>
		                </a>
		            </li>
					<li>
						<a href="#" class="ttr-material-button">
							<span class="ttr-icon"><i class="ti-user"></i></span>
		                	<span class="ttr-label">My Profile</span>
		                	<span class="ttr-arrow-icon"><i class="fa fa-angle-down"></i></span>
		                </a>
		                <ul>
		                	<li>
		                		<a href="user-profile.html" class="ttr-material-button"><span class="ttr-label">User Profile</span></a>
		                	</li>
		                	<li>
		                		<a href="teacher-profile.html" class="ttr-material-button"><span class="ttr-label">Teacher Profile</span></a>
		                	</li>
		                </ul>
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
				<h4 class="breadcrumb-title">Events Management</h4>
				<ul class="db-breadcrumb-list">
					<li><a href="#"><i class="fa fa-home"></i>Dashboard</a></li>
					<li>Events</li>
					<li>All Events</li>
				</ul>
			</div>	
			
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
									   placeholder="Search events by title, description, or location..." 
									   value="${searchTerm}">
							</div>
						</div>
						<div class="col-lg-2 col-md-2 col-sm-6 col-12">
							<div class="form-group">
								<select class="form-control" name="status" id="statusFilter">
									<option value="">All Status</option>
									<option value="Draft" ${statusFilter == 'Draft' ? 'selected' : ''}>Draft</option>
									<option value="Pending" ${statusFilter == 'Pending' ? 'selected' : ''}>Pending</option>
									<option value="Approved" ${statusFilter == 'Approved' ? 'selected' : ''}>Approved</option>
									<option value="Rejected" ${statusFilter == 'Rejected' ? 'selected' : ''}>Rejected</option>
									<option value="Published" ${statusFilter == 'Published' ? 'selected' : ''}>Published</option>
								</select>
							</div>
						</div>
						<div class="col-lg-2 col-md-2 col-sm-6 col-12">
							<div class="form-group">
								<button type="submit" class="btn btn-primary btn-block">
									<i class="fa fa-search"></i> Search
								</button>
							</div>
						</div>
						<div class="col-lg-3 col-md-3 col-sm-12">
							<div class="form-group">
								<a href="addNewEvent" class="btn btn-success btn-block">
									<i class="fa fa-plus"></i> Add New Event
								</a>
							</div>
						</div>
					</div>
					<!-- Clear Filters Row (only show when filters are active) -->
					<c:if test="${not empty searchTerm or not empty statusFilter}">
						<div class="row" style="margin-top: 10px;">
							<div class="col-lg-12">
								<div class="form-group">
									<a href="listEvents" class="btn btn-secondary">
										<i class="fa fa-refresh"></i> Clear Filters
									</a>
								</div>
							</div>
						</div>
					</c:if>
				</form>
			</div>
			
			<div class="row">
				<!-- Events List -->
				<div class="col-lg-12 m-b30">
					<div class="widget-box">
						<div class="wc-title">
							<h4>All Events</h4>
						</div>
						<div class="widget-inner">
							<c:choose>
								<c:when test="${not empty events}">
									<div id="eventsContainer">
										<c:forEach var="event" items="${events}">
											<div class="card-courses-list admin-courses event-card" data-title="${event.eventName}" data-status="${event.status}" data-description="${event.description}">
												<div class="card-courses-media">
													<div class="event-date">
														<div class="day">
															<fmt:formatDate value="${event.eventDate}" pattern="dd" />
														</div>
														<div class="month">
															<fmt:formatDate value="${event.eventDate}" pattern="MMM" />
														</div>
													</div>
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
																	<h5>Event Date</h5>
																	<h4><fmt:formatDate value="${event.eventDate}" pattern="MMM dd, yyyy" /></h4>
																</div>
															</li>
															<li class="card-courses-categories">
																<h5>Time</h5>
																<h4><fmt:formatDate value="${event.eventDate}" pattern="HH:mm" /></h4>
															</li>
															<li class="card-courses-review">
																<h5>Club ID</h5>
																<h4>${event.clubID}</h4>
															</li>
															<li class="card-courses-stats">
																<h5>Status</h5>
																<h4>${event.status}</h4>
															</li>
															<li class="card-courses-price">
																<h5>Created</h5>
																<h4><fmt:formatDate value="${event.createdAt}" pattern="MMM dd" /></h4>
															</li>
														</ul>
													</div>
													<div class="row card-courses-dec">
														<div class="col-md-12">
															<h6 class="m-b10">Event Description</h6>
															<p class="event-description">${not empty event.description ? event.description : 'No description provided.'}</p>	
														</div>
														<div class="col-md-12">
															<div class="event-actions">
																<a href="viewEvent?eventId=${event.eventID}" class="btn btn-info btn-sm">
																	<i class="fa fa-eye"></i> View Details
																</a>
																<a href="editEvent?eventId=${event.eventID}" class="btn btn-warning btn-sm">
																	<i class="fa fa-edit"></i> Edit
																</a>
																<c:if test="${event.status == 'Draft' or event.status == 'Pending'}">
																	<a href="publishEvent?eventId=${event.eventID}" class="btn btn-success btn-sm">
																		<i class="fa fa-check"></i> Publish
																	</a>
																</c:if>
																<c:if test="${event.status == 'Published'}">
																	<a href="unpublishEvent?eventId=${event.eventID}" class="btn btn-secondary btn-sm">
																		<i class="fa fa-pause"></i> Unpublish
																	</a>
																</c:if>
																<a href="deleteEvent?eventId=${event.eventID}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this event?')">
																	<i class="fa fa-trash"></i> Delete
																</a>
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
										<h3>No Events Found</h3>
										<p>There are no events to display at the moment.</p>
										<a href="addNewEvent" class="btn btn-primary">
											<i class="fa fa-plus"></i> Create Your First Event
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
															<i class="fa fa-chevron-left"></i> Previous
														</a>
													</li>
												</c:when>
												<c:otherwise>
													<li class="page-item disabled">
														<span class="page-link">
															<i class="fa fa-chevron-left"></i> Previous
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
															Next <i class="fa fa-chevron-right"></i>
														</a>
													</li>
												</c:when>
												<c:otherwise>
													<li class="page-item disabled">
														<span class="page-link">
															Next <i class="fa fa-chevron-right"></i>
														</span>
													</li>
												</c:otherwise>
											</c:choose>
										</ul>
									</nav>
									
									<!-- Pagination info -->
									<div class="pagination-info" style="margin-top: 15px; color: #666; font-size: 14px;">
										Showing ${(currentPage - 1) * recordsPerPage + 1} to ${currentPage * recordsPerPage > totalRecords ? totalRecords : currentPage * recordsPerPage} 
										of ${totalRecords} events
										<c:if test="${not empty searchTerm or not empty statusFilter}">
											(filtered results)
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
<script src="assets/js/jquery.min.js"></script>
<script src="assets/vendors/bootstrap/js/popper.min.js"></script>
<script src="assets/vendors/bootstrap/js/bootstrap.min.js"></script>
<script src="assets/vendors/bootstrap-select/bootstrap-select.min.js"></script>
<script src="assets/vendors/bootstrap-touchspin/jquery.bootstrap-touchspin.js"></script>
<script src="assets/vendors/magnific-popup/magnific-popup.js"></script>
<script src="assets/vendors/counter/waypoints-min.js"></script>
<script src="assets/vendors/counter/counterup.min.js"></script>
<script src="assets/vendors/imagesloaded/imagesloaded.js"></script>
<script src="assets/vendors/masonry/masonry.js"></script>
<script src="assets/vendors/masonry/filter.js"></script>
<script src="assets/vendors/owl-carousel/owl.carousel.js"></script>
<script src='assets/vendors/scroll/scrollbar.min.js'></script>
<script src="assets/js/functions.js"></script>
<script src="assets/vendors/chart/chart.min.js"></script>
<script src="assets/js/admin.js"></script>
<script src='assets/vendors/switcher/switcher.js'></script>

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
</script>
</body>

<!-- Student Club Management System - Events List Page -->
</html>
