import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/employee.dart';

class EmployeeService {
  const EmployeeService();

  Future<List<Employee>> fetchEmployees(String apiUrl) async {
    final uri = Uri.parse(apiUrl);
    final response = await http
        .get(
          uri,
          headers: const {
            'Accept': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load employees. Status: ${response.statusCode}. Body: ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is List) {
      return decoded
          .map((e) => Employee.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    if (decoded is Map<String, dynamic>) {
      final data = decoded['employees'];
      if (data is List) {
        return data
            .map((e) => Employee.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }

    throw Exception('Unexpected response format: ${response.body}');
  }
}

