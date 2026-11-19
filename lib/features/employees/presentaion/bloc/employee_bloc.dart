import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:employees/features/employees/domain/entities/employee_entity.dart';
import 'package:employees/features/employees/domain/repositories/employee_repository.dart';
import 'package:equatable/equatable.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeRepository repository;
  EmployeeBloc(this.repository) : super(EmployeeState()) {
    on<LoadEmployeesEvent>(_loadEmployees);
    on<AddEmployeeEvent>(_addEmployee);
    on<UpdateEmployeeEvent>(_updateEmployee);
    on<DeleteEmployeeEvent>(_deleteEmployee);
  }

  FutureOr<void> _loadEmployees(
    LoadEmployeesEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(state.copyWith(status: EmployeeStatus.loading, message: null));
    try {
      final employees = await repository.getEmployees();
      emit(
        state.copyWith(status: EmployeeStatus.success, employees: employees),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EmployeeStatus.failure,
          message: 'Failed to load employees',
        ),
      );
      throw Exception('Failed to load employees: $e');
    }
  }

  FutureOr<void> _addEmployee(
    AddEmployeeEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(state.copyWith(status: EmployeeStatus.loading, message: null));
    try {
      await repository.addEmployee(event.employee);
      final employees = await repository.getEmployees();
      emit(
        state.copyWith(
          status: EmployeeStatus.success,
          employees: employees,
          message: 'Employee added successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EmployeeStatus.failure,
          message: 'Failed to add employee',
        ),
      );
      throw Exception('Failed to add employee: $e');
    }
  }

  FutureOr<void> _updateEmployee(
    UpdateEmployeeEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(state.copyWith(status: EmployeeStatus.loading, message: null));
    try {
      await repository.updateEmployee(event.employee);
      final employees = await repository.getEmployees();
      emit(
        state.copyWith(
          status: EmployeeStatus.success,
          employees: employees,
          message: 'Employee updated successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EmployeeStatus.failure,
          message: 'Failed to update employee',
        ),
      );
      throw Exception('Failed to update employee: $e');
    }
  }

  FutureOr<void> _deleteEmployee(
    DeleteEmployeeEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(state.copyWith(status: EmployeeStatus.loading, message: null));
    try {
      await repository.deleteEmployee(event.id);
      final employees = await repository.getEmployees();

      emit(
        state.copyWith(
          status: EmployeeStatus.success,
          employees: employees,
          message: 'Employee deleted successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EmployeeStatus.failure,
          message: 'Failed to delete employee',
        ),
      );
      throw Exception('Failed to delete employee: $e');
    }
  }
}
