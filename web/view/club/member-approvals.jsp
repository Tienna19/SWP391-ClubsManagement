<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Phê duyệt thành viên - ${club.clubName}</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" type="image/x-icon" />
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/assets.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/typography.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/shortcodes.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">
    <style>
        .page-title {
            font-weight: 700;
            color: #2b2350;
        }
        .summary-card {
            border-radius: 24px;
            padding: 24px;
            background: linear-gradient(135deg, rgba(94,53,177,0.12), rgba(63,81,181,0.05));
            border: 1px solid rgba(94,53,177,0.15);
            height: 100%;
        }
        .summary-card .number {
            font-size: 36px;
            font-weight: 700;
            color: #2b2350;
            line-height: 1;
        }
        .tag-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 11px;
            background: rgba(33, 150, 243, 0.12);
            color: #1a73e8;
        }
        .status-tabs .nav-link {
            border-radius: 16px;
            padding: 10px 18px;
            font-weight: 600;
            color: #5E35B1;
            border: none;
        }
        .status-tabs .nav-link.active {
            background: rgba(94,53,177,0.12);
            color: #4527A0;
        }
        .filter-select {
            border-radius: 16px;
            padding: 10px 16px;
            border: 1px solid #e3e6f0;
            background-position: right 14px center;
        }
        .request-card {
            border-radius: 24px;
            border: 1px solid rgba(94,53,177,0.1);
            box-shadow: 0 18px 34px rgba(31, 43, 90, 0.08);
            padding: 24px;
            background: #fff;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .request-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 22px 40px rgba(31, 43, 90, 0.12);
        }
        .request-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
        }
        .request-badge.pending {
            background: rgba(255, 171, 0, 0.18);
            color: #ff6f00;
        }
        .request-badge.approved {
            background: rgba(76, 175, 80, 0.18);
            color: #2e7d32;
        }
        .request-badge.rejected {
            background: rgba(244, 67, 54, 0.18);
            color: #c62828;
        }
        .avatar {
            width: 64px;
            height: 64px;
            border-radius: 16px;
            object-fit: cover;
            background: #f3f4fb;
        }
        .action-buttons .btn {
            border-radius: 14px;
            padding: 10px 20px;
            min-width: 120px;
        }
        .empty-state {
            padding: 60px;
            text-align: center;
            background: #fff;
            border-radius: 24px;
            box-shadow: 0 18px 34px rgba(31, 43, 90, 0.08);
            color: #5E35B1;
        }
        .flash-message {
            border-radius: 16px;
            padding: 14px 18px;
            border: none;
        }
    </style>
</head>
<body class="ttr-opened-sidebar ttr-pinned-sidebar">
<jsp:include page="/WEB-INF/jspf/leader-layout.jspf"/>

<main class="ttr-wrapper">
    <div class="container-fluid">
        <div class="db-breadcrumb">
            <h4 class="breadcrumb-title page-title">Phê duyệt thành viên</h4>
            <ul class="db-breadcrumb-list">
                <li><a href="${pageContext.request.contextPath}/clubDashboard?clubId=${clubId}"><i class="fa fa-home"></i>Dashboard</a></li>
                <li>Thành viên</li>
                <li>Phê duyệt</li>
            </ul>
        </div>

        <c:if test="${not empty flashMessage}">
            <div class="alert alert-${flashType != null ? flashType : 'info'} flash-message alert-dismissible fade show">
                <i class="fa fa-info-circle me-2"></i>${flashMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="row g-4 m-b30">
            <div class="col-lg-4 col-md-6">
                <div class="summary-card">
                    <span class="tag-pill"><i class="fa fa-hourglass-half"></i> Đang chờ duyệt</span>
                    <div class="number mt-3">${pendingRequests}</div>
                    <p class="mb-0 text-muted">Số yêu cầu đang chờ xử lý.</p>
                </div>
            </div>
            <div class="col-lg-4 col-md-6">
                <div class="summary-card">
                    <span class="tag-pill" style="background:rgba(76,175,80,0.14);color:#2e7d32;"><i class="fa fa-check-circle"></i> Đã phê duyệt</span>
                    <div class="number mt-3">
                        <c:set var="approvedCount" value="0"/>
                        <c:forEach items="${requests}" var="req">
                            <c:if test="${req.status eq 'Approved'}">
                                <c:set var="approvedCount" value="${approvedCount + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${approvedCount}
                    </div>
                    <p class="mb-0 text-muted">Phê duyệt trong danh sách hiển thị.</p>
                </div>
            </div>
            <div class="col-lg-4 col-md-6">
                <div class="summary-card">
                    <span class="tag-pill" style="background:rgba(244,67,54,0.14);color:#c62828;"><i class="fa fa-times-circle"></i> Đã từ chối</span>
                    <div class="number mt-3">
                        <c:set var="rejectedCount" value="0"/>
                        <c:forEach items="${requests}" var="req">
                            <c:if test="${req.status eq 'Rejected'}">
                                <c:set var="rejectedCount" value="${rejectedCount + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${rejectedCount}
                    </div>
                    <p class="mb-0 text-muted">Từ chối trong danh sách hiển thị.</p>
                </div>
            </div>
        </div>

        <ul class="nav nav-pills status-tabs mb-4" role="tablist">
            <li class="nav-item">
                <a class="nav-link ${statusFilter eq 'pending' ? 'active' : ''}" href="${pageContext.request.contextPath}/memberApprovals?clubId=${clubId}&status=pending">Đang chờ</a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${statusFilter eq 'approved' ? 'active' : ''}" href="${pageContext.request.contextPath}/memberApprovals?clubId=${clubId}&status=approved">Đã duyệt</a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${statusFilter eq 'rejected' ? 'active' : ''}" href="${pageContext.request.contextPath}/memberApprovals?clubId=${clubId}&status=rejected">Đã từ chối</a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${statusFilter eq 'all' ? 'active' : ''}" href="${pageContext.request.contextPath}/memberApprovals?clubId=${clubId}&status=all">Tất cả</a>
            </li>
        </ul>

        <c:choose>
            <c:when test="${empty requests}">
                <div class="empty-state">
                    <i class="fa fa-inbox fa-3x mb-3"></i>
                    <h4 class="mb-2">Không có yêu cầu nào trong trạng thái này</h4>
                    <p class="mb-0">Khi có sinh viên gửi yêu cầu tham gia CLB, chúng sẽ xuất hiện tại đây.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row g-4">
                    <c:forEach items="${requests}" var="req">
                        <div class="col-xl-6">
                            <c:set var="avatarSrc" value="${pageContext.request.contextPath}/assets/images/testimonials/pic1.jpg"/>
                            <c:if test="${not empty req.profileImage}">
                                <c:choose>
                                    <c:when test="${fn:startsWith(req.profileImage, 'http')}">
                                        <c:set var="avatarSrc" value="${req.profileImage}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="avatarSrc" value="${pageContext.request.contextPath}/${req.profileImage}"/>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                            <div class="request-card">
                                <div class="d-flex justify-content-between align-items-start flex-wrap gap-3">
                                    <div class="d-flex align-items-center gap-3">
                                        <img class="avatar" src="${avatarSrc}" alt="${req.studentName}">
                                        <div>
                                            <h5 class="mb-1">${req.studentName}</h5>
                                            <div class="text-muted small">${req.studentEmail != null ? req.studentEmail : 'Không có email'}</div>
                                            <div class="text-muted small mt-1">
                                                <i class="fa fa-calendar me-1"></i>
                                                <c:choose>
                                                    <c:when test="${not empty req.createdAtDisplay}">${req.createdAtDisplay}</c:when>
                                                    <c:otherwise>${req.requestDate}</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                    <span class="request-badge ${fn:toLowerCase(req.status)}">
                                        <i class="fa ${req.status eq 'Approved' ? 'fa-check' : (req.status eq 'Rejected' ? 'fa-times' : 'fa-hourglass-half')}"></i>
                                        ${req.status}
                                    </span>
                                </div>

                                <div class="mt-3">
                                    <h6 class="mb-2 text-muted">Lý do tham gia</h6>
                                    <p class="mb-0">${req.reason != null && req.reason.trim().length() > 0 ? req.reason : 'Ứng viên không cung cấp lý do.'}</p>
                                </div>

                                <c:if test="${req.status eq 'Pending'}">
                                    <form method="post" class="action-buttons d-flex flex-wrap gap-2 mt-4">
                                        <input type="hidden" name="requestId" value="${req.requestId}">
                                        <input type="hidden" name="clubId" value="${clubId}">
                                        <input type="hidden" name="status" value="${statusFilter}">
                                        <button type="submit" name="action" value="approve" class="btn btn-success">
                                            <i class="fa fa-check me-1"></i>Phê duyệt
                                        </button>
                                        <button type="submit" name="action" value="reject" class="btn btn-outline-danger">
                                            <i class="fa fa-times me-1"></i>Từ chối
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>
<div class="ttr-overlay"></div>

<script src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/popper.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/functions.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin.js"></script>
</body>
</html>

