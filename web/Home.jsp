<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<fmt:setLocale value="en_US"/>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Home</title>
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
        <script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet"
              integrity="sha384-wvfXpqpZZVQGK6TAh5PVlGOfQNHSoD2xbE+QkPxCAFlNEevoEH3Sl0sibVcOQVnN" crossorigin="anonymous">
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
        <jsp:include page="/Common/Menu.jsp"></jsp:include>

        <div class="w-100 mb-3">
            <img src="${pageContext.request.contextPath}/images/banner.png?v=20260611"
                 class="w-100" style="height:auto;" alt="Global sale banner"/>
        </div>

        <div class="container mt-3">
            <div class="row">
                <jsp:include page="/Common/Left.jsp"></jsp:include>

                <div class="col-sm-9">
                    <c:if test="${not empty dbError}">
                        <div class="alert alert-danger">
                            <strong>Database connection failed.</strong>
                            <div><c:out value="${dbError}"/></div>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/home" method="get" class="mb-3">
                        <input type="hidden" name="typeId" value="${param.typeId}"/>
                        <div class="row align-items-end">
                            <div class="col-md-3">
                                <label class="font-weight-bold" style="font-size:13px;">Price Range</label>
                                <select name="priceRange" class="form-control form-control-sm">
                                    <option value="">All</option>
                                    <option value="low"  ${param.priceRange == 'low'  ? 'selected' : ''}>Under 5M VND</option>
                                    <option value="mid"  ${param.priceRange == 'mid'  ? 'selected' : ''}>5M - 15M VND</option>
                                    <option value="high" ${param.priceRange == 'high' ? 'selected' : ''}>Over 15M VND</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="font-weight-bold" style="font-size:13px;">Discount</label>
                                <select name="discountFilter" class="form-control form-control-sm">
                                    <option value="">All</option>
                                    <option value="yes" ${param.discountFilter == 'yes' ? 'selected' : ''}>On sale</option>
                                    <option value="no"  ${param.discountFilter == 'no'  ? 'selected' : ''}>No discount</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="font-weight-bold" style="font-size:13px;">Sort By</label>
                                <select name="sortPrice" class="form-control form-control-sm">
                                    <option value="">Default</option>
                                    <option value="asc"  ${param.sortPrice == 'asc'  ? 'selected' : ''}>Price: Low to High</option>
                                    <option value="desc" ${param.sortPrice == 'desc' ? 'selected' : ''}>Price: High to Low</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <button type="submit" class="btn btn-primary btn-sm btn-block">Apply Filters</button>
                            </div>
                        </div>
                    </form>

                    <div class="row">
                        <c:choose>
                            <c:when test="${empty listP}">
                                <div class="col-12">
                                    <div class="alert alert-info">No products found.</div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach items="${listP}" var="o">
                                    <div class="col-12 col-md-6 col-lg-4 d-flex">
                                        <div class="card mb-3 w-100" style="min-height: 400px;">
                                            <img class="card-img-top product-img"
                                                 src="${pageContext.request.contextPath}/${o.productImage}"
                                                 alt="Product" style="height:200px; object-fit:cover;">
                                            <div class="card-body d-flex flex-column">
                                                <h4 class="card-title show_txt" style="word-break: break-word; white-space: normal; text-align:center;">
                                                    <a href="${pageContext.request.contextPath}/detail?productId=${o.productId}" title="${o.productName}">${o.productName}</a>
                                                </h4>
                                                <div class="mt-auto">
                                                    <div style="border:1px solid #ddd; padding:10px; border-radius:8px; background:#f8f9fa; text-align:center; min-height:80px; display:flex; flex-direction:column; justify-content:center;">
                                                        <c:choose>
                                                            <c:when test="${o.discount > 0}">
                                                                <div style="text-decoration: line-through; color: gray; font-size:14px;">
                                                                    <fmt:formatNumber value="${o.price}" type="number" groupingUsed="true"/> VND
                                                                </div>
                                                                <div style="color: red; font-weight: bold; font-size:18px;">
                                                                    <fmt:formatNumber value="${o.price - (o.price * o.discount / 100)}" type="number" groupingUsed="true"/> VND
                                                                </div>
                                                                <div style="font-size:12px; color:green;">-${o.discount}% OFF</div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div style="font-weight: bold; font-size:18px;">
                                                                    <fmt:formatNumber value="${o.price}" type="number" groupingUsed="true"/> VND
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/Common/Footer.jsp"></jsp:include>
    </body>
</html>
