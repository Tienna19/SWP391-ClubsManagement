<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">

<head>

	<!-- META ============================================= -->
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="keywords" content="" />
	<meta name="author" content="" />
	<meta name="robots" content="" />
	
	<!-- DESCRIPTION -->
	<meta name="description" content="StuClub Manager : Student Club Management System" />
	
	<!-- OG -->
	<meta property="og:title" content="StuClub Manager : Student Club Management System" />
	<meta property="og:description" content="StuClub Manager : Student Club Management System" />
	<meta property="og:image" content="" />
	<meta name="format-detection" content="telephone=no">
	
	<!-- FAVICONS ICON ============================================= -->
	<link rel="icon" href="assets/images/favicon.ico" type="image/x-icon" />
	<link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon.png" />
	
	<!-- PAGE TITLE HERE ============================================= -->
	<title>StuClub Manager - Student Club Management System</title>
	
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
		.event-bx {
			background: #fff;
			border-radius: 10px;
			box-shadow: 0 5px 15px rgba(0,0,0,0.1);
			overflow: hidden;
			transition: transform 0.3s ease;
		}
		.event-bx:hover {
			transform: translateY(-5px);
		}
		.event-bx .action-box {
			position: relative;
			overflow: hidden;
		}
		.event-bx .action-box img {
			width: 100%;
			height: 200px;
			object-fit: cover;
		}
		.event-bx .info-bx {
			padding: 20px;
		}
		.event-bx .info-bx h5 {
			margin-bottom: 15px;
			color: #333;
		}
		.event-bx .info-bx h5 a {
			color: #333;
			text-decoration: none;
		}
		.event-bx .info-bx h5 a:hover {
			color: #f8b500;
		}
		.media-post {
			list-style: none;
			padding: 0;
			margin: 0 0 15px 0;
		}
		.media-post li {
			display: inline-block;
			margin-right: 15px;
			margin-bottom: 5px;
			font-size: 14px;
			color: #666;
		}
		.media-post li i {
			margin-right: 5px;
			color: #f8b500;
		}
		.event-status {
			margin-top: 10px;
		}
		.badge {
			padding: 4px 8px;
			border-radius: 4px;
			font-size: 12px;
			font-weight: bold;
		}
		.badge-success {
			background-color: #28a745;
			color: white;
		}
		.badge-secondary {
			background-color: #6c757d;
			color: white;
		}
		.text-success {
			color: #28a745 !important;
		}
		.text-warning {
			color: #ffc107 !important;
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
        <div class="section-area section-sp1 ovpr-dark bg-fix online-cours" style="background-image:url(assets/images/background/bg1.jpg);">
				<div class="container">
					<div class="row">
						<div class="col-md-12 text-center text-white">
							<h2>Discover Student Clubs</h2>
							<h5>Join Clubs, Make Friends, Create Memories</h5>
							<form class="cours-search">
								<div class="input-group">
									<input type="text" class="form-control" placeholder="Which club are you looking for?">
									<div class="input-group-append">
										<button class="btn" type="submit">Search</button> 
									</div>
								</div>
							</form>
						</div>
					</div>
					<div class="mw800 m-auto">
						<div class="row">
							<div class="col-md-4 col-sm-6">
								<div class="cours-search-bx m-b30">
									<div class="icon-box">
										<h3><i class="ti-user"></i><span class="counter">${totalClubs != null ? totalClubs : 50}</span>+</h3>
									</div>
									<span class="cours-search-text">Active Student Clubs</span>
								</div>
							</div>
							<div class="col-md-4 col-sm-6">
								<div class="cours-search-bx m-b30">
									<div class="icon-box">
										<h3><i class="ti-calendar"></i><span class="counter">${totalEvents != null ? totalEvents : 200}</span>+</h3>
									</div>
									<span class="cours-search-text">Events This Year</span>
								</div>
							</div>
							<div class="col-md-4 col-sm-12">
								<div class="cours-search-bx m-b30">
									<div class="icon-box">
										<h3><i class="ti-heart"></i><span class="counter">1000</span>+</h3>
									</div>
									<span class="cours-search-text">Happy Members</span>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
        <!-- Main Slider -->
		<div class="content-block">
            <!-- Featured Clubs -->
			<div class="section-area section-sp2 popular-courses-bx">
                <div class="container">
					<div class="row">
						<div class="col-md-12 heading-bx left">
							<h2 class="title-head">Featured <span>Clubs</span></h2>
							<p>Discover amazing student clubs and find your community at our university</p>
						</div>
					</div>
					<div class="row">
					<div class="courses-carousel owl-carousel owl-btn-1 col-12 p-lr0">
						<c:choose>
							<c:when test="${not empty featuredClubs}">
								<c:forEach var="club" items="${featuredClubs}" varStatus="status">
									<div class="item">
										<div class="cours-bx">
											<div class="action-box">
												<img src="${not empty club.logoUrl ? club.logoUrl : 'assets/images/courses/pic'.concat((status.index % 4) + 1).concat('.jpg')}" 
													 alt="${club.name}">
												<a href="viewAllClubs?clubId=${club.clubId}" class="btn">Join Club</a>
											</div>
											<div class="info-bx text-center">
												<h5><a href="viewAllClubs?clubId=${club.clubId}">${club.name}</a></h5>
												<span>Category ID: ${club.categoryId}</span>
											</div>
											<div class="cours-more-info">
												<div class="review">
													<span><i class="ti-calendar"></i> <fmt:formatDate value="${club.createdAt}" pattern="MMM yyyy"/></span>
												</div>
												<div class="price">
													<h5 class="${club.status == 'Approved' ? 'text-success' : 'text-warning'}">${club.status}</h5>
												</div>
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
			<div class="section-area section-sp2 bg-fix ovbl-dark join-bx text-center" style="background-image:url(assets/images/background/bg1.jpg);">
                <div class="container">
					<div class="row">
						<div class="col-md-12">
							<div class="join-content-bx text-white">
								<h2>Join Student Clubs and <br> Build Your Network</h2>
								<h4><span class="counter">50</span>+ Active Clubs</h4>
								<p>Connect with like-minded students, develop new skills, and create lasting friendships through our diverse range of student clubs. From academic societies to hobby groups, there's something for everyone. Join a community that shares your interests and passions.</p>
								<a href="viewAllClubs" class="btn button-md">Explore All Clubs</a>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- Form END -->
			
			<!-- Upcoming Events -->
			<div class="section-area section-sp2">
				<div class="container">
					<div class="row">
						<div class="col-md-12 heading-bx left">
							<h2 class="title-head">Upcoming <span>Events</span></h2>
							<p>Don't miss out on exciting events happening across our student clubs</p>
						</div>
					</div>
					<div class="row">
						<c:choose>
							<c:when test="${not empty upcomingEvents}">
								<c:forEach var="event" items="${upcomingEvents}" varStatus="status">
									<div class="col-lg-4 col-md-6 col-sm-12 m-b30">
										<div class="event-bx">
											<div class="action-box">
												<img src="assets/images/courses/pic${(status.index % 3) + 6}.jpg" alt="${event.title}">
											</div>
											<div class="info-bx">
												<h5><a href="#">${event.title}</a></h5>
												<ul class="media-post">
													<li><i class="fa fa-calendar"></i><span><fmt:formatDate value="${event.startTime}" pattern="dd MMM yyyy"/></span></li>
													<li><i class="fa fa-clock-o"></i><span><fmt:formatDate value="${event.startTime}" pattern="HH:mm"/> - <fmt:formatDate value="${event.endTime}" pattern="HH:mm"/></span></li>
													<li><i class="fa fa-map-marker"></i><span>${event.location}</span></li>
												</ul>
												<p>${event.description}</p>
												<div class="event-status">
													<span class="badge ${event.status == 'Active' ? 'badge-success' : 'badge-secondary'}">${event.status}</span>
												</div>
											</div>
										</div>
									</div>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<!-- Fallback static content if no events in database -->
								<div class="col-lg-4 col-md-6 col-sm-12 m-b30">
									<div class="event-bx">
										<div class="action-box">
											<img src="assets/images/courses/pic6.jpg" alt="Tech Workshop">
										</div>
										<div class="info-bx">
											<h5><a href="#">Programming Workshop</a></h5>
											<ul class="media-post">
												<li><i class="fa fa-calendar"></i><span>25 Dec 2024</span></li>
												<li><i class="fa fa-clock-o"></i><span>2:00 PM - 5:00 PM</span></li>
												<li><i class="fa fa-map-marker"></i><span>Computer Lab A</span></li>
											</ul>
											<p>Join us for an intensive programming workshop covering modern web development techniques.</p>
										</div>
									</div>
								</div>
								<div class="col-lg-4 col-md-6 col-sm-12 m-b30">
									<div class="event-bx">
										<div class="action-box">
											<img src="assets/images/courses/pic7.jpg" alt="Music Concert">
										</div>
										<div class="info-bx">
											<h5><a href="#">Annual Music Concert</a></h5>
											<ul class="media-post">
												<li><i class="fa fa-calendar"></i><span>30 Dec 2024</span></li>
												<li><i class="fa fa-clock-o"></i><span>7:00 PM - 10:00 PM</span></li>
												<li><i class="fa fa-map-marker"></i><span>Main Auditorium</span></li>
											</ul>
											<p>Experience amazing performances by our talented music club members.</p>
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
							<h2 class="title-head ">Why Join <br> <span class="text-primary">Student Clubs?</span></h2>
							<h4>Build Your <span class="counter">Future</span> Today</h4>
							<p>Student clubs provide invaluable opportunities for personal growth, skill development, and networking. Connect with peers who share your interests and build lasting relationships.</p>
							<a href="viewAllClubs" class="btn button-md">Explore Clubs</a>
						 </div>
						 <div class="col-lg-6">
							 <div class="row">
								<div class="col-lg-6 col-md-6 col-sm-6 m-b30">
									<div class="feature-container">
										<div class="feature-md text-white m-b20">
											<a href="#" class="icon-cell"><i class="ti-user" style="font-size: 40px; color: #f8b500;"></i></a> 
										</div>
										<div class="icon-content">
											<h5 class="ttr-tilte">Network Building</h5>
											<p>Connect with like-minded students and build professional relationships.</p>
										</div>
									</div>
								</div>
								<div class="col-lg-6 col-md-6 col-sm-6 m-b30">
									<div class="feature-container">
										<div class="feature-md text-white m-b20">
											<a href="#" class="icon-cell"><i class="ti-trophy" style="font-size: 40px; color: #f8b500;"></i></a> 
										</div>
										<div class="icon-content">
											<h5 class="ttr-tilte">Skill Development</h5>
											<p>Develop leadership, teamwork, and specialized skills through club activities.</p>
										</div>
									</div>
								</div>
								<div class="col-lg-6 col-md-6 col-sm-6 m-b30">
									<div class="feature-container">
										<div class="feature-md text-white m-b20">
											<a href="#" class="icon-cell"><i class="ti-heart" style="font-size: 40px; color: #f8b500;"></i></a> 
										</div>
										<div class="icon-content">
											<h5 class="ttr-tilte">Fun & Friendship</h5>
											<p>Enjoy memorable experiences and create lasting friendships.</p>
										</div>
									</div>
								</div>
								<div class="col-lg-6 col-md-6 col-sm-6 m-b30">
									<div class="feature-container">
										<div class="feature-md text-white m-b20">
											<a href="#" class="icon-cell"><i class="ti-star" style="font-size: 40px; color: #f8b500;"></i></a> 
										</div>
										<div class="icon-content">
											<h5 class="ttr-tilte">Personal Growth</h5>
											<p>Challenge yourself and discover new interests and talents.</p>
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
									<span class="counter-text">Active Clubs</span>
                                </div>
                            </div>
                            <div class="col-lg-3 col-md-6 col-sm-6 col-6 m-b30">
                                <div class="counter-style-1">
									<div class="text-white">
										<span class="counter">1000</span><span>+</span>
									</div>
									<span class="counter-text">Club Members</span>
								</div>
                            </div>
                            <div class="col-lg-3 col-md-6 col-sm-6 col-6 m-b30">
                                <div class="counter-style-1">
									<div class="text-white">
										<span class="counter">${totalEvents != null ? totalEvents : 200}</span><span>+</span>
									</div>
									<span class="counter-text">Events This Year</span>
								</div>
                            </div>
                            <div class="col-lg-3 col-md-6 col-sm-6 col-6 m-b30">
                                <div class="counter-style-1">
									<div class="text-white">
										<span class="counter">15</span><span>+</span>
									</div>
									<span class="counter-text">Club Categories</span>
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
							<h2 class="title-head text-uppercase">what students <span>say</span></h2>
							<p>Hear from our active club members about their experiences and achievements</p>
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
									<p>Joining the Programming Club was the best decision I made in university. I've learned so much, made great friends, and even landed an internship through the connections I made here. The club activities really helped me develop both technical and leadership skills.</p>
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
									<p>The Sports Club has been my second family throughout university. Not only did I stay fit and healthy, but I also learned valuable teamwork skills and made lifelong friendships. The tournaments and events are always exciting and well-organized.</p>
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
									<p>Being part of the Music Club has allowed me to pursue my passion while studying. We've performed at numerous events, and I've grown so much as a musician and performer. The supportive community here is incredible.</p>
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
<script src="assets/js/contact.js"></script>
<script src='assets/vendors/switcher/switcher.js'></script>
</body>

</html>