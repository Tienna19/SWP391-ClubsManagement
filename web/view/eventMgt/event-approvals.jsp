<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yêu cầu sự kiện - Hệ thống Quản lý CLB Sinh viên</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" type="image/x-icon" />
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/assets.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/typography.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/shortcodes.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">
    <style>
        .event-request-card {
            border-radius: 16px;
            border: 1px solid rgba(94,53,177,0.1);
            box-shadow: 0 4px 12px rgba(31, 43, 90, 0.08);
            padding: 24px;
            background: #fff;
            margin-bottom: 20px;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .event-request-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(31, 43, 90, 0.12);
        }
        .status-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .status-pending {
            background: rgba(255, 171, 0, 0.18);
            color: #ff6f00;
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }
        .empty-state i {
            font-size: 64px;
            color: #ccc;
            margin-bottom: 20px;
        }
    </style>
</head>
<body class="ttr-opened-sidebar ttr-pinned-sidebar">
    <%@ include file="/WEB-INF/jspf/admin-layout.jspf" %>
    
    <main class="ttr-wrapper">
        <div class="container-fluid">
            <div class="row">
                <div class="col-lg-12 m-b30">
                    <!-- Flash Messages -->
                    <c:if test="${not empty flashMessage}">
                        <div class="alert alert-${flashType} alert-dismissible fade show" role="alert">
                            ${flashMessage}
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                    </c:if>
                    
                    <div class="widget-box">
                        <div class="wc-title">
                            <h4>Yêu cầu sự kiện đang chờ phê duyệt</h4>
                        </div>
                        <div class="widget-inner">
                            <c:choose>
                                <c:when test="${empty pendingRequests}">
                                    <div class="empty-state">
                                        <i class="fa fa-calendar-check-o"></i>
                                        <h3>Không có yêu cầu sự kiện nào đang chờ phê duyệt</h3>
                                        <p>Tất cả các yêu cầu sự kiện đã được xử lý.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="request" items="${pendingRequests}">
                                        <div class="event-request-card">
                                            <div class="row">
                                                <div class="col-md-3">
                                                    <c:choose>
                                                        <c:when test="${not empty request.image}">
                                                            <img src="${pageContext.request.contextPath}/${request.image}" 
                                                                 alt="${request.eventName}" 
                                                                 style="width: 100%; height: 200px; object-fit: cover; border-radius: 12px;">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div style="background: #f0f0f0; height: 200px; display: flex; align-items: center; justify-content: center; border-radius: 12px;">
                                                                <i class="fa fa-calendar" style="font-size: 48px; color: #ccc;"></i>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="col-md-9">
                                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                                        <div>
                                                            <h4 style="margin: 0; color: #2b2350;">${request.eventName}</h4>
                                                            <span class="status-badge status-pending mt-2">Đang chờ duyệt</span>
                                                        </div>
                                                    </div>
                                                    
                                                    <div class="row mb-3">
                                                        <div class="col-md-6">
                                                            <p style="margin: 5px 0;"><strong>CLB:</strong> 
                                                                <c:set var="club" value="${clubsMap[request.clubID]}" />
                                                                ${not empty club ? club.clubName : 'CLB #'}${empty club ? request.clubID : ''}
                                                            </p>
                                                            <p style="margin: 5px 0;"><strong>Địa điểm:</strong> ${not empty request.location ? request.location : 'Chưa cập nhật'}</p>
                                                            <p style="margin: 5px 0;"><strong>Sức chứa:</strong> ${request.capacity} người</p>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <p style="margin: 5px 0;"><strong>Bắt đầu:</strong> 
                                                                <fmt:formatDate value="${request.startDate}" pattern="dd/MM/yyyy HH:mm" />
                                                            </p>
                                                            <p style="margin: 5px 0;"><strong>Kết thúc:</strong> 
                                                                <fmt:formatDate value="${request.endDate}" pattern="dd/MM/yyyy HH:mm" />
                                                            </p>
                                                            <p style="margin: 5px 0;"><strong>Ngày tạo:</strong> 
                                                                <fmt:formatDate value="${request.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                                            </p>
                                                        </div>
                                                    </div>
                                                    
                                                    <c:if test="${not empty request.description}">
                                                        <div class="mb-3">
                                                            <strong>Mô tả:</strong>
                                                            <p style="margin-top: 5px; color: #666;">${fn:substring(request.description, 0, 200)}${fn:length(request.description) > 200 ? '...' : ''}</p>
                                                        </div>
                                                    </c:if>
                                                    
                                                    <div class="d-flex mt-3" style="gap: 12px; flex-wrap: wrap;">
                                                        <button type="button" class="btn btn-success btn-sm btn-approve-request" 
                                                                data-request-id="${request.requestID}" 
                                                                data-event-name="<c:out value='${request.eventName}'/>"
                                                                style="background: #28a745; border: none; padding: 8px 20px; color: white;">
                                                            <i class="fa fa-check"></i> Phê duyệt
                                                        </button>
                                                        <button type="button" class="btn btn-danger btn-sm btn-reject-request" 
                                                                data-request-id="${request.requestID}" 
                                                                data-event-name="<c:out value='${request.eventName}'/>"
                                                                style="background: #dc3545; border: none; padding: 8px 20px; color: white;">
                                                            <i class="fa fa-times"></i> Từ chối
                                                        </button>
                                                        <a href="editEvent?eventId=${-(request.requestID + 1000000)}" class="btn btn-info btn-sm"
                                                           style="background: #17a2b8; border: none; padding: 8px 20px; color: white;">
                                                            <i class="fa fa-eye"></i> Xem chi tiết
                                                        </a>
                                                    </div>
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
    </main>
    
    <!-- Approve/Reject Form (hidden) -->
    <form id="eventActionForm" method="post" action="${pageContext.request.contextPath}/approveRejectEvent" style="display:none;">
        <input type="hidden" name="requestId" id="eventActionRequestId">
        <input type="hidden" name="action" id="eventActionType">
        <input type="hidden" name="redirectTo" value="eventApprovals">
    </form>
    
    <!-- Hidden inputs to store request IDs -->
    <input type="hidden" id="approveRequestId" value="">
    <input type="hidden" id="rejectRequestId" value="">
    
    <!-- Approve Event Confirmation Modal -->
    <div class="modal fade" id="approveEventModal" tabindex="-1" role="dialog" aria-labelledby="approveEventModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header" style="background: #28a745; border: none;">
                    <h5 class="modal-title text-white" id="approveEventModalLabel">
                        <i class="fa fa-check-circle"></i> Phê duyệt Sự kiện
                    </h5>
                    <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body" style="padding: 30px;">
                    <div class="text-center mb-4">
                        <div class="success-icon" style="font-size: 48px; color: #28a745; margin-bottom: 20px;">
                            <i class="fa fa-check-circle"></i>
                        </div>
                        <h4 style="color: #333; margin-bottom: 15px;">Bạn có chắc chắn muốn phê duyệt sự kiện này?</h4>
                        <p style="color: #666; font-size: 16px; margin-bottom: 20px;">
                            Bạn sắp phê duyệt sự kiện: <strong id="approveEventName"></strong>
                        </p>
                        <div class="alert alert-info" style="border-left: 4px solid #28a745; background-color: #d1f2eb; border-color: #28a745;">
                            <i class="fa fa-info-circle"></i>
                            <strong>Lưu ý:</strong> Sự kiện sẽ được chuyển sang trạng thái "Published" và hiển thị công khai cho tất cả người dùng. 
                            Bạn có thể chỉnh sửa hoặc hủy sự kiện sau khi phê duyệt.
                        </div>
                    </div>
                </div>
                <div class="modal-footer" style="border: none; padding: 20px 30px; background-color: #f8f9fa;">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal" style="padding: 10px 25px;">
                        <i class="fa fa-times"></i> Hủy
                    </button>
                    <button type="button" class="btn btn-success" id="approveConfirmBtn" onclick="confirmApproveEvent()" style="padding: 10px 25px; background: #28a745; border: none; color: white;">
                        <i class="fa fa-check"></i> Xác nhận phê duyệt
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Reject Event Confirmation Modal -->
    <div class="modal fade" id="rejectEventModal" tabindex="-1" role="dialog" aria-labelledby="rejectEventModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header" style="background: #dc3545; border: none;">
                    <h5 class="modal-title text-white" id="rejectEventModalLabel">
                        <i class="fa fa-times-circle"></i> Từ chối Sự kiện
                    </h5>
                    <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body" style="padding: 30px;">
                    <div class="text-center mb-4">
                        <div class="warning-icon" style="font-size: 48px; color: #dc3545; margin-bottom: 20px;">
                            <i class="fa fa-exclamation-triangle"></i>
                        </div>
                        <h4 style="color: #333; margin-bottom: 15px;">Bạn có chắc chắn muốn từ chối sự kiện này?</h4>
                        <p style="color: #666; font-size: 16px; margin-bottom: 20px;">
                            Bạn sắp từ chối sự kiện: <strong id="rejectEventName"></strong>
                        </p>
                        <div class="alert alert-warning" style="border-left: 4px solid #dc3545; background-color: #f8d7da; border-color: #f5c6cb;">
                            <i class="fa fa-info-circle"></i>
                            <strong>Lưu ý:</strong> Sự kiện sẽ được chuyển sang trạng thái "Rejected" và chỉ người tạo sự kiện mới có thể xem. 
                            Người tạo có thể chỉnh sửa và gửi lại yêu cầu phê duyệt.
                        </div>
                    </div>
                </div>
                <div class="modal-footer" style="border: none; padding: 20px 30px; background-color: #f8f9fa;">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal" style="padding: 10px 25px;">
                        <i class="fa fa-times"></i> Hủy
                    </button>
                    <button type="button" class="btn btn-danger" id="rejectConfirmBtn" onclick="confirmRejectEvent()" style="padding: 10px 25px; background: #dc3545; border: none; color: white;">
                        <i class="fa fa-times"></i> Xác nhận từ chối
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Scripts -->
    <script src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/popper.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
    <script>
        $(document).ready(function() {
            // Approve button click
            $('.btn-approve-request').on('click', function(e) {
                e.preventDefault();
                var requestId = $(this).data('request-id');
                var eventName = $(this).data('event-name');
                showApproveEventModal(requestId, eventName);
            });
            
            // Reject button click
            $('.btn-reject-request').on('click', function(e) {
                e.preventDefault();
                var requestId = $(this).data('request-id');
                var eventName = $(this).data('event-name');
                showRejectEventModal(requestId, eventName);
            });
        });
        
        // Approve Event Modal Functions
        function showApproveEventModal(requestId, eventName) {
            $('#approveRequestId').val(requestId);
            $('#approveEventName').text(eventName);
            $('#approveEventModal').modal('show');
        }
        
        function confirmApproveEvent() {
            var requestId = $('#approveRequestId').val();
            var eventName = $('#approveEventName').text();
            
            // Show loading state
            $('#approveConfirmBtn').html('<i class="fa fa-spinner fa-spin"></i> Đang phê duyệt...');
            $('#approveConfirmBtn').prop('disabled', true);
            
            // Submit form
            $('#eventActionRequestId').val(requestId);
            $('#eventActionType').val('approve');
            $('#eventActionForm').submit();
        }
        
        // Reject Event Modal Functions
        function showRejectEventModal(requestId, eventName) {
            $('#rejectRequestId').val(requestId);
            $('#rejectEventName').text(eventName);
            $('#rejectEventModal').modal('show');
        }
        
        function confirmRejectEvent() {
            var requestId = $('#rejectRequestId').val();
            var eventName = $('#rejectEventName').text();
            
            // Show loading state
            $('#rejectConfirmBtn').html('<i class="fa fa-spinner fa-spin"></i> Đang từ chối...');
            $('#rejectConfirmBtn').prop('disabled', true);
            
            // Submit form
            $('#eventActionRequestId').val(requestId);
            $('#eventActionType').val('reject');
            $('#eventActionForm').submit();
        }
    </script>
</body>
</html>

