<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In - EventSphere</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body class="auth-body-bg">
    <!-- Ambient Animated Background Elements -->
    <div class="auth-bg-blob auth-blob-1"></div>
    <div class="auth-bg-blob auth-blob-2"></div>
    <div class="auth-bg-blob auth-blob-3"></div>

    <div class="auth-page">
        <div class="card auth-card shadow-lg border-0">
            <!-- Brand & Header -->
            <div class="auth-header">
                <a href="${pageContext.request.contextPath}/" class="auth-brand-logo text-decoration-none d-inline-flex align-items-center mb-3">
                    <span class="auth-brand-icon me-2">
                        <i class="bi bi-calendar2-event-fill"></i>
                    </span>
                    <span class="auth-brand-name">Event<span>Sphere</span></span>
                </a>
                <h1 class="auth-title">Welcome Back</h1>
                <p class="auth-subtitle">Sign in to manage your tickets, events & experiences</p>

                <!-- Interactive Demo Accounts Switcher -->
                <div class="demo-accounts-box mt-3 p-2 rounded-3">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="demo-box-label"><i class="bi bi-lightning-charge-fill text-warning me-1"></i>One-Click Demo Login</span>
                        <span id="demoFeedback" class="demo-feedback-badge d-none"></span>
                    </div>
                    <div class="d-flex gap-2 justify-content-center flex-wrap">
                        <button type="button" class="btn btn-sm demo-role-btn demo-btn-admin" onclick="fillCredentials('admin@eventsphere.com', 'admin123', 'Admin')">
                            <i class="bi bi-shield-check me-1"></i>Admin
                        </button>
                        <button type="button" class="btn btn-sm demo-role-btn demo-btn-organizer" onclick="fillCredentials('organizer@eventsphere.com', 'organizer123', 'Organizer')">
                            <i class="bi bi-award me-1"></i>Organizer
                        </button>
                        <button type="button" class="btn btn-sm demo-role-btn demo-btn-attendee" onclick="fillCredentials('attendee@eventsphere.com', 'attendee123', 'Attendee')">
                            <i class="bi bi-ticket-perforated me-1"></i>Attendee
                        </button>
                    </div>
                </div>
            </div>

            <!-- Auth Body & Form -->
            <div class="auth-body">
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center mb-3" role="alert">
                        <i class="bi bi-exclamation-triangle-fill fs-5 me-2 flex-shrink-0"></i>
                        <div><c:out value="${errorMessage}"/></div>
                        <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show d-flex align-items-center mb-3" role="alert">
                        <i class="bi bi-check-circle-fill fs-5 me-2 flex-shrink-0"></i>
                        <div><c:out value="${successMessage}"/></div>
                        <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/login" id="loginForm" data-validate novalidate>
                    <!-- Email Field -->
                    <div class="mb-3">
                        <label for="email" class="form-label fw-semibold">Email Address</label>
                        <div class="input-group input-group-lg modern-input-group">
                            <span class="input-group-text bg-white border-end-0 text-muted">
                                <i class="bi bi-envelope"></i>
                            </span>
                            <input type="email" class="form-control border-start-0 ps-1" id="email" name="email" 
                                   value="${email}" placeholder="you@example.com" required autocomplete="email" autofocus>
                        </div>
                        <div class="invalid-feedback">Please enter a valid email address.</div>
                    </div>

                    <!-- Password Field -->
                    <div class="mb-3">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <label for="password" class="form-label fw-semibold mb-0">Password</label>
                            <span id="capsLockWarning" class="caps-lock-warning d-none text-warning small">
                                <i class="bi bi-capslock-fill me-1"></i>Caps Lock is ON
                            </span>
                        </div>
                        <div class="input-group input-group-lg modern-input-group">
                            <span class="input-group-text bg-white border-end-0 text-muted">
                                <i class="bi bi-lock"></i>
                            </span>
                            <input type="password" class="form-control border-start-0 border-end-0 ps-1" id="password" name="password" 
                                   placeholder="••••••••" required autocomplete="current-password">
                            <button class="btn btn-outline-light border border-start-0 text-muted bg-white px-3" type="button" 
                                    id="togglePasswordBtn" onclick="togglePasswordVisibility('password', 'togglePasswordBtn')" title="Show/Hide Password">
                                <i class="bi bi-eye"></i>
                            </button>
                        </div>
                        <div class="invalid-feedback">Password is required.</div>
                    </div>

                    <!-- Remember & Options -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" role="switch" id="remember" name="remember" checked>
                            <label class="form-check-label text-muted small" for="remember">Remember me</label>
                        </div>
                        <a href="javascript:void(0)" onclick="showForgotTooltip()" class="text-primary text-decoration-none small fw-semibold">Forgot password?</a>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" class="btn btn-primary btn-lg w-100 auth-submit-btn shadow-sm" id="submitBtn">
                        <span class="btn-text d-inline-flex align-items-center justify-content-center">
                            Sign In to Account <i class="bi bi-arrow-right ms-2"></i>
                        </span>
                        <span class="btn-spinner spinner-border spinner-border-sm ms-2 d-none" role="status"></span>
                    </button>
                </form>
            </div>

            <!-- Auth Footer -->
            <div class="auth-footer text-center">
                <p class="mb-2 text-muted">
                    Don't have an account yet? 
                    <a href="${pageContext.request.contextPath}/register" class="text-primary fw-bold text-decoration-none ms-1">Create Account</a>
                </p>
                <div class="mt-3 pt-2 border-top">
                    <a href="${pageContext.request.contextPath}/" class="text-muted text-decoration-none small d-inline-flex align-items-center">
                        <i class="bi bi-house me-1"></i> Back to Homepage
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script>
        // Interactive One-Click Fill for Demo Accounts
        function fillCredentials(email, password, roleName) {
            const emailInput = document.getElementById('email');
            const passwordInput = document.getElementById('password');
            const feedback = document.getElementById('demoFeedback');

            emailInput.value = email;
            passwordInput.value = password;

            // Highlight inputs with a pulse effect
            emailInput.classList.add('input-fill-highlight');
            passwordInput.classList.add('input-fill-highlight');
            setTimeout(() => {
                emailInput.classList.remove('input-fill-highlight');
                passwordInput.classList.remove('input-fill-highlight');
            }, 1000);

            // Show feedback badge
            feedback.innerHTML = '<i class="bi bi-check2-circle me-1"></i>' + roleName + ' filled!';
            feedback.className = 'demo-feedback-badge d-inline-block animate-fade-in';
            setTimeout(() => {
                feedback.className = 'demo-feedback-badge d-none';
            }, 3000);
        }

        // Caps Lock Detection
        const pwdInput = document.getElementById('password');
        const capsWarning = document.getElementById('capsLockWarning');
        if (pwdInput && capsWarning) {
            pwdInput.addEventListener('keyup', function(event) {
                if (event.getModifierState && event.getModifierState('CapsLock')) {
                    capsWarning.classList.remove('d-none');
                } else {
                    capsWarning.classList.add('d-none');
                }
            });
        }

        // Show Forgot Password alert tooltip
        function showForgotTooltip() {
            alert('Default accounts:\n• admin@eventsphere.com / admin123\n• organizer@eventsphere.com / organizer123\n• attendee@eventsphere.com / attendee123\n\nYou can click the Demo buttons at the top to auto-fill!');
        }

        // Form Submit Loading State
        const form = document.getElementById('loginForm');
        if (form) {
            form.addEventListener('submit', function(e) {
                if (form.checkValidity()) {
                    const btn = document.getElementById('submitBtn');
                    const btnText = btn.querySelector('.btn-text');
                    const spinner = btn.querySelector('.btn-spinner');
                    btn.disabled = true;
                    btnText.innerHTML = 'Signing In...';
                    spinner.classList.remove('d-none');
                    form.submit();
                }
            });
        }
    </script>
</body>
</html>