package com.krishiofficer.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;

/**
 * NotificationRequest - DTO for dispatching SMS and WhatsApp push notifications.
 */
@Schema(description = "Request body for dispatching severe weather or pest alerts via SMS / WhatsApp")
public class NotificationRequest {

    @NotBlank(message = "Recipient phone number is required")
    @Schema(description = "10-digit mobile number of farmer or farm manager", example = "9876543210")
    private String recipientPhone;

    @Schema(description = "Farm district or taluk", example = "Thanjavur")
    private String district;

    @Schema(description = "Target crop name", example = "Paddy (Rice)")
    private String cropName;

    @NotBlank(message = "Alert type is required")
    @Schema(description = "Type of alert: WEATHER, PEST, DISEASE, IRRIGATION", example = "WEATHER")
    private String alertType;

    @Schema(description = "Severity level: CRITICAL, WARNING, INFO", example = "CRITICAL")
    private String severity;

    @Schema(description = "Delivery channel: WHATSAPP, SMS, BOTH", example = "WHATSAPP")
    private String channel;

    @NotBlank(message = "Message text is required")
    @Schema(description = "Agricultural warning advisory text", example = "Heavy rain alert (80%). Avoid irrigation today.")
    private String message;

    public NotificationRequest() {}

    public NotificationRequest(String recipientPhone, String district, String cropName,
                               String alertType, String severity, String channel, String message) {
        this.recipientPhone = recipientPhone;
        this.district = district;
        this.cropName = cropName;
        this.alertType = alertType;
        this.severity = severity != null ? severity : "WARNING";
        this.channel = channel != null ? channel : "WHATSAPP";
        this.message = message;
    }

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
}
