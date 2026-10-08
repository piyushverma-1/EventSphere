<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Browse Events"/>
<%@ include file="../../header.jsp" %>

<div class="row mb-4">
    <div class="col-12">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h2 class="h4 fw-bold mb-0">Browse Events</h2>
                <p class="text-muted">Find and register for events you'll love</p>
            </div>
            <form method="get" class="d-flex gap-2">
                <div class="input-group" style="width: 400px;">
                    <input type="text" class="form-control" name="search" placeholder="Search events..." value="${search}">
                    <button type="submit" class="btn btn-outline-primary">
                        <i class="bi bi-search"></i>
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Filters -->
<div class="card mb-4">
    <div class="card-body">
        <form method="get" class="row g-3">
            <div class="col-md-3">
                <label class="form-label">Search</label>
                <input type="text" class="form-control" name="search" placeholder="Event name, venue..." value="${search}">
            </div>
            <div class="col-md-2">
                <label class="form-label">Date From</label>
                <input type="date" class="form-control" name="dateFrom" value="${dateFrom}">
            </div>
            <div class="col-md-2">
                <label class="form-label">Date To</label>
                <input type="date" class="form-control" name="dateTo" value="${dateTo}">
            </div>
            <div class="col-md-2 d-flex align-items-end">
                <button type="submit" class="btn btn-primary w-100">
                    <i class="bi bi-funnel me-1"></i>Filter
                </button>
            </div>
            <div class="col-md-2 d-flex align-items-end">
                <a href="${pageContext.request.contextPath}/events" class="btn btn-outline-secondary w-100">Reset</a>
            </div>
        </form>
    </div>
</div>

<!-- Events Grid -->
<c:if test="${not empty events}">
    <div class="row event-grid">
        <c:forEach items="${events}" var="event">
            <div class="col">
                <div class="card event-card h-100">
                    <div class="event-image">
                        <i class="bi bi-calendar-event"></i>
                    </div>
                    <div class="card-body d-flex flex-column">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <h5 class="card-title mb-0"><c:out value="${event.title}"/></h5>
                            <c:if test="${event.status == 'APPROVED'}">
                                <span class="badge bg-success status-badge">
                                    <i class="bi bi-check-circle-fill me-1"></i>Approved
                                </span>
                            </c:if>
                        </div>
                        <p class="card-text text-muted small"><c:out value="${event.description}"/></p>
                        <div class="mb-2">
                            <small class="text-muted">
                                <i class="bi bi-calendar me-1"></i>
                                <fmt:formatDate value="${event.eventDate}" pattern="MMM d, yyyy"/>
                                at <fmt:formatDate value="${event.eventTime}" pattern="h:mm a"/>
                            </small>
                        </div>
                        <div class="mb-2">
                            <small class="text-muted">
                                <i class="bi bi-geo-alt me-1"></i><c:out value="${event.venue}"/>
                            </small>
                        </div>
                        <div class="mb-3">
                            <small class="text-muted">
                                <i class="bi bi-people me-1"></i>
                                ${event.soldTickets} / ${event.capacity} registered
                            </small>
                            <div class="progress mt-1" style="height: 6px;">
                                <c:set var="fillRate" value="${event.capacity > 0 ? (event.soldTickets * 100 / event.capacity) : 0}"/>
                                <div class="progress-bar ${event.soldTickets >= event.capacity ? 'bg-danger' : 'bg-success'}" role="progressbar" style="width: ${fillRate}%;"></div>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/events/${event.id}" class="btn btn-outline-primary mt-auto">
                            <i class="bi bi-eye me-2"></i>View Details
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</c:if>

<c:if test="${empty events}">
    <div class="text-center py-5">
        <i class="bi bi-search display-4 text-muted"></i>
        <h3 class="mt-3 text-muted">No events found</h3>
        <p class="text-muted">Try adjusting your search criteria</p>
    </div>
</c:if>


<%@ include file="../../footer.jsp" %>

