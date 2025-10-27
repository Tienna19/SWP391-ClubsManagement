<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<!-- Student Club Management System - Edit Event Page -->
<head>

	<!-- META ============================================= -->
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="keywords" content="" />
	<meta name="author" content="" />
	<meta name="robots" content="" />
	
	<!-- DESCRIPTION -->
	<meta name="description" content="Student Club Management System - Manage your clubs and events efficiently" />
	
	<!-- OG -->
	<meta property="og:title" content="Student Club Management System" />
	<meta property="og:description" content="Student Club Management System - Manage your clubs and events efficiently" />
	<meta property="og:image" content="" />
	<meta name="format-detection" content="telephone=no">
	
	<!-- FAVICONS ICON ============================================= -->
	<link rel="icon" href="error-404.html" type="image/x-icon" />
	<link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon.png" />

	<!-- PAGE TITLE HERE ============================================= -->
	<title>Edit Event - Student Club Management System</title>

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
								<li><a href="events.html">All Events</a></li>
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
							<a href="events.html">
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
				<!-- <div class="ttr-sidebar-pin-button" title="Pin/Unpin Menu">
					<i class="material-icons ttr-fixed-icon">gps_fixed</i>
					<i class="material-icons ttr-not-fixed-icon">gps_not_fixed</i>
				</div> -->
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
						<a href="events.html" class="ttr-material-button">
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
				<h4 class="breadcrumb-title">Edit Event</h4>
				<ul class="db-breadcrumb-list">
					<li><a href="#"><i class="fa fa-home"></i>Dashboard</a></li>
					<li>Events</li>
					<li>Edit Event</li>
				</ul>
			</div>	
			<div class="row">
				<!-- Your Profile Views Chart -->
				<div class="col-lg-12 m-b30">
					<div class="widget-box">
						<div class="wc-title">
							<h4>Edit Event: ${event.eventName}</h4>
						</div>
						<div class="widget-inner">
							<form class="edit-profile m-b30" id="editEventForm" action="editEvent" method="post" novalidate>
								<input type="hidden" name="eventId" value="${event.eventID}">
								<div class="row">
									<div class="col-12">
										<div class="ml-auto">
											<h3>1. Basic Information</h3>
										</div>
									</div>
									<div class="form-group col-12">
										<label class="col-form-label">Event Title <span class="text-danger">*</span></label>
										<div>
											<input class="form-control" type="text" name="eventName" id="eventTitle" required maxlength="200" placeholder="Enter event title" value="${not empty param.eventName ? param.eventName : event.eventName}">
											<div class="text-danger" id="eventTitleError"></div>
										</div>
									</div>
									<div class="form-group col-6">
										<label class="col-form-label">Club <span class="text-danger">*</span></label>
										<div>
											<select class="form-control" name="clubId" id="clubId" required>
												<option value="">Select a club</option>
												<c:forEach var="club" items="${clubs}">
													<option value="${club.clubId}" ${(not empty param.clubId ? param.clubId : event.clubID) == club.clubId ? 'selected' : ''}>
														${club.clubName}
													</option>
												</c:forEach>
											</select>
											<div class="text-danger" id="clubIdError"></div>
										</div>
									</div>
									<div class="form-group col-6">
										<label class="col-form-label">Status</label>
										<div>
											<select class="form-control" name="status" id="eventStatus">
												<option value="Draft" ${(not empty param.status ? param.status : event.status) == 'Draft' ? 'selected' : ''}>Draft</option>
												<option value="Published" ${(not empty param.status ? param.status : event.status) == 'Published' ? 'selected' : ''}>Published</option>
												<option value="Upcoming" ${(not empty param.status ? param.status : event.status) == 'Upcoming' ? 'selected' : ''}>Upcoming</option>
											</select>
										</div>
									</div>
									<div class="seperator"></div>
									
									<div class="col-12 m-t20">
										<div class="ml-auto m-b5">
											<h3>2. Event Details</h3>
										</div>
									</div>
									<div class="form-group col-12">
										<label class="col-form-label">Description</label>
										<div>
											<textarea class="form-control" name="description" id="eventDescription" rows="4" maxlength="1000" placeholder="Enter event description">${not empty param.description ? param.description : event.description}</textarea>
										</div>
									</div>
									<div class="form-group col-6">
										<label class="col-form-label">Location <span class="text-danger">*</span></label>
										<div>
											<input class="form-control" type="text" name="location" id="eventLocation" maxlength="300" placeholder="Enter event location" value="${not empty param.location ? param.location : event.location}" required>
											<div class="text-danger" id="locationError"></div>
										</div>
									</div>
									<div class="form-group col-6">
										<label class="col-form-label">Capacity <span class="text-danger">*</span></label>
										<div>
											<input class="form-control" type="number" name="capacity" id="eventCapacity" min="1" max="1000" placeholder="Enter capacity" value="${not empty param.capacity ? param.capacity : event.capacity}" required>
											<div class="text-danger" id="capacityError"></div>
										</div>
									</div>
									<div class="seperator"></div>
									
									<div class="col-12 m-t20">
										<div class="ml-auto m-b5">
											<h3>3. Date & Time</h3>
										</div>
									</div>
									<div class="form-group col-6">
										<label class="col-form-label">Start Date & Time <span class="text-danger">*</span></label>
										<div>
											<input class="form-control" type="datetime-local" name="startDate" id="startTime" required value="${not empty param.startDate ? param.startDate : event.startDate}">
											<div class="text-danger" id="startTimeError"></div>
										</div>
									</div>
									<div class="form-group col-6">
										<label class="col-form-label">End Date & Time <span class="text-danger">*</span></label>
										<div>
											<input class="form-control" type="datetime-local" name="endDate" id="endTime" required value="${not empty param.endDate ? param.endDate : event.endDate}">
											<div class="text-danger" id="endTimeError"></div>
										</div>
									</div>
									<div class="col-12 m-t20">
										<div class="ml-auto m-b5">
											<h3>4. Registration Period</h3>
										</div>
									</div>
									<div class="form-group col-6">
										<label class="col-form-label">Registration Start</label>
										<div>
											<input class="form-control" type="datetime-local" name="registrationStart" id="regStartTime" value="${not empty param.registrationStart ? param.registrationStart : event.registrationStart}">
											<div class="text-danger" id="regStartTimeError"></div>
										</div>
									</div>
									<div class="form-group col-6">
										<label class="col-form-label">Registration End</label>
										<div>
											<input class="form-control" type="datetime-local" name="registrationEnd" id="regEndTime" value="${not empty param.registrationEnd ? param.registrationEnd : event.registrationEnd}">
											<div class="text-danger" id="regEndTimeError"></div>
										</div>
									</div>
									<div class="col-12">
										<div class="alert alert-info">
											<i class="fa fa-info-circle"></i> <strong>Note:</strong> Event date must be at least 3 days from today.
										</div>
									</div>
									<div class="col-12 m-t20">
										<button type="submit" class="btn btn-primary m-r5"><i class="fa fa-save"></i> Update Event</button>
										<button type="reset" class="btn btn-secondary"><i class="fa fa-refresh"></i> Reset Form</button>
										<a href="listEvents" class="btn btn-outline-secondary"><i class="fa fa-arrow-left"></i> Back to Events</a>
									</div>
								</div>
							</form>
							<!-- Display success/error messages if any at the bottom of the form -->
							<c:if test="${not empty message}">
								<div class="alert alert-${messageType} alert-dismissible fade show" role="alert">
									${message}
									<button type="button" class="close" data-dismiss="alert" aria-label="Close">
										<span aria-hidden="true">&times;</span>
									</button>
								</div>
							</c:if>
						</div>
					</div>
				</div>
				<!-- Your Profile Views Chart END-->
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
    // Form validation and submission
    $('#editEventForm').on('submit', function(e) {
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
            $('#eventTitleError').text('Event title is required');
        } else {
            $('#eventTitle').removeClass('is-invalid');
            $('#eventTitleError').text('');
        }
    });

    $('#clubId').on('change blur', function() {
        if (!$(this).val()) {
            $('#clubId').addClass('is-invalid');
            $('#clubIdError').text('Please select a club');
        } else {
            $('#clubId').removeClass('is-invalid');
            $('#clubIdError').text('');
        }
    });

    $('#eventLocation').on('input blur', function() {
        if (!$(this).val().trim()) {
            $('#eventLocation').addClass('is-invalid');
            $('#locationError').text('Location is required');
        } else {
            $('#eventLocation').removeClass('is-invalid');
            $('#locationError').text('');
        }
    });

    $('#eventCapacity').on('input blur', function() {
        var capacity = parseInt($(this).val());
        if (!$(this).val() || capacity <= 0) {
            $('#eventCapacity').addClass('is-invalid');
            $('#capacityError').text('Capacity must be greater than 0');
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
        $('#eventTitleError').text('Event title is required');
        isValid = false;
    } else {
        $('#eventTitle').removeClass('is-invalid');
        $('#eventTitleError').text('');
    }
    
    if (!$('#clubId').val()) {
        $('#clubId').addClass('is-invalid');
        $('#clubIdError').text('Please select a club');
        isValid = false;
    } else {
        $('#clubId').removeClass('is-invalid');
        $('#clubIdError').text('');
    }
    
    if (!$('#eventLocation').val().trim()) {
        $('#eventLocation').addClass('is-invalid');
        $('#locationError').text('Location is required');
        isValid = false;
    } else {
        $('#eventLocation').removeClass('is-invalid');
        $('#locationError').text('');
    }
    
    var capacity = parseInt($('#eventCapacity').val());
    if (!$('#eventCapacity').val() || capacity <= 0) {
        $('#eventCapacity').addClass('is-invalid');
        $('#capacityError').text('Capacity must be greater than 0');
        isValid = false;
    } else {
        $('#eventCapacity').removeClass('is-invalid');
        $('#capacityError').text('');
    }
    
    if (!$('#startTime').val()) {
        $('#startTime').addClass('is-invalid');
        $('#startTimeError').text('Start date is required');
        isValid = false;
    } else {
        // Check event date >= today + 3 days
        var eventDate = new Date($('#startTime').val());
        var now = new Date();
        var minDate = new Date(now.getFullYear(), now.getMonth(), now.getDate());
        minDate.setDate(minDate.getDate() + 3);

        if (eventDate < minDate) {
            $('#startTime').addClass('is-invalid');
            $('#startTimeError').text('Start date must be at least 3 days from today');
            isValid = false;
        } else {
            $('#startTime').removeClass('is-invalid');
            $('#startTimeError').text('');
        }
    }
    
    if (!$('#endTime').val()) {
        $('#endTime').addClass('is-invalid');
        $('#endTimeError').text('End date is required');
        isValid = false;
    } else {
        var endDate = new Date($('#endTime').val());
        var startDate = new Date($('#startTime').val());
        
        if (endDate <= startDate) {
            $('#endTime').addClass('is-invalid');
            $('#endTimeError').text('End date must be after start date');
            isValid = false;
        } else {
            $('#endTime').removeClass('is-invalid');
            $('#endTimeError').text('');
        }
    }
    
    // Validate registration dates if provided
    if ($('#regStartTime').val() || $('#regEndTime').val()) {
        var startDate = new Date($('#startTime').val());
        var regStart = $('#regStartTime').val() ? new Date($('#regStartTime').val()) : null;
        var regEnd = $('#regEndTime').val() ? new Date($('#regEndTime').val()) : null;
        
        if (regStart && regStart >= startDate) {
            $('#regStartTime').addClass('is-invalid');
            $('#regStartTimeError').text('Registration start must be before event start date');
            isValid = false;
        } else {
            $('#regStartTime').removeClass('is-invalid');
            $('#regStartTimeError').text('');
        }
        
        if (regEnd && regEnd >= startDate) {
            $('#regEndTime').addClass('is-invalid');
            $('#regEndTimeError').text('Registration end must be before event start date');
            isValid = false;
        } else {
            $('#regEndTime').removeClass('is-invalid');
            $('#regEndTimeError').text('');
        }
        
        // Cross-validation: reg start should be before reg end
        if (regStart && regEnd && regStart >= regEnd) {
            $('#regEndTime').addClass('is-invalid');
            $('#regEndTimeError').text('Registration end must be after registration start');
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
        $('#startTimeError').text('Start date must be at least 3 days from today');
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
        $('#endTimeError').text('End date must be after start date');
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
    var regStart = $('#regStartTime').val() ? new Date($('#regStartTime').val()) : null;
    var regEnd = $('#regEndTime').val() ? new Date($('#regEndTime').val()) : null;
    
    // Validate registration start
    if (regStart) {
        if (regStart >= startDate) {
            $('#regStartTime').addClass('is-invalid');
            $('#regStartTimeError').text('Registration start must be before event start date');
        } else {
            $('#regStartTime').removeClass('is-invalid');
            $('#regStartTimeError').text('');
        }
    }
    
    // Validate registration end
    if (regEnd) {
        if (regEnd >= startDate) {
            $('#regEndTime').addClass('is-invalid');
            $('#regEndTimeError').text('Registration end must be before event start date');
        } else {
            $('#regEndTime').removeClass('is-invalid');
            $('#regEndTimeError').text('');
        }
    }
    
    // Cross-validation: reg start should be before reg end
    if (regStart && regEnd && regStart >= regEnd) {
        $('#regEndTime').addClass('is-invalid');
        $('#regEndTimeError').text('Registration end must be after registration start');
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
    $('#editEventForm').before(alertHtml);
    
    // Auto-hide after 5 seconds for success messages
    if (type === 'success') {
        setTimeout(function() {
            $('.alert').fadeOut();
        }, 5000);
    }
}
</script>
</body>

<!-- Student Club Management System - Edit Event Page -->
</html>
