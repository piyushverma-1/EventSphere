<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="User Management"/>
<%@ include file="../../header.jsp" %>

<div class="row mb-4">
    <div class="col-12">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h2 class="h4 fw-bold mb-0">User Management</h2>
                <p class="text-muted">Manage system users and their roles</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/users/create" class="btn btn-primary">
                <i class="bi bi-person-plus me-2"></i>Add User
            </a>
        </div>
    </div>
</div>

<!-- Stats -->
<div class="row g-3 mb-4">
    <div class="col-md-3">
        <div class="stat-card">
            <div class="stat-label">Total Users</div>
            <div class="stat-value">${totalUsers}</div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="stat-card success">
            <div class="stat-label">Attendees</div>
            <div class="stat-value">${attendeeCount}</div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="stat-card warning">
            <div class="stat-label">Organizers</div>
            <div class="stat-value">${organizerCount}</div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="stat-card danger">
            <div class="stat-label">Admins</div>
            <div class="stat-value">${adminCount}</div>
        </div>
    </div>
</div>

<!-- Filters -->
<div class="card mb-4">
    <div class="card-body">
        <form method="get" class="row g-3">
            <div class="col-md-3">
                <label class="form-label visually-hidden">Search</label>
                <input type="text" class="form-control" name="search" placeholder="Search by name or email..." value="${search}">
            </div>
            <div class="col-md-2">
                <label class="form-label visually-hidden">Role</label>
                <select class="form-select" name="role">
                    <option value="">All Roles</option>
                    <option value="ADMIN" ${roleFilter == 'ADMIN' ? 'selected' : ''}>Admin</option>
                    <option value="ORGANIZER" ${roleFilter == 'ORGANIZER' ? 'selected' : ''}>Organizer</option>
                    <option value="ATTENDEE" ${roleFilter == 'ATTENDEE' ? 'selected' : ''}>Attendee</option>
                </select>
            </div>
            <div class="col-md-2">
                <label class="form-label visually-hidden">Status</label>
                <select class="form-select" name="status">
                    <option value="">All Status</option>
                    <option value="active" ${statusFilter == 'active' ? 'selected' : ''}>Active</option>
                    <option value="inactive" ${statusFilter == 'inactive' ? 'selected' : ''}>Inactive</option>
                </select>
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn btn-outline-primary w-100">Filter</button>
            </div>
            <div class="col-md-2">
                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary w-100">Reset</a>
            </div>
        </form>
    </div>
</div>

<!-- Users Table -->
<div class="card">
    <div class="card-body p-0">
        <c:if test="${not empty users}">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>User</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Registered</th>
                            <th>Last Login</th>
                            <th class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${users}" var="user">
                            <tr>
                                <td>
                                    <div>
                                        <strong><c:out value="${user.fullName}"/></strong>
                                        <br>
                                        <small class="text-muted"><c:out value="${user.email}"/></small>
                                    </div>
                                </td>
                                <td>
                                    <span class="badge bg-primary"><c:out value="${user.role}"/></span>
                                </td>
                                <td>
                                    <span class="badge ${user.isActive ? 'bg-success' : 'bg-danger'}">
                                        ${user.isActive ? 'Active' : 'Inactive'}
                                    </span>
                                </td>
                                <td><c:out value="${user.formattedCreatedAt}"/></td>
                                <td><c:out value="${user.formattedLastLogin}"/></td>
                                <td class="text-end">
                                    <div class="btn-group btn-group-sm">
                                        <a href="${pageContext.request.contextPath}/admin/users/${user.id}" class="btn btn-outline-secondary" title="View">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/users/${user.id}/edit" class="btn btn-outline-secondary" title="Edit">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <c:if test="${user.id != sessionScope.currentUser.id}">
                                            <form method="post" action="${pageContext.request.contextPath}/admin/users/${user.id}/toggle" class="d-inline" onsubmit="return confirm('Are you sure?')">
                                                <button type="submit" class="btn btn-outline-${user.isActive ? 'warning' : 'success'}" title="${user.isActive ? 'Deactivate' : 'Activate'}">
                                                    <i class="bi bi-${user.isActive ? 'person-x' : 'person-check'}"></i>
                                                </button>
                                            </form>
                                            <a href="${pageContext.request.contextPath}/admin/users/${user.id}/reset-password" class="btn btn-outline-info" title="Reset Password" onclick="return confirm('Reset password for this user?')">
                                                <i class="bi bi-key"></i>
                                            </a>
                                            <form method="post" action="${pageContext.request.contextPath}/admin/users/${user.id}/delete" class="d-inline" onsubmit="return confirm('Delete this user permanently?')">
                                                <button type="submit" class="btn btn-outline-danger" title="Delete">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${user.id == sessionScope.currentUser.id}">
                                            <span class="text-muted small">(You)</span>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
        <c:if test="${empty users}">
            <div class="text-center py-5">
                <i class="bi bi-people display-4 text-muted"></i>
                <h5 class="mt-3 text-muted">No users found</h5>
                <a href="${pageContext.request.contextPath}/admin/users/create" class="btn btn-primary mt-2">Add First User</a>
            </div>
        </c:if>
    </div>
</div>


<%@ include file="../../footer.jsp" %>

