


import 'package:drift/drift.dart';

class Employee extends Table{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userName => text().named('user_name')();
  TextColumn get firstName => text().named('first_name')();
  TextColumn get lastName => text().named('last_name')();
  DateTimeColumn get dateOfBirth => dateTime().named('date_of_birth')();
  IntColumn get isActive => integer().named('is_active').nullable()();
}