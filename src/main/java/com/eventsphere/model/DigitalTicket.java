package com.eventsphere.model;

import java.time.LocalDateTime;

public class DigitalTicket {
    private Long id;
    private Long registrationId;
    private String ticketCode;
    private String qrCodeData;
    private Boolean isUsed;
    private LocalDateTime usedAt;
    private LocalDateTime createdAt;

    public DigitalTicket() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getRegistrationId() { return registrationId; }
    public void setRegistrationId(Long registrationId) { this.registrationId = registrationId; }

    public String getTicketCode() { return ticketCode; }
    public void setTicketCode(String ticketCode) { this.ticketCode = ticketCode; }

    public String getQrCodeData() { return qrCodeData; }
    public void setQrCodeData(String qrCodeData) { this.qrCodeData = qrCodeData; }

    public Boolean getIsUsed() { return isUsed; }
    public void setIsUsed(Boolean isUsed) { this.isUsed = isUsed; }

    public LocalDateTime getUsedAt() { return usedAt; }
    public void setUsedAt(LocalDateTime usedAt) { this.usedAt = usedAt; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
