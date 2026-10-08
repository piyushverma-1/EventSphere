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
                <p class="text-muted mb-0"><c:out value="${event.organizerName}"/></p>
            </div>
            <a href="${pageContext.request.contextPath}/events" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-2"></i>Back to Browse
            </a>
        </div>
    </div>
</div>

<div class="row">
    <!-- Event Details -->
    <div class="col-lg-8">
        <div class="card mb-4">
            <div class="card-body">
                <div class="event-image mb-4" style="height: 250px;">
                    <i class="bi bi-calendar-event" style="font-size: 4rem;"></i>
                </div>

                <h3 class="mb-3"><c:out value="${event.title}"/></h3>

                <dl class="row">
                    <dt class="col-sm-3">Date & Time</dt>
                    <dd class="col-sm-9">
                        <fmt:formatDate value="${event.eventDate}" pattern="EEEE, MMMM d, yyyy"/>
                        at <fmt:formatDate value="${event.eventTime}" pattern="h:mm a"/>
                    </dd>
                    <dt class="col-sm-3">Venue</dt>
                    <dd class="col-sm-9"><c:out value="${event.venue}"/></dd>
                    <dt class="col-sm-3">Organizer</dt>
                    <dd class="col-sm-9"><c:out value="${event.organizerName}"/></dd>
                    <dt class="col-sm-3">Capacity</dt>
                    <dd class="col-sm-9">${event.capacity} attendees</dd>
                </dl>

                <h5 class="mt-4">Description</h5>
                <p><c:out value="${event.description}"/></p>
            </div>
        </div>

        <!-- Ticket Types -->
        <div class="card mb-4">
            <div class="card-header">
                <h6 class="mb-0">Available Tickets</h6>
            </div>
            <div class="card-body p-0">
                <c:if test="${not empty tickets}">
                    <table class="table table-hover mb-0">
                        <thead>
                            <tr>
                                <th>Ticket Type</th>
                                <th>Price</th>
                                <th>Available</th>
                                <th>Sold</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${tickets}" var="ticket">
                                <tr>
                                    <td>
                                        <strong><c:out value="${ticket.name}"/></strong>
                                        <br><small class="text-muted"><c:out value="${ticket.description}"/></small>
                                    </td>
                                    <td>$${ticket.price}</td>
                                    <td><span class="text-success">${ticket.availableCount}</span></td>
                                    <td>${ticket.soldCount}</td>
                                </tr>
                            </tbody>
                        </table>
                    </c:if>
                    <c:if test="${empty tickets}">
                        <div class="text-center py-4 text-muted">
                            <p class="mb-0">No tickets are currently available for this event</p>
                        </div>
                    </c:if>
                </div>

                <c:if test="${empty existingRegistration && not empty tickets}">
                    <div class="text-center pt-3 border-top">
                        <a href="${pageContext.request.contextPath}/events/${event.id}/register" class="btn btn-success btn-lg">
                            <i class="bi bi-ticket-perforated me-2"></i>Register Now
                        </a>
                    </div>
                </c:if>
                <c:if test="${not empty existingRegistration}">
                    <div class="text-center pt-3 border-top">
                        <span class="badge bg-success status-badge me-2">
                            <i class="bi bi-check-circle me-1"></i>Registered
                        </span>
                        Your booking reference: <strong><c:out value="${existingRegistration.bookingReference}"/></strong>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Sidebar -->
    <div class="col-lg-4">
        <div class="card mb-4">
            <div class="card-header">Event Summary</div>
            <div class="card-body">
                <div class="text-center mb-3">
                    <i class="bi bi-person fs-1 text-primary"></i>
                    <div class="mt-1"><strong>Organized by</strong></div>
                    <div><c:out value="${event.organizerName}"/></div>
                </div>
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
                <c:if test="${event.availableTickets <= 0 || event.availableTickets == null}">
                    <div class="alert alert-warning mt-3 mb-0">
                        <i class="bi bi-exclamation-triangle me-2"></i>This event is sold out!
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>



<%@ include file="../../footer.jsp" %>

