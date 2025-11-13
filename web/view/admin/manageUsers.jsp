<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Quản lý người dùng - Admin</title>

    <!-- CSS giống các trang admin khác -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/assets.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/typography.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/shortcodes.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">

    <style>
        .user-card {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 8px 20px rgba(94,53,177,0.08);
            padding: 16px 20px;
            margin-bottom: 16px;
        }
        .badge-role {
            border-radius: 999px;
            padding: 4px 10px;
            font-size: 11px;
            font-weight: 600;
        }
        .badge-role.user   { background:#e3f2fd; color:#1565c0; }
        .badge-role.member { background:#e8f5e9; color:#2e7d32; }
        .badge-role.leader { background:#fff8e1; color:#f9a825; }
        .badge-role.admin  { background:#fce4ec; color:#c2185b; }
    </style>
</head>

<body class="ttr-opened-sidebar ttr-pinned-sidebar admin-theme-loaded">

    <%@ include file="/WEB-INF/jspf/admin-layout.jspf" %>

    <main class="ttr-wrapper">
        <div class="container-fluid">
            <!-- Breadcrumb -->
            <div class="db-breadcrumb">
                <h4 class="breadcrumb-title">Danh sách người dùng</h4>
                <ul class="db-breadcrumb-list">
                    <li><a href="${pageContext.request.contextPath}/adminDashboard"><i class="fa fa-home"></i>Dashboard</a></li>
                    <li>Người dùng</li>
                    <li>Quản lý người dùng</li>
                </ul>
            </div>

            <!-- Thông báo -->
            <c:if test="${not empty message}">
                <div class="alert alert-${empty messageType ? 'info' : messageType} alert-dismissible fade show" role="alert">
                    ${message}
                    <button type="button" class="close" data-dismiss="alert">
                        <span>&times;</span>
                    </button>
                </div>
            </c:if>

            <!-- Thanh search + nút thêm -->
            <div class="card m-b30 shadow-sm">
                <div class="card-body">
                    <form class="row g-3 align-items-end"
                          method="get"
                          action="${pageContext.request.contextPath}/ManageUsersServlet">
                        <div class="col-md-6">
                            <label class="form-label">Tìm kiếm</label>
                            <input type="text"
                                   name="keyword"
                                   class="form-control"
                                   value="${keyword}"
                                   placeholder="Nhập tên hoặc email người dùng">
                        </div>
                        <div class="col-md-3 text-md-end mt-3 mt-md-0">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="fa fa-search mr-1"></i> Lọc kết quả
                            </button>
                        </div>
                        <div class="col-md-3 text-md-end mt-3 mt-md-0">
                            <button type="button"
                                    class="btn btn-success w-100"
                                    onclick="openModalCreate()">
                                <i class="fa fa-user-plus mr-1"></i> Tạo người dùng mới
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Bảng danh sách -->
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0"><i class="fa fa-users mr-2"></i>Danh sách người dùng</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="thead-light">
                            <tr>
                                <th>ID</th>
                                <th>Họ tên</th>
                                <th>Email</th>
                                <th>Điện thoại</th>
                                <th>Địa chỉ</th>
                                <th>Giới tính</th>
                                <th>Status</th>
                                <th>Vai trò</th>                            
                                <th class="text-right">Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${empty users}">
                                    <tr>
                                        <td colspan="8" class="text-center py-4 text-muted">
                                            Không có người dùng nào.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="u" items="${users}">
                                        <tr>
                                            <td>${u.userID}</td>
                                            <td>${u.fullName}</td>
                                            <td>${u.email}</td>
                                            <td>${u.phoneNumber}</td>
                                            <td>${u.address}</td>
                                            <td>${u.gender}</td>
                                            <td>${u.status}</td>
                                            <td>
                                                <c:set var="roleClass"
                                                       value="${u.roleID == 1 ? 'user'
                                                                : u.roleID == 2 ? 'member'
                                                                : u.roleID == 3 ? 'leader'
                                                                : 'admin'}"/>
                                                <span class="badge-role ${roleClass}">
                                                    <c:choose>
                                                        <c:when test="${u.roleID == 1}">User</c:when>
                                                        <c:when test="${u.roleID == 2}">Member</c:when>
                                                        <c:when test="${u.roleID == 3}">Club Leader</c:when>
                                                        <c:when test="${u.roleID == 4}">Admin</c:when>
                                                        <c:otherwise>Unknown</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>
                                            <td class="text-right">
                                                <button type="button"
                                                        class="btn btn-sm btn-outline-primary"
                                                        onclick="openModalEdit(
                                                                '${u.userID}',
                                                                '${fn:escapeXml(u.fullName)}',
                                                                '${fn:escapeXml(u.email)}',
                                                                '${fn:escapeXml(u.phoneNumber)}',
                                                                '${fn:escapeXml(u.address)}',
                                                                '${fn:escapeXml(u.gender)}',
                                                                '${u.roleID}')">
                                                    <i class="fa fa-pencil"></i> Sửa
                                                </button>
                                                <form action="${pageContext.request.contextPath}/ManageUsersServlet"
                                                      method="post"
                                                      class="d-inline"
                                                      onsubmit="return confirmDeactivate();">
                                                    <input type="hidden" name="action" value="deactivate">
                                                    <input type="hidden" name="userId" value="${u.userID}">
                                                    <button class="btn btn-sm btn-outline-danger">
                                                        <i class="fa fa-ban"></i> Vô hiệu hóa
                                                    </button>
                                                </form>
                                                    
                                                    <c:if test="${u.status == 'Inactive'}">
    <form method="post" action="${ctx}/ManageUsersServlet" class="d-inline">
        <input type="hidden" name="action" value="activate">
        <input type="hidden" name="userId" value="${u.userID}">
        <button class="btn btn-sm btn-outline-success">
            <i class="fa fa-check"></i> Kích hoạt
        </button>
    </form>
</c:if>

                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Phân trang -->
                <c:if test="${totalPages > 1}">
                    <div class="card-footer">
                        <nav>
                            <ul class="pagination justify-content-end mb-0">
                                <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link"
                                           href="${pageContext.request.contextPath}/ManageUsersServlet?page=${currentPage - 1}&keyword=${keyword}">
                                            Trước
                                        </a>
                                    </li>
                                </c:if>
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link"
                                           href="${pageContext.request.contextPath}/admin/user-management?page=${i}&keyword=${keyword}">
                                            ${i}
                                        </a>
                                    </li>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link"
                                           href="${pageContext.request.contextPath}/ManageUsersServlet?page=${currentPage + 1}&keyword=${keyword}">
                                            Sau
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
                    </div>
                </c:if>
            </div>
        </div>
    </main>

    <!-- Modal create / edit -->
    <div class="modal fade" id="userModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <form id="userForm"
                      action="${pageContext.request.contextPath}/ManageUsersServlet"
                      method="post"
                      enctype="multipart/form-data">
                    <div class="modal-header">
                        <h5 class="modal-title" id="userModalTitle">Tạo người dùng mới</h5>
                        <button type="button" class="close" data-dismiss="modal">
                            <span>&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="action" id="formAction" value="create">
                        <input type="hidden" name="userId" id="userId">

                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label>Họ tên</label>
                                <input type="text" name="fullName" id="fullName"
                                       class="form-control" required>
                            </div>
                            <div class="form-group col-md-6">
                                <label>Email</label>
                                <input type="email" name="email" id="email"
                                       class="form-control" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label>Điện thoại</label>
                                <input type="text" name="phone" id="phone"
                                       class="form-control">
                            </div>
                            <div class="form-group col-md-6">
                                <label>Địa chỉ</label>
                                <input type="text" name="address" id="address"
                                       class="form-control">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group col-md-4">
                                <label>Giới tính</label>
                                <select name="gender" id="gender" class="form-control">
                                    <option value="Nam">Nam</option>
                                    <option value="Nữ">Nữ</option>
                                    <option value="Khác">Khác</option>
                                </select>
                            </div>
                            <div class="form-group col-md-4">
                                <label>Vai trò</label>
                                <select name="role" id="role" class="form-control">
                                    <option value="1">User</option>
                                    <option value="2">Member</option>
                                    <option value="3">ClubLeader</option>
                                    <option value="4">Admin</option>
                                </select>
                            </div>
                            <div class="form-row">
    <div class="form-group col-md-6">
        <label>Mật khẩu</label>
        
        <input type="password" name="password" id="password"
               class="form-control">
        <small class="text-muted">
            Nếu để trống khi chỉnh sửa thì giữ nguyên mật khẩu cũ.
        </small>
    </div>

    <div class="form-group col-md-6">
        <label>Ảnh đại diện</label>
        <input type="file" name="profileImage" id="profileImage"
               class="form-control-file"
               accept="image/*">
        <small class="text-muted">
            Tùy chọn.
        </small>
    </div>
</div>

                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-primary">Lưu</button>
                        <button type="button" class="btn btn-secondary"
                                data-dismiss="modal">Hủy</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="ttr-overlay"></div>

    <script src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/popper.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap-select/bootstrap-select.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/scroll/scrollbar.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/functions.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/admin.js"></script>
    <script>
        function openModalCreate() {
            $('#userModalTitle').text('Tạo người dùng mới');
            $('#formAction').val('create');
            $('#userId').val('');
            $('#userForm')[0].reset();
            $('#userModal').modal('show');
        }

        function openModalEdit(id, name, email, phone, address, gender, role) {
            $('#userModalTitle').text('Cập nhật người dùng');
            $('#formAction').val('update');
            $('#userId').val(id);
            $('#fullName').val(name);
            $('#email').val(email);
            $('#phone').val(phone);
            $('#address').val(address);
            $('#gender').val(gender);
            $('#role').val(role);
            $('#password').val('');          // không bắt buộc nhập lại
            $('#profileImage').val('');      // clear file input
            $('#userModal').modal('show');
        }

        function confirmDeactivate() {
            return confirm('Bạn có chắc chắn muốn vô hiệu hóa người dùng này?');
        }

        (function () {
            function adjustSidebar() {
                if (window.innerWidth <= 1024) {
                    document.body.classList.remove('ttr-opened-sidebar');
                    document.body.classList.remove('ttr-pinned-sidebar');
                } else {
                    document.body.classList.add('ttr-opened-sidebar');
                    document.body.classList.add('ttr-pinned-sidebar');
                }
            }
            adjustSidebar();
            window.addEventListener('resize', adjustSidebar);
        })();
    </script>
</body>
</html>
