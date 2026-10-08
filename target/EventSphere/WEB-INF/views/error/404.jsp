<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Not Found - EventSphere</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>
    <div class="container py-5">
        <div class="text-center">
            <div class="mb-4">
                <i class="bi bi-exclamation-diamond display-1 text-warning"></i>
            </div>
            <h1 class="display-1 fw-bold">404</h1>
            <h2 class="h4 mb-3">Page Not Found</h2>
            <p class="text-muted">The page you're looking for doesn't exist or has been moved.</p>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary btn-lg mt-3">
                <i class="bi bi-house-door me-2"></i>Go to Homepage
            </a>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>