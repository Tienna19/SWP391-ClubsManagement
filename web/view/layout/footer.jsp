<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- ✅ CSS cho footer -->
<style>
    footer {
        background-color: #5B2C8E;
        color: white;
        text-align: center;
        padding: 20px 0;
        margin-top: 40px;
    }
    footer a {
        color: #FFD700;
        text-decoration: none;
    }
    footer a:hover {
        text-decoration: underline;
    }
</style>

<footer>
    <div class="container">
        <p class="mb-1">&copy; 2025 Student Club Management System</p>
        <p class="mb-0">
            <a href="${pageContext.request.contextPath}/contact.jsp">Contact Us</a> |
            <a href="${pageContext.request.contextPath}/faq.jsp">FAQ</a>
        </p>
    </div>
</footer>

<!-- JS Libraries -->
<script src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/popper.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap-select/bootstrap-select.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/magnific-popup/magnific-popup.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/owl-carousel/owl.carousel.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/functions.js"></script>
