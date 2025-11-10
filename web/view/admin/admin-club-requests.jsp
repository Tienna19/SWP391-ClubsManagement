<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yêu cầu tạo CLB - Admin</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/assets.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/typography.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/shortcodes.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">
    <style>
        .request-card {
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 10px 25px rgba(94, 53, 177, 0.08);
            padding: 22px;
            margin-bottom: 22px;
            transition: transform .2s ease, box-shadow .2s ease;
        }
        .request-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 18px 35px rgba(94, 53, 177, 0.18);
        }
        .request-card .badge {
            border-radius: 999px;
            font-size: 12px;
            padding: 6px 12px;
        }
        .request-meta {
            font-size: 13px;
            color: #6f7896;
        }
        .nav-status .nav-link {
            border-radius: 30px;
            padding: 8px 18px;
            font-weight: 600;
            color: #5e5b7d;
        }
        .nav-status .nav-link.active {
            background: linear-gradient(135deg, #6c4fe0 0%, #8855ff 100%);
            color: #fff;
            box-shadow: 0 10px 20px rgba(108, 79, 224, 0.2);
        }
    </style>
</head>
<body class="ttr-opened-sidebar ttr-pinned-sidebar admin-theme-loaded">
<%@ include file="/WEB-INF/jspf/admin-layout.jspf" %>

<main class="ttr-wrapper">
    <div class="container-fluid">
        <div class="db-breadcrumb">
            <h4 class="breadcrumb-title">Yêu cầu tạo CLB</h4>
            <ul class="db-breadcrumb-list">
                <li><a href="${pageContext.request.contextPath}/adminDashboard"><i class="fa fa-home"></i>Dashboard</a></li>
                <li>Quản lý CLB</li>
                <li>Yêu cầu tạo CLB</li>
            </ul>
        </div>

        <div class="row g-3 m-b30">
            <div class="col-md-3 col-sm-6">
                <div class="widget-card widget-bg1">
                    <div class="wc-item">
                        <h4 class="wc-title">Đang chờ duyệt</h4>
                        <span class="wc-stats">${pendingCount}</span>
                        <span class="wc-des">Yêu cầu ở trạng thái Pending</span>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="widget-card widget-bg2">
                    <div class="wc-item">
                        <h4 class="wc-title">Đã phê duyệt</h4>
                        <span class="wc-stats">${approvedCount}</span>
                        <span class="wc-des">Yêu cầu được chấp thuận</span>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="widget-card widget-bg3">
                    <div class="wc-item">
                        <h4 class="wc-title">Bị từ chối</h4>
                        <span class="wc-stats">${rejectedCount}</span>
                        <span class="wc-des">Yêu cầu bị từ chối</span>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="widget-card widget-bg4">
                    <div class="wc-item">
                        <h4 class="wc-title">Tổng yêu cầu</h4>
                        <span class="wc-stats">${fn:length(requests)}</span>
                        <span class="wc-des">Theo bộ lọc hiện tại</span>
                    </div>
                </div>
            </div>
        </div>

        <ul class="nav nav-pills nav-status mb-4">
            <c:set var="selectedStatus" value="${statusFilter}" />
            <li class="nav-item">
                <a class="nav-link${selectedStatus eq 'All' ? ' active' : ''}" href="${pageContext.request.contextPath}/viewClubRequests?status=All">Tất cả</a>
            </li>
            <li class="nav-item">
                <a class="nav-link${selectedStatus eq 'Pending' ? ' active' : ''}" href="${pageContext.request.contextPath}/viewClubRequests?status=Pending">Chờ duyệt (${pendingCount})</a>
            </li>
            <li class="nav-item">
                <a class="nav-link${selectedStatus eq 'Approved' ? ' active' : ''}" href="${pageContext.request.contextPath}/viewClubRequests?status=Approved">Đã duyệt (${approvedCount})</a>
            </li>
            <li class="nav-item">
                <a class="nav-link${selectedStatus eq 'Rejected' ? ' active' : ''}" href="${pageContext.request.contextPath}/viewClubRequests?status=Rejected">Từ chối (${rejectedCount})</a>
            </li>
        </ul>

        <c:choose>
            <c:when test="${empty requests}">
                <div class="alert alert-info text-center py-5">
                    <i class="fa fa-info-circle fa-3x mb-3"></i>
                    <h5>Không có yêu cầu nào</h5>
                    <p class="mb-0">${selectedStatus eq 'Pending' ? 'Không có yêu cầu chờ duyệt' : (selectedStatus eq 'Approved' ? 'Chưa có yêu cầu nào được phê duyệt' : (selectedStatus eq 'Rejected' ? 'Chưa có yêu cầu nào bị từ chối' : 'Không có yêu cầu tạo CLB nào.'))}</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row">
                    <c:forEach items="${requests}" var="req">
                        <div class="col-xl-6">
                            <div class="request-card">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div>
                                        <h4 class="mb-1">${req.clubName}</h4>
                                        <div class="request-meta">
                                            <i class="fa fa-user-circle"></i> ${req.requestedByName}
                                            <span class="mx-2">•</span>
                                            <i class="fa fa-clock-o"></i>
                                            <fmt:formatDate value="${req.requestedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </div>
                                    </div>
                                    <span class="badge ${req.status eq 'Approved' ? 'badge-success' : req.status eq 'Rejected' ? 'badge-danger' : 'badge-warning'}">${req.status}</span>
                                </div>
                                <p class="text-muted mb-3">${req.description}</p>
                                <div class="d-flex flex-wrap gap-2 mb-3">
                                    <span class="badge badge-light"><i class="fa fa-tags mr-1"></i>${req.clubTypes != null ? req.clubTypes : 'Chưa phân loại'}</span>
                                    <span class="badge badge-light"><i class="fa fa-id-badge mr-1"></i>Yêu cầu #${req.requestId}</span>
                                </div>
                                <c:if test="${not empty req.reviewComment}">
                                    <div class="alert alert-warning py-2 px-3 mb-3">
                                        <i class="fa fa-commenting mr-1"></i> Ghi chú: ${req.reviewComment}
                                    </div>
                                </c:if>
                                <div class="d-flex justify-content-between align-items-center">
                                    <c:choose>
                                        <c:when test="${req.status eq 'Pending'}">
                                            <div class="btn-group">
                                                <button type="button" class="btn btn-success btn-sm" onclick="showApproveModal('${req.requestId}', '${fn:escapeXml(req.clubName)}')">
                                                    <i class="fa fa-check mr-1"></i> Phê duyệt
                                                </button>
                                                <button type="button" class="btn btn-outline-danger btn-sm" onclick="showRejectModal('${req.requestId}', '${fn:escapeXml(req.clubName)}')">
                                                    <i class="fa fa-times mr-1"></i> Từ chối
                                                </button>
                                            </div>
                                        </c:when>
                                        <c:when test="${req.status eq 'Approved'}">
                                            <small class="text-success"><i class="fa fa-check-circle mr-1"></i>Đã phê duyệt bởi ${req.reviewedByName != null ? req.reviewedByName : 'Admin'}.</small>
                                        </c:when>
                                        <c:otherwise>
                                            <small class="text-danger"><i class="fa fa-times-circle mr-1"></i>Đã bị từ chối.</small>
                                        </c:otherwise>
                                    </c:choose>
                                    <c:if test="${req.reviewedAt != null}">
                                        <small class="text-muted">
                                            <i class="fa fa-calendar mr-1"></i>
                                            <fmt:formatDate value="${req.reviewedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </small>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>
<div class="ttr-overlay"></div>

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
                    <p class="text-info"><i class="fa fa-info-circle"></i> Sau khi phê duyệt, CLB sẽ được tạo và hiển thị trong danh sách.</p>
                    <div class="form-group">
                        <label>Ghi chú (tùy chọn):</label>
                        <textarea name="reviewComment" class="form-control" rows="3" placeholder="Nhập ghi chú nếu có..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-success"><i class="fa fa-check"></i> Phê duyệt</button>
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
                        <textarea name="reviewComment" class="form-control" rows="3" placeholder="Vui lòng nhập lý do từ chối..." required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-danger"><i class="fa fa-times"></i> Từ chối</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/popper.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap-select/bootstrap-select.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/scroll/scrollbar.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/owl-carousel/owl.carousel.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/functions.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin.js"></script>
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
</script>
</body>
</html>

