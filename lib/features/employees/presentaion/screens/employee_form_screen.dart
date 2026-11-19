import 'package:employees/features/employees/domain/entities/employee_entity.dart';
import 'package:employees/features/employees/presentaion/bloc/employee_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeFormScreen extends StatefulWidget {
  final bool editingEmployee;
  final EmployeeEntity? employee;

  const EmployeeFormScreen({
    super.key,
    required this.editingEmployee,
    this.employee,
  });

  @override
  State<EmployeeFormScreen> createState() => _EmployeeFormScreenState();
}

class _EmployeeFormScreenState extends State<EmployeeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();

  bool _isSubmitting = false;

  @override
  initState() {
    super.initState();
    if (widget.editingEmployee && widget.employee != null) {
      _nameController.text = widget.employee!.name;
      _emailController.text = widget.employee!.email;
      _phoneController.text = widget.employee!.phone;
      _designationController.text = widget.employee!.designation;
    }
  }

  @override
  dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _designationController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final employee = EmployeeEntity(
      id: widget.editingEmployee
          ? widget.employee!.id
          : DateTime.now().microsecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      designation: _designationController.text.trim(),
    );

    if (widget.editingEmployee) {
      context.read<EmployeeBloc>().add(UpdateEmployeeEvent(employee));
    } else {
      context.read<EmployeeBloc>().add(AddEmployeeEvent(employee));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeBloc, EmployeeState>(
      listenWhen: (previous, current) =>
          current.status != previous.status ||
          current.message != previous.message,
      listener: (context, state) {
        if (state.status == EmployeeStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message ?? 'Operation successful')),
          );
          Navigator.pop(context);
        } else if (state.status == EmployeeStatus.failure) {
          setState(() {
            _isSubmitting = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? 'Something went wrong, Try again'),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.editingEmployee ? 'Edit Employee' : 'Add Employee',
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 15,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateRequired,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }

                    if (!RegExp(
                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                    ).hasMatch(value.trim())) {
                      return 'Enter a valid email';
                    }

                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateRequired,
                ),
                TextFormField(
                  controller: _designationController,
                  decoration: InputDecoration(
                    labelText: 'Designation',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateRequired,
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitForm,
                    child: _isSubmitting
                        ? const CircularProgressIndicator()
                        : Text(
                            widget.editingEmployee
                                ? 'Update Employee'
                                : 'Add Employee',
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
