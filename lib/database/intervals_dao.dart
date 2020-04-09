import 'package:basketball_workouts/model/work_interval.dart';
import 'package:sqflite/sqlite_api.dart';

import 'database_repository.dart';

class IntervalsDao {
  Future<void> insertInterval(WorkInterval interval, int workoutId) async {
    // Get a reference to the database.
    final Database db = await DataBaseRepository.intervalsDatabase;

    await db.insert(
      'intervals',
      interval.toMap(workoutId),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteInterval(WorkInterval interval) async {
    final Database db = await DataBaseRepository.intervalsDatabase;

    await db.delete('intervals', where: "id = ?", whereArgs: [interval.id]);
  }

  Future<void> updateInterval(WorkInterval interval) async {
    final Database db = await DataBaseRepository.intervalsDatabase;

    await db.rawUpdate(
        "UPDATE intervals SET description = ?, duration = ?, rest = ? WHERE id = ?",
        [interval.description, interval.duration, interval.rest, interval.id]);
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
          rest: maps[i]['rest']);
    });
  }
}
