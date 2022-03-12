import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:employee_book/data/local/entity/employee_address.dart';
import 'package:employee_book/data/local/entity/employee_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

part 'app_db.g.dart';

LazyDatabase _openConnection(){
  return LazyDatabase(() async {

    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'employee.sqlite'));

    return NativeDatabase(file);
  });
}


@DriftDatabase(tables: [Employee, EmployeeAddress])
class AppDb extends _$AppDb {

  AppDb() : super(_openConnection());

  @override 
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      debugPrint('beforeOpen');
      await customStatement('PRAGMA foreign_keys = ON');
    },
    onUpgrade: (m, from, to)  async {
      
      if (from == 1) {
        await m.addColumn(employee, employee.isActive);
      }
      if (from == 3) {       
        await m.createTable(employeeAddress);
        debugPrint('migration from 3 - 4');
      }
    },

  );

  // Get the list of employee
  Future<List<EmployeeData>> getEmployees() async {
    return await select(employee).get();
  }

  Stream<List<EmployeeData>> getEmployeeStream() {
    return select(employee).watch();
  }

  Future<EmployeeData>getEmployee(int id) async {
    return await (select(employee)..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  Future<bool> updateEmployee(EmployeeCompanion entity) async {
    return await update(employee).replace(entity);
  }

  Future<int> insertEmployee(EmployeeCompanion entity) async {
    return await into(employee).insert(entity);
  }

  Future<int> deleteEmployee(int id) async {
    return await (delete(employee)..where((tbl) => tbl.id.equals(id))).go();
  }

  // insert the emp address
  Future<int> insertAddress(EmployeeAddressCompanion entity) async {
    return await into(employeeAddress).insert(entity);
  }

  // get the emp address by emp id
  Stream<List<emp_address>> getEmployeeAddress(int id) {
    return (select(employeeAddress)..where((tbl) => tbl.employee.equals(id))).watch();
  }

  // get the list of address
  Stream<List<emp_address>> getEmployeeAddressList() {
    return select(employeeAddress).watch();
  }

  
}