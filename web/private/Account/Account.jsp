<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Account Management</title>
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet">
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
        <script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
        <jsp:include page="/Common/Menu.jsp"/>

        <div class="main-content" style="min-height: calc(100vh - 440px);">
            <div class="container mt-4">

                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${error}
                        <button type="button" class="close" data-dismiss="alert">
                            <span>&times;</span>
                        </button>
                    </div>
                </c:if>

                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h3>List of account in system</h3>
                    <a href="${pageContext.request.contextPath}/account/add"
                       class="btn btn-success">
                        + Add Account
                    </a>
                </div>

                <div class="mb-3">
                    <a href="${pageContext.request.contextPath}/account"
                       class="btn btn-sm ${empty param.role ? 'btn-dark' : 'btn-outline-dark'}">All</a>
                    <a href="${pageContext.request.contextPath}/account?role=1"
                       class="btn btn-sm ${param.role == '1' ? 'btn-danger' : 'btn-outline-danger'}">Admin</a>
                    <a href="${pageContext.request.contextPath}/account?role=2"
                       class="btn btn-sm ${param.role == '2' ? 'btn-secondary' : 'btn-outline-secondary'}">Staff</a>
                    <a href="${pageContext.request.contextPath}/account?role=0"
                       class="btn btn-sm ${param.role == '0' ? 'btn-info' : 'btn-outline-info'}">Customer</a>
                </div>

                <table class="table table-bordered table-hover">
                    <thead class="thead-light">
                        <tr>
                            <th>Account</th>
                            <th>Full name</th>
                            <th>Birth day</th>
                            <th>Gender</th>
                            <th>Phone</th>
                            <th>Role in system</th>
                            <th>Segment</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${listA}" var="a">
                            <tr>
                                <td>${a.account}</td>
                                <td>${a.firstName} ${a.lastName}</td>
                                <td>${a.birthday}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${a.gender}">Male</c:when>
                                        <c:otherwise>Female</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${a.phone}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${a.roleInSystem == 1}">
                                            <span class="badge badge-danger">Administrator</span>
                                        </c:when>
                                        <c:when test="${a.roleInSystem == 2}">
                                            <span class="badge badge-secondary">Staff</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-info">Customer</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${segmentMap[a.account] == 'High income'}">
                                            <span class="badge badge-danger">${segmentMap[a.account]}</span>
                                        </c:when>
                                        <c:when test="${segmentMap[a.account] == 'Middle income'}">
                                            <span class="badge badge-primary">${segmentMap[a.account]}</span>
                                        </c:when>
                                        <c:when test="${segmentMap[a.account] == 'Low income'}">
                                            <span class="badge badge-success">${segmentMap[a.account]}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-secondary">${segmentMap[a.account]}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/account/update?id=${a.account}"
                                       class="btn btn-primary btn-sm">Update</a>

                                    <c:if test="${a.roleInSystem != 1}">
                                        <c:choose>
                                            <c:when test="${a.isUse}">
                                                <form action="${pageContext.request.contextPath}/account/toggleUse"
                                                      method="post" style="display:inline;">
                                                    <input type="hidden" name="id" value="${a.account}"/>
                                                    <input type="hidden" name="isUse" value="false"/>
                                                    <button type="submit" class="btn btn-warning btn-sm">
                                                        Deactivate
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <form action="${pageContext.request.contextPath}/account/toggleUse"
                                                      method="post" style="display:inline;">
                                                    <input type="hidden" name="id" value="${a.account}"/>
                                                    <input type="hidden" name="isUse" value="true"/>
                                                    <button type="submit" class="btn btn-success btn-sm">
                                                        Activate
                                                    </button>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>

                                        <form action="${pageContext.request.contextPath}/account/delete"
                                              method="post" style="display:inline;">
                                            <input type="hidden" name="id" value="${a.account}"/>
                                            <button type="submit" class="btn btn-danger btn-sm"
                                                    onclick="return confirm('Delete account: ${a.account}?')">
                                                Delete
                                            </button>
                                        </form>
                                    </c:if>
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
