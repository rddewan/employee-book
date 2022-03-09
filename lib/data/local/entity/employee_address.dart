
import 'package:drift/drift.dart';
import 'package:employee_book/data/local/entity/employee_entity.dart';

@DataClassName('emp_address')
class EmployeeAddress extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get employee => integer().references(Employee, #id, onDelete: KeyAction.cascade)();
  TextColumn get street => text()();
  TextColumn get country => text()();  
}