package com.krishiofficer.service;

import com.krishiofficer.dto.CropDto;
import java.util.List;

/**
 * CropService - Business logic contract for Crop cycle management.
 * Demonstrates Object-Oriented Abstraction.
 */
public interface CropService {

    CropDto addCrop(CropDto cropDto);

    List<CropDto> getCropsByFarmer(Long farmerId);

    List<CropDto> getAllCrops();

    CropDto getCropById(Long id);

    void deleteCrop(Long id);
}
