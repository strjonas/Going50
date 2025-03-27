import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:going50/obd_lib/obd_service.dart';
import 'package:going50/obd_lib/models/obd_data.dart';
import 'package:going50/obd_lib/models/obd_command.dart';
import 'package:going50/obd_lib/protocol/obd_commands.dart';

class ObdTestPage extends StatefulWidget {
  @override
  _ObdTestPageState createState() => _ObdTestPageState();
}

class _ObdTestPageState extends State<ObdTestPage> {
  late ObdService _obdService;
  bool _isConnecting = false;
  String? _errorMessage;
  String? _response;
  ObdCommand? _selectedCommand;

  final List<ObdCommand> _commands = ObdCommands.allCommands;

 

  Future<void> _executeCommand() async {
    if (_selectedCommand == null) return;

    setState(() {
      _isConnecting = true;
      _errorMessage = null;
      _response = null;
    });

    try {
      final response = await _obdService.sendCustomCommand(_selectedCommand!.command);
      setState(() {
        _response = response;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to execute command: $e';
      });
    } finally {
      setState(() {
        _isConnecting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OBD Test Page'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Command selection section
              Expanded(
                flex: 2,
                child: _buildCommandSelectionSection(),
              ),

              // Execution section
              Expanded(
                flex: 1,
                child: _buildExecutionSection(),
              ),

              // Response display section
              Expanded(
                flex: 2,
                child: _buildResponseSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommandSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select a Command:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        DropdownButton<ObdCommand>(
          hint: Text('Select a command'),
          value: _selectedCommand,
          onChanged: (command) {
            setState(() {
              _selectedCommand = command;
            });
          },
          items: _commands.map((command) {
            return DropdownMenuItem(
              value: command,
              child: Text(command.name),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildExecutionSection() {
    return Center(
      child: ElevatedButton(
        onPressed: _executeCommand,
        child: Text('Execute Command'),
      ),
    );
  }

  Widget _buildResponseSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isConnecting) Center(child: CircularProgressIndicator()),
        if (_errorMessage != null) Text('Error: $_errorMessage', style: TextStyle(color: Colors.red)),
        if (_response != null) Text('Response: $_response'),
      ],
    );
  }
} 