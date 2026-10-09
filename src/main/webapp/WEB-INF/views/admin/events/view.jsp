<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Event Details"/>
<%@ include file="../../header.jsp" %>

<div class="row mb-4">
    <div class="col-12">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h2 class="h4 fw-bold mb-0"><c:out value="${event.title}"/></h2>
                <p class="text-muted mb-0">Event Details</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/events" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-2"></i>Back
            </a>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-lg-8">
        <div class="card mb-4">
            <div class="card-header">Event Information</div>
            <div class="card-body">
                <dl class="row mb-0">
                    <dt class="col-sm-3">Description</dt>
                    <dd class="col-sm-9"><c:out value="${event.description}"/></dd>
                    <dt class="col-sm-3">Date & Time</dt>
                    <dd class="col-sm-9">
                        <c:out value="${event.formattedEventDateTime}"/>
                    </dd>
                    <dt class="col-sm-3">Venue</dt>
                    <dd class="col-sm-9"><c:out value="${event.venue}"/></dd>
                    <dt class="col-sm-3">Capacity</dt>
                    <dd class="col-sm-9">${event.capacity} attendees</dd>
                    <dt class="col-sm-3">Organizer</dt>
                    <dd class="col-sm-9"><c:out value="${event.organizerName}"/></dd>
                    <dt class="col-sm-3">Status</dt>
                    <dd class="col-sm-9">
                        <span class="badge bg-${event.status == 'APPROVED' ? 'success' : event.status == 'PENDING_APPROVAL' ? 'warning' : event.status == 'REJECTED' ? 'danger' : event.status == 'CANCELLED' ? 'secondary' : 'info'} fs-6">
                            <c:out value="${event.status}"/>
                        </span>
                    </dd>
                    <c:if test="${event.rejectionReason != null}">
                        <dt class="col-sm-3">Rejection Reason</dt>
                        <dd class="col-sm-9 text-danger"><c:out value="${event.rejectionReason}"/></dd>
                    </c:if>
                    <c:if test="${event.approvedAt != null}">
                        <dt class="col-sm-3">Approved</dt>
                        <dd class="col-sm-9"><c:out value="${event.formattedApprovedAt}"/></dd>
                    </c:if>
                    <dt class="col-sm-3">Created</dt>
                    <dd class="col-sm-9"><c:out value="${event.formattedCreatedAt}"/></dd>
                </dl>
            </div>
        </div>

        <c:if test="${event.status == 'PENDING_APPROVAL'}">
            <div class="card mb-4">
                <div class="card-header">Approval Actions</div>
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/admin/events/${event.id}/approve" class="d-inline" onsubmit="return confirm('Approve this event?')">
                        <button type="submit" class="btn btn-success me-2">
                            <i class="bi bi-check me-2"></i>Approve Event
                        </button>
                    </form>
                    <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#rejectModal">
                        <i class="bi bi-x me-2"></i>Reject Event
                    </button>
                </div>
            </div>
        </c:if>

        <c:if test="${event.status == 'APPROVED'}">
            <div class="card mb-4">
                <div class="card-header">Registrations</div>
                <div class="card-body">
                    <p class="text-muted">Total Registrations: <strong>${event.soldTickets}</strong> / ${event.capacity} (${event.availableTickets} available)</p>
                    <a href="${pageContext.request.contextPath}/admin/events/${event.id}/registrations" class="btn btn-outline-primary">View All Registrations</a>
                </div>
            </div>
        </c:if>
    </div>

    <div class="col-lg-4">
        <div class="card mb-4">
            <div class="card-header">Quick Stats</div>
            <div class="card-body">
                <div class="d-flex justify-content-between mb-2">
                    <span>Total Capacity</span>
                    <strong>${event.capacity}</strong>
                </div>
                <div class="d-flex justify-content-between mb-2">
                    <span>Registered</span>
                    <strong>${event.soldTickets}</strong>
                </div>
                <div class="d-flex justify-content-between mb-2">
                    <span>Available</span>
                    <strong class="text-success">${event.availableTickets}</strong>
                </div>
                <div class="d-flex justify-content-between mb-2">
                    <span>Fill Rate</span>
                    <strong>${event.capacity > 0 ? (event.soldTickets * 100 / event.capacity) : 0}%</strong>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header">Actions</div>
            <div class="card-body">
                <div class="d-grid gap-2">
                    <a href="${pageContext.request.contextPath}/events/${event.id}" class="btn btn-outline-primary" target="_blank">
                        <i class="bi bi-eye me-2"></i>Public View
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Reject Modal -->
<div class="modal fade" id="rejectModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form method="post" action="${pageContext.request.contextPath}/admin/events/${event.id}/reject">
                <div class="modal-header">
                    <h5 class="modal-title">Reject Event</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to reject "<strong><c:out value="${event.title}"/></strong>"?</p>
                    <div class="mb-3">
                        <label for="rejectionReason" class="form-label">Rejection Reason <span class="text-danger">*</span></label>
                        <textarea class="form-control" id="rejectionReason" name="rejectionReason" rows="3" required placeholder="Please provide a reason for rejection..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-danger">Reject Event</button>
                </div>
            </form>
        </div>
    </div>
</div>


<%@ include file="../../footer.jsp" %>

