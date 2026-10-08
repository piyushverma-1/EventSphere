<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Ticket View"/>
<%@ include file="../../header.jsp" %>

<div class="row justify-content-center">
    <div class="col-lg-8">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="h4 fw-bold mb-0">Digital Ticket</h2>
            </div>
            <a href="${pageContext.request.contextPath}/attendee/tickets" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-2"></i>Back to Tickets
            </a>
        </div>

        <div id="ticketPrint">
            <div class="ticket-detail text-center text-white mb-4">
                <div class="ticket-perforation"></div>
                <div class="mb-4">
                    <i class="bi bi-qr-code-scan" style="font-size: 4rem;"></i>
                </div>
                <div class="ticket-code">
                    <c:out value="${digitalTicket.ticketCode}"/>
                </div>
                <div class="mt-3">
                    <h3 class="fw-bold"><c:out value="${registration.eventTitle}"/></h3>
                </div>
                <div class="mt-4">
                    <p class="mb-1"><strong><c:out value="${registration.attendeeName}"/></strong></p>
                    <p class="mb-0 text-white-50 small">
                        <c:out value="${registration.ticketTypeName}"/> | Qty: ${registration.quantity}
                    </p>
                </div>
                <div class="ticket-perforation"></div>
            </div>

            <div class="card mb-4">
                <div class="card-header">Registration Details</div>
                <div class="card-body">
                    <dl class="row mb-0">
                        <dt class="col-sm-4">Booking Reference</dt>
                        <dd class="col-sm-8">
                            <div class="input-group">
                                <input type="text" class="form-control" id="bookingRef" value="${registration.bookingReference}" readonly>
                                <button class="btn btn-outline-secondary" type="button" onclick="copyToClipboard('bookingRef')">
                                    <i class="bi bi-clipboard"></i>
                                </button>
                            </div>
                        </dd>
                        <dt class="col-sm-4">Ticket Code</dt>
                        <dd class="col-sm-8">
                            <div class="input-group">
                                <input type="text" class="form-control" id="ticketCode" value="${digitalTicket.ticketCode}" readonly>
                                <button class="btn btn-outline-secondary" type="button" onclick="copyToClipboard('ticketCode')">
                                    <i class="bi bi-clipboard"></i>
                                </button>
                            </div>
                        </dd>
                        <dt class="col-sm-4">Attendee</dt>
                        <dd class="col-sm-8"><c:out value="${registration.attendeeName}"/></dd>
                        <dt class="col-sm-4">Email</dt>
                        <dd class="col-sm-8"><c:out value="${registration.attendeeEmail}"/></dd>
                        <dt class="col-sm-4">Event</dt>
                        <dd class="col-sm-8"><c:out value="${registration.eventTitle}"/></dd>
                        <dt class="col-sm-4">Ticket Type</dt>
                        <dd class="col-sm-8"><c:out value="${registration.ticketTypeName}"/></dd>
                        <dt class="col-sm-4">Quantity</dt>
                        <dd class="col-sm-8">${registration.quantity}</dd>
                        <dt class="col-sm-4">Total Price</dt>
                        <dd class="col-sm-8"><strong>$${registration.totalPrice}</strong></dd>
                        <dt class="col-sm-4">Payment Status</dt>
                        <dd class="col-sm-8">
                            <span class="badge bg-${registration.paymentStatus == 'PAID' ? 'success' : registration.paymentStatus == 'PENDING' ? 'warning' : 'danger'}">
                                <c:out value="${registration.paymentStatus}"/>
                            </span>
                        </dd>
                        <dt class="col-sm-4">Booking Date</dt>
                        <dd class="col-sm-8"><fmt:formatDate value="${registration.createdAt}" pattern="MMM d, yyyy h:mm a"/></dd>
                        <dt class="col-sm-4">Ticket Status</dt>
                        <dd class="col-sm-8">
                            <span class="badge bg-${digitalTicket.isUsed ? 'secondary' : 'success'}">
                                ${digitalTicket.isUsed ? 'Used' : 'Active'}
                            </span>
                        </dd>
                    </dl>
                </div>
            </div>

            <div class="card">
                <div class="card-header">Actions</div>
                <div class="card-body">
                    <div class="d-grid gap-2">
                        <c:if test="${registration.canCancel}">
                            <button type="button" class="btn btn-danger" onclick="cancelRegistration(${registration.id})">
                                <i class="bi bi-x-circle me-2"></i>Cancel Registration
                            </button>
                        </c:if>
                        <button type="button" class="btn btn-outline-secondary" onclick="printTicket()">
                            <i class="bi bi-printer me-2"></i>Print Ticket
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function copyToClipboard(elementId) {
    var copyText = document.getElementById(elementId);
    copyText.select();
    copyText.setSelectionRange(0, copyText.value.length);
    navigator.clipboard.writeText(copyText.value);
    
    var btn = copyText.nextElementSibling;
    var originalText = btn.innerHTML;
    btn.innerHTML = '<i class="bi bi-check"></i>';
    setTimeout(function() { btn.innerHTML = originalText; }, 2000);
}

function cancelRegistration(regId) {
    if (confirm('Are you sure you want to cancel this registration?')) {
        window.location.href = '/attendee/tickets/' + regId + '/cancel';
    }
}
</script>


<%@ include file="../../footer.jsp" %>

