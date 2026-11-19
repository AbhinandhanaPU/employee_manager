import 'package:employees/features/employees/domain/entities/employee_entity.dart';

abstract class EmployeeRepository {
  Future<List<EmployeeEntity>> getEmployees();

  Future<void> addEmployee(EmployeeEntity employee);

  Future<void> updateEmployee(EmployeeEntity employee);

  Future<void> deleteEmployee(String id);
}
