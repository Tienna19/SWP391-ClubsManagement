<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Quản lý sự kiện - Admin</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/assets.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/typography.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/shortcodes.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">
    <style>
        .event-card {
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 10px 25px rgba(94,53,177,0.08);
            padding: 20px;
            margin-bottom: 22px;
            transition: transform .2s ease, box-shadow .2s ease;
        }
        .event-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 18px 35px rgba(94,53,177,0.18);
        }
        .status-pill {
            border-radius: 999px;
            padding: 6px 12px;
            font-size: 12px;
            font-weight: 600;
        }
    </style>
</head>
<body class="ttr-opened-sidebar ttr-pinned-sidebar admin-theme-loaded">
<%@ include file="/WEB-INF/jspf/admin-layout.jspf" %>

<main class="ttr-wrapper">
    <div class="container-fluid">
        <div class="db-breadcrumb">
            <h4 class="breadcrumb-title">Danh sách sự kiện</h4>
            <ul class="db-breadcrumb-list">
                <li><a href="${pageContext.request.contextPath}/adminDashboard"><i class="fa fa-home"></i>Dashboard</a></li>
                <li>Quản lý sự kiện</li>
                <li>Danh sách sự kiện</li>
            </ul>
        </div>

        <div class="row g-3 m-b30">
            <div class="col-md-3 col-sm-6">
                <div class="widget-card widget-bg1">
                    <div class="wc-item">
                        <h4 class="wc-title">Tổng sự kiện</h4>
                        <span class="wc-stats">${totalEvents}</span>
                        <span class="wc-des">Bao gồm cả sự kiện đã phê duyệt</span>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="widget-card widget-bg2">
                    <div class="wc-item">
                        <h4 class="wc-title">Đã xuất bản</h4>
                        <span class="wc-stats">${publishedEvents}</span>
                        <span class="wc-des">Hiển thị với người dùng</span>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="widget-card widget-bg3">
                    <div class="wc-item">
                        <h4 class="wc-title">Chờ duyệt</h4>
                        <span class="wc-stats">${pendingEventsCount}</span>
                        <span class="wc-des">Yêu cầu từ Club Leader</span>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="widget-card widget-bg4">
                    <div class="wc-item">
                        <h4 class="wc-title">Bản nháp</h4>
                        <span class="wc-stats">${draftEventsCount}</span>
                        <span class="wc-des">Sự kiện cần hoàn thiện</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="card shadow-sm m-b30">
            <div class="card-body">
                <form class="row g-3 align-items-end" method="get" action="${pageContext.request.contextPath}/admin-event-list">
                    <div class="col-md-5">
                        <label class="form-label">Tìm kiếm</label>
                        <input type="text" name="search" class="form-control" value="${searchTerm}" placeholder="Nhập tên sự kiện hoặc địa điểm">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Trạng thái</label>
                        <select name="status" class="form-control">
                            <option value=""<c:if test="${empty statusFilter}"> selected="selected"</c:if>>Tất cả</option>
                            <option value="Published"<c:if test="${statusFilter eq 'Published'}"> selected="selected"</c:if>>Published</option>
                            <option value="Pending"<c:if test="${statusFilter eq 'Pending'}"> selected="selected"</c:if>>Pending</option>
                            <option value="Draft"<c:if test="${statusFilter eq 'Draft'}"> selected="selected"</c:if>>Draft</option>
                            <option value="Approved"<c:if test="${statusFilter eq 'Approved'}"> selected="selected"</c:if>>Approved</option>
                            <option value="Rejected"<c:if test="${statusFilter eq 'Rejected'}"> selected="selected"</c:if>>Rejected</option>
                            <option value="Completed"<c:if test="${statusFilter eq 'Completed'}"> selected="selected"</c:if>>Completed</option>
                        </select>
                    </div>
                    <div class="col-md-3 text-md-end">
                        <button type="submit" class="btn btn-primary w-100"><i class="fa fa-search mr-1"></i>Lọc kết quả</button>
                    </div>
                </form>
            </div>
        </div>

        <c:if test="${not empty pendingEvents}">
            <div class="card shadow-sm m-b30">
                <div class="card-header bg-warning text-white d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="fa fa-clock-o mr-2"></i>Sự kiện đang chờ phê duyệt</h5>
                    <span>${fn:length(pendingEvents)} yêu cầu</span>
                </div>
                <div class="card-body">
                    <div class="row">
                        <c:forEach items="${pendingEvents}" var="event">
                            <c:set var="requestId" value="${event.eventID lt 0 ? -(event.eventID + 1000000) : event.eventID}" />
                            <c:set var="escapedName" value="${event.eventName != null ? fn:escapeXml(event.eventName) : ''}" />
                            <div class="col-xl-6">
                                <div class="event-card">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <div>
                                            <h5 class="mb-1">${event.eventName}</h5>
                                            <small class="text-muted"><i class="fa fa-map-marker mr-1"></i>${event.location}</small>
                                        </div>
                                        <span class="badge badge-warning status-pill">Pending</span>
                                    </div>
                                    <p class="text-muted mb-3">${event.description}</p>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="text-muted small">
                                            <i class="fa fa-calendar mr-1"></i>
                                            <fmt:formatDate value="${event.startDate}" pattern="dd/MM/yyyy HH:mm"/>
                                        </div>
                                        <div>
                                                <button type="button" class="btn btn-success btn-sm mr-1" onclick="submitEventAction('approve', '${requestId}', '${escapedName}')"><i class="fa fa-check"></i> Duyệt</button>
                                                <button type="button" class="btn btn-outline-danger btn-sm" onclick="submitEventAction('reject', '${requestId}', '${escapedName}')"><i class="fa fa-times"></i> Từ chối</button>
                                            </div>
                                        </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </c:if>

        <div class="card shadow-sm m-b30">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0"><i class="fa fa-list mr-2"></i>Danh sách sự kiện</h5>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="thead-light">
                            <tr>
                                <th>Tên sự kiện</th>
                                <th>CLB</th>
                                <th>Bắt đầu</th>
                                <th>Kết thúc</th>
                                <th>Sức chứa</th>
                                <th>Trạng thái</th>
                                <th class="text-right">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty events}">
                                    <tr>
                                        <td colspan="7" class="text-center py-4 text-muted">Không có sự kiện nào phù hợp.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${events}" var="event">
                                        <tr>
                                            <td>
                                                <strong>${event.eventName}</strong>
                                                <br>
                                                <small class="text-muted">${event.location}</small>
                                            </td>
                                            <td>CLB #${event.clubID}</td>
                                            <td><fmt:formatDate value="${event.startDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                            <td><fmt:formatDate value="${event.endDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                            <td>${event.capacity}</td>
                                            <td>
                                                <span class="status-pill badge ${event.status eq 'Published' ? 'badge-success' : event.status eq 'Draft' ? 'badge-secondary' : event.status eq 'Rejected' ? 'badge-danger' : 'badge-info'}">
                                                    ${event.status}
                                                </span>
                                            </td>
                                            <td class="text-right">
                                                <a href="${pageContext.request.contextPath}/viewEvent?eventId=${event.eventID}" class="btn btn-sm btn-outline-primary"><i class="fa fa-eye"></i> Chi tiết</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
            <c:if test="${totalPages > 1}">
                <div class="card-footer">
                    <nav>
                        <ul class="pagination justify-content-end mb-0">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item"><a class="page-link" href="?page=${currentPage - 1}&search=${searchTerm}&status=${statusFilter}">Trước</a></li>
                            </c:if>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}"><a class="page-link" href="?page=${i}&search=${searchTerm}&status=${statusFilter}">${i}</a></li>
                            </c:forEach>
                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item"><a class="page-link" href="?page=${currentPage + 1}&search=${searchTerm}&status=${statusFilter}">Sau</a></li>
                            </c:if>
                        </ul>
                    </nav>
                </div>
            </c:if>
        </div>

        <c:if test="${not empty draftEvents}">
            <div class="card shadow-sm m-b30">
                <div class="card-header bg-secondary text-white">
                    <h5 class="mb-0"><i class="fa fa-pencil mr-2"></i>Bản nháp</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <c:forEach items="${draftEvents}" var="event">
                            <div class="col-xl-4 col-lg-6">
                                <div class="event-card">
                                    <h5 class="mb-2">${event.eventName}</h5>
                                    <p class="text-muted mb-3">${event.description}</p>
                                    <small class="text-muted"><i class="fa fa-calendar mr-1"></i><fmt:formatDate value="${event.startDate}" pattern="dd/MM/yyyy HH:mm"/></small>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </c:if>
    </div>
</main>
<form id="eventActionForm" method="post" action="${pageContext.request.contextPath}/approveRejectEvent" style="display:none;">
    <input type="hidden" name="requestId" id="eventActionRequestId">
    <input type="hidden" name="action" id="eventActionType">
    <input type="hidden" name="reviewComment" id="eventActionComment">
</form>
<div class="ttr-overlay"></div>

<script src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/popper.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap-select/bootstrap-select.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/scroll/scrollbar.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/file-upload/imageuploadify.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/functions.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin.js"></script>
<script>
    (function () {
        function adjustSidebar() {
            if (window.innerWidth <= 1024) {
                document.body.classList.remove('ttr-opened-sidebar');
                document.body.classList.remove('ttr-pinned-sidebar');
            } else {
                document.body.classList.add('ttr-opened-sidebar');
                document.body.classList.add('ttr-pinned-sidebar');
            }
        }
        adjustSidebar();
        window.addEventListener('resize', adjustSidebar);
    })();

    window.submitEventAction = function(action, requestId, eventName) {
        if (action === 'approve') {
            if (!confirm('Bạn có chắc chắn muốn phê duyệt sự kiện "' + eventName + '"?')) {
                return;
            }
            document.getElementById('eventActionComment').value = '';
        } else {
            var reason = prompt('Nhập lý do từ chối cho sự kiện "' + eventName + '":');
            if (reason === null || reason.trim() === '') {
                return;
            }
            document.getElementById('eventActionComment').value = reason.trim();
        }
        document.getElementById('eventActionRequestId').value = requestId;
        document.getElementById('eventActionType').value = action;
        document.getElementById('eventActionForm').submit();
    };
</script>
</body>
</html>
