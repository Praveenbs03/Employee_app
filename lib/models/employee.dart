class Employee {
  final int id;
  final String name;
  final DateTime? joinDate;
  final bool isActive;
  final bool flagged;
  final int? yearsAtOrg;

  const Employee({
    required this.id,
    required this.name,
    required this.joinDate,
    required this.isActive,
    required this.flagged,
    required this.yearsAtOrg,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    final joinDateValue = json['join_date'];
    final joinDate = joinDateValue is String && joinDateValue.isNotEmpty
        ? DateTime.tryParse(joinDateValue)
        : null;

    final yearsAtOrgValue = json['yearsAtOrg'];
    final yearsAtOrg = yearsAtOrgValue is int
        ? yearsAtOrgValue
        : (yearsAtOrgValue is String ? int.tryParse(yearsAtOrgValue) : null);

    return Employee(
      id: (json['id'] as num).toInt(),
      name: (json['name'] as String),
      joinDate: joinDate,
      isActive: json['is_active'] == 1 ||
          json['is_active'] == true ||
          json['is_active'] == '1',
      flagged: json['flagged'] == true ||
          json['flagged'] == 1 ||
          json['flagged'] == '1',
      yearsAtOrg: yearsAtOrg,
    );
  }
}

