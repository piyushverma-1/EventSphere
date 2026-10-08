<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Ticket Validation"/>
<%@ include file="../header.jsp" %>

<div class="row justify-content-center">
    <div class="col-md-6">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">Scan Ticket</h5>
            </div>
            <div class="card-body">
                <form id="ticketValidationForm">
                    <div class="mb-3">
                        <label for="ticketCode" class="form-label">Ticket Code</label>
                        <div class="input-group">
                            <input type="text" class="form-control" id="ticketCode" name="ticketCode" placeholder="Enter ticket code" autocomplete="off" autofocus>
                            <button type="submit" class="btn btn-primary" id="scanBtn">
                                <i class="bi bi-search"></i> Scan
                            </button>
                        </div>
                        <div class="form-text">Enter the ticket code or scan the QR code.</div>
                    </div>

                    <div class="camera-container" style="display: none;">
                        <video id="scannerVideo" class="scanner-video" autoplay playsinline></video>
                    </div>

                    <div id="scanResult" class="mt-4" style="display: none;">
                        <div class="scan-result">
                            <h6 id="resultTitle"></h6>
                            <p id="resultDetails" class="mb-0"></p>
                        </div>
                    </div>

                    <div id="scannerContainer" class="scanner-container mt-4" style="display: none;">
                        <h6>Or use your camera:</h6>
                        <button type="button" class="btn btn-outline-primary w-100" id="startCameraBtn">
                            <i class="bi bi-camera-video me-2"></i>Start Camera Scanner
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/jsQR@1.4.0/dist/jsQR.js"></script>
<script>
let videoStream = null;
let scanning = false;

document.getElementById('ticketValidationForm').addEventListener('submit', function(e) {
    e.preventDefault();
    const ticketCode = document.getElementById('ticketCode').value.trim();
    if (!ticketCode) return;
    
    validateTicket(ticketCode);
});

function validateTicket(ticketCode) {
    const btn = document.getElementById('scanBtn');
    const originalText = btn.innerHTML;
    btn.innerHTML = '';
    btn.disabled = true;
    
    fetch('${pageContext.request.contextPath}/validate-ticket', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: 'ticketCode=' + encodeURIComponent(ticketCode) + '&action=check'
    })
    .then(response => response.json())
    .then(data => {
        const resultDiv = document.getElementById('scanResult');
        const resultTitle = document.getElementById('resultTitle');
        const resultDetails = document.getElementById('resultDetails');
        
        if (data.valid) {
            resultDiv.style.display = 'block';
            resultTitle.innerHTML = '<i class="bi bi-check-circle-fill text-success me-2"></i>' + data.message;
            resultDetails.innerHTML = 'Event: ' + data.event + '<br>Attendee: ' + data.attendee + '<br>Ticket Type: ' + data.ticketType;
            resultDiv.className = 'mt-4 scan-result valid';
        } else {
            resultDiv.style.display = 'block';
            resultTitle.innerHTML = '<i class="bi bi-x-circle-fill text-danger me-2"></i>' + data.message;
            resultDetails.innerHTML = '';
            resultDiv.className = 'mt-4 scan-result invalid';
        }
        
        btn.innerHTML = originalText;
        btn.disabled = false;
    })
    .catch(error => {
        console.error('Error:', error);
        btn.innerHTML = originalText;
        btn.disabled = false;
    });
}

document.getElementById('startCameraBtn').addEventListener('click', function() {
    startScanner();
});

function startScanner() {
    navigator.mediaDevices.getUserMedia({ video: { facingMode: 'environment' } })
        .then(function(stream) {
            videoStream = stream;
            const video = document.getElementById('scannerVideo');
            video.srcObject = stream;
            video.play();
            document.querySelector('.camera-container').style.display = 'block';
            document.getElementById('scannerContainer').style.display = 'none';
            scanning = true;
            requestAnimationFrame(tick);
        })
        .catch(function(err) {
            alert('Camera access denied: ' + err.message);
        });
}

function tick() {
    const video = document.getElementById('scannerVideo');
    if (video.readyState > 0) {
        const canvas = document.createElement('canvas');
        const canvasContext = canvas.getContext('2d');
        canvas.height = video.videoHeight;
        canvas.width = video.videoWidth;
        canvasContext.drawImage(video, 0, 0, canvas.width, canvas.height);
        const imageData = canvasContext.getImageData(0, 0, canvas.width, canvas.height);
        
        const code = jsQR(imageData.data, imageData.width, imageData.height);
        if (code && scanning) {
            scanning = false;
            validateTicket(code.data);
            stopScanner();
        }
    }
    if (scanning) {
        requestAnimationFrame(tick);
    }
}

function stopScanner() {
    const video = document.getElementById('scannerVideo');
    if (video.srcObject) {
        video.srcObject.getTracks().forEach(track => track.stop());
        video.srcObject = null;
    }
    document.querySelector('.camera-container').style.display = 'none';
    document.getElementById('scannerContainer').style.display = 'block';
}
</script>
<%@ include file="../footer.jsp" %>