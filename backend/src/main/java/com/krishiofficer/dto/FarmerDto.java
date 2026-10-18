package com.krishiofficer.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

/**
 * FarmerDto - Data Transfer Object for Farmer Registration & Profile Updates.
 */
public class FarmerDto {

    private Long id;

    @NotBlank(message = "Farmer full name cannot be blank")
    private String fullName;

    private String phoneNumber;
    private String state;
    private String district;
    private String city;

    @NotBlank(message = "Main crop is required")
    private String mainCrop;

    @NotNull(message = "Land size is required")
    @Positive(message = "Land size must be positive")
    private Double landSizeAcres;

    private String soilType;
    private String waterAvailability;
    private String preferredLanguage = "en";

    public FarmerDto() {
    }

    public FarmerDto(Long id, String fullName, String phoneNumber, String state, String district,
                     String city, String mainCrop, Double landSizeAcres, String soilType,
                     String waterAvailability, String preferredLanguage) {
        this.id = id;
        this.fullName = fullName;
        this.phoneNumber = phoneNumber;
        this.state = state;
        this.district = district;
        this.city = city;
        this.mainCrop = mainCrop;
        this.landSizeAcres = landSizeAcres;
        this.soilType = soilType;
        this.waterAvailability = waterAvailability;
        this.preferredLanguage = preferredLanguage != null ? preferredLanguage : "en";
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getMainCrop() {
        return mainCrop;
    }

    public void setMainCrop(String mainCrop) {
        this.mainCrop = mainCrop;
    }

    public Double getLandSizeAcres() {
        return landSizeAcres;
    }

    public void setLandSizeAcres(Double landSizeAcres) {
        this.landSizeAcres = landSizeAcres;
    }

    public String getSoilType() {
        return soilType;
    }

    public void setSoilType(String soilType) {
        this.soilType = soilType;
    }

    public String getWaterAvailability() {
        return waterAvailability;
    }

    public void setWaterAvailability(String waterAvailability) {
        this.waterAvailability = waterAvailability;
    }

    public String getPreferredLanguage() {
        return preferredLanguage;
    }

    public void setPreferredLanguage(String preferredLanguage) {
        this.preferredLanguage = preferredLanguage;
    }
}
