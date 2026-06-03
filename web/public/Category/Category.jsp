<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Category Management</title>
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet">
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
        <script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
        <jsp:include page="/Common/Menu.jsp"/>

        <div class="main-content" style="min-height: calc(100vh - 440px);">
            <div class="container mt-4">

                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h3>List of categories</h3>
                    <a href="${pageContext.request.contextPath}/manageCategory/add"
                       class="btn btn-success">
                        + Add Category
                    </a>
                </div>

                <table class="table table-bordered table-hover">
                    <thead class="thead-light">
                        <tr>
                            <th>#</th>
                            <th>Category Name</th>
                            <th>Memo</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${listC}" var="c">
                            <tr>
                                <td>${c.typeId}</td>
                                <td>${c.categoryName}</td>
                                <td>${c.memo}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/manageCategory/update?id=${c.typeId}"
                                       class="btn btn-primary btn-sm">Update</a>
                                    <form action="${pageContext.request.contextPath}/manageCategory/delete"
                                          method="post" style="display:inline;"
                                          onsubmit="return confirm('Delete category: ${c.categoryName}?')">
                                        <input type="hidden" name="id" value="${c.typeId}"/>
                                        <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <jsp:include page="/Common/Footer.jsp"/>
    </body>
</html>
