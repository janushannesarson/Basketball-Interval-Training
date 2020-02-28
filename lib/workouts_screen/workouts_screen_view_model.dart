import 'package:basketball_workouts/database/workouts_dao.dart';
import 'package:basketball_workouts/model/workout.dart';

class WorkoutsScreenViewModel{
  WorkoutsDao _workoutsDao = WorkoutsDao();

  Future<List<Workout>> getWorkouts(){
    return _workoutsDao.workouts();
  }

  void addWorkout(String name){
    _workoutsDao.insertWorkout(Workout(id: 2,name: name));
  }
}