<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Notification"/>
<%@ include file="../../header.jsp" %>

<div class="row justify-content-center">
    <div class="col-lg-8">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="h4 fw-bold mb-0">Notification</h2>
            </div>
            <a href="${pageContext.request.contextPath}/attendee/notifications" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-2"></i>Back
            </a>
        </div>

        <c:if test="${not empty notification}">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><c:out value="${notification.title}"/></h5>
                    <span class="badge bg-${notification.isRead ? 'secondary' : 'primary'}">
                        ${notification.isRead ? 'Read' : 'New'}
                    </span>
                </div>
                <div class="card-body">
                    <p class="card-text"><c:out value="${notification.message}"/></p>
                    
                    <c:if test="${not empty notification.eventTitle}">
                        <div class="alert alert-info">
                            <i class="bi bi-calendar-event me-2"></i>
                            <strong>Related Event:</strong> <c:out value="${notification.eventTitle}"/>
                        </div>
                    </c:if>

                    <hr class="my-4">
                    
                    <div class="d-flex justify-content-between align-items-center">
                        <small class="text-muted">
                            <i class="bi bi-clock me-1"></i><fmt:formatDate value="${notification.createdAt}" pattern="MMM d, yyyy h:mm a"/>
                        </small>
                        <c:if test="${not notification.isRead}">
                            <form method="post" action="${pageContext.request.contextPath}/attendee/notifications/${notification.id}/read">
                                <button type="submit" class="btn btn-sm btn-outline-primary">
                                    <i class="bi bi-eye me-1"></i>Mark as Read
                                </button>
                            </form>
                        </c:if>
                    </div>
                </div>
            </div>
        </c:if>
        <c:if test="${empty notification}">
            <div class="text-center py-5 text-muted">
                <i class="bi bi-exclamation-circle display-4"></i>
                <h5 class="mt-3">Notification not found</h5>
            </div>
        </c:if>
    </div>
</div>


<%@ include file="../../footer.jsp" %>

