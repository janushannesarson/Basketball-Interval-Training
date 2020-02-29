import 'package:basketball_workouts/model/work_interval.dart';
import 'package:sqflite/sqlite_api.dart';

import 'database_repository.dart';

class IntervalsDao {
  Future<void> insertInterval(WorkInterval interval, int workoutId) async {
    // Get a reference to the database.
    final Database db = await DataBaseRepository.intervalsDatabase;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'intervals',
      interval.toMap(workoutId),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<WorkInterval>> getIntervals(int workoutId) async {
    final Database db = await DataBaseRepository.intervalsDatabase;

    final List<Map<String, dynamic>> maps = await db
        .query('intervals', where: 'workoutid = ?', whereArgs: [workoutId]);

    return List.generate(maps.length, (i) {
      return WorkInterval(
        id: maps[i]['id'],
        description: maps[i]['description'],
        duration: maps[i]['duration'],
        rest: maps[i]['rest']
      );
    });
  }
}
