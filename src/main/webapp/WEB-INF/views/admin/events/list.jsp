<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="All Events"/>
<%@ include file="../../header.jsp" %>

<div class="row mb-4">
    <div class="col-12">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h2 class="h4 fw-bold mb-0">Event Management</h2>
                <p class="text-muted">View and manage all events in the system</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/events/pending" class="btn btn-warning">
                <i class="bi bi-clock-history me-2"></i>Pending Approvals (${pendingEvents})
            </a>
        </div>
    </div>
</div>

<!-- Stats -->
<div class="row g-3 mb-4">
    <div class="col-md-3">
        <div class="stat-card">
            <div class="stat-label">Total Events</div>
            <div class="stat-value">${totalEvents}</div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="stat-card warning">
            <div class="stat-label">Pending</div>
            <div class="stat-value">${pendingEvents}</div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="stat-card success">
            <div class="stat-label">Approved</div>
            <div class="stat-value">${approvedEvents}</div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="stat-card danger">
            <div class="stat-label">Rejected</div>
            <div class="stat-value">${rejectedEvents}</div>
        </div>
    </div>
</div>

<!-- Filters -->
<div class="card mb-4">
    <div class="card-body">
        <form method="get" class="row g-3">
            <div class="col-md-4">
                <label class="form-label visually-hidden">Status</label>
                <select class="form-select" name="status">
                    <option value="">All Statuses</option>
                    <option value="DRAFT" ${statusFilter == 'DRAFT' ? 'selected' : ''}>Draft</option>
                    <option value="PENDING_APPROVAL" ${statusFilter == 'PENDING_APPROVAL' ? 'selected' : ''}>Pending Approval</option>
                    <option value="APPROVED" ${statusFilter == 'APPROVED' ? 'selected' : ''}>Approved</option>
                    <option value="REJECTED" ${statusFilter == 'REJECTED' ? 'selected' : ''}>Rejected</option>
                    <option value="CANCELLED" ${statusFilter == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                </select>
            </div>
            <div class="col-md-3">
                <button type="submit" class="btn btn-outline-primary w-100">Filter</button>
            </div>
            <div class="col-md-3">
                <a href="${pageContext.request.contextPath}/admin/events" class="btn btn-outline-secondary w-100">Reset</a>
            </div>
        </form>
    </div>
</div>

<!-- Events Table -->
<div class="card">
    <div class="card-body p-0">
        <c:if test="${not empty events}">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>Event</th>
                            <th>Organizer</th>
                            <th>Date & Time</th>
                            <th>Venue</th>
                            <th>Capacity</th>
                            <th>Status</th>
                            <th>Registrations</th>
                            <th class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${events}" var="event">
                            <tr>
                                <td>
                                    <strong><c:out value="${event.title}"/></strong>
                                    <br>
                                    <small class="text-muted"><c:out value="${event.description}"/></small>
                                </td>
                                <td><c:out value="${event.organizerName}"/></td>
                                <td>
                                    <c:out value="${event.formattedEventDate}"/>
                                    <br>
                                    <small class="text-muted"><c:out value="${event.formattedEventTime}"/></small>
                                </td>
                                <td><c:out value="${event.venue}"/></td>
                                <td>${event.capacity}</td>
                                <td>
                                    <span class="badge bg-${event.status == 'APPROVED' ? 'success' : event.status == 'PENDING_APPROVAL' ? 'warning' : event.status == 'REJECTED' ? 'danger' : event.status == 'CANCELLED' ? 'secondary' : 'info'} status-badge">
                                        <c:out value="${event.status}"/>
                                    </span>
                                </td>
                                <td>${event.soldTickets} / ${event.capacity}</td>
                                <td class="text-end">
                                    <div class="btn-group btn-group-sm">
                                        <a href="${pageContext.request.contextPath}/admin/events/${event.id}" class="btn btn-outline-secondary" title="View">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                        <c:if test="${event.status == 'PENDING_APPROVAL'}">
                                            <a href="${pageContext.request.contextPath}/admin/events/${event.id}" class="btn btn-outline-primary" title="Review">
                                                <i class="bi bi-check-circle"></i>
                                            </a>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
        <c:if test="${empty events}">
            <div class="text-center py-5">
                <i class="bi bi-calendar-x display-4 text-muted"></i>
                <h5 class="mt-3 text-muted">No events found</h5>
            </div>
        </c:if>
    </div>
</div>


<%@ include file="../../footer.jsp" %>

