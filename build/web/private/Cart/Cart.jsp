<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Shopping Cart</title>
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet">
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
        <script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
        <jsp:include page="/Common/Menu.jsp"/>

        <div class="container mt-4" style="min-height: calc(100vh - 440px);">
            <h3 class="mb-4"><i class="fa fa-shopping-cart"></i> Shopping Cart</h3>

            <c:choose>
                <c:when test="${empty cartProducts}">
                    <div class="alert alert-info">
                        Your cart is empty. <a href="${pageContext.request.contextPath}/home">Continue shopping</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="table table-bordered table-hover">
                        <thead class="thead-dark">
                            <tr>
                                <th>Image</th>
                                <th>Product</th>
                                <th>Unit Price</th>
                                <th>Quantity</th>
                                <th>Subtotal</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${cartProducts}" var="p">
                                <c:set var="finalPrice" value="${p.discount > 0 ? p.price - (p.price * p.discount / 100) : p.price}"/>
                                <c:set var="qty" value="${cart[p.productId]}"/>
                                <tr>
                                    <td style="width:80px;">
                                        <img src="${pageContext.request.contextPath}/${p.productImage}"
                                             style="width:60px; height:60px; object-fit:cover; border-radius:4px;">
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/detail?productId=${p.productId}">
                                            ${p.productName}
                                        </a>
                                    </td>
                                    <td style="color:#e00; font-weight:bold;">
                                        <fmt:formatNumber value="${finalPrice}" type="number" groupingUsed="true"/> đ
                                        <c:if test="${p.discount > 0}">
                                            <br/><small style="color:green;">-${p.discount}%</small>
                                        </c:if>
                                    </td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/cart" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="decrease"/>
                                            <input type="hidden" name="productId" value="${p.productId}"/>
                                            <button type="submit" class="btn btn-outline-secondary btn-sm">-</button>
                                        </form>
                                        <span class="mx-2 font-weight-bold">${qty}</span>
                                        <form action="${pageContext.request.contextPath}/cart" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="increase"/>
                                            <input type="hidden" name="productId" value="${p.productId}"/>
                                            <button type="submit" class="btn btn-outline-secondary btn-sm">+</button>
                                        </form>
                                    </td>
                                    <td style="font-weight:bold;">
                                        <fmt:formatNumber value="${finalPrice * qty}" type="number" groupingUsed="true"/> đ
                                    </td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/cart" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="remove"/>
                                            <input type="hidden" name="productId" value="${p.productId}"/>
                                            <button type="submit" class="btn btn-danger btn-sm">
                                                <i class="fa fa-trash"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="4" class="text-right font-weight-bold">Total:</td>
                                <td colspan="2" style="color:#e00; font-weight:bold; font-size:20px;">
                                    <fmt:formatNumber value="${total}" type="number" groupingUsed="true"/> đ
                                </td>
                            </tr>
                        </tfoot>
                    </table>

                    <div class="d-flex justify-content-between mt-3 mb-5">
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">
                            <i class="fa fa-arrow-left"></i> Continue Shopping
                        </a>
                        <a href="${pageContext.request.contextPath}/checkout" class="btn btn-success">
                            <i class="fa fa-credit-card"></i> Đặt hàng
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <jsp:include page="/Common/Footer.jsp"/>
    </body>
</html>
