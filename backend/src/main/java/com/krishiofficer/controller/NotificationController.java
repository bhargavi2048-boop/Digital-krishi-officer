package com.krishiofficer.controller;

import com.krishiofficer.dto.NotificationRequest;
import com.krishiofficer.entity.NotificationLog;
import com.krishiofficer.service.NotificationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * NotificationController - REST API for SMS & WhatsApp Emergency Agricultural Alerts.
 * Connects the mobile advisory engine with external communication channels.
 */
@RestController
@RequestMapping("/api/notifications")
@Tag(name = "Notification Controller", description = "SMS & WhatsApp Severe Weather and Pest Alert Dispatch APIs")
public class NotificationController {

    private final NotificationService notificationService;

    public NotificationController(NotificationService notificationService) {
        this.notificationService = notificationService;
    }

    @PostMapping("/dispatch-alert")
    @Operation(summary = "Dispatch emergency agricultural alert via SMS or WhatsApp")
    public ResponseEntity<NotificationLog> dispatchAlert(@Valid @RequestBody NotificationRequest request) {
        NotificationLog logged = notificationService.dispatchAlert(request);
        return new ResponseEntity<>(logged, HttpStatus.CREATED);
    }

    @GetMapping("/history")
    @Operation(summary = "Get historical dispatch log of all sent SMS and WhatsApp alerts")
    public ResponseEntity<List<NotificationLog>> getRecentDispatches() {
        return ResponseEntity.ok(notificationService.getRecentDispatches());
    }

    @GetMapping("/phone/{phone}")
    @Operation(summary = "Get alert history for a specific farmer phone number")
    public ResponseEntity<List<NotificationLog>> getDispatchesByPhone(@PathVariable String phone) {
        return ResponseEntity.ok(notificationService.getDispatchesByPhone(phone));
    }

    @GetMapping("/summary")
    @Operation(summary = "Get notification system operational status and stats")
    public ResponseEntity<Map<String, Object>> getSummary() {
        return ResponseEntity.ok(notificationService.getNotificationSummary());
    }
}
