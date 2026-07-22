<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="navbar navbar-expand-md navbar-dark shadow" style="background-color:#343a40;">   
    <div class="container">

        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
            <img src="${pageContext.request.contextPath}/images/logo.png"
                 alt="Logo"
                 style="height:40px;">
        </a>

        <c:if test="${sessionScope.acc != null}">
            <span class="navbar-text text-white ml-2">
                Welcome <b>${sessionScope.acc.firstName} ${sessionScope.acc.lastName}</b>
                <c:choose>
                    <c:when test="${sessionScope.acc.roleInSystem == 1}">
                        <span class="badge badge-danger ml-1">Admin</span>
                    </c:when>
                    <c:when test="${sessionScope.acc.roleInSystem == 2}">
                        <span class="badge badge-light ml-1">Staff</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge badge-info ml-1">Customer</span>
                    </c:otherwise>
                </c:choose>
            </span>
        </c:if>

        <button class="navbar-toggler" type="button"
                data-toggle="collapse"
                data-target="#navbarsExampleDefault">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarsExampleDefault">

            <ul class="navbar-nav mx-auto">
                <c:if test="${sessionScope.acc.roleInSystem == 1}">
                    <li class="nav-item">
                        <a class="btn btn-light btn-sm mx-1"
                           href="${pageContext.request.contextPath}/account">Account</a>
                    </li>
                    <li class="nav-item">
                        <a class="btn btn-light btn-sm mx-1"
                           href="${pageContext.request.contextPath}/account/orders">Orders</a>
                    </li>
                </c:if>

                <c:if test="${sessionScope.acc.roleInSystem == 1 || sessionScope.acc.roleInSystem == 2}">
                    <li class="nav-item">
                        <a class="btn btn-light btn-sm mx-1"
                           href="${pageContext.request.contextPath}/manageCategory">Category</a>
                    </li>

                    <li class="nav-item">
                        <a class="btn btn-light btn-sm mx-1"
                           href="${pageContext.request.contextPath}/manageProduct">Product</a>
                    </li>
                </c:if>
            </ul>

            <ul class="navbar-nav align-items-center">

                <li class="nav-item mr-2">
                    <form action="${pageContext.request.contextPath}/search" method="post" class="form-inline">
                        <div class="input-group input-group-sm">
                            <input name="txt" type="text" class="form-control">
                            <div class="input-group-append">
                                <button type="submit" class="btn btn-light">
                                    <i class="fa fa-search"></i>
                                </button>
                            </div>
                        </div>
                    </form>
                </li>

                <li class="nav-item mr-2">
                    <a class="btn btn-success btn-sm" href="${pageContext.request.contextPath}/cart">
                        <i class="fa fa-shopping-cart"></i> Cart
                        <c:set var="cartSize" value="0"/>
                        <c:if test="${not empty sessionScope.cart}">
                            <c:forEach items="${sessionScope.cart}" var="entry">
                                <c:set var="cartSize" value="${cartSize + entry.value}"/>
                            </c:forEach>
                        </c:if>
                        <span class="badge badge-light">${cartSize}</span>
                    </a>
                </li>

                <c:if test="${sessionScope.acc != null}">
                    <li class="nav-item mr-2">
                        <a class="btn btn-outline-light btn-sm"
                           href="${pageContext.request.contextPath}/orderHistory">
                            <i class="fa fa-list"></i> Orders
                        </a>
                    </li>
                </c:if>

                <c:if test="${sessionScope.acc == null}">
                    <li class="nav-item">
                        <a class="btn btn-warning btn-sm"
                           href="${pageContext.request.contextPath}/login">Login</a>
                    </li>
                </c:if>

                <c:if test="${sessionScope.acc != null}">
                    <li class="nav-item">
                        <a class="btn btn-danger btn-sm"
                           href="${pageContext.request.contextPath}/logout">Logout</a>
                    </li>
                </c:if>

            </ul>

        </div>
    </div>
</nav>
