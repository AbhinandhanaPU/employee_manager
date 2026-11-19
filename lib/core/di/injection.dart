import 'package:employees/features/employees/data/repositories/employee_repository_impl.dart';
import 'package:employees/features/employees/domain/repositories/employee_repository.dart';
import 'package:employees/features/employees/presentaion/bloc/employee_bloc.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerLazySingleton<EmployeeRepository>(
    () => EmployeeRepositoryImpl(),
  );
  getIt.registerFactory<EmployeeBloc>(
    () => EmployeeBloc(getIt<EmployeeRepository>()),
  );
}
