<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <title>Club Management - Assign Roles</title>
  <style>
    body { margin:0; font-family: Arial, sans-serif; background:#f5f7fa; }
    .sidebar { position: fixed; left:0; top:0; bottom:0;
      width:220px; background:#2c3e50; color:#ecf0f1; padding-top:20px; }
    .sidebar h2 { text-align:center; margin-bottom:30px; font-size:18px; }
    .sidebar a { display:block; padding:12px 20px; color:#ecf0f1; text-decoration:none; transition:0.3s; }
    .sidebar a:hover { background:#34495e; }
    .main { margin-left:220px; padding:20px; }
    .header { display:flex; justify-content:space-between; align-items:center; margin-bottom:20px; }
    .header h1 { font-size:24px; margin:0; }
    .search-bar { margin-bottom:20px; display:flex; gap:10px; }
    .search-bar input, .search-bar select { padding:8px; border:1px solid #ccc; border-radius:4px; }
    .search-bar button { padding:8px 15px; border:none; border-radius:4px; cursor:pointer; background:#3498db; color:white; }
    table { width:100%; border-collapse:collapse; background:white; box-shadow:0 2px 4px rgba(0,0,0,0.1); }
    th, td { padding:12px; text-align:left; border-bottom:1px solid #ddd; }
    th { background:#ecf0f1; }
    tr:hover { background:#f9f9f9; }
    .status-active { color:green; font-weight:bold; }
    .status-inactive { color:red; font-weight:bold; }
    .action-btn { margin-right:8px; padding:6px 10px; border:none; border-radius:4px; cursor:pointer; }
    .assign { background:#2ecc71; color:white; }
    .approve { background:#3498db; color:white; }
    .reject { background:#e74c3c; color:white; }
    .pagination { margin-top:15px; text-align:center; }
    .pagination span, .pagination a { margin:0 5px; padding:6px 12px; border:1px solid #ccc; border-radius:4px; cursor:pointer; background:white; }
    .pagination .active { background:#3498db; color:white; border-color:#3498db; }
  </style>
</head>
<body>
  <div class="sidebar">
    <h2>Club Admin</h2>
    <a href="#">Dashboard</a>
    <a href="#">Clubs</a>
    <a href="#">Members</a>
    <a href="AssignRoleServlet">Assign Roles</a>
    <a href="ApproveRoleServlet">Approve Requests</a>
    <a href="#">Settings</a>
  </div>

  <div class="main">
    <div class="header">
      <h1>Assign Roles</h1>
      <button style="background:#2ecc71;color:white;padding:8px 15px;border:none;border-radius:4px;">+ Add Member</button>
    </div>

    <!-- Search Bar -->
    <form class="search-bar" method="get" action="AssignRoleServlet">
      <input type="text" name="keyword" placeholder="Search member...">
      <select name="filterRole">
        <option value="">All Roles</option>
        <option>Leader</option>
        <option>Vice</option>
        <option>Treasurer</option>
        <option>Secretary</option>
        <option>Member</option>
      </select>
      <button type="submit">Search</button>
    </form>

    <!-- Message -->
    <c:if test="${not empty message}">
      <div style="margin-bottom:15px;padding:10px;background:#e1f5fe;border:1px solid #81d4fa;">${message}</div>
    </c:if>

    <!-- Members Table -->
    <table>
      <thead>
        <tr>
          <th>ID</th>
          <th>Name</th>
          <th>Current Role</th>
          <th>Status</th>
          <th>Action</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="m" items="${members}">
          <tr>
            <td>${m.membershipId}</td>
            <td>${m.fullName}</td>
            <td>${m.role}</td>
            <td>
              <span class="${m.status eq 'Active' ? 'status-active' : 'status-inactive'}">
                ${m.status}
              </span>
            </td>
            <td>
              <!-- Form Assign -->
              <form action="AssignRoleServlet" method="post" style="display:inline;">
                <input type="hidden" name="membershipId" value="${m.membershipId}">
                <select name="newRole">
                  <option ${m.role == 'Leader' ? 'selected' : ''}>Leader</option>
                  <option ${m.role == 'Vice' ? 'selected' : ''}>Vice</option>
                  <option ${m.role == 'Treasurer' ? 'selected' : ''}>Treasurer</option>
                  <option ${m.role == 'Secretary' ? 'selected' : ''}>Secretary</option>
                  <option ${m.role == 'Member' ? 'selected' : ''}>Member</option>
                </select>
                <button type="submit" class="action-btn assign">Assign</button>
              </form>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>

    <!-- Pagination -->
    <div class="pagination">
      <c:forEach begin="1" end="${totalPages}" var="i">
        <c:choose>
          <c:when test="${i == currentPage}">
            <span class="active">${i}</span>
          </c:when>
          <c:otherwise>
            <a href="AssignRoleServlet?page=${i}">${i}</a>
          </c:otherwise>
        </c:choose>
      </c:forEach>
    </div>
  </div>
</body>
</html>

