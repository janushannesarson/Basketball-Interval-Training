class WorkInterval{
  int id;
  String description;
  int duration;
  int rest;

  WorkInterval({this.id, this.description, this.duration, this.rest});

  int get totalSeconds => this.duration + this.rest;

  Map<String, dynamic> toMap(int workoutId){
    return {
      'id': id,
      'description': description,
      'duration': duration,
      'rest': rest,
      'workoutid': workoutId
    };
  }

  @override
  String toString() {
    return 'WorkInterval{id: $id, description: $description, duration: $duration, rest: $rest}';
  }


}