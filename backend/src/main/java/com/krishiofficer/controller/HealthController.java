package com.krishiofficer.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * HealthController - API Health & System Status Endpoint.
 */
@RestController
@RequestMapping("/api/health")
@Tag(name = "Health Controller", description = "Backend Health & Status Check")
public class HealthController {

    @GetMapping
    @Operation(summary = "Check backend server status and Java runtime info")
    public ResponseEntity<Map<String, Object>> checkHealth() {
        Map<String, Object> status = new HashMap<>();
        status.put("status", "UP");
        status.put("application", "Digital Krishi Officer Backend");
        status.put("javaVersion", System.getProperty("java.version"));
        status.put("javaVendor", System.getProperty("java.vendor"));
        status.put("timestamp", LocalDateTime.now());
        status.put("subject", "Object-Oriented Programming (Java)");
        return ResponseEntity.ok(status);
    }
}
