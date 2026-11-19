part of 'employee_bloc.dart';

enum EmployeeStatus { initial, loading, success, failure }

class EmployeeState extends Equatable {
  final EmployeeStatus status;
  final List<EmployeeEntity> employees;
  final String? message;

  const EmployeeState({
    this.status = EmployeeStatus.initial,
    this.employees = const [],
    this.message,
  });

  EmployeeState copyWith({
    EmployeeStatus? status,
    List<EmployeeEntity>? employees,
    String? message,
  }) {
    return EmployeeState(
      status: status ?? this.status,
      employees: employees ?? this.employees,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, employees, message];
}
