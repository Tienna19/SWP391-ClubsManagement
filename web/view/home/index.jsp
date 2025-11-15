<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">

<head>

	<!-- META ============================================= -->
	<meta charset="utf-8">
	<!-- Simple Error Suppression -->
	<script>
		// Suppress browser extension errors
		(function() {
			'use strict';
			
			const originalError = console.error;
			const originalWarn = console.warn;
			
			console.error = function() {
				const message = Array.prototype.join.call(arguments, ' ');
				if (message.includes('runtime.lastError') || 
					message.includes('message port closed') ||
					message.includes('extension')) {
					return;
				}
				originalError.apply(console, arguments);
			};
			
			console.warn = function() {
				const message = Array.prototype.join.call(arguments, ' ');
				if (message.includes('runtime.lastError') || 
					message.includes('message port closed') ||
					message.includes('extension')) {
					return;
				}
				originalWarn.apply(console, arguments);
			};
			
		})();
	</script>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="keywords" content="" />
	<meta name="author" content="" />
	<meta name="robots" content="" />
	
	<!-- DESCRIPTION -->
	<meta name="description" content="StuClubManagement : Student Club & Event Management Platform" />
	
	<!-- OG -->
	<meta property="og:title" content="StuClubManagement : Student Club & Event Management Platform" />
	<meta property="og:description" content="StuClubManagement : Student Club & Event Management Platform" />
	<meta property="og:image" content="" />
	<meta name="format-detection" content="telephone=no">
	
	<!-- FAVICONS ICON ============================================= -->
	<link rel="icon" href="assets/images/favicon.ico" type="image/x-icon" />
	<link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon.png" />
	
	<!-- PAGE TITLE HERE ============================================= -->
	<title>StuClubManagement - Student Club & Event Management</title>
	
	<!-- MOBILE SPECIFIC ============================================= -->
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
	<!--[if lt IE 9]>
	<script src="assets/js/html5shiv.min.js"></script>
	<script src="assets/js/respond.min.js"></script>
	<![endif]-->
	
	<!-- All PLUGINS CSS ============================================= -->
	<link rel="stylesheet" type="text/css" href="assets/css/assets.css">
	
	<!-- TYPOGRAPHY ============================================= -->
	<link rel="stylesheet" type="text/css" href="assets/css/typography.css">
	
	<!-- SHORTCODES ============================================= -->
	<link rel="stylesheet" type="text/css" href="assets/css/shortcodes/shortcodes.css">
	
	<!-- STYLESHEETS ============================================= -->
	<link rel="stylesheet" type="text/css" href="assets/css/style.css">
	<link class="skin" rel="stylesheet" type="text/css" href="assets/css/color/color-1.css">
	
	<!-- Custom Styles for StuClub Manager -->
	<style>
		:root {
			--primary: #5E35B1;
			--primary-dark: #4527A0;
			--accent: #F8B500;
			--bg-soft: #f6f7fb;
		}
		body {
			background: var(--bg-soft);
		}
		.hero {
			position: relative;
			padding: 120px 0 100px;
			background: linear-gradient(120deg, rgba(94,53,177,1) 0%, rgba(63,81,181,1) 65%, rgba(3,155,229,1) 100%);
			color: #fff;
			overflow: hidden;
			border-bottom-left-radius: 60px;
			border-bottom-right-radius: 60px;
		}
		.hero::before,
		.hero::after {
			content: "";
			position: absolute;
			border-radius: 50%;
			background: rgba(255,255,255,0.12);
			filter: blur(0);
		}
		.hero::before {
			width: 420px;
			height: 420px;
			top: -120px;
			left: -90px;
			background: radial-gradient(circle, rgba(255,255,255,0.22) 0%, rgba(255,255,255,0) 70%);
		}
		.hero::after {
			width: 360px;
			height: 360px;
			right: -100px;
			bottom: -140px;
			background: radial-gradient(circle, rgba(255,255,255,0.18) 0%, rgba(255,255,255,0) 65%);
		}
		.hero .container {
			position: relative;
			z-index: 1;
		}
		.hero-title {
                    color: #ffffff;
			font-size: 52px;
			font-weight: 800;
			margin-bottom: 20px;
		}
		.hero-subtitle {
			font-size: 18px;
			color: rgba(255,255,255,0.8);
			margin-bottom: 40px;
		}
		.search-wrap {
			max-width: 620px;
			margin: 0 auto;
			background: rgba(255,255,255,0.12);
			padding: 12px;
			border-radius: 60px;
			backdrop-filter: blur(10px);
			box-shadow: 0 20px 40px rgba(22,30,84,0.25);
		}
		.search-wrap .form-control {
			border: none;
			border-radius: 40px;
			padding: 16px 24px;
			font-size: 16px;
		}
		.search-wrap .btn {
			background: var(--accent);
			color: #1d1748;
			font-weight: 600;
			padding: 12px 28px;
			border-radius: 40px;
		}
		.metrics-row {
			margin-top: 60px;
		}
		.metric-card {
			background: rgba(255,255,255,0.14);
			border-radius: 24px;
			padding: 28px;
			color: #fff;
			box-shadow: 0 25px 45px rgba(10,24,82,0.25);
			text-align: center;
			transition: transform 0.25s ease;
		}
		.metric-card:hover {
			transform: translateY(-6px);
		}
		.metric-icon {
			width: 62px;
			height: 62px;
			margin: 0 auto 16px;
			border-radius: 18px;
			background: rgba(255,255,255,0.18);
			display: flex;
			align-items: center;
			justify-content: center;
			font-size: 28px;
		}
		.metric-number {
			font-size: 34px;
			font-weight: 700;
			margin-bottom: 6px;
		}
		.metric-label {
			color: rgba(255,255,255,0.75);
			font-size: 14px;
		}
		.section-title {
			margin-bottom: 18px;
			font-weight: 700;
			color: #2a274d;
		}
		.section-subtitle {
			color: #667094;
			margin-bottom: 40px;
		}
		.club-card {
			background: #fff;
			border-radius: 22px;
			box-shadow: 0 20px 35px rgba(31,43,90,0.1);
			overflow: hidden;
			transition: transform 0.25s ease, box-shadow 0.25s ease;
		}
		.club-card:hover {
			transform: translateY(-6px);
			box-shadow: 0 28px 55px rgba(31,43,90,0.16);
		}
		.club-card .action-box img {
			height: 200px;
			object-fit: cover;
			width: 100%;
		}
		.club-card .btn {
			border-radius: 40px;
			padding: 8px 20px;
			font-weight: 600;
		}
		.event-card {
			background: #fff;
			border-radius: 20px;
			box-shadow: 0 20px 32px rgba(31,43,90,0.1);
			overflow: hidden;
			height: 100%;
			display: flex;
			flex-direction: column;
		}
		.event-card img {
			height: 190px;
			object-fit: cover;
		}
		.event-card .info-bx {
			flex: 1;
		}
		.event-card .badge {
			border-radius: 999px;
			padding: 6px 14px;
			font-weight: 600;
			font-size: 12px;
		}
		.join-section {
			background: linear-gradient(135deg, rgba(67,147,255,1) 0%, rgba(94,53,177,1) 80%);
			border-radius: 26px;
			padding: 60px 40px;
			color: #fff;
			box-shadow: 0 30px 50px rgba(18,30,76,0.3);
			position: relative;
			overflow: hidden;
		}
		.join-section::before {
			content: "";
			position: absolute;
			inset: 0;
			background: radial-gradient(circle at 15% 20%, rgba(255,255,255,0.2), transparent 60%);
		}
		.join-section .btn {
			background: #fff;
			color: #4527A0;
			font-weight: 700;
			padding: 12px 28px;
			border-radius: 40px;
			box-shadow: 0 20px 38px rgba(17, 33, 100, 0.25);
		}
	</style>
	
	<!-- REVOLUTION SLIDER CSS ============================================= -->
	<link rel="stylesheet" type="text/css" href="assets/vendors/revolution/css/layers.css">
	<link rel="stylesheet" type="text/css" href="assets/vendors/revolution/css/settings.css">
	<link rel="stylesheet" type="text/css" href="assets/vendors/revolution/css/navigation.css">
	<!-- REVOLUTION SLIDER END -->	
</head>
<body id="bg">
<div class="page-wraper">
<div id="loading-icon-bx"></div>
<%@ include file="/view/layout/header.jsp" %>
    <!-- Content -->
    <div class="page-content bg-white">
        <!-- Main Slider -->
        <section class="hero">
            <div class="container">
                <div class="text-center">
                    <h1 class="hero-title">StuClubManagement</h1>
                    <p class="hero-subtitle">Giải pháp toàn diện cho quản lý câu lạc bộ và sự kiện</p>
                    <form class="search-wrap mx-auto">
                        <div class="input-group">
                            <input type="text" class="form-control" placeholder="Bạn muốn tìm CLB hoặc sự kiện nào hôm nay?">
                            <button class="btn" type="submit">Search</button>
                        </div>
                    </form>
                </div>
                <div class="row metrics-row mt-5">
                    <div class="col-md-4 col-sm-6 mb-3">
                        <div class="metric-card">
                            <div class="metric-icon"><i class="ti-user"></i></div>
                            <div class="metric-number">${totalClubs != null ? totalClubs : 50}+</div>
                            <div class="metric-label">CLB đang hoạt động</div>
                        </div>
                    </div>
                    <div class="col-md-4 col-sm-6 mb-3">
                        <div class="metric-card">
                            <div class="metric-icon"><i class="ti-calendar"></i></div>
                            <div class="metric-number">${totalEvents != null ? totalEvents : 200}+</div>
                            <div class="metric-label">Sự kiện được quản lí</div>
                        </div>
                    </div>
                    <div class="col-md-4 col-sm-12 mb-3">
                        <div class="metric-card">
                            <div class="metric-icon"><i class="ti-heart"></i></div>
                            <div class="metric-number">1000+</div>
                            <div class="metric-label">Thành viên hài lòng</div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- Main Slider -->
		<div class="content-block">
            <!-- Featured Clubs -->
			<div class="section-area section-sp2 popular-courses-bx">
                <div class="container">
					<div class="row">
						<div class="col-md-12 heading-bx left">
							<h2 class="title-head">Các CLB <span>Nổi Bật</span></h2>
							<p class="section-subtitle">Khám phá cộng đồng năng động trong hệ thống StuClubManagement</p>
						</div>
					</div>
					<div class="row">
					<div class="courses-carousel owl-carousel owl-btn-1 col-12 p-lr0">
						<c:choose>
							<c:when test="${not empty featuredClubs}">
								<c:forEach var="club" items="${featuredClubs}" varStatus="status">
									<c:set var="clubLogo" value="" />
									<c:if test="${not empty club.logo}">
										<c:set var="rawLogo" value="${club.logo}" />
										<c:set var="normalizedLogo" value="${fn:replace(rawLogo, '\\\\', '/')}" />
										<c:choose>
											<c:when test="${fn:startsWith(normalizedLogo, 'http')}">
												<c:set var="clubLogo" value="${normalizedLogo}" />
											</c:when>
											<c:when test="${fn:startsWith(normalizedLogo, '/')}">
												<c:set var="clubLogo" value="${pageContext.request.contextPath}${normalizedLogo}" />
											</c:when>
											<c:when test="${fn:contains(normalizedLogo, '/web/')}">
												<c:set var="relativeLogo" value="${fn:substringAfter(normalizedLogo, '/web/')}" />
												<c:if test="${not fn:startsWith(relativeLogo, '/')}">
													<c:set var="relativeLogo" value="/${relativeLogo}" />
												</c:if>
												<c:set var="clubLogo" value="${pageContext.request.contextPath}${relativeLogo}" />
											</c:when>
											<c:when test="${fn:contains(normalizedLogo, '/assets/') or fn:startsWith(normalizedLogo, 'assets/')}">
												<c:set var="relativeLogo" value="${normalizedLogo}" />
												<c:if test="${fn:contains(relativeLogo, '/assets/')}">
													<c:set var="relativeLogo" value="${fn:substringAfter(relativeLogo, '/assets/')}" />
													<c:set var="relativeLogo" value="/assets/${relativeLogo}" />
												</c:if>
												<c:if test="${fn:startsWith(relativeLogo, 'assets/')}">
													<c:set var="relativeLogo" value="/${relativeLogo}" />
												</c:if>
												<c:set var="clubLogo" value="${pageContext.request.contextPath}${relativeLogo}" />
											</c:when>
											<c:otherwise>
												<c:set var="clubLogo" value="${pageContext.request.contextPath}/${normalizedLogo}" />
											</c:otherwise>
										</c:choose>
									</c:if>
									<c:if test="${empty clubLogo}">
										<c:set var="clubLogo" value="assets/images/courses/pic${(status.index % 4) + 1}.jpg" />
									</c:if>
									<div class="item">
										<div class="club-card">
											<div class="action-box">
												<img src="${clubLogo}" alt="${club.clubName != null ? club.clubName : 'Club'}" loading="lazy">
											</div>
											<div class="info-bx text-center">
												<h5><a href="clubDetail?clubId=${club.clubId}">${club.clubName != null ? club.clubName : 'Unknown Club'}</a></h5>
												<span><i class="fa fa-tag mr-1"></i>${club.clubTypes != null ? club.clubTypes : 'N/A'}</span>
											</div>
											<div class="cours-more-info">
												<div class="review">
													<span><i class="ti-calendar"></i> 
														<c:choose>
															<c:when test="${club.createdAt != null}">
																<fmt:formatDate value="${club.createdAt}" pattern="MMM yyyy"/>
															</c:when>
															<c:otherwise>
																Unknown
															</c:otherwise>
														</c:choose>
													</span>
												</div>
												<div class="price">
													<span class="badge ${club.status == 'Approved' ? 'badge-success' : 'badge-secondary'}">${club.status != null ? club.status : 'Đang cập nhật'}</span>
												</div>
											</div>
											<div class="p-3 text-center">
												<a href="clubDetail?clubId=${club.clubId}" class="btn btn-outline-primary btn-sm">Xem chi tiết</a>
											</div>
										</div>
									</div>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<!-- Fallback static content if no clubs in database -->
								<div class="item">
									<div class="cours-bx">
										<div class="action-box">
											<img src="assets/images/courses/pic1.jpg" alt="Programming Club">
											<a href="#" class="btn">Join Club</a>
										</div>
										<div class="info-bx text-center">
											<h5><a href="#">Programming Club</a></h5>
											<span>Technology</span>
										</div>
										<div class="cours-more-info">
											<div class="review">
												<span><i class="ti-user"></i> 150 Members</span>
											</div>
											<div class="price">
												<h5>Active</h5>
											</div>
										</div>
									</div>
								</div>
								<div class="item">
									<div class="cours-bx">
										<div class="action-box">
											<img src="assets/images/courses/pic2.jpg" alt="Music Club">
											<a href="#" class="btn">Join Club</a>
										</div>
										<div class="info-bx text-center">
											<h5><a href="#">Music Club</a></h5>
											<span>Arts & Culture</span>
										</div>
										<div class="cours-more-info">
											<div class="review">
												<span><i class="ti-user"></i> 85 Members</span>
											</div>
											<div class="price">
												<h5>Active</h5>
											</div>
										</div>
									</div>
								</div>
							</c:otherwise>
						</c:choose>
					</div>
					</div>
				</div>
			</div>
			<!-- Featured Clubs END -->
			<section class="section-area section-sp2">
                <div class="container">
                    <div class="join-section text-center">
                        <h2 class="mb-3">Tham gia StuClubManagement <br><strong>chỉ với vài bước</strong></h2>
                        <p class="mb-4" style="max-width:620px;margin:0 auto;">Kết nối với cộng đồng đam mê, phát triển kỹ năng và quản lý hoạt động CLB dễ dàng hơn. Bắt đầu hành trình của bạn ngay hôm nay.</p>
                        <a href="${pageContext.request.contextPath}/viewAllClubs" class="btn">Khám phá CLB</a>
                    </div>
                </div>
            </section>
			<!-- Form END -->
			
			<!-- Upcoming Events -->
			<div class="section-area section-sp2">
				<div class="container">
					<div class="row">
						<div class="col-md-12 heading-bx left">
							<h2 class="title-head">Sự kiện <span>Sắp diễn ra</span></h2>
							<p>Cùng StuClubManagement theo dõi các hoạt động nổi bật của cộng đồng CLB</p>
						</div>
					</div>
					<div class="row">
						<c:choose>
							<c:when test="${not empty upcomingEvents}">
								<c:forEach var="event" items="${upcomingEvents}" varStatus="status">
									<div class="col-lg-4 col-md-6 col-sm-12 m-b30">
										<div class="event-card">
											<img src="assets/images/courses/pic${(status.index % 3) + 6}.jpg" alt="${event.title}" loading="lazy">
											<div class="info-bx p-4">
												<h5><a href="#">${event.title}</a></h5>
												<ul class="media-post">
													<li><i class="fa fa-calendar"></i><span><fmt:formatDate value="${event.startTime}" pattern="dd MMM yyyy"/></span></li>
													<li><i class="fa fa-clock-o"></i><span><fmt:formatDate value="${event.startTime}" pattern="HH:mm"/> - <fmt:formatDate value="${event.endTime}" pattern="HH:mm"/></span></li>
													<li><i class="fa fa-map-marker"></i><span>${event.location}</span></li>
												</ul>
												<p>${event.description}</p>
												<div class="event-status">
													<span class="badge ${event.status == 'Active' ? 'badge-success' : 'badge-secondary'}">${event.status != null ? event.status : 'Đang cập nhật'}</span>
												</div>
											</div>
										</div>
									</div>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<!-- Fallback static content if no events in database -->
								<div class="col-lg-4 col-md-6 col-sm-12 m-b30">
									<div class="event-card">
										<img src="assets/images/courses/pic6.jpg" alt="Tech Workshop">
										<div class="info-bx p-4">
											<h5><a href="#">Programming Workshop</a></h5>
											<ul class="media-post">
												<li><i class="fa fa-calendar"></i><span>25 Dec 2024</span></li>
												<li><i class="fa fa-clock-o"></i><span>2:00 PM - 5:00 PM</span></li>
												<li><i class="fa fa-map-marker"></i><span>Computer Lab A</span></li>
											</ul>
											<p>Join us for an intensive programming workshop covering modern web development techniques.</p>
											<div class="event-status">
												<span class="badge badge-success">Active</span>
											</div>
										</div>
									</div>
								</div>
								<div class="col-lg-4 col-md-6 col-sm-12 m-b30">
									<div class="event-card">
										<img src="assets/images/courses/pic7.jpg" alt="Music Concert">
										<div class="info-bx p-4">
											<h5><a href="#">Annual Music Concert</a></h5>
											<ul class="media-post">
												<li><i class="fa fa-calendar"></i><span>30 Dec 2024</span></li>
												<li><i class="fa fa-clock-o"></i><span>7:00 PM - 10:00 PM</span></li>
												<li><i class="fa fa-map-marker"></i><span>Main Auditorium</span></li>
											</ul>
											<p>Experience amazing performances by our talented music club members.</p>
											<div class="event-status">
												<span class="badge badge-success">Active</span>
											</div>
										</div>
									</div>
								</div>
								<div class="col-lg-4 col-md-6 col-sm-12 m-b30">
									<div class="event-bx">
										<div class="action-box">
											<img src="assets/images/courses/pic8.jpg" alt="Sports Tournament">
										</div>
										<div class="info-bx">
											<h5><a href="#">Inter-Club Sports Tournament</a></h5>
											<ul class="media-post">
												<li><i class="fa fa-calendar"></i><span>5 Jan 2025</span></li>
												<li><i class="fa fa-clock-o"></i><span>9:00 AM - 6:00 PM</span></li>
												<li><i class="fa fa-map-marker"></i><span>Sports Complex</span></li>
											</ul>
											<p>Compete with other clubs in various sports and showcase your athletic skills.</p>
										</div>
									</div>
								</div>
							</c:otherwise>
						</c:choose>
					</div>
				</div>
			</div>
			<!-- Upcoming Events END -->
			
			<div class="section-area section-sp1">
                <div class="container">
					 <div class="row">
						 <div class="col-lg-6 m-b30">
							<h2 class="title-head ">Vì sao chọn <br> <span class="text-primary">StuClubManagement?</span></h2>
							<h4>Xây dựng <span class="counter">tương lai</span> từ hôm nay</h4>
							<p>Nền tảng giúp ban chủ nhiệm quản lí CLB hiệu quả, sinh viên dễ dàng tiếp cận thông tin và đăng ký tham gia sự kiện. Mọi thứ tập trung tại một nơi duy nhất.</p>
							<a href="viewAllClubs" class="btn button-md">Trải nghiệm ngay</a>
						 </div>
						 <div class="col-lg-6">
							 <div class="row">
								<div class="col-lg-6 col-md-6 col-sm-6 m-b30">
									<div class="feature-container">
										<div class="feature-md text-white m-b20">
											<a href="#" class="icon-cell"><i class="ti-user" style="font-size: 40px; color: #f8b500;"></i></a> 
										</div>
										<div class="icon-content">
											<h5 class="ttr-tilte">Kết nối thành viên</h5>
											<p>Xây dựng mạng lưới sinh viên cùng sở thích và mục tiêu.</p>
										</div>
									</div>
								</div>
								<div class="col-lg-6 col-md-6 col-sm-6 m-b30">
									<div class="feature-container">
										<div class="feature-md text-white m-b20">
											<a href="#" class="icon-cell"><i class="ti-trophy" style="font-size: 40px; color: #f8b500;"></i></a> 
										</div>
										<div class="icon-content">
											<h5 class="ttr-tilte">Nâng cao kỹ năng</h5>
											<p>Phát triển lãnh đạo, làm việc nhóm và kỹ năng chuyên môn.</p>
										</div>
									</div>
								</div>
								<div class="col-lg-6 col-md-6 col-sm-6 m-b30">
									<div class="feature-container">
										<div class="feature-md text-white m-b20">
											<a href="#" class="icon-cell"><i class="ti-heart" style="font-size: 40px; color: #f8b500;"></i></a> 
										</div>
										<div class="icon-content">
											<h5 class="ttr-tilte">Trải nghiệm thú vị</h5>
											<p>Tạo ra những kỷ niệm đáng nhớ cùng cộng đồng CLB.</p>
										</div>
									</div>
								</div>
								<div class="col-lg-6 col-md-6 col-sm-6 m-b30">
									<div class="feature-container">
										<div class="feature-md text-white m-b20">
											<a href="#" class="icon-cell"><i class="ti-star" style="font-size: 40px; color: #f8b500;"></i></a> 
										</div>
										<div class="icon-content">
											<h5 class="ttr-tilte">Phát triển bản thân</h5>
											<p>Khai phá đam mê mới và tự tin khẳng định bản thân.</p>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
            </div>
			
			<!-- Testimonials -->
			<div class="section-area section-sp1 bg-fix ovbl-dark text-white" style="background-image:url(assets/images/background/bg1.jpg);">
                <div class="container">
					<div class="row">
                            <div class="col-lg-3 col-md-6 col-sm-6 col-6 m-b30">
                                <div class="counter-style-1">
                                    <div class="text-white">
										<span class="counter">${totalClubs != null ? totalClubs : 50}</span><span>+</span>
									</div>
									<span class="counter-text">CLB đang hoạt động</span>
                                </div>
                            </div>
                            <div class="col-lg-3 col-md-6 col-sm-6 col-6 m-b30">
                                <div class="counter-style-1">
									<div class="text-white">
										<span class="counter">1000</span><span>+</span>
									</div>
									<span class="counter-text">Thành viên đang tham gia</span>
								</div>
                            </div>
                            <div class="col-lg-3 col-md-6 col-sm-6 col-6 m-b30">
                                <div class="counter-style-1">
									<div class="text-white">
										<span class="counter">${totalEvents != null ? totalEvents : 200}</span><span>+</span>
									</div>
									<span class="counter-text">Sự kiện trong năm</span>
								</div>
                            </div>
                            <div class="col-lg-3 col-md-6 col-sm-6 col-6 m-b30">
                                <div class="counter-style-1">
									<div class="text-white">
										<span class="counter">15</span><span>+</span>
									</div>
									<span class="counter-text">Nhóm CLB khác nhau</span>
								</div>
                            </div>
                        </div>
				</div>
			</div>
			<!-- Testimonials END -->
			<!-- Student Testimonials ==== -->
			<div class="section-area section-sp2">
				<div class="container">
					<div class="row">
						<div class="col-md-12 heading-bx left">
							<h2 class="title-head text-uppercase">Cảm nhận <span>thành viên</span></h2>
							<p>Chia sẻ từ những sinh viên đã và đang tham gia hệ thống StuClubManagement</p>
						</div>
					</div>
					<div class="testimonial-carousel owl-carousel owl-btn-1 col-12 p-lr0">
						<div class="item">
							<div class="testimonial-bx">
								<div class="testimonial-thumb">
									<img src="assets/images/testimonials/pic1.jpg" alt="">
								</div>
								<div class="testimonial-info">
									<h5 class="name">Sarah Johnson</h5>
									<p>- Programming Club President</p>
								</div>
								<div class="testimonial-content">
									<p>Việc sử dụng StuClubManagement giúp câu lạc bộ lập trình của chúng tôi vận hành trơn tru. Mình dễ dàng quản lí lịch sự kiện, thông báo cho thành viên và theo dõi tiến độ hoạt động.</p>
								</div>
							</div>
						</div>
						<div class="item">
							<div class="testimonial-bx">
								<div class="testimonial-thumb">
									<img src="assets/images/testimonials/pic2.jpg" alt="">
								</div>
								<div class="testimonial-info">
									<h5 class="name">Michael Chen</h5>
									<p>- Sports Club Member</p>
								</div>
								<div class="testimonial-content">
									<p>Nhờ nền tảng, chúng tôi quản lí lịch tập luyện, đăng ký giải đấu và điểm danh thành viên chỉ với vài cú click. Mọi thứ minh bạch và hiệu quả hơn trước rất nhiều.</p>
								</div>
							</div>
						</div>
						<div class="item">
							<div class="testimonial-bx">
								<div class="testimonial-thumb">
									<img src="assets/images/testimonials/pic3.jpg" alt="">
								</div>
								<div class="testimonial-info">
									<h5 class="name">Emily Rodriguez</h5>
									<p>- Music Club Vice President</p>
								</div>
								<div class="testimonial-content">
									<p>StuClubManagement hỗ trợ ban nhạc của chúng tôi quảng bá sự kiện và nhận đăng ký biểu diễn trực tiếp. Tương tác với người tham gia cũng dễ dàng hơn.</p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- Student Testimonials END ==== -->
        </div>
		<!-- contact area END -->
    </div>
    <!-- Content END-->
	
    <%@ include file="/view/layout/footer.jsp" %>
    <button class="back-to-top fa fa-chevron-up" ></button>
</div>

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
<script src="assets/js/functions.js"></script>
<!-- <script src="assets/js/contact.js"></script> -->
<script src='assets/vendors/switcher/switcher.js'></script>
</body>

</html>