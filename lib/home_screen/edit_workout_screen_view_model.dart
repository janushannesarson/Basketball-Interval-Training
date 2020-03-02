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

  void saveWorkout(){
    for(WorkInterval interval in intervals){
      dao.deleteInterval(interval);
    }

    for(WorkInterval interval in intervals){
      addInterval(interval.description, interval.duration, interval.rest);
    }
  }

  void addInterval(String description, int duration, int rest) {
    WorkInterval interval = new WorkInterval(
        description: description, duration: duration, rest: rest);

    dao.insertInterval(interval, workoutId);
  }

  Future<List<WorkInterval>> getIntervals() {
    return dao.getIntervals(workoutId);
  }

}
