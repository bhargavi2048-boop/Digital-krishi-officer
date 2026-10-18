package com.krishiofficer.service.impl;

import com.krishiofficer.dto.CropDto;
import com.krishiofficer.entity.Crop;
import com.krishiofficer.exception.ResourceNotFoundException;
import com.krishiofficer.repository.CropRepository;
import com.krishiofficer.service.CropService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

/**
 * CropServiceImpl - Implementation of CropService interface.
 * Demonstrates Polymorphism and business domain operations.
 */
@Service
@Transactional
public class CropServiceImpl implements CropService {

    private final CropRepository cropRepository;

    public CropServiceImpl(CropRepository cropRepository) {
        this.cropRepository = cropRepository;
    }

    @Override
    public CropDto addCrop(CropDto dto) {
        Crop crop = new Crop(
                dto.getName(),
                dto.getVariety(),
                dto.getPlantingDate(),
                dto.getExpectedHarvestDate(),
                dto.getLandAreaAcres(),
                dto.getSoilType(),
                dto.getWaterSource(),
                dto.getStage(),
                dto.getNotes(),
                dto.getFarmerId()
        );

        Crop saved = cropRepository.save(crop);
        return mapToDto(saved);
    }

    @Override
    @Transactional(readOnly = true)
    public List<CropDto> getCropsByFarmer(Long farmerId) {
        return cropRepository.findByFarmerIdOrderByPlantingDateDesc(farmerId).stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<CropDto> getAllCrops() {
        return cropRepository.findAll().stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public CropDto getCropById(Long id) {
        Crop crop = cropRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Crop", "id", id));
        return mapToDto(crop);
    }

    @Override
    public void deleteCrop(Long id) {
        if (!cropRepository.existsById(id)) {
            throw new ResourceNotFoundException("Crop", "id", id);
        }
        cropRepository.deleteById(id);
    }

    private CropDto mapToDto(Crop crop) {
        return new CropDto(
                crop.getId(),
                crop.getName(),
                crop.getVariety(),
                crop.getPlantingDate(),
                crop.getExpectedHarvestDate(),
                crop.getLandAreaAcres(),
                crop.getSoilType(),
                crop.getWaterSource(),
                crop.getStage(),
                crop.getNotes(),
                crop.getFarmerId()
        );
    }
}
