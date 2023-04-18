import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';

class DBhelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'training_session_results1.db'),
        onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE history_table(dateTime TEXT  ,exercise TEXT )');
      await db.execute(
          'CREATE TABLE set_time_table(dateTime TEXT  ,name TEXT, setNumber INTEGER, time TEXT )');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final sqlDb = await DBhelper.database();
    sqlDb.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final sqlDb = await DBhelper.database();
    return sqlDb.query(table);
  }
}
