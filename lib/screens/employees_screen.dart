import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../models/employee.dart';
import '../services/employee_service.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key, this.showAppBar = true});

  final bool showAppBar;

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  final _service = const EmployeeService();


  String _apiUrl = kIsWeb
      ? 'http://localhost:8001/api/employees'
      : 'http://10.0.2.2:8000/api/employees.php';

  late Future<List<Employee>> _futureEmployees;

  @override
  void initState() {
    super.initState();
    _futureEmployees = _service.fetchEmployees(_apiUrl);
  }

  Future<void> _refresh() async {
    setState(() {
      _futureEmployees = _service.fetchEmployees(_apiUrl);
    });
  }

  Future<void> _editApiUrl() async {
    final controller = TextEditingController(text: _apiUrl);

    final updated = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('API URL'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'http://<host>:8000/api/employees.php',
            ),
            keyboardType: TextInputType.url,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(controller.text.trim()),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (updated == null || updated.isEmpty || updated == _apiUrl) return;

    setState(() {
      _apiUrl = updated;
      _futureEmployees = _service.fetchEmployees(_apiUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    final listBody = FutureBuilder<List<Employee>>(
      future: _futureEmployees,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Failed to load employees:\n${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }
        final employees = snapshot.data ?? [];
        if (employees.isEmpty) {
          return const Center(child: Text('No employees found.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: employees.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final e = employees[index];

            final tileColor = e.flagged
                ? Colors.green.withValues(alpha: 0.12)
                : Theme.of(context).colorScheme.surface;

            return Container(
              decoration: BoxDecoration(
                color: tileColor,
                borderRadius: BorderRadius.circular(14),
                border: e.flagged
                    ? Border.all(
                        color: Colors.green.withValues(alpha: 0.6),
                        width: 1,
                      )
                    : null,
              ),
              child: ListTile(
                title: Text(
                  e.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: e.flagged ? Colors.green[900] : null,
                  ),
                ),
                subtitle: Text(
                  [
                    if (e.joinDate != null)
                      'Joined: ${e.joinDate!.toIso8601String().split('T').first}',
                    'Active: ${e.isActive ? "Yes" : "No"}',
                  ].join('\n'),
                ),
                isThreeLine: true,
                trailing: e.flagged
                    ? Chip(
                        label: Text(
                          "FLAGGED${e.yearsAtOrg != null ? ' (${e.yearsAtOrg}y)' : ''}",
                          style: TextStyle(
                            color: Colors.green[900],
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        backgroundColor: Colors.green.withValues(alpha: 0.18),
                        side: BorderSide(
                          color: Colors.green.withValues(alpha: 0.5),
                        ),
                      )
                    : null,
              ),
            );
          },
        );
      },
    );

    if (!widget.showAppBar) {
      return listBody;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Edit API URL',
            onPressed: _editApiUrl,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: listBody,
    );
  }
}

