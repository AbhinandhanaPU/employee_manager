import 'package:hive_flutter/hive_flutter.dart';

class DatabaseHelper {
  static const String _employeesTable = "employees";

  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isBoxOpen(_employeesTable)) {
      await Hive.openBox(_employeesTable);
    }
  }

  static Box getEmployeesBox() {
    return Hive.box(_employeesTable);
  }
}
