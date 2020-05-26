import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseRepository {
  static final Future<Database> workoutsDatabase = getDatabasesPath().then((
      String path) {
    return openDatabase(
      join(path, 'workouts_database.db'),
      onCreate: (db, version) {
        db
            .execute(
            "CREATE TABLE workouts(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT UNIQUE NOT NULL)");
        db.execute(
            "INSERT INTO workouts (name) VALUES"
                "('Example shooting workout'),"
                "('Example dribbling workout')");
      },
      version: 1,
    );
  });
  static final Future<Database> intervalsDatabase = getDatabasesPath().then((
      String path) {
    return openDatabase(
      join(path, 'intervals_database.db'),
      onCreate: (db, version) {
        db
            .execute(
            "CREATE TABLE intervals(id INTEGER PRIMARY KEY AUTOINCREMENT,"
                "description TEXT,"
                "duration INTEGER,"
                "rest INTEGER,"
                "workoutid INTEGER,"
                "FOREIGN KEY(workoutid) REFERENCES workouts(id) ON DELETE CASCADE)");
        db.execute(
            "INSERT INTO intervals (description, duration, rest, workoutid)" +
                "VALUES"
                    "('Power layup', 60, 30, 1),"
                    "('Underhand layup', 60, 30, 1),"
                    "('Reverse layup', 60, 30, 1),"
                    "('Floater', 60, 30, 1),"
                    "('Short corner jumpshot', 60, 30, 1),"
                    "('Highpost jumpshot', 60, 30, 1),"
                    "('Floater', 60, 30, 1),"
                    "('Turn-around jumpshot', 60, 30, 1),"
                    "('Three pointer', 60, 30, 1),"

                    "('Power dribble', 45, 15, 2),"
                    "('In-and-out', 45, 15, 2),"
                    "('Crossover', 45, 15, 2),"
                    "('In-and-out crossover', 45, 15, 2),"
                    "('V dribble', 45, 15, 2),"
                    "('Between the legs behind the back', 45, 15, 2),"
                    "('In-and-out power dribble', 45, 15, 2)");
      },
      version: 1,
    );
  });

}
