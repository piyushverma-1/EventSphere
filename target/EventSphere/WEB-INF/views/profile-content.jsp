<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Profile"/>
<%@ include file="../header.jsp" %>

<div class="row">
    <div class="col-lg-8 mx-auto">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="h4 fw-bold mb-0">Profile Settings</h2>
        </div>

        <div class="card mb-4">
            <div class="card-header">Profile Information</div>
            <div class="card-body">
                <form method="post" action="${pageContext.request.contextPath}/profile" data-validate>
                    <input type="hidden" name="action" value="updateProfile">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="fullName" class="form-label">Full Name</label>
                            <input type="text" class="form-control" id="fullName" name="fullName" 
                                   value="${sessionScope.currentUser.fullName}" required>
                        </div>
                        <div class="col-md-6">
                            <label for="email" class="form-label">Email Address</label>
                            <input type="email" class="form-control" id="email" name="email" 
                                   value="${sessionScope.currentUser.email}" required>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="phone" class="form-label">Phone Number</label>
                            <input type="tel" class="form-control" id="phone" name="phone" 
                                   value="${sessionScope.currentUser.phone}" placeholder="+1 (555) 000-0000">
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="address" class="form-label">Address</label>
                        <textarea class="form-control" id="address" name="address" rows="3">${sessionScope.currentUser.address}</textarea>
                    </div>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-save me-2"></i>Save Changes
                    </button>
                </form>
            </div>
        </div>

        <div class="card mb-4">
            <div class="card-header">Change Password</div>
            <div class="card-body">
                <form method="post" action="${pageContext.request.contextPath}/profile" data-validate>
                    <input type="hidden" name="action" value="changePassword">
                    <div class="mb-3">
                        <label for="currentPassword" class="form-label">Current Password</label>
                        <input type="password" class="form-control" id="currentPassword" name="currentPassword" required autocomplete="current-password">
                    </div>
                    <div class="mb-3">
                        <label for="newPassword" class="form-label">New Password</label>
                        <div class="input-group">
                            <input type="password" class="form-control" id="newPassword" name="newPassword" 
                                   required autocomplete="new-password" data-strength="passwordStrength2" minlength="8">
                            <button class="btn btn-outline-secondary" type="button" onclick="togglePasswordVisibility('newPassword', 'toggleNewPassword')">
                                <i class="bi bi-eye" id="toggleNewPassword"></i>
                            </button>
                        </div>
                        <div class="mt-2">
                            <div class="progress" style="height: 4px;">
                                <div class="progress-bar" id="passwordStrength2" style="width: 0%;"></div>
                            </div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="confirmNewPassword" class="form-label">Confirm New Password</label>
                        <input type="password" class="form-control" id="confirmNewPassword" name="confirmPassword" required autocomplete="new-password">
                    </div>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-key me-2"></i>Update Password
                    </button>
                </form>
            </div>
        </div>

        <div class="card">
            <div class="card-header">Account Information</div>
            <div class="card-body">
                <dl class="row mb-0">
                    <dt class="col-sm-3">Role</dt>
                    <dd class="col-sm-9">
                        <span class="badge bg-primary">${sessionScope.currentUser.role}</span>
                    </dd>
                    <dt class="col-sm-3">Member Since</dt>
                    <dd class="col-sm-9"><c:out value="${sessionScope.currentUser.createdAt}"/></dd>
                    <dt class="col-sm-3">Last Login</dt>
                    <dd class="col-sm-9"><c:out value="${sessionScope.currentUser.lastLogin}"/></dd>
                    <dt class="col-sm-3">Status</dt>
                    <dd class="col-sm-9">
                        <span class="badge ${sessionScope.currentUser.isActive ? 'bg-success' : 'bg-danger'}">
                            ${sessionScope.currentUser.isActive ? 'Active' : 'Inactive'}
                        </span>
                    </dd>
                </dl>
            </div>
        </div>
    </div>
</div>

<%@ include file="../footer.jsp" %>
