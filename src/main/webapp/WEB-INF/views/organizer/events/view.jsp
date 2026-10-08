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
                <p class="text-muted mb-0"><c:out value="${event.description}"/></p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/organizer/events" class="btn btn-outline-secondary me-2">
                    <i class="bi bi-arrow-left"></i>
                </a>
                <c:if test="${event.isDraft || event.isRejected}">
                    <a href="${pageContext.request.contextPath}/organizer/events/${event.id}/edit" class="btn btn-outline-primary me-2">
                        <i class="bi bi-pencil"></i> Edit
                    </a>
                </c:if>
                <c:if test="${event.isDraft || event.isRejected}">
                    <form method="post" action="${pageContext.request.contextPath}/organizer/events/${event.id}/submit" class="d-inline" onsubmit="return confirm('Submit this event for approval?')">
                        <button type="submit" class="btn btn-success">
                            <i class="bi bi-send"></i> Submit
                        </button>
                    </form>
                </c:if>
                <c:if test="${event.isPending || event.isApproved}">
                    <button type="button" class="btn btn-warning" onclick="cancelEvent(${event.id})">
                        <i class="bi bi-stop-circle"></i> Cancel
                    </button>
                </c:if>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <!-- Event Details -->
    <div class="col-lg-8">
        <div class="card mb-4">
            <div class="card-header">Event Information</div>
            <div class="card-body">
                <dl class="row mb-0">
                    <dt class="col-sm-3">Date & Time</dt>
                    <dd class="col-sm-9">
                        <fmt:formatDate value="${event.eventDate}" pattern="EEEE, MMMM d, yyyy"/>
                        at <fmt:formatDate value="${event.eventTime}" pattern="h:mm a"/>
                    </dd>
                    <dt class="col-sm-3">Venue</dt>
                    <dd class="col-sm-9"><c:out value="${event.venue}"/></dd>
                    <dt class="col-sm-3">Capacity</dt>
                    <dd class="col-sm-9">${event.capacity} attendees</dd>
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
                        <dd class="col-sm-9"><fmt:formatDate value="${event.approvedAt}" pattern="MMM d, yyyy h:mm a"/></dd>
                    </c:if>
                    <dt class="col-sm-3">Created</dt>
                    <dd class="col-sm-9"><fmt:formatDate value="${event.createdAt}" pattern="MMM d, yyyy h:mm a"/></dd>
                </dl>
            </div>
        </div>

        <!-- Ticket Types -->
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h6 class="mb-0">Ticket Types</h6>
                <c:if test="${event.isApproved}">
                    <a href="${pageContext.request.contextPath}/organizer/events/${event.id}/tickets" class="btn btn-sm btn-outline-primary">
                        <i class="bi bi-pencil"></i> Edit Tickets
                    </a>
                </c:if>
            </div>
            <div class="card-body p-0">
                <c:if test="${not empty tickets}">
                    <table class="table table-hover mb-0">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Price</th>
                                <th>Quantity</th>
                                <th>Sold</th>
                                <th>Available</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${tickets}" var="ticket">
                                <tr>
                                    <td><strong><c:out value="${ticket.name}"/></strong></td>
                                    <td>$${ticket.price}</td>
                                    <td>${ticket.quantity}</td>
                                    <td><span class="text-primary">${ticket.soldCount}</span></td>
                                    <td><span class="text-success">${ticket.availableCount}</span></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>
                <c:if test="${empty tickets}">
                    <div class="text-center py-4 text-muted">
                        <p class="mb-0">No ticket types have been created</p>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Registrations -->
        <c:if test="${event.isApproved}">
            <div class="card mb-4">
                <div class="card-header">
                    <h6 class="mb-0">Registered Attendees (${event.soldTickets})</h6>
                </div>
                <div class="card-body p-0">
                    <c:if test="${not empty tickets}">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Ticket Type</th>
                                    <th>Quantity</th>
                                    <th>Booking Ref</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${registrations}" var="reg">
                                    <tr>
                                        <td><c:out value="${reg.attendeeName}"/></td>
                                        <td><c:out value="${reg.attendeeEmail}"/></td>
                                        <td><c:out value="${reg.ticketTypeName}"/></td>
                                        <td>${reg.quantity}</td>
                                        <td><code><c:out value="${reg.bookingReference}"/></code></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:if>
                    <c:if test="${empty tickets}">
                        <div class="text-center py-4">
                            <i class="bi bi-people display-4 text-muted"></i>
                            <p class="text-muted mt-2 mb-0">No registrations yet</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </c:if>

        <!-- Announcements -->
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h6 class="mb-0">Announcements</h6>
                <c:if test="${event.isApproved}">
                    <a href="${pageContext.request.contextPath}/organizer/announcements/create?eventId=${event.id}" class="btn btn-sm btn-outline-primary">
                        <i class="bi bi-plus"></i> Create
                    </a>
                </c:if>
            </div>
            <div class="card-body">
                <c:if test="${not empty announcements}">
                    <c:forEach items="${announcements}" var="ann">
                        <div class="border-bottom pb-3 mb-3">
                            <div class="d-flex justify-content-between">
                                <h6 class="mb-0"><c:out value="${ann.title}"/></h6>
                                <span class="badge bg-${ann.isSent ? 'success' : 'warning'}">${ann.isSent ? 'Sent' : 'Draft'}</span>
                            </div>
                            <p class="text-muted small mb-1"><c:out value="${ann.message}"/></p>
                            <small class="text-muted">
                                <i class="bi bi-clock me-1"></i><fmt:formatDate value="${ann.createdAt}" pattern="MMM d, yyyy h:mm a"/>
                                <c:if test="${ann.sentAt != null}">
                                    | <i class="bi bi-send me-1"></i>Sent <fmt:formatDate value="${ann.sentAt}" pattern="MMM d, yyyy h:mm a"/>
                                </c:if>
                            </small>
                        </div>
                    </c:forEach>
                </c:if>
                <c:if test="${empty announcements}">
                    <p class="text-muted mb-0">No announcements yet</p>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Sidebar -->
    <div class="col-lg-4">
        <div class="card mb-4">
            <div class="card-header">Registration Stats</div>
            <div class="card-body">
                <div class="text-center mb-3">
                    <div class="stat-value">${event.soldTickets}</div>
                    <div class="stat-label">Registered</div>
                </div>
                <div class="progress mb-3" style="height: 20px;">
                    <c:set var="fillRate" value="${event.capacity > 0 ? (event.soldTickets != null ? event.soldTickets : 0) * 100 / event.capacity : 0}"/>
                    <div class="progress-bar bg-primary" role="progressbar" style="width: ${fillRate}%;">
                        ${fillRate}%
                    </div>
                </div>
                <div class="d-flex justify-content-between small text-muted">
                    <span>${event.soldTickets} / ${event.capacity}</span>
                    <span>${event.capacity - event.soldTickets} remaining</span>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header">Quick Actions</div>
            <div class="card-body p-0">
                <div class="list-group list-group-flush">
                    <c:if test="${event.isDraft || event.isRejected}">
                        <a href="${pageContext.request.contextPath}/organizer/events/${event.id}/tickets" class="list-group-item list-group-item-action">
                            <i class="bi bi-tag me-2"></i>Manage Tickets
                        </a>
                        <form method="post" action="${pageContext.request.contextPath}/organizer/events/${event.id}/submit" class="list-group-item p-0">
                            <button type="submit" class="list-group-item list-group-item-action border-0 bg-transparent" onclick="return confirm('Submit this event for approval?')">
                                <i class="bi bi-send me-2"></i>Submit for Approval
                            </button>
                        </form>
                    </c:if>
                    <c:if test="${event.isPending}">
                        <a href="${pageContext.request.contextPath}/validate-ticket" class="list-group-item list-group-item-action">
                            <i class="bi bi-qr-code-scan me-2"></i>Scan Tickets
                        </a>
                    </c:if>
                    <c:if test="${event.isApproved}">
                        <a href="${pageContext.request.contextPath}/organizer/announcements/create?eventId=${event.id}" class="list-group-item list-group-item-action">
                            <i class="bi bi-megaphone me-2"></i>Create Announcement
                        </a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function cancelEvent(eventId) {
    if (confirm('Cancel this event? This action cannot be undone.')) {
        window.location.href = '/organizer/events/' + eventId + '/cancel';
    }
}
</script>


<%@ include file="../../footer.jsp" %>

