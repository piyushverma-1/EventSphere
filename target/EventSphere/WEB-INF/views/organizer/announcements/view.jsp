<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Announcement Details"/>
<%@ include file="../../header.jsp" %>

<div class="row justify-content-center">
    <div class="col-lg-8">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="h4 fw-bold mb-0">Announcement Details</h2>
            </div>
            <a href="${pageContext.request.contextPath}/organizer/announcements" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-2"></i>Back
            </a>
        </div>

        <c:if test="${not empty announcement}">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><c:out value="${announcement.title}"/></h5>
                    <span class="badge bg-${announcement.isSent ? 'success' : 'warning'} status-badge">
                        <i class="bi bi-${announcement.isSent ? 'send-check' : 'clock'} me-1"></i>
                        ${announcement.isSent ? 'Sent' : 'Draft'}
                    </span>
                </div>
                <div class="card-body">
                    <dl class="row">
                        <dt class="col-sm-3">Message</dt>
                        <dd class="col-sm-9"><c:out value="${announcement.message}"/></dd>
                        <dt class="col-sm-3">Event</dt>
                        <dd class="col-sm-9"><c:out value="${announcement.eventTitle}"/></dd>
                        <dt class="col-sm-3">Organizer</dt>
                        <dd class="col-sm-9"><c:out value="${announcement.organizerName}"/></dd>
                        <dt class="col-sm-3">Created</dt>
                        <dd class="col-sm-9"><fmt:formatDate value="${announcement.createdAt}" pattern="MMM d, yyyy h:mm a"/></dd>
                        <c:if test="${announcement.sentAt != null}">
                            <dt class="col-sm-3">Sent At</dt>
                            <dd class="col-sm-9"><fmt:formatDate value="${announcement.sentAt}" pattern="MMM d, yyyy h:mm a"/></dd>
                        </c:if>
                    </dl>
                </div>
            </div>

            <div class="card mt-4">
                <div class="card-header">Actions</div>
                <div class="card-body">
                    <div class="d-grid gap-2">
                        <c:if test="${!announcement.isSent}">
                            <form method="post" action="${pageContext.request.contextPath}/organizer/announcements/${announcement.id}/send" onsubmit="return confirm('Send this announcement now?')">
                                <button type="submit" class="btn btn-success w-100">
                                    <i class="bi bi-send me-2"></i>Send Now
                                </button>
                            </form>
                        </c:if>
                        <form method="post" action="${pageContext.request.contextPath}/organizer/announcements/${announcement.id}/delete" onsubmit="return confirm('Delete this announcement?')">
                            <button type="submit" class="btn btn-danger w-100">
                                <i class="bi bi-trash me-2"></i>Delete
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </c:if>

        <c:if test="${empty announcement}">
            <div class="text-center py-5 text-muted">
                <i class="bi bi-exclamation-circle display-4"></i>
                <h5 class="mt-3">Announcement not found</h5>
            </div>
        </c:if>
    </div>
</div>
<%@ include file="../../footer.jsp" %>