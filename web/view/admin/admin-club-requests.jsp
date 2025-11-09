<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yêu cầu tạo CLB - Admin</title>
    
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
        }
        body {
            background: #f5f6fb;
        }
        .admin-layout {
            display: flex;
            min-height: calc(100vh - 70px);
        }
        .admin-sidebar {
            width: 255px;
            background: #25124B;
            color: #fff;
            display: flex;
            flex-direction: column;
            padding: 28px 22px;
            box-shadow: 0 10px 30px rgba(37,18,75,0.35);
            position: relative;
            z-index: 2;
        }
        .admin-sidebar .sidebar-title {
            font-size: 18px;
            font-weight: 600;
            letter-spacing: 0.5px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .admin-sidebar .sidebar-title i {
            font-size: 24px;
        }
        .sidebar-nav {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .sidebar-nav a {
            color: rgba(255,255,255,0.85);
            text-decoration: none;
            padding: 12px 14px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 500;
            transition: background 0.25s ease, transform 0.2s ease;
        }
        .sidebar-nav a i {
            font-size: 18px;
        }
        .sidebar-nav a:hover {
            background: rgba(255,255,255,0.12);
            transform: translateX(4px);
        }
        .sidebar-nav a.active {
            background: linear-gradient(135deg, #FFB64E 0%, #FF6B83 100%);
            color: #fff;
            box-shadow: 0 8px 20px rgba(255,107,131,0.35);
        }
        .sidebar-footer {
            margin-top: auto;
            padding-top: 25px;
            border-top: 1px solid rgba(255,255,255,0.1);
            font-size: 13px;
            color: rgba(255,255,255,0.6);
        }
        .admin-content {
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        .admin-header {
            background: var(--primary-gradient);
            color: white;
            padding: 30px 0;
            margin-bottom: 30px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .filter-tabs .nav-link {
            color: #495057;
            border-radius: 30px;
            padding: 10px 18px;
            background: #f2f4f8;
            margin-right: 8px;
            transition: all 0.2s ease;
        }
        .filter-tabs .nav-link.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 6px 16px rgba(118, 75, 162, 0.35);
        }
        .request-card {
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 20px;
            transition: box-shadow 0.3s ease, transform 0.2s ease;
            background: #fff;
            box-shadow: 0 6px 14px rgba(0,0,0,0.05);
        }
        .request-card:hover {
            box-shadow: 0 12px 26px rgba(0,0,0,0.08);
            transform: translateY(-3px);
        }
        .request-logo {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 12px;
            border: 2px solid rgba(102, 126, 234, 0.3);
        }
        .badge-lg {
            font-size: 14px;
            padding: 8px 12px;
        }
        .btn-action {
            min-width: 120px;
        }
        @media (max-width: 991px) {
            .admin-layout {
                flex-direction: column;
            }
            .admin-sidebar {
                width: 100%;
                flex-direction: row;
                overflow-x: auto;
                padding: 18px;
                gap: 12px;
            }
            .sidebar-nav {
                flex-direction: row;
                flex-wrap: nowrap;
                gap: 8px;
            }
            .sidebar-nav a {
                flex: 0 0 auto;
                padding: 10px 16px;
                border-radius: 30px;
            }
            .sidebar-footer {
                display: none;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <jsp:include page="../layout/header.jsp" />

    <div class="admin-layout">
        <aside class="admin-sidebar">
            <div class="sidebar-title">
                <i class="fa fa-shield"></i> Bảng điều khiển
            </div>
            <nav class="sidebar-nav">
                <a href="${pageContext.request.contextPath}/adminDashboard">
                    <i class="fa fa-tachometer"></i> Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/viewClubRequests" class="active">
                    <i class="fa fa-bell"></i> Yêu cầu CLB
                </a>
                <a href="${pageContext.request.contextPath}/viewAllClubs">
                    <i class="fa fa-users"></i> Quản lý CLB
                </a>
                <a href="${pageContext.request.contextPath}/listEvents">
                    <i class="fa fa-calendar"></i> Quản lý sự kiện
                </a>
                <a href="${pageContext.request.contextPath}/manageUsers">
                    <i class="fa fa-user-circle"></i> Quản lý người dùng
                </a>
                <a href="${pageContext.request.contextPath}/systemReports">
                    <i class="fa fa-bar-chart"></i> Báo cáo
                </a>
                <a href="${pageContext.request.contextPath}/systemSettings">
                    <i class="fa fa-cog"></i> Cài đặt hệ thống
                </a>
            </nav>
            <div class="sidebar-footer">
                <div><i class="fa fa-check-circle text-success mr-2"></i>Hệ thống hoạt động ổn định</div>
                <div class="mt-2"><i class="fa fa-life-ring mr-2"></i>Hỗ trợ: support@stuclub.vn</div>
            </div>
        </aside>

        <div class="admin-content">
            <div class="admin-header">
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <h1 class="mb-2">
                                <i class="fa fa-list-alt"></i> Yêu cầu tạo CLB
                            </h1>
                            <p class="mb-0">Theo dõi, phê duyệt và quản lý các yêu cầu tạo CLB từ sinh viên</p>
                        </div>
                        <div class="col-md-4 text-md-end mt-3 mt-md-0">
                            <a href="${pageContext.request.contextPath}/adminDashboard"
                               class="btn btn-light text-primary">
                                <i class="fa fa-arrow-left"></i> Quay lại Dashboard
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="container pb-5">
                <!-- Success Message -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fa fa-check-circle"></i> ${sessionScope.successMessage}
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>

                <!-- Filter Tabs -->
                <div class="row">
                    <div class="col-lg-12 mb-4">
                        <ul class="nav nav-pills filter-tabs">
                            <li class="nav-item">
                                <a class="nav-link ${statusFilter == 'All' ? 'active' : ''}" 
                                   href="${pageContext.request.contextPath}/viewClubRequests?status=All">
                                    <i class="fa fa-th-list"></i> Tất cả 
                                    <span class="badge badge-secondary">${pendingCount + approvedCount + rejectedCount}</span>
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link ${statusFilter == 'Pending' ? 'active' : ''}" 
                                   href="${pageContext.request.contextPath}/viewClubRequests?status=Pending">
                                    <i class="fa fa-clock-o"></i> Chờ duyệt 
                                    <span class="badge badge-warning">${pendingCount}</span>
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link ${statusFilter == 'Approved' ? 'active' : ''}" 
                                   href="${pageContext.request.contextPath}/viewClubRequests?status=Approved">
                                    <i class="fa fa-check-circle"></i> Đã duyệt 
                                    <span class="badge badge-success">${approvedCount}</span>
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link ${statusFilter == 'Rejected' ? 'active' : ''}" 
                                   href="${pageContext.request.contextPath}/viewClubRequests?status=Rejected">
                                    <i class="fa fa-times-circle"></i> Từ chối 
                                    <span class="badge badge-danger">${rejectedCount}</span>
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>

                <!-- Requests List -->
                <div class="row">
                    <div class="col-lg-12">
                        <c:choose>
                            <c:when test="${empty requests}">
                                <div class="alert alert-info text-center">
                                    <i class="fa fa-info-circle fa-3x mb-3"></i>
                                    <h5>Không có yêu cầu nào</h5>
                                    <p class="mb-0">
                                        <c:choose>
                                            <c:when test="${statusFilter == 'Pending'}">Không có yêu cầu chờ duyệt</c:when>
                                            <c:when test="${statusFilter == 'Approved'}">Chưa có yêu cầu nào được phê duyệt</c:when>
                                            <c:when test="${statusFilter == 'Rejected'}">Chưa có yêu cầu nào bị từ chối</c:when>
                                            <c:otherwise>Chưa có yêu cầu tạo CLB nào</c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach items="${requests}" var="req">
                                    <div class="request-card">
                                        <div class="row align-items-center">
                                            <div class="col-md-2 mb-3 mb-md-0 text-center text-md-left">
                                                <c:choose>
                                                    <c:when test="${not empty req.logo}">
                                                        <img src="${pageContext.request.contextPath}/${req.logo}" 
                                                             alt="${req.clubName}" class="request-logo">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="request-logo bg-light d-flex align-items-center justify-content-center text-muted">
                                                            <i class="fa fa-users fa-2x"></i>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="col-md-6">
                                                <h4 class="mb-2">
                                                    ${req.clubName}
                                                    <span class="badge ${req.statusCssClass} badge-lg ml-2">
                                                        <i class="fa ${req.statusIcon}"></i> ${req.status}
                                                    </span>
                                                </h4>
                                                <p class="text-muted mb-2">${req.description}</p>
                                                <div class="small text-muted">
                                                    <span class="badge badge-info">${req.clubTypes}</span>
                                                    <span class="ml-3">
                                                        <i class="fa fa-user"></i> Người yêu cầu: 
                                                        <strong>${req.requestedByName}</strong> (ID: ${req.requestedBy})
                                                    </span>
                                                    <span class="ml-3">
                                                        <i class="fa fa-calendar"></i> ${req.formattedRequestedAt}
                                                    </span>
                                                </div>
                                                <c:if test="${req.status != 'Pending'}">
                                                    <div class="mt-3 pt-3 border-top">
                                                        <small>
                                                            <i class="fa fa-check-square-o"></i> Xử lý bởi: 
                                                            <strong>${req.reviewedByName}</strong> - ${req.formattedReviewedAt}
                                                        </small>
                                                        <c:if test="${not empty req.reviewComment}">
                                                            <br><small><i class="fa fa-comment"></i> <em>${req.reviewComment}</em></small>
                                                        </c:if>
                                                        <c:if test="${req.status == 'Approved' && req.createdClubId != null}">
                                                            <br><small>
                                                                <i class="fa fa-link"></i> 
                                                                <a href="${pageContext.request.contextPath}/clubDetail?clubId=${req.createdClubId}">
                                                                    Xem CLB đã tạo (ID: ${req.createdClubId})
                                                                </a>
                                                            </small>
                                                        </c:if>
                                                    </div>
                                                </c:if>
                                            </div>
                                            <div class="col-md-4 text-md-end mt-3 mt-md-0">
                                                <c:choose>
                                                    <c:when test="${req.status == 'Pending'}">
                                                        <button type="button" class="btn btn-success btn-action mb-2" 
                                                                onclick="showApproveModal(${req.requestId}, '${req.clubName}')">
                                                            <i class="fa fa-check"></i> Phê duyệt
                                                        </button>
                                                        <button type="button" class="btn btn-danger btn-action" 
                                                                onclick="showRejectModal(${req.requestId}, '${req.clubName}')">
                                                            <i class="fa fa-times"></i> Từ chối
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge ${req.statusCssClass} badge-lg">
                                                            <i class="fa ${req.statusIcon}"></i> Đã xử lý
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Approve Modal -->
    <div class="modal fade" id="approveModal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/approveClubRequest" method="POST">
                    <div class="modal-header bg-success text-white">
                        <h5 class="modal-title"><i class="fa fa-check-circle"></i> Phê duyệt yêu cầu</h5>
                        <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="requestId" id="approveRequestId">
                        <input type="hidden" name="action" value="approve">
                        <p>Bạn có chắc chắn muốn phê duyệt CLB <strong id="approveClubName"></strong>?</p>
                        <p class="text-info">
                            <i class="fa fa-info-circle"></i> 
                            Sau khi phê duyệt, CLB sẽ được tạo và hiển thị trong danh sách CLB.
                        </p>
                        <div class="form-group">
                            <label>Ghi chú (tùy chọn):</label>
                            <textarea name="reviewComment" class="form-control" rows="3" 
                                      placeholder="Nhập ghi chú nếu có..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-success">
                            <i class="fa fa-check"></i> Phê duyệt
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Reject Modal -->
    <div class="modal fade" id="rejectModal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/approveClubRequest" method="POST">
                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title"><i class="fa fa-times-circle"></i> Từ chối yêu cầu</h5>
                        <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="requestId" id="rejectRequestId">
                        <input type="hidden" name="action" value="reject">
                        <p>Bạn có chắc chắn muốn từ chối yêu cầu tạo CLB <strong id="rejectClubName"></strong>?</p>
                        <div class="form-group">
                            <label>Lý do từ chối <span class="text-danger">*</span>:</label>
                            <textarea name="reviewComment" class="form-control" rows="3" 
                                      placeholder="Vui lòng nhập lý do từ chối..." required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-danger">
                            <i class="fa fa-times"></i> Từ chối
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <jsp:include page="../layout/footer.jsp" />

    <!-- Scripts -->
    <script src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/popper.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/functions.js"></script>

    <script>
        function showApproveModal(requestId, clubName) {
            document.getElementById('approveRequestId').value = requestId;
            document.getElementById('approveClubName').textContent = clubName;
            $('#approveModal').modal('show');
        }

        function showRejectModal(requestId, clubName) {
            document.getElementById('rejectRequestId').value = requestId;
            document.getElementById('rejectClubName').textContent = clubName;
            $('#rejectModal').modal('show');
        }
    </script>
</body>
</html>

