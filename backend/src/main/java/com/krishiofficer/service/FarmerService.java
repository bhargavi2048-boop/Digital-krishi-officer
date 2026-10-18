package com.krishiofficer.service;

import com.krishiofficer.dto.FarmerDto;
import java.util.List;

/**
 * FarmerService - Demonstrates Object-Oriented ABSTRACTION.
 * Defines the contract for Farmer profile management operations.
 */
public interface FarmerService {

    FarmerDto registerOrUpdateFarmer(FarmerDto farmerDto);

    FarmerDto getFarmerById(Long id);

    FarmerDto getFarmerByPhone(String phone);

    List<FarmerDto> getAllFarmers();

    void deleteFarmer(Long id);
}
