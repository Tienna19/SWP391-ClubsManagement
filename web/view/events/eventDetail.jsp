<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <title>Chi tiết sự kiện - StuClub</title>

    <!-- CSS chung -->
    <link rel="stylesheet" type="text/css" href="<%=ctx%>/assets/css/assets.css">
    <link rel="stylesheet" type="text/css" href="<%=ctx%>/assets/css/typography.css">
    <link rel="stylesheet" type="text/css" href="<%=ctx%>/assets/css/shortcodes/shortcodes.css">
    <link rel="stylesheet" type="text/css" href="<%=ctx%>/assets/css/style.css">
    <link rel="stylesheet" type="text/css" href="<%=ctx%>/assets/css/dashboard.css">
    <link class="skin" rel="stylesheet" type="text/css" href="<%=ctx%>/assets/css/color/color-1.css">

    <style>
        .event-hero-detail {
            position: relative;
            background: linear-gradient(120deg, #5E35B1, #7E57C2);
            color: #fff;
            padding: 34px 0 28px;
            margin-bottom: 20px;
            overflow: hidden;
        }
        .event-hero-detail .bg-image {
            position:absolute;
            inset:0;
            opacity:0.18;
            background-position:center;
            background-size:cover;
            filter: blur(4px);
        }
        .event-hero-detail .overlay {
            position:relative;
        }
        .event-hero-detail h1 {
            font-size: 34px;
            font-weight: 800;
            margin-bottom: 6px;
            color:#fff;
        }
        .event-hero-detail .subtitle {
            margin: 0;
            opacity: .96;
        }
        .badge-status {
            display:inline-block;
            font-size:11px;
            padding:3px 10px;
            border-radius:999px;
            background:#E3F2FD;
            color:#1565C0;
            font-weight:600;
            margin-right:8px;
        }
        .badge-club {
            display:inline-block;
            font-size:11px;
            padding:3px 10px;
            border-radius:999px;
            background:rgba(0,0,0,0.12);
            color:#fff;
        }

        .event-layout {
            display:flex;
            flex-wrap:wrap;
            gap:24px;
        }
        .event-main {
            flex:1 1 60%;
        }
        .event-side {
            flex:0 0 320px;
        }

        .event-section-card {
            background:#fff;
            border-radius:14px;
            box-shadow:0 8px 20px rgba(0,0,0,0.06);
            padding:20px 22px;
            margin-bottom:18px;
        }
        .event-section-card h3 {
            font-size:18px;
            margin-bottom:10px;
            font-weight:700;
        }
        .event-section-card p {
            margin-bottom:6px;
        }

        .event-meta-row {
            display:flex;
            align-items:flex-start;
            margin-bottom:10px;
            font-size:14px;
        }
        .event-meta-row i {
            width:20px;
            margin-right:8px;
            color:#5E35B1;
            margin-top:2px;
        }

        .event-summary-label {
            font-size:12px;
            text-transform:uppercase;
            color:#999;
            margin-bottom:2px;
        }
        .event-summary-value {
            font-size:14px;
            font-weight:600;
            margin-bottom:10px;
        }
        .summary-capacity {
            font-size:13px;
            color:#555;
        }
        .btn-register {
            width:100%;
            border-radius:999px;
            padding:9px 16px;
            font-weight:600;
        }
        .btn-back {
            margin-top:10px;
            font-size:13px;
            display:block;
            width: fit-content;
            margin-left:auto;
            margin-right:auto;
        }

        @media (max-width: 992px) {
            .event-layout {
                flex-direction:column;
            }
            .event-side {
                flex:1 1 auto;
            }
        }
    </style>
</head>
<body>

<jsp:include page="/view/layout/header.jsp"/>

<div class="page-content bg-white">

    <c:choose>
        <c:when test="${empty event}">
            <div class="section-area section-sp1">
                <div class="container">
                    <div class="alert alert-warning">
                        Không tìm thấy thông tin sự kiện.
                    </div>
                    <a href="${pageContext.request.contextPath}/viewAllEvents" class="btn btn-secondary">
                        &laquo; Quay lại danh sách sự kiện
                    </a>
                </div>
            </div>
        </c:when>

        <c:otherwise>
            <!-- HERO -->
            <div class="event-hero-detail">
                <div class="bg-image"
                     style="background-image:url('<c:out value='${empty event.image ? (ctx.concat("/assets/images/events/default-event.jpg")) : event.image}'/>');">
                </div>
                <div class="overlay">
                    <div class="container">
                        <span class="badge-status">${event.status}</span>
                        <span class="badge-club">
                            CLB ID: ${event.clubID}
                        </span>

                        <h1>${event.eventName}</h1>
                        <p class="subtitle">
                            <i class="fa fa-calendar"></i>
                            <fmt:formatDate value="${event.startDate}" pattern="dd/MM/yyyy HH:mm"/>
                            -
                            <fmt:formatDate value="${event.endDate}" pattern="dd/MM/yyyy HH:mm"/>
                        </p>
                    </div>
                </div>
            </div>

            <div class="content-block">
                <div class="section-area section-sp1">
                    <div class="container">

                        <!-- Message sau đăng ký / check-in, nếu có -->
                        <c:if test="${not empty message}">
                            <div class="alert alert-info">
                                ${message}
                            </div>
                        </c:if>

                        <div class="event-layout">
                            <!-- Cột trái: mô tả -->
                            <div class="event-main">

                                <div class="event-section-card">
                                    <h3>Thông tin chi tiết</h3>

                                    <div class="event-meta-row">
                                        <i class="fa fa-map-marker"></i>
                                        <div>
                                            <strong>Địa điểm:</strong><br/>
                                            ${event.location}
                                        </div>
                                    </div>

                                    <div class="event-meta-row">
                                        <i class="fa fa-clock-o"></i>
                                        <div>
                                            <strong>Thời gian:</strong><br/>
                                            <fmt:formatDate value="${event.startDate}" pattern="dd/MM/yyyy HH:mm"/>
                                            &nbsp;&ndash;&nbsp;
                                            <fmt:formatDate value="${event.endDate}" pattern="dd/MM/yyyy HH:mm"/>
                                        </div>
                                    </div>

                                    <c:if test="${event.registrationStart != null}">
                                        <div class="event-meta-row">
                                            <i class="fa fa-pencil-square-o"></i>
                                            <div>
                                                <strong>Thời gian mở đăng ký:</strong><br/>
                                                <fmt:formatDate value="${event.registrationStart}" pattern="dd/MM/yyyy HH:mm"/>
                                                <c:if test="${event.registrationEnd != null}">
                                                    &nbsp;&ndash;&nbsp;
                                                    <fmt:formatDate value="${event.registrationEnd}" pattern="dd/MM/yyyy HH:mm"/>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>

                                <div class="event-section-card">
                                    <h3>Mô tả</h3>
                                    <c:if test="${empty event.description}">
                                        <p>Hiện chưa có mô tả chi tiết cho sự kiện này.</p>
                                    </c:if>
                                    <c:if test="${not empty event.description}">
                                        <p>${event.description}</p>
                                    </c:if>
                                </div>

                            </div>

                            <!-- Cột phải: summary + nút đăng ký / check-in -->
                            <div class="event-side">
                                <div class="event-section-card">
                                    <div class="event-summary-label">Trạng thái</div>
                                    <div class="event-summary-value">${event.status}</div>

                                    <div class="event-summary-label">Sức chứa</div>
                                    <div class="event-summary-value">
                                        ${event.capacity}
                                        <span class="summary-capacity">người tham gia tối đa</span>
                                    </div>

                                    <div class="event-summary-label">Địa điểm</div>
                                    <div class="event-summary-value">
                                        <i class="fa fa-map-marker"></i>
                                        ${event.location}
                                    </div>

                                    <!-- Nút đăng ký -->
                                    <form action="${pageContext.request.contextPath}/RegisterForEventServlet"
                                          method="post" style="margin-bottom:10px;">
                                        <input type="hidden" name="eventId" value="${event.eventID}">
                                        <button type="submit" class="btn btn-primary btn-register">
                                            Đăng ký tham gia
                                        </button>
                                    </form>

                                    <!-- FORM CHECK-IN (id = checkInForm) -->
                                    <form id="checkInForm"
                                          action="${pageContext.request.contextPath}/CheckInServlet"
                                          method="post">
                                        <input type="hidden" name="eventId" value="${event.eventID}">
                                        <button type="button"
                                                class="btn btn-success btn-register"
                                                onclick="handleCheckIn();">
                                            <i class="fa fa-check-circle mr-2"></i> Check-in tham gia
                                        </button>
                                    </form>

                                    <a href="${pageContext.request.contextPath}/viewAllEvents"
                                       class="btn btn-link btn-back">
                                        &laquo; Quay lại danh sách sự kiện
                                    </a>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/view/layout/footer.jsp"/>

<script src="<%=ctx%>/assets/js/jquery.min.js"></script>
<script src="<%=ctx%>/assets/vendors/bootstrap/js/popper.min.js"></script>
<script src="<%=ctx%>/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
<script src="<%=ctx%>/assets/js/functions.js"></script>

<script>
function handleCheckIn() {
    <%-- Nếu chưa login --%>
    <c:choose>
        <c:when test="${empty account}">
            if (confirm('Bạn cần đăng nhập để check-in.\nBạn có muốn đăng nhập ngay bây giờ?')) {
                window.location.href =
                    '${pageContext.request.contextPath}/login'
                    + '?redirect=ViewAllEventsServlet'
                    + '&eventId=${event.eventID}';
            }
        </c:when>
        <c:otherwise>
            if (confirm('Xác nhận bạn đang có mặt tại sự kiện và muốn check-in?')) {
                var form = document.getElementById('checkInForm');
                if (form) {
                    form.submit();
                }
            }
        </c:otherwise>
    </c:choose>
}
</script>
</body>
</html>
