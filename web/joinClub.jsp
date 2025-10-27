<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <title>Request to Join Club</title>
  <style>
    body {
      font-family: 'Segoe UI', Arial, sans-serif;
      background: #f4f6f9;
      margin: 0; padding: 0;
    }
    .container {
      width: 650px; margin: 50px auto; background: #fff;
      padding: 30px; border-radius: 10px;
      box-shadow: 0 2px 6px rgba(0,0,0,0.15);
    }
    h1 {
      text-align: center; margin-bottom: 25px;
      color: #2c3e50; font-size: 24px;
    }
    label {
      display: block; margin-top: 12px;
      font-weight: 600; color: #34495e;
    }
    input, select, textarea {
      width: 100%; padding: 8px; margin-top: 6px;
      border: 1px solid #ccc; border-radius: 4px;
      font-size: 14px;
    }
    textarea { resize: vertical; }
    button {
      margin-top: 20px; width: 100%;
      background: #2ecc71; color: white;
      padding: 10px; border: none; border-radius: 5px;
      cursor: pointer; font-size: 16px; font-weight: bold;
    }
    button:hover { background: #27ae60; }
    .message {
      margin-top: 15px; padding: 10px;
      background: #eaf6ff; border-left: 4px solid #3498db;
      color: #2c3e50;
    }
  </style>
</head>
<body>

  <div class="container">
    <h1>Request to Join Club</h1>

    <form action="JoinClubServlet" method="post">
      <!-- Thông tin cá nhân -->
      <label>Full Name</label>
      <input type="text" name="fullName" required>

      <label>Gender</label>
      <select name="gender" required>
        <option value="">-- Select Gender --</option>
        <option>Male</option>
        <option>Female</option>
        <option>Other</option>
      </select>

      <label>Address</label>
      <input type="text" name="address" placeholder="Your current address">

      <label>Email</label>
      <input type="email" name="email" placeholder="your.email@example.com" required>

      <label>Phone Number</label>
      <input type="text" name="phoneNumber" placeholder="e.g., 0909123456">

      <hr style="margin: 25px 0;">

      <!-- Thông tin ??ng ký CLB -->
      <label>Student ID</label>
      <input type="number" name="userId" required placeholder="Enter your UserID">

      <label>Select Club</label>
      <select name="clubId" required>
        <option value="">-- Choose a Club --</option>
        <option value="1">Football Club</option>
        <option value="2">Music Club</option>
        <option value="3">Volunteer Club</option>
      </select>

      <label>Reason for Joining</label>
      <textarea name="reason" rows="3" required
        placeholder="Why do you want to join this club?"></textarea>

      <button type="submit">Submit Request</button>
    </form>

    <c:if test="${not empty message}">
      <div class="message">${message}</div>
    </c:if>
  </div>
</body>
</html>
