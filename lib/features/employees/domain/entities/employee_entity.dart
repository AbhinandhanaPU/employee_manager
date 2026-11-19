import 'package:equatable/equatable.dart';

class EmployeeEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String designation;

  const EmployeeEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.designation,
  });

  @override
  List<Object?> get props => [id, name, email, phone, designation];
}
