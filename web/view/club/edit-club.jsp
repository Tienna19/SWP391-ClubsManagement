<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            background: #f5f6fb;
        }

        .club-edit-wrapper {
            padding: 24px 24px 48px;
            min-height: calc(100vh - 120px);
        }

        .club-edit-hero {
            position: relative;
            border-radius: 24px;
            padding: 28px 32px;
            background: linear-gradient(135deg, rgba(106, 79, 249, 0.9) 0%, rgba(79, 59, 190, 0.85) 45%, rgba(66, 133, 244, 0.85) 100%);
            color: #fff;
            margin-bottom: 28px;
            overflow: hidden;
        }

        .club-edit-hero::after {
            content: "";
            position: absolute;
            inset: 0;
            background:
                radial-gradient(circle at 20% 15%, rgba(255, 255, 255, 0.25), transparent 60%),
                radial-gradient(circle at 85% 20%, rgba(255, 255, 255, 0.2), transparent 55%);
            pointer-events: none;
            opacity: 0.8;
        }

        .club-edit-hero .container-fluid {
            position: relative;
            z-index: 1;
        }

        .hero-content {
            display: flex;
            align-items: center;
            gap: 28px;
            flex-wrap: wrap;
        }

        .hero-title {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        .hero-text h1 {
            font-size: 30px;
            font-weight: 700;
            margin: 0;
        }

        .hero-badges {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-top: 8px;
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.18);
            font-weight: 600;
            letter-spacing: 0.3px;
        }

        .club-edit-container .edit-card,
        .club-edit-container .info-card,
        .club-edit-container .tips-card {
            border-radius: 20px;
            border: 1px solid rgba(111, 118, 225, 0.12);
            box-shadow: 0 16px 34px rgba(31, 43, 90, 0.08);
            background: #fff;
        }

        .club-edit-container .edit-card-header {
            padding: 24px 28px 16px;
            border-bottom: 1px solid rgba(226, 230, 247, 0.6);
        }

        .club-edit-container .edit-card-body {
            padding: 24px 28px 32px;
        }

        .form-section {
            padding-bottom: 20px;
            margin-bottom: 20px;
            border-bottom: 1px dashed rgba(163, 172, 222, 0.35);
        }

        .form-section:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }

        .form-section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
            color: #4f3edf;
            margin-bottom: 16px;
        }

        .form-section-title .icon {
            width: 34px;
            height: 34px;
            border-radius: 10px;
            background: rgba(79, 62, 223, 0.12);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #4f3edf;
        }

        .form-control,
        .form-select {
            border-radius: 12px;
            border: 1px solid rgba(148, 156, 194, 0.45);
            padding: 12px 16px;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: rgba(79, 62, 223, 0.8);
            box-shadow: 0 0 0 3px rgba(79, 62, 223, 0.18);
        }

        .logo-preview {
            max-width: 80px;
            max-height: 80px;
            width: 100%;
            border-radius: 14px;
            border: 1px solid rgba(94, 53, 177, 0.15);
            padding: 12px;
            background: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 12px 24px rgba(31, 43, 90, 0.06);
        }

        .logo-preview img {
            width: 100%;
            height: auto;
            max-height: 68px;
            object-fit: contain;
            border-radius: 12px;
        }

        .hero-logo.hero-logo--small {
            width: 120px;
            height: 120px;
            padding: 10px;
            border-radius: 24px;
            box-shadow: 0 22px 36px rgba(12, 18, 54, 0.22);
            background: rgba(255, 255, 255, 0.22);
        }

        .hero-logo.hero-logo--small img {
            width: 100%;
            height: 100%;
            object-fit: contain;
            border-radius: 18px;
        }

        @media (max-width: 575px) {
            .logo-preview {
                max-width: 220px;
                margin-left: auto;
                margin-right: auto;
            }

            .club-edit-hero {
                padding: 22px 20px;
                border-radius: 20px;
            }

            .hero-logo.hero-logo--small {
                width: 100px;
                height: 100px;
            }

            .hero-text h1 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body class="ttr-opened-sidebar ttr-pinned-sidebar">

    <%@ include file="/WEB-INF/jspf/leader-layout.jspf" %>

    <c:set var="logoSrc" value=""/>
    <c:if test="${not empty club.logo}">
        <c:set var="rawLogo" value="${club.logo}"/>
        <c:set var="normalizedLogo" value="${fn:replace(rawLogo, '\\\\', '/')}"/>
        <c:choose>
            <c:when test="${fn:startsWith(normalizedLogo, 'http')}">
                <c:set var="logoSrc" value="${normalizedLogo}"/>
            </c:when>
            <c:when test="${fn:startsWith(normalizedLogo, '/')}">
                <c:set var="logoSrc" value="${pageContext.request.contextPath}${normalizedLogo}"/>
            </c:when>
            <c:when test="${fn:contains(normalizedLogo, '/web/')}">
                <c:set var="relativeLogo" value="${fn:substringAfter(normalizedLogo, '/web/')}"/>
                <c:if test="${not fn:startsWith(relativeLogo, '/')}">
                    <c:set var="relativeLogo" value="/${relativeLogo}"/>
                </c:if>
                <c:set var="logoSrc" value="${pageContext.request.contextPath}${relativeLogo}"/>
            </c:when>
            <c:when test="${fn:contains(normalizedLogo, '/assets/') or fn:startsWith(normalizedLogo, 'assets/')}">
                <c:set var="relativeLogo" value="${normalizedLogo}"/>
                <c:if test="${fn:contains(relativeLogo, '/assets/')}">
                    <c:set var="relativeLogo" value="${fn:substringAfter(relativeLogo, '/assets/')}"/>
                    <c:set var="relativeLogo" value="/assets/${relativeLogo}"/>
                </c:if>
                <c:if test="${fn:startsWith(relativeLogo, 'assets/')}">
                    <c:set var="relativeLogo" value="/${relativeLogo}"/>
                </c:if>
                <c:set var="logoSrc" value="${pageContext.request.contextPath}${relativeLogo}"/>
            </c:when>
            <c:otherwise>
                <c:set var="logoSrc" value="${pageContext.request.contextPath}/${normalizedLogo}"/>
            </c:otherwise>
        </c:choose>
    </c:if>

    <main class="ttr-wrapper club-edit-wrapper">
        <div class="club-edit-hero">
            <div class="container-fluid">
                <div class="hero-content">
                    <div class="hero-logo hero-logo--small">
                        <c:choose>
                            <c:when test="${not empty logoSrc}">
                                <img src="${logoSrc}" alt="${club.clubName}">
                            </c:when>
                            <c:otherwise>
                                <div class="hero-logo-placeholder">
                                    <i class="fa fa-university"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="hero-text">
                        <div class="hero-title">
                            <h1>${club.clubName}</h1>
                            <span class="hero-badge"><i class="fa fa-id-badge"></i> ID #${club.clubId}</span>
                        </div>
                        <div class="hero-badges hero-badges-inline">
                            <span class="hero-badge"><i class="fa fa-tags"></i> ${club.clubTypes}</span>
                            <span class="hero-badge">
                                <i class="fa ${club.status == 'Active' ? 'fa-check-circle' : 'fa-pause-circle'}"></i>
                                ${club.status == 'Active' ? 'Đang hoạt động' : 'Tạm ngưng'}
                            </span>
                            <span class="hero-badge"><i class="fa fa-calendar"></i> Tạo ngày: ${club.createdAt}</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="container-fluid club-edit-container">
            <div class="row">
                <div class="col-lg-8 mb-4">
                    <div class="edit-card">
                        <div class="edit-card-header">
                            <h2>Chỉnh sửa thông tin CLB</h2>
                            <p>Điều chỉnh chi tiết, logo và quyền quản trị cho câu lạc bộ của bạn.</p>
                        </div>
                        <div class="edit-card-body">
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger alert-dismissible fade show mb-4">
                                    <i class="fa fa-exclamation-circle"></i> ${error}
                                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                            </c:if>

                            <form action="${pageContext.request.contextPath}/updateClub" method="POST" enctype="multipart/form-data">
                                <input type="hidden" name="clubId" value="${club.clubId}">

                                <div class="form-section">
                                    <div class="form-section-title">
                                        <span class="icon"><i class="fa fa-id-card"></i></span>
                                        Thông tin cơ bản
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label class="form-label font-weight-semibold">Tên CLB <span class="text-danger">*</span></label>
                                            <input class="form-control" type="text" name="clubName" value="${club.clubName}" required>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label class="form-label font-weight-semibold">Loại CLB <span class="text-danger">*</span></label>
                                            <select class="form-select" name="clubTypes" required>
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
                                        <div class="col-12">
                                            <label class="form-label font-weight-semibold">Mô tả CLB <span class="text-danger">*</span></label>
                                            <textarea class="form-control" name="description" rows="6" required>${club.description}</textarea>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-section">
                                    <div class="form-section-title">
                                        <span class="icon"><i class="fa fa-image"></i></span>
                                        Logo & Trạng thái
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label class="form-label font-weight-semibold">Logo hiện tại</label>
                                            <div class="logo-preview mb-3">
                                                <c:choose>
                                                    <c:when test="${not empty logoSrc}">
                                                        <img src="${logoSrc}" alt="${club.clubName}">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="text-center text-muted small">Chưa có logo – hãy tải lên để tăng nhận diện.</div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <input type="hidden" name="currentLogo" value="${club.logo}">
                                            <input class="form-control" type="file" name="logo"
                                                   accept="image/jpeg,image/jpg,image/png,image/gif,image/webp"
                                                   onchange="previewLogo(this)">
                                            <small class="form-text text-muted">
                                                JPG, PNG, GIF, WEBP • Tối đa 5MB. Để trống nếu giữ nguyên logo hiện tại.
                                            </small>
                                            <div id="newLogoPreview" class="logo-preview mt-3" style="display: none;">
                                                <label class="d-block text-primary small font-weight-semibold mb-2">Logo mới:</label>
                                                <img id="newLogoImg" src="" alt="Preview">
                                            </div>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label class="form-label font-weight-semibold">Trạng thái CLB</label>
                                            <select class="form-select mb-3" name="status">
                                                <option value="Active" ${club.status == 'Active' ? 'selected' : ''}>Active</option>
                                                <option value="Inactive" ${club.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                                            </select>
                                            <label class="form-label font-weight-semibold">Ngày tạo</label>
                                            <input class="form-control" type="text" value="${club.createdAt}" readonly disabled>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-section mb-0">
                                    <div class="form-section-title">
                                        <span class="icon"><i class="fa fa-user-shield"></i></span>
                                        Quản lý Leader
                                    </div>
                                    <label class="form-label font-weight-semibold">Chọn Club Leader mới (tùy chọn)</label>
                                    <select class="form-select" name="newLeaderId">
                                        <option value="">-- Giữ nguyên leader hiện tại --</option>
                                        <c:forEach items="${allUsers}" var="user">
                                            <option value="${user.userId}" ${user.userId == club.createdBy ? 'selected' : ''}>
                                                ${user.fullName} (ID: ${user.userId})
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <small class="form-text text-muted">
                                        Người được chọn sẽ trở thành Club Leader ngay sau khi lưu lại thay đổi.
                                    </small>
                                </div>

                                <div class="edit-actions">
                                    <button type="submit" class="btn btn-rounded btn-gradient">
                                        <i class="fa fa-save mr-2"></i> Lưu thay đổi
                                    </button>
                                    <a href="${pageContext.request.contextPath}/clubDetail?clubId=${club.clubId}" class="btn btn-rounded btn-outline">
                                        <i class="fa fa-arrow-left mr-2"></i> Quay lại chi tiết
                                    </a>
                                    <button type="button" class="btn btn-rounded btn-danger-soft ml-auto" onclick="confirmDelete()">
                                        <i class="fa fa-exclamation-triangle mr-2"></i> Vô hiệu hóa CLB
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4 mb-4">
                    <div class="info-card">
                        <h5><i class="fa fa-info-circle mr-2 text-primary"></i>Thông tin nhanh</h5>
                        <ul class="info-list">
                            <li>
                                <span class="icon"><i class="fa fa-user"></i></span>
                                Leader hiện tại: <strong>ID ${club.createdBy}</strong>
                            </li>
                            <li>
                                <span class="icon"><i class="fa fa-calendar"></i></span>
                                Ngày tạo: <span class="text-muted">${club.createdAt}</span>
                            </li>
                            <li>
                                <span class="icon"><i class="fa fa-signal"></i></span>
                                Trạng thái:
                                <span class="info-badge ${club.status == 'Active' ? 'success' : 'warning'}">
                                    <i class="fa ${club.status == 'Active' ? 'fa-check' : 'fa-pause'}"></i> ${club.status}
                                </span>
                            </li>
                            <li>
                                <span class="icon"><i class="fa fa-bookmark"></i></span>
                                Loại CLB: <strong>${club.clubTypes}</strong>
                            </li>
                        </ul>
                    </div>

                    <div class="tips-card">
                        <h5><i class="fa fa-lightbulb-o mr-2 text-warning"></i>Mẹo chỉnh sửa hiệu quả</h5>
                        <ul>
                            <li>Logo rõ nét giúp CLB nổi bật hơn trong danh sách hiển thị.</li>
                            <li>Mô tả nên ngắn gọn, thể hiện được giá trị và hoạt động chính.</li>
                            <li>Chỉ chuyển quyền Leader khi đã thống nhất với người nhận.</li>
                            <li>Chế độ <strong>Inactive</strong> dùng để tạm ẩn CLB khỏi người dùng.</li>
                        </ul>
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

