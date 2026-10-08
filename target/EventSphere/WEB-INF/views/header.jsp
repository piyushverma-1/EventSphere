<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${pageTitle != null ? pageTitle : 'EventSphere'}"/> - EventSphere</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <c:if test="${sessionScope.currentUser != null}">
        <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
            <div class="container-fluid">
                <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/">
                    <i class="bi bi-calendar-event me-2"></i>EventSphere
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav me-auto">
                        <c:choose>
                            <c:when test="${sessionScope.currentUser.role == 'ADMIN'}">
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2 me-1"></i>Dashboard</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/users"><i class="bi bi-people me-1"></i>Users</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/events"><i class="bi bi-calendar-check me-1"></i>Events</a></li>
                            </c:when>
                            <c:when test="${sessionScope.currentUser.role == 'ORGANIZER'}">
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/organizer/dashboard"><i class="bi bi-speedometer2 me-1"></i>Dashboard</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/organizer/events"><i class="bi bi-calendar-plus me-1"></i>My Events</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/organizer/announcements"><i class="bi bi-megaphone me-1"></i>Announcements</a></li>
                            </c:when>
                            <c:when test="${sessionScope.currentUser.role == 'ATTENDEE'}">
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/attendee/dashboard"><i class="bi bi-speedometer2 me-1"></i>Dashboard</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/events"><i class="bi bi-calendar3 me-1"></i>Browse Events</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/attendee/tickets"><i class="bi bi-ticket-perforated me-1"></i>My Tickets</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/attendee/notifications"><i class="bi bi-bell me-1"></i>Notifications</a></li>
                            </c:when>
                        </c:choose>
                    </ul>
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                                <i class="bi bi-person-circle me-1"></i><c:out value="${sessionScope.currentUser.fullName}"/>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile"><i class="bi bi-person me-2"></i>Profile</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
    </c:if>

    <main class="container-fluid py-4">
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <c:out value="${errorMessage}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <c:out value="${successMessage}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
