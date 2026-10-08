<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Ticket Types"/>
<%@ include file="../../header.jsp" %>

<div class="row mb-4">
    <div class="col-12">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h2 class="h4 fw-bold mb-0">Ticket Types - <c:out value="${event.title}"/></h2>
                <p class="text-muted">Manage ticket types for this event</p>
            </div>
            <a href="${pageContext.request.contextPath}/organizer/events/${event.id}" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-2"></i>Back to Event
            </a>
        </div>
    </div>
</div>

<div class="card mb-4">
    <div class="card-header">Existing Ticket Types</div>
    <div class="card-body p-0">
        <c:if test="${not empty tickets}">
            <table class="table table-hover mb-0" id="ticketTypesTable">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Description</th>
                        <th>Price</th>
                        <th>Total Qty</th>
                        <th>Sold</th>
                        <th>Available</th>
                        <th class="text-end">Actions</th>
                    </tr>
                </thead>
                <tbody id="ticketTypesContainer">
                    <c:forEach items="${tickets}" var="ticket" varStatus="status">
                        <tr id="ticketRow${ticket.id}">
                            <td>
                                <input type="text" class="form-control form-control-sm" name="ticketName" value="${ticket.name}" readonly>
                                <input type="hidden" name="ticketId" value="${ticket.id}">
                            </td>
                            <td>
                                <input type="text" class="form-control form-control-sm" name="ticketDescription" value="${ticket.description}" readonly>
                            </td>
                            <td>
                                <div class="input-group input-group-sm">
                                    <span class="input-group-text">$</span>
                                    <input type="number" class="form-control form-control-sm" name="ticketPrice" value="${ticket.price}" step="0.01" min="0" readonly>
                                </div>
                            </td>
                            <td>
                                <input type="number" class="form-control form-control-sm" name="ticketQuantity" value="${ticket.quantity}" min="0" readonly>
                            </td>
                            <td>${ticket.soldCount}</td>
                            <td><strong class="text-success">${ticket.availableCount}</strong></td>
                            <td class="text-end">
                                <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeTicket(${ticket.id})">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>
        <c:if test="${empty tickets}">
            <div class="text-center py-4 text-muted">
                <p class="mb-0">No ticket types created yet</p>
            </div>
        </c:if>
    </div>
</div>

<div class="card">
    <div class="card-header">Add/Edit Ticket Types</div>
    <div class="card-body">
        <form method="post" action="${pageContext.request.contextPath}/organizer/events/${event.id}/tickets">
            <input type="hidden" name="action" value="saveTickets">
            
            <table class="table" id="ticketEditorTable">
                <thead>
                    <tr>
                        <th>Name <span class="text-danger">*</span></th>
                        <th>Description</th>
                        <th>Price ($)</th>
                        <th>Quantity <span class="text-danger">*</span></th>
                        <th>Remove</th>
                    </tr>
                </thead>
                <tbody id="editableTicketsContainer">
                    <c:forEach items="${tickets}" var="ticket" varStatus="status">
                        <tr>
                            <input type="hidden" name="ticketId" value="${ticket.id}">
                            <td>
                                <input type="text" class="form-control form-control-sm" name="ticketName" value="${ticket.name}" required>
                            </td>
                            <td>
                                <input type="text" class="form-control form-control-sm" name="ticketDescription" value="${ticket.description}">
                            </td>
                            <td>
                                <input type="number" class="form-control form-control-sm" name="ticketPrice" value="${ticket.price}" step="0.01" min="0">
                            </td>
                            <td>
                                <input type="number" class="form-control form-control-sm" name="ticketQuantity" value="${ticket.quantity}" min="0" required>
                            </td>
                            <td class="text-center">
                                <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeEditableRow(this)">
                                    <i class="bi bi-x"></i>
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <!-- Template row for new tickets (hidden) -->
                    <tbody id="newTicketsContainer"></tbody>
                </tbody>
            </table>

            <div class="mb-3">
                <button type="button" class="btn btn-outline-secondary" id="addTicketType" onclick="addNewTicketRow()">
                    <i class="bi bi-plus-lg me-2"></i>Add Ticket Type
                </button>
            </div>

            <div class="d-flex gap-2">
                <button type="submit" class="btn btn-success">
                    <i class="bi bi-save me-2"></i>Save Ticket Types
                </button>
                <a href="${pageContext.request.contextPath}/organizer/events/${event.id}" class="btn btn-outline-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>

<script>
let newTicketCount = 0;

function addNewTicketRow() {
    const container = document.getElementById('newTicketsContainer');
    const row = document.createElement('tr');
    row.innerHTML = '<input type="hidden" name="ticketId" value="">' +
        '<td><input type="text" class="form-control form-control-sm" name="ticketName" placeholder="e.g. General Admission" required></td>' +
        '<td><input type="text" class="form-control form-control-sm" name="ticketDescription" placeholder="Description"></td>' +
        '<td><input type="number" class="form-control form-control-sm" name="ticketPrice" step="0.01" min="0" value="0"></td>' +
        '<td><input type="number" class="form-control form-control-sm" name="ticketQuantity" min="0" required></td>' +
        '<td class="text-center"><button type="button" class="btn btn-sm btn-outline-danger" onclick="removeNewRow(this)"><i class="bi bi-x"></i></button></td>';
    container.appendChild(row);
    newTicketCount++;
}

function removeNewRow(btn) {
    btn.closest('tr').remove();
}

function removeEditableRow(btn) {
    const row = btn.closest('tr');
    const inputs = row.querySelectorAll('input[name="ticketName"]');
    if (inputs.length > 0) {
        const name = inputs[0].value;
        const idInput = row.querySelector('input[name="ticketId"]');
        if (confirm('Remove ticket "' + name + '"?')) {
            row.style.display = 'none';
            row.innerHTML += '<input type="hidden" name="removedTicketIds" value="' + idInput.value + '">';
        }
    }
}

function removeTicket(id) {
    // This will be handled by saveTickets via hidden input
}
</script>


<%@ include file="../../footer.jsp" %>

