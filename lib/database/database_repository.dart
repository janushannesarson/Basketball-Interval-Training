import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseRepository {
  static final Future<Database> database = getDatabasesPath().then((String path) {
    return openDatabase(
      join(path, 'workouts_database.db'),
      onCreate: (db, version) {
        return db
            .execute("CREATE TABLE workouts(id INTEGER PRIMARY KEY, name TEXT)");
      },
      version: 1,
    );
  });
}
