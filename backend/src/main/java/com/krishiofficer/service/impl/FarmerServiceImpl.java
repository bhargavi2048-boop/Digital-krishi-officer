package com.krishiofficer.service.impl;

import com.krishiofficer.dto.FarmerDto;
import com.krishiofficer.entity.Farmer;
import com.krishiofficer.exception.ResourceNotFoundException;
import com.krishiofficer.repository.FarmerRepository;
import com.krishiofficer.service.FarmerService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

/**
 * FarmerServiceImpl - Demonstrates Object-Oriented POLYMORPHISM and INTERFACE IMPLEMENTATION.
 */
@Service
@Transactional
public class FarmerServiceImpl implements FarmerService {

    private final FarmerRepository farmerRepository;

    public FarmerServiceImpl(FarmerRepository farmerRepository) {
        this.farmerRepository = farmerRepository;
    }

    @Override
    public FarmerDto registerOrUpdateFarmer(FarmerDto dto) {
        Farmer farmer = null;

        if (dto.getId() != null && farmerRepository.existsById(dto.getId())) {
            farmer = farmerRepository.findById(dto.getId()).orElse(null);
        }

        // If not found by ID, look up by email or phone to update existing record
        if (farmer == null && dto.getEmail() != null && !dto.getEmail().trim().isEmpty()) {
            farmer = farmerRepository.findByEmailIgnoreCase(dto.getEmail().trim()).orElse(null);
        }
        if (farmer == null && dto.getPhoneNumber() != null && !dto.getPhoneNumber().trim().isEmpty()) {
            farmer = farmerRepository.findByPhoneNumber(dto.getPhoneNumber().trim()).orElse(null);
        }

        if (farmer == null) {
            farmer = new Farmer();
        }

        farmer.setFullName(dto.getFullName());
        if (dto.getEmail() != null && !dto.getEmail().trim().isEmpty()) {
            farmer.setEmail(dto.getEmail().trim().toLowerCase());
        }
        if (dto.getPassword() != null && !dto.getPassword().trim().isEmpty()) {
            farmer.setPassword(dto.getPassword().trim());
        }
        farmer.setPhoneNumber(dto.getPhoneNumber());
        farmer.setState(dto.getState());
        farmer.setDistrict(dto.getDistrict());
        farmer.setCity(dto.getCity());
        farmer.setMainCrop(dto.getMainCrop() != null ? dto.getMainCrop() : "Paddy (Rice)");
        farmer.setLandSizeAcres(dto.getLandSizeAcres() != null ? dto.getLandSizeAcres() : 2.5);
        farmer.setSoilType(dto.getSoilType());
        farmer.setWaterAvailability(dto.getWaterAvailability());
        farmer.setPreferredLanguage(dto.getPreferredLanguage() != null ? dto.getPreferredLanguage() : "en");

        Farmer saved = farmerRepository.save(farmer);
        return mapToDto(saved);
    }

    @Override
    @Transactional(readOnly = true)
    public FarmerDto getFarmerById(Long id) {
        Farmer farmer = farmerRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Farmer", "id", id));
        return mapToDto(farmer);
    }

    @Override
    @Transactional(readOnly = true)
    public FarmerDto getFarmerByPhone(String phone) {
        Farmer farmer = farmerRepository.findByPhoneNumber(phone)
                .orElseThrow(() -> new ResourceNotFoundException("Farmer", "phoneNumber", phone));
        return mapToDto(farmer);
    }

    @Override
    @Transactional(readOnly = true)
    public List<FarmerDto> getAllFarmers() {
        return farmerRepository.findAll().stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Override
    public void deleteFarmer(Long id) {
        if (!farmerRepository.existsById(id)) {
            throw new ResourceNotFoundException("Farmer", "id", id);
        }
        farmerRepository.deleteById(id);
    }

    // Encapsulated Entity-to-DTO conversion
    private FarmerDto mapToDto(Farmer farmer) {
        return new FarmerDto(
                farmer.getId(),
                farmer.getFullName(),
                farmer.getEmail(),
                farmer.getPassword(),
                farmer.getPhoneNumber(),
                farmer.getState(),
                farmer.getDistrict(),
                farmer.getCity(),
                farmer.getMainCrop(),
                farmer.getLandSizeAcres(),
                farmer.getSoilType(),
                farmer.getWaterAvailability(),
                farmer.getPreferredLanguage()
        );
    }
}
