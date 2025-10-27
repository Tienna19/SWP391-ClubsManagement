<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết CLB - ${club.clubName}</title>
    <link href="${pageContext.request.contextPath}/assets/vendors/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendors/fontawesome/css/font-awesome.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
    
    <style>
        .club-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 0;
            margin-bottom: 30px;
        }
        .club-logo {
            width: 150px;
            height: 150px;
            object-fit: cover;
            border-radius: 15px;
            border: 5px solid white;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        .stat-box {
            background: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .stat-number {
            font-size: 36px;
            font-weight: bold;
            color: #667eea;
        }
        .action-buttons .btn {
            margin: 5px;
        }
    </style>
</head>
<body>

<jsp:include page="../layout/header.jsp"/>

<!-- Club Header -->
<div class="club-header">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-2">
                <c:if test="${not empty club.logo}">
                    <img src="${pageContext.request.contextPath}/${club.logo}" alt="${club.clubName}" class="club-logo">
                </c:if>
                <c:if test="${empty club.logo}">
                    <div class="club-logo d-flex align-items-center justify-content-center bg-light text-dark">
                        <i class="fa fa-users fa-4x"></i>
                    </div>
                </c:if>
            </div>
            <div class="col-md-7">
                <h1 class="mb-2">${club.clubName}</h1>
                <p class="mb-2">
                    <span class="badge bg-light text-dark"><i class="fa fa-tag"></i> ${club.clubTypes}</span>
                    <span class="badge bg-${club.status eq 'Active' ? 'success' : 'secondary'} ms-2">${club.status}</span>
                </p>
                <p class="mb-0"><i class="fa fa-calendar"></i> Ngày tạo: ${club.createdAt}</p>
            </div>
            <div class="col-md-3 text-end action-buttons">
                <!-- Only show management buttons for Leader/Admin -->
                <c:if test="${isLeaderOrAdmin}">
                    <a href="${pageContext.request.contextPath}/updateClub?clubId=${club.clubId}" class="btn btn-warning">
                        <i class="fa fa-edit"></i> Chỉnh sửa
                    </a>
                    <a href="${pageContext.request.contextPath}/clubDashboard" class="btn btn-info">
                        <i class="fa fa-dashboard"></i> Dashboard
                    </a>
                    <button onclick="confirmDelete()" class="btn btn-danger">
                        <i class="fa fa-trash"></i> Xóa
                    </button>
                </c:if>
                <!-- Join button for regular users -->
                <c:if test="${!isLeaderOrAdmin && club.status eq 'Active'}">
                    <button onclick="joinClub()" class="btn btn-success btn-lg">
                        <i class="fa fa-user-plus"></i> Tham gia CLB
                    </button>
                </c:if>
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
    
    <!-- Statistics -->
    <div class="row mb-4">
        <div class="col-md-4">
            <div class="stat-box">
                <div class="stat-number">${totalMembers}</div>
                <div class="text-muted">Thành viên</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-box">
                <div class="stat-number">${totalEvents}</div>
                <div class="text-muted">Sự kiện</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-box">
                <div class="stat-number">
                    <c:choose>
                        <c:when test="${club.status eq 'Active'}">
                            <i class="fa fa-check-circle text-success"></i>
                        </c:when>
                        <c:otherwise>
                            <i class="fa fa-times-circle text-danger"></i>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="text-muted">Trạng thái</div>
            </div>
        </div>
    </div>
    
    <!-- Description -->
    <div class="card mb-4">
        <div class="card-header bg-primary text-white">
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
            <ul class="nav nav-tabs" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" data-bs-toggle="tab" href="#members">
                        <i class="fa fa-users"></i> Thành viên (${totalMembers})
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-bs-toggle="tab" href="#events">
                        <i class="fa fa-calendar"></i> Sự kiện (${totalEvents})
                    </a>
                </li>
            </ul>
            
            <div class="tab-content p-3 border border-top-0">
                <!-- Members Tab -->
                <div id="members" class="tab-pane active">
                    <c:if test="${empty members}">
                        <div class="alert alert-info">Chưa có thành viên nào.</div>
                    </c:if>
                    
                    <div class="table-responsive">
                        <table class="table table-hover">
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
                                            <span class="badge bg-${member.roleInClub eq 'Leader' ? 'danger' : 'primary'}">
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
                <div id="events" class="tab-pane fade">
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
                    <div class="card mb-4">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0"><i class="fa fa-calendar"></i> Sự kiện (${totalEvents})</h5>
                        </div>
                        <div class="card-body">
                            <c:if test="${empty events}">
                                <div class="alert alert-info">Chưa có sự kiện nào.</div>
                            </c:if>
                            
                            <c:forEach items="${events}" var="event">
                                <div class="card mb-3 border-left-primary">
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-9">
                                                <h5 class="card-title mb-2">${event.eventName}</h5>
                                                <p class="card-text text-muted mb-1">
                                                    <i class="fa fa-map-marker text-danger"></i> <strong>Địa điểm:</strong> ${event.location}
                                                </p>
                                                <p class="card-text text-muted mb-1">
                                                    <i class="fa fa-clock-o text-primary"></i> <strong>Bắt đầu:</strong> ${event.startDate}
                                                </p>
                                                <p class="card-text text-muted mb-2">
                                                    <i class="fa fa-calendar-check-o text-success"></i> <strong>Kết thúc:</strong> ${event.endDate}
                                                </p>
                                                <span class="badge bg-${event.status eq 'Published' ? 'success' : 'secondary'}">${event.status}</span>
                                            </div>
                                            <div class="col-md-3 text-end">
                                                <c:if test="${event.status eq 'Published'}">
                                                    <button class="btn btn-sm btn-primary" onclick="registerEvent(${event.eventID})">
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
                    <div class="card mb-3">
                        <div class="card-header bg-light">
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
                    <div class="card">
                        <div class="card-header bg-light">
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
    <c:choose>
        <c:when test="${isGuest}">
            // Guest needs to login first
            if (confirm('Bạn cần đăng nhập để đăng ký sự kiện.\nBạn có muốn đăng nhập ngay bây giờ?')) {
                window.location.href = '${pageContext.request.contextPath}/login?redirect=clubDetail&clubId=${club.clubId}&eventId=' + eventId;
            }
        </c:when>
        <c:otherwise>
            // Logged in user can register
            if (confirm('Bạn có muốn đăng ký tham gia sự kiện này?')) {
                window.location.href = '${pageContext.request.contextPath}/registerEvent?eventId=' + eventId;
            }
        </c:otherwise>
    </c:choose>
}
</script>

</body>
</html>

