<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Sự kiện đã đăng ký</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 40px;
        }
        h2 {
            text-align: center;
            color: #2c3e50;
        }
        .events-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 25px;
            margin-top: 30px;
        }
        .event-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .event-title {
            font-size: 18px;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 10px;
        }
        .event-info {
            font-size: 14px;
            color: #555;
            margin-bottom: 15px;
        }
        .checkin-btn {
            background-color: #27ae60;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .checkin-btn:hover {
            background-color: #219150;
        }
        .checked {
            background-color: #aaa;
            cursor: not-allowed;
        }
        .message {
            text-align: center;
            margin-top: 20px;
            color: #3498db;
            font-weight: bold;
        }
    </style>
</head>
<body>

<h2>🎉 Sự kiện bạn đã đăng ký</h2>

<c:if test="${not empty message}">
    <div class="message">${message}</div>
</c:if>

<div class="events-grid">
    <c:forEach var="reg" items="${registrations}">
        <div class="event-card">
            <div class="event-title">Sự kiện #${reg.eventID}</div>
            <div class="event-info">
                👤 Người dùng: ${reg.userID}<br>
                🗓️ Ngày đăng ký: ${reg.registeredAt}<br>
                ✅ Trạng thái: 
                <c:choose>
                    <c:when test="${reg.checkIn}">
                        Đã Check-in
                    </c:when>
                    <c:otherwise>
                        Chưa Check-in
                    </c:otherwise>
                </c:choose>
            </div>
            <c:if test="${!reg.checkIn}">
                <form action="${pageContext.request.contextPath}/CheckInServlet" method="post">
                    <input type="hidden" name="eventId" value="${reg.eventID}">
                    <button type="submit" class="checkin-btn">Check-in</button>
                </form>
            </c:if>
            <c:if test="${reg.checkIn}">
                <button class="checkin-btn checked" disabled>Đã Check-in</button>
            </c:if>
        </div>
    </c:forEach>
</div>

</body>
</html>
