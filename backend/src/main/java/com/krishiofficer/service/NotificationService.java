package com.krishiofficer.service;

import com.krishiofficer.dto.NotificationRequest;
import com.krishiofficer.entity.NotificationLog;

import java.util.List;
import java.util.Map;

/**
 * NotificationService - Service contract for dispatching SMS and WhatsApp push alerts.
 * Demonstrates Abstraction in Object-Oriented Architecture.
 */
public interface NotificationService {

    NotificationLog dispatchAlert(NotificationRequest request);

    List<NotificationLog> getRecentDispatches();

    List<NotificationLog> getDispatchesByPhone(String phone);

    Map<String, Object> getNotificationSummary();
}
