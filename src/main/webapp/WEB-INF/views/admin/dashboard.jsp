<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Admin Dashboard"/>
<%@ include file="../header.jsp" %>

<div class="row mb-4">
    <div class="col-12">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h2 class="h4 fw-bold mb-0">Admin Dashboard</h2>
                <p class="text-muted">System overview and quick actions</p>
            </div>
        </div>
    </div>
</div>

<!-- Stats Cards -->
<div class="row g-3 mb-4">
    <div class="col-md-6 col-lg-3">
        <div class="stat-card">
            <div class="stat-label">Total Users</div>
            <div class="stat-value">${totalUsers}</div>
        </div>
    </div>
    <div class="col-md-6 col-lg-3">
        <div class="stat-card success">
            <div class="stat-label">Attendees</div>
            <div class="stat-value">${attendeeCount}</div>
        </div>
    </div>
    <div class="col-md-6 col-lg-3">
        <div class="stat-card warning">
            <div class="stat-label">Organizers</div>
            <div class="stat-value">${organizerCount}</div>
        </div>
    </div>
    <div class="col-md-6 col-lg-3">
        <div class="stat-card danger">
            <div class="stat-label">Admins</div>
            <div class="stat-value">${adminCount}</div>
        </div>
    </div>
</div>

<div class="row g-3 mb-4">
    <div class="col-md-6 col-lg-3">
        <div class="stat-card">
            <div class="stat-label">Total Events</div>
            <div class="stat-value">${totalEvents}</div>
        </div>
    </div>
    <div class="col-md-6 col-lg-3">
        <div class="stat-card warning">
            <div class="stat-label">Pending</div>
            <div class="stat-value">${pendingEvents}</div>
        </div>
    </div>
    <div class="col-md-6 col-lg-3">
        <div class="stat-card success">
            <div class="stat-label">Approved</div>
            <div class="stat-value">${approvedEvents}</div>
        </div>
    </div>
    <div class="col-md-6 col-lg-3">
        <div class="stat-card">
            <div class="stat-label">Revenue</div>
            <div class="stat-value">$${totalRevenue}</div>
        </div>
    </div>
</div>

<!-- Quick Actions -->
<div class="row g-3 mb-4">
    <div class="col-md-3">
        <a href="${pageContext.request.contextPath}/admin/users/create" class="card text-center h-100 text-decoration-none">
            <div class="card-body">
                <i class="bi bi-person-plus fs-1 text-primary"></i>
                <h6 class="mt-2 mb-0">Add User</h6>
            </div>
        </a>
    </div>
    <div class="col-md-3">
        <a href="${pageContext.request.contextPath}/admin/events/pending" class="card text-center h-100 text-decoration-none">
            <div class="card-body">
                <i class="bi bi-clock-history fs-1 text-warning"></i>
                <h6 class="mt-2 mb-0">Review Events</h6>
                <span class="badge bg-warning text-dark">${pendingEvents}</span>
            </div>
        </a>
    </div>
    <div class="col-md-3">
        <a href="${pageContext.request.contextPath}/admin/users" class="card text-center h-100 text-decoration-none">
            <div class="card-body">
                <i class="bi bi-people fs-1 text-success"></i>
                <h6 class="mt-2 mb-0">Manage Users</h6>
            </div>
        </a>
    </div>
    <div class="col-md-3">
        <a href="${pageContext.request.contextPath}/admin/events" class="card text-center h-100 text-decoration-none">
            <div class="card-body">
                <i class="bi bi-calendar-check fs-1 text-info"></i>
                <h6 class="mt-2 mb-0">All Events</h6>
            </div>
        </a>
    </div>
</div>

<!-- Pending Approvals -->
<div class="row mb-4">
    <div class="col-12">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="mb-0">Pending Event Approvals</h5>
            <a href="${pageContext.request.contextPath}/admin/events/pending" class="btn btn-sm btn-outline-primary">View All</a>
        </div>
        <c:if test="${not empty pendingApproval}">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Event</th>
                            <th>Organizer</th>
                            <th>Date</th>
                            <th>Venue</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${pendingApproval}" var="event">
                            <tr>
                                <td>
                                    <strong><c:out value="${event.title}"/></strong>
                                </td>
                                <td><c:out value="${event.organizerName}"/></td>
                                <td>${event.formattedEventDate}</td>
                                <td><c:out value="${event.venue}"/></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/events/${event.id}" class="btn btn-sm btn-outline-primary">Review</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
        <c:if test="${empty pendingApproval}">
            <div class="text-center py-4 text-muted">
                <i class="bi bi-check-circle display-4"></i>
                <p class="mt-2">No pending approvals</p>
            </div>
        </c:if>
    </div>
</div>

<!-- Recent Users & Events -->
<div class="row">
    <div class="col-lg-6 mb-4">
        <div class="card h-100">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h6 class="mb-0">Recent Users</h6>
                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-sm btn-outline-primary">View All</a>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${recentUsers}" var="user">
                                <tr>
                                    <td><c:out value="${user.fullName}"/></td>
                                    <td><c:out value="${user.email}"/></td>
                                    <td><span class="badge bg-primary"><c:out value="${user.role}"/></span></td>
                                    <td><span class="badge ${user.isActive ? 'bg-success' : 'bg-danger'}">${user.isActive ? 'Active' : 'Inactive'}</span></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="col-lg-6 mb-4">
        <div class="card h-100">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h6 class="mb-0">Recent Events</h6>
                <a href="${pageContext.request.contextPath}/admin/events" class="btn btn-sm btn-outline-primary">View All</a>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead>
                            <tr>
                                <th>Event</th>
                                <th>Organizer</th>
                                <th>Date</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${recentEvents}" var="event">
                                <tr>
                                    <td><strong><c:out value="${event.title}"/></strong></td>
                                    <td><c:out value="${event.organizerName}"/></td>
                                    <td>${event.formattedEventDate}</td>
                                    <td>
                                        <span class="badge bg-${event.status == 'APPROVED' ? 'success' : event.status == 'PENDING_APPROVAL' ? 'warning' : event.status == 'REJECTED' ? 'danger' : 'secondary'} status-badge">
                                            <c:out value="${event.status}"/>
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../footer.jsp" %>
