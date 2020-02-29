import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseRepository {
  static final Future<Database> workoutsDatabase = getDatabasesPath().then((String path) {
    return openDatabase(
      join(path, 'workouts_database.db'),
      onCreate: (db, version) {
        return db
            .execute("CREATE TABLE workouts(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)");
      },
      version: 1,
    );
  });
  static final Future<Database> intervalsDatabase = getDatabasesPath().then((String path) {
    return openDatabase(
      join(path, 'intervals_database.db'),
      onCreate: (db, version) {
        return db
            .execute("CREATE TABLE intervals(id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "description TEXT,"
            "duration INTEGER,"
            "rest INTEGER,"
            "workoutid INTEGER,"
            "FOREIGN KEY(workoutid) REFERENCES workouts(id) ON DELETE CASCADE)");
      },
      version: 1,
    );
  });

}
