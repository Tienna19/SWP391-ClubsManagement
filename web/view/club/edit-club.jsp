<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <!-- META ============================================= -->
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <!-- FAVICONS ICON ============================================= -->
    <link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" type="image/x-icon" />
    
    <!-- PAGE TITLE ============================================= -->
    <title>Chỉnh sửa CLB - ${club.clubName}</title>
    
    <!-- All PLUGINS CSS ============================================= -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/assets.css">
    
    <!-- TYPOGRAPHY ============================================= -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/typography.css">
    
    <!-- SHORTCODES ============================================= -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/shortcodes/shortcodes.css">
    
    <!-- STYLESHEETS ============================================= -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link class="skin" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/color/color-1.css">
    
</head>
<body class="ttr-opened-sidebar ttr-pinned-sidebar">
    
    <!-- Header start -->
    <jsp:include page="../layout/header.jsp"/>
    <!-- Header end -->
    
    <!-- Left sidebar menu start -->
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
                    <li>
                        <a href="${pageContext.request.contextPath}/clubDashboard?clubId=${club.clubId}" class="ttr-material-button">
                            <span class="ttr-icon"><i class="ti-home"></i></span>
                            <span class="ttr-label">Dashboard</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/clubDetail?clubId=${club.clubId}" class="ttr-material-button">
                            <span class="ttr-icon"><i class="ti-info-alt"></i></span>
                            <span class="ttr-label">Chi tiết CLB</span>
                        </a>
                    </li>
                    <li class="show">
                        <a href="${pageContext.request.contextPath}/updateClub?clubId=${club.clubId}" class="ttr-material-button">
                            <span class="ttr-icon"><i class="ti-pencil"></i></span>
                            <span class="ttr-label">Chỉnh sửa</span>
                        </a>
                    </li>
                    <li class="ttr-seperate"></li>
                </ul>
            </nav>
        </div>
    </div>
    <!-- Left sidebar menu end -->

    <!--Main container start -->
    <main class="ttr-wrapper">
        <div class="container-fluid">
            <div class="db-breadcrumb">
                <h4 class="breadcrumb-title">Chỉnh sửa - ${club.clubName}</h4>
                <ul class="db-breadcrumb-list">
                    <li><a href="${pageContext.request.contextPath}/home"><i class="fa fa-home"></i>Trang chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/clubDetail?clubId=${club.clubId}">Chi tiết CLB</a></li>
                    <li>Chỉnh sửa</li>
                </ul>
            </div>    
            
            <!-- Edit Club Form -->
            <div class="row">
                <div class="col-lg-12 m-b30">
                    <div class="widget-box">
                        <div class="wc-title">
                            <h4>Thông tin CLB</h4>
                        </div>
                        <div class="widget-inner">
                            
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger alert-dismissible fade show">
                                    <i class="fa fa-exclamation-circle"></i> ${error}
                                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                            </c:if>
                            
                            <form action="${pageContext.request.contextPath}/updateClub" method="POST" enctype="multipart/form-data" class="edit-profile">
                                <input type="hidden" name="clubId" value="${club.clubId}">
                                
                                <div class="row">
                                    <div class="col-12 col-sm-6 m-b30">
                                        <div class="form-group">
                                            <label class="col-form-label">Tên CLB <span class="text-danger">*</span></label>
                                            <div>
                                                <input class="form-control" type="text" name="clubName" 
                                                       value="${club.clubName}" required>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="col-12 col-sm-6 m-b30">
                                        <div class="form-group">
                                            <label class="col-form-label">Loại CLB <span class="text-danger">*</span></label>
                                            <div>
                                                <select class="form-control" name="clubTypes" required>
                                                    <option value="">-- Chọn loại CLB --</option>
                                                    <option value="Thể thao" ${club.clubTypes == 'Thể thao' ? 'selected' : ''}>Thể thao</option>
                                                    <option value="Văn hóa" ${club.clubTypes == 'Văn hóa' ? 'selected' : ''}>Văn hóa</option>
                                                    <option value="Học thuật" ${club.clubTypes == 'Học thuật' ? 'selected' : ''}>Học thuật</option>
                                                    <option value="Nghệ thuật" ${club.clubTypes == 'Nghệ thuật' ? 'selected' : ''}>Nghệ thuật</option>
                                                    <option value="Công nghệ" ${club.clubTypes == 'Công nghệ' ? 'selected' : ''}>Công nghệ</option>
                                                    <option value="Tình nguyện" ${club.clubTypes == 'Tình nguyện' ? 'selected' : ''}>Tình nguyện</option>
                                                    <option value="Khác" ${club.clubTypes == 'Khác' ? 'selected' : ''}>Khác</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="col-12 m-b30">
                                        <div class="form-group">
                                            <label class="col-form-label">Mô tả CLB <span class="text-danger">*</span></label>
                                            <div>
                                                <textarea class="form-control" name="description" rows="6" required>${club.description}</textarea>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="col-12 col-sm-6 m-b30">
                                        <div class="form-group">
                                            <label class="col-form-label">Logo CLB</label>
                                            <div>
                                                <!-- Current Logo Preview -->
                                                <c:if test="${not empty club.logo}">
                                                    <div class="mb-3">
                                                        <label class="d-block text-muted small mb-2">Logo hiện tại:</label>
                                                        <img src="${pageContext.request.contextPath}/${club.logo}" 
                                                             alt="${club.clubName}" class="img-thumbnail" 
                                                             style="max-width: 200px; max-height: 200px;">
                                                    </div>
                                                </c:if>
                                                
                                                <!-- Upload New Logo -->
                                                <input type="hidden" name="currentLogo" value="${club.logo}">
                                                <input class="form-control" type="file" name="logo" 
                                                       accept="image/jpeg,image/jpg,image/png,image/gif,image/webp"
                                                       onchange="previewLogo(this)">
                                                <small class="form-text text-muted">
                                                    Upload ảnh mới (JPG, PNG, GIF, WEBP - tối đa 5MB). Để trống nếu không thay đổi.
                                                </small>
                                                
                                                <!-- Preview New Logo -->
                                                <div id="newLogoPreview" class="mt-2" style="display: none;">
                                                    <label class="d-block text-primary small mb-2">Logo mới:</label>
                                                    <img id="newLogoImg" src="" alt="Preview" class="img-thumbnail" 
                                                         style="max-width: 200px; max-height: 200px;">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="col-12 col-sm-6 m-b30">
                                        <div class="form-group">
                                            <label class="col-form-label">Trạng thái</label>
                                            <div>
                                                <select class="form-control" name="status">
                                                    <option value="Active" ${club.status == 'Active' ? 'selected' : ''}>Active</option>
                                                    <option value="Inactive" ${club.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="col-12 col-sm-6 m-b30">
                                        <div class="form-group">
                                            <label class="col-form-label">Ngày tạo</label>
                                            <div>
                                                <input class="form-control" type="text" value="${club.createdAt}" readonly disabled>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="col-12 col-sm-6 m-b30">
                                        <div class="form-group">
                                            <label class="col-form-label">Club Leader (Người tạo ban đầu: User ID ${club.createdBy})</label>
                                            <div>
                                                <select class="form-control" name="newLeaderId">
                                                    <option value="">-- Giữ nguyên --</option>
                                                    <c:forEach items="${allUsers}" var="user">
                                                        <option value="${user.userId}" 
                                                                ${user.userId == club.createdBy ? 'selected' : ''}>
                                                            ${user.fullName} (ID: ${user.userId})
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                                <small class="form-text text-muted">
                                                    Chọn người dùng mới để chuyển quyền Club Leader. Để trống để giữ nguyên.
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="col-12">
                                        <div class="seperator"></div>
                                    </div>
                                    
                                    <div class="col-12">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fa fa-save"></i> Lưu thay đổi
                                        </button>
                                        <a href="${pageContext.request.contextPath}/clubDetail?clubId=${club.clubId}" 
                                           class="btn btn-secondary">
                                            <i class="fa fa-times"></i> Hủy
                                        </a>
                                        <button type="button" class="btn btn-danger float-right" onclick="confirmDelete()">
                                            <i class="fa fa-trash"></i> Xóa CLB
                                        </button>
                                    </div>
                                    
                                </div>
                                
                            </form>
                            
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Thông tin CLB -->
            <div class="row">
                <div class="col-lg-12 m-b30">
                    <div class="widget-box">
                        <div class="wc-title">
                            <h4>
                                <i class="fa fa-info-circle"></i> Thông tin chi tiết CLB
                            </h4>
                        </div>
                        <div class="widget-inner">
                            <div class="row">
                                <!-- Card 1: Thông tin thời gian -->
                                <div class="col-md-6">
                                    <div class="card border-primary mb-3">
                                        <div class="card-header bg-primary text-white">
                                            <i class="fa fa-clock-o"></i> Thông tin thời gian
                                        </div>
                                        <div class="card-body">
                                            <p>
                                                <strong>Ngày tạo:</strong><br>
                                                <span class="text-muted">${club.createdAt}</span>
                                            </p>
                                            <p class="mb-0">
                                                <strong>Người tạo ban đầu:</strong><br>
                                                <span class="badge badge-success">User ID: ${club.createdBy}</span>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Card 2: Trạng thái hiện tại -->
                                <div class="col-md-6">
                                    <div class="card border-info mb-3">
                                        <div class="card-header bg-info text-white">
                                            <i class="fa fa-bar-chart"></i> Trạng thái hiện tại
                                        </div>
                                        <div class="card-body">
                                            <p>
                                                <strong>Trạng thái:</strong><br>
                                                <c:choose>
                                                    <c:when test="${club.status == 'Active'}">
                                                        <span class="badge badge-success badge-lg">
                                                            <i class="fa fa-check-circle"></i> Active - Đang hoạt động
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-secondary badge-lg">
                                                            <i class="fa fa-pause-circle"></i> Inactive - Tạm ngưng
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                            <p class="mb-0">
                                                <strong>Loại CLB:</strong><br>
                                                <span class="badge badge-primary">${club.clubTypes}</span>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Lưu ý -->
                            <div class="alert alert-light border">
                                <h5><i class="fa fa-lightbulb-o text-warning"></i> Lưu ý khi chỉnh sửa</h5>
                                <ul class="mb-0">
                                    <li><strong>Logo:</strong> Upload ảnh mới sẽ thay thế logo cũ. Để trống nếu giữ nguyên logo hiện tại.</li>
                                    <li><strong>Club Leader:</strong> Khi thay đổi leader, người mới sẽ có quyền quản lý toàn bộ CLB.</li>
                                    <li><strong>Trạng thái:</strong> Đặt "Inactive" để tạm ẩn CLB khỏi danh sách công khai.</li>
                                    <li><strong>Thông tin khác:</strong> Mọi thay đổi sẽ có hiệu lực ngay lập tức sau khi lưu.</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
        </div>
    </main>
    <div class="ttr-overlay"></div>

    <!-- External JavaScripts -->
    <script src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/popper.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap-select/bootstrap-select.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/scroll/scrollbar.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/functions.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/admin.js"></script>
    
    <script>
    // Preview logo before upload
    function previewLogo(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            
            reader.onload = function(e) {
                document.getElementById('newLogoImg').src = e.target.result;
                document.getElementById('newLogoPreview').style.display = 'block';
            };
            
            reader.readAsDataURL(input.files[0]);
        } else {
            document.getElementById('newLogoPreview').style.display = 'none';
        }
    }
    
    // Confirm delete
    function confirmDelete() {
        if (confirm('Bạn có chắc chắn muốn xóa CLB này?\n\nChọn OK để vô hiệu hóa (Inactive)\nChọn Cancel để hủy.')) {
            var form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/deleteClub';
            
            var clubIdInput = document.createElement('input');
            clubIdInput.type = 'hidden';
            clubIdInput.name = 'clubId';
            clubIdInput.value = '${club.clubId}';
            
            var actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'deactivate';
            
            form.appendChild(clubIdInput);
            form.appendChild(actionInput);
            document.body.appendChild(form);
            form.submit();
        }
    }
    </script>
</body>
</html>

