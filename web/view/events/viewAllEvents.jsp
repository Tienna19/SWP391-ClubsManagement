<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <title>Sự kiện - StuClub</title>

    <!-- CSS chung -->
    <link rel="stylesheet" type="text/css" href="<%=ctx%>/assets/css/assets.css">
    <link rel="stylesheet" type="text/css" href="<%=ctx%>/assets/css/typography.css">
    <link rel="stylesheet" type="text/css" href="<%=ctx%>/assets/css/shortcodes/shortcodes.css">
    <link rel="stylesheet" type="text/css" href="<%=ctx%>/assets/css/style.css">
    <link rel="stylesheet" type="text/css" href="<%=ctx%>/assets/css/dashboard.css">
    <link class="skin" rel="stylesheet" type="text/css" href="<%=ctx%>/assets/css/color/color-1.css">

    <style>
        .event-hero {
            background: linear-gradient(120deg, #5E35B1, #7E57C2);
            color: #fff;
            padding: 40px 0 30px 0;
            text-align: center;
            margin-bottom: 20px;
        }
        .event-hero h1 {
            font-size: 34px;      /* TO HƠN */
            margin-bottom: 8px;
            font-weight: 800;
            color: #ffffff;       /* ĐẢM BẢO MÀU TRẮNG */
        }
        .event-hero p {
            margin: 0;
            opacity: .95;
        }
        .event-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill,minmax(280px,1fr));
            gap: 24px;
        }
        .event-card {
            background: #fff;
            border-radius: 14px;
            overflow: hidden;
            box-shadow: 0 8px 20px rgba(0,0,0,0.08);
            display: flex;
            flex-direction: column;
            transition: transform .18s ease, box-shadow .18s ease;
        }
        .event-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 16px 30px rgba(0,0,0,0.14);
        }
        .event-card img {
            width: 100%;
            height: 170px;
            object-fit: cover;
        }
        .event-body {
            padding: 14px 16px 16px;
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        .event-title {
            font-size: 17px;
            font-weight: 700;
            margin: 4px 0 6px;
            color: #333;
        }
        .event-meta {
            font-size: 13px;
            color: #777;
            margin-bottom: 6px;
        }
        .event-location {
            font-size: 13px;
            color: #555;
        }
        .event-footer {
            padding: 0 16px 14px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .event-date-chip {
            font-size: 12px;
            background: #E8EAF6;
            color: #303F9F;
            padding: 4px 10px;
            border-radius: 999px;
            font-weight: 600;
        }
        .event-actions a {
            font-size: 13px;
            padding: 6px 12px;
            border-radius: 999px;
        }
        .badge-status {
            display:inline-block;
            font-size:11px;
            padding:2px 8px;
            border-radius:999px;
            background:#E3F2FD;
            color:#1565C0;
            font-weight:600;
            margin-bottom:4px;
        }
    </style>
</head>
<body>

<!-- Header chung -->
<jsp:include page="/view/layout/header.jsp"/>

<div class="page-content bg-white">

    <!-- Banner / hero -->
    <div class="event-hero">
        <div class="container">
            <h1>Sự kiện đang diễn ra &amp; sắp tới</h1>
            <p>Khám phá các hoạt động thú vị từ các câu lạc bộ trong trường</p>
        </div>
    </div>

    <div class="content-block">
        <div class="section-area section-sp1">
            <div class="container">

                <!-- Thông báo -->
                <c:if test="${not empty message}">
                    <div class="alert alert-info">
                        ${message}
                    </div>
                </c:if>

                <!-- Thanh TÌM KIẾM + LỌC CLB -->
                <div class="card m-b30 shadow-sm">
                    <div class="card-body">
                        <form class="row g-3 align-items-end" method="get" action="${pageContext.request.contextPath}/viewAllEvents">
                            <div class="col-md-6">
                                <label class="form-label">Tìm kiếm sự kiện</label>
                                <input type="text"
                                       name="keyword"
                                       class="form-control"
                                       value="<c:out value='${keyword}'/>"
                                       placeholder="Nhập tên sự kiện, địa điểm...">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Câu lạc bộ tổ chức</label>
                                <select name="clubId" class="form-control">
                                    <option value="">Tất cả CLB</option>
                                    <c:forEach var="cClub" items="${clubs}">
                                        <option value="${cClub.clubID}"
                                            <c:if test="${selectedClubId != null && selectedClubId == cClub.clubID}">
                                                selected
                                            </c:if>>
                                            ${cClub.clubName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-3 text-md-right">
                                <button type="submit" class="btn btn-primary w-100" style="margin-top:27px;">
                                    <i class="fa fa-search mr-1"></i> Lọc sự kiện
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Không có sự kiện -->
                <c:if test="${empty events}">
                    <div class="text-center text-muted m-t20">
                        Hiện chưa có sự kiện Published nào phù hợp với bộ lọc.
                    </div>
                </c:if>

                <!-- Grid sự kiện -->
                <c:if test="${not empty events}">
                    <div class="event-grid">
                        <c:forEach var="e" items="${events}">
                            <div class="event-card">
                                <img src="<c:out value='${empty e.image ? (ctx.concat("/assets/images/events/default-event.jpg")) : e.image}'/>"
                                     alt="${e.eventName}"/>

                                <div class="event-body">
                                    <span class="badge-status">
                                        ${e.status}
                                    </span>

                                    <div class="event-title">
                                        ${e.eventName}
                                    </div>

                                    <div class="event-meta">
                                        <i class="fa fa-calendar"></i>
                                        <fmt:formatDate value="${e.startDate}" pattern="dd/MM/yyyy HH:mm"/>
                                        -
                                        <fmt:formatDate value="${e.endDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </div>

                                    <div class="event-location">
                                        <i class="fa fa-map-marker"></i>
                                        ${e.location}
                                    </div>
                                </div>

                                <div class="event-footer">
                                    <span class="event-date-chip">
                                        <i class="fa fa-users"></i>
                                        Sức chứa: ${e.capacity}
                                    </span>
                                    <div class="event-actions">
                                        <c:url var="detailUrl" value="/viewAllEvents">
                                            <c:param name="eventId" value="${e.eventID}"/>
                                        </c:url>
                                        <a href="${detailUrl}" class="btn btn-sm btn-warning">
                                            Xem chi tiết
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>

                <!-- PHÂN TRANG -->
                <c:if test="${totalPages > 1}">
                    <nav class="m-t30">
                        <ul class="pagination justify-content-center">

                            <!-- Prev -->
                            <c:if test="${currentPage > 1}">
                                <c:url var="prevUrl" value="/viewAllEvents">
                                    <c:param name="page" value="${currentPage - 1}"/>
                                    <c:if test="${not empty keyword}">
                                        <c:param name="keyword" value="${keyword}"/>
                                    </c:if>
                                    <c:if test="${selectedClubId != null}">
                                        <c:param name="clubId" value="${selectedClubId}"/>
                                    </c:if>
                                </c:url>
                                <li class="page-item">
                                    <a class="page-link" href="${prevUrl}">Trước</a>
                                </li>
                            </c:if>

                            <!-- Các trang -->
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <c:url var="pageUrl" value="/viewAllEvents">
                                    <c:param name="page" value="${i}"/>
                                    <c:if test="${not empty keyword}">
                                        <c:param name="keyword" value="${keyword}"/>
                                    </c:if>
                                    <c:if test="${selectedClubId != null}">
                                        <c:param name="clubId" value="${selectedClubId}"/>
                                    </c:if>
                                </c:url>
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="${pageUrl}">${i}</a>
                                </li>
                            </c:forEach>

                            <!-- Next -->
                            <c:if test="${currentPage < totalPages}">
                                <c:url var="nextUrl" value="/viewAllEvents">
                                    <c:param name="page" value="${currentPage + 1}"/>
                                    <c:if test="${not empty keyword}">
                                        <c:param name="keyword" value="${keyword}"/>
                                    </c:if>
                                    <c:if test="${selectedClubId != null}">
                                        <c:param name="clubId" value="${selectedClubId}"/>
                                    </c:if>
                                </c:url>
                                <li class="page-item">
                                    <a class="page-link" href="${nextUrl}">Sau</a>
                                </li>
                            </c:if>

                        </ul>
                    </nav>
                </c:if>

            </div>
        </div>
    </div>

</div>

<jsp:include page="/view/layout/footer.jsp"/>

<script src="<%=ctx%>/assets/js/jquery.min.js"></script>
<script src="<%=ctx%>/assets/vendors/bootstrap/js/popper.min.js"></script>
<script src="<%=ctx%>/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
<script src="<%=ctx%>/assets/js/functions.js"></script>

</body>
</html>
