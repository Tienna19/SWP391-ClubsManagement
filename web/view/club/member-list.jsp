<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách thành viên - ${club.clubName}</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" type="image/x-icon" />
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/assets.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/typography.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/shortcodes.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">
    <style>
        .page-title {
            font-weight: 700;
            color: #2b2350;
        }
        .filter-toolbar {
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 12px 32px rgba(31, 43, 90, 0.08);
            padding: 18px;
            margin-bottom: 24px;
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            align-items: center;
        }
        .filter-toolbar .search-group {
            flex: 1 1 260px;
            position: relative;
        }
        .filter-toolbar .search-group input {
            width: 100%;
            border-radius: 14px;
            padding: 12px 44px 12px 16px;
            border: 1px solid #e3e6f0;
            background: #f8f9ff;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }
        .filter-toolbar .search-group input:focus {
            border-color: #5E35B1;
            box-shadow: 0 0 0 3px rgba(94, 53, 177, 0.18);
            background: #fff;
            outline: none;
        }
        .filter-toolbar .search-group i {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #5E35B1;
            font-size: 16px;
        }
        .filter-toolbar .form-select {
            border-radius: 14px;
            padding: 10px 36px 10px 14px;
            border: 1px solid #e3e6f0;
            background-position: right 14px center;
        }
        .member-table th {
            text-transform: uppercase;
            font-size: 12px;
            letter-spacing: 1px;
            background: #f1effd;
            color: #5E35B1;
            border: none;
        }
        .member-table td {
            vertical-align: middle;
            border-color: #f1f1fa;
        }
        .member-avatar {
            width: 46px;
            height: 46px;
            border-radius: 12px;
            object-fit: cover;
            background: #f1f1f9;
        }
        .role-chip {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            border-radius: 999px;
            padding: 6px 14px;
            font-weight: 600;
            font-size: 12px;
        }
        .role-chip.leader {
            background: rgba(94, 53, 177, 0.12);
            color: #4527A0;
        }
        .role-chip.member {
            background: rgba(0, 188, 212, 0.12);
            color: #007C91;
        }
        .summary-card {
            border-radius: 24px;
            padding: 24px;
            background: linear-gradient(135deg, rgba(94,53,177,0.12), rgba(63,81,181,0.05));
            border: 1px solid rgba(94,53,177,0.15);
            height: 100%;
        }
        .summary-card .number {
            font-size: 36px;
            font-weight: 700;
            color: #2b2350;
            line-height: 1;
        }
        .tag-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 11px;
            background: rgba(33, 150, 243, 0.12);
            color: #1a73e8;
        }
        .table-responsive {
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 18px 34px rgba(31, 43, 90, 0.08);
        }
        .empty-state {
            padding: 60px;
            text-align: center;
            background: #fff;
            border-radius: 24px;
            box-shadow: 0 18px 34px rgba(31, 43, 90, 0.08);
            color: #5E35B1;
        }
        .pagination button {
            border: none;
            border-radius: 12px;
            padding: 8px 14px;
            background: transparent;
            color: #5E35B1;
            font-weight: 600;
        }
        .pagination button.active {
            background: #5E35B1;
            color: #fff;
        }
        .pagination button:disabled {
            opacity: 0.4;
        }
        @media (max-width: 991px) {
            .filter-toolbar {
                padding: 14px;
            }
        }
    </style>
</head>
<body class="ttr-opened-sidebar ttr-pinned-sidebar">

<jsp:include page="partials/leader-header.jsp"/>
<jsp:include page="partials/leader-sidebar.jsp"/>

<main class="ttr-wrapper">
    <div class="container-fluid">
        <div class="db-breadcrumb">
            <h4 class="breadcrumb-title page-title">Thành viên CLB</h4>
            <ul class="db-breadcrumb-list">
                <li><a href="${pageContext.request.contextPath}/clubDashboard?clubId=${clubId}"><i class="fa fa-home"></i>Dashboard</a></li>
                <li>Thành viên</li>
            </ul>
        </div>

        <div class="row g-4 m-b30">
            <div class="col-lg-4 col-md-6">
                <div class="summary-card">
                    <span class="tag-pill"><i class="fa fa-users"></i> Tổng thành viên</span>
                    <div class="number mt-3">${totalMembers}</div>
                    <p class="mb-0 text-muted">Bao gồm Leader và Members đang hoạt động.</p>
                </div>
            </div>
            <div class="col-lg-4 col-md-6">
                <div class="summary-card">
                    <span class="tag-pill" style="background:rgba(0,200,83,0.14);color:#007e33;"><i class="fa fa-check-circle"></i> Leader</span>
                    <div class="number mt-3">
                        <c:set var="leaderCount" value="0"/>
                        <c:forEach items="${members}" var="m">
                            <c:if test="${m.roleInClub eq 'Leader'}">
                                <c:set var="leaderCount" value="${leaderCount + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${leaderCount}
                    </div>
                    <p class="mb-0 text-muted">Số lượng Leader hiện tại của CLB.</p>
                </div>
            </div>
            <div class="col-lg-4 col-md-6">
                <div class="summary-card">
                    <span class="tag-pill" style="background:rgba(255,171,0,0.14);color:#ff6f00;"><i class="fa fa-hourglass-half"></i> Yêu cầu chờ duyệt</span>
                    <div class="number mt-3">${pendingRequests}</div>
                    <p class="mb-0 text-muted">Truy cập mục "Phê duyệt thành viên" để xử lý.</p>
                </div>
            </div>
        </div>

        <div class="filter-toolbar">
            <div class="search-group">
                <input type="text" id="searchInput" placeholder="Tìm kiếm theo tên, email, vai trò...">
                <i class="fa fa-search"></i>
            </div>
            <select id="roleFilter" class="form-select" aria-label="Lọc theo vai trò">
                <option value="all">Tất cả vai trò</option>
                <option value="Leader">Leader</option>
                <option value="Member">Member</option>
            </select>
            <select id="sortSelect" class="form-select" aria-label="Sắp xếp">
                <option value="join_desc">Mới tham gia trước</option>
                <option value="join_asc">Tham gia lâu nhất</option>
                <option value="name_asc">Tên (A-Z)</option>
                <option value="name_desc">Tên (Z-A)</option>
            </select>
        </div>

        <c:choose>
            <c:when test="${empty members}">
                <div class="empty-state">
                    <i class="fa fa-users fa-3x mb-3"></i>
                    <h4 class="mb-2">Chưa có thành viên nào</h4>
                    <p class="mb-0">Bắt đầu mời các bạn sinh viên tham gia CLB hoặc duyệt các yêu cầu đang chờ.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table member-table mb-0" id="memberTable">
                        <thead>
                            <tr>
                                <th>Thành viên</th>
                                <th>Vai trò</th>
                                <th>Email</th>
                                <th>Ngày tham gia</th>
                                <th>ID</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${members}" var="member">
                                <c:set var="avatarSrc" value="${pageContext.request.contextPath}/assets/images/testimonials/pic1.jpg"/>
                                <c:if test="${not empty member.profileImage}">
                                    <c:choose>
                                        <c:when test="${fn:startsWith(member.profileImage, 'http')}">
                                            <c:set var="avatarSrc" value="${member.profileImage}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="avatarSrc" value="${pageContext.request.contextPath}/${member.profileImage}"/>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                                <tr data-role="${member.roleInClub}" data-search="${member.fullName} ${member.roleInClub} ${member.joinDateDisplay}">
                                    <td>
                                        <div class="d-flex align-items-center gap-3">
                                            <img class="member-avatar" src="${avatarSrc}" alt="${member.fullName}">
                                            <div>
                                                <div class="fw-semibold">${member.fullName}</div>
                                                <div class="text-muted small">User ID: ${member.userId}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="role-chip ${member.roleInClub eq 'Leader' ? 'leader' : 'member'}">
                                            <i class="fa ${member.roleInClub eq 'Leader' ? 'fa-crown' : 'fa-user'}"></i>
                                            ${member.roleInClub}
                                        </span>
                                    </td>
                                    <td class="text-muted">${member.email != null ? member.email : '—'}</td>
                                    <td>${member.joinDateDisplay}</td>
                                    <td>#${member.userId}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mt-4">
                    <div class="text-muted" id="rangeInfo"></div>
                    <div class="pagination" id="pagination"></div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>
<div class="ttr-overlay"></div>

<script src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/popper.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/functions.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin.js"></script>
<script>
(function(){
    const searchInput = document.getElementById('searchInput');
    const roleFilter = document.getElementById('roleFilter');
    const sortSelect = document.getElementById('sortSelect');
    const table = document.getElementById('memberTable');
    const tbody = table ? table.tBodies[0] : null;
    const paginationEl = document.getElementById('pagination');
    const rangeInfo = document.getElementById('rangeInfo');

    if (!tbody) return;

    const state = {
        page: 1,
        size: 10
    };

    function normalize(value) {
        return (value || '').toString().toLowerCase().trim();
    }

    function getRows() {
        return Array.from(tbody.rows);
    }

    function applyFilters() {
        const searchValue = normalize(searchInput.value);
        const roleValue = roleFilter.value;

        return getRows().filter(row => {
            const matchesSearch = !searchValue || normalize(row.dataset.search).includes(searchValue);
            const matchesRole = roleValue === 'all' || row.dataset.role === roleValue;
            return matchesSearch && matchesRole;
        });
    }

    function applySort(rows) {
        const value = sortSelect.value;
        const compare = {
            join_desc: (a, b) => b.rowIndex - a.rowIndex,
            join_asc: (a, b) => a.rowIndex - b.rowIndex,
            name_asc: (a, b) => a.cells[0].innerText.localeCompare(b.cells[0].innerText, 'vi'),
            name_desc: (a, b) => b.cells[0].innerText.localeCompare(a.cells[0].innerText, 'vi')
        }[value];
        return rows.sort(compare);
    }

    function renderPagination(total) {
        paginationEl.innerHTML = '';
        const totalPages = Math.max(1, Math.ceil(total / state.size));
        if (state.page > totalPages) state.page = totalPages;

        const prev = document.createElement('button');
        prev.textContent = 'Trước';
        prev.disabled = state.page === 1;
        prev.onclick = () => { state.page = Math.max(1, state.page - 1); update(); };
        paginationEl.appendChild(prev);

        for (let p = 1; p <= totalPages; p++) {
            const btn = document.createElement('button');
            btn.textContent = p;
            if (p === state.page) btn.classList.add('active');
            btn.onclick = () => { state.page = p; update(); };
            paginationEl.appendChild(btn);
        }

        const next = document.createElement('button');
        next.textContent = 'Tiếp';
        next.disabled = state.page >= totalPages;
        next.onclick = () => { state.page = Math.min(totalPages, state.page + 1); update(); };
        paginationEl.appendChild(next);
    }

    function update() {
        const filtered = applySort(applyFilters());
        getRows().forEach(row => row.style.display = 'none');

        const start = (state.page - 1) * state.size;
        const end = start + state.size;
        filtered.slice(start, end).forEach(row => row.style.display = '');

        renderPagination(filtered.length);

        if (rangeInfo) {
            const total = filtered.length;
            const from = total === 0 ? 0 : start + 1;
            const to = Math.min(end, total);
            rangeInfo.textContent = total === 0
                ? 'Không có thành viên phù hợp'
                : `Hiển thị ${from}-${to} trong tổng số ${total} thành viên`;
        }
    }

    searchInput.addEventListener('input', () => { state.page = 1; update(); });
    roleFilter.addEventListener('change', () => { state.page = 1; update(); });
    sortSelect.addEventListener('change', () => { state.page = 1; update(); });

    update();
})();
</script>
</body>
</html>

