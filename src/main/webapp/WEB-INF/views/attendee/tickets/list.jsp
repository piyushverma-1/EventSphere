<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="My Tickets"/>
<%@ include file="../../header.jsp" %>

<div class="row mb-4">
    <div class="col-12">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h2 class="h4 fw-bold mb-0">My Tickets</h2>
                <p class="text-muted">View and manage your event registrations</p>
            </div>
            <a href="${pageContext.request.contextPath}/attendee/dashboard" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-2"></i>Back to Dashboard
            </a>
        </div>
    </div>
</div>

<ul class="nav nav-pills mb-4" id="ticketTabs" role="tablist">
    <li class="nav-item" role="presentation">
        <button class="nav-link active" id="upcoming-tab" data-bs-toggle="pill" data-bs-target="#upcoming">
            <i class="bi bi-calendar-check me-1"></i>Upcoming (${fn:length(upcomingTickets)})
        </button>
    </li>
    <li class="nav-item" role="presentation">
        <button class="nav-link" id="past-tab" data-bs-toggle="pill" data-bs-target="#past">
            <i class="bi bi-clock-history me-1"></i>Past (${fn:length(pastTickets)})
        </button>
    </li>
    <li class="nav-item" role="presentation">
        <button class="nav-link" id="cancelled-tab" data-bs-toggle="pill" data-bs-target="#cancelled">
            <i class="bi bi-slash-circle me-1"></i>Cancelled (${fn:length(cancelledTickets)})
        </button>
    </li>
</ul>

<div class="tab-content">
    <!-- Upcoming Tickets -->
    <div class="tab-pane fade show active" id="upcoming">
        <c:if test="${not empty upcomingTickets}">
            <c:forEach items="${upcomingTickets}" var="reg">
                <c:if test="${not empty digitalTickets}">
                    <c:forEach items="${digitalTickets}" var="ticket">
                        <c:if test="${ticket.registrationId == reg.id}">
                            <div class="card mb-3 ticket-card">
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-8">
                                            <div class="d-flex justify-content-between">
                                                <h5 class="card-title mb-0"><c:out value="${reg.eventTitle}"/></h5>
                                                <span class="badge bg-success status-badge">
                                                    <i class="bi bi-check-circle me-1"></i>Confirmed
                                                </span>
                                            </div>
                                            <p class="card-text text-muted small">
                                                <i class="bi bi-person me-1"></i><c:out value="${reg.attendeeName}"/> |
                                                <i class="bi bi-tag me-1"></i><c:out value="${reg.ticketTypeName}"/> |
                                                <i class="bi bi-people me-1"></i>Qty: ${reg.quantity}
                                            </p>
                                            <p class="card-text text-muted small">
                                                <i class="bi bi-calendar me-1"></i><fmt:formatDate value="${reg.createdAt}" pattern="MMM d, yyyy"/>
                                                | <i class="bi bi-qr-code me-1"></i>Ticket: <code><c:out value="${ticket.ticketCode}"/></code>
                                            </p>
                                        </div>
                                        <div class="col-md-4 text-md-end">
                                            <div class="mb-2"><strong>$${reg.totalPrice}</strong></div>
                                            <div class="d-grid gap-2">
                                                <a href="${pageContext.request.contextPath}/attendee/tickets/${reg.id}" class="btn btn-sm btn-outline-primary">
                                                    <i class="bi bi-eye me-1"></i>View Ticket
                                                </a>
                                                <button type="button" class="btn btn-sm btn-outline-danger" onclick="cancelRegistration(${reg.id})">
                                                    <i class="bi bi-x-circle me-1"></i>Cancel
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </c:if>
            </c:forEach>
        </c:if>
        <c:if test="${empty upcomingTickets}">
            <div class="text-center py-5 text-muted">
                <i class="bi bi-ticket-detailed display-4"></i>
                <h5 class="mt-3">No upcoming tickets</h5>
                <a href="${pageContext.request.contextPath}/events" class="btn btn-primary mt-2">Browse Events</a>
            </div>
        </c:if>
    </div>

    <!-- Past Tickets -->
    <div class="tab-pane fade" id="past">
        <c:if test="${not empty pastTickets}">
            <c:forEach items="${pastTickets}" var="reg">
                <div class="card mb-3">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-8">
                                <h5 class="card-title mb-0"><c:out value="${reg.eventTitle}"/></h5>
                                <p class="card-text text-muted small">
                                    <i class="bi bi-person me-1"></i><c:out value="${reg.attendeeName}"/> |
                                    <i class="bi bi-tag me-1"></i><c:out value="${reg.ticketTypeName}"/> |
                                    <i class="bi bi-calendar me-1"></i><fmt:formatDate value="${reg.createdAt}" pattern="MMM d, yyyy"/>
                                </p>
                            </div>
                            <div class="col-md-4 text-md-end">
                                <div class="mb-2"><strong>$${reg.totalPrice}</strong></div>
                                <span class="badge bg-secondary">Completed</span>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:if>
        <c:if test="${empty pastTickets}">
            <div class="text-center py-5 text-muted">
                <i class="bi bi-clock-history display-4"></i>
                <h5 class="mt-3">No past events</h5>
            </div>
        </c:if>
    </div>

    <!-- Cancelled Tickets -->
    <div class="tab-pane fade" id="cancelled">
        <c:if test="${not empty cancelledTickets}">
            <c:forEach items="${cancelledTickets}" var="reg">
                <div class="card mb-3 ticket-card cancelled">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-8">
                                <h5 class="card-title mb-0"><c:out value="${reg.eventTitle}"/></h5>
                                <p class="card-text text-muted small">
                                    <i class="bi bi-person me-1"></i><c:out value="${reg.attendeeName}"/> |
                                    <i class="bi bi-tag me-1"></i><c:out value="${reg.ticketTypeName}"/> |
                                    <i class="bi bi-calendar me-1"></i><fmt:formatDate value="${reg.createdAt}" pattern="MMM d, yyyy"/>
                                </p>
                                <p class="card-text text-danger small">
                                    <i class="bi bi-info-circle me-1"></i>Cancellation reason: <c:out value="${reg.cancellationReason}"/>
                                </p>
                            </div>
                            <div class="col-md-4 text-md-end">
                                <span class="badge bg-secondary">Cancelled</span>
                                <div class="mt-2"><small class="text-muted">Refunded</small></div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:if>
        <c:if test="${empty cancelledTickets}">
            <div class="text-center py-5 text-muted">
                <i class="bi bi-slash-circle display-4"></i>
                <h5 class="mt-3">No cancelled tickets</h5>
            </div>
        </c:if>
    </div>
</div>

<script>
function cancelRegistration(regId) {
    if (confirm('Are you sure you want to cancel this registration?')) {
        window.location.href = '/attendee/tickets/' + regId + '/cancel';
    }
}
</script>


<%@ include file="../../footer.jsp" %>

