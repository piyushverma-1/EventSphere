<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Dashboard"/>
<%@ include file="../header.jsp" %>

<div class="row mb-4">
    <div class="col-12">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h2 class="h4 fw-bold mb-0">Attendee Dashboard</h2>
                <p class="text-muted">Welcome back, <c:out value="${sessionScope.currentUser.fullName}"/>!</p>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/events" class="btn btn-outline-primary">
                    <i class="bi bi-calendar3 me-2"></i>Browse Events
                </a>
                <a href="${pageContext.request.contextPath}/attendee/tickets" class="btn btn-outline-secondary">
                    <i class="bi bi-ticket-perforated me-2"></i>My Tickets
                </a>
            </div>
        </div>
    </div>
</div>

<!-- Stats Cards -->
<div class="row g-3 mb-4">
    <div class="col-md-6 col-lg-3">
        <div class="stat-card">
            <div class="stat-label">Total Registrations</div>
            <div class="stat-value">${totalRegistrations}</div>
        </div>
    </div>
    <div class="col-md-6 col-lg-3">
        <div class="stat-card success">
            <div class="stat-label">Upcoming Events</div>
            <div class="stat-value">${upcomingCount}</div>
        </div>
    </div>
    <div class="col-md-6 col-lg-3">
        <div class="stat-card warning">
            <div class="stat-label">Past Events</div>
            <div class="stat-value">${pastCount}</div>
        </div>
    </div>
    <div class="col-md-6 col-lg-3">
        <div class="stat-card danger">
            <div class="stat-label">Unread Notifications</div>
            <div class="stat-value">${unreadCount}</div>
        </div>
    </div>
</div>

<!-- Upcoming Events -->
<div class="row mb-4">
    <div class="col-12">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="mb-0">Upcoming Events</h5>
            <a href="${pageContext.request.contextPath}/attendee/tickets" class="btn btn-sm btn-outline-primary">View All Tickets</a>
        </div>
        <c:if test="${not empty upcomingRegistrations}">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Event</th>
                            <th>Date</th>
                            <th>Ticket Type</th>
                            <th>Booking Ref</th>
                            <th class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${upcomingRegistrations}" var="reg">
                            <tr>
                                <td><strong><c:out value="${reg.eventTitle}"/></strong></td>
                                <td>${reg.formattedCreatedAt}</td>
                                <td><c:out value="${reg.ticketTypeName}"/></td>
                                <td><code><c:out value="${reg.bookingReference}"/></code></td>
                                <td class="text-end">
                                    <a href="${pageContext.request.contextPath}/attendee/tickets/${reg.id}" class="btn btn-sm btn-outline-primary">View Ticket</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
        <c:if test="${empty upcomingRegistrations}">
            <div class="text-center py-4 text-muted">
                <i class="bi bi-calendar-x display-4"></i>
                <p class="mt-2">No upcoming events</p>
                <a href="${pageContext.request.contextPath}/events" class="btn btn-primary mt-2">Browse Events</a>
            </div>
        </c:if>
    </div>
</div>

<!-- Recent Notifications -->
<div class="row mb-4">
    <div class="col-12">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="mb-0">Upcoming Events (Available for Registration)</h5>
            <a href="${pageContext.request.contextPath}/events" class="btn btn-sm btn-outline-primary">View All Events</a>
        </div>
        <c:if test="${not empty allUpcomingEvents}">
            <div class="row event-grid">
                <c:forEach items="${allUpcomingEvents}" var="event">
                    <div class="col-md-6 col-lg-4 mb-3">
                        <div class="card event-card h-100">
                            <div class="event-image">
                                <i class="bi bi-calendar-event"></i>
                            </div>
                            <div class="card-body d-flex flex-column">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <h6 class="card-title mb-0"><c:out value="${event.title}"/></h6>
                                    <span class="badge bg-success status-badge">
                                        <i class="bi bi-check-circle-fill me-1"></i>Open
                                    </span>
                                </div>
                                <p class="card-text text-muted small"><c:out value="${event.description}"/></p>
                                <div class="mb-2">
                                    <small class="text-muted">
                                        <i class="bi bi-calendar me-1"></i>
                                        ${event.formattedEventDateTime}
                                    </small>
                                </div>
                                <div class="mb-2">
                                    <small class="text-muted">
                                        <i class="bi bi-geo-alt me-1"></i><c:out value="${event.venue}"/>
                                    </small>
                                </div>
                                <div class="mt-auto pt-2">
                                    <a href="${pageContext.request.contextPath}/events/${event.id}" class="btn btn-outline-primary w-100">
                                        <i class="bi bi-ticket-perforated me-1"></i>Register
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
        <c:if test="${empty allUpcomingEvents}">
            <div class="text-center py-4 text-muted">
                <i class="bi bi-calendar-x display-4"></i>
                <p class="mt-2">No upcoming events available</p>
            </div>
        </c:if>
    </div>
</div>

<!-- Recent Notifications -->
<div class="row">
    <div class="col-12">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="mb-0">Recent Notifications</h5>
            <a href="${pageContext.request.contextPath}/attendee/notifications" class="btn btn-sm btn-outline-primary">View All</a>
        </div>
        <c:if test="${not empty notifications}">
            <div class="list-group">
                <c:forEach items="${notifications}" var="notif">
                    <a href="${pageContext.request.contextPath}/attendee/notifications/${notif.id}" class="list-group-item list-group-item-action">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <h6 class="mb-1"><c:out value="${notif.title}"/></h6>
                                <p class="mb-0 text-muted small"><c:out value="${fn:substring(notif.message, 0, 100)}"/>...</p>
                            </div>
                            <div class="text-end">
                                <small class="text-muted">${notif.formattedCreatedAt}</small>
                                <c:if test="${!notif.isRead}">
                                    <span class="badge bg-primary ms-2">New</span>
                                </c:if>
                            </div>
                        </div>
                    </a>
                </c:forEach>
            </div>
        </c:if>
        <c:if test="${empty notifications}">
            <div class="text-center py-4 text-muted">
                <i class="bi bi-bell-slash display-4"></i>
                <p class="mt-2">No new notifications</p>
            </div>
        </c:if>
    </div>
</div>

<%@ include file="../footer.jsp" %>
