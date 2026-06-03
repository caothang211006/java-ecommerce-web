<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Lịch sử đơn hàng</title>
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet">
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
        <script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet"/>
    </head>
    <body>
        <jsp:include page="/Common/Menu.jsp"/>
        <div class="container mt-4" style="min-height: calc(100vh - 440px);">
            <h3 class="mb-4">Lịch sử đơn hàng</h3>

            <c:if test="${param.success == '1'}">
                <div class="alert alert-success">Đặt hàng thành công!</div>
            </c:if>

            <!-- Chi tiết đơn hàng -->
            <c:if test="${not empty details}">
                <div class="card mb-4">
                    <div class="card-header font-weight-bold">
                        Chi tiết đơn #${orderId}
                    </div>
                    <div class="card-body p-0">
                        <table class="table table-bordered mb-0">
                            <thead class="thead-light">
                                <tr>
                                    <th>Ảnh</th>
                                    <th>Sản phẩm</th>
                                    <th>Giá</th>
                                    <th>Giảm</th>
                                    <th>SL</th>
                                    <th>Thành tiền</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:set var="total" value="0"/>
                                <c:forEach items="${details}" var="d">
                                    <tr>
                                        <td><img src="${pageContext.request.contextPath}/${d.productImage}" style="height:50px; object-fit:cover;"/></td>
                                        <td>${d.productName}</td>
                                        <td><fmt:formatNumber value="${d.price}" type="number"/> đ</td>
                                        <td>${d.discount}%</td>
                                        <td>${d.quantity}</td>
                                        <td><fmt:formatNumber value="${d.finalPrice}" type="number"/> đ</td>
                                    </tr>
                                    <c:set var="total" value="${total + d.finalPrice}"/>
                                </c:forEach>
                                <tr class="font-weight-bold">
                                    <td colspan="5" class="text-right">Tổng cộng:</td>
                                    <td style="color:#e00;"><fmt:formatNumber value="${total}" type="number"/> đ</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:if>

            <!-- Danh sách đơn hàng -->
            <c:choose>
                <c:when test="${empty orders}">
                    <div class="alert alert-info">Bạn chưa có đơn hàng nào.</div>
                </c:when>
                <c:otherwise>
                    <table class="table table-bordered table-hover">
                        <thead class="thead-light">
                            <tr>
                                <th>#</th>
                                <th>Ngày đặt</th>
                                <th>Địa chỉ</th>
                                <th>SĐT</th>
                                <th>Trạng thái</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${orders}" var="o">
                                <tr>
                                    <td>${o.orderId}</td>
                                    <td>${o.orderDate}</td>
                                    <td>${o.address}</td>
                                    <td>${o.phone}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${o.status == 0}"><span class="badge badge-warning">Chờ xử lý</span></c:when>
                                            <c:when test="${o.status == 1}"><span class="badge badge-primary">Đang giao</span></c:when>
                                            <c:when test="${o.status == 2}"><span class="badge badge-success">Hoàn thành</span></c:when>
                                            <c:when test="${o.status == 3}"><span class="badge badge-danger">Đã hủy</span></c:when>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/orderHistory?orderId=${o.orderId}"
                                           class="btn btn-info btn-sm">
                                             Chi tiết
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
        <jsp:include page="/Common/Footer.jsp"/>
    </body>
</html>
