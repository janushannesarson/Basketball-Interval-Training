import 'dart:developer';

import 'package:basketball_workouts/database/intervals_dao.dart';
import 'package:basketball_workouts/model/work_interval.dart';

class EditWorkoutScreenViewModel {
  List<WorkInterval> intervals = new List();
  IntervalsDao dao = IntervalsDao();
  final int workoutId;
  bool workoutSaved = true;

  EditWorkoutScreenViewModel({this.workoutId});

  void onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final x = intervals.removeAt(oldIndex);
    intervals.insert(newIndex, x);
  }

  Future saveWorkout() async {
    for (WorkInterval interval in intervals) {
      dao.deleteInterval(interval);
    }

    for (WorkInterval interval in intervals) {
      addInterval(interval.description, interval.duration, interval.rest);
    }
  }

  void addInterval(String description, int duration, int rest) {
    WorkInterval interval = new WorkInterval(
        description: description, duration: duration, rest: rest);

    dao.insertInterval(interval, workoutId);
  }

  void deleteInterval(WorkInterval interval) {
    dao.deleteInterval(interval);
    intervals.remove(interval);
  }

  Future<List<WorkInterval>> getIntervals() {
    return dao.getIntervals(workoutId);
  }

  void updateInterval(int intervalId, String exercise, int duration, int rest) {

    print("$intervalId, $exercise, $duration, $rest");

    WorkInterval interval = new WorkInterval(
        id: intervalId, description: exercise, duration: duration, rest: rest);

    dao.updateInterval(interval);
  }
}
