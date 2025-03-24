/// Constants for OBD-II protocol
class ObdConstants {
  // Private constructor to prevent instantiation
  ObdConstants._();
  
  /// Service UUID for ELM327 Bluetooth
  /// Using the full UUID format for cross-platform compatibility
  /// The standard format for Bluetooth UUIDs is: 0000XXXX-0000-1000-8000-00805f9b34fb
  /// where XXXX is the short-form UUID
  static const String serviceUuid = '0000fff0-0000-1000-8000-00805f9b34fb';
  
  /// Characteristic UUID for notifications (reading from ELM327)
  static const String notifyCharacteristicUuid = '0000fff1-0000-1000-8000-00805f9b34fb';
  
  /// Characteristic UUID for writing commands to ELM327
  static const String writeCharacteristicUuid = '0000fff2-0000-1000-8000-00805f9b34fb';
  
  /// Command terminator (carriage return)
  static const String commandTerminator = '\r';
  
  /// Response timeout for commands (ms)
  static const int responseTimeoutMs = 300;
  
  /// Connection timeout (ms)
  static const int connectionTimeoutMs = 10000;
  
  /// Command timeout (ms)
  static const int commandTimeoutMs = 4000;
  
  /// Delay between commands during initialization (ms)
  static const int initCommandDelayMs = 300;
  
  /// Delay after reset command (ms)
  static const int resetDelayMs = 1000;
  
  /// Standard OBD-II protocol commands
  static const String resetCommand = 'ATZ';
  static const String echoOffCommand = 'ATE0';
  static const String headersOffCommand = 'ATH0';
  static const String linebreaksOffCommand = 'ATL0';
  static const String protocolKwpCommand = 'ATSP4'; // ISO 14230-4 KWP (5 baud init)
  static const String baudRateCommand = 'ATBRD10'; // 10.4 kbaud
  static const String timeoutCommand = 'ATST20'; // 200ms timeout
  static const String supportedPidsCommand = '0100'; // Get supported PIDs 01-20
  
  /// Standard OBD-II Mode 01 PIDs
  static const String pidSupportedPids = '00'; // PIDs supported 01-20
  static const String pidCoolantTemp = '05'; // Engine coolant temperature
  static const String pidEngineRpm = '0C'; // Engine RPM
  static const String pidVehicleSpeed = '0D'; // Vehicle speed
  static const String pidControlModuleVoltage = '42'; // Control module voltage
  static const String pidCurrentFuelLevel = '2F'; // Current fuel level
  static const String pidFuelType = '51'; // Fuel type
  // engine load
  static const String pidEngineLoad = '04'; // Engine load
  // throttle position
  static const String pidThrottlePosition = '11'; // Throttle position  
  // intake manifold absolute pressure
  static const String pidIntakeManifoldAbsolutePressure = '0B'; // Intake manifold absolute pressure
  // intake air temperature
  static const String pidIntakeAirTemperature = '0F'; // Intake air temperature
  // engine oil temperature
  static const String pidEngineOilTemperature = '5C'; // Engine oil temperature
  // ambient air temperature
  static const String pidAmbientAirTemperature = '1F'; // Ambient air temperature
  // fuel pressure
  static const String pidFuelPressure = '23'; // Fuel pressure
  // fuel level
  static const String pidFuelLevel = '2F'; // Fuel level
  
  /// Standard PIDs for OBD-II
  static const String engineRpmPid = '010C';
  static const String vehicleSpeedPid = '010D';
  static const String coolantTempPid = '0105';
  static const String controlModuleVoltagePid = '0142';
  
  /// ELM327 commands
  static const String setProtocolCommand = 'ATSP0';
  static const String setBaudRateCommand = 'ATBRD';
  
  /// Response prefixes and patterns
  static const String okResponse = 'OK';
  static const String errorResponse = 'ERROR';
  static const String noDataResponse = 'NO DATA';
  static const String searchingResponse = 'SEARCHING';
  
  /// Timeout values (in milliseconds)
  static const int commandTimeout = 2000;
  static const int connectionTimeout = 5000;
  static const int initializationTimeout = 10000;
  
  /// Polling intervals (in milliseconds)
  static const int defaultPollingInterval = 1200;
  static const int fastPollingInterval = 700;
  static const int slowPollingInterval = 2000;
  static const int engineOffPollingInterval = 5000;
  
  // Additional PIDs for eco-driving analysis
  static const String pidMassAirFlow = '10'; // Mass air flow rate (g/s)
  static const String pidDistanceMIL = '21'; // Distance traveled with MIL on (km)
  static const String pidFuelRate = '5E'; // Engine fuel rate (L/h)
  static const String pidAcceleratorPosition = '49'; // Accelerator pedal position D (%)
} 