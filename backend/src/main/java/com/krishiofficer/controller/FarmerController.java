package com.krishiofficer.controller;

import com.krishiofficer.dto.FarmerDto;
import com.krishiofficer.service.FarmerService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * FarmerController - REST API Controller for Farmer Profiles.
 * Demonstrates Spring Web MVC and RESTful Architecture.
 */
@RestController
@RequestMapping("/api/farmers")
@Tag(name = "Farmer Controller", description = "Farmer Profile Management APIs")
public class FarmerController {

    private final FarmerService farmerService;

    public FarmerController(FarmerService farmerService) {
        this.farmerService = farmerService;
    }

    @PostMapping
    @Operation(summary = "Register or update a farmer profile")
    public ResponseEntity<FarmerDto> saveProfile(@Valid @RequestBody FarmerDto dto) {
        FarmerDto saved = farmerService.registerOrUpdateFarmer(dto);
        return new ResponseEntity<>(saved, HttpStatus.CREATED);
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get farmer profile by ID")
    public ResponseEntity<FarmerDto> getProfileById(@PathVariable Long id) {
        return ResponseEntity.ok(farmerService.getFarmerById(id));
    }

    @GetMapping("/phone/{phone}")
    @Operation(summary = "Get farmer profile by phone number")
    public ResponseEntity<FarmerDto> getProfileByPhone(@PathVariable String phone) {
        return ResponseEntity.ok(farmerService.getFarmerByPhone(phone));
    }

    @GetMapping
    @Operation(summary = "List all registered farmers")
    public ResponseEntity<List<FarmerDto>> getAllFarmers() {
        return ResponseEntity.ok(farmerService.getAllFarmers());
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Delete farmer profile")
    public ResponseEntity<Void> deleteFarmer(@PathVariable Long id) {
        farmerService.deleteFarmer(id);
        return ResponseEntity.noContent().build();
    }
}
