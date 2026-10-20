package com.krishiofficer.controller;

import com.krishiofficer.dto.AuthRequest;
import com.krishiofficer.dto.FarmerDto;
import com.krishiofficer.entity.Farmer;
import com.krishiofficer.repository.FarmerRepository;
import com.krishiofficer.service.FarmerService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/auth")
@Tag(name = "Authentication Controller", description = "Farmer Account Registration, Login, and Password Reset")
public class AuthController {

    private final FarmerRepository farmerRepository;
    private final FarmerService farmerService;

    public AuthController(FarmerRepository farmerRepository, FarmerService farmerService) {
        this.farmerRepository = farmerRepository;
        this.farmerService = farmerService;
    }

    @PostMapping("/register")
    @Operation(summary = "Register a new farmer account")
    public ResponseEntity<?> register(@RequestBody FarmerDto dto) {
        if (dto.getEmail() != null && !dto.getEmail().trim().isEmpty()) {
            Optional<Farmer> existingByEmail = farmerRepository.findByEmailIgnoreCase(dto.getEmail().trim());
            if (existingByEmail.isPresent()) {
                return ResponseEntity.status(HttpStatus.CONFLICT)
                        .body(Map.of("message", "An account with this email address already exists."));
            }
        }

        if (dto.getPhoneNumber() != null && !dto.getPhoneNumber().trim().isEmpty()) {
            Optional<Farmer> existingByPhone = farmerRepository.findByPhoneNumber(dto.getPhoneNumber().trim());
            if (existingByPhone.isPresent()) {
                return ResponseEntity.status(HttpStatus.CONFLICT)
                        .body(Map.of("message", "An account with this phone number already exists."));
            }
        }

        FarmerDto saved = farmerService.registerOrUpdateFarmer(dto);
        return new ResponseEntity<>(saved, HttpStatus.CREATED);
    }

    @PostMapping("/login")
    @Operation(summary = "Authenticate farmer by email or mobile number")
    public ResponseEntity<?> login(@RequestBody AuthRequest request) {
        String identifier = request.getIdentifier() != null ? request.getIdentifier().trim() : "";
        String cleanPhone = identifier.replaceAll("\\D", "");
        String password = request.getPassword() != null ? request.getPassword().trim() : "";

        if (identifier.isEmpty() || password.isEmpty()) {
            return ResponseEntity.badRequest()
                    .body(Map.of("message", "Identifier and password are required."));
        }

        Optional<Farmer> farmerOpt = Optional.empty();
        if (identifier.contains("@")) {
            farmerOpt = farmerRepository.findByEmailIgnoreCase(identifier);
        } else if (cleanPhone.length() == 10) {
            farmerOpt = farmerRepository.findByPhoneNumber(cleanPhone);
        }

        if (farmerOpt.isEmpty()) {
            // Check either field
            farmerOpt = farmerRepository.findByEmailIgnoreCase(identifier);
            if (farmerOpt.isEmpty() && !cleanPhone.isEmpty()) {
                farmerOpt = farmerRepository.findByPhoneNumber(cleanPhone);
            }
        }

        if (farmerOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("message", "No account found for this email or mobile number."));
        }

        Farmer farmer = farmerOpt.get();
        if (farmer.getPassword() == null || !farmer.getPassword().equals(password)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("message", "Incorrect password. Please verify your credentials."));
        }

        FarmerDto dto = farmerService.getFarmerById(farmer.getId());
        return ResponseEntity.ok(dto);
    }

    @PostMapping("/reset-password")
    @Operation(summary = "Reset farmer password using email or mobile number")
    public ResponseEntity<?> resetPassword(@RequestBody AuthRequest request) {
        String identifier = request.getIdentifier() != null ? request.getIdentifier().trim() : "";
        String cleanPhone = identifier.replaceAll("\\D", "");
        String newPassword = request.getPassword() != null ? request.getPassword().trim() : "farmer1234";

        Optional<Farmer> farmerOpt = farmerRepository.findByEmailIgnoreCase(identifier);
        if (farmerOpt.isEmpty() && !cleanPhone.isEmpty()) {
            farmerOpt = farmerRepository.findByPhoneNumber(cleanPhone);
        }

        if (farmerOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("message", "No account found for " + identifier));
        }

        Farmer farmer = farmerOpt.get();
        farmer.setPassword(newPassword);
        farmerRepository.save(farmer);

        return ResponseEntity.ok(Map.of("message", "Password successfully reset to: " + newPassword));
    }
}
