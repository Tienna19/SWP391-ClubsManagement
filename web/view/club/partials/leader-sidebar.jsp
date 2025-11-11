<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="ttr-sidebar">
    <div class="ttr-sidebar-wrapper content-scroll">
        <div class="ttr-sidebar-logo">
            <a href="${pageContext.request.contextPath}/home">
                <img alt="" src="${pageContext.request.contextPath}/assets/images/logo.png" width="122" height="27">
            </a>
            <div class="ttr-sidebar-toggle-button">
                <i class="ti-arrow-left"></i>
            </div>
        </div>
        <nav class="ttr-sidebar-navi">
            <ul>
                <li class="ttr-seperate"></li>
                <li class="<c:if test='${activeMenu eq "dashboard"}'>active</c:if>">
                    <a href="${pageContext.request.contextPath}/clubDashboard?clubId=${club.clubId}"
                       class="ttr-material-button <c:if test='${activeMenu eq "dashboard"}'>active</c:if>">
                        <span class="ttr-icon"><i class="ti-home"></i></span>
                        <span class="ttr-label">Dashboard</span>
                    </a>
                </li>
                <li class="<c:if test='${activeMenu eq "clubInfo"}'>active</c:if>">
                    <a href="${pageContext.request.contextPath}/clubDetail?clubId=${club.clubId}"
                       class="ttr-material-button <c:if test='${activeMenu eq "clubInfo"}'>active</c:if>">
                        <span class="ttr-icon"><i class="ti-info-alt"></i></span>
                        <span class="ttr-label">Thông tin CLB</span>
                    </a>
                </li>
                <li class="<c:if test='${activeMenu eq "clubEdit"}'>active</c:if>">
                    <a href="${pageContext.request.contextPath}/updateClub?clubId=${club.clubId}"
                       class="ttr-material-button <c:if test='${activeMenu eq "clubEdit"}'>active</c:if>">
                        <span class="ttr-icon"><i class="ti-pencil"></i></span>
                        <span class="ttr-label">Chỉnh sửa CLB</span>
                    </a>
                </li>
                <li class="<c:if test='${activeMenu eq "members" || activeMenu eq "memberApprovals"}'>active open</c:if>">
                    <a href="#" class="ttr-material-button">
                        <span class="ttr-icon"><i class="ti-user"></i></span>
                        <span class="ttr-label">Thành viên</span>
                        <span class="ttr-arrow-icon"><i class="fa fa-angle-down"></i></span>
                    </a>
                    <ul>
                        <li>
                            <a href="${pageContext.request.contextPath}/memberList?clubId=${club.clubId}"
                               class="ttr-material-button <c:if test='${activeMenu eq "members"}'>active</c:if>">
                                <span class="ttr-label">Danh sách TV</span>
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/memberApprovals?clubId=${club.clubId}"
                               class="ttr-material-button <c:if test='${activeMenu eq "memberApprovals"}'>active</c:if>">
                                <span class="ttr-label">Phê duyệt thành viên</span>
                                <c:if test="${not empty pendingRequests and pendingRequests gt 0}">
                                    <span class="ttr-badge badge-success">${pendingRequests}</span>
                                </c:if>
                            </a>
                        </li>
                    </ul>
                </li>
                <li class="<c:if test='${activeMenu eq "events"}'>active</c:if>">
                    <a href="#" class="ttr-material-button">
                        <span class="ttr-icon"><i class="ti-calendar"></i></span>
                        <span class="ttr-label">Sự kiện</span>
                        <span class="ttr-arrow-icon"><i class="fa fa-angle-down"></i></span>
                    </a>
                    <ul>
                        <li>
                            <a href="${pageContext.request.contextPath}/listEvents"
                               class="ttr-material-button">
                                <span class="ttr-label">Danh sách sự kiện</span>
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/addNewEvent"
                               class="ttr-material-button">
                                <span class="ttr-label">Tạo sự kiện mới</span>
                            </a>
                        </li>
                    </ul>
                </li>
                <li class="<c:if test='${activeMenu eq "statistics"}'>active</c:if>">
                    <a href="${pageContext.request.contextPath}/clubStatistics?clubId=${club.clubId}"
                       class="ttr-material-button">
                        <span class="ttr-icon"><i class="ti-bar-chart"></i></span>
                        <span class="ttr-label">Thống kê</span>
                    </a>
                </li>
                <li class="ttr-seperate"></li>
            </ul>
        </nav>
    </div>
</div>

