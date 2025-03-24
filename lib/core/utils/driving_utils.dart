import 'dart:math' as math;

/// A utility class for driving-related calculations
class DrivingUtils {
  /// Calculate the eco-efficiency score of a speed in km/h
  /// Returns a score between 0 and 100 based on how close the speed is to the optimal range
  static double calculateSpeedEfficiencyScore(double speedKmh) {
    // Most vehicles are most efficient between 50-80 km/h (31-50 mph)
    const double optimumLower = 50.0;
    const double optimumUpper = 80.0;
    
    // Score is 100 if within optimal range
    if (speedKmh >= optimumLower && speedKmh <= optimumUpper) {
      return 100.0;
    }
    
    // Score decreases as speed moves away from optimal range
    // Using a logarithmic falloff for more realistic scoring
    if (speedKmh < optimumLower) {
      // For speeds below optimal range
      return 100.0 * (1.0 - math.log(optimumLower / math.max(speedKmh, 5.0)) * 0.2);
    } else {
      // For speeds above optimal range
      return 100.0 * (1.0 - math.log(speedKmh / optimumUpper) * 0.1);
    }
  }
  
  /// Calculate the estimated fuel consumption (L/100km) based on speed and other factors
  /// This is a simplified model and should be calibrated with real-world data
  static double estimateFuelConsumption(double speedKmh, double accelerationMps2, double engineRpm) {
    // Base consumption for a typical mid-size vehicle at steady speed
    double baseFuelConsumption = 0.0;
    
    // Adjust for speed (U-shaped curve with minimum around 70-90 km/h)
    if (speedKmh < 40) {
      // Higher consumption at low speeds
      baseFuelConsumption = 8.0 + (40 - speedKmh) * 0.1;
    } else if (speedKmh <= 80) {
      // Optimal range 
      baseFuelConsumption = 5.0 + (speedKmh - 60).abs() * 0.05;
    } else {
      // Increases with speed above optimal range
      baseFuelConsumption = 6.0 + (speedKmh - 80) * 0.06;
    }
    
    // Adjust for acceleration (higher acceleration = higher consumption)
    double accelerationFactor = 1.0 + math.max(0.0, accelerationMps2) * 0.5;
    
    // Adjust for RPM (higher RPM = higher consumption)
    double rpmFactor = 1.0;
    if (engineRpm > 0) {  // Only if we have RPM data
      rpmFactor = 1.0 + math.max(0.0, (engineRpm - 1500) / 1000) * 0.2;
    }
    
    return baseFuelConsumption * accelerationFactor * rpmFactor;
  }
  
  /// Calculate the estimated CO2 emissions (g/km) based on fuel consumption
  /// Using an average conversion factor for gasoline
  static double estimateCO2Emissions(double fuelConsumptionL100km) {
    // Average conversion factor: ~2.3 kg CO2 per liter of gasoline
    const double co2PerLiterGasoline = 2300.0; // g/L
    
    // Convert L/100km to g/km
    return (fuelConsumptionL100km * co2PerLiterGasoline) / 100.0;
  }
  
  /// Calculate acceleration from two speed measurements
  static double calculateAcceleration(double speedKmh1, double speedKmh2, double timeIntervalSeconds) {
    if (timeIntervalSeconds <= 0) {
      return 0.0;
    }
    
    // Convert km/h to m/s
    double speedMps1 = speedKmh1 * (1000.0 / 3600.0);
    double speedMps2 = speedKmh2 * (1000.0 / 3600.0);
    
    // Calculate acceleration in m/s²
    return (speedMps2 - speedMps1) / timeIntervalSeconds;
  }
  
  /// Detect if an acceleration event is aggressive
  static bool isAggressiveAcceleration(double accelerationMps2) {
    // Threshold for aggressive acceleration (typical threshold is 2.5-3.0 m/s²)
    const double aggressiveAccelerationThreshold = 2.5;
    
    return accelerationMps2 > aggressiveAccelerationThreshold;
  }
  
  /// Detect if a braking event is aggressive
  static bool isAggressiveBraking(double accelerationMps2) {
    // Threshold for aggressive braking (typical threshold is -3.0 to -3.5 m/s²)
    const double aggressiveBrakingThreshold = -3.0;
    
    return accelerationMps2 < aggressiveBrakingThreshold;
  }
  
  /// Calculate the optimal following distance in meters based on speed
  static double calculateOptimalFollowingDistance(double speedKmh) {
    // Using the 3-second rule: distance = speed × time
    const double followingTimeSeconds = 3.0;
    
    // Convert km/h to m/s for distance calculation
    double speedMps = speedKmh * (1000.0 / 3600.0);
    
    return speedMps * followingTimeSeconds;
  }
  
  /// Calculate distance between two coordinate points using the Haversine formula
  static double calculateDistanceBetweenCoordinates(
    double lat1, double lon1, double lat2, double lon2
  ) {
    const double earthRadiusKm = 6371.0;
    
    // Convert degrees to radians
    double toRadians(double degrees) => degrees * math.pi / 180.0;
    
    final double dLat = toRadians(lat2 - lat1);
    final double dLon = toRadians(lon2 - lon1);
    
    final double a = 
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(toRadians(lat1)) * math.cos(toRadians(lat2)) * 
        math.sin(dLon / 2) * math.sin(dLon / 2);
    
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }
  
  /// Determine if a trip is considered "short distance" (potentially inefficient)
  static bool isShortDistanceTrip(double distanceKm) {
    // Trips under 3 km are generally considered short
    const double shortTripThresholdKm = 3.0;
    
    return distanceKm < shortTripThresholdKm;
  }
  
  /// Calculate the eco-savings from improved driving (in liters of fuel)
  static double calculateFuelSavings(double distanceKm, double actualConsumptionL100km, double targetConsumptionL100km) {
    // Calculate difference in consumption
    double consumptionDifferenceL100km = actualConsumptionL100km - targetConsumptionL100km;
    
    // Convert to actual fuel saved
    return (consumptionDifferenceL100km * distanceKm) / 100.0;
  }
  
  /// Calculate the cost savings from improved fuel efficiency
  static double calculateCostSavings(double fuelSavedL, double fuelPricePerLiter) {
    return fuelSavedL * fuelPricePerLiter;
  }
  
  /// Calculate the CO2 savings from improved driving (in kg)
  static double calculateCO2Savings(double fuelSavedL) {
    // Average conversion factor: ~2.3 kg CO2 per liter of gasoline
    const double co2PerLiterGasoline = 2.3; // kg/L
    
    return fuelSavedL * co2PerLiterGasoline;
  }
} 