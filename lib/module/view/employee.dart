Employee toEmployee(Map<String, Object?> map) => Employee.toEmp(map);

class Employee {
  final int empId;
  final String empName;
  final String empDesignation;
  final bool isMale;
  Employee(
      {required this.empId,
      required this.empName,
      required this.empDesignation,
      required this.isMale});

  Map<String, dynamic> toMap() => {
        "id": empId,
        "name": empName,
        "desg": empDesignation,
        "isMale": isMale,
      };

  factory Employee.toEmp(Map<String, dynamic> map) => Employee(
      empId: map["id"],
      empName: map["name"],
      empDesignation: map["desg"],
      isMale: map["isMale"] == 1 ? true : false);
}
