import '../models/obd_command.dart';
import 'obd_constants.dart';

/// Provides standard OBD-II commands
class ObdCommands {
  // Private constructor to prevent instantiation
  ObdCommands._();
  
  /// Get supported PIDs 01-20
  static final supportedPids = ObdCommand.mode01(
    ObdConstants.pidSupportedPids,
    name: 'Supported PIDs',
    description: 'PIDs supported [01-20]',
  );
  
  /// Get engine coolant temperature
  static final coolantTemperature = ObdCommand.mode01(
    ObdConstants.pidCoolantTemp,
    name: 'Coolant Temperature',
    description: 'Engine coolant temperature',
  );
  
  /// Get engine RPM
  static final engineRpm = ObdCommand.mode01(
    ObdConstants.pidEngineRpm,
    name: 'Engine RPM',
    description: 'Engine revolutions per minute',
  );
  
  /// Get vehicle speed
  static final vehicleSpeed = ObdCommand.mode01(
    ObdConstants.pidVehicleSpeed,
    name: 'Vehicle Speed',
    description: 'Vehicle speed in km/h',
  );
  
  /// Get control module voltage
  static final controlModuleVoltage = ObdCommand.mode01(
    ObdConstants.pidControlModuleVoltage,
    name: 'Control Module Voltage',
    description: 'Control module voltage',
  );

  static final fuelRate = ObdCommand.mode01(
    ObdConstants.pidFuelRate,
    name: 'Fuel Rate',
    description: 'Fuel rate in L/h',
  );
  
  /// ATZ - Reset the ELM327
  static final reset = ObdCommand(
    mode: 'AT',
    pid: 'Z',
    name: 'Reset',
    description: 'Reset the ELM327 adapter',
  );
  
  /// ATE0 - Turn echo off
  static final echoOff = ObdCommand(
    mode: 'AT',
    pid: 'E0',
    name: 'Echo Off',
    description: 'Turn command echo off',
  );
  
  /// ATH0 - Turn headers off
  static final headersOff = ObdCommand(
    mode: 'AT',
    pid: 'H0',
    name: 'Headers Off',
    description: 'Turn headers off',
  );
  
  /// ATL0 - Turn linefeeds off
  static final linebreaksOff = ObdCommand(
    mode: 'AT',
    pid: 'L0',
    name: 'Linefeeds Off',
    description: 'Turn linefeeds off',
  );
  
  /// ATSP4 - Set protocol to ISO 14230-4 KWP (5 baud init)
  static final setProtocol = ObdCommand(
    mode: 'AT',
    pid: 'SP4',
    name: 'Set Protocol',
    description: 'Set protocol to ISO 14230-4 KWP (5 baud init)',
  );
  
  /// ATBRD10 - Set baud rate divisor to 10.4 kbaud
  static final setBaudRate = ObdCommand(
    mode: 'AT',
    pid: 'BRD10',
    name: 'Set Baud Rate',
    description: 'Set baud rate to 10.4 kbaud',
  );
  
  /// ATST20 - Set timeout to 200ms
  static final setTimeout = ObdCommand(
    mode: 'AT',
    pid: 'ST20',
    name: 'Set Timeout',
    description: 'Set timeout to 200ms (20 x 10ms)',
  );
  
  /// Get a list of all standard commands
  static List<ObdCommand> get allCommands => [
    supportedPids,
    coolantTemperature,
    engineRpm,
    vehicleSpeed,
    controlModuleVoltage,
    fuelRate,
  ];
  
  /// Get a list of initialization commands in the correct order
  static List<ObdCommand> get initializationCommands => [
    reset,
    echoOff,
    headersOff,
    linebreaksOff,
    setProtocol,
    setBaudRate,
    setTimeout,
    supportedPids,
  ];
} 