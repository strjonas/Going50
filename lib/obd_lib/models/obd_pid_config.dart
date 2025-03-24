import 'package:flutter/material.dart';
import '../protocol/obd_constants.dart';

/// Represents configuration for an OBD-II Parameter ID (PID)
class ObdPidConfig {
  /// The PID code (e.g., '05' for coolant temperature)
  final String pid;

  /// Human-readable name to display
  final String displayName;

  /// Unit of measurement (e.g., 'km/h', '°C')
  final String unit;

  /// Icon to display with the data
  final IconData icon;

  /// Importance/priority (lower number = higher priority)
  final int priority;

  /// Creates a new OBD PID configuration
  const ObdPidConfig({
    required this.pid,
    required this.displayName,
    required this.unit,
    required this.icon,
    this.priority = 100,
  });

  /// Standard PIDs with predefined configurations
  static const Map<String, ObdPidConfig> standardPids = {
    // Coolant temperature
    ObdConstants.pidCoolantTemp: ObdPidConfig(
      pid: ObdConstants.pidCoolantTemp,
      displayName: 'Coolant Temp',
      unit: '°C',
      icon: Icons.thermostat,
      priority: 10,
    ),
    
    // Engine RPM
    ObdConstants.pidEngineRpm: ObdPidConfig(
      pid: ObdConstants.pidEngineRpm,
      displayName: 'Engine RPM',
      unit: 'RPM',
      icon: Icons.speed,
      priority: 1,
    ),
    
    // Vehicle speed
    ObdConstants.pidVehicleSpeed: ObdPidConfig(
      pid: ObdConstants.pidVehicleSpeed,
      displayName: 'Vehicle Speed',
      unit: 'km/h', 
      icon: Icons.directions_car,
      priority: 2,
    ),
    
    // Control module voltage
    ObdConstants.pidControlModuleVoltage: ObdPidConfig(
      pid: ObdConstants.pidControlModuleVoltage,
      displayName: 'Voltage',
      unit: 'V',
      icon: Icons.battery_charging_full,
      priority: 20,
    ),

    // Current fuel level
    ObdConstants.pidCurrentFuelLevel: ObdPidConfig(
      pid: ObdConstants.pidCurrentFuelLevel,
      displayName: 'Fuel Level',
      unit: '%',
      icon: Icons.local_gas_station,
    ),

    // Fuel type
    ObdConstants.pidFuelType: ObdPidConfig(
      pid: ObdConstants.pidFuelType,
      displayName: 'Fuel Type',
      unit: '',
      icon: Icons.local_gas_station,
    ),

    // Engine load
    ObdConstants.pidEngineLoad: ObdPidConfig(
      pid: ObdConstants.pidEngineLoad,
      displayName: 'Engine Load',
      unit: '%',
      icon: Icons.speed,
    ),

    // Throttle position
    ObdConstants.pidThrottlePosition: ObdPidConfig(
      pid: ObdConstants.pidThrottlePosition,
      displayName: 'Throttle Position',
      unit: '%',
      icon: Icons.add_to_drive_sharp
    ),

    // Intake manifold absolute pressure
    ObdConstants.pidIntakeManifoldAbsolutePressure: ObdPidConfig(
      pid: ObdConstants.pidIntakeManifoldAbsolutePressure,
      displayName: 'Intake Manifold Absolute Pressure',
      unit: 'kPa',
      icon: Icons.speed,
    ),

    // Intake air temperature
    ObdConstants.pidIntakeAirTemperature: ObdPidConfig(
      pid: ObdConstants.pidIntakeAirTemperature,
      displayName: 'Intake Air Temperature',
      unit: '°C',
      icon: Icons.air
    ),

    // Engine oil temperature
    ObdConstants.pidEngineOilTemperature: ObdPidConfig(
      pid: ObdConstants.pidEngineOilTemperature,
      displayName: 'Engine Oil Temperature',
      unit: '°C',
      icon: Icons.oil_barrel
    ),

    // Ambient air temperature
    ObdConstants.pidAmbientAirTemperature: ObdPidConfig(
      pid: ObdConstants.pidAmbientAirTemperature,
      displayName: 'Ambient Air Temperature',
      unit: '°C',
      icon: Icons.thermostat
    ),

    // Fuel pressure
    ObdConstants.pidFuelPressure: ObdPidConfig(
      pid: ObdConstants.pidFuelPressure,
      displayName: 'Fuel Pressure',
      unit: 'kPa',
      icon: Icons.local_gas_station
    ),
    
    // Mass Air Flow rate
    ObdConstants.pidMassAirFlow: ObdPidConfig(
      pid: ObdConstants.pidMassAirFlow,
      displayName: 'Mass Air Flow',
      unit: 'g/s',
      icon: Icons.air,
      priority: 15,
    ),
    
    // Distance traveled with MIL on
    ObdConstants.pidDistanceMIL: ObdPidConfig(
      pid: ObdConstants.pidDistanceMIL,
      displayName: 'Distance with MIL',
      unit: 'km',
      icon: Icons.warning,
      priority: 40,
    ),
    
    // Fuel rate
    ObdConstants.pidFuelRate: ObdPidConfig(
      pid: ObdConstants.pidFuelRate,
      displayName: 'Fuel Rate',
      unit: 'L/h',
      icon: Icons.local_gas_station,
      priority: 12,
    ),
    
    // Accelerator pedal position
    ObdConstants.pidAcceleratorPosition: ObdPidConfig(
      pid: ObdConstants.pidAcceleratorPosition,
      displayName: 'Accelerator Position',
      unit: '%',
      icon: Icons.pedal_bike,
      priority: 8,
    ),
  };

  /// Get a predefined PID configuration by PID
  static ObdPidConfig getConfig(String pid) {
    return standardPids[pid] ?? ObdPidConfig(
      pid: pid,
      displayName: 'PID $pid',
      unit: '',
      icon: Icons.data_usage,
    );
  }

  /// Get a list of all standard PID configurations
  static List<ObdPidConfig> get allConfigs => 
      standardPids.values.toList()
        ..sort((a, b) => a.priority.compareTo(b.priority));
} 