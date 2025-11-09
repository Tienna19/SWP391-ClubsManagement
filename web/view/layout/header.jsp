<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Favicon -->
<link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png">
<link rel="shortcut icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png">

<!-- Simple Error Suppression -->
<script>
    // Suppress browser extension errors globally
    (function () {
        'use strict';

        const originalError = console.error;
        const originalWarn = console.warn;

        console.error = function () {
            const message = Array.prototype.join.call(arguments, ' ');
            if (message.includes('runtime.lastError') ||
                    message.includes('message port closed') ||
                    message.includes('extension')) {
                return;
            }
            originalError.apply(console, arguments);
        };

        console.warn = function () {
            const message = Array.prototype.join.call(arguments, ' ');
            if (message.includes('runtime.lastError') ||
                    message.includes('message port closed') ||
                    message.includes('extension')) {
                return;
            }
            originalWarn.apply(console, arguments);
        };

        window.addEventListener('error', function (e) {
            if (e.message && (
                    e.message.includes('runtime.lastError') ||
                    e.message.includes('message port closed')
                    )) {
                e.preventDefault();
                return false;
            }
        }, true);

    })();
</script>

<!-- Header Styles -->
<style>
    @import url('https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=Poppins:wght@400;500;600;700&display=swap');

    body {
        margin: 0;
        font-family: 'Be Vietnam Pro', 'Poppins', 'Segoe UI', sans-serif;
    }
    header {
        background: linear-gradient(90deg, #5E35B1 0%, #512DA8 50%, #4527A0 100%);
        color: white;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 32px;
        height: 70px;
        box-shadow: 0 8px 20px rgba(40, 16, 72, 0.25);
    }
    .header-left {
        display: flex;
        align-items: center;
        gap: 28px;
    }
    .menu-toggle {
        background: rgba(255,255,255,0.08);
        border: 1px solid rgba(255,255,255,0.3);
        color: white;
        width: 44px;
        height: 44px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        transition: background 0.2s, transform 0.2s;
    }
    .menu-toggle:hover {
        background: rgba(255,255,255,0.15);
        transform: translateY(-1px);
    }
    .logo {
        display: flex;
        align-items: center;
        text-decoration: none;
        color: white;
        gap: 12px;
    }
    .logo-icon {
        width: 44px;
        height: 44px;
        border-radius: 14px;
        background: rgba(255,255,255,0.12);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 22px;
    }
    .logo-text {
        display: flex;
        flex-direction: column;
        line-height: 1.2;
    }
    .logo-text strong {
        font-size: 18px;
        font-weight: 700;
        letter-spacing: 0.3px;
    }
    .logo-text span {
        font-size: 12px;
        opacity: 0.8;
        font-weight: 500;
    }
    nav ul {
        list-style: none;
        display: flex;
        margin: 0;
        padding: 0;
    }
    nav ul li {
        margin-left: 36px;
        position: relative;
    }
    nav ul li a {
        color: white;
        text-decoration: none;
        font-weight: 600;
        font-size: 15px;
        letter-spacing: 0.6px;
        display: flex;
        align-items: center;
        transition: opacity 0.2s;
    }
    nav ul li a:hover {
        opacity: 0.7;
    }
    .submenu {
        position: absolute;
        top: 58px;
        left: 0;
        background-color: white;
        color: #333;
        min-width: 180px;
        box-shadow: 0 2px 6px rgba(0,0,0,0.15);
        display: none;
        border-radius: 4px;
        z-index: 999;
    }
    .submenu ul {
        list-style: none;
        margin: 0;
        padding: 8px 0;
    }
    .submenu ul li {
        padding: 8px 16px;
    }
    .submenu ul li a {
        color: #333;
        text-decoration: none;
        display: block;
    }
    nav ul li:hover .submenu {
        display: block;
    }
    .header-right {
        display: flex;
        align-items: center;
        gap: 20px;
    }
    .header-right a {
        color: white;
        text-decoration: none;
        font-size: 18px;
    }
    .auth-links {
        display: flex;
        align-items: center;
        gap: 12px;
    }
    .auth-links a {
        border: 1px solid rgba(255,255,255,0.7);
        border-radius: 20px;
        padding: 6px 16px;
        font-size: 15px;
        transition: background 0.2s, color 0.2s;
    }
    .auth-links a:hover {
        background: white;
        color: #5E35B1;
    }
    .profile-info {
        display: flex;
        align-items: center;
        gap: 10px;
    }
    .profile-info span {
        font-size: 15px;
    }
    .avatar {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        object-fit: cover;
    }
</style>

<header>
    <div class="header-left">
        <button type="button" class="menu-toggle" onclick="if (typeof window.toggleSidebar === 'function') { window.toggleSidebar(); } else { document.body.classList.toggle('sidebar-open'); }">
            <i class="fa fa-bars"></i>
        </button>
        <a href="${pageContext.request.contextPath}/home" class="logo">
            <div class="logo-icon">
                <i class="fa fa-graduation-cap"></i>
            </div>
            <div class="logo-text">
                <strong>EduChamp</strong>
                <span>Education & Courses</span>
            </div>
        </a>
        <nav>
            <ul>
                <li><a href="${pageContext.request.contextPath}/home">TRANG CHỦ</a></li>
                <li class="has-dropdown">
                    <a href="#">MENU NHANH <i class="fa fa-angle-down" style="margin-left:6px;"></i></a>
                    <div class="submenu">
                        <ul>
                            <li><a href="${pageContext.request.contextPath}/viewAllClubs">Các CLB</a></li>
                            <li><a href="${pageContext.request.contextPath}/viewAllEvents">Sự kiện</a></li>
                            <li><a href="${pageContext.request.contextPath}/clubDetails">Chi tiết CLB</a></li>
                <li><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                <li>
                    <a href="#">CLUBS <i class="fa fa-angle-down" style="margin-left:4px;"></i></a>
                    <div class="submenu">
                        <ul>
                            <li><a href="${pageContext.request.contextPath}/viewAllClubs">Tất cả Câu lạc bộ</a></li>
                            <li><a href="${pageContext.request.contextPath}/myClubs">Câu lạc bộ của tôi</a></li>
                            <li><a href="${pageContext.request.contextPath}/createClub">Tạo Câu lạc bộ</a></li>
                        </ul>
                    </div>
                </li>
                <li>
                    <a href="#">EVENTS <i class="fa fa-angle-down" style="margin-left:4px;"></i></a>
                    <div class="submenu">
                        <ul>
                            <li><a href="${pageContext.request.contextPath}/viewAllEvents">Tất cả Sự kiện</a></li>
                            <li><a href="${pageContext.request.contextPath}/addNewEvent">Thêm sự kiện</a></li>
                            <li><a href="${pageContext.request.contextPath}/myEvents">Sự kiện của tôi</a></li>
                        </ul>
                    </div>
                </li>
            </ul>
        </nav>
    </div>

    <div class="header-right">
        <a href="#"><i class="fa fa-search"></i></a>
        <a href="#"><i class="fa fa-bell"></i></a>
        <c:choose>
            <c:when test="${not empty account}">
                <div class="profile-info">
                    <a href="${pageContext.request.contextPath}/profile">
                        <img src="${account.profileImage}" class="avatar" alt="User">
                    </a>
                    <span>Hi, <strong>${account.fullName}</strong></span>
                    <a href="#"
                       onclick="if (confirm('Bạn có chắc chắn muốn đăng xuất không?')) { window.location.href = '${pageContext.request.contextPath}/logout'; } return false;">
                        <i class="fa fa-sign-out"></i> Logout
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="auth-links">
                    <a href="${pageContext.request.contextPath}/login">Login</a>
                    <a href="${pageContext.request.contextPath}/register">Register</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</header>
