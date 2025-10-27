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
                                <li><a href="${pageContext.request.contextPath}/clubDetail?clubId=${club.clubId}">Chi tiết CLB</a></li>
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
                                <li><a href="${pageContext.request.contextPath}/clubDetail?clubId=${club.clubId}">Chi tiết CLB</a></li>
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
                        <a href="${pageContext.request.contextPath}/clubDashboard?clubId=${club.clubId}" class="ttr-material-button">
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
                    <li>
                        <a href="#" class="ttr-material-button">
                            <span class="ttr-icon"><i class="ti-calendar"></i></span>
                            <span class="ttr-label">Sự kiện</span>
                            <span class="ttr-arrow-icon"><i class="fa fa-angle-down"></i></span>
                        </a>
                        <ul>
                            <li>
                                <a href="${pageContext.request.contextPath}/listEvents?clubId=${club.clubId}" class="ttr-material-button">
                                    <span class="ttr-label">Danh sách sự kiện</span>
                                </a>
                            </li>
                            <li>
                                <a href="${pageContext.request.contextPath}/addEvent?clubId=${club.clubId}" class="ttr-material-button">
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
                <div class="col-md-6 col-lg-3 col-xl-3 col-sm-6 col-12">
                    <div class="widget-card widget-bg4">                     
                        <div class="wc-item">
                            <h4 class="wc-title">Trạng thái</h4>
                            <span class="wc-des">Tình trạng CLB</span>
                            <span class="wc-stats">${club.status}</span>        
                            <div class="progress wc-progress">
                                <div class="progress-bar" role="progressbar" style="width: ${club.status eq 'Active' ? '100' : '50'}%;" 
                                     aria-valuenow="${club.status eq 'Active' ? '100' : '50'}" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                            <span class="wc-progress-bx">
                                <span class="wc-change">Hoạt động</span>
                                <span class="wc-number ml-auto">${club.status eq 'Active' ? '100' : '50'}%</span>
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
                {
                    title: '${event.eventName}',
                    start: '${event.startDate}',
                    end: '${event.endDate}',
                    url: '${pageContext.request.contextPath}/editEvent?eventId=${event.eventID}'
                }<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            ]
        });
    });
    </script>
</body>
</html>

