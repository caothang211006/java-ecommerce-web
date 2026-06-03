<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Update Product</title>
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet">
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
        <script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
        <jsp:include page="/Common/Menu.jsp"/>

        <div class="container mt-4">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <h3 class="mb-4">Update product</h3>

                    <form action="${pageContext.request.contextPath}/manageProduct/update" method="post">
                        <input type="hidden" name="productId" value="${p.productId}"/>

                        <div class="form-group row">
                            <label class="col-sm-3 col-form-label font-weight-bold">Product ID</label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" value="${p.productId}" disabled/>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label class="col-sm-3 col-form-label font-weight-bold">Product Name <span class="text-danger">*</span></label>
                            <div class="col-sm-9">
                                <input type="text" name="productName" class="form-control"
                                       value="${p.productName}" required maxlength="500"/>
                            </div>
                        </div>

                        <!-- FIX: Thêm dropdown Category, pre-select category hiện tại -->
                        <div class="form-group row">
                            <label class="col-sm-3 col-form-label font-weight-bold">Category <span class="text-danger">*</span></label>
                            <div class="col-sm-9">
                                <select name="typeId" class="form-control" required>
                                    <option value="">-- Select Category --</option>
                                    <c:forEach items="${listC}" var="c">
                                        <option value="${c.typeId}"
                                                ${p.type != null && p.type.typeId == c.typeId ? 'selected' : ''}>
                                            ${c.categoryName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label class="col-sm-3 col-form-label font-weight-bold">Image Path</label>
                            <div class="col-sm-9">
                                <input type="text" name="productImage" class="form-control"
                                       value="${p.productImage}"/>
                                <c:if test="${not empty p.productImage}">
                                    <img src="${pageContext.request.contextPath}/${p.productImage}"
                                         class="mt-2" style="height:80px; object-fit:cover;" alt="preview"/>
                                </c:if>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label class="col-sm-3 col-form-label font-weight-bold">Brief</label>
                            <div class="col-sm-9">
                                <textarea name="brief" class="form-control" rows="4">${p.brief}</textarea>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label class="col-sm-3 col-form-label font-weight-bold">Unit</label>
                            <div class="col-sm-9">
                                <input type="text" name="unit" class="form-control" value="${p.unit}"/>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label class="col-sm-3 col-form-label font-weight-bold">Price <span class="text-danger">*</span></label>
                            <div class="col-sm-9">
                                <input type="number" name="price" class="form-control"
                                       value="${p.price}" required min="0"/>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label class="col-sm-3 col-form-label font-weight-bold">Discount (%)</label>
                            <div class="col-sm-9">
                                <input type="number" name="discount" class="form-control"
                                       value="${p.discount}" min="0" max="100"/>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label class="col-sm-3 col-form-label font-weight-bold">Posted Date</label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control"
                                       value="${p.postedDate}" readonly/>
                            </div>
                        </div>

                        <div class="form-group row">
                            <div class="col-sm-9 offset-sm-3">
                                <button type="submit" class="btn btn-primary mr-2">Update</button>
                                <a href="${pageContext.request.contextPath}/manageProduct"
                                   class="btn btn-secondary">Cancel</a>
                            </div>
                        </div>

                    </form>
                </div>
            </div>
        </div>

        <jsp:include page="/Common/Footer.jsp"/>
    </body>
</html>
