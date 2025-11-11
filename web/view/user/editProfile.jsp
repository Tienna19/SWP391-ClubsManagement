<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">

    <head>

        <!-- META ============================================= -->
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="keywords" content="" />
        <meta name="author" content="" />
        <meta name="robots" content="" />

        <!-- DESCRIPTION -->
        <meta name="description" content="EduChamp : Education HTML Template" />

        <!-- OG -->
        <meta property="og:title" content="EduChamp : Education HTML Template" />
        <meta property="og:description" content="EduChamp : Education HTML Template" />
        <meta property="og:image" content="" />
        <meta name="format-detection" content="telephone=no">

        <!-- FAVICONS ICON ============================================= -->
        <link rel="icon" href="assets/images/favicon.ico" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/images/favicon.png" />

        <!-- PAGE TITLE HERE ============================================= -->
        <title>EduChamp : Education HTML Template </title>

        <!-- MOBILE SPECIFIC ============================================= -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!--[if lt IE 9]>
        <script src="assets/js/html5shiv.min.js"></script>
        <script src="assets/js/respond.min.js"></script>
        <![endif]-->

        <!-- All PLUGINS CSS ============================================= -->
        <link rel="stylesheet" type="text/css" href="assets/css/assets.css">

        <!-- TYPOGRAPHY ============================================= -->
        <link rel="stylesheet" type="text/css" href="assets/css/typography.css">

        <!-- SHORTCODES ============================================= -->
        <link rel="stylesheet" type="text/css" href="assets/css/shortcodes/shortcodes.css">

        <!-- STYLESHEETS ============================================= -->
        <link rel="stylesheet" type="text/css" href="assets/css/style.css">
        <link class="skin" rel="stylesheet" type="text/css" href="assets/css/color/color-1.css">

    </head>
    <body id="bg">
        <div class="page-wraper">
            <div id="loading-icon-bx"></div>
            <%@ include file="/view/layout/header.jsp" %>
            <!-- Content -->
            <c:if test="${not empty message}">
                <div class="alert alert-success">${message}</div>
            </c:if>
            <div class="page-content bg-white">
                <div class="content-block">
                    <!-- About Us -->
                    <div class="section-area section-sp1">
                        <div class="container">
                            <div class="row">

                                <div class="col-lg-9 col-md-8 col-sm-12 m-b30 mx-auto">
                                    <div class="profile-content-bx p-4 shadow radius bg-white">

                                        <h3 class="mb-4 font-weight-bold">Chỉnh sửa hồ sơ</h3>

                                        <!-- Avatar Preview -->
                                        <div class="text-center mb-4">
                                            <img id="avatarPreview" src="${account.profileImage}" class="rounded-circle"
                                                 style="width: 120px; height: 120px; object-fit: cover; border: 4px solid #eee;">
                                            <div class="mt-2">
                                                <label class="btn btn-outline-primary btn-sm">
                                                    Chọn ảnh mới <input type="file" name="profileImage" id="avatarInput" hidden>
                                                </label>
                                            </div>
                                        </div>

                                        <form action="edit-profile" method="post" enctype="multipart/form-data">

                                            <div class="form-group">
                                                <label>Họ và tên</label>
                                                <input class="form-control" type="text" name="fullName" value="${userInfo.fullName}">
                                            </div>

                                            <div class="form-group">
                                                <label>Số điện thoại</label>
                                                <input class="form-control" type="text" name="phoneNumber" value="${userInfo.phoneNumber}">
                                            </div>

                                            <div class="form-group">
                                                <label>Địa chỉ</label>
                                                <input class="form-control" type="text" name="address" value="${userInfo.address}">
                                            </div>

                                            <div class="form-group">
                                                <label>Giới tính</label>
                                                <select name="gender" class="form-control">
                                                    <option value="Male" ${userInfo.gender == 'Male' ? 'selected' : ''}>Nam</option>
                                                    <option value="Female" ${userInfo.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                                                    <option value="Other" ${userInfo.gender == 'Other' ? 'selected' : ''}>Khác</option>
                                                </select>
                                            </div>

                                            <div class="text-right mt-4">
                                                <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                                                <a href="profile" class="btn btn-light">Hủy</a>
                                            </div>

                                        </form>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- contact area END -->
        </div>
        <!-- Content END-->
        <%@ include file="/view/layout/footer.jsp" %>
        <button class="back-to-top fa fa-chevron-up" ></button>
    </div>
    <!-- External JavaScripts -->
    <script src="assets/js/jquery.min.js"></script>
    <script src="assets/vendors/bootstrap/js/popper.min.js"></script>
    <script src="assets/vendors/bootstrap/js/bootstrap.min.js"></script>
    <script src="assets/vendors/bootstrap-select/bootstrap-select.min.js"></script>
    <script src="assets/vendors/bootstrap-touchspin/jquery.bootstrap-touchspin.js"></script>
    <script src="assets/vendors/magnific-popup/magnific-popup.js"></script>
    <script src="assets/vendors/counter/waypoints-min.js"></script>
    <script src="assets/vendors/counter/counterup.min.js"></script>
    <script src="assets/vendors/imagesloaded/imagesloaded.js"></script>
    <script src="assets/vendors/masonry/masonry.js"></script>
    <script src="assets/vendors/masonry/filter.js"></script>
    <script src="assets/vendors/owl-carousel/owl.carousel.js"></script>
    <script src="assets/js/functions.js"></script>
    <script src="assets/js/contact.js"></script>
    <script src='assets/vendors/switcher/switcher.js'></script>
    <script>
    const avatarInput = document.getElementById("avatarInput");
    const avatarPreview = document.getElementById("avatarPreview");

    avatarInput.addEventListener("change", function () {
        const file = this.files[0];
        if (file) {
            avatarPreview.src = URL.createObjectURL(file);
        }
    });
</script>

</body>

</html>

