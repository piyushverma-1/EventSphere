<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Create Announcement"/>
<%@ include file="../../header.jsp" %>

<div class="row justify-content-center">
    <div class="col-lg-8">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="h4 fw-bold mb-0">Create Announcement</h2>
                <p class="text-muted">Send a message to attendees of your event</p>
            </div>
            <a href="${pageContext.request.contextPath}/organizer/announcements" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left"></i>
            </a>
        </div>

        <div class="card">
            <div class="card-body">
                <form method="post" action="${pageContext.request.contextPath}/organizer/announcements/create" data-validate>
                    <div class="mb-3">
                        <label for="eventId" class="form-label">Event <span class="text-danger">*</span></label>
                        <select class="form-select" id="eventId" name="eventId" required>
                            <option value="">Select an approved event</option>
                            <c:forEach items="${events}" var="event">
                                <option value="${event.id}" ${param.eventId == event.id ? 'selected' : ''}>${event.title}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="title" class="form-label">Subject <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="title" name="title" required maxlength="255" placeholder="e.g. Important Update About Your Event">
                    </div>

                    <div class="mb-3">
                        <label for="message" class="form-label">Message <span class="text-danger">*</span></label>
                        <textarea class="form-control" id="message" name="message" rows="5" required placeholder="Enter your announcement message..."></textarea>
                    </div>

                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="sendNow" name="sendNow" value="on">
                        <label class="form-check-label" for="sendNow">Send immediately</label>
                        <c:if test="${empty param.eventId}">
                            <input type="hidden" name="eventId" value="${param.eventId}">
                        </c:if>
                    </div>

                    <c:if test="${empty param.eventId}">
                        <div class="mb-3">
                            <label class="form-label">Pre-selected Event ID</label>
                            <input type="hidden" name="eventIdParam" value="${param.eventId}">
                        </div>
                    </c:if>

                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-megaphone me-2"></i>Create Announcement
                        </button>
                        <a href="${pageContext.request.contextPath}/organizer/announcements" class="btn btn-outline-secondary">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>


<%@ include file="../../footer.jsp" %>

