<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <title>User Management</title>
  <style>
    body {
      font-family: "Segoe UI", Arial, sans-serif;
      background: #f5f6fa;
      margin: 0;
      padding: 20px;
      color: #2c3e50;
    }

    h1 {
      text-align: center;
      font-size: 28px;
      margin-bottom: 10px;
    }

    .subtitle {
      text-align: center;
      color: #7f8c8d;
      margin-bottom: 30px;
    }

    .top-bar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
    }

    .search-filter {
      display: flex;
      gap: 10px;
    }

    .search-filter input {
      padding: 8px 10px;
      border: 1px solid #ccc;
      border-radius: 6px;
      font-size: 14px;
    }

    .search-filter button {
      padding: 8px 15px;
      background: #3498db;
      border: none;
      border-radius: 6px;
      color: white;
      cursor: pointer;
    }

    .btn-add {
      background: #27ae60;
      color: white;
      border: none;
      padding: 10px 20px;
      border-radius: 8px;
      font-weight: bold;
      cursor: pointer;
      font-size: 14px;
    }

    .btn-add:hover {
      background: #219150;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      background: white;
      border-radius: 8px;
      overflow: hidden;
      box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }

    th, td {
      padding: 12px;
      border-bottom: 1px solid #eee;
      text-align: left;
    }

    th {
      background: #f0f2f5;
      font-weight: bold;
    }

    .status-active { background: #2ecc71; color: white; padding: 4px 8px; border-radius: 6px; font-size: 12px; }
    .status-inactive { background: #95a5a6; color: white; padding: 4px 8px; border-radius: 6px; font-size: 12px; }
    .status-suspended { background: #e74c3c; color: white; padding: 4px 8px; border-radius: 6px; font-size: 12px; }

    .actions button {
      background: none;
      border: none;
      cursor: pointer;
      margin-right: 5px;
      font-size: 16px;
    }

    .actions .edit { color: #3498db; }
    .actions .delete { color: #e74c3c; }

    .pagination {
      text-align: center;
      margin-top: 20px;
    }

    .pagination a, .pagination span {
      display: inline-block;
      padding: 6px 12px;
      margin: 0 4px;
      border-radius: 6px;
      border: 1px solid #ccc;
      color: #2c3e50;
      text-decoration: none;
    }

    .pagination .active {
      background: #3498db;
      color: white;
      border-color: #3498db;
    }

    /* Modal Popup */
    .modal {
      display: none;
      position: fixed;
      z-index: 1000;
      left: 0; top: 0;
      width: 100%; height: 100%;
      background: rgba(0, 0, 0, 0.5);
      justify-content: center;
      align-items: center;
    }

    .modal-content {
      background: white;
      width: 450px;
      padding: 20px;
      border-radius: 10px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.2);
      animation: fadeIn 0.3s ease-in-out;
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(-10px); }
      to { opacity: 1; transform: translateY(0); }
    }

    .modal-content h3 {
      margin-top: 0;
      text-align: center;
      color: #34495e;
    }

    .modal-content input, .modal-content select {
      width: 100%;
      padding: 8px;
      margin-bottom: 10px;
      border-radius: 6px;
      border: 1px solid #ccc;
    }

    .modal-content button {
      padding: 8px 15px;
      border: none;
      border-radius: 6px;
      cursor: pointer;
    }

    .save-btn { background: #27ae60; color: white; width: 100%; }
    .cancel-btn { background: #7f8c8d; color: white; width: 100%; margin-top: 5px; }
  </style>
</head>
<body>

  <h1>User Management</h1>
  <div class="subtitle">Manage all users in one place. Control access, assign roles, and monitor activity.</div>

  <div class="top-bar">
    <form class="search-filter" method="get" action="ManageUsersServlet">
      <input type="text" name="keyword" placeholder="Search user...">
      <button type="submit">Search</button>
    </form>
    <button class="btn-add" onclick="openModal()">+ Add User</button>
  </div>

  <c:if test="${not empty message}">
    <div style="background:#d1f2eb;padding:10px;border-left:5px solid #1abc9c;margin-bottom:15px;">${message}</div>
  </c:if>

  <table>
    <thead>
      <tr>
        <th>ID</th>
        <th>Full Name</th>
        <th>Email</th>
        <th>Phone</th>
        <th>Address</th>
        <th>Gender</th>
        <th>Role</th>
        <th>Action</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="u" items="${users}">
        <tr>
          <td>${u.userID}</td>
          <td>${u.fullName}</td>
          <td>${u.email}</td>
          <td>${u.phoneNumber}</td>
          <td>${u.address}</td>
          <td>${u.gender}</td>
          <td>${u.roleID}</td>
          <td class="actions">
            <button class="edit" title="Edit"
                    onclick="editUser('${u.userID}','${u.fullName}','${u.email}','${u.phoneNumber}','${u.address}','${u.gender}','${u.roleID}')">&#9998;</button>
            <form action="ManageUsersServlet" method="post" style="display:inline;" onsubmit="return confirmDeactivate()">
              <input type="hidden" name="action" value="deactivate">
              <input type="hidden" name="userId" value="${u.userID}">
              <button class="delete" title="Deactivate">&#128465;</button>
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
          <a href="ManageUsersServlet?page=${i}">${i}</a>
        </c:otherwise>
      </c:choose>
    </c:forEach>
  </div>

  <!-- pop-up để add, edit -->
  <div class="modal" id="userModal">
    <div class="modal-content">
      <h3 id="modalTitle">Add New User</h3>
      <form id="userForm" action="ManageUsersServlet" method="post">
        <input type="hidden" name="action" id="formAction" value="create">
        <input type="hidden" name="userId" id="userId">

        <label>Full Name:</label>
        <input type="text" name="fullName" id="fullName" required>

        <label>Email:</label>
        <input type="email" name="email" id="email" required>

        <label>Phone:</label>
        <input type="text" name="phone" id="phone">

        <label>Address:</label>
        <input type="text" name="address" id="address">

        <label>Gender:</label>
        <select name="gender" id="gender">
          <option value="Nam">Nam</option>
          <option value="Nữ">Nữ</option>
        </select>

        <label>Role:</label>
        <select name="role" id="role">
          <option value="1">User</option>
          <option value="2">Member</option>
          <option value="3">ClubLeader</option>
          <option value="4">Admin</option>
        </select>

        <button type="submit" class="save-btn">Save</button>
        <button type="button" class="cancel-btn" onclick="closeModal()">Cancel</button>
      </form>
    </div>
  </div>

  <script>
    function openModal() {
      document.getElementById("modalTitle").innerText = "Add New User";
      document.getElementById("formAction").value = "create";
      document.getElementById("userForm").reset();
      document.getElementById("userModal").style.display = "flex";
    }

    function editUser(id, name, email, phone, address, gender, role) {
      document.getElementById("modalTitle").innerText = "Edit User";
      document.getElementById("formAction").value = "update";
      document.getElementById("userId").value = id;
      document.getElementById("fullName").value = name;
      document.getElementById("email").value = email;
      document.getElementById("phone").value = phone;
      document.getElementById("address").value = address;
      document.getElementById("gender").value = gender;
      document.getElementById("role").value = role;
      document.getElementById("userModal").style.display = "flex";
    }

    function closeModal() {
      document.getElementById("userModal").style.display = "none";
    }

    function confirmDeactivate() {
      return confirm("⚠️ Are you sure you want to deactivate this user?");
    }
  </script>

</body>
</html>
