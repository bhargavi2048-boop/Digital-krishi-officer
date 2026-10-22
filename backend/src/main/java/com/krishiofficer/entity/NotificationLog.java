package com.krishiofficer.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * NotificationLog - Entity recording dispatched SMS and WhatsApp agricultural alerts.
 * Demonstrates Object-Oriented Domain Modeling and JPA Persistence.
 */
@Entity
@Table(name = "notification_logs", indexes = {
        @Index(name = "idx_notif_phone", columnList = "recipient_phone"),
        @Index(name = "idx_notif_district", columnList = "district"),
        @Index(name = "idx_notif_channel", columnList = "channel")
})
public class NotificationLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "recipient_phone", nullable = false, length = 20)
    private String recipientPhone;

    @Column(name = "district", length = 100)
    private String district;

    @Column(name = "crop_name", length = 100)
    private String cropName;

    @Column(name = "alert_type", nullable = false, length = 50)
    private String alertType; // 'WEATHER', 'PEST', 'DISEASE', 'IRRIGATION'

    @Column(name = "severity", nullable = false, length = 20)
    private String severity; // 'CRITICAL', 'WARNING', 'INFO'

    @Column(name = "channel", nullable = false, length = 20)
    private String channel; // 'WHATSAPP', 'SMS'

    @Column(name = "message", nullable = false, length = 1000)
    private String message;

    @Column(name = "delivery_status", nullable = false, length = 20)
    private String deliveryStatus; // 'DELIVERED', 'SIMULATED', 'FAILED'

    @Column(name = "dispatched_at", nullable = false)
    private LocalDateTime dispatchedAt;

    public NotificationLog() {
        this.dispatchedAt = LocalDateTime.now();
        this.deliveryStatus = "DELIVERED";
    }

    public NotificationLog(String recipientPhone, String district, String cropName,
                           String alertType, String severity, String channel,
                           String message, String deliveryStatus) {
        this.recipientPhone = recipientPhone;
        this.district = district;
        this.cropName = cropName;
        this.alertType = alertType;
        this.severity = severity;
        this.channel = channel;
        this.message = message;
        this.deliveryStatus = deliveryStatus;
        this.dispatchedAt = LocalDateTime.now();
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getRecipientPhone() { return recipientPhone; }
    public void setRecipientPhone(String recipientPhone) { this.recipientPhone = recipientPhone; }

    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }

    public String getCropName() { return cropName; }
    public void setCropName(String cropName) { this.cropName = cropName; }

    public String getAlertType() { return alertType; }
    public void setAlertType(String alertType) { this.alertType = alertType; }

    public String getSeverity() { return severity; }
    public void setSeverity(String severity) { this.severity = severity; }

    public String getChannel() { return channel; }
    public void setChannel(String channel) { this.channel = channel; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public String getDeliveryStatus() { return deliveryStatus; }
    public void setDeliveryStatus(String deliveryStatus) { this.deliveryStatus = deliveryStatus; }

    public LocalDateTime getDispatchedAt() { return dispatchedAt; }
    public void setDispatchedAt(LocalDateTime dispatchedAt) { this.dispatchedAt = dispatchedAt; }
}
