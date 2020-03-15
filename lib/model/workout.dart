import 'package:basketball_workouts/model/work_interval.dart';

class Workout{
  final int id;
  final String name;
  final List<WorkInterval> intervals;

  Workout({this.id,this.name, this.intervals});

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'Workout{id: $id, name: $name, intervals: $intervals}';
  }

}