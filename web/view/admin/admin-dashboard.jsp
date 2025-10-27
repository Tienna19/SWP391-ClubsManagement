<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Club Management System</title>
    
    <!-- Bootstrap CSS -->
    <link href="${pageContext.request.contextPath}/assets/vendors/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="${pageContext.request.contextPath}/assets/vendors/fontawesome/css/font-awesome.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/dashboard.css" rel="stylesheet">
    
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --success-color: #28a745;
            --danger-color: #dc3545;
            --warning-color: #ffc107;
            --info-color: #17a2b8;
        }
        
        .admin-header {
            background: var(--primary-gradient);
            color: white;
            padding: 30px 0;
            margin-bottom: 30px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        
        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            margin-bottom: 25px;
            transition: all 0.3s ease;
            border-left: 5px solid;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        
        .stat-card.primary { border-left-color: #667eea; }
        .stat-card.success { border-left-color: var(--success-color); }
        .stat-card.danger { border-left-color: var(--danger-color); }
        .stat-card.warning { border-left-color: var(--warning-color); }
        .stat-card.info { border-left-color: var(--info-color); }
        
        .stat-icon {
            font-size: 48px;
            opacity: 0.2;
            position: absolute;
            right: 20px;
            top: 50%;
            transform: translateY(-50%);
        }
        
        .stat-number {
            font-size: 42px;
            font-weight: bold;
            margin: 10px 0;
        }
        
        .stat-label {
            color: #666;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .stat-details {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }
        
        .stat-detail-item {
            display: flex;
            justify-content: space-between;
            margin: 5px 0;
            font-size: 13px;
        }
        
        .quick-action-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            transition: all 0.3s;
            cursor: pointer;
            height: 100%;
        }
        
        .quick-action-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }
        
        .quick-action-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }
        
        .recent-item {
            background: white;
            padding: 15px;
            margin-bottom: 10px;
            border-radius: 8px;
            border-left: 4px solid #667eea;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            transition: all 0.2s;
        }
        
        .recent-item:hover {
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            transform: translateX(5px);
        }
        
        .section-title {
            font-size: 22px;
            font-weight: 600;
            margin: 30px 0 20px 0;
            color: #333;
            display: flex;
            align-items: center;
        }
        
        .section-title i {
            margin-right: 10px;
            color: #667eea;
        }
        
        .chart-container {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }
    </style>
</head>
<body>

<!-- Include Header -->
<jsp:include page="../layout/header.jsp"/>

<!-- Admin Header -->
<div class="admin-header">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-8">
                <h1 class="mb-2">
                    <i class="fa fa-tachometer"></i> Admin Dashboard
                </h1>
                <p class="mb-0">Quản lý toàn bộ hệ thống Club Management</p>
            </div>
            <div class="col-md-4 text-end">
                <span class="badge bg-light text-dark fs-6">
                    <i class="fa fa-user-shield"></i> Administrator
                </span>
            </div>
        </div>
    </div>
</div>

<div class="container">
    
    <!-- Statistics Overview -->
    <div class="row">
        
        <!-- Total Clubs -->
        <div class="col-md-3">
            <div class="stat-card primary position-relative">
                <i class="fa fa-users stat-icon"></i>
                <div class="stat-label">Tổng số CLB</div>
                <div class="stat-number text-primary">${totalClubs}</div>
                <div class="stat-details">
                    <div class="stat-detail-item">
                        <span><i class="fa fa-check-circle text-success"></i> Hoạt động:</span>
                        <strong>${activeClubs}</strong>
                    </div>
                    <div class="stat-detail-item">
                        <span><i class="fa fa-times-circle text-danger"></i> Ngưng:</span>
                        <strong>${inactiveClubs}</strong>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/viewAllClubs" class="btn btn-sm btn-primary mt-2 w-100">
                    Quản lý CLB
                </a>
            </div>
        </div>
        
        <!-- Total Events -->
        <div class="col-md-3">
            <div class="stat-card success position-relative">
                <i class="fa fa-calendar stat-icon"></i>
                <div class="stat-label">Tổng sự kiện</div>
                <div class="stat-number text-success">${totalEvents}</div>
                <div class="stat-details">
                    <div class="stat-detail-item">
                        <span><i class="fa fa-eye text-success"></i> Published:</span>
                        <strong>${publishedEvents}</strong>
                    </div>
                    <div class="stat-detail-item">
                        <span><i class="fa fa-pencil text-warning"></i> Draft:</span>
                        <strong>${draftEvents}</strong>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/listEvents" class="btn btn-sm btn-success mt-2 w-100">
                    Quản lý Events
                </a>
            </div>
        </div>
        
        <!-- Total Users -->
        <div class="col-md-3">
            <div class="stat-card warning position-relative">
                <i class="fa fa-user stat-icon"></i>
                <div class="stat-label">Tổng người dùng</div>
                <div class="stat-number text-warning">${totalUsers}</div>
                <div class="stat-details">
                    <div class="stat-detail-item">
                        <span><i class="fa fa-user-circle"></i> Thành viên</span>
                    </div>
                    <div class="stat-detail-item">
                        <span><i class="fa fa-user-plus text-info"></i> Đang hoạt động</span>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/manageUsers" class="btn btn-sm btn-warning mt-2 w-100">
                    Quản lý Users
                </a>
            </div>
        </div>
        
        <!-- System Health -->
        <div class="col-md-3">
            <div class="stat-card info position-relative">
                <i class="fa fa-heartbeat stat-icon"></i>
                <div class="stat-label">Trạng thái hệ thống</div>
                <div class="stat-number text-info">
                    <i class="fa fa-check-circle"></i>
                </div>
                <div class="stat-details">
                    <div class="stat-detail-item">
                        <span><i class="fa fa-database text-success"></i> Database:</span>
                        <strong class="text-success">OK</strong>
                    </div>
                    <div class="stat-detail-item">
                        <span><i class="fa fa-server text-success"></i> Server:</span>
                        <strong class="text-success">Online</strong>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/systemSettings" class="btn btn-sm btn-info mt-2 w-100">
                    Cài đặt
                </a>
            </div>
        </div>
        
    </div>
    
    <!-- Quick Actions -->
    <div class="section-title">
        <i class="fa fa-bolt"></i> Thao tác nhanh
    </div>
    
    <div class="row mb-4">
        <div class="col-md-3">
            <a href="${pageContext.request.contextPath}/createClub" class="text-decoration-none">
                <div class="quick-action-card">
                    <div class="quick-action-icon text-primary">
                        <i class="fa fa-plus-circle"></i>
                    </div>
                    <h5>Tạo CLB mới</h5>
                    <p class="text-muted small mb-0">Thêm câu lạc bộ vào hệ thống</p>
                </div>
            </a>
        </div>
        <div class="col-md-3">
            <a href="${pageContext.request.contextPath}/addNewEvent" class="text-decoration-none">
                <div class="quick-action-card">
                    <div class="quick-action-icon text-success">
                        <i class="fa fa-calendar-plus-o"></i>
                    </div>
                    <h5>Tạo sự kiện</h5>
                    <p class="text-muted small mb-0">Thêm sự kiện mới</p>
                </div>
            </a>
        </div>
        <div class="col-md-3">
            <a href="${pageContext.request.contextPath}/assignRole" class="text-decoration-none">
                <div class="quick-action-card">
                    <div class="quick-action-icon text-warning">
                        <i class="fa fa-user-plus"></i>
                    </div>
                    <h5>Phân quyền</h5>
                    <p class="text-muted small mb-0">Gán vai trò người dùng</p>
                </div>
            </a>
        </div>
        <div class="col-md-3">
            <a href="${pageContext.request.contextPath}/systemReports" class="text-decoration-none">
                <div class="quick-action-card">
                    <div class="quick-action-icon text-info">
                        <i class="fa fa-bar-chart"></i>
                    </div>
                    <h5>Báo cáo</h5>
                    <p class="text-muted small mb-0">Xem thống kê chi tiết</p>
                </div>
            </a>
        </div>
    </div>
    
    <!-- Recent Activities -->
    <div class="row">
        
        <!-- Recent Clubs -->
        <div class="col-md-4">
            <div class="section-title">
                <i class="fa fa-users"></i> CLB mới nhất
            </div>
            <div class="chart-container">
                <c:if test="${empty recentClubs}">
                    <div class="alert alert-info">
                        <i class="fa fa-info-circle"></i> Chưa có CLB nào.
                    </div>
                </c:if>
                
                <c:forEach items="${recentClubs}" var="club">
                    <div class="recent-item">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <h6 class="mb-1">${club.clubName}</h6>
                                <p class="mb-0 text-muted small">
                                    <span class="badge bg-${club.status eq 'Active' ? 'success' : 'secondary'}">${club.status}</span>
                                    <span class="ms-2">${club.clubTypes}</span>
                                </p>
                            </div>
                            <a href="${pageContext.request.contextPath}/clubDashboard?clubId=${club.clubId}" 
                               class="btn btn-sm btn-outline-primary">
                                <i class="fa fa-eye"></i>
                            </a>
                        </div>
                    </div>
                </c:forEach>
                
                <c:if test="${not empty recentClubs}">
                    <a href="${pageContext.request.contextPath}/viewAllClubs" class="btn btn-primary w-100 mt-3">
                        Xem tất cả <i class="fa fa-arrow-right"></i>
                    </a>
                </c:if>
            </div>
        </div>
        
        <!-- Recent Events -->
        <div class="col-md-4">
            <div class="section-title">
                <i class="fa fa-calendar"></i> Sự kiện mới nhất
            </div>
            <div class="chart-container">
                <c:if test="${empty recentEvents}">
                    <div class="alert alert-info">
                        <i class="fa fa-info-circle"></i> Chưa có sự kiện nào.
                    </div>
                </c:if>
                
                <c:forEach items="${recentEvents}" var="event">
                    <div class="recent-item">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <h6 class="mb-1">${event.eventName}</h6>
                                <p class="mb-0 text-muted small">
                                    <i class="fa fa-map-marker"></i> ${event.location}
                                    <br>
                                    <i class="fa fa-clock-o"></i> ${event.startDate}
                                </p>
                            </div>
                            <span class="badge bg-primary">${event.status}</span>
                        </div>
                    </div>
                </c:forEach>
                
                <c:if test="${not empty recentEvents}">
                    <a href="${pageContext.request.contextPath}/listEvents" class="btn btn-success w-100 mt-3">
                        Xem tất cả <i class="fa fa-arrow-right"></i>
                    </a>
                </c:if>
            </div>
        </div>
        
        <!-- Recent Users -->
        <div class="col-md-4">
            <div class="section-title">
                <i class="fa fa-user"></i> Người dùng mới
            </div>
            <div class="chart-container">
                <c:if test="${empty recentUsers}">
                    <div class="alert alert-info">
                        <i class="fa fa-info-circle"></i> Chưa có người dùng nào.
                    </div>
                </c:if>
                
                <c:forEach items="${recentUsers}" var="user">
                    <div class="recent-item">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="mb-1">${user.fullName}</h6>
                                <p class="mb-0 text-muted small">
                                    <i class="fa fa-envelope"></i> ${user.email}
                                </p>
                            </div>
                            <span class="badge bg-info">User</span>
                        </div>
                    </div>
                </c:forEach>
                
                <c:if test="${not empty recentUsers}">
                    <a href="${pageContext.request.contextPath}/manageUsers" class="btn btn-warning w-100 mt-3">
                        Xem tất cả <i class="fa fa-arrow-right"></i>
                    </a>
                </c:if>
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
    // Auto refresh statistics every 60 seconds
    setTimeout(function() {
        location.reload();
    }, 60000);
</script>

</body>
</html>

