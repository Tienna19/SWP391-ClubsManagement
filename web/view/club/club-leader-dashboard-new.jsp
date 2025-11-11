<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <!-- META ============================================= -->
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <!-- FAVICONS ICON ============================================= -->
    <link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" type="image/x-icon" />
    <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" />
    
    <!-- PAGE TITLE ============================================= -->
    <title>Club Leader Dashboard - ${club.clubName}</title>
    
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
    
</head>
<body class="ttr-opened-sidebar ttr-pinned-sidebar">

    <%@ include file="/WEB-INF/jspf/leader-layout.jspf" %>

    <!--Main container start -->
    <main class="ttr-wrapper">
        <div class="container-fluid">
            <div class="db-breadcrumb">
                <h4 class="breadcrumb-title">Dashboard - ${club.clubName}</h4>
                <ul class="db-breadcrumb-list">
                    <li><a href="${pageContext.request.contextPath}/home"><i class="fa fa-home"></i>Trang chủ</a></li>
                    <li>Dashboard</li>
                </ul>
            </div>    
            
            <!-- Card -->
            <div class="row">
                <!-- Total Members -->
                <div class="col-md-6 col-lg-3 col-xl-3 col-sm-6 col-12">
                    <div class="widget-card widget-bg1">                     
                        <div class="wc-item">
                            <h4 class="wc-title">Tổng thành viên</h4>
                            <span class="wc-des">Số lượng thành viên</span>
                            <span class="wc-stats counter">${totalMembers}</span>        
                            <div class="progress wc-progress">
                                <div class="progress-bar" role="progressbar" style="width: 78%;" aria-valuenow="78" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                            <span class="wc-progress-bx">
                                <span class="wc-change">Tăng trưởng</span>
                                <span class="wc-number ml-auto">78%</span>
                            </span>
                        </div>                      
                    </div>
                </div>
                
                <!-- Total Events -->
                <div class="col-md-6 col-lg-3 col-xl-3 col-sm-6 col-12">
                    <div class="widget-card widget-bg2">                     
                        <div class="wc-item">
                            <h4 class="wc-title">Tổng sự kiện</h4>
                            <span class="wc-des">Sự kiện đã tổ chức</span>
                            <span class="wc-stats counter">${totalEvents}</span>        
                            <div class="progress wc-progress">
                                <div class="progress-bar" role="progressbar" style="width: 88%;" aria-valuenow="88" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                            <span class="wc-progress-bx">
                                <span class="wc-change">Hoạt động</span>
                                <span class="wc-number ml-auto">88%</span>
                            </span>
                        </div>                      
                    </div>
                </div>
                
                <!-- Upcoming Events -->
                <div class="col-md-6 col-lg-3 col-xl-3 col-sm-6 col-12">
                    <div class="widget-card widget-bg3">                     
                        <div class="wc-item">
                            <h4 class="wc-title">Sự kiện sắp tới</h4>
                            <span class="wc-des">Sự kiện trong tháng</span>
                            <span class="wc-stats counter">${upcomingEvents != null ? upcomingEvents.size() : 0}</span>        
                            <div class="progress wc-progress">
                                <div class="progress-bar" role="progressbar" style="width: 65%;" aria-valuenow="65" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                            <span class="wc-progress-bx">
                                <span class="wc-change">Kế hoạch</span>
                                <span class="wc-number ml-auto">65%</span>
                            </span>
                        </div>                      
                    </div>
                </div>
                
                <!-- Club Status -->
                <c:set var="statusProgress" value="${club.status eq 'Active' ? 100 : 50}" />
                <div class="col-md-6 col-lg-3 col-xl-3 col-sm-6 col-12">
                    <div class="widget-card widget-bg4">                     
                        <div class="wc-item">
                            <h4 class="wc-title">Trạng thái</h4>
                            <span class="wc-des">Tình trạng CLB</span>
                            <span class="wc-stats">${club.status}</span>        
                            <div class="progress wc-progress">
                                <div class="progress-bar" role="progressbar" style="width: 100%;" 
                                     aria-valuenow="100" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                            <span class="wc-progress-bx">
                                <span class="wc-change">Hoạt động</span>
                                <span class="wc-number ml-auto">${statusProgress}%</span>
                            </span>
                        </div>                      
                    </div>
                </div>
            </div>
            <!-- Card END -->
            
            <div class="row">
                <!-- Member List -->
                <div class="col-lg-6 m-b30">
                    <div class="widget-box">
                        <div class="wc-title">
                            <h4>Thành viên mới</h4>
                        </div>
                        <div class="widget-inner">
                            <div class="new-user-list">
                                <ul>
                                    <c:forEach items="${members}" var="member" end="4">
                                        <li>
                                            <span class="new-users-pic">
                                                <c:choose>
                                                    <c:when test="${not empty member.profileImage}">
                                                        <img src="${pageContext.request.contextPath}/${member.profileImage}" alt=""/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="${pageContext.request.contextPath}/assets/images/testimonials/pic1.jpg" alt=""/>
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                            <span class="new-users-text">
                                                <a href="#" class="new-users-name">${member.fullName}</a>
                                                <span class="new-users-info">${member.roleInClub} | ${member.joinDate}</span>
                                            </span>
                                            <span class="new-users-btn">
                                                <a href="#" class="btn button-sm outline">Xem</a>
                                            </span>
                                        </li>
                                    </c:forEach>
                                    
                                    <c:if test="${empty members}">
                                        <li class="text-center text-muted">Chưa có thành viên nào</li>
                                    </c:if>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Upcoming Events -->
                <div class="col-lg-6 m-b30">
                    <div class="widget-box">
                        <div class="wc-title">
                            <h4>Sự kiện sắp tới</h4>
                        </div>
                        <div class="widget-inner">
                            <div class="orders-list">
                                <ul>
                                    <c:forEach items="${upcomingEvents}" var="event">
                                        <li>
                                            <span class="orders-title">
                                                <a href="${pageContext.request.contextPath}/editEvent?eventId=${event.eventID}" class="orders-title-name">
                                                    ${event.eventName}
                                                </a>
                                                <span class="orders-info">
                                                    <i class="fa fa-map-marker"></i> ${event.location} | 
                                                    <i class="fa fa-clock-o"></i> ${event.startDate}
                                                </span>
                                            </span>
                                            <span class="orders-btn">
                                                <a href="${pageContext.request.contextPath}/editEvent?eventId=${event.eventID}" 
                                                   class="btn button-sm ${event.status eq 'Published' ? 'green' : 'red'}">
                                                    ${event.status}
                                                </a>
                                            </span>
                                        </li>
                                    </c:forEach>
                                    
                                    <c:if test="${empty upcomingEvents}">
                                        <li class="text-center text-muted">Không có sự kiện sắp tới</li>
                                    </c:if>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Calendar -->
                <div class="col-lg-12 m-b30">
                    <div class="widget-box">
                        <div class="wc-title">
                            <h4>Lịch sự kiện CLB</h4>
                        </div>
                        <div class="widget-inner">
                            <div id="calendar"></div>
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
    <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap-touchspin/jquery.bootstrap-touchspin.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/magnific-popup/magnific-popup.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/counter/waypoints-min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/counter/counterup.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/imagesloaded/imagesloaded.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/masonry/masonry.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/masonry/filter.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/owl-carousel/owl.carousel.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/scroll/scrollbar.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/functions.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/admin.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/calendar/moment.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/calendar/fullcalendar.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/switcher/switcher.js"></script>
    
    <script>
    $(document).ready(function() {
        // Counter animation
        $('.counter').each(function() {
            $(this).prop('Counter',0).animate({
                Counter: $(this).text()
            }, {
                duration: 2000,
                easing: 'swing',
                step: function (now) {
                    $(this).text(Math.ceil(now));
                }
            });
        });

        // Calendar initialization
        $('#calendar').fullCalendar({
            header: {
                left: 'prev,next today',
                center: 'title',
                right: 'month,agendaWeek,agendaDay,listWeek'
            },
            defaultDate: new Date(),
            navLinks: true,
            editable: true,
            eventLimit: true,
            events: [
                <c:forEach items="${upcomingEvents}" var="event" varStatus="status">
                <c:url var="eventUrl" value="/editEvent">
                    <c:param name="eventId" value="${event.eventID}" />
                </c:url>
                {
                    title: '<c:out value="${event.eventName}" />',
                    start: '<fmt:formatDate value="${event.startDate}" pattern="yyyy-MM-dd\'T\'HH:mm:ss" />',
                    end: '<fmt:formatDate value="${event.endDate}" pattern="yyyy-MM-dd\'T\'HH:mm:ss" />',
                    url: '<c:out value="${eventUrl}" />'
                }<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            ]
        });
    });
    </script>
</body>
</html>

