package com.krishiofficer.controller;

import com.krishiofficer.dto.CropDto;
import com.krishiofficer.service.CropService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * CropController - REST API Controller for Crop lifecycle operations.
 */
@RestController
@RequestMapping("/api/crops")
@Tag(name = "Crop Controller", description = "Crop Cycle & Field Management APIs")
public class CropController {

    private final CropService cropService;

    public CropController(CropService cropService) {
        this.cropService = cropService;
    }

    @PostMapping
    @Operation(summary = "Add a new crop to farmer's field")
    public ResponseEntity<CropDto> addCrop(@Valid @RequestBody CropDto cropDto) {
        CropDto saved = cropService.addCrop(cropDto);
        return new ResponseEntity<>(saved, HttpStatus.CREATED);
    }

    @GetMapping
    @Operation(summary = "Get all crops or filter by farmer ID")
    public ResponseEntity<List<CropDto>> getCrops(@RequestParam(required = false) Long farmerId) {
        if (farmerId != null) {
            return ResponseEntity.ok(cropService.getCropsByFarmer(farmerId));
        }
        return ResponseEntity.ok(cropService.getAllCrops());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get crop details by ID")
    public ResponseEntity<CropDto> getCropById(@PathVariable Long id) {
        return ResponseEntity.ok(cropService.getCropById(id));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Delete a crop record")
    public ResponseEntity<Void> deleteCrop(@PathVariable Long id) {
        cropService.deleteCrop(id);
        return ResponseEntity.noContent().build();
    }
}
