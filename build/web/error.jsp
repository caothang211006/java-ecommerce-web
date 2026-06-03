<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Access Denied</title>
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet">
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
        <script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
        <jsp:include page="/Common/Menu.jsp"/>

        <div class="container mt-5" style="min-height: calc(100vh - 466px);">
            <div class="row justify-content-center">
                <div class="col-md-6 text-center">
                    <div class="alert alert-danger">
                        <h4 class="alert-heading">Access Denied!</h4>
                        <p>${not empty error ? error : 'You do not have permission to access this page.'}</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">Back to Home</a>
                </div>
            </div>
        </div>

        <jsp:include page="/Common/Footer.jsp"/>
    </body>
</html>
