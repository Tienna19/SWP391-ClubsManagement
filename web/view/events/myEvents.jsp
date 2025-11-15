<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%String ctx = request.getContextPath();%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>My Event Participation - StuClub</title>
    <link rel="stylesheet" type="text/css" href="<%=ctx%>/assets/css/assets.css">
    <link rel="stylesheet" type="text/css" href="<%=ctx%>/assets/css/style.css">
    <link rel="stylesheet" type="text/css" href="<%=ctx%>/assets/css/dashboard.css">
    <link class="skin" rel="stylesheet" type="text/css" href="<%=ctx%>/assets/css/color/color-1.css">

    <style>
        .page-title {
            text-align: center;
            margin: 25px 0 10px;
            font-size: 26px;
            font-weight: 700;
            color: #4527A0;
        }
        .subtitle {
            text-align: center;
            color: #777;
            margin-bottom: 25px;
        }
        .filter-box {
            background: #fff;
            border-radius: 12px;
            padding: 16px 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.06);
            margin-bottom: 20px;
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            align-items: flex-end;
        }
        .filter-box .form-control {
            min-width: 180px;
        }
        .table-history {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.06);
        }
        .table-history table {
            width: 100%;
            border-collapse: collapse;
        }
        .table-history th,
        .table-history td {
            padding: 10px 14px;
            font-size: 14px;
        }
        .table-history th {
            background: #f5f5f5;
            font-weight: 600;
        }
        .badge-status {
            display:inline-block;
            padding:3px 8px;
            border-radius:999px;
            font-size:11px;
        }
        .badge-status.Upcoming { background:#E3F2FD; color:#1565C0; }
        .badge-status.Ongoing { background:#E8F5E9; color:#2E7D32; }
        .badge-status.Completed { background:#FFF3E0; color:#EF6C00; }
        .badge-status.Cancelled { background:#FFEBEE; color:#C62828; }

        .badge-checkin {
            display:inline-block;
            padding:3px 8px;
            border-radius:999px;
            font-size:11px;
        }
        .badge-checkin.yes { background:#E8F5E9; color:#2E7D32; }
        .badge-checkin.no  { background:#FFFDE7; color:#F9A825; }

        .pagination {
            margin-top: 18px;
            text-align: center;
        }
        .pagination a,
        .pagination span {
            display:inline-block;
            padding:4px 10px;
            margin:0 2px;
            border-radius:4px;
            border:1px solid #ddd;
            font-size:13px;
            text-decoration:none;
            color:#444;
        }
        .pagination .active {
            background:#5E35B1;
            color:#fff;
            border-color:#5E35B1;
        }
        .filter-field {
            display: flex;
            flex-direction: column;
        }

        .filter-label {
            font-size: 12px;
            font-weight: 600;
            color: #666;
            margin-bottom: 4px;
        }

    </style>
</head>
<body class="ttr-opened-sidebar">

<jsp:include page="/view/layout/header.jsp"/>

<div class="page-content bg-light">
    <div class="container">

        <h1 class="page-title">Sự kiện mà tôi tham gia</h1>
        <div class="subtitle">
            Xem tất cả các sự kiện bạn đã đăng ký, bao gồm trạng thái và lịch sử đăng ký.
        </div>

        <!-- Filter box -->
        <form method="get" action="${pageContext.request.contextPath}/myEvents" class="filter-box">
            <input type="text" name="keyword" class="form-control"
                   placeholder="Search event name..."
                   value="${fn:escapeXml(keyword)}"/>

            <div class="filter-field">
                <label for="fromDate" class="filter-label">Từ ngày</label>
                    <input type="date" id="fromDate" name="fromDate" class="form-control" value="${fromDate}"/>
            </div>

            <div class="filter-field">
                <label for="toDate" class="filter-label">Đến ngày</label>
                    <input type="date" id="toDate" name="toDate" class="form-control" value="${toDate}"/>
            </div>

            <div class="filter-field">
            <label for="status" class="filter-label">Trạng thái</label>
            <select name="status" class="form-control">
                <c:set var="st" value="${statusFilter}" />
                <option value="All" ${st == 'All' ? 'selected' : ''}>All status</option>
                <option value="Upcoming"  ${st == 'Upcoming'  ? 'selected' : ''}>Upcoming</option>
                <option value="Ongoing"   ${st == 'Ongoing'   ? 'selected' : ''}>Ongoing</option>
                <option value="Completed" ${st == 'Completed' ? 'selected' : ''}>Completed</option>
                <option value="Cancelled" ${st == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
            </select>
            </div>
            
            <div class="filter-field">
                <label class="filter-label">&nbsp;</label> 
                <button type="submit" class="btn btn-primary">
                Filter
                </button>
            </div>
        </form>

        <!-- Error message -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <!-- Table -->
        <div class="table-history">
            <c:if test="${empty history}">
                <p style="padding:16px;">No event participation records found.</p>
            </c:if>

            <c:if test="${not empty history}">
                <table>
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>Tên sự kiện</th>
                        <th>Club</th>
                        <th>Thời gian sự kiện</th>
                        <th>Đăng kí vào</th>
                        <th>Trạng thái</th>
                        <th>Check-in</th>
                        <th>Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="item" items="${history}" varStatus="loop">
                        <tr>
                            <td>${(currentPage - 1) * 10 + loop.index + 1}</td>
                            <td>${item.eventName}</td>
                            <td>${item.clubName}</td>
                            <td>
                                <fmt:formatDate value="${item.startDate}" pattern="dd/MM/yyyy HH:mm"/>
                                –
                                <fmt:formatDate value="${item.endDate}" pattern="dd/MM/yyyy HH:mm"/>
                            </td>
                            <td>
                                <fmt:formatDate value="${item.registeredAt}" pattern="dd/MM/yyyy HH:mm"/>
                            </td>
                            <td>
                                <span class="badge-status ${item.status}">
                                    ${item.status}
                                </span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${item.checkIn}">
                                        <span class="badge-checkin yes">Checked-in</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge-checkin no">Not checked-in</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/ViewAllEventsServlet?eventId=${item.eventId}"
                                   class="btn btn-sm btn-outline-primary">
                                    View detail
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <div class="pagination">
                <c:forEach begin="1" end="${totalPages}" var="p">
                    <c:choose>
                        <c:when test="${p == currentPage}">
                            <span class="active">${p}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/myEvents?page=${p}
                                     &keyword=${fn:escapeXml(keyword)}
                                     &fromDate=${fromDate}
                                     &toDate=${toDate}
                                     &status=${statusFilter}">
                                ${p}
                            </a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </div>
        </c:if>

    </div>
</div>

<jsp:include page="/view/layout/footer.jsp"/>

<script src="<%=ctx%>/assets/js/jquery.min.js"></script>
<script src="<%=ctx%>/assets/vendors/bootstrap/js/popper.min.js"></script>
<script src="<%=ctx%>/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
<script src="<%=ctx%>/assets/js/functions.js"></script>
</body>
</html>
