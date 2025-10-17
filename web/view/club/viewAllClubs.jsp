<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách Câu Lạc Bộ</title>
    <!-- Favicon -->
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png">
    <link rel="shortcut icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png">
    <!-- Prevent browser extension conflicts -->
    <meta name="referrer" content="no-referrer">
    <meta name="robots" content="noindex, nofollow">
    
    <!-- Simple Error Suppression -->
    <script>
        // Suppress browser extension errors
        (function() {
            'use strict';
            
            const originalError = console.error;
            const originalWarn = console.warn;
            
            console.error = function() {
                const message = Array.prototype.join.call(arguments, ' ');
                if (message.includes('runtime.lastError') || 
                    message.includes('message port closed') ||
                    message.includes('extension')) {
                    return;
                }
                originalError.apply(console, arguments);
            };
            
            console.warn = function() {
                const message = Array.prototype.join.call(arguments, ' ');
                if (message.includes('runtime.lastError') || 
                    message.includes('message port closed') ||
                    message.includes('extension')) {
                    return;
                }
                originalWarn.apply(console, arguments);
            };
            
            window.addEventListener('error', function(e) {
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
    <style>
        body {
            font-family: 'Roboto', Arial, sans-serif;
            margin: 0;
            background: #f9f9fb;
            color: #333;
        }
        .container {
            max-width: 1200px;
            margin: 40px auto;
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 6px 16px rgba(0,0,0,0.08);
        }
        h2 {
            margin-bottom: 20px;
            color: #5E35B1;
            font-size: 24px;
        }

        /* Bộ lọc */
        .filter-bar {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-bottom: 25px;
        }
        .filter-bar select,
        .filter-bar input[type="text"] {
            padding: 8px 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            min-width: 180px;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .filter-bar select:focus,
        .filter-bar input:focus {
            border-color: #5E35B1;
            box-shadow: 0 0 0 2px rgba(94,53,177,0.2);
            outline: none;
        }
        .filter-bar button {
            background-color: #5E35B1;
            color: #fff;
            border: none;
            padding: 9px 18px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            transition: background-color 0.2s;
        }
        .filter-bar button:hover {
            background-color: #4527A0;
        }

        /* Bảng CLB */
        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 10px;
            border-radius: 8px;
            overflow: hidden;
        }
        th, td {
            padding: 12px 16px;
            text-align: left;
        }
        th {
            background: #5E35B1;
            color: white;
            font-weight: 600;
        }
        tr:nth-child(even) {
            background: #f8f6fc;
        }
        tr:hover {
            background: #ede7f6;
            transition: background 0.2s;
        }
        img {
            border-radius: 6px;
            max-height: 50px;
        }

        /* Button */
        a.button {
            display: inline-block;
            margin-top: 25px;
            padding: 10px 18px;
            background-color: #43a047;
            color: #fff;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 500;
            transition: background-color 0.2s;
        }
        a.button:hover {
            background-color: #2e7d32;
        }

        /* Action buttons */
        .action-buttons {
            display: flex;
            gap: 8px;
        }
        .action-buttons a {
            padding: 6px 12px;
            text-decoration: none;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.2s;
        }
        .action-buttons a.view {
            background-color: #2196F3;
            color: white;
        }
        .action-buttons a.view:hover {
            background-color: #1976D2;
        }
        .action-buttons a.join {
            background-color: #4CAF50;
            color: white;
        }
        .action-buttons a.join:hover {
            background-color: #388E3C;
        }

        /* Pagination */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-top: 30px;
            gap: 8px;
        }
        .pagination a, .pagination span {
            display: inline-block;
            padding: 8px 12px;
            text-decoration: none;
            border: 1px solid #ddd;
            border-radius: 6px;
            color: #333;
            font-weight: 500;
            transition: all 0.2s;
            min-width: 40px;
            text-align: center;
        }
        .pagination a:hover {
            background-color: #f5f5f5;
            border-color: #5E35B1;
        }
        .pagination .current {
            background-color: #5E35B1;
            color: white;
            border-color: #5E35B1;
        }
        .pagination .disabled {
            color: #ccc;
            cursor: not-allowed;
            background-color: #f9f9f9;
        }

        /* Status badges */
        .status-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
            text-transform: uppercase;
        }
        .status-badge.text-success {
            background-color: #d4edda;
            color: #155724;
        }
        .status-badge.text-warning {
            background-color: #fff3cd;
            color: #856404;
        }
        .status-badge.text-danger {
            background-color: #f8d7da;
            color: #721c24;
        }
        .status-badge.text-secondary {
            background-color: #e2e3e5;
            color: #383d41;
        }

        /* Statistics */
        .stats-container {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
            min-width: 120px;
            flex: 1;
        }
        .stat-card h3 {
            margin: 0;
            font-size: 24px;
            font-weight: bold;
        }
        .stat-card p {
            margin: 5px 0 0 0;
            font-size: 14px;
            opacity: 0.9;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .filter-bar {
                flex-direction: column;
                align-items: stretch;
            }
            table, th, td {
                font-size: 14px;
            }
            .stats-container {
                flex-direction: column;
            }
            .action-buttons {
                flex-direction: column;
                gap: 4px;
            }
        }
    </style>
</head>
<body>

    <!-- ✅ Include header -->
    <jsp:include page="../layout/header.jsp" />

    <div class="container">
        <h2>📋 Danh sách Câu Lạc Bộ</h2>

        <!-- 📊 Thống kê -->
        <div class="stats-container">
            <div class="stat-card">
                <h3>${totalClubs}</h3>
                <p>Tổng CLB</p>
            </div>
            <div class="stat-card">
                <h3>${activeClubs}</h3>
                <p>CLB Hoạt động</p>
            </div>
            <div class="stat-card">
                <h3>${inactiveClubs}</h3>
                <p>Không hoạt động</p>
            </div>
        </div>

        <!-- 🔍 Bộ lọc -->
        <form method="get" action="<c:url value='/viewAllClubs'/>" class="filter-bar">
            <!-- Lọc theo Category -->
            <select name="category">
                <option value="">Tất cả Category</option>
                <c:forEach var="cat" items="${categories}">
                    <option value="${cat.id}" <c:if test="${param.category eq cat.id}">selected</c:if>>
                        ${cat.name}
                    </option>
                </c:forEach>
            </select>

            <!-- Lọc theo Status -->
            <select name="status">
                <option value="">-- Tất cả Trạng thái --</option>
                <option value="Active" <c:if test="${param.status eq 'Active'}">selected</c:if>>Active</option>
                <option value="Inactive" <c:if test="${param.status eq 'Inactive'}">selected</c:if>>Inactive</option>
                <option value="Rejected" <c:if test="${param.status eq 'Rejected'}">selected</c:if>>Rejected</option>
            </select>

            <!-- Ô tìm kiếm -->
            <input type="text" name="search" placeholder="Tìm kiếm theo tên CLB..."
                   value="${param.search != null ? param.search : ''}"/>

            <button type="submit">Lọc</button>
        </form>

        <!-- 📋 Danh sách CLB -->
        <table>
            <tr>
                <th>
                    <a href="?sort=id&order=${param.order == 'asc' ? 'desc' : 'asc'}&category=${param.category}&status=${param.status}&search=${param.search}" 
                       style="text-decoration: none; color: inherit;">
                        ID 
                        <c:choose>
                            <c:when test="${param.sort == 'id' && param.order == 'asc'}">↑</c:when>
                            <c:when test="${param.sort == 'id' && param.order == 'desc'}">↓</c:when>
                            <c:otherwise>↕</c:otherwise>
                        </c:choose>
                    </a>
                </th>
                <th>Logo</th>
                <th>Tên CLB</th>
                <th>Thể loại</th>
                <th>Trạng thái</th>
                <th>Ngày tạo</th>
                <th>Actions</th>
            </tr>

            <c:choose>
                <c:when test="${not empty clubs}">
                    <c:forEach var="c" items="${clubs}">
                        <tr>
                            <td>${c.clubId}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty c.logo}">
                                        <img src="${pageContext.request.contextPath}/${c.logo}" 
                                             alt="Logo ${c.clubName}" 
                                             style="max-width: 50px; max-height: 50px; border-radius: 6px;"
                                             onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                        <div style="width: 50px; height: 50px; background: #f0f0f0; border-radius: 6px; display: none; align-items: center; justify-content: center; color: #999;">
                                            <i class="fas fa-image"></i>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div style="width: 50px; height: 50px; background: #f0f0f0; border-radius: 6px; display: flex; align-items: center; justify-content: center; color: #999;">
                                            <i class="fas fa-image"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <strong>${c.clubName != null ? c.clubName : 'N/A'}</strong>
                                <c:if test="${not empty c.description}">
                                    <br><small style="color: #666;">
                                        <c:choose>
                                            <c:when test="${c.description.length() > 50}">
                                                ${c.description.substring(0, 47)}...
                                            </c:when>
                                            <c:otherwise>
                                                ${c.description}
                                            </c:otherwise>
                                        </c:choose>
                                    </small>
                                </c:if>
                            </td>
                            <td>${c.clubTypes != null ? c.clubTypes : 'N/A'}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${c.status == 'Active'}">
                                        <span class="status-badge text-success">Active</span>
                                    </c:when>
                                    <c:when test="${c.status == 'Inactive'}">
                                        <span class="status-badge text-danger">Inactive</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge text-secondary">${c.status != null ? c.status : 'Unknown'}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${c.createdAt != null}">
                                        <fmt:formatDate value="${c.createdAt}" pattern="MMM dd, yyyy"/>
                                    </c:when>
                                    <c:otherwise>
                                        Unknown
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="action-buttons">
                                    <a href="<c:url value='/viewClub'><c:param name='id' value='${c.clubId}'/></c:url>" class="view">View</a>
                                    <c:if test="${c.status != null && c.status == 'Active'}">
                                        <a href="<c:url value='/joinClub'><c:param name='id' value='${c.clubId}'/></c:url>" class="join">Join</a>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="7" style="text-align:center; color:#999; font-style:italic; padding: 40px;">
                            <i class="fas fa-club" style="font-size: 48px; margin-bottom: 16px; display: block;"></i>
                            Không có CLB nào được tìm thấy.
                            <br><small>Thử thay đổi bộ lọc hoặc tạo CLB mới.</small>
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </table>

        <!-- Phân trang -->
        <c:if test="${totalPages > 1}">
            <div class="pagination">
                <!-- Nút Previous -->
                <c:choose>
                    <c:when test="${currentPage > 1}">
                        <a href="<c:url value='/viewAllClubs'>
                            <c:param name='page' value='${currentPage - 1}'/>
                            <c:param name='category' value='${param.category}'/>
                            <c:param name='status' value='${param.status}'/>
                            <c:param name='search' value='${param.search}'/>
                        </c:url>">&laquo; Trước</a>
                    </c:when>
                    <c:otherwise>
                        <span class="disabled">&laquo; Trước</span>
                    </c:otherwise>
                </c:choose>

                <!-- Các số trang -->
                <c:set var="startPage" value="${currentPage - 2}"/>
                <c:set var="endPage" value="${currentPage + 2}"/>
                
                <c:if test="${startPage < 1}">
                    <c:set var="startPage" value="1"/>
                </c:if>
                
                <c:if test="${endPage > totalPages}">
                    <c:set var="endPage" value="${totalPages}"/>
                </c:if>

                <c:forEach begin="${startPage}" end="${endPage}" var="pageNum">
                    <c:choose>
                        <c:when test="${pageNum == currentPage}">
                            <span class="current">${pageNum}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="<c:url value='/viewAllClubs'>
                                <c:param name='page' value='${pageNum}'/>
                                <c:param name='category' value='${param.category}'/>
                                <c:param name='status' value='${param.status}'/>
                                <c:param name='search' value='${param.search}'/>
                            </c:url>">${pageNum}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>

                <!-- Nút Next -->
                <c:choose>
                    <c:when test="${currentPage < totalPages}">
                        <a href="<c:url value='/viewAllClubs'>
                            <c:param name='page' value='${currentPage + 1}'/>
                            <c:param name='category' value='${param.category}'/>
                            <c:param name='status' value='${param.status}'/>
                            <c:param name='search' value='${param.search}'/>
                        </c:url>">Sau &raquo;</a>
                    </c:when>
                    <c:otherwise>
                        <span class="disabled">Sau &raquo;</span>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- Thông tin phân trang -->
            <div style="text-align: center; margin-top: 10px; color: #666; font-size: 14px;">
                Trang ${currentPage} / ${totalPages} - Tổng ${totalClubs} CLB
            </div>
        </c:if>

        <a href="<c:url value='/createClub'/>" class="button">+ Tạo CLB mới</a>
    </div>

    <!-- ✅ Include footer -->
    <jsp:include page="../layout/footer.jsp" />

    <script>
        // Ultimate browser extension error suppression
        (function() {
            'use strict';
            
            // Store original methods
            const originalError = console.error;
            const originalWarn = console.warn;
            const originalLog = console.log;
            
            // Override console.error
            console.error = function() {
                const args = Array.prototype.slice.call(arguments);
                const message = args.join(' ');
                
                // Ignore ALL browser extension errors
                if (message.includes('message port closed') || 
                    message.includes('faviconV2') ||
                    message.includes('content.js') ||
                    message.includes('extension') ||
                    message.includes('Unchecked runtime.lastError') ||
                    message.includes('runtime.lastError') ||
                    message.includes('chrome-extension') ||
                    message.includes('moz-extension') ||
                    message.includes('safari-extension')) {
                    return;
                }
                
                originalError.apply(console, arguments);
            };
            
            // Override console.warn
            console.warn = function() {
                const args = Array.prototype.slice.call(arguments);
                const message = args.join(' ');
                
                // Ignore ALL browser extension warnings
                if (message.includes('message port closed') || 
                    message.includes('faviconV2') ||
                    message.includes('content.js') ||
                    message.includes('extension') ||
                    message.includes('Unchecked runtime.lastError') ||
                    message.includes('runtime.lastError') ||
                    message.includes('chrome-extension') ||
                    message.includes('moz-extension') ||
                    message.includes('safari-extension')) {
                    return;
                }
                
                originalWarn.apply(console, arguments);
            };
            
            // Override console.log
            console.log = function() {
                const args = Array.prototype.slice.call(arguments);
                const message = args.join(' ');
                
                // Ignore ALL browser extension logs
                if (message.includes('message port closed') || 
                    message.includes('faviconV2') ||
                    message.includes('content.js') ||
                    message.includes('extension') ||
                    message.includes('Unchecked runtime.lastError') ||
                    message.includes('runtime.lastError') ||
                    message.includes('chrome-extension') ||
                    message.includes('moz-extension') ||
                    message.includes('safari-extension')) {
                    return;
                }
                
                originalLog.apply(console, arguments);
            };
        })();

        // Auto-hide alerts after 5 seconds
        document.addEventListener('DOMContentLoaded', function() {
            try {
                const alerts = document.querySelectorAll('.alert');
                if (alerts && alerts.length > 0) {
                    alerts.forEach(function(alert) {
                        if (alert) {
                            setTimeout(function() {
                                if (alert && alert.style) {
                                    alert.style.opacity = '0';
                                    setTimeout(function() {
                                        if (alert && alert.style) {
                                            alert.style.display = 'none';
                                        }
                                    }, 300);
                                }
                            }, 5000);
                        }
                    });
                }
            } catch (e) {
                // Silently ignore errors
            }
        });

        // Form validation
        document.addEventListener('DOMContentLoaded', function() {
            try {
                const filterForm = document.querySelector('.filter-bar');
                if (filterForm) {
                    filterForm.addEventListener('submit', function(e) {
                        try {
                            // Clear any previous error states
                            const inputs = filterForm.querySelectorAll('input, select');
                            if (inputs && inputs.length > 0) {
                                inputs.forEach(input => {
                                    if (input && input.classList) {
                                        input.classList.remove('is-invalid');
                                    }
                                });
                            }
                        } catch (e) {
                            // Silently ignore errors
                        }
                    });
                }
            } catch (e) {
                // Silently ignore errors
            }
        });

        // Smooth scrolling for pagination
        document.addEventListener('DOMContentLoaded', function() {
            try {
                const paginationLinks = document.querySelectorAll('.pagination a');
                if (paginationLinks && paginationLinks.length > 0) {
                    paginationLinks.forEach(link => {
                        if (link) {
                            link.addEventListener('click', function(e) {
                                try {
                                    // Add loading state
                                    if (this && this.style) {
                                        this.style.opacity = '0.6';
                                        this.style.pointerEvents = 'none';
                                    }
                                } catch (e) {
                                    // Silently ignore errors
                                }
                            });
                        }
                    });
                }
            } catch (e) {
                // Silently ignore errors
            }
        });

        // Ultimate global error handlers
        window.addEventListener('error', function(e) {
            if (e.message && (
                e.message.includes('message port closed') ||
                e.message.includes('faviconV2') ||
                e.message.includes('content.js') ||
                e.message.includes('extension') ||
                e.message.includes('Unchecked runtime.lastError') ||
                e.message.includes('runtime.lastError') ||
                e.message.includes('chrome-extension') ||
                e.message.includes('moz-extension') ||
                e.message.includes('safari-extension')
            )) {
                e.preventDefault();
                e.stopPropagation();
                e.stopImmediatePropagation();
                return false;
            }
        }, true);

        // Prevent unhandled promise rejections from extensions
        window.addEventListener('unhandledrejection', function(e) {
            if (e.reason && (
                e.reason.toString().includes('message port closed') ||
                e.reason.toString().includes('faviconV2') ||
                e.reason.toString().includes('content.js') ||
                e.reason.toString().includes('extension') ||
                e.reason.toString().includes('Unchecked runtime.lastError') ||
                e.reason.toString().includes('runtime.lastError') ||
                e.reason.toString().includes('chrome-extension') ||
                e.reason.toString().includes('moz-extension') ||
                e.reason.toString().includes('safari-extension')
            )) {
                e.preventDefault();
                e.stopPropagation();
                e.stopImmediatePropagation();
                return false;
            }
        }, true);

        // Override window.onerror
        window.onerror = function(message, source, lineno, colno, error) {
            if (message && (
                message.includes('message port closed') ||
                message.includes('faviconV2') ||
                message.includes('content.js') ||
                message.includes('extension') ||
                message.includes('Unchecked runtime.lastError') ||
                message.includes('runtime.lastError') ||
                message.includes('chrome-extension') ||
                message.includes('moz-extension') ||
                message.includes('safari-extension')
            )) {
                return true; // Prevent default error handling
            }
            return false; // Let other errors through
        };

        // Override window.onunhandledrejection
        window.onunhandledrejection = function(event) {
            if (event.reason && (
                event.reason.toString().includes('message port closed') ||
                event.reason.toString().includes('faviconV2') ||
                event.reason.toString().includes('content.js') ||
                event.reason.toString().includes('extension') ||
                event.reason.toString().includes('Unchecked runtime.lastError') ||
                event.reason.toString().includes('runtime.lastError') ||
                event.reason.toString().includes('chrome-extension') ||
                event.reason.toString().includes('moz-extension') ||
                event.reason.toString().includes('safari-extension')
            )) {
                event.preventDefault();
                return true;
            }
            return false;
        };
    </script>

</body>
</html>
