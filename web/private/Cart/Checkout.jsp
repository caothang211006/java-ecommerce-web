<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<fmt:setLocale value="en_US"/>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Checkout</title>
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet">
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
        <script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet"/>
    </head>
    <body>
        <jsp:include page="/Common/Menu.jsp"/>
        <div class="container mt-4" style="max-width:600px;">
            <h3 class="mb-4">Confirm Order</h3>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/checkout" method="post">
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" class="form-control" value="${sessionScope.acc.firstName} ${sessionScope.acc.lastName}" readonly/>
                </div>
                <div class="form-group">
                    <label>Phone Number <span class="text-danger">*</span></label>
                    <input type="text" name="phone" class="form-control"
                           value="${sessionScope.acc.phone}" required/>
                </div>
                <div class="form-group">
                    <label>Shipping Address <span class="text-danger">*</span></label>
                    <textarea name="address" class="form-control" rows="3" required></textarea>
                </div>
                <div class="d-flex justify-content-between">
                    <a href="${pageContext.request.contextPath}/cart" class="btn btn-secondary">
                        <i class="fa fa-arrow-left"></i> Back to Cart
                    </a>
                    <button type="submit" class="btn btn-success">
                        <i class="fa fa-check"></i> Place Order
                    </button>
                </div>
            </form>
        </div>
        <jsp:include page="/Common/Footer.jsp"/>
    </body>
</html>
