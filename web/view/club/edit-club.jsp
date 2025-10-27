<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chỉnh sửa CLB - ${club.clubName}</title>
    <link href="${pageContext.request.contextPath}/assets/vendors/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendors/fontawesome/css/font-awesome.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
</head>
<body>

<jsp:include page="../layout/header.jsp"/>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0"><i class="fa fa-edit"></i> Chỉnh sửa thông tin CLB</h4>
                </div>
                <div class="card-body">
                    
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">
                            <i class="fa fa-exclamation-circle"></i> ${error}
                        </div>
                    </c:if>
                    
                    <form action="${pageContext.request.contextPath}/updateClub" method="POST">
                        <input type="hidden" name="clubId" value="${club.clubId}">
                        
                        <!-- Club Name -->
                        <div class="mb-3">
                            <label for="clubName" class="form-label">
                                Tên CLB <span class="text-danger">*</span>
                            </label>
                            <input type="text" 
                                   class="form-control" 
                                   id="clubName" 
                                   name="clubName" 
                                   value="${club.clubName}" 
                                   required>
                        </div>
                        
                        <!-- Description -->
                        <div class="mb-3">
                            <label for="description" class="form-label">Mô tả</label>
                            <textarea class="form-control" 
                                      id="description" 
                                      name="description" 
                                      rows="5">${club.description}</textarea>
                        </div>
                        
                        <!-- Club Type -->
                        <div class="mb-3">
                            <label for="clubTypes" class="form-label">
                                Thể loại <span class="text-danger">*</span>
                            </label>
                            <select class="form-select" id="clubTypes" name="clubTypes" required>
                                <option value="">-- Chọn thể loại --</option>
                                <option value="Thể thao" ${club.clubTypes eq 'Thể thao' ? 'selected' : ''}>Thể thao</option>
                                <option value="Nghệ thuật" ${club.clubTypes eq 'Nghệ thuật' ? 'selected' : ''}>Nghệ thuật</option>
                                <option value="Xã hội" ${club.clubTypes eq 'Xã hội' ? 'selected' : ''}>Xã hội</option>
                                <option value="Học thuật" ${club.clubTypes eq 'Học thuật' ? 'selected' : ''}>Học thuật</option>
                                <option value="Công nghệ" ${club.clubTypes eq 'Công nghệ' ? 'selected' : ''}>Công nghệ</option>
                                <option value="Khác" ${club.clubTypes eq 'Khác' ? 'selected' : ''}>Khác</option>
                            </select>
                        </div>
                        
                        <!-- Status -->
                        <div class="mb-3">
                            <label for="status" class="form-label">
                                Trạng thái <span class="text-danger">*</span>
                            </label>
                            <select class="form-select" id="status" name="status" required>
                                <option value="Active" ${club.status eq 'Active' ? 'selected' : ''}>Active</option>
                                <option value="Inactive" ${club.status eq 'Inactive' ? 'selected' : ''}>Inactive</option>
                            </select>
                        </div>
                        
                        <!-- Buttons -->
                        <div class="d-flex justify-content-between">
                            <a href="${pageContext.request.contextPath}/clubDetail?clubId=${club.clubId}" 
                               class="btn btn-secondary">
                                <i class="fa fa-arrow-left"></i> Hủy
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fa fa-save"></i> Lưu thay đổi
                            </button>
                        </div>
                        
                    </form>
                    
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../layout/footer.jsp"/>

<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/bootstrap.min.js"></script>

</body>
</html>

