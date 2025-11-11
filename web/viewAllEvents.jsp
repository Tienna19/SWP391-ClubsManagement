<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <title>All Events</title>
  <style>
    body { font-family: Arial, sans-serif; background:#f5f7fb; margin:0; padding:40px; }
    h1 { text-align:center; color:#2c3e50; margin-bottom:10px; }
    .subtitle { text-align:center; color:#666; margin-bottom:30px; }

    .events-grid {
      display:grid;
      grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
      gap:25px;
    }
    .event-card {
      background:white; border-radius:10px; overflow:hidden;
      box-shadow:0 2px 8px rgba(0,0,0,0.1); transition:transform .2s;
    }
    .event-card:hover { transform:translateY(-5px); }
    .event-card img { width:100%; height:160px; object-fit:cover; }
    .event-info { padding:15px; }
    .event-info h3 { margin:0 0 8px; color:#34495e; }
    .event-info p { margin:0; color:#777; font-size:14px; }
    .event-info .date { font-weight:bold; color:#2980b9; margin-bottom:5px; display:block; }
    .view-btn {
      display:inline-block; margin-top:10px;
      background:#3498db; color:white; padding:6px 12px;
      border-radius:4px; text-decoration:none; font-size:14px;
    }
  </style>
</head>
<body>

  <h1>Upcoming Events</h1>
  <div class="subtitle">Discover events organized by clubs you might like to join!</div>

  <c:if test="${empty events}">
    <p style="text-align:center; color:#888;">No published events available.</p>
  </c:if>

  <div class="events-grid">
    <c:forEach var="e" items="${events}">
      <div class="event-card">
        <img src="${empty e.image ? 'images/default-event.jpg' : e.image}" alt="${e.eventName}">
        <div class="event-info">
          <span class="date">
            ${e.startDate} - ${e.endDate}
          </span>
          <h3>${e.eventName}</h3>
          <p>${e.location}</p>
          <a class="view-btn" href="ViewAllEventsServlet?eventId=${e.eventID}">View Details</a>
        </div>
      </div>
    </c:forEach>
  </div>

</body>
</html>
