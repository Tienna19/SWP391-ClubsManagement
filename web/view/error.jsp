<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page isErrorPage="true" %>
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
        <div class="error-icon">⚠️</div>
        <h1>Oops! Something went wrong</h1>
        <p>We're sorry, but an error occurred while processing your request.</p>
        
        <c:if test="${not empty errorMessage}">
            <div class="error-message">
                <strong>Error Details:</strong><br>
                ${errorMessage}
            </div>
        </c:if>
        
        <c:if test="${not empty requestScope['javax.servlet.error.message']}">
            <div class="error-message">
                <strong>Technical Details:</strong><br>
                ${requestScope['javax.servlet.error.message']}
            </div>
        </c:if>
        
        <div>
            <a href="${pageContext.request.contextPath}/home" class="btn">Go to Home</a>
            <a href="javascript:history.back()" class="btn">Go Back</a>
        </div>
        
        <p style="margin-top: 30px; color: #6c757d; font-size: 14px;">
            If this problem persists, please contact the system administrator.
        </p>
    </div>
</body>
</html>
