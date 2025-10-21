<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Tạo Câu Lạc Bộ Mới</title>
    <!-- Enhanced Error Suppression -->
    <script>
        // Comprehensive browser extension error suppression
        (function() {
            'use strict';
            
            const originalError = console.error;
            const originalWarn = console.warn;
            const originalLog = console.log;
            const originalInfo = console.info;
            
            function shouldSuppress(message) {
                if (!message) return false;
                const lowerMessage = message.toLowerCase();
                return lowerMessage.includes('runtime.lasterror') ||
                       lowerMessage.includes('message port closed') ||
                       lowerMessage.includes('extension') ||
                       lowerMessage.includes('chrome-extension') ||
                       lowerMessage.includes('moz-extension') ||
                       lowerMessage.includes('safari-extension') ||
                       lowerMessage.includes('unchecked runtime.lasterror') ||
                       lowerMessage.includes('the message port closed before a response was received');
            }
            
            console.error = function() {
                const message = Array.prototype.join.call(arguments, ' ');
                if (shouldSuppress(message)) {
                    return;
                }
                originalError.apply(console, arguments);
            };
            
            console.warn = function() {
                const message = Array.prototype.join.call(arguments, ' ');
                if (shouldSuppress(message)) {
                    return;
                }
                originalWarn.apply(console, arguments);
            };
            
            console.log = function() {
                const message = Array.prototype.join.call(arguments, ' ');
                if (shouldSuppress(message)) {
                    return;
                }
                originalLog.apply(console, arguments);
            };
            
            console.info = function() {
                const message = Array.prototype.join.call(arguments, ' ');
                if (shouldSuppress(message)) {
                    return;
                }
                originalInfo.apply(console, arguments);
            };
            
            // Suppress unhandled errors
            window.addEventListener('error', function(e) {
                if (e.message && shouldSuppress(e.message)) {
                    e.preventDefault();
                    return false;
                }
            }, true);
            
            // Suppress unhandled promise rejections
            window.addEventListener('unhandledrejection', function(e) {
                if (e.reason && shouldSuppress(e.reason.toString())) {
                    e.preventDefault();
                    return false;
                }
            }, true);
            
        })();
    </script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendors/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        body {
            background-color: #f7f6fb;
        }
        .form-container {
            background: #fff;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            max-width: 600px;
            margin: 40px auto;
        }
        h2 {
            text-align: center;
            color: #5B2C8E;
            font-weight: bold;
            margin-bottom: 25px;
        }
        label {
            font-weight: 500;
            margin-bottom: 6px;
        }
        .btn-primary {
            background-color: #5B2C8E;
            border: none;
        }
        .btn-primary:hover {
            background-color: #4a2476;
        }
        a.back-link {
            display: block;
            margin-top: 15px;
            text-align: center;
            color: #5B2C8E;
            text-decoration: none;
        }
        a.back-link:hover {
            text-decoration: underline;
        }
        .alert {
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .form-control:focus, .form-select:focus {
            border-color: #5B2C8E;
            box-shadow: 0 0 0 0.2rem rgba(91, 44, 142, 0.25);
        }
        .file-upload-area {
            border: 2px dashed #ddd;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
            background-color: #fafafa;
            transition: all 0.3s ease;
        }
        .file-upload-area:hover {
            border-color: #5B2C8E;
            background-color: #f0f0ff;
        }
        .file-upload-area.dragover {
            border-color: #5B2C8E;
            background-color: #f0f0ff;
        }
        .file-preview {
            margin-top: 10px;
            text-align: center;
        }
        .file-preview img {
            max-width: 150px;
            max-height: 150px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .file-info {
            margin-top: 8px;
            font-size: 0.9em;
            color: #666;
        }
        .character-count {
            font-size: 0.8em;
            color: #666;
            text-align: right;
            margin-top: 5px;
        }
        .character-count.warning {
            color: #ff9800;
        }
        .character-count.danger {
            color: #f44336;
        }
        .required {
            color: #f44336;
        }
        .form-text {
            font-size: 0.85em;
            color: #666;
        }
    </style>
</head>

<body>

    <%@ include file="/view/layout/header.jsp" %>

    <div class="form-container">
        <h2>Tạo CLB Mới</h2>

        <!-- Error Message -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger" role="alert">
                <i class="fas fa-exclamation-triangle"></i> ${errorMessage}
            </div>
        </c:if>

        <!-- Success Message -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success" role="alert">
                <i class="fas fa-check-circle"></i> ${successMessage}
            </div>
        </c:if>

        <!-- Form -->
        <form id="createClubForm" action="${pageContext.request.contextPath}/createClub" 
              method="post" enctype="multipart/form-data" novalidate>

            <!-- Tên CLB -->
            <div class="mb-3">
                <label for="clubName" class="form-label">Tên CLB <span class="required">*</span></label>
                <input type="text" id="clubName" name="clubName" class="form-control" 
                       placeholder="Nhập tên CLB" maxlength="100" required>
                <div class="form-text">Tên CLB không được vượt quá 100 ký tự</div>
                <div class="invalid-feedback">Vui lòng nhập tên CLB</div>
            </div>

            <!-- Mô tả -->
            <div class="mb-3">
                <label for="description" class="form-label">Mô tả <span class="required">*</span></label>
                <textarea id="description" name="description" rows="4" class="form-control" 
                          placeholder="Giới thiệu ngắn gọn về CLB, mục tiêu, hoạt động..." 
                          maxlength="500" required></textarea>
                <div class="character-count" id="descriptionCount">0/500 ký tự</div>
                <div class="form-text">Mô tả không được vượt quá 500 ký tự</div>
                <div class="invalid-feedback">Vui lòng nhập mô tả CLB</div>
            </div>

            <!-- Logo -->
            <div class="mb-3">
                <label for="logo" class="form-label">Logo CLB <span class="required">*</span></label>
                <div class="file-upload-area" id="fileUploadArea">
                    <i class="fas fa-cloud-upload-alt fa-2x text-muted mb-2"></i>
                    <p class="mb-1">Kéo thả file vào đây hoặc click để chọn</p>
                    <p class="text-muted small">Chỉ chấp nhận file ảnh: JPG, PNG, GIF, WEBP (tối đa 5MB)</p>
                </div>
                <input type="file" id="logo" name="logo" class="form-control d-none" 
                       accept="image/jpeg,image/jpg,image/png,image/gif,image/webp" required>
                <div class="file-preview" id="filePreview" style="display: none;">
                    <img id="previewImage" src="" alt="Preview">
                    <div class="file-info">
                        <span id="fileName"></span>
                        <span id="fileSize"></span>
                    </div>
                    <button type="button" class="btn btn-sm btn-outline-danger mt-2" id="removeFile">
                        <i class="fas fa-trash"></i> Xóa
                    </button>
                </div>
                <div class="invalid-feedback">Vui lòng chọn logo cho CLB</div>
            </div>

            <!-- Thể loại CLB -->
            <div class="mb-3">
                <label for="clubTypes" class="form-label">Thể loại CLB <span class="required">*</span></label>
                <select id="clubTypes" name="clubTypes" class="form-select" required>
                    <option value="">-- Chọn thể loại --</option>
                    <c:forEach var="c" items="${categoryList}">
                        <option value="${c.name}">${c.name}</option>
                    </c:forEach>
                </select>
                <div class="form-text">Chọn thể loại phù hợp với hoạt động của CLB</div>
                <div class="invalid-feedback">Vui lòng chọn thể loại CLB</div>
            </div>

            <!-- Mã sinh viên (Chủ tịch CLB) -->
            <div class="mb-3">
                <label for="createdBy" class="form-label">Mã người tạo (Chủ tịch CLB) <span class="required">*</span></label>
                <input type="text" id="createdBy" name="createdBy" class="form-control" 
                       placeholder="Nhập mã người tạo" pattern="[0-9]+" maxlength="10" required>
                <div class="form-text">Mã sinh viên của người sẽ làm chủ tịch CLB</div>
                <div class="invalid-feedback">Vui lòng nhập mã sinh viên hợp lệ</div>
            </div>

            <!-- Thông tin bổ sung -->
            <div class="alert alert-info">
                <i class="fas fa-info-circle"></i>
                <strong>Lưu ý:</strong> CLB sẽ được tạo với trạng thái Active và có thể hoạt động ngay lập tức.
            </div>

            <!-- Nút submit -->
            <div class="text-center">
                <button type="submit" class="btn btn-primary px-5" id="submitBtn">
                    <i class="fas fa-plus"></i> Tạo CLB
                </button>
                <button type="button" class="btn btn-outline-secondary px-4 ms-2" onclick="resetForm()">
                    <i class="fas fa-undo"></i> Làm mới
                </button>
            </div>
        </form>

        <a href="${pageContext.request.contextPath}/viewAllClubs" class="back-link">
            <i class="fas fa-arrow-left"></i> Quay lại danh sách CLB
        </a>
    </div>

    <%@ include file="/view/layout/footer.jsp" %>

    <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/popper.min.js"></script>
    <script>
        // Character count for description
        const descriptionTextarea = document.getElementById('description');
        const descriptionCount = document.getElementById('descriptionCount');
        
        descriptionTextarea.addEventListener('input', function() {
            const length = this.value.length;
            const maxLength = 500;
            
            descriptionCount.textContent = `${length}/${maxLength} ký tự`;
            
            if (length > maxLength * 0.9) {
                descriptionCount.className = 'character-count danger';
            } else if (length > maxLength * 0.7) {
                descriptionCount.className = 'character-count warning';
            } else {
                descriptionCount.className = 'character-count';
            }
        });

        // File upload handling
        const fileUploadArea = document.getElementById('fileUploadArea');
        const fileInput = document.getElementById('logo');
        const filePreview = document.getElementById('filePreview');
        const previewImage = document.getElementById('previewImage');
        const fileName = document.getElementById('fileName');
        const fileSize = document.getElementById('fileSize');
        const removeFileBtn = document.getElementById('removeFile');

        // Click to select file
        fileUploadArea.addEventListener('click', () => {
            fileInput.click();
        });

        // Drag and drop
        fileUploadArea.addEventListener('dragover', (e) => {
            e.preventDefault();
            fileUploadArea.classList.add('dragover');
        });

        fileUploadArea.addEventListener('dragleave', () => {
            fileUploadArea.classList.remove('dragover');
        });

        fileUploadArea.addEventListener('drop', (e) => {
            e.preventDefault();
            fileUploadArea.classList.remove('dragover');
            
            const files = e.dataTransfer.files;
            if (files.length > 0) {
                handleFileSelect(files[0]);
            }
        });

        // File input change
        fileInput.addEventListener('change', (e) => {
            if (e.target.files.length > 0) {
                handleFileSelect(e.target.files[0]);
            }
        });

        // Remove file
        removeFileBtn.addEventListener('click', () => {
            fileInput.value = '';
            filePreview.style.display = 'none';
            fileUploadArea.style.display = 'block';
        });

        function handleFileSelect(file) {
            // Validate file type
            const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
            if (!allowedTypes.includes(file.type)) {
                alert('Chỉ chấp nhận file ảnh: JPG, JPEG, PNG, GIF, WEBP');
                return;
            }

            // Validate file size (5MB)
            const maxSize = 5 * 1024 * 1024;
            if (file.size > maxSize) {
                alert('Kích thước file không được vượt quá 5MB');
                return;
            }

            // Show preview
            const reader = new FileReader();
            reader.onload = function(e) {
                previewImage.src = e.target.result;
                fileName.textContent = file.name;
                fileSize.textContent = formatFileSize(file.size);
                
                fileUploadArea.style.display = 'none';
                filePreview.style.display = 'block';
            };
            reader.readAsDataURL(file);
        }

        function formatFileSize(bytes) {
            if (bytes === 0) return '0 Bytes';
            const k = 1024;
            const sizes = ['Bytes', 'KB', 'MB', 'GB'];
            const i = Math.floor(Math.log(bytes) / Math.log(k));
            return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
        }

        // Form validation
        const form = document.getElementById('createClubForm');
        const submitBtn = document.getElementById('submitBtn');

        form.addEventListener('submit', function(e) {
            if (!form.checkValidity()) {
                e.preventDefault();
                e.stopPropagation();
            } else {
                // Show loading state
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang tạo...';
                submitBtn.disabled = true;
            }
            form.classList.add('was-validated');
        });

        // Reset form
        function resetForm() {
            form.reset();
            form.classList.remove('was-validated');
            filePreview.style.display = 'none';
            fileUploadArea.style.display = 'block';
            descriptionCount.textContent = '0/500 ký tự';
            descriptionCount.className = 'character-count';
            submitBtn.innerHTML = '<i class="fas fa-plus"></i> Tạo CLB';
            submitBtn.disabled = false;
        }

        // Real-time validation
        const inputs = form.querySelectorAll('input, textarea, select');
        inputs.forEach(input => {
            input.addEventListener('blur', function() {
                if (this.checkValidity()) {
                    this.classList.remove('is-invalid');
                    this.classList.add('is-valid');
                } else {
                    this.classList.remove('is-valid');
                    this.classList.add('is-invalid');
                }
            });
        });
    </script>
</body>
</html>
