<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
    body {
        margin: 0;
        font-family: 'Roboto', sans-serif;
    }
    header {
        background-color: #5E35B1; /* Purple header */
        color: white;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 30px;
        height: 64px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    .header-left {
        display: flex;
        align-items: center;
    }
    .logo {
        display: flex;
        align-items: center;
        text-decoration: none;
        color: white;
    }
    .logo-icon {
        font-size: 24px;
        margin-right: 10px;
    }
    .logo-text {
        display: flex;
        flex-direction: column;
        line-height: 1.2;
    }
    .logo-text strong {
        font-size: 18px;
    }
    .logo-text span {
        font-size: 12px;
        opacity: 0.8;
    }
    nav ul {
        list-style: none;
        display: flex;
        margin: 0;
        padding: 0;
    }
    nav ul li {
        margin-left: 30px;
        position: relative;
    }
    nav ul li a {
        color: white;
        text-decoration: none;
        font-weight: 500;
        display: flex;
        align-items: center;
        transition: opacity 0.2s;
    }
    nav ul li a:hover {
        opacity: 0.8;
    }
    .submenu {
        position: absolute;
        top: 50px;
        left: 0;
        background-color: white;
        color: #333;
        min-width: 150px;
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
    .avatar {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        object-fit: cover;
    }
</style>

<header>
    <div class="header-left">
        <a href="${pageContext.request.contextPath}/home" class="logo">
            <div class="logo-icon">?</div>
            <div class="logo-text">
                <strong>Student Club</strong>
                <span>Management System</span>
            </div>
        </a>
        <nav>
            <ul>
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
                <a href="profile"><img src="${account.profileImage}" class="avatar" alt="User"></a>
                Xin chào, <strong>${account.fullName}</strong> 
                <a href="#" 
                   onclick="if (confirm('Bạn có chắc chắn muốn đăng xuất không?')) {
               window.location.href = 'logout';
           }
           return false;">
                    <i class="fa fa-sign-out"></i> Đăng xuất
                </a>
            </c:when>
            <c:otherwise>
                <a href="login">Đăng nhập</a>
                <a href="register">Đăng kí</a>
            </c:otherwise>
        </c:choose>
    </div>
</header>
