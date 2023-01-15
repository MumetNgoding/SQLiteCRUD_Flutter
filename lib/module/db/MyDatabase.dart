import 'dart:io';

import 'package:fhe_template/module/view/employee.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class MyDatabase {
  static final MyDatabase _Mydatabase = MyDatabase._privateConstructor();
  MyDatabase._privateConstructor();

  static late Database _database;
  factory MyDatabase() {
    return _Mydatabase;
  }

  final String tableName = 'emp';
  final String columnId = 'id';
  final String columnName = 'name';
  final String columnDesignation = 'desg';
  final String columnIsMale = 'isMale';

  initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();

    String path = '${directory.path}emp.db';

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE $tableName ($columnId INTEGER PRIMARY KEY, $columnName TEXT, $columnDesignation INTEGER, $columnIsMale BOOLEAN )');
      },
    );
  }

//READ
  Future<List<Map<String, Object?>>> getEmpList() async {
    // List<Map<String, Object?>> emps =
    //     await _database.rawQuery('SELECT * FROM $tableName');

    List<Map<String, Object?>> result =
        await _database.query(tableName, orderBy: columnName);
    return result;
  }

  //UPDATE
  Future<int> updateEmp(Employee employee) async {
    // List<Map<String, Object?>> emps =
    //     await _database.rawQuery('SELECT * FROM $tableName');

    int rowUpdated = await _database.update(tableName, employee.toMap(),
        where: '$columnId=?', whereArgs: [employee.empId]);
    return rowUpdated;
  }

//INSERT
  Future<int> insertEmp(Employee employee) async {
    // List<Map<String, Object?>> emps =
    //     await _database.rawQuery('SELECT * FROM $tableName');

    int rowInserted = await _database.insert(tableName, employee.toMap());
    return rowInserted;
  }

  //DELETE
  Future<int> deleteEmp(Employee employee) async {
    // List<Map<String, Object?>> emps =
    //     await _database.rawQuery('SELECT * FROM $tableName');

    int rowDeleted = await _database
        .delete(tableName, where: '$columnId=?', whereArgs: [employee.empId]);
    return rowDeleted;
  }

  //COUNT
  Future<int> countEmp() async {
    List<Map<String, Object?>> result =
        await _database.rawQuery('SELECT COUNT(*) FROM $tableName');
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count;
  }

  // getApplicationDocumentsDirectory() {}
}
