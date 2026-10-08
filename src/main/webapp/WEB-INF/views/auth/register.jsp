<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - EventSphere</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body class="auth-body-bg">
    <div class="auth-bg-blob auth-blob-1"></div>
    <div class="auth-bg-blob auth-blob-2"></div>
    <div class="auth-page">
        <div class="card auth-card shadow-lg border-0" style="max-width: 540px;">
            <div class="auth-header">
                <a href="${pageContext.request.contextPath}/" class="auth-brand-logo text-decoration-none d-inline-flex align-items-center mb-3">
                    <span class="auth-brand-icon me-2">
                        <i class="bi bi-calendar2-event-fill"></i>
                    </span>
                    <span class="auth-brand-name">Event<span>Sphere</span></span>
                </a>
                <h1 class="auth-title">Create Account</h1>
                <p class="auth-subtitle">Join EventSphere to discover and manage events</p>
            </div>
            <div class="auth-body">
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <c:out value="${errorMessage}"/>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <c:out value="${successMessage}"/>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <form method="post" action="${pageContext.request.contextPath}/register" data-validate>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="fullName" class="form-label">Full Name</label>
                            <input type="text" class="form-control" id="fullName" name="fullName" 
                                   value="${fullName}" required autocomplete="name" autofocus>
                        </div>
                        <div class="col-md-6">
                            <label for="role" class="form-label">Register As</label>
                            <select class="form-select" id="role" name="role" required>
                                <option value="ATTENDEE" ${role == 'ATTENDEE' ? 'selected' : ''}>Attendee</option>
                                <option value="ORGANIZER" ${role == 'ORGANIZER' ? 'selected' : ''}>Organizer</option>
                            </select>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label">Email Address</label>
                        <input type="email" class="form-control" id="email" name="email" 
                               value="${email}" required autocomplete="email">
                    </div>
                    <div class="mb-3">
                        <label for="phone" class="form-label">Phone Number (Optional)</label>
                        <input type="tel" class="form-control" id="phone" name="phone" 
                               value="${phone}" placeholder="+1 (555) 000-0000">
                    </div>
                    <div class="mb-3">
                        <label for="address" class="form-label">Address (Optional)</label>
                        <textarea class="form-control" id="address" name="address" rows="2">${address}</textarea>
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label">Password</label>
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
                            <small class="text-muted">Password strength</small>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">Confirm Password</label>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required autocomplete="new-password">
                    </div>
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="terms" required>
                        <label class="form-check-label" for="terms">I agree to the <a href="#">Terms of Service</a> and <a href="#">Privacy Policy</a></label>
                    </div>
                    <button type="submit" class="btn btn-primary w-100 mb-3">
                        <i class="bi bi-person-plus me-2"></i>Create Account
                    </button>
                </form>
            </div>
            <div class="auth-footer">
                <p class="mb-0">Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in</a></p>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>