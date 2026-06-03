<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Update Account</title>
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
                    <h3 class="mb-4">Update account</h3>

                    <form action="${pageContext.request.contextPath}/account/update" method="post">
                        <input type="hidden" name="account" value="${editAcc.account}"/>

                        <div class="form-group row">
                            <label class="col-sm-4 col-form-label font-weight-bold">Account</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" value="${editAcc.account}" disabled/>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label class="col-sm-4 col-form-label font-weight-bold">Password</label>
                            <div class="col-sm-8">
                                <input type="password" name="pass" class="form-control"
                                       placeholder="Leave blank to keep current password" maxlength="20"/>
                                <small class="text-muted">Leave blank to keep the current password.</small>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label class="col-sm-4 col-form-label font-weight-bold">Last name</label>
                            <div class="col-sm-8">
                                <input type="text" name="lastName" class="form-control"
                                       value="${editAcc.lastName}" maxlength="50"/>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label class="col-sm-4 col-form-label font-weight-bold">First name</label>
                            <div class="col-sm-8">
                                <input type="text" name="firstName" class="form-control"
                                       value="${editAcc.firstName}" required maxlength="30"/>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label class="col-sm-4 col-form-label font-weight-bold">Phone number</label>
                            <div class="col-sm-8">
                                <input type="text" name="phone" class="form-control"
                                       value="${editAcc.phone}" maxlength="20"/>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label class="col-sm-4 col-form-label font-weight-bold">Birth day</label>
                            <div class="col-sm-8">
                                <input type="date" name="birthday" class="form-control"
                                       value="${editAcc.birthday}"/>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label class="col-sm-4 col-form-label font-weight-bold">Gender</label>
                            <div class="col-sm-8 d-flex align-items-center">
                                <div class="form-check mr-4">
                                    <input class="form-check-input" type="radio"
                                           name="gender" value="true"
                                           ${editAcc.gender ? 'checked' : ''}/>
                                    <label class="form-check-label">Male</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio"
                                           name="gender" value="false"
                                           ${editAcc.gender ? '' : 'checked'}/>
                                    <label class="form-check-label">Female</label>
                                </div>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label class="col-sm-4 col-form-label font-weight-bold">Role in system</label>
                            <div class="col-sm-8">
                                <select name="role" class="form-control">
                                    <option value="1" ${editAcc.roleInSystem == 1 ? 'selected' : ''}>Administrator</option>
                                    <option value="2" ${editAcc.roleInSystem == 2 ? 'selected' : ''}>Staff</option>
                                    <option value="0" ${editAcc.roleInSystem == 0 ? 'selected' : ''}>Customer</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group row">
                            <div class="col-sm-8 offset-sm-4">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox"
                                           name="isUse" value="true" id="isUseCheck"
                                           ${editAcc.isUse ? 'checked' : ''}/>
                                    <label class="form-check-label" for="isUseCheck">Is active</label>
                                </div>
                            </div>
                        </div>

                        <div class="form-group row">
                            <div class="col-sm-8 offset-sm-4">
                                <button type="submit" class="btn btn-primary mr-2">Update</button>
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
