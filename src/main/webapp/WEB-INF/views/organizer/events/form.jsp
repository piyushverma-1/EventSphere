<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Create Event"/>
<%@ include file="../../header.jsp" %>

<div class="row justify-content-center">
    <div class="col-lg-8">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="h4 fw-bold mb-0">${isEdit ? 'Edit Event' : 'Create New Event'}</h2>
                <p class="text-muted">${isEdit ? 'Update your event details' : 'Fill in the event information'}</p>
            </div>
            <a href="${pageContext.request.contextPath}/organizer/events" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-2"></i>Back
            </a>
        </div>

        <div class="card">
            <div class="card-body">
                <form method="post" action="${pageContext.request.contextPath}/organizer/events${isEdit ? '/' + event.id + '/edit' : '/create'}" data-validate>
                    <c:if test="${isEdit}">
                        <input type="hidden" name="action" value="update">
                    </c:if>

                    <div class="mb-3">
                        <label for="title" class="form-label">Event Title <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="title" name="title" 
                               value="${event.title}" required maxlength="255">
                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control" id="description" name="description" rows="4" maxlength="2000">${event.description}</textarea>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="eventDate" class="form-label">Event Date <span class="text-danger">*</span></label>
                            <input type="date" class="form-control" id="eventDate" name="eventDate" 
                                   value="${event.eventDate != null ? event.eventDate : ''}" required>
                        </div>
                        <div class="col-md-6">
                            <label for="eventTime" class="form-label">Event Time <span class="text-danger">*</span></label>
                            <input type="time" class="form-control" id="eventTime" name="eventTime" 
                                   value="${event.eventTime != null ? event.eventTime : ''}" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="venue" class="form-label">Venue <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="venue" name="venue" 
                               value="${event.venue}" required maxlength="500">
                    </div>

                    <div class="mb-3">
                        <label for="capacity" class="form-label">Capacity <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" id="capacity" name="capacity" 
                               value="${event.capacity}" required min="1">
                        <div class="form-text">Maximum number of attendees allowed</div>
                    </div>

                    <c:if test="${isEdit && event.status == 'PENDING_APPROVAL'}">
                        <div class="alert alert-warning">
                            <i class="bi bi-info-circle me-2"></i>
                            This event is pending approval. Only draft and rejected events can be edited.
                        </div>
                    </c:if>

                    <div class="d-flex gap-2 mt-4">
                        <c:if test="${!isEdit}">
                            <button type="submit" name="action" value="save" class="btn btn-outline-secondary">
                                <i class="bi bi-save me-2"></i>Save as Draft
                            </button>
                        </c:if>
                        <c:if test="${isEdit && event.isDraft || isEdit && event.isRejected}">
                            <button type="submit" name="action" value="save" class="btn btn-outline-secondary">
                                <i class="bi bi-save me-2"></i>Save Changes
                            </button>
                        </c:if>
                        <c:if test="${!isEdit || (isEdit && (event.isDraft || event.isRejected))}">
                            <button type="submit" name="action" value="submit" class="btn btn-primary">
                                <i class="bi bi-send me-2"></i>${isEdit ? 'Resubmit' : 'Submit'} for Approval
                            </button>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/organizer/events${isEdit ? '/' + event.id : ''}" class="btn btn-outline-secondary">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>


<%@ include file="../../footer.jsp" %>

