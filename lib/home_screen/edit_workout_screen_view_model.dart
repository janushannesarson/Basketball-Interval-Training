import 'package:basketball_workouts/database/intervals_dao.dart';
import 'package:basketball_workouts/model/work_interval.dart';

class EditWorkoutScreenViewModel {
  List<WorkInterval> intervals = new List();
  IntervalsDao dao = IntervalsDao();

  void onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final x = intervals.removeAt(oldIndex);
    intervals.insert(newIndex, x);
  }

  void addInterval(String description, int duration, int rest, int workoutId) {
    WorkInterval interval = new WorkInterval(
        description: description, duration: duration, rest: rest);

    dao.insertInterval(interval, workoutId);
  }

  Future<List<WorkInterval>> getIntervals(int workoutId) {
    return dao.getIntervals(workoutId);
  }

}
