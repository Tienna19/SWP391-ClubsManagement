<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<header class="ttr-header">
    <div class="ttr-header-wrapper">
        <div class="ttr-toggle-sidebar ttr-material-button">
            <i class="ti-close ttr-open-icon"></i>
            <i class="ti-menu ttr-close-icon"></i>
        </div>
        <div class="ttr-logo-box">
            <div>
                <a href="${pageContext.request.contextPath}/home" class="ttr-logo">
                    <img class="ttr-logo-mobile" alt="" src="${pageContext.request.contextPath}/assets/images/logo-mobile.png" width="30" height="30">
                    <img class="ttr-logo-desktop" alt="" src="${pageContext.request.contextPath}/assets/images/logo-white.png" width="160" height="27">
                </a>
            </div>
        </div>
        <div class="ttr-header-menu">
            <ul class="ttr-header-navigation">
                <li>
                    <a href="${pageContext.request.contextPath}/home" class="ttr-material-button ttr-submenu-toggle">TRANG CHỦ</a>
                </li>
                <li>
                    <a href="#" class="ttr-material-button ttr-submenu-toggle">MENU NHANH <i class="fa fa-angle-down"></i></a>
                    <div class="ttr-header-submenu">
                        <ul>
                            <li><a href="${pageContext.request.contextPath}/viewAllClubs">Các CLB</a></li>
                            <li><a href="${pageContext.request.contextPath}/listEvents">Sự kiện</a></li>
                            <li><a href="${pageContext.request.contextPath}/clubDetail?clubId=${club.clubId}">Chi tiết CLB</a></li>
                        </ul>
                    </div>
                </li>
            </ul>
        </div>
        <div class="ttr-header-right ttr-with-seperator">
            <ul class="ttr-header-navigation">
                <li>
                    <a href="#" class="ttr-material-button ttr-search-toggle"><i class="fa fa-search"></i></a>
                </li>
                <li>
                    <a href="#" class="ttr-material-button ttr-submenu-toggle">
                        <span class="ttr-user-avatar">
                            <img alt="" src="${pageContext.request.contextPath}/assets/images/testimonials/pic3.jpg" width="32" height="32">
                        </span>
                    </a>
                    <div class="ttr-header-submenu">
                        <ul>
                            <li><a href="${pageContext.request.contextPath}/profile">Hồ sơ của tôi</a></li>
                            <li><a href="${pageContext.request.contextPath}/clubDetail?clubId=${club.clubId}">Chi tiết CLB</a></li>
                            <li><a href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                        </ul>
                    </div>
                </li>
            </ul>
        </div>
        <div class="ttr-search-bar">
            <form class="ttr-search-form">
                <div class="ttr-search-input-wrapper">
                    <input type="text" name="qq" placeholder="Tìm kiếm..." class="ttr-search-input">
                    <button type="submit" name="search" class="ttr-search-submit"><i class="ti-arrow-right"></i></button>
                </div>
                <span class="ttr-search-close ttr-search-toggle">
                    <i class="ti-close"></i>
                </span>
            </form>
        </div>
    </div>
</header>

