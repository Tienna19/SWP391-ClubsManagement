<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<h2>Assign Role (New Version)</h2>

<c:if test="${not empty error}">
    <p style="color:red">${error}</p>
</c:if>

<c:if test="${not empty message}">
    <p style="color:green">${message}</p>
</c:if>

<!-- chọn CLB -->
<form method="get">
    <label>Chọn CLB:</label>
    <select name="clubId" onchange="this.form.submit()">
        <option value="">-- chọn --</option>
        <c:forEach items="${clubs}" var="c">
            <option value="${c.clubId}" ${param.clubId == c.clubId ? 'selected' : ''}>
                ${c.clubName}
            </option>
        </c:forEach>
    </select>
</form>

<c:if test="${not empty members}">
    <form method="get">
        <input type="hidden" name="clubId" value="${param.clubId}">
        <label>Chọn thành viên:</label>
        <select name="membershipId" onchange="this.form.submit()">
            <option value="">-- chọn --</option>
            <c:forEach items="${members}" var="m">
                <option value="${m.membershipId}" ${param.membershipId == m.membershipId ? 'selected' : ''}>
                    ${m.fullName} (${m.email})
                </option>
            </c:forEach>
        </select>
    </form>
</c:if>

<c:if test="${not empty detail}">
    <h3>Chi tiết:</h3>

    <form method="post">
        <input type="hidden" name="membershipId" value="${detail.membershipId}"/>

        <p>Club role hiện tại: <b>${detail.roleInClub}</b></p>
        <p>System role hiện tại: <b>${detail.systemRoleId}</b></p>

        <label>Club role mới:</label>
        <select name="newClubRole">
            <option value="Member">Member</option>
            <option value="Leader">Leader</option>
        </select><br/>

        <label>Membership status:</label>
        <select name="membershipStatus">
            <option value="Active">Active</option>
            <option value="Inactive">Inactive</option>
        </select><br/>

        <label>System role:</label>
        <select name="systemRoleId">
            <option value="">-- giữ nguyên --</option>
            <c:forEach items="${systemRoles}" var="r">
                <option value="${r.roleId}">${r.roleName}</option>
            </c:forEach>
        </select><br/>

        <label>User status:</label>
        <select name="systemStatus">
            <option value="Active">Active</option>
            <option value="Inactive">Inactive</option>
        </select><br/>

        <button type="submit">Lưu</button>
    </form>
</c:if>
