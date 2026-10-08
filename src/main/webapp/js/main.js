// EventSphere Main JavaScript

document.addEventListener('DOMContentLoaded', function() {
    // Initialize tooltips
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function(tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });

    // Initialize popovers
    var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'));
    popoverTriggerList.map(function(popoverTriggerEl) {
        return new bootstrap.Popover(popoverTriggerEl);
    });

    // Auto-dismiss alerts after 5 seconds
    setTimeout(function() {
        var alerts = document.querySelectorAll('.alert-dismissible');
        alerts.forEach(function(alert) {
            var bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        });
    }, 5000);

    // Confirm delete actions
    document.querySelectorAll('[data-confirm]').forEach(function(element) {
        element.addEventListener('click', function(e) {
            if (!confirm(this.getAttribute('data-confirm'))) {
                e.preventDefault();
            }
        });
    });

    // Form validation enhancement
    document.querySelectorAll('form[data-validate]').forEach(function(form) {
        form.addEventListener('submit', function(e) {
            var requiredFields = this.querySelectorAll('[required]');
            var valid = true;
            requiredFields.forEach(function(field) {
                if (!field.value.trim()) {
                    field.classList.add('is-invalid');
                    valid = false;
                } else {
                    field.classList.remove('is-invalid');
                }
            });
            if (!valid) {
                e.preventDefault();
                var firstInvalid = this.querySelector('.is-invalid');
                if (firstInvalid) firstInvalid.focus();
            }
        });
    });

    // Password strength indicator
    var passwordFields = document.querySelectorAll('input[type="password"][data-strength]');
    passwordFields.forEach(function(field) {
        field.addEventListener('input', function() {
            var strength = calculatePasswordStrength(this.value);
            updateStrengthIndicator(this, strength);
        });
    });

    // Ticket quantity validation
    document.querySelectorAll('input[name="quantity"]').forEach(function(input) {
        input.addEventListener('change', function() {
            var max = parseInt(this.getAttribute('max')) || 999;
            var min = parseInt(this.getAttribute('min')) || 1;
            var value = parseInt(this.value) || 0;
            if (value > max) this.value = max;
            if (value < min) this.value = min;
        });
    });

    // Dynamic ticket type rows
    var addTicketBtn = document.getElementById('addTicketType');
    if (addTicketBtn) {
        addTicketBtn.addEventListener('click', function() {
            var container = document.getElementById('ticketTypesContainer');
            var index = container.children.length;
            var template = document.getElementById('ticketTypeTemplate');
            if (template) {
                var clone = template.content.cloneNode(true);
                clone.querySelectorAll('[name]').forEach(function(el) {
                    el.name = el.name.replace('[]', '[' + index + ']');
                });
                container.appendChild(clone);
            }
        });
    }

    // Search form debounce
    var searchInput = document.getElementById('eventSearch');
    if (searchInput) {
        var debounceTimer;
        searchInput.addEventListener('input', function() {
            clearTimeout(debounceTimer);
            debounceTimer = setTimeout(function() {
                searchInput.form.submit();
            }, 500);
        });
    }

    // Notification badge update
    updateNotificationBadge();

    // Copy to clipboard functionality
    document.querySelectorAll('[data-copy]').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var targetId = this.getAttribute('data-copy');
            var target = document.getElementById(targetId);
            if (target) {
                navigator.clipboard.writeText(target.textContent || target.value).then(function() {
                    var originalText = btn.innerHTML;
                    btn.innerHTML = '<i class="bi bi-check"></i> Copied!';
                    setTimeout(function() { btn.innerHTML = originalText; }, 2000);
                });
            }
        });
    });
});

function calculatePasswordStrength(password) {
    var strength = 0;
    if (password.length >= 8) strength++;
    if (password.length >= 12) strength++;
    if (/[A-Z]/.test(password)) strength++;
    if (/[a-z]/.test(password)) strength++;
    if (/[0-9]/.test(password)) strength++;
    if (/[^A-Za-z0-9]/.test(password)) strength++;
    return strength;
}

function updateStrengthIndicator(field, strength) {
    var indicator = document.getElementById(field.getAttribute('data-strength'));
    if (!indicator) return;

    var colors = ['#ef4444', '#f59e0b', '#10b981', '#10b981', '#10b981'];
    var labels = ['Very Weak', 'Weak', 'Fair', 'Good', 'Strong'];

    indicator.style.width = ((strength / 5) * 100) + '%';
    indicator.style.backgroundColor = colors[Math.min(strength - 1, 4)] || '#e2e8f0';
    indicator.setAttribute('aria-label', 'Password strength: ' + (labels[Math.min(strength - 1, 4)] || 'None'));
}

function updateNotificationBadge() {
    if (typeof fetch !== 'undefined') {
        fetch('/api/notifications/unread-count')
            .then(function(response) { return response.json(); })
            .then(function(data) {
                var badge = document.getElementById('notifBadge');
                if (badge && data.count > 0) {
                    badge.textContent = data.count;
                    badge.style.display = 'inline-block';
                } else if (badge) {
                    badge.style.display = 'none';
                }
            })
            .catch(function() {});
    }
}

// Format currency
function formatCurrency(amount) {
    return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD'
    }).format(amount);
}

// Format date
function formatDate(dateString) {
    var options = { year: 'numeric', month: 'short', day: 'numeric' };
    return new Date(dateString).toLocaleDateString('en-US', options);
}

// Format datetime
function formatDateTime(dateString) {
    var options = { year: 'numeric', month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' };
    return new Date(dateString).toLocaleDateString('en-US', options);
}

// Show loading state on button
function setButtonLoading(button, loading) {
    if (loading) {
        button.classList.add('btn-loading');
        button.disabled = true;
        button.dataset.originalText = button.innerHTML;
        button.innerHTML = '';
    } else {
        button.classList.remove('btn-loading');
        button.disabled = false;
        if (button.dataset.originalText) {
            button.innerHTML = button.dataset.originalText;
        }
    }
}

// Toggle password visibility
function togglePasswordVisibility(inputId, toggleId) {
    var input = document.getElementById(inputId);
    var toggle = document.getElementById(toggleId);
    if (input && toggle) {
        if (input.type === 'password') {
            input.type = 'text';
            toggle.innerHTML = '<i class="bi bi-eye-slash"></i>';
        } else {
            input.type = 'password';
            toggle.innerHTML = '<i class="bi bi-eye"></i>';
        }
    }
}

// Print ticket
function printTicket() {
    var ticketElement = document.getElementById('ticketPrint');
    if (ticketElement) {
        var printWindow = window.open('', '_blank');
        printWindow.document.write('<!DOCTYPE html><html><head><title>Event Ticket</title>');
        printWindow.document.write('<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">');
        printWindow.document.write('<style>@media print { .no-print { display: none !important; } body { padding: 20px; } }</style>');
        printWindow.document.write('</head><body>');
        printWindow.document.write(ticketElement.outerHTML);
        printWindow.document.write('</body></html>');
        printWindow.document.close();
        printWindow.focus();
        setTimeout(function() { printWindow.print(); }, 500);
    }
}