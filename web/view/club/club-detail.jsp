<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết CLB - ${club.clubName}</title>
    <link href="${pageContext.request.contextPath}/assets/vendors/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendors/fontawesome/css/font-awesome.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
    
    <style>
        body {
            background: #f7f8fc;
        }
        .club-hero {
            position: relative;
            padding: 100px 0 70px;
            background: linear-gradient(120deg, rgba(94,53,177,1) 0%, rgba(63,81,181,1) 70%, rgba(33,150,243,1) 100%);
            color: #fff;
            overflow: hidden;
        }
        .club-hero::before {
            content: "";
            position: absolute;
            inset: 0;
            background: radial-gradient(circle at 20% 20%, rgba(255,255,255,0.25), transparent 50%),
                        radial-gradient(circle at 80% 10%, rgba(255,255,255,0.18), transparent 45%);
            pointer-events: none;
        }
        .club-hero .container {
            position: relative;
            z-index: 1;
        }
        .club-logo-wrapper {
            width: 160px;
            height: 160px;
            border-radius: 28px;
            padding: 6px;
            background: rgba(255,255,255,0.2);
            box-shadow: 0 18px 40px rgba(21, 22, 79, 0.3);
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
        .club-logo-wrapper img,
        .club-logo-placeholder {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 22px;
            background: #fff;
        }
        .club-logo-placeholder {
            display: flex;
            align-items: center;
            justify-content: center;
            color: #5E35B1;
            font-size: 48px;
        }
        .category-pill,
        .status-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            border-radius: 999px;
            font-weight: 600;
            font-size: 13px;
            margin-right: 10px;
        }
        .category-pill {
            background: rgba(255,255,255,0.14);
        }
        .status-pill.active {
            background: rgba(76, 175, 80, 0.25);
            color: #e8ffe9;
        }
        .status-pill.inactive {
            background: rgba(255,255,255,0.18);
            color: rgba(255,255,255,0.85);
        }
        .club-meta {
            margin-top: 18px;
            color: rgba(255,255,255,0.85);
            font-size: 14px;
        }
        .btn-join {
            background: #43d17c;
            border: none;
            color: #0f5132;
            font-weight: 600;
            padding: 12px 26px;
            border-radius: 50px;
            box-shadow: 0 16px 35px rgba(67,209,124,0.35);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .btn-join:hover {
            transform: translateY(-2px);
            box-shadow: 0 22px 45px rgba(67,209,124,0.45);
        }
        .btn-glass {
            border-radius: 40px;
            border: 1px solid rgba(255,255,255,0.45);
            color: #fff;
            backdrop-filter: blur(10px);
            background: rgba(255,255,255,0.12);
            padding: 10px 20px;
        }
        .btn-glass:hover {
            background: rgba(255,255,255,0.22);
        }
        .stats-wrapper {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 20px;
            margin-bottom: 28px;
        }
        .stat-card {
            background: #fff;
            border-radius: 22px;
            padding: 24px 26px;
            box-shadow: 0 20px 35px rgba(31, 43, 90, 0.1);
            display: flex;
            align-items: center;
            gap: 18px;
        }
        .stat-icon {
            width: 52px;
            height: 52px;
            border-radius: 16px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            color: #fff;
        }
        .stat-value {
            font-size: 32px;
            font-weight: 700;
            color: #2b2350;
            line-height: 1.1;
        }
        .stat-label {
            color: #7a8196;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .section-card {
            background: #fff;
            border-radius: 22px;
            box-shadow: 0 20px 35px rgba(31, 43, 90, 0.08);
            margin-bottom: 28px;
            border: none;
        }
        .section-card .card-header {
            background: transparent;
            border-bottom: 1px solid rgba(98, 109, 147, 0.1);
            padding: 22px 26px;
        }
        .section-card .card-body {
            padding: 24px 26px 28px;
            color: #4a5170;
            line-height: 1.7;
        }
        .club-tabs .nav-link {
            border: none;
            border-radius: 18px;
            padding: 10px 20px;
            font-weight: 600;
            color: #5E35B1;
        }
        .club-tabs .nav-link.active {
            background: rgba(94,53,177,0.12);
            color: #4527A0;
        }
        .table-modern thead {
            background: rgba(94,53,177,0.08);
        }
        .table-modern thead th {
            border: none;
            color: #4527A0;
            text-transform: uppercase;
            font-size: 12px;
            letter-spacing: 1px;
        }
        .table-modern tbody tr:hover {
            background: rgba(94,53,177,0.05);
        }
        .label-role {
            padding: 6px 12px;
            border-radius: 999px;
            font-weight: 600;
            font-size: 12px;
        }
        .label-role.leader {
            background: rgba(244,67,54,0.15);
            color: #d32f2f;
        }
        .label-role.member {
            background: rgba(103,58,183,0.12);
            color: #512DA8;
        }
        .event-card {
            border-radius: 18px;
            border: none;
            box-shadow: 0 18px 32px rgba(31,43,90,0.1);
        }
        .event-status {
            font-size: 12px;
            font-weight: 600;
            padding: 6px 12px;
            border-radius: 999px;
        }
        .empty-state {
            background: rgba(94,53,177,0.05);
            border-radius: 18px;
            padding: 40px;
            text-align: center;
            color: #5E35B1;
        }
        @media (max-width: 767px) {
            .club-logo-wrapper {
                margin-bottom: 20px;
            }
            .stats-wrapper {
                margin-top: -20px;
            }
        }
    </style>
</head>
<body>

<jsp:include page="../layout/header.jsp"/>

<!-- Club Header -->
<c:set var="logoSrc" value="" />
<c:if test="${not empty club.logo}">
    <c:set var="rawLogo" value="${club.logo}" />
    <c:set var="normalizedLogo" value="${fn:replace(rawLogo, '\\\\', '/')}" />
    <c:choose>
        <c:when test="${fn:startsWith(normalizedLogo, 'http')}">
            <c:set var="logoSrc" value="${normalizedLogo}" />
        </c:when>
        <c:when test="${fn:startsWith(normalizedLogo, '/')}">
            <c:set var="logoSrc" value="${pageContext.request.contextPath}${normalizedLogo}" />
        </c:when>
        <c:when test="${fn:contains(normalizedLogo, '/web/')}">
            <c:set var="relativeLogo" value="${fn:substringAfter(normalizedLogo, '/web/')}" />
            <c:if test="${not fn:startsWith(relativeLogo, '/')}">
                <c:set var="relativeLogo" value="/${relativeLogo}" />
            </c:if>
            <c:set var="logoSrc" value="${pageContext.request.contextPath}${relativeLogo}" />
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
            <c:set var="logoSrc" value="${pageContext.request.contextPath}${relativeLogo}" />
        </c:when>
        <c:otherwise>
            <c:set var="logoSrc" value="${pageContext.request.contextPath}/${normalizedLogo}" />
        </c:otherwise>
    </c:choose>
</c:if>
<div class="club-hero">
    <div class="container">
        <div class="row align-items-center g-4">
            <div class="col-lg-2 col-md-3 text-center text-md-start">
                <div class="club-logo-wrapper">
                    <c:choose>
                        <c:when test="${not empty logoSrc}">
                            <img src="${logoSrc}" alt="${club.clubName}" loading="lazy">
                        </c:when>
                        <c:otherwise>
                            <div class="club-logo-placeholder">
                                <i class="fa fa-users"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="col-lg-7 col-md-6">
                <h1 class="mb-3">${club.clubName}</h1>
                <div>
                    <span class="category-pill"><i class="fa fa-tag"></i> ${club.clubTypes}</span>
                    <span class="status-pill ${club.status eq 'Active' ? 'active' : 'inactive'}">
                        <i class="fa ${club.status eq 'Active' ? 'fa-check-circle' : 'fa-clock-o'}"></i>
                        ${club.status}
                    </span>
                </div>
                <div class="club-meta">
                    <i class="fa fa-calendar-check-o me-1"></i> Ngày tạo: ${club.createdAt}
                </div>
            </div>
            <div class="col-lg-3 col-md-3 text-md-end">
                <div class="d-flex d-md-block flex-wrap justify-content-center gap-2 action-buttons">
                    <c:if test="${isLeaderOrAdmin}">
                        <a href="${pageContext.request.contextPath}/clubDashboard" class="btn btn-glass">
                            <i class="fa fa-dashboard"></i> Dashboard
                        </a>
                    </c:if>
                    
<!--                    Request to join Club-->
                    <c:if test="${!isLeaderOrAdmin && club.status eq 'Active'}">
                        <c:choose>
                        <c:when test="${isGuest}">
                        <a class="btn btn-join" href="${pageContext.request.contextPath}/login?redirect=clubDetail&clubId=${club.clubId}">
                            <i class="fa fa-sign-in"></i> Đăng nhập để tham gia
                        </a>
                        </c:when>
                        <c:when test="${isMember}">
                            <button class="btn btn-join" type="button" disabled>
                                <i class="fa fa-check-circle"></i> Đã tham gia
                            </button>
                        </c:when>
                        <c:when test="${joinPending}">
                            <button class="btn btn-join" type="button" disabled>
                                <i class="fa fa-hourglass-half"></i> Đã gửi yêu cầu
                            </button>
                        </c:when>
                        <c:otherwise>
            <!-- Điều hướng tới form join, mang theo clubId -->
                            <a class="btn btn-join"  href="${pageContext.request.contextPath}/JoinClubServlet?clubId=${club.clubId}">
                                <i class="fa fa-user-plus"></i> Tham gia CLB
                            </a>
                        </c:otherwise>
                        </c:choose>
                    </c:if>

                </div>
            </div>
        </div>
    </div>
</div>

<div class="container mb-5">
    
    <!-- Success/Error Messages -->
    <c:if test="${not empty param.message}">
        <c:choose>
            <c:when test="${param.message eq 'update_success'}">
                <div class="alert alert-success alert-dismissible fade show">
                    <i class="fa fa-check-circle"></i> Cập nhật thông tin CLB thành công!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:when>
        </c:choose>
    </c:if>
    
    <c:if test="${not empty param.error}">
        <div class="alert alert-danger alert-dismissible fade show">
            <i class="fa fa-exclamation-circle"></i> 
            <c:choose>
                <c:when test="${param.error eq 'deactivate_failed'}">Vô hiệu hóa CLB thất bại.</c:when>
                <c:when test="${param.error eq 'delete_failed'}">Xóa CLB thất bại. CLB có thể có dữ liệu liên quan.</c:when>
                <c:otherwise>Có lỗi xảy ra.</c:otherwise>
            </c:choose>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    
    <!-- Flash messages từ Session (sau POST/Redirect) -->
    <c:if test="${not empty sessionScope.flashSuccess}">
        <div class="alert alert-success alert-dismissible fade show">
            <i class="fa fa-check-circle"></i> ${sessionScope.flashSuccess}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <c:remove var="flashSuccess" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.flashInfo}">
        <div class="alert alert-info alert-dismissible fade show">
            <i class="fa fa-info-circle"></i> ${sessionScope.flashInfo}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <c:remove var="flashInfo" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.flashError}">
        <div class="alert alert-danger alert-dismissible fade show">
            <i class="fa fa-exclamation-circle"></i> ${sessionScope.flashError}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <c:remove var="flashError" scope="session"/>
    </c:if>

    
    <!-- Statistics -->
    <div class="stats-wrapper">
        <div class="stat-card">
            <span class="stat-icon" style="background:#7C4DFF;"><i class="fa fa-users"></i></span>
            <div>
                <div class="stat-value">${totalMembers}</div>
                <div class="stat-label">Thành viên</div>
            </div>
        </div>
        <div class="stat-card">
            <span class="stat-icon" style="background:#29B6F6;"><i class="fa fa-calendar"></i></span>
            <div>
                <div class="stat-value">${totalEvents}</div>
                <div class="stat-label">Sự kiện</div>
            </div>
        </div>
        <div class="stat-card">
            <span class="stat-icon" style="background:#66BB6A;"><i class="fa fa-bolt"></i></span>
            <div>
                <div class="stat-value">
                    <c:choose>
                        <c:when test="${club.status eq 'Active'}">
                            Hoạt động
                        </c:when>
                        <c:otherwise>
                            Tạm ngưng
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="stat-label">Trạng thái</div>
            </div>
        </div>
    </div>
    
    <!-- Description -->
    <div class="card section-card mb-4">
        <div class="card-header">
            <h5 class="mb-0"><i class="fa fa-info-circle"></i> Mô tả CLB</h5>
        </div>
        <div class="card-body">
            <p>${club.description}</p>
        </div>
    </div>
    
    <!-- Tabs: Different views for Admin/Leader vs Regular User -->
    <c:choose>
        <c:when test="${isLeaderOrAdmin}">
            <!-- Admin/Leader View: Show Members & Events tabs -->
            <ul class="nav nav-tabs club-tabs" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" href="#members" id="members-tab" data-bs-toggle="tab" role="tab" aria-controls="members" aria-selected="true">
                        <i class="fa fa-users"></i> Thành viên (${totalMembers})
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#events" id="events-tab" data-bs-toggle="tab" role="tab" aria-controls="events" aria-selected="false">
                        <i class="fa fa-calendar"></i> Sự kiện (${totalEvents})
                    </a>
                </li>
            </ul>
            
            <div class="tab-content club-tabs-content p-3 border border-top-0 section-card">
                <!-- Members Tab -->
                <div id="members" class="tab-pane fade show active" role="tabpanel" aria-labelledby="members-tab">
                    <c:if test="${empty members}">
                        <div class="alert alert-info">Chưa có thành viên nào.</div>
                    </c:if>
                    
                    <div class="table-responsive">
                        <table class="table table-modern">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Họ tên</th>
                                    <th>Vai trò</th>
                                    <th>Ngày tham gia</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${members}" var="member">
                                    <tr>
                                        <td>${member.userId}</td>
                                        <td>${member.fullName}</td>
                                        <td>
                                            <span class="label-role ${member.roleInClub eq 'Leader' ? 'leader' : 'member'}">
                                                ${member.roleInClub}
                                            </span>
                                        </td>
                                        <td>${member.joinDate}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <!-- Events Tab -->
                <div id="events" class="tab-pane fade" role="tabpanel" aria-labelledby="events-tab">
                    <c:if test="${empty events}">
                        <div class="alert alert-info">Chưa có sự kiện nào.</div>
                    </c:if>
                    
                    <div class="row">
                        <c:forEach items="${events}" var="event">
                            <div class="col-md-6 mb-3">
                                <div class="card">
                                    <div class="card-body">
                                        <h5 class="card-title">${event.eventName}</h5>
                                        <p class="card-text text-muted small">
                                            <i class="fa fa-map-marker"></i> ${event.location}<br>
                                            <i class="fa fa-clock-o"></i> ${event.startDate}
                                        </p>
                                        <span class="badge bg-primary">${event.status}</span>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </c:when>
        
        <c:otherwise>
            <!-- Regular User View: Show Events list only -->
            <div class="row">
                <!-- Events List -->
                <div class="col-md-8">
                    <div class="card section-card">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="fa fa-calendar"></i> Sự kiện (${totalEvents})</h5>
                        </div>
                        <div class="card-body">
                            <c:if test="${empty events}">
                                <div class="alert alert-info">Chưa có sự kiện nào.</div>
                            </c:if>
                            
                            <c:forEach items="${events}" var="event">
                                <div class="card event-card mb-3">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-start flex-wrap gap-2">
                                            <div>
                                                <h5 class="card-title mb-2">${event.eventName}</h5>
                                                <p class="text-muted mb-1"><i class="fa fa-map-marker text-danger me-1"></i><strong>Địa điểm:</strong> ${event.location}</p>
                                                <p class="text-muted mb-1"><i class="fa fa-clock-o text-primary me-1"></i><strong>Bắt đầu:</strong> ${event.startDate}</p>
                                                <p class="text-muted mb-0"><i class="fa fa-calendar-check-o text-success me-1"></i><strong>Kết thúc:</strong> ${event.endDate}</p>
                                            </div>
                                            <div class="text-end">
                                                <span class="event-status ${event.status eq 'Published' ? 'bg-success text-white' : 'bg-secondary text-white'}">${event.status}</span>
                                                <c:if test="${event.status eq 'Published'}">
                                                    <button class="btn btn-sm btn-outline-primary mt-2" onclick="registerEvent(${event.eventID})">
                                                        <i class="fa fa-user-plus"></i> Đăng ký
                                                    </button>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
                
                <!-- Sidebar: Club Info -->
                <div class="col-md-4">
                    <!-- About Club Card -->
                    <div class="card section-card">
                        <div class="card-header">
                            <h6 class="mb-0"><i class="fa fa-info-circle"></i> Về CLB này</h6>
                        </div>
                        <div class="card-body">
                            <p class="small text-muted">${club.description}</p>
                            <hr>
                            <p class="mb-2"><strong>Loại CLB:</strong> <span class="badge bg-info">${club.clubTypes}</span></p>
                            <p class="mb-2"><strong>Thành viên:</strong> ${totalMembers} người</p>
                            <p class="mb-0"><strong>Sự kiện:</strong> ${totalEvents} sự kiện</p>
                        </div>
                    </div>
                    
                    <!-- Reviews Section -->
                    <div class="card section-card">
                        <div class="card-header">
                            <h6 class="mb-0"><i class="fa fa-star"></i> Đánh giá</h6>
                        </div>
                        <div class="card-body">
                            <!-- Rating Stars -->
                            <div class="text-center mb-3">
                                <div class="rating-stars mb-2">
                                    <i class="fa fa-star text-warning"></i>
                                    <i class="fa fa-star text-warning"></i>
                                    <i class="fa fa-star text-warning"></i>
                                    <i class="fa fa-star text-warning"></i>
                                    <i class="fa fa-star-o text-warning"></i>
                                </div>
                                <p class="text-muted small mb-0">4.0/5.0 (Based on reviews)</p>
                            </div>
                            
                            <!-- Sample Review -->
                            <div class="border-top pt-3">
                                <div class="d-flex mb-2">
                                    <div class="me-2">
                                        <i class="fa fa-user-circle fa-2x text-muted"></i>
                                    </div>
                                    <div>
                                        <h6 class="mb-0">Review title</h6>
                                        <p class="small text-muted mb-1">Reviewer name</p>
                                        <div class="rating-stars small">
                                            <i class="fa fa-star text-warning"></i>
                                            <i class="fa fa-star text-warning"></i>
                                            <i class="fa fa-star text-warning"></i>
                                            <i class="fa fa-star text-warning"></i>
                                            <i class="fa fa-star-o text-warning"></i>
                                        </div>
                                        <p class="small mt-2">Review body content...</p>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="text-center mt-3">
                                <button class="btn btn-sm btn-outline-primary">
                                    <i class="fa fa-pencil"></i> Viết đánh giá
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
    
</div>

<jsp:include page="../layout/footer.jsp"/>

<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
<script>
function confirmDelete() {
    if (confirm('Bạn có chắc chắn muốn xóa CLB này?\n\nChọn OK để vô hiệu hóa (Inactive)\nChọn Cancel để hủy.')) {
        // Create form to POST delete request
        var form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/deleteClub';
        
        var clubIdInput = document.createElement('input');
        clubIdInput.type = 'hidden';
        clubIdInput.name = 'clubId';
        clubIdInput.value = '${club.clubId}';
        
        var actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'deactivate';
        
        form.appendChild(clubIdInput);
        form.appendChild(actionInput);
        document.body.appendChild(form);
        form.submit();
    }
}

function joinClub() {
    <c:choose>
        <c:when test="${isGuest}">
            // Guest needs to login first
            if (confirm('Bạn cần đăng nhập để tham gia CLB.\nBạn có muốn đăng nhập ngay bây giờ?')) {
                window.location.href = '${pageContext.request.contextPath}/login?redirect=clubDetail&clubId=${club.clubId}';
            }
        </c:when>
        <c:otherwise>
            // Logged in user can join
            if (confirm('Bạn có muốn tham gia CLB này?')) {
                window.location.href = '${pageContext.request.contextPath}/joinClub?clubId=${club.clubId}';
            }
        </c:otherwise>
    </c:choose>
}

function registerEvent(eventId) {
    <%-- Nếu là khách (chưa đăng nhập) --%>
    <c:choose>
        <c:when test="${isGuest}">
            if (confirm('Bạn cần đăng nhập để đăng ký sự kiện.\nBạn có muốn đăng nhập ngay bây giờ?')) {
                // redirect sang trang login, kèm theo redirect về lại clubDetail sau khi login
                window.location.href =
                    '${pageContext.request.contextPath}/login'
                    + '?redirect=clubDetail'
                    + '&clubId=${club.clubId}'
                    + '&eventId=' + eventId;
            }
        </c:when>
        <c:otherwise>
            // Đã login -> gửi đơn đăng ký
            if (confirm('Bạn có muốn đăng ký tham gia sự kiện này?')) {
                // set eventId vào input ẩn rồi submit form POST
                document.getElementById('registerEventId').value = eventId;
                document.getElementById('registerEventForm').submit();
            }
        </c:otherwise>
    </c:choose>
}
</script>

<!-- Form ẩn để đăng ký sự kiện -->
<form id="registerEventForm"
      action="${pageContext.request.contextPath}/RegisterForEventServlet"
      method="post"
      style="display:none;">
    <input type="hidden" name="eventId" id="registerEventId">
</form>

<!-- Form ẩn check-in sự kiện -->
<form id="checkInForm"
      action="${pageContext.request.contextPath}/EventCheckInServlet"
      method="post"
      style="display:none;">
    <input type="hidden" name="eventId" value="${event.eventID}">
</form>      


</body>
</html>

