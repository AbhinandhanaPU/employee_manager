import 'package:employees/core/database/database_helper.dart';
import 'package:employees/features/employees/data/models/employee_model.dart';
import 'package:employees/features/employees/domain/entities/employee_entity.dart';
import 'package:employees/features/employees/domain/repositories/employee_repository.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  // Reads all Employee records from the Hive database and returns them as a list of EmployeeEntity objects.
  @override
  Future<List<EmployeeEntity>> getEmployees() async {
    final box = DatabaseHelper.getEmployeesBox();

    return box.values.map((data) {
      final employeeMap = Map<String, dynamic>.from(data);

      return EmployeeModel.fromMap(employeeMap);
    }).toList();
  }

  // Saves an Employee record to the Hive database.
  @override
  Future<void> addEmployee(EmployeeEntity employee) async {
    final box = DatabaseHelper.getEmployeesBox();
    final model = EmployeeModel(
      id: employee.id,
      name: employee.name,
      email: employee.email,
      phone: employee.phone,
      designation: employee.designation,
    );
    await box.put(model.id, model.toMap());
  }

  // Updates an existing Employee record in the Hive database
  @override
  Future<void> updateEmployee(EmployeeEntity employee) async {
    final box = DatabaseHelper.getEmployeesBox();
    final model = EmployeeModel(
      id: employee.id,
      name: employee.name,
      email: employee.email,
      phone: employee.phone,
      designation: employee.designation,
    );
    if (!box.containsKey(model.id)) {
      throw Exception('Employee with id ${model.id} does not exist.');
    }
    await box.put(model.id, model.toMap());
  }

  // Deletes an Employee record from the Hive database based on the provided id.
  @override
  Future<void> deleteEmployee(String id) async {
    final box = DatabaseHelper.getEmployeesBox();
    if (!box.containsKey(id)) {
      throw Exception('Employee with id $id does not exist.');
    }
    await box.delete(id);
  }
}
