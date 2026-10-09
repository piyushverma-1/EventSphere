<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Home"/>

<div class="row mb-5">
    <div class="col-12 text-center">
        <h1 class="display-4 fw-bold text-primary mb-3">Discover Amazing Events</h1>
        <p class="lead text-muted">Find and register for events you'll love. From conferences to concerts, we've got you covered.</p>
    </div>
</div>

<c:choose>
    <c:when test="${sessionScope.currentUser != null && sessionScope.currentUser.role == 'ATTENDEE'}">
        <div class="row mb-4">
            <div class="col-12">
                <a href="${pageContext.request.contextPath}/events" class="btn btn-primary btn-lg">
                    <i class="bi bi-calendar3 me-2"></i>Browse All Events
                </a>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="row mb-4">
            <div class="col-12 text-center">
                <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-lg me-3">
                    <i class="bi bi-person-plus me-2"></i>Get Started Free
                </a>
                <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-primary btn-lg">
                    <i class="bi bi-box-arrow-in-right me-2"></i>Login
                </a>
            </div>
        </div>
    </c:otherwise>
</c:choose>

<c:if test="${not empty upcomingEvents}">
    <div class="row mb-4">
        <div class="col-12">
            <h2 class="h4 fw-bold mb-3">Upcoming Events</h2>
        </div>
    </div>
    <div class="row event-grid">
        <c:forEach items="${upcomingEvents}" var="event">
            <div class="col">
                <div class="card event-card h-100">
                    <div class="event-image">
                        <i class="bi bi-calendar-event"></i>
                    </div>
                    <div class="card-body d-flex flex-column">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <h5 class="card-title mb-0"><c:out value="${event.title}"/></h5>
                            <span class="badge bg-approved status-badge">
                                <i class="bi bi-check-circle-fill me-1"></i>Approved
                            </span>
                        </div>
                        <p class="card-text text-muted small"><c:out value="${event.description}"/></p>
                        <div class="mb-2">
                            <small class="text-muted">
                                <i class="bi bi-calendar me-1"></i>
                                <c:out value="${event.formattedEventDateTime}"/>
                            </small>
                        </div>
                        <div class="mb-2">
                            <small class="text-muted">
                                <i class="bi bi-geo-alt me-1"></i><c:out value="${event.venue}"/>
                            </small>
                        </div>
                        <div class="mt-auto pt-2">
                            <a href="${pageContext.request.contextPath}/events/${event.id}" class="btn btn-outline-primary w-100">
                                View Details
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</c:if>

<c:if test="${empty upcomingEvents}">
    <div class="text-center py-5">
        <i class="bi bi-calendar-x display-1 text-muted"></i>
        <h3 class="mt-3 text-muted">No upcoming events</h3>
        <p class="text-muted">Check back soon for new events!</p>
    </div>
</c:if>

<!-- Features Section -->
<div class="row mt-5 pt-5 border-top">
    <div class="col-md-4 mb-4">
        <div class="card h-100 border-0 shadow-sm">
            <div class="card-body text-center p-4">
                <div class="bg-primary bg-opacity-10 text-primary rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 60px; height: 60px;">
                    <i class="bi bi-shield-check fs-3"></i>
                </div>
                <h5 class="card-title">Secure Registration</h5>
                <p class="card-text text-muted">Your bookings are protected with unique confirmation codes and digital tickets.</p>
            </div>
        </div>
    </div>
    <div class="col-md-4 mb-4">
        <div class="card h-100 border-0 shadow-sm">
            <div class="card-body text-center p-4">
                <div class="bg-success bg-opacity-10 text-success rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 60px; height: 60px;">
                    <i class="bi bi-ticket-perforated fs-3"></i>
                </div>
                <h5 class="card-title">Digital Tickets</h5>
                <p class="card-text text-muted">Receive QR-coded tickets instantly. No printing required - just show on your phone.</p>
            </div>
        </div>
    </div>
    <div class="col-md-4 mb-4">
        <div class="card h-100 border-0 shadow-sm">
            <div class="card-body text-center p-4">
                <div class="bg-warning bg-opacity-10 text-warning rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 60px; height: 60px;">
                    <i class="bi bi-bell fs-3"></i>
                </div>
                <h5 class="card-title">Event Updates</h5>
                <p class="card-text text-muted">Get real-time notifications about event changes, announcements, and reminders.</p>
            </div>
        </div>
    </div>
</div>
