<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../../header.jsp" %>
<c:set var="pageTitle" value="Pending Approvals"/>

<div class="row mb-4">
    <div class="col-12">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h2 class="h4 fw-bold mb-0">Pending Event Approvals</h2>
                <p class="text-muted">Review and approve or reject submitted events</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/events" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-2"></i>Back to All Events
            </a>
        </div>
    </div>
</div>

<c:if test="${not empty events}">
    <div class="row">
        <c:forEach items="${events}" var="event">
            <div class="col-lg-6 mb-4">
                <div class="card h-100">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h6 class="mb-0"><c:out value="${event.title}"/></h6>
                        <span class="badge bg-warning status-badge">Pending Review</span>
                    </div>
                    <div class="card-body">
                        <p class="card-text"><c:out value="${event.description}"/></p>
                        <div class="row mb-2">
                            <div class="col-6">
                                <small class="text-muted">Organizer:</small>
                                <div><strong><c:out value="${event.organizerName}"/></strong></div>
                            </div>
                            <div class="col-6">
                                <small class="text-muted">Date:</small>
                                <div><strong><c:out value="${event.formattedEventDateTime}"/></strong></div>
                            </div>
                        </div>
                        <div class="row mb-2">
                            <div class="col-6">
                                <small class="text-muted">Venue:</small>
                                <div><strong><c:out value="${event.venue}"/></strong></div>
                            </div>
                            <div class="col-6">
                                <small class="text-muted">Capacity:</small>
                                <div><strong>${event.capacity}</strong></div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <small class="text-muted">Submitted:</small>
                            <div><c:out value="${event.formattedCreatedAt}"/></div>
                        </div>
                    </div>
                    <div class="card-footer">
                        <form method="post" action="${pageContext.request.contextPath}/admin/events/${event.id}/approve" class="d-inline" onsubmit="return confirm('Approve this event?')">
                            <button type="submit" class="btn btn-success">
                                <i class="bi bi-check me-2"></i>Approve
                            </button>
                        </form>
                        <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#rejectModal${event.id}">
                            <i class="bi bi-x me-2"></i>Reject
                        </button>
                    </div>
                </div>
            </div>

            <!-- Reject Modal -->
            <div class="modal fade" id="rejectModal${event.id}" tabindex="-1">
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
                                    <label for="rejectionReason${event.id}" class="form-label">Rejection Reason <span class="text-danger">*</span></label>
                                    <textarea class="form-control" id="rejectionReason${event.id}" name="rejectionReason" rows="3" required placeholder="Please provide a reason for rejection..."></textarea>
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
        </c:forEach>
    </div>
</c:if>

<c:if test="${empty events}">
    <div class="text-center py-5">
        <i class="bi bi-check-circle display-1 text-success"></i>
        <h3 class="mt-3">No Pending Approvals</h3>
        <p class="text-muted">All events have been reviewed.</p>
        <a href="${pageContext.request.contextPath}/admin/events" class="btn btn-primary mt-2">View All Events</a>
    </div>
</c:if>


<%@ include file="../../footer.jsp" %>
