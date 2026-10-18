package com.krishiofficer.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import java.time.LocalDate;

/**
 * Crop Entity - Represents a managed crop cycle on a farmer's land.
 * Demonstrates Object-Oriented Modeling, Encapsulation, and Inheritance.
 */
@Entity
@Table(name = "crops")
public class Crop extends BaseEntity {

    @NotBlank(message = "Crop name cannot be blank")
    @Column(name = "name", nullable = false)
    private String name;

    @Column(name = "variety")
    private String variety;

    @NotNull(message = "Planting date is required")
    @Column(name = "planting_date", nullable = false)
    private LocalDate plantingDate;

    @Column(name = "expected_harvest_date")
    private LocalDate expectedHarvestDate;

    @NotNull(message = "Land area is required")
    @Positive(message = "Land area must be greater than zero")
    @Column(name = "land_area_acres", nullable = false)
    private Double landAreaAcres;

    @Column(name = "soil_type")
    private String soilType;

    @Column(name = "water_source")
    private String waterSource;

    @Column(name = "stage")
    private String stage;

    @Column(name = "notes", length = 1000)
    private String notes;

    @Column(name = "farmer_id")
    private Long farmerId;

    public Crop() {
        super();
    }

    public Crop(String name, String variety, LocalDate plantingDate, LocalDate expectedHarvestDate,
                Double landAreaAcres, String soilType, String waterSource, String stage, String notes, Long farmerId) {
        super();
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

    @Override
    public String toString() {
        return "Crop{" +
                "id=" + getId() +
                ", name='" + name + '\'' +
                ", variety='" + variety + '\'' +
                ", stage='" + stage + '\'' +
                ", landAreaAcres=" + landAreaAcres +
                '}';
    }
}
