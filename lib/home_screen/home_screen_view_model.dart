import 'package:basketball_workouts/model/work_interval.dart';

class HomeScreenViewModel {
  List<WorkInterval> intervals = new List();

  void onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final x = intervals.removeAt(oldIndex);
    intervals.insert(newIndex, x);
  }

  void addInterval(String exercise, int duration, int rest){
    intervals.add(WorkInterval(title: exercise, duration: duration, rest: rest));
  }
  
}
