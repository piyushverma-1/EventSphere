<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Organizer Dashboard"/>
<%@ include file="../header.jsp" %>

<div class="row mb-4">
    <div class="col-12">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h2 class="h4 fw-bold mb-0">Organizer Dashboard</h2>
                <p class="text-muted">Manage your events and track performance</p>
            </div>
            <a href="${pageContext.request.contextPath}/organizer/events/create" class="btn btn-primary">
                <i class="bi bi-calendar-plus me-2"></i>Create Event
            </a>
        </div>
    </div>
</div>

<!-- Stats Cards -->
<div class="row g-3 mb-4">
    <div class="col-md-6 col-lg-3">
        <div class="stat-card">
            <div class="stat-label">Total Events</div>
            <div class="stat-value">${totalEvents}</div>
        </div>
    </div>
    <div class="col-md-6 col-lg-3">
        <div class="stat-card warning">
            <div class="stat-label">Pending Approval</div>
            <div class="stat-value">${pendingEvents}</div>
        </div>
    </div>
    <div class="col-md-6 col-lg-3">
        <div class="stat-card success">
            <div class="stat-label">Approved Events</div>
            <div class="stat-value">${approvedEvents}</div>
        </div>
    </div>
    <div class="col-md-6 col-lg-3">
        <div class="stat-card danger">
            <div class="stat-label">Cancelled Events</div>
            <div class="stat-value">${cancelledEvents}</div>
        </div>
    </div>
</div>

<!-- Registration Stats -->
<div class="row g-3 mb-4">
    <div class="col-md-6 col-lg-3">
        <div class="stat-card">
            <div class="stat-label">Total Registrations</div>
            <div class="stat-value">${totalRegistrations}</div>
        </div>
    </div>
    <div class="col-md-6 col-lg-3">
        <div class="stat-card success">
            <div class="stat-label">Confirmed</div>
            <div class="stat-value">${confirmedRegistrations}</div>
        </div>
    </div>
    <div class="col-md-6 col-lg-3">
        <div class="stat-card">
            <div class="stat-label">Total Revenue</div>
            <div class="stat-value">$${totalRevenue}</div>
        </div>
    </div>
    <div class="col-md-6 col-lg-3">
        <div class="stat-card">
            <div class="stat-label">Draft Events</div>
            <div class="stat-value">${draftEvents}</div>
        </div>
    </div>
</div>

<!-- Quick Actions -->
<div class="row g-3 mb-4">
    <div class="col-md-3">
        <a href="${pageContext.request.contextPath}/organizer/events/create" class="card text-center h-100 text-decoration-none">
            <div class="card-body">
                <i class="bi bi-calendar-plus fs-1 text-primary"></i>
                <h6 class="mt-2 mb-0">Create Event</h6>
            </div>
        </a>
    </div>
    <div class="col-md-3">
        <a href="${pageContext.request.contextPath}/organizer/events" class="card text-center h-100 text-decoration-none">
            <div class="card-body">
                <i class="bi bi-calendar-check fs-1 text-success"></i>
                <h6 class="mt-2 mb-0">My Events</h6>
            </div>
        </a>
    </div>
    <div class="col-md-3">
        <a href="${pageContext.request.contextPath}/organizer/announcements/create" class="card text-center h-100 text-decoration-none">
            <div class="card-body">
                <i class="bi bi-megaphone fs-1 text-warning"></i>
                <h6 class="mt-2 mb-0">Create Announcement</h6>
            </div>
        </a>
    </div>
    <div class="col-md-3">
        <a href="${pageContext.request.contextPath}/validation" class="card text-center h-100 text-decoration-none">
            <div class="card-body">
                <i class="bi bi-qr-code-scan fs-1 text-info"></i>
                <h6 class="mt-2 mb-0">Scan Tickets</h6>
            </div>
        </a>
    </div>
</div>

<!-- Upcoming Events -->
<div class="row mb-4">
    <div class="col-12">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="mb-0">Upcoming Events</h5>
            <a href="${pageContext.request.contextPath}/organizer/events" class="btn btn-sm btn-outline-primary">View All</a>
        </div>
        <c:if test="${not empty upcomingEvents}">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Event</th>
                            <th>Date</th>
                            <th>Registrations</th>
                            <th>Revenue</th>
                            <th>Status</th>
                            <th class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${upcomingEvents}" var="event">
                            <tr>
                                <td><strong><c:out value="${event.title}"/></strong></td>
                                <td>${event.formattedEventDateTime}</td>
                                <td><c:out value="${regCountByEvent[event.id]}" default="0"/> / ${event.capacity}</td>
                                <td>$${totalRevenue}</td>
                                <td>
                                    <span class="badge bg-success status-badge"><c:out value="${event.status}"/></span>
                                </td>
                                <td class="text-end">
                                    <a href="${pageContext.request.contextPath}/organizer/events/${event.id}" class="btn btn-sm btn-outline-primary">View</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
        <c:if test="${empty upcomingEvents}">
            <div class="text-center py-4 text-muted">
                <i class="bi bi-calendar-x display-4"></i>
                <p class="mt-2">No upcoming events</p>
                <a href="${pageContext.request.contextPath}/organizer/events/create" class="btn btn-primary mt-2">Create Your First Event</a>
            </div>
        </c:if>
    </div>
</div>

<!-- Top Performing Events -->
<div class="row">
    <div class="col-12">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="mb-0">Top Performing Events</h5>
        </div>
        <c:if test="${not empty topEvents}">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Event</th>
                            <th>Registrations</th>
                            <th>Capacity</th>
                            <th>Fill Rate</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${topEvents}" var="event">
                            <tr>
                                <td><strong><c:out value="${event.title}"/></strong></td>
                                <td><c:out value="${regCountByEvent[event.id]}" default="0"/></td>
                                <td>${event.capacity}</td>
                                <td>
                                    <c:set var="fillRate" value="${event.capacity > 0 ? (regCountByEvent[event.id] != null ? regCountByEvent[event.id] : 0) * 100 / event.capacity : 0}"/>
                                    <div class="progress" style="height: 20px;">
                                        <div class="progress-bar bg-success" role="progressbar" style="width: ${fillRate}%;">${fillRate}%</div>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
    </div>
</div>

<%@ include file="../footer.jsp" %>
