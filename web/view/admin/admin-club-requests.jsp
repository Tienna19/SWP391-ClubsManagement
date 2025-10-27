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
        .request-card {
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            transition: box-shadow 0.3s;
        }
        .request-card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .request-logo {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 8px;
        }
        .badge-lg {
            font-size: 14px;
            padding: 8px 12px;
        }
        .btn-action {
            min-width: 100px;
        }
        .filter-tabs .nav-link {
            color: #495057;
        }
        .filter-tabs .nav-link.active {
            background-color: #007bff;
            color: white;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <jsp:include page="../layout/header.jsp" />

    <!-- Page Content -->
    <div class="page-content bg-white">
        <div class="content-block">
            <div class="section-full bg-white p-t50 p-b20">
                <div class="container">
                    <!-- Page Title -->
                    <div class="row">
                        <div class="col-lg-12 mb-4">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h2 class="m-b5"><i class="fa fa-list-alt text-primary"></i> Yêu cầu tạo CLB</h2>
                                    <p class="text-muted">Quản lý và phê duyệt yêu cầu tạo CLB từ sinh viên</p>
                                </div>
                                <a href="${pageContext.request.contextPath}/adminDashboard" class="btn btn-secondary">
                                    <i class="fa fa-arrow-left"></i> Quay lại Dashboard
                                </a>
                            </div>
                        </div>
                    </div>

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
                                                <!-- Logo -->
                                                <div class="col-md-1">
                                                    <c:choose>
                                                        <c:when test="${not empty req.logo}">
                                                            <img src="${pageContext.request.contextPath}/${req.logo}" 
                                                                 alt="${req.clubName}" class="request-logo">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="request-logo bg-light d-flex align-items-center justify-content-center">
                                                                <i class="fa fa-image fa-2x text-muted"></i>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <!-- Info -->
                                                <div class="col-md-7">
                                                    <h4 class="mb-2">
                                                        ${req.clubName}
                                                        <span class="badge ${req.statusCssClass} badge-lg ml-2">
                                                            <i class="fa ${req.statusIcon}"></i> ${req.status}
                                                        </span>
                                                    </h4>
                                                    <p class="text-muted mb-2">${req.description}</p>
                                                    <div class="small">
                                                        <span class="badge badge-info">${req.clubTypes}</span>
                                                        <span class="ml-3">
                                                            <i class="fa fa-user"></i> Người yêu cầu: 
                                                            <strong>${req.requestedByName}</strong> (ID: ${req.requestedBy})
                                                        </span>
                                                        <span class="ml-3">
                                                            <i class="fa fa-calendar"></i> ${req.formattedRequestedAt}
                                                        </span>
                                                    </div>
                                                    
                                                    <!-- Review Info (if reviewed) -->
                                                    <c:if test="${req.status != 'Pending'}">
                                                        <div class="mt-2 pt-2 border-top">
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

                                                <!-- Actions -->
                                                <div class="col-md-4 text-right">
                                                    <c:choose>
                                                        <c:when test="${req.status == 'Pending'}">
                                                            <button type="button" class="btn btn-success btn-action mb-2" 
                                                                    onclick="showApproveModal(${req.requestId}, '${req.clubName}')">
                                                                <i class="fa fa-check"></i> Phê duyệt
                                                            </button>
                                                            <br>
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

