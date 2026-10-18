import '../../models/government_scheme.dart';
import '../../models/farmer_profile.dart';

class SchemeService {
  static final SchemeService _instance = SchemeService._internal();
  factory SchemeService() => _instance;
  SchemeService._internal();

  final List<GovernmentScheme> _schemes = [
    GovernmentScheme(
      id: 'scheme_pm_kisan',
      name: 'Pradhan Mantri Kisan Samman Nidhi (PM-KISAN)',
      category: 'Income Support',
      shortDescription: 'Direct financial assistance of ₹6,000 per year in three equal installments of ₹2,000.',
      detailedDescription: 'Central Sector scheme with 100% funding from Government of India to provide income support to all landholding farmer families across the country to enable them to take care of expenses related to agriculture and domestic needs.',
      eligibility: [
        'All landholding farmer families with cultivable land in their names.',
        'Subject to certain exclusion criteria (institutional landholders, constitutional posts, income tax payers).',
        'Valid Aadhaar card and e-KYC authentication are mandatory.',
      ],
      benefits: [
        'Direct cash transfer of ₹6,000 annually.',
        'Credited in three four-monthly installments of ₹2,000 each directly into Aadhaar-linked bank accounts.',
        'Zero deduction or intermediary involvement via Direct Benefit Transfer (DBT).',
      ],
      requiredDocuments: [
        'Aadhaar Card',
        'Land Ownership Record (RoR / Patta / Chitta / Khasra)',
        'Active Bank Account linked with Aadhaar & Mobile',
        'e-KYC biometric or OTP verification',
      ],
      applicationProcess: [
        'Step 1: Visit official PM-KISAN portal (pmkisan.gov.in) or visit nearest Common Service Center (CSC).',
        'Step 2: Click on "Farmers Corner" -> "New Farmer Registration".',
        'Step 3: Enter Rural/Urban registration, Aadhaar number, Mobile number, and State.',
        'Step 4: Fill land ownership details, survey numbers, and submit for District Nodal Officer verification.',
      ],
      officialSource: 'Ministry of Agriculture and Farmers Welfare, Govt of India',
      officialUrl: 'https://pmkisan.gov.in',
      lastUpdated: 'February 2025',
    ),
    GovernmentScheme(
      id: 'scheme_pmfby',
      name: 'Pradhan Mantri Fasal Bima Yojana (PMFBY)',
      category: 'Insurance',
      shortDescription: 'Comprehensive crop insurance against non-preventable natural risks from pre-sowing to post-harvest.',
      detailedDescription: 'Provides affordable crop insurance coverage to stabilize farmers income against losses caused by droughts, floods, landslides, natural fire, pests, and unseasonal rains.',
      eligibility: [
        'All farmers including sharecroppers and tenant farmers growing notified crops in notified areas.',
        'Both loanee and non-loanee farmers are eligible.',
      ],
      benefits: [
        'Very low premium payable by farmer: Max 2% for Kharif food/oilseeds, 1.5% for Rabi, 5% for Annual Commercial/Horticultural crops.',
        'Remaining premium subsidized equally by Central and State Governments.',
        'Coverage for prevented sowing, localized calamities (hailstorm, cloudburst), and mid-season adversity.',
      ],
      requiredDocuments: [
        'Aadhaar Card',
        'Land Record (Khatauni / Patta / Land Possession Certificate)',
        'Sowing Certificate issued by Village Administrative Officer / Patwari',
        'Bank Passbook copy showing IFSC',
      ],
      applicationProcess: [
        'Step 1: Access the National Crop Insurance Portal (pmfby.gov.in) or enroll through bank / CSC.',
        'Step 2: Submit crop insurance proposal before cut-off date for the respective season.',
        'Step 3: Pay the subsidized farmer premium and collect insurance receipt/policy number.',
        'Step 4: In case of crop loss, report within 72 hours via Crop Insurance Mobile App.',
      ],
      officialSource: 'Department of Agriculture & Farmers Welfare',
      officialUrl: 'https://pmfby.gov.in',
      lastUpdated: 'January 2025',
    ),
    GovernmentScheme(
      id: 'scheme_kcc',
      name: 'Kisan Credit Card (KCC) Scheme',
      category: 'Credit & Loans',
      shortDescription: 'Concessional institutional credit at effective 4% interest rate for crop production and allied needs.',
      detailedDescription: 'Simplifies credit delivery mechanism to meet short-term credit requirements for cultivation of crops, post-harvest expenses, farm asset maintenance, and allied activities like animal husbandry and fisheries.',
      eligibility: [
        'All individual farmers, joint borrowers, tenant farmers, oral lessees, and sharecroppers.',
        'Self Help Groups (SHGs) or Joint Liability Groups (JLGs) of farmers.',
      ],
      benefits: [
        'Credit limit up to ₹3,00,000 at concessional interest rate of 7%.',
        'Additional 3% prompt repayment incentive, reducing effective borrowing cost to just 4% per annum.',
        'Collateral-free agricultural loans up to ₹1,60,000.',
        'ATM-enabled RuPay Kisan Card for easy withdrawals and input purchases.',
      ],
      requiredDocuments: [
        'Completed KCC Application Form',
        'Identity & Address Proof (Aadhaar, Voter ID, PAN)',
        'Land holding documents duly verified by revenue authority',
        'Cropping pattern details for the upcoming season',
      ],
      applicationProcess: [
        'Step 1: Obtain KCC form from local cooperative bank, commercial bank, or RRB.',
        'Step 2: Fill personal and farm land holding details with proposed cropping plan.',
        'Step 3: Submit to bank branch along with land documents.',
        'Step 4: Bank issues sanctioned limit and RuPay card within 14 days.',
      ],
      officialSource: 'Reserve Bank of India & NABARD',
      officialUrl: 'https://www.nabard.org',
      lastUpdated: 'March 2025',
    ),
    GovernmentScheme(
      id: 'scheme_pmksy',
      name: 'PM Krishi Sinchayee Yojana (Per Drop More Crop)',
      category: 'Irrigation',
      shortDescription: 'Up to 55% subsidy on micro-irrigation systems (Drip and Sprinkler) to maximize water use efficiency.',
      detailedDescription: 'Focuses on enhancing water use efficiency at farm level through precision micro-irrigation, moisture conservation, and farm ponds to achieve Har Khet Ko Pani and More Crop Per Drop.',
      eligibility: [
        'All categories of farmers with assured water source and agricultural land.',
        'Small and Marginal farmers receive higher subsidy allocation (up to 55%).',
      ],
      benefits: [
        '45% to 55% capital subsidy on Drip and Sprinkler irrigation equipment.',
        'Saves 40-50% water while increasing crop yield by 20-30%.',
        'Enables fertigation to deliver dissolved fertilizers directly to root zones.',
      ],
      requiredDocuments: [
        'Aadhaar Card',
        'Land Record (RoR) & Electricity bill/water source proof',
        'Passport size photograph',
        'Bank account details',
      ],
      applicationProcess: [
        'Step 1: Register through State Horticulture/Agriculture Department portal.',
        'Step 2: Select registered micro-irrigation manufacturer/vendor.',
        'Step 3: Field verification and GPS survey by horticulture officer.',
        'Step 4: Installation followed by subsidy transfer to bank or vendor.',
      ],
      officialSource: 'Ministry of Jal Shakti & Dept of Agriculture',
      officialUrl: 'https://pmksy.gov.in',
      lastUpdated: 'January 2025',
    ),
    GovernmentScheme(
      id: 'scheme_soil_health',
      name: 'Soil Health Card (SHC) Scheme',
      category: 'Organic & Soil',
      shortDescription: 'Free soil testing and customized nutrient recommendations issued every 2 years.',
      detailedDescription: 'Assists farmers in improving productivity through judicious use of chemical fertilizers, organic compost, and micro-nutrients based on periodic laboratory soil analysis.',
      eligibility: [
        'All farmers across India possessing agricultural land.',
      ],
      benefits: [
        'Detailed status report on 12 parameters: N, P, K, S, Zn, Fe, Cu, Mn, Bo, pH, EC, and OC.',
        'Dosage advisory for specific crops to reduce wasteful fertilizer expenditure by 15-20%.',
        'Guidance on soil amendments like gypsum or lime for alkaline/acidic soils.',
      ],
      requiredDocuments: [
        'Aadhaar Card',
        'Land identification survey number',
        'Mobile number for digital SMS delivery',
      ],
      applicationProcess: [
        'Step 1: Soil samples collected by agricultural department field workers.',
        'Step 2: Samples tested in designated district Soil Testing Laboratories (STLs).',
        'Step 3: Soil Health Card generated and printed or downloaded via soilhealth.dac.gov.in.',
      ],
      officialSource: 'Ministry of Agriculture and Farmers Welfare',
      officialUrl: 'https://soilhealth.dac.gov.in',
      lastUpdated: 'December 2024',
    ),
    GovernmentScheme(
      id: 'scheme_pkvy',
      name: 'Paramparagat Krishi Vikas Yojana (PKVY)',
      category: 'Organic & Soil',
      shortDescription: 'Financial assistance of ₹50,000/ha over 3 years for organic farming cluster certification.',
      detailedDescription: 'Promotes organic farming through a cluster approach with Participatory Guarantee System (PGS) certification, bio-fertilizer production, and direct market linkage.',
      eligibility: [
        'Farmers organized into clusters of 20 or more members having 20 hectares land.',
        'Willingness to transition away from synthetic inputs.',
      ],
      benefits: [
        '₹50,000 per hectare allocated for organic conversion, seeds, and bio-inputs.',
        '₹31,000/ha transferred directly to farmer for procurement of bio-fertilizers and botanical sprays.',
        'Free PGS-India organic certification.',
      ],
      requiredDocuments: [
        'Cluster Farmer Group Registration',
        'Individual Aadhaar and Land Title documents',
        'Bank Passbook copy',
      ],
      applicationProcess: [
        'Step 1: Form a farmer group under Block Agriculture Officer / KVK guidance.',
        'Step 2: Submit cluster DPR on Jaivikkheti portal (jaivikkheti.in).',
        'Step 3: Undertake conversion protocol with lead agency monitoring.',
      ],
      officialSource: 'National Project on Organic Farming',
      officialUrl: 'https://pgsindia-ncof.gov.in',
      lastUpdated: 'February 2025',
    ),
    GovernmentScheme(
      id: 'scheme_smam',
      name: 'Sub-Mission on Agricultural Mechanization (SMAM)',
      category: 'Machinery',
      shortDescription: '40% to 50% subsidy on procurement of tractors, power tillers, rotavators, and harvesters.',
      detailedDescription: 'Enhances farm productivity and addresses agricultural labor shortages by incentivizing farm equipment purchase and establishing Custom Hiring Centers (CHCs) in rural areas.',
      eligibility: [
        'Small, marginal, SC/ST, and women farmers receive preference (50% subsidy rate).',
        'Other farmers eligible for 40% subsidy.',
      ],
      benefits: [
        'Subsidy up to ₹1.25 Lakh on tractors, ₹80,000 on power tillers.',
        'Up to 80% project cost subsidy for establishing Custom Hiring Centers by rural youth.',
      ],
      requiredDocuments: [
        'Aadhaar Card',
        'Land Records (7/12, Patta)',
        'Caste Certificate (if applicable)',
        'Bank passbook and manufacturer quotation',
      ],
      applicationProcess: [
        'Step 1: Register on Agricultural Mechanization Portal (agrimachinery.nic.in).',
        'Step 2: Select machine type, dealer, and upload quotation.',
        'Step 3: Administrative sanction issued based on target lottery/queue.',
      ],
      officialSource: 'Mechanization & Technology Division, MoA&FW',
      officialUrl: 'https://agrimachinery.nic.in',
      lastUpdated: 'January 2025',
    ),
    GovernmentScheme(
      id: 'scheme_kusum',
      name: 'PM-KUSUM Scheme (Solar Agriculture Pumps)',
      category: 'Irrigation',
      shortDescription: 'Up to 60% subsidy for installation of stand-alone solar agricultural water pumps.',
      detailedDescription: 'Enables farmers to replace diesel pumps with clean solar energy pumps and generate extra income by selling surplus solar power back to the electricity grid.',
      eligibility: [
        'Individual farmers, cooperatives, Panchayats, Farmer Producer Organizations (FPOs).',
        'Existing diesel pump users in off-grid or power-deficit rural areas.',
      ],
      benefits: [
        '60% total subsidy (30% Central + 30% State government).',
        'Bank loan covers 30%; farmer contributes only 10% upfront cost.',
        'Zero recurring diesel fuel expense and reliable daytime irrigation power.',
      ],
      requiredDocuments: [
        'Aadhaar Card',
        'Land Ownership Record and Water Source Certificate',
        'Bank details',
      ],
      applicationProcess: [
        'Step 1: Apply through State Renewable Energy Agency portal (e.g. TEDA, MEDA, HAREDA).',
        'Step 2: Upload water source capacity and site feasibility documents.',
        'Step 3: Verification followed by subsidized vendor installation.',
      ],
      officialSource: 'Ministry of New and Renewable Energy (MNRE)',
      officialUrl: 'https://pmkusum.mnre.gov.in',
      lastUpdated: 'February 2025',
    ),
  ];

  List<GovernmentScheme> getAllSchemes() => List.unmodifiable(_schemes);

  List<GovernmentScheme> getSchemesByCategory(String category) {
    if (category.toLowerCase() == 'all') return getAllSchemes();
    return _schemes.where((s) => s.category.toLowerCase().contains(category.toLowerCase())).toList();
  }

  List<GovernmentScheme> searchSchemes(String query) {
    if (query.trim().isEmpty) return getAllSchemes();
    final q = query.toLowerCase();
    return _schemes.where((s) =>
      s.name.toLowerCase().contains(q) ||
      s.shortDescription.toLowerCase().contains(q) ||
      s.category.toLowerCase().contains(q) ||
      s.benefits.any((b) => b.toLowerCase().contains(q))
    ).toList();
  }

  GovernmentScheme? getSchemeById(String id) {
    try {
      return _schemes.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Returns tailored scheme recommendations based on farmer's personal agricultural details
  List<SchemeRecommendation> getPersonalizedRecommendations(FarmerProfile? profile) {
    final List<SchemeRecommendation> recommendations = [];
    final land = profile?.landSizeAcres ?? 2.5;
    final crop = (profile?.mainCrop ?? 'Paddy (Rice)');
    final water = (profile?.waterAvailability ?? 'Canal Irrigation').toLowerCase();
    final soil = profile?.soilType ?? 'Alluvial Soil';

    // 1. PM-KISAN - Direct income support for all landholders
    final pmKisan = getSchemeById('scheme_pm_kisan');
    if (pmKisan != null) {
      recommendations.add(
        SchemeRecommendation(
          scheme: pmKisan,
          matchReason: 'Direct ₹6,000/yr financial support for your ${land.toStringAsFixed(1)} Acre landholding.',
          badgeText: 'Top Income Match',
          matchPercentage: 96,
        ),
      );
    }

    // 2. PMFBY Crop Insurance - Tailored for the specific crop
    final pmfby = getSchemeById('scheme_pmfby');
    if (pmfby != null) {
      recommendations.add(
        SchemeRecommendation(
          scheme: pmfby,
          matchReason: 'Protect your $crop crop against unseasonal weather with 1.5% - 2% low premium.',
          badgeText: '$crop Shield',
          matchPercentage: 92,
        ),
      );
    }

    // 3. PMKSY Micro-Irrigation (Drip/Sprinkler)
    final pmksy = getSchemeById('scheme_pmksy');
    if (pmksy != null) {
      recommendations.add(
        SchemeRecommendation(
          scheme: pmksy,
          matchReason: land <= 5.0
              ? 'Avail maximum 55% small-farmer subsidy on Drip & Sprinkler micro-irrigation.'
              : 'Save 40-50% irrigation water and boost yield with subsidized precision irrigation.',
          badgeText: '55% Water Subsidy',
          matchPercentage: 88,
        ),
      );
    }

    // 4. KCC Kisan Credit Card
    final kcc = getSchemeById('scheme_kcc');
    if (kcc != null) {
      recommendations.add(
        SchemeRecommendation(
          scheme: kcc,
          matchReason: 'Avail up to ₹3 Lakh working capital loan at subsidized 4% prompt interest rate.',
          badgeText: 'Low 4% Interest Credit',
          matchPercentage: 85,
        ),
      );
    }

    // 5. PM-KUSUM Solar Pump (if groundwater/borewell/well used)
    if (water.contains('borewell') || water.contains('well') || water.contains('tube') || water.contains('lift')) {
      final pmKusum = getSchemeById('scheme_pmkusum');
      if (pmKusum != null) {
        recommendations.add(
          SchemeRecommendation(
            scheme: pmKusum,
            matchReason: 'Eliminate electricity costs: 60% capital subsidy on Solar Agricultural Pumps.',
            badgeText: 'Solar Pump Grant',
            matchPercentage: 83,
          ),
        );
      }
    }

    // 6. Soil Health Card
    final shc = getSchemeById('scheme_soil_health');
    if (shc != null) {
      recommendations.add(
        SchemeRecommendation(
          scheme: shc,
          matchReason: 'Free laboratory testing and customized nutrient formula formulated for $soil.',
          badgeText: 'Free Soil Testing',
          matchPercentage: 80,
        ),
      );
    }

    return recommendations;
  }
}

class SchemeRecommendation {
  final GovernmentScheme scheme;
  final String matchReason;
  final String badgeText;
  final int matchPercentage;

  const SchemeRecommendation({
    required this.scheme,
    required this.matchReason,
    required this.badgeText,
    required this.matchPercentage,
  });
}
