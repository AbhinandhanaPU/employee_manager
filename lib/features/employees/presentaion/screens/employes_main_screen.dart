import 'package:employees/features/employees/presentaion/bloc/employee_bloc.dart';
import 'package:employees/features/employees/presentaion/screens/employee_form_screen.dart';
import 'package:employees/features/employees/presentaion/widgets/employee_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployesMainScreen extends StatelessWidget {
  const EmployesMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees List'),
        actions: [
          TextButton.icon(
            label: const Text(
              'Add Employee',
              style: TextStyle(color: Colors.black),
            ),
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const EmployeeFormScreen(editingEmployee: false),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state.status == EmployeeStatus.loading ||
              state.status == EmployeeStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == EmployeeStatus.failure) {
            return Center(
              child: Text(state.message ?? 'Failed to load employees'),
            );
          } else if (state.status == EmployeeStatus.success &&
              state.employees.isEmpty) {
            return const Center(child: Text('No employees found'));
          }
          return ListView.builder(
            itemCount: state.employees.length,
            itemBuilder: (context, index) {
              final employee = state.employees[index];
              return EmployeeCard(
                employee: employee,
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmployeeFormScreen(
                        editingEmployee: true,
                        employee: employee,
                      ),
                    ),
                  );
                },
                onDelete: () {
                  _showDeleteConfirmationDialog(context, employee.id);
                },
              );
            },
          );
        },
      ),
    );
  }

  // confirmation dialog for delete employee
  void _showDeleteConfirmationDialog(BuildContext context, String employeeId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Employee'),
        content: const Text('Are you sure you want to delete this employee?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<EmployeeBloc>().add(DeleteEmployeeEvent(employeeId));
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
