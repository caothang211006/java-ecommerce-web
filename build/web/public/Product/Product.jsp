<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Product Management</title>
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet">
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
        <script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
        <jsp:include page="/Common/Menu.jsp"/>

        <div class="container mt-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h3>List of products</h3>
                <a href="${pageContext.request.contextPath}/manageProduct/add"
                   class="btn btn-success">
                    + Add Product
                </a>
            </div>

            <table class="table table-bordered table-hover">
                <thead class="thead-light">
                    <tr>
                        <th>ID</th>
                        <th>Image</th>
                        <th>Product Name</th>
                        <th>Unit</th>
                        <th>Price</th>
                        <th>Discount</th>
                        <th>Posted Date</th>
                        <th>Added by</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${listP}" var="p">
                        <tr>
                            <td>${p.productId}</td>
                            <td>
                                <img src="${pageContext.request.contextPath}/${p.productImage}"
                                     style="width:60px; height:60px; object-fit:cover;"
                                     alt="img"/>
                            </td>
                            <td>${p.productName}</td>
                            <td>${p.unit}</td>
                            <td><fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/> đ</td>
                            <td>${p.discount}%</td>
                            <td>${p.postedDate}</td>
                            <td>${p.account.account}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/manageProduct/update?id=${p.productId}"
                                   class="btn btn-primary btn-sm">Update</a>

                                <%-- FIX: POST form thay vì GET link để tránh xóa nhầm --%>
                                <form action="${pageContext.request.contextPath}/manageProduct/delete"
                                      method="post" style="display:inline;"
                                      onsubmit="return confirm('Delete product: ${p.productName}?')">
                                    <input type="hidden" name="id" value="${p.productId}"/>
                                    <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <jsp:include page="/Common/Footer.jsp"/>
    </body>
</html>
