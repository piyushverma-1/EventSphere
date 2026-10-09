<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Register for Event"/>
<%@ include file="../../header.jsp" %>

<div class="row justify-content-center">
    <div class="col-lg-8">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="h4 fw-bold mb-0">Register for "<c:out value="${event.title}"/>"</h2>
                <p class="text-muted"><c:out value="${event.description}"/></p>
            </div>
            <a href="${pageContext.request.contextPath}/events/${event.id}" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left"></i>
            </a>
        </div>

        <div class="row">
            <div class="col-md-6 mb-4">
                <div class="card h-100">
                    <div class="card-header">Event Details</div>
                    <div class="card-body">
                        <dl class="row mb-0">
                            <dt class="col-sm-5">Date</dt>
                            <dd class="col-sm-7">
                                <c:out value="${event.formattedEventDate}"/>
                            </dd>
                            <dt class="col-sm-5">Time</dt>
                            <dd class="col-sm-7">
                                <c:out value="${event.formattedEventTime}"/>
                            </dd>
                            <dt class="col-sm-5">Venue</dt>
                            <dd class="col-sm-7"><c:out value="${event.venue}"/></dd>
                            <dt class="col-sm-5">Capacity</dt>
                            <dd class="col-sm-7">${event.capacity} attendees</dd>
                        </dl>
                    </div>
                </div>
            </div>

            <div class="col-md-6 mb-4">
                <form method="post" action="${pageContext.request.contextPath}/events/${event.id}/register">
                    <input type="hidden" name="action" value="register">
                    
                    <div class="card">
                        <div class="card-header">Select Ticket</div>
                        <div class="card-body">
                            <div class="mb-3">
                                <label for="ticketTypeId" class="form-label">Ticket Type <span class="text-danger">*</span></label>
                                <select class="form-select" id="ticketTypeId" name="ticketTypeId" required onchange="updateQuantityAndPrice(this)">
                                    <option value="">Select a ticket type</option>
                                    <c:forEach items="${tickets}" var="ticket">
                                        <option value="${ticket.id}" data-price="${ticket.price}" data-available="${ticket.availableCount}">
                                            ${ticket.name} - $${ticket.price} (${ticket.availableCount} available)
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="quantity" class="form-label">Quantity <span class="text-danger">*</span></label>
                                <select class="form-select" id="quantity" name="quantity" required min="1" max="10" disabled>
                                    <option value="">Select ticket type first</option>
                                </select>
                            </div>

                            <div class="alert alert-info">
                                <div class="d-flex justify-content-between">
                                    <span>Total Price:</span>
                                    <strong id="totalPrice">$0.00</strong>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <button type="submit" class="btn btn-success btn-lg w-100">
                    <i class="bi bi-ticket-perforated me-2"></i>Complete Registration
                </button>
            </div>
        </div>
    </div>
</div>

<script>
function updateQuantityAndPrice(select) {
    var quantitySelect = document.getElementById('quantity');
    var totalPrice = document.getElementById('totalPrice');
    quantitySelect.innerHTML = '';
    quantitySelect.disabled = false;
    
    var selectedOption = select.options[select.selectedIndex];
    var price = parseFloat(selectedOption.dataset.price || 0);
    var available = parseInt(selectedOption.dataset.available || 0);
    
    var maxQty = Math.min(available, 10);
    for (var i = 1; i <= maxQty; i++) {
        var option = document.createElement('option');
        option.value = i;
        option.textContent = i + ' ticket' + (i > 1 ? 's' : '');
        option.dataset.price = price;
        quantitySelect.appendChild(option);
    }
    
    quantitySelect.onchange = function() {
        var qty = parseInt(this.value || 0);
        totalPrice.textContent = '$' + (price * qty).toFixed(2);
    };
}
</script>

<%@ include file="../../footer.jsp" %>

