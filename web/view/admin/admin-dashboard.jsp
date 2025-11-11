<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <!-- META ============================================= -->
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin Dashboard</title>

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
<body class="ttr-opened-sidebar ttr-pinned-sidebar admin-theme-loaded">
<%@ include file="/WEB-INF/jspf/admin-layout.jspf" %>

<!--Main container start -->
<main class="ttr-wrapper">
    <div class="container-fluid">
        <div class="db-breadcrumb">
            <h4 class="breadcrumb-title">Dashboard</h4>
            <ul class="db-breadcrumb-list">
                <li><a href="${pageContext.request.contextPath}/home"><i class="fa fa-home"></i>Home</a></li>
                <li>Dashboard</li>
            </ul>
        </div>

        <!-- Stat cards -->
        <div class="row">
            <div class="col-md-6 col-lg-3 col-xl-3 col-sm-6 col-12">
                <div class="widget-card widget-bg1">
                    <div class="wc-item">
                        <h4 class="wc-title">Tổng CLB</h4>
                        <span class="wc-des">Số CLB trong hệ thống</span>
                        <span class="wc-stats">${totalClubsVal}</span>
                        <div class="progress wc-progress">
                            <div class="progress-bar" role="progressbar" style="width: 78%;"></div>
                        </div>
                        <span class="wc-progress-bx">
                            <span class="wc-change">Hoạt động</span>
                            <span class="wc-number ml-auto">${activeClubsVal}</span>
                        </span>
                    </div>
                </div>
            </div>
            <div class="col-md-6 col-lg-3 col-xl-3 col-sm-6 col-12">
                <div class="widget-card widget-bg2">
                    <div class="wc-item">
                        <h4 class="wc-title">Sự kiện</h4>
                        <span class="wc-des">Tổng sự kiện</span>
                        <span class="wc-stats">${totalEventsVal}</span>
                        <div class="progress wc-progress">
                            <div class="progress-bar" role="progressbar" style="width: 88%;"></div>
                        </div>
                        <span class="wc-progress-bx">
                            <span class="wc-change">Đã xuất bản</span>
                            <span class="wc-number ml-auto">${publishedEventsVal}</span>
                        </span>
                    </div>
                </div>
            </div>
            <div class="col-md-6 col-lg-3 col-xl-3 col-sm-6 col-12">
                <div class="widget-card widget-bg3">
                    <div class="wc-item">
                        <h4 class="wc-title">Thành viên</h4>
                        <span class="wc-des">Tổng người dùng</span>
                        <span class="wc-stats">${totalUsersVal}</span>
                        <div class="progress wc-progress">
                            <div class="progress-bar" role="progressbar" style="width: 65%;"></div>
                        </div>
                        <span class="wc-progress-bx">
                            <span class="wc-change">Nháp sự kiện</span>
                            <span class="wc-number ml-auto">${draftEventsVal}</span>
                        </span>
                    </div>
                </div>
            </div>
            <div class="col-md-6 col-lg-3 col-xl-3 col-sm-6 col-12">
                <div class="widget-card widget-bg4">
                    <div class="wc-item">
                        <h4 class="wc-title">Tình trạng</h4>
                        <span class="wc-des">Hệ thống</span>
                        <span class="wc-stats">Online</span>
                        <div class="progress wc-progress">
                            <div class="progress-bar" role="progressbar" style="width: 90%;"></div>
                        </div>
                        <span class="wc-progress-bx">
                            <span class="wc-change">CLB ngưng</span>
                            <span class="wc-number ml-auto">${inactiveClubsVal}</span>
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-8 m-b30">
                <div class="widget-box">
                    <div class="wc-title">
                        <h4>Tổng quan hệ thống</h4>
                    </div>
                    <div class="widget-inner">
                        <canvas id="overviewChart" width="100" height="45"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-lg-4 m-b30">
                <div class="widget-box">
                    <div class="wc-title">
                        <h4>CLB mới</h4>
                    </div>
                    <div class="widget-inner">
                        <div class="noti-box-list">
                            <ul>
                                <c:forEach items="${recentClubs}" var="club">
                                    <li>
                                        <span class="notification-icon dashbg-green">
                                            <i class="fa fa-university"></i>
                                        </span>
                                        <span class="notification-text">
                                            <strong>${club.clubName}</strong> - ${club.clubTypes}
                                        </span>
                                        <span class="notification-time">
                                            <span>${club.status}</span>
                                        </span>
                                    </li>
                                </c:forEach>
                                <c:if test="${empty recentClubs}">
                                    <li class="text-center text-muted py-3">
                                        Chưa có CLB nào
                                    </li>
                                </c:if>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-6 m-b30">
                <div class="widget-box">
                    <div class="wc-title">
                        <h4>Người dùng mới</h4>
                    </div>
                    <div class="widget-inner">
                        <div class="new-user-list">
                            <ul>
                                <c:forEach items="${recentUsers}" var="user">
                                    <li>
                                        <span class="new-users-pic">
                                            <img src="${pageContext.request.contextPath}/assets/images/testimonials/pic1.jpg" alt="avatar"/>
                                        </span>
                                        <span class="new-users-text">
                                            <a href="#" class="new-users-name">${user.fullName}</a>
                                            <span class="new-users-info">${user.email}</span>
                                        </span>
                                        <span class="new-users-btn">
                                            <a href="${pageContext.request.contextPath}/adminUsers" class="btn button-sm outline">Xem</a>
                                        </span>
                                    </li>
                                </c:forEach>
                                <c:if test="${empty recentUsers}">
                                    <li class="text-center text-muted py-3">
                                        Chưa có người dùng mới
                                    </li>
                                </c:if>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-6 m-b30">
                <div class="widget-box">
                    <div class="wc-title">
                        <h4>Sự kiện gần đây</h4>
                    </div>
                    <div class="widget-inner">
                        <div class="orders-list">
                            <ul>
                                <c:forEach items="${recentEvents}" var="event">
                                    <li>
                                        <span class="orders-title">
                                            <a href="${pageContext.request.contextPath}/editEvent?eventId=${event.eventID}" class="orders-title-name">
                                                ${event.eventName}
                                            </a>
                                            <span class="orders-info">
                                                <i class="fa fa-map-marker"></i> ${event.location}
                                                <br/>
                                                <i class="fa fa-clock-o"></i>
                                                <fmt:formatDate value="${event.startDate}" pattern="dd/MM/yyyy HH:mm"/>
                                            </span>
                                        </span>
                                        <span class="orders-btn">
                                            <span class="btn button-sm ${event.status eq 'Published' ? 'green' : 'red'}">${event.status}</span>
                                        </span>
                                    </li>
                                </c:forEach>
                                <c:if test="${empty recentEvents}">
                                    <li class="text-center text-muted py-3">
                                        Chưa có sự kiện nào
                                    </li>
                                </c:if>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-12 m-b30">
                <div class="widget-box">
                    <div class="wc-title">
                        <h4>Lịch sự kiện</h4>
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
<script src="${pageContext.request.contextPath}/assets/vendors/chart/chart.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/functions.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/calendar/moment.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/calendar/fullcalendar.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/switcher/switcher.js"></script>

<script>
    (function () {
        const clubs = Number("<c:out value='${totalClubsVal}'/>");
        const events = Number("<c:out value='${totalEventsVal}'/>");
        const users = Number("<c:out value='${totalUsersVal}'/>");
        const ctx = document.getElementById('overviewChart');
        if (ctx && window.Chart) {
            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: ['CLB', 'Sự kiện', 'Người dùng'],
                    datasets: [{
                        label: 'Thống kê hệ thống',
                        data: [clubs, events, users],
                        borderColor: '#5E35B1',
                        backgroundColor: 'rgba(94, 53, 177, 0.15)',
                        borderWidth: 3,
                        tension: 0.3,
                        fill: true
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: { display: false }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: { precision: 0 }
                        }
                    }
                }
            });
        }

        const calendarEvents = [];
        document.querySelectorAll('#calendar-event-data .calendar-event').forEach(function(node) {
            calendarEvents.push({
                title: node.dataset.title,
                start: node.dataset.start,
                end: node.dataset.end,
                url: node.dataset.url
            });
        });

        $('#calendar').fullCalendar({
            header: {
                left: 'prev,next today',
                center: 'title',
                right: 'month,agendaWeek,agendaDay,listWeek'
            },
            defaultDate: moment().format('YYYY-MM-DD'),
            navLinks: true,
            editable: false,
            eventLimit: true,
            events: calendarEvents
        });
        if (window.innerWidth <= 1024) {
            document.body.classList.remove('ttr-opened-sidebar');
            document.body.classList.remove('ttr-pinned-sidebar');
        } else {
            document.body.classList.add('ttr-opened-sidebar');
            document.body.classList.add('ttr-pinned-sidebar');
        }
        window.addEventListener('resize', function () {
            if (window.innerWidth <= 1024) {
                document.body.classList.remove('ttr-opened-sidebar');
                document.body.classList.remove('ttr-pinned-sidebar');
            } else {
                document.body.classList.add('ttr-opened-sidebar');
                document.body.classList.add('ttr-pinned-sidebar');
            }
        });
    })();
</script>

<div id="calendar-event-data" style="display:none;">
    <c:forEach items="${recentEvents}" var="event">
        <fmt:formatDate value="${event.startDate}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="eventStartIso"/>
        <fmt:formatDate value="${event.endDate}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="eventEndIso"/>
        <div class="calendar-event"
             data-title="<c:out value='${event.eventName}'/>"
             data-start="<c:out value='${eventStartIso}'/>"
             data-end="<c:out value='${eventEndIso}'/>"
             data-url="${pageContext.request.contextPath}/editEvent?eventId=${event.eventID}">
        </div>
    </c:forEach>
</div>
</body>
</html>

