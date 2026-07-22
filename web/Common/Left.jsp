<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="en_US"/>
<div class="col-sm-3">
    <div class="card bg-light mb-3">
        <div class="card-header bg-primary text-white text-uppercase">
            <i class="fa fa-list"></i> Categories
        </div>
        <ul class="list-group category_block">
            <c:forEach items="${listC}" var="o">
                <li class="list-group-item ${tag == o.typeId ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/home?typeId=${o.typeId}"
                       style="${tag == o.typeId ? 'color:white;' : ''} overflow:hidden; text-overflow:ellipsis; white-space:nowrap; display:block;">
                        <c:choose>
                            <c:when test="${o.typeId == 1}">Kitchenware</c:when>
                            <c:when test="${o.typeId == 2}">Home Appliances</c:when>
                            <c:when test="${o.typeId == 3}">Home Decor</c:when>
                            <c:when test="${o.typeId == 4}">Fitness Equipment</c:when>
                            <c:when test="${o.typeId == 5}">Smart Devices</c:when>
                            <c:when test="${o.typeId == 6}">Fashion Apparel</c:when>
                            <c:otherwise>${o.categoryName}</c:otherwise>
                        </c:choose>
                    </a>
                </li>
            </c:forEach>
        </ul>
    </div>

    <div class="card bg-light mb-3">
        <div class="card-header bg-success text-white text-uppercase">Latest Product</div>
        <div class="card-body">
            <c:choose>
                <c:when test="${empty last}">
                    <p class="text-muted text-center">No products available.</p>
                </c:when>
                <c:otherwise>
                    <img class="img-fluid" src="${pageContext.request.contextPath}/${last.productImage}" />
                    <h5 class="card-title" style="word-break: break-word; white-space: normal;">
                        ${last.productName}
                    </h5>
                    <p class="card-text" style="word-break: break-word; white-space: normal;">
                        ${last.brief}
                    </p>
                    <p class="bloc_left_price">
                        <fmt:formatNumber value="${last.price}" type="number" groupingUsed="true"/> VND
                    </p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <c:if test="${not empty viewedProductList}">
        <div class="card bg-light mb-3">
            <div class="card-header bg-warning text-white text-uppercase">
                <i class="fa fa-history"></i> Recently Viewed
            </div>
            <ul class="list-group list-group-flush">
                <c:forEach items="${viewedProductList}" var="vp" end="4">
                    <li class="list-group-item p-2">
                        <a href="${pageContext.request.contextPath}/detail?productId=${vp.productId}"
                           class="d-flex align-items-center" style="text-decoration:none; color:inherit;">
                            <img src="${pageContext.request.contextPath}/${vp.productImage}"
                                 style="width:45px; height:45px; object-fit:cover; border-radius:4px; margin-right:8px; flex-shrink:0;">
                            <div style="overflow:hidden;">
                                <div style="font-size:12px; font-weight:600; line-height:1.3; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">${vp.productName}</div>
                                <div style="font-size:12px; color:#e00; font-weight:bold;">
                                    <fmt:formatNumber value="${vp.discount > 0 ? vp.price - (vp.price * vp.discount / 100) : vp.price}" type="number" groupingUsed="true"/> VND
                                </div>
                            </div>
                        </a>
                    </li>
                </c:forEach>
            </ul>
        </div>
    </c:if>
</div>
