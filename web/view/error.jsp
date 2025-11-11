<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page isErrorPage="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Club Management System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 20px;
        }
        .error-container {
            max-width: 600px;
            margin: 50px auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        .error-icon {
            font-size: 48px;
            color: #dc3545;
            margin-bottom: 20px;
        }
        h1 {
            color: #dc3545;
            margin-bottom: 20px;
        }
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 4px;
            margin: 20px 0;
            border: 1px solid #f5c6cb;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            margin: 10px;
        }
        .btn:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <!-- Check if it's a 403 Permission Error -->
        <c:choose>
            <c:when test="${errorCode == '403'}">
                <div class="error-icon">🚫</div>
                <h1 style="color: #dc3545;">Không có quyền truy cập</h1>
                <p>Bạn không có quyền thực hiện thao tác này.</p>
                
                <div class="error-message" style="background-color: #fff3cd; color: #856404; border-color: #ffeeba;">
                    <strong>⚠️ Lý do:</strong><br>
                    ${errorMessage != null ? errorMessage : 'Chỉ Admin hoặc Club Leader mới có quyền chỉnh sửa/xóa CLB.'}
                </div>
                
                <div style="margin-top: 20px; padding: 15px; background-color: #e7f3ff; border-radius: 4px;">
                    <p style="margin: 0;"><strong>💡 Gợi ý:</strong></p>
                    <ul style="text-align: left; margin: 10px 0;">
                        <li>Nếu bạn là thành viên CLB, liên hệ Club Leader để được hỗ trợ</li>
                        <li>Nếu bạn là Club Leader, đăng nhập lại để kiểm tra quyền</li>
                        <li>Nếu bạn cần quyền Admin, liên hệ quản trị viên hệ thống</li>
                    </ul>
                </div>
            </c:when>
            <c:otherwise>
                <div class="error-icon">⚠️</div>
                <h1>Oops! Something went wrong</h1>
                <p>We're sorry, but an error occurred while processing your request.</p>
                
                <c:if test="${not empty errorMessage}">
                    <div class="error-message">
                        <strong>Error Details:</strong><br>
                        ${errorMessage}
                    </div>
                </c:if>
                
                <c:if test="${not empty error}">
                    <div class="error-message">
                        <strong>Error:</strong><br>
                        ${error}
                    </div>
                </c:if>
                
                <c:if test="${not empty requestScope['javax.servlet.error.message']}">
                    <div class="error-message">
                        <strong>Technical Details:</strong><br>
                        ${requestScope['javax.servlet.error.message']}
                    </div>
                </c:if>
            </c:otherwise>
        </c:choose>
        
        <div style="margin-top: 20px;">
            <a href="${pageContext.request.contextPath}/home" class="btn">🏠 Về Trang chủ</a>
            <a href="${pageContext.request.contextPath}/viewAllClubs" class="btn">📋 Danh sách CLB</a>
            <a href="javascript:history.back()" class="btn" style="background-color: #6c757d;">↩️ Quay lại</a>
        </div>
        
        <p style="margin-top: 30px; color: #6c757d; font-size: 14px;">
            Nếu vấn đề vẫn tiếp diễn, vui lòng liên hệ quản trị viên hệ thống.
        </p>
    </div>
</body>
</html>
