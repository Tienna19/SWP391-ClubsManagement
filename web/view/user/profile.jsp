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

                                        <div class="d-flex align-items-center mb-4">
                                            <img src="${account.profileImage}" class="rounded-circle mr-3" style="width: 90px; height: 90px; object-fit: cover;">
                                            <div>
                                                <h3 class="m-0">${userInfo.fullName}</h3>
                                                <small class="text-muted">${userInfo.email}</small>
                                            </div>
                                        </div>

                                        <h4 class="mb-3">Thông tin cá nhân</h4>

                                        <ul class="list-group mb-4">
                                            <li class="list-group-item d-flex justify-content-between">
                                                <span>📞 Số điện thoại:</span>
                                                <span>${userInfo.phoneNumber != null ? userInfo.phoneNumber : "Chưa cập nhật"}</span>
                                            </li>
                                            <li class="list-group-item d-flex justify-content-between">
                                                <span>🏠 Địa chỉ:</span>
                                                <span>${userInfo.address != null ? userInfo.address : "Chưa cập nhật"}</span>
                                            </li>
                                            <li class="list-group-item d-flex justify-content-between">
                                                <span>⚧ Giới tính:</span>
                                                <span>${userInfo.gender != null ? userInfo.gender : "Chưa cập nhật"}</span>
                                            </li>
                                            <li class="list-group-item d-flex justify-content-between">
                                                <span>🗓 Ngày tạo tài khoản:</span>
                                                <span>${userInfo.createdAt}</span>
                                            </li>
                                        </ul>

                                        <div class="text-right">
                                            <a href="edit-profile" class="btn btn-primary mr-2"><i class="ti-pencil-alt"></i> Chỉnh sửa hồ sơ</a>
                                            <a href="change-password" class="btn btn-warning"><i class="ti-lock"></i> Đổi mật khẩu</a>
                                        </div>

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
    <!-- <script src="assets/js/contact.js"></script> -->
    <script src='assets/vendors/switcher/switcher.js'></script>
</body>

</html>

