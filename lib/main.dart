import 'package:flutter/material.dart';

import 'screens/dashboard_page.dart';
import 'screens/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _loggedIn = false;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void _showSnack(String message, {Color? backgroundColor}) {
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      title: 'Employee App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: _loggedIn
          ? DashboardPage(
              onLogout: () {
                setState(() => _loggedIn = false);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _showSnack(
                    'Logged out',
                    backgroundColor: Colors.red,
                  );
                });
              },
            )
          : LoginPage(
              onLogin: () {
                setState(() => _loggedIn = true);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _showSnack(
                    'Login successful',
                    backgroundColor: Colors.green,
                  );
                });
              },
            ),
    );
  }
}
