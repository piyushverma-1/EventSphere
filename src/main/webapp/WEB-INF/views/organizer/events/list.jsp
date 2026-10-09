<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="My Events"/>
<%@ include file="../../header.jsp" %>

<div class="row mb-4">
    <div class="col-12">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h2 class="h4 fw-bold mb-0">My Events</h2>
                <p class="text-muted">Manage your created events</p>
            </div>
            <a href="${pageContext.request.contextPath}/organizer/events/create" class="btn btn-primary">
                <i class="bi bi-plus-lg"></i> New Event
            </a>
        </div>
    </div>
</div>

<div class="card">
    <div class="card-body p-0">
        <c:if test="${not empty events}">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>Event</th>
                            <th>Date & Time</th>
                            <th>Venue</th>
                            <th>Tickets</th>
                            <th>Status</th>
                            <th class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${events}" var="event">
                            <tr>
                                <td>
                                    <strong><c:out value="${event.title}"/></strong>
                                    <br><small class="text-muted"><c:out value="${fn:substring(event.description, 0, 50)}"/>...</small>
                                </td>
                                <td>
                                    <c:out value="${event.formattedEventDate}"/>
                                    <br><small><c:out value="${event.formattedEventTime}"/></small>
                                </td>
                                <td><c:out value="${event.venue}"/></td>
                                <td>
                                    <c:set var="sold" value="${event.soldTickets != null ? event.soldTickets : 0}"/>
                                    <c:set var="available" value="${event.availableTickets != null ? event.availableTickets : 0}"/>
                                    <c:out value="${sold}"/> / <c:out value="${event.capacity}"/> tickets
                                </td>
                                <td>
                                    <span class="badge bg-${event.status == 'APPROVED' ? 'success' : event.status == 'PENDING_APPROVAL' ? 'warning' : event.status == 'REJECTED' ? 'danger' : event.status == 'CANCELLED' ? 'secondary' : 'info'} status-badge">
                                        <c:out value="${event.status}"/>
                                    </span>
                                    <c:if test="${event.rejectionReason != null}">
                                        <br><small class="text-danger"><c:out value="${event.rejectionReason}"/></small>
                                    </c:if>
                                </td>
                                <td class="text-end">
                                    <div class="btn-group btn-group-sm">
                                        <a href="${pageContext.request.contextPath}/organizer/events/${event.id}" class="btn btn-outline-secondary" title="View">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                        <c:if test="${event.isDraft || event.isRejected}">
                                            <a href="${pageContext.request.contextPath}/organizer/events/${event.id}/edit" class="btn btn-outline-primary" title="Edit">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <button type="button" class="btn btn-outline-success" title="Submit for Approval" onclick="submitEvent(${event.id})">
                                                <i class="bi bi-send"></i>
                                            </button>
                                        </c:if>
                                        <c:if test="${event.isPending || event.isApproved}">
                                            <button type="button" class="btn btn-outline-warning" title="Cancel Event" onclick="cancelEvent(${event.id})">
                                                <i class="bi bi-stop-circle"></i>
                                            </button>
                                        </c:if>
                                        <c:if test="${event.isDraft || event.isRejected || event.isCancelled}">
                                            <form method="post" action="${pageContext.request.contextPath}/organizer/events/${event.id}/delete" class="d-inline" onsubmit="return confirm('Delete this event permanently? This cannot be undone.')">
                                                <button type="submit" class="btn btn-outline-danger" title="Delete">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </form>
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
                <i class="bi bi-calendar-event display-4 text-muted"></i>
                <h5 class="mt-3 text-muted">You haven't created any events yet</h5>
                <a href="${pageContext.request.contextPath}/organizer/events/create" class="btn btn-primary mt-2">Create Your First Event</a>
            </div>
        </c:if>
    </div>
</div>


<%@ include file="../../footer.jsp" %>
