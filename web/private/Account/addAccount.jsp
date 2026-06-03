<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add New Account</title>
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet">
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
        <script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
        <jsp:include page="/Common/Menu.jsp"/>

        <div class="container mt-4">
            <div class="row justify-content-center">
                <div class="col-md-7">
                    <h3 class="mb-4">Add new account</h3>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/account/add" method="post">

                        <div class="form-group row">
                            <label class="col-sm-4 col-form-label font-weight-bold">Account</label>
                            <div class="col-sm-8">
                                <input type="text" name="account" class="form-control"
                                       placeholder="Enter account" required maxlength="20"/>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label class="col-sm-4 col-form-label font-weight-bold">Password</label>
                            <div class="col-sm-8">
                                <input type="password" name="pass" class="form-control"
                                       placeholder="Enter password" required maxlength="20"/>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label class="col-sm-4 col-form-label font-weight-bold">Last name</label>
                            <div class="col-sm-8">
                                <input type="text" name="lastName" class="form-control"
                                       placeholder="Last name" maxlength="50"/>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label class="col-sm-4 col-form-label font-weight-bold">First name</label>
                            <div class="col-sm-8">
                                <input type="text" name="firstName" class="form-control"
                                       placeholder="First name" required maxlength="30"/>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label class="col-sm-4 col-form-label font-weight-bold">Phone number</label>
                            <div class="col-sm-8">
                                <input type="text" name="phone" class="form-control"
                                       placeholder="Phone number" maxlength="20"/>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label class="col-sm-4 col-form-label font-weight-bold">Birth day</label>
                            <div class="col-sm-8">
                                <input type="date" name="birthday" class="form-control"/>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label class="col-sm-4 col-form-label font-weight-bold">Gender</label>
                            <div class="col-sm-8 d-flex align-items-center">
                                <div class="form-check mr-4">
                                    <input class="form-check-input" type="radio"
                                           name="gender" value="true" checked/>
                                    <label class="form-check-label">Male</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio"
                                           name="gender" value="false"/>
                                    <label class="form-check-label">Female</label>
                                </div>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label class="col-sm-4 col-form-label font-weight-bold">Role in system</label>
                            <div class="col-sm-8">
                                <select name="role" class="form-control">
                                    <option value="1">Administrator</option>
                                    <option value="2">Staff</option>
                                    <option value="0" selected>Customer</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group row">
                            <div class="col-sm-8 offset-sm-4">
                                <button type="submit" class="btn btn-primary mr-2">Submit</button>
                                <a href="${pageContext.request.contextPath}/account"
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
