<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="User Form"/>
<%@ include file="../../header.jsp" %>

<div class="row justify-content-center">
    <div class="col-lg-8">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="h4 fw-bold mb-0">${isEdit ? 'Edit User' : 'Create New User'}</h2>
                <p class="text-muted">${isEdit ? 'Update user information' : 'Add a new user to the system'}</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-2"></i>Back
            </a>
        </div>

        <div class="card">
            <div class="card-body">
                <form method="post" action="${pageContext.request.contextPath}/admin/users${isEdit ? '/' + user.id + '/edit' : '/create'}" data-validate>
                    <c:if test="${isEdit}">
                        <input type="hidden" name="action" value="update">
                    </c:if>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="fullName" class="form-label">Full Name <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="fullName" name="fullName" 
                                   value="${user.fullName}" required autocomplete="name" autofocus>
                        </div>
                        <div class="col-md-6">
                            <label for="email" class="form-label">Email Address <span class="text-danger">*</span></label>
                            <input type="email" class="form-control" id="email" name="email" 
                                   value="${user.email}" required autocomplete="email">
                        </div>
                    </div>

                    <c:if test="${!isEdit}">
                        <div class="mb-3">
                            <label for="password" class="form-label">Password <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <input type="password" class="form-control" id="password" name="password" 
                                       required autocomplete="new-password" data-strength="passwordStrength" minlength="8">
                                <button class="btn btn-outline-secondary" type="button" onclick="togglePasswordVisibility('password', 'togglePassword')">
                                    <i class="bi bi-eye" id="togglePassword"></i>
                                </button>
                            </div>
                            <div class="mt-2">
                                <div class="progress" style="height: 4px;">
                                    <div class="progress-bar" id="passwordStrength" style="width: 0%;"></div>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <div class="row mb-3">
                        <div class="col-md-4">
                            <label for="role" class="form-label">Role <span class="text-danger">*</span></label>
                            <select class="form-select" id="role" name="role" required>
                                <option value="ATTENDEE" ${user.role == 'ATTENDEE' ? 'selected' : ''}>Attendee</option>
                                <option value="ORGANIZER" ${user.role == 'ORGANIZER' ? 'selected' : ''}>Organizer</option>
                                <option value="ADMIN" ${user.role == 'ADMIN' ? 'selected' : ''}>Admin</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label for="phone" class="form-label">Phone Number</label>
                            <input type="tel" class="form-control" id="phone" name="phone" 
                                   value="${user.phone}" placeholder="+1 (555) 000-0000">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label d-block">&nbsp;</label>
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" id="isActive" name="isActive" 
                                       ${user.isActive ? 'checked' : ''}>
                                <label class="form-check-label" for="isActive">Active</label>
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="address" class="form-label">Address</label>
                        <textarea class="form-control" id="address" name="address" rows="3">${user.address}</textarea>
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-${isEdit ? 'save' : 'person-plus'} me-2"></i>${isEdit ? 'Update User' : 'Create User'}
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>


<%@ include file="../../footer.jsp" %>

