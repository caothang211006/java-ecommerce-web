<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<fmt:setLocale value="en_US"/>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Product Detail</title>
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
        <script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
        <style>
            .gallery-wrap .img-big-wrap img {
                height: 450px;
                width: auto;
                display: inline-block;
                cursor: zoom-in;
            }

            .gallery-wrap .img-small-wrap .item-gallery {
                width: 60px;
                height: 60px;
                border: 1px solid #ddd;
                margin: 7px 2px;
                display: inline-block;
                overflow: hidden;
            }

            .gallery-wrap .img-small-wrap {
                text-align: center;
            }
            .gallery-wrap .img-small-wrap img {
                max-width: 100%;
                max-height: 100%;
                object-fit: cover;
                border-radius: 4px;
                cursor: zoom-in;
            }
            .img-big-wrap img{
                width: 100% !important;
                height: auto !important;
            }
        </style>
    </head>
    <body>
        <jsp:include page="/Common/Menu.jsp"></jsp:include>
            <div class="container">
                <div class="row">
                <jsp:include page="/Common/Left.jsp"></jsp:include>
                    <div class="col-sm-9">
                        <div class="container">
                            <div class="card">
                                <div class="row">
                                    <aside class="col-sm-5 border-right">
                                        <article class="gallery-wrap"> 
                                            <div class="img-big-wrap">
                                                <div> <a href="#"><img src="${pageContext.request.contextPath}/${detail.productImage}"></a></div>
                                        </div>
                                        <div class="img-small-wrap">
                                        </div>
                                    </article>
                                </aside>
                                <aside class="col-sm-7">
                                    <article class="card-body p-5">

                                        <div class="mb-3">
                                            <a href="javascript:history.back()" 
                                               class="btn btn-secondary">
                                                <i class="fa fa-arrow-left"></i> Back
                                            </a>
                                        </div>

                                        <h3 class="title mb-3">${detail.productName}</h3>

                                        <div class="price-detail-wrap mb-3" style="background:#f8f9fa; border-radius:10px; padding:16px 20px; display:inline-block; min-width:260px;">
                                            <c:choose>
                                                <c:when test="${detail.discount > 0}">
                                                    <div style="font-size:14px; color:#999; text-decoration:line-through; margin-bottom:2px;">
                                                        <fmt:formatNumber value="${detail.price}" type="number" groupingUsed="true"/> VND
                                                    </div>
                                                    <div style="display:flex; align-items:center; gap:10px;">
                                                        <span style="color:#e00; font-weight:700; font-size:30px; letter-spacing:0.5px;">
                                                            <fmt:formatNumber value="${detail.price - (detail.price * detail.discount / 100)}" type="number" groupingUsed="true"/> VND
                                                        </span>
                                                        <span style="background:#e00; color:#fff; font-size:13px; font-weight:600; padding:3px 9px; border-radius:20px;">
                                                            -${detail.discount}%
                                                        </span>
                                                    </div>
                                                    <div style="font-size:12px; color:green; margin-top:4px;">
                                                        You save <fmt:formatNumber value="${detail.price * detail.discount / 100}" type="number" groupingUsed="true"/> VND
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div style="font-size:30px; font-weight:700; color:#e00; letter-spacing:0.5px;">
                                                        <fmt:formatNumber value="${detail.price}" type="number" groupingUsed="true"/> VND
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>

                                        </div>
                                        <form action="${pageContext.request.contextPath}/cart" method="post" class="mb-3">
                                            <input type="hidden" name="productId" value="${detail.productId}"/>
                                            <div class="d-flex gap-2" style="gap:10px;">
                                                <button type="submit" name="action" value="add" class="btn btn-warning btn-lg">
                                                    <i class="fa fa-shopping-cart"></i> Add to Cart
                                                </button>
                                                <button type="submit" name="action" value="buyNow" class="btn btn-danger btn-lg">
                                                    <i class="fa fa-bolt"></i> Buy Now
                                                </button>
                                            </div>
                                        </form>

                                        <dl class="item-property">
                                            <dt>Description</dt>
                                            <dd><p>
                                                    ${detail.brief}
                                                </p></dd>
                                        </dl>

                                    </article>
                                </aside>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/Common/Footer.jsp"></jsp:include>
    </body>
</html>
