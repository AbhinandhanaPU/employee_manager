part of 'employee_bloc.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object> get props => [];
}

class LoadEmployeesEvent extends EmployeeEvent {
  const LoadEmployeesEvent();
}

class AddEmployeeEvent extends EmployeeEvent {
  final EmployeeEntity employee;

  const AddEmployeeEvent(this.employee);

  @override
  List<Object> get props => [employee];
}

class UpdateEmployeeEvent extends EmployeeEvent {
  final EmployeeEntity employee;

  const UpdateEmployeeEvent(this.employee);

  @override
  List<Object> get props => [employee];
}

class DeleteEmployeeEvent extends EmployeeEvent {
  final String id;

  const DeleteEmployeeEvent(this.id);

  @override
  List<Object> get props => [id];
}
