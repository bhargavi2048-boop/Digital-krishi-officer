package com.krishiofficer.repository;

import com.krishiofficer.entity.Farmer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * FarmerRepository - Spring Data JPA Data Access Layer.
 * Demonstrates the Repository Pattern and Polymorphic Spring Interface inheritance.
 */
@Repository
public interface FarmerRepository extends JpaRepository<Farmer, Long> {

    Optional<Farmer> findByEmailIgnoreCase(String email);

    Optional<Farmer> findByPhoneNumber(String phoneNumber);

    Optional<Farmer> findByFullNameIgnoreCase(String fullName);
}
