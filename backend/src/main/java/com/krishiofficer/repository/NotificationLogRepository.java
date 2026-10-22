package com.krishiofficer.repository;

import com.krishiofficer.entity.NotificationLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * NotificationLogRepository - Data Access Layer for alert logs.
 * Demonstrates Spring Data JPA Repository pattern.
 */
@Repository
public interface NotificationLogRepository extends JpaRepository<NotificationLog, Long> {

    List<NotificationLog> findByRecipientPhoneOrderByDispatchedAtDesc(String recipientPhone);

    List<NotificationLog> findByDistrictIgnoreCaseOrderByDispatchedAtDesc(String district);

    List<NotificationLog> findTop20ByOrderByDispatchedAtDesc();
}
