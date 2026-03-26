import 'package:flutter/material.dart';

import 'employees_screen.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: onLogout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: EmployeesScreen(showAppBar: false),
    );
  }
}

