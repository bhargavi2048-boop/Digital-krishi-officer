package com.krishiofficer.repository;

import com.krishiofficer.entity.Crop;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * CropRepository - Spring Data JPA Data Access Layer for Crop cycles.
 * Demonstrates Spring Interface derivation and custom query methods.
 */
@Repository
public interface CropRepository extends JpaRepository<Crop, Long> {

    List<Crop> findByFarmerIdOrderByPlantingDateDesc(Long farmerId);

    List<Crop> findByNameIgnoreCase(String name);
}
