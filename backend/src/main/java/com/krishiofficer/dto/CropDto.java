package com.krishiofficer.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import java.time.LocalDate;

/**
 * CropDto - Data Transfer Object for creating and transferring Crop records.
 */
public class CropDto {

    private Long id;

    @NotBlank(message = "Crop name cannot be blank")
    private String name;

    private String variety;

    @NotNull(message = "Planting date is required")
    private LocalDate plantingDate;

    private LocalDate expectedHarvestDate;

    @NotNull(message = "Land area is required")
    @Positive(message = "Land area must be positive")
    private Double landAreaAcres;

    private String soilType;
    private String waterSource;
    private String stage;
    private String notes;
    private Long farmerId;

    public CropDto() {
    }

    public CropDto(Long id, String name, String variety, LocalDate plantingDate, LocalDate expectedHarvestDate,
                   Double landAreaAcres, String soilType, String waterSource, String stage, String notes, Long farmerId) {
        this.id = id;
        this.name = name;
        this.variety = variety;
        this.plantingDate = plantingDate;
        this.expectedHarvestDate = expectedHarvestDate;
        this.landAreaAcres = landAreaAcres;
        this.soilType = soilType;
        this.waterSource = waterSource;
        this.stage = stage;
        this.notes = notes;
        this.farmerId = farmerId;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getVariety() {
        return variety;
    }

    public void setVariety(String variety) {
        this.variety = variety;
    }

    public LocalDate getPlantingDate() {
        return plantingDate;
    }

    public void setPlantingDate(LocalDate plantingDate) {
        this.plantingDate = plantingDate;
    }

    public LocalDate getExpectedHarvestDate() {
        return expectedHarvestDate;
    }

    public void setExpectedHarvestDate(LocalDate expectedHarvestDate) {
        this.expectedHarvestDate = expectedHarvestDate;
    }

    public Double getLandAreaAcres() {
        return landAreaAcres;
    }

    public void setLandAreaAcres(Double landAreaAcres) {
        this.landAreaAcres = landAreaAcres;
    }

    public String getSoilType() {
        return soilType;
    }

    public void setSoilType(String soilType) {
        this.soilType = soilType;
    }

    public String getWaterSource() {
        return waterSource;
    }

    public void setWaterSource(String waterSource) {
        this.waterSource = waterSource;
    }

    public String getStage() {
        return stage;
    }

    public void setStage(String stage) {
        this.stage = stage;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public Long getFarmerId() {
        return farmerId;
    }

    public void setFarmerId(Long farmerId) {
        this.farmerId = farmerId;
    }
}
