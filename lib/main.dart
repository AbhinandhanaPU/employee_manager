import 'package:employees/core/database/database_helper.dart';
import 'package:employees/core/di/injection.dart';
import 'package:employees/features/employees/presentaion/bloc/employee_bloc.dart';
import 'package:employees/features/employees/presentaion/screens/employes_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseHelper.init();
  await setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EmployeeBloc>()..add(LoadEmployeesEvent()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Management System',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const EmployesMainScreen(),
      ),
    );
  }
}
