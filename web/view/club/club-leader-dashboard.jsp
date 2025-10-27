<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Club Leader Dashboard - ${club.clubName}</title>
    
    <!-- Bootstrap CSS -->
    <link href="${pageContext.request.contextPath}/assets/vendors/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="${pageContext.request.contextPath}/assets/vendors/fontawesome/css/font-awesome.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/dashboard.css" rel="stylesheet">
    
    <style>
        .dashboard-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px 0;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            transition: transform 0.3s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }
        .stat-icon {
            font-size: 48px;
            opacity: 0.8;
        }
        .stat-number {
            font-size: 36px;
            font-weight: bold;
            margin: 10px 0;
        }
        .stat-label {
            color: #666;
            font-size: 14px;
        }
        .quick-action-btn {
            width: 100%;
            padding: 15px;
            margin-bottom: 10px;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s;
        }
        .section-title {
            font-size: 20px;
            font-weight: 600;
            margin: 30px 0 20px 0;
            color: #333;
        }
        .event-card {
            border-left: 4px solid #667eea;
            padding: 15px;
            margin-bottom: 15px;
            background: white;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
        .member-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #667eea;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
        }
    </style>
</head>
<body>

<!-- Include Header -->
<jsp:include page="../layout/header.jsp"/>

<!-- Dashboard Header -->
<div class="dashboard-header">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-8">
                <h1 class="mb-2">
                    <i class="fa fa-dashboard"></i> Dashboard Quản Lý CLB
                </h1>
                <h3>${club.clubName}</h3>
                <p class="mb-0">
                    <span class="badge bg-light text-dark">${club.clubTypes}</span>
                    <span class="badge bg-success ms-2">${club.status}</span>
                </p>
            </div>
            <div class="col-md-4 text-end">
                <a href="${pageContext.request.contextPath}/viewAllClubs" class="btn btn-light">
                    <i class="fa fa-arrow-left"></i> Quay lại
                </a>
            </div>
        </div>
    </div>
</div>

<div class="container">
    
    <!-- Statistics Cards -->
    <div class="row">
        <!-- Total Members -->
        <div class="col-md-4">
            <div class="stat-card text-center">
                <i class="fa fa-users stat-icon" style="color: #667eea;"></i>
                <div class="stat-number">${totalMembers}</div>
                <div class="stat-label">Thành viên</div>
                <a href="#members-section" class="btn btn-sm btn-outline-primary mt-2">
                    Xem chi tiết <i class="fa fa-arrow-down"></i>
                </a>
            </div>
        </div>
        
        <!-- Total Events -->
        <div class="col-md-4">
            <div class="stat-card text-center">
                <i class="fa fa-calendar stat-icon" style="color: #f093fb;"></i>
                <div class="stat-number">${totalEvents}</div>
                <div class="stat-label">Sự kiện đang hoạt động</div>
                <a href="${pageContext.request.contextPath}/listEvents?clubId=${club.clubId}" class="btn btn-sm btn-outline-primary mt-2">
                    Quản lý sự kiện
                </a>
            </div>
        </div>
        
        <!-- Pending Requests -->
        <div class="col-md-4">
            <div class="stat-card text-center">
                <i class="fa fa-bell stat-icon" style="color: #ffa647;"></i>
                <div class="stat-number">${pendingRequests}</div>
                <div class="stat-label">Yêu cầu chờ duyệt</div>
                <a href="#" class="btn btn-sm btn-outline-warning mt-2">
                    Xử lý yêu cầu
                </a>
            </div>
        </div>
    </div>
    
    <div class="row mt-4">
        
        <!-- Left Column: Quick Actions & Recent Events -->
        <div class="col-md-8">
            
            <!-- Quick Actions -->
            <div class="card mb-4">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0"><i class="fa fa-bolt"></i> Thao tác nhanh</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <a href="${pageContext.request.contextPath}/addEvent?clubId=${club.clubId}" 
                               class="quick-action-btn btn btn-primary">
                                <i class="fa fa-plus-circle"></i> Tạo sự kiện mới
                            </a>
                        </div>
                        <div class="col-md-6">
                            <a href="${pageContext.request.contextPath}/editClub?clubId=${club.clubId}" 
                               class="quick-action-btn btn btn-info text-white">
                                <i class="fa fa-edit"></i> Chỉnh sửa thông tin CLB
                            </a>
                        </div>
                        <div class="col-md-6">
                            <a href="#members-section" class="quick-action-btn btn btn-success">
                                <i class="fa fa-user-plus"></i> Quản lý thành viên
                            </a>
                        </div>
                        <div class="col-md-6">
                            <a href="${pageContext.request.contextPath}/clubStatistics?clubId=${club.clubId}" 
                               class="quick-action-btn btn btn-warning text-white">
                                <i class="fa fa-bar-chart"></i> Xem thống kê
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Recent Events -->
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0"><i class="fa fa-calendar-check-o"></i> Sự kiện sắp tới</h5>
                </div>
                <div class="card-body">
                    <c:if test="${empty recentEvents}">
                        <div class="alert alert-info">
                            <i class="fa fa-info-circle"></i> Chưa có sự kiện nào.
                            <a href="${pageContext.request.contextPath}/addEvent?clubId=${club.clubId}" class="alert-link">
                                Tạo sự kiện đầu tiên
                            </a>
                        </div>
                    </c:if>
                    
                    <c:forEach items="${recentEvents}" var="event">
                        <div class="event-card">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <h6 class="mb-1">${event.eventName}</h6>
                                    <p class="mb-1 text-muted small">
                                        <i class="fa fa-map-marker"></i> ${event.location}
                                    </p>
                                    <p class="mb-0 text-muted small">
                                        <i class="fa fa-clock-o"></i> ${event.startDate}
                                    </p>
                                </div>
                                <div>
                                    <span class="badge bg-primary">${event.status}</span>
                                    <br>
                                    <a href="${pageContext.request.contextPath}/editEvent?eventId=${event.eventID}" 
                                       class="btn btn-sm btn-outline-primary mt-2">
                                        <i class="fa fa-edit"></i> Sửa
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    
                    <c:if test="${not empty recentEvents}">
                        <div class="text-center mt-3">
                            <a href="${pageContext.request.contextPath}/listEvents?clubId=${club.clubId}" 
                               class="btn btn-primary">
                                Xem tất cả sự kiện <i class="fa fa-arrow-right"></i>
                            </a>
                        </div>
                    </c:if>
                </div>
            </div>
            
        </div>
        
        <!-- Right Column: Club Info & Activity Feed -->
        <div class="col-md-4">
            
            <!-- Club Information -->
            <div class="card mb-4">
                <div class="card-header bg-info text-white">
                    <h5 class="mb-0"><i class="fa fa-info-circle"></i> Thông tin CLB</h5>
                </div>
                <div class="card-body">
                    <c:if test="${not empty club.logo}">
                        <img src="${pageContext.request.contextPath}/${club.logo}" 
                             alt="${club.clubName}" 
                             class="img-fluid rounded mb-3">
                    </c:if>
                    
                    <p><strong>Mô tả:</strong></p>
                    <p class="text-muted">${club.description}</p>
                    
                    <hr>
                    
                    <p class="mb-2">
                        <i class="fa fa-tag"></i> <strong>Thể loại:</strong> ${club.clubTypes}
                    </p>
                    <p class="mb-2">
                        <i class="fa fa-calendar"></i> <strong>Ngày tạo:</strong> ${club.createdAt}
                    </p>
                    <p class="mb-0">
                        <i class="fa fa-check-circle"></i> <strong>Trạng thái:</strong> 
                        <span class="badge bg-success">${club.status}</span>
                    </p>
                </div>
            </div>
            
            <!-- Activity Feed (Optional) -->
            <div class="card">
                <div class="card-header bg-warning text-white">
                    <h5 class="mb-0"><i class="fa fa-bell"></i> Thông báo</h5>
                </div>
                <div class="card-body">
                    <div class="alert alert-light">
                        <small><i class="fa fa-info-circle"></i> Chức năng thông báo sẽ được cập nhật sau.</small>
                    </div>
                </div>
            </div>
            
        </div>
    </div>
    
    <!-- Members Section -->
    <div class="row mt-5" id="members-section">
        <div class="col-12">
            <div class="card">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0"><i class="fa fa-users"></i> Danh sách thành viên (${totalMembers})</h5>
                </div>
                <div class="card-body">
                    <c:if test="${empty members}">
                        <div class="alert alert-info">
                            <i class="fa fa-info-circle"></i> Chưa có thành viên nào trong CLB.
                        </div>
                    </c:if>
                    
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Thành viên</th>
                                    <th>Vai trò</th>
                                    <th>Ngày tham gia</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${members}" var="member">
                                    <tr>
                                        <td>${member.userId}</td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="member-avatar me-2">
                                                    ${member.fullName.substring(0,1)}
                                                </div>
                                                <div>
                                                    <strong>${member.fullName}</strong>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="badge bg-${member.roleInClub eq 'Leader' ? 'danger' : 'primary'}">
                                                ${member.roleInClub}
                                            </span>
                                        </td>
                                        <td>${member.joinDate}</td>
                                        <td>
                                            <c:if test="${member.roleInClub ne 'Leader'}">
                                                <button class="btn btn-sm btn-outline-danger" 
                                                        onclick="confirmRemoveMember(${member.userId})">
                                                    <i class="fa fa-times"></i> Xóa
                                                </button>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
</div>

<!-- Include Footer -->
<jsp:include page="../layout/footer.jsp"/>

<!-- Bootstrap JS -->
<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>

<script>
    function confirmRemoveMember(userId) {
        if (confirm('Bạn có chắc chắn muốn xóa thành viên này khỏi CLB?')) {
            // TODO: Implement remove member functionality
            window.location.href = '${pageContext.request.contextPath}/removeMember?userId=' + userId + '&clubId=${club.clubId}';
        }
    }
    
    // Smooth scroll to sections
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({ behavior: 'smooth' });
            }
        });
    });
</script>

</body>
</html>

