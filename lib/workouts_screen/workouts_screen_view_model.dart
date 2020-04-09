import 'package:basketball_workouts/database/workouts_dao.dart';
import 'package:basketball_workouts/model/workout.dart';

class WorkoutsScreenViewModel{
  WorkoutsDao _workoutsDao = WorkoutsDao();
  Future<List<Workout>> workouts;

  WorkoutsScreenViewModel(){
    getWorkouts();
  }

  void getWorkouts(){
    workouts = _workoutsDao.workouts();
  }

  void addWorkout(String name){
    _workoutsDao.insertWorkout(Workout(name: name));
  }

  void deleteWorkout(int id){
    _workoutsDao.deleteWorkout(id);
  }

  int workoutDurationInSeconds(Workout workout){
    int sum = 0;

    for(var interval in workout.intervals){
      sum += interval.duration + interval.rest;
    }

    return sum;
  }


}