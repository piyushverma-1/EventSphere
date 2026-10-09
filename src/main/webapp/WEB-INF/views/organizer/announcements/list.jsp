<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Announcements"/>
<%@ include file="../../header.jsp" %>

<div class="row mb-4">
    <div class="col-12">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h2 class="h4 fw-bold mb-0">Announcements</h2>
                <p class="text-muted">Send announcements to your event attendees</p>
            </div>
            <a href="${pageContext.request.contextPath}/organizer/announcements/create" class="btn btn-primary">
                <i class="bi bi-plus-lg"></i> New Announcement
            </a>
        </div>
    </div>
</div>

<c:if test="${not empty announcements}">
    <div class="table-responsive">
        <table class="table table-hover">
            <thead>
                <tr>
                    <th>Announcement</th>
                    <th>Event</th>
                    <th>Status</th>
                    <th>Date</th>
                    <th class="text-end">Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${announcements}" var="ann">
                    <tr>
                        <td>
                            <strong><c:out value="${ann.title}"/></strong>
                            <br><small class="text-muted"><c:out value="${ann.message}"/></small>
                        </td>
                        <td><c:out value="${ann.eventTitle}"/></td>
                        <td>
                            <span class="badge bg-${ann.isSent ? 'success' : 'warning'} status-badge">
                                <i class="bi bi-${ann.isSent ? 'send-check' : 'clock'} me-1"></i>
                                ${ann.isSent ? 'Sent' : 'Draft'}
                            </span>
                        </td>
                        <td><c:out value="${ann.formattedCreatedAt}"/></td>
                        <td class="text-end">
                            <a href="${pageContext.request.contextPath}/organizer/announcements/${ann.id}" class="btn btn-sm btn-outline-secondary" title="View">
                                <i class="bi bi-eye"></i>
                            </a>
                            <c:if test="${!ann.isSent}">
                                <form method="post" action="${pageContext.request.contextPath}/organizer/announcements/${ann.id}/send" class="d-inline">
                                    <button type="submit" class="btn btn-sm btn-outline-success" onclick="return confirm('Send this announcement now?')">
                                        <i class="bi bi-send"></i>
                                    </button>
                                </form>
                            </c:if>
                            <form method="post" action="${pageContext.request.contextPath}/organizer/announcements/${ann.id}/delete" class="d-inline" onsubmit="return confirm('Delete this announcement?')">
                                <button type="submit" class="btn btn-sm btn-outline-danger" title="Delete">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</c:if>

<c:if test="${empty announcements}">
    <div class="text-center py-5">
        <i class="bi bi-megaphone display-4 text-muted"></i>
        <h5 class="mt-3 text-muted">No announcements yet</h5>
        <a href="${pageContext.request.contextPath}/organizer/announcements/create" class="btn btn-primary mt-2">Create First Announcement</a>
    </div>
</c:if>


<%@ include file="../../footer.jsp" %>

