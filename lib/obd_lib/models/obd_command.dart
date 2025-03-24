/// Represents an OBD-II command
class ObdCommand {
  /// The command mode (e.g., '01' for current data)
  final String mode;
  
  /// The Parameter ID (PID) for the command
  final String pid;
  
  /// Optional additional parameters
  final List<String> parameters;
  
  /// Human-readable name of the command
  final String name;
  
  /// Description of what this command retrieves
  final String description;
  
  /// Creates a new OBD-II command
  const ObdCommand({
    required this.mode,
    required this.pid,
    this.parameters = const [],
    required this.name,
    required this.description,
  });
  
  /// The full command string to send to the OBD-II adapter
  String get command {
    final buffer = StringBuffer();
    buffer.write(mode);
    buffer.write(pid);
    
    for (final param in parameters) {
      buffer.write(' ');
      buffer.write(param);
    }
    
    return buffer.toString();
  }
  
  /// Creates a standard mode 01 command for current data
  factory ObdCommand.mode01(
    String pid, {
    required String name,
    required String description,
    List<String> parameters = const [],
  }) {
    return ObdCommand(
      mode: '01',
      pid: pid,
      name: name,
      description: description,
      parameters: parameters,
    );
  }
  
  /// Creates a standard mode 09 command for vehicle information
  factory ObdCommand.mode09(
    String pid, {
    required String name,
    required String description,
    List<String> parameters = const [],
  }) {
    return ObdCommand(
      mode: '09',
      pid: pid,
      name: name,
      description: description,
      parameters: parameters,
    );
  }
  
  @override
  String toString() => '$name ($mode$pid)';
} 