<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Server Error - EventSphere</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>
    <div class="container py-5">
        <div class="text-center">
            <div class="mb-4">
                <i class="bi bi-exclamation-octagon display-1 text-danger"></i>
            </div>
            <h1 class="display-1 fw-bold">500</h1>
            <h2 class="h4 mb-3">Internal Server Error</h2>
            <p class="text-muted">Something went wrong on our end. Please try again later.</p>
            <c:if test="${pageContext.errorData != null}">
                <div class="alert alert-light">
                    <small>Error: ${pageContext.errorData.statusCode}</small>
                </div>
            </c:if>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary btn-lg mt-3">
                <i class="bi bi-house-door me-2"></i>Go to Homepage
            </a>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>