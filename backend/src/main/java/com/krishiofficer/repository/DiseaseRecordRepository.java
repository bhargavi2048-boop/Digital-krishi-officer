package com.krishiofficer.repository;

import com.krishiofficer.entity.DiseaseRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * DiseaseRecordRepository - Data Access Layer for Disease Diagnoses.
 */
@Repository
public interface DiseaseRecordRepository extends JpaRepository<DiseaseRecord, Long> {

    List<DiseaseRecord> findByFarmerIdOrderByCreatedAtDesc(Long farmerId);

    List<DiseaseRecord> findByCropNameIgnoreCaseOrderByCreatedAtDesc(String cropName);
}
