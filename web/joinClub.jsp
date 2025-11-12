<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <title>Request to Join Club</title>
  <style>
    body { font-family: 'Segoe UI', Arial, sans-serif; background: #f4f6f9; margin: 0; padding: 0; }
    .container { width: 650px; margin: 50px auto; background: #fff; padding: 30px; border-radius: 10px; box-shadow: 0 2px 6px rgba(0,0,0,0.15); }
    h1 { text-align: center; margin-bottom: 25px; color: #2c3e50; font-size: 24px; }
    label { display: block; margin-top: 12px; font-weight: 600; color: #34495e; }
    input, textarea { width: 100%; padding: 8px; margin-top: 6px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; }
    input[readonly] { background: #f8f9fb; }
    textarea { resize: vertical; }
    button { margin-top: 20px; width: 100%; background: #2ecc71; color: white; padding: 10px; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; font-weight: bold; }
    button:hover { background: #27ae60; }
    .message { margin-top: 15px; padding: 10px; background: #eaf6ff; border-left: 4px solid #3498db; color: #2c3e50; }
    .muted { color: #6c757d; font-size: 13px; }
  </style>
</head>
<body>
  <div class="container">
    <h1>Request to Join Club</h1>

    <c:if test="${not empty message}">
      <div class="message">${message}</div>
    </c:if>

    <form action="JoinClubServlet" method="post">

      <input type="hidden" name="clubId" value="${prefillClubId}" />
      
      <input type="hidden" name="userId" value="${prefillUserId}" />

      <label>Full Name</label>
      <input type="text" value="${prefillFullName}" readonly />

      <label>Email</label>
      <input type="email" value="${prefillEmail}" readonly />

      <label>Club</label>
      <input type="text" value="${club.clubName}" readonly /> 
      <span class="muted">ID: ${prefillClubId}</span>

      <hr style="margin: 25px 0;">

      <label>Reason for Joining</label>
      <textarea name="reason" rows="3" required
        placeholder="Why do you want to join this club?"></textarea>

      <button type="submit">Submit Request</button>
    </form>
  </div>
</body>
</html>
