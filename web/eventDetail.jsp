<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <title>${event.eventName}</title>
  <style>
    body { font-family: Arial, sans-serif; background:#f4f6f9; margin:0; padding:40px; }
    .container { max-width:800px; margin:auto; background:white; border-radius:10px; padding:25px;
      box-shadow:0 2px 10px rgba(0,0,0,0.1);}
    h1 { color:#2c3e50; margin-bottom:10px; }
    .meta { color:#777; margin-bottom:15px; }
    .description { margin:20px 0; color:#333; line-height:1.6; }
    .register-btn {
      background:#27ae60; color:white; padding:12px 20px; border:none;
      border-radius:6px; font-size:16px; cursor:pointer;
    }
    .register-btn:hover { background:#219150; }
    .message { margin-top:20px; padding:10px; border-left:5px solid #3498db; background:#eaf6ff; }
    .back-link { display:inline-block; margin-top:20px; text-decoration:none; color:#3498db; }
    img.event-img { width:100%; border-radius:10px; margin-bottom:20px; }
  </style>
</head>
<body>

<div class="container">
  <c:if test="${not empty event}">
    <img src="${empty event.image ? 'images/default-event.jpg' : event.image}" alt="${event.eventName}" class="event-img">
    <h1>${event.eventName}</h1>
    <div class="meta">
      📍 ${event.location}<br>
      🗓️ ${event.startDate} → ${event.endDate}<br>
      👥 Capacity: ${event.capacity}
    </div>
    <div class="description">${event.description}</div>

    <!-- Nút đăng ký sự kiện -->
    <form action="${pageContext.request.contextPath}/RegisterForEventServlet" method="post">
      <input type="hidden" name="eventId" value="${event.eventID}">
      <button type="submit" class="register-btn">Register for Event</button>
    </form>

    <c:if test="${not empty message}">
      <div class="message">${message}</div>
    </c:if>

    <a href="ViewAllEventsServlet" class="back-link">← Back to All Events</a>
  </c:if>

  <c:if test="${empty event}">
    <p>⚠️ Event not found.</p>
  </c:if>
</div>

</body>
</html>
