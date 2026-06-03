<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.3.1/css/all.css">
        <link href="css/login.css" rel="stylesheet" type="text/css"/>
        <title>Login Form</title>
    </head>
    <body>
        <div id="logreg-forms">
            <form class="form-signin" action="${pageContext.request.contextPath}/login" method="post">
                <h1 class="h3 mb-3 font-weight-normal" style="text-align: center">Sign in</h1>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">
                        ${error}
                    </div>
                </c:if>

                <c:if test="${param.error == 'duplicate'}">
                    <div class="alert alert-warning" role="alert">
                        Your account has been logged in on another browser!
                    </div>
                </c:if>

                <input name="user" type="text" class="form-control" placeholder="Username" required autofocus/>
                <input name="pass" type="password" class="form-control" placeholder="Password" required/>

                <button class="btn btn-success btn-block mt-3" type="submit">
                    <i class="fas fa-sign-in-alt"></i> Sign in
                </button>
                <hr>
            </form>
        </div>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    </body>
</html>
