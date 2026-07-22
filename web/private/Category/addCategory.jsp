<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add New Category</title>
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
                    <h3 class="mb-4">Add new category</h3>

                    <form action="${pageContext.request.contextPath}/manageCategory/add" method="post">

                        <div class="form-group row">
                            <label class="col-sm-4 col-form-label font-weight-bold">
                                Category Name <span class="text-danger">*</span>
                            </label>
                            <div class="col-sm-8">
                                <input type="text" name="categoryName" class="form-control"
                                       placeholder="Enter category name" required maxlength="88"/>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label class="col-sm-4 col-form-label font-weight-bold">Memo</label>
                            <div class="col-sm-8">
                                <textarea name="memo" class="form-control" rows="4"
                                          placeholder="Enter description (optional)"></textarea>
                            </div>
                        </div>

                        <div class="form-group row">
                            <div class="col-sm-8 offset-sm-4">
                                <button type="submit" class="btn btn-primary mr-2">Submit</button>
                                <a href="${pageContext.request.contextPath}/manageCategory"
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
