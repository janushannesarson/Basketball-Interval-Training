import 'dart:async';
import 'dart:io';

import 'package:basketball_workouts/database/database_repository.dart';
import 'package:basketball_workouts/model/workout.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class WorkoutsDao {
  Future<void> insertWorkout(Workout workout) async {
    // Get a reference to the database.
    final Database db = await DataBaseRepository.workoutsDatabase;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'workouts',
      workout.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Workout>> workouts() async {
    final Database db = await DataBaseRepository.workoutsDatabase;

    final List<Map<String, dynamic>> maps = await db.query('workouts');

    return List.generate(maps.length, (i) {
      return Workout(
        id: maps[i]['id'],
        name: maps[i]['name'],
      );
    });
  }

  void deleteWorkout(int id) async {
    final Database db = await DataBaseRepository.workoutsDatabase;
    await db.delete('workouts', where: "id = ?", whereArgs: [id]);
  }
}
