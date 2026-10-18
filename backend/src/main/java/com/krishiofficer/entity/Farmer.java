package com.krishiofficer.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

/**
 * Farmer Entity - Demonstrates Object-Oriented ENCAPSULATION and INHERITANCE.
 * Extends BaseEntity to inherit identity and timestamp behavior.
 */
@Entity
@Table(name = "farmers")
public class Farmer extends BaseEntity {

    @NotBlank(message = "Farmer full name cannot be blank")
    @Column(name = "full_name", nullable = false)
    private String fullName;

    @Column(name = "phone_number")
    private String phoneNumber;

    @Column(name = "state")
    private String state;

    @Column(name = "district")
    private String district;

    @Column(name = "city")
    private String city;

    @NotBlank(message = "Main crop is required")
    @Column(name = "main_crop", nullable = false)
    private String mainCrop;

    @NotNull(message = "Land size is required")
    @Positive(message = "Land size must be greater than zero")
    @Column(name = "land_size_acres", nullable = false)
    private Double landSizeAcres;

    @Column(name = "soil_type")
    private String soilType;

    @Column(name = "water_availability")
    private String waterAvailability;

    @Column(name = "preferred_language")
    private String preferredLanguage = "en";

    // Default Constructor (Required by JPA)
    public Farmer() {
        super();
    }

    // Parameterized Constructor (OOP Object Instantiation)
    public Farmer(String fullName, String phoneNumber, String state, String district, String city,
                  String mainCrop, Double landSizeAcres, String soilType, String waterAvailability,
                  String preferredLanguage) {
        super();
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

    // Encapsulation: Public Accessor and Mutator methods
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

    // Polymorphic method override
    @Override
    public String toString() {
        return "Farmer{" +
                "id=" + getId() +
                ", fullName='" + fullName + '\'' +
                ", district='" + district + '\'' +
                ", mainCrop='" + mainCrop + '\'' +
                ", landSizeAcres=" + landSizeAcres +
                '}';
    }
}
