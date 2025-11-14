<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="activeMenu" value="${empty requestScope.activeMenu ? '' : requestScope.activeMenu}" />
<c:set var="activeSubMenu" value="${empty requestScope.activeSubMenu ? '' : requestScope.activeSubMenu}" />
<c:set var="dashboardClass" value="" />
<c:set var="clubsClass" value="" />
<c:set var="eventsClass" value="" />
<c:set var="usersClass" value="" />
<c:set var="reportsClass" value="" />
<c:set var="settingsClass" value="" />
<c:if test="${activeMenu eq 'dashboard'}">
    <c:set var="dashboardClass" value="active open" />
</c:if>
<c:if test="${activeMenu eq 'clubs'}">
    <c:set var="clubsClass" value="open active" />
</c:if>
<c:if test="${activeMenu eq 'events'}">
    <c:set var="eventsClass" value="open active" />
</c:if>
<c:if test="${activeMenu eq 'users'}">
    <c:set var="usersClass" value="open active" />
</c:if>
<c:if test="${activeMenu eq 'reports'}">
    <c:set var="reportsClass" value="active open" />
</c:if>
<c:if test="${activeMenu eq 'settings'}">
    <c:set var="settingsClass" value="active open" />
</c:if>
<div class="ttr-sidebar">
    <div class="ttr-sidebar-wrapper content-scroll">
        <div class="ttr-sidebar-logo">
            <a href="${pageContext.request.contextPath}/home">
                <img alt="logo" src="${pageContext.request.contextPath}/assets/images/logo.png" width="122" height="27">
            </a>
            <div class="ttr-sidebar-toggle-button"><i class="ti-arrow-left"></i></div>
        </div>
        <nav class="ttr-sidebar-navi">
            <ul>
                <li class="${dashboardClass}">
                    <a href="${pageContext.request.contextPath}/adminDashboard" class="ttr-material-button">
                        <span class="ttr-icon"><i class="ti-home"></i></span>
                        <span class="ttr-label">Dashboard</span>
                    </a>
                </li>
                <li class="${clubsClass}">
                    <a href="${pageContext.request.contextPath}/admin-club-list" class="ttr-material-button">
                        <span class="ttr-icon"><i class="ti-briefcase"></i></span>
                        <span class="ttr-label">Quản lý CLB</span>
                        <span class="ttr-arrow-icon"><i class="fa fa-angle-down"></i></span>
                    </a>
                    <ul>
                        <c:set var="clubsListClass" value="" />
                        <c:set var="clubRequestsClass" value="" />
                        <c:if test="${activeSubMenu eq 'clubs-list'}">
                            <c:set var="clubsListClass" value="active" />
                        </c:if>
                        <c:if test="${activeSubMenu eq 'club-requests'}">
                            <c:set var="clubRequestsClass" value="active" />
                        </c:if>
                        <li class="${clubsListClass}">
                            <a href="${pageContext.request.contextPath}/admin-club-list" class="ttr-material-button">
                                <span class="ttr-label">Danh sách CLB</span>
                            </a>
                        </li>
                        <li class="${clubRequestsClass}">
                            <a href="${pageContext.request.contextPath}/viewClubRequests" class="ttr-material-button">
                                <span class="ttr-label">Yêu cầu tạo CLB</span>
                            </a>
                        </li>
                    </ul>
                </li>
                <li class="${eventsClass}">
                    <a href="#" class="ttr-material-button sidebar-toggle">
                        <span class="ttr-icon"><i class="ti-calendar"></i></span>
                        <span class="ttr-label">Quản lý sự kiện</span>
                        <span class="ttr-arrow-icon"><i class="fa fa-angle-down"></i></span>
                    </a>
                    <ul>
                        <c:set var="eventsListClass" value="" />
                        <c:set var="eventsCreateClass" value="" />
                        <c:if test="${activeSubMenu eq 'events-list'}">
                            <c:set var="eventsListClass" value="active" />
                        </c:if>
                        <c:if test="${activeSubMenu eq 'events-create'}">
                            <c:set var="eventsCreateClass" value="active" />
                        </c:if>
                        <li class="${eventsListClass}">
                            <a href="${pageContext.request.contextPath}/listEvents" class="ttr-material-button">
                                <span class="ttr-label">Danh sách sự kiện</span>
                            </a>
                        </li>
                        <li class="${eventsCreateClass}">
                            <a href="${pageContext.request.contextPath}/addNewEvent" class="ttr-material-button">
                                <span class="ttr-label">Tạo sự kiện mới</span>
                            </a>
                        </li>
                    </ul>
                </li>
                <li class="${usersClass}">
                    <a href="#" class="ttr-material-button sidebar-toggle">
                        <span class="ttr-icon"><i class="ti-user"></i></span>
                        <span class="ttr-label">Người dùng</span>
                        <span class="ttr-arrow-icon"><i class="fa fa-angle-down"></i></span>
                    </a>
                    <ul>
                        <c:set var="usersListClass" value="" />
                        <c:if test="${activeSubMenu eq 'users-list'}">
                            <c:set var="usersListClass" value="active" />
                        </c:if>
                        <li class="${usersListClass}">
                            <a href="${pageContext.request.contextPath}/adminUsers" class="ttr-material-button">
                                <span class="ttr-label">Danh sách người dùng</span>
                            </a>
                        </li>
                    </ul>
                </li>
                <li class="${reportsClass}">
                    <a href="${pageContext.request.contextPath}/systemReports" class="ttr-material-button">
                        <span class="ttr-icon"><i class="ti-bar-chart"></i></span>
                        <span class="ttr-label">Báo cáo</span>
                    </a>
                </li>
                <li class="${settingsClass}">
                    <a href="${pageContext.request.contextPath}/systemSettings" class="ttr-material-button">
                        <span class="ttr-icon"><i class="ti-settings"></i></span>
                        <span class="ttr-label">Cài đặt hệ thống</span>
                    </a>
                </li>
                <li class="ttr-seperate"></li>
            </ul>
        </nav>
    </div>
</div>
<script>
    (function() {
        var arrows = document.querySelectorAll('.ttr-sidebar-navi .ttr-arrow-icon');
        arrows.forEach(function(arrow) {
            arrow.addEventListener('click', function(event) {
                event.preventDefault();
                event.stopPropagation();
                var parentLi = this.closest('li');
                if (!parentLi) return;
                if (parentLi.classList.contains('open')) {
                    parentLi.classList.remove('open');
                    parentLi.classList.remove('active');
                } else {
                    parentLi.classList.add('open');
                    parentLi.classList.add('active');
                }
            });
        });
    })();
</script>
