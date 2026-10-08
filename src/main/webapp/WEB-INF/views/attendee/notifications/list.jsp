<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Notifications"/>
<%@ include file="../../header.jsp" %>

<div class="row mb-4">
    <div class="col-12">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h2 class="h4 fw-bold mb-0">Notifications</h2>
                <p class="text-muted">Stay updated with event announcements</p>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/attendee/notifications/mark-all-read">
                <button type="submit" class="btn btn-outline-primary" onclick="return confirm('Mark all notifications as read?')">
                    <i class="bi bi-check-all me-2"></i>Mark All as Read
                </button>
            </form>
        </div>
    </div>
</div>

<ul class="nav nav-pills mb-4" id="notifTabs" role="tablist">
    <li class="nav-item" role="presentation">
        <a class="nav-link ${empty filter || filter == 'all' ? 'active' : ''}" 
           href="${pageContext.request.contextPath}/attendee/notifications?filter=all">
            All (${fn:length(notifications)})
        </a>
    </li>
    <li class="nav-item" role="presentation">
        <a class="nav-link ${filter == 'unread' ? 'active' : ''}" 
           href="${pageContext.request.contextPath}/attendee/notifications?filter=unread">
            Unread (${unreadCount})
        </a>
    </li>
</ul>

<c:if test="${not empty notifications}">
    <div class="list-group">
        <c:forEach items="${notifications}" var="notif">
            <div class="list-group-item ${notif.isRead ? '' : 'bg-primary bg-opacity-10'}">
                <div class="d-flex justify-content-between align-items-start">
                    <div class="flex-grow-1">
                        <h6 class="mb-1 ${notif.isRead ? '' : 'fw-bold'}">
                            <c:out value="${notif.title}"/>
                        </h6>
                        <p class="mb-0 text-muted small">
                            <c:out value="${notif.message}"/>
                        </p>
                        <c:if test="${not empty notif.eventTitle}">
                            <small class="text-muted">
                                <i class="bi bi-calendar-event me-1"></i>Event: <c:out value="${notif.eventTitle}"/>
                            </small>
                        </c:if>
                        <div class="mt-1">
                            <small class="text-muted">
                                <i class="bi bi-clock me-1"></i><fmt:formatDate value="${notif.createdAt}" pattern="MMM d, yyyy h:mm a"/>
                            </small>
                            <c:if test="${notif.readAt != null}">
                                | <small class="text-muted">
                                    <i class="bi bi-eye me-1"></i>Read <fmt:formatDate value="${notif.readAt}" pattern="h:mm a"/>
                                </small>
                            </c:if>
                        </div>
                    </div>
                    <div class="ms-3">
                        <c:if test="${!notif.isRead}">
                            <span class="badge bg-primary mb-2">New</span>
                        </c:if>
                        <form method="post" action="${pageContext.request.contextPath}/attendee/notifications/${notif.id}/read">
                            <button type="submit" class="btn btn-sm btn-outline-secondary ${notif.isRead ? 'd-none' : ''}">
                                <i class="bi bi-eye"></i> Mark Read
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</c:if>

<c:if test="${empty notifications}">
    <div class="text-center py-5">
        <i class="bi bi-bell-slash display-4 text-muted"></i>
        <h5 class="mt-3 text-muted">No notifications</h5>
        <p class="text-muted">You'll see event announcements and updates here</p>
    </div>
</c:if>


<%@ include file="../../footer.jsp" %>

