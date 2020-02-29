class Workout{
  final int id;
  final String name;

  Workout({this.id,this.name});

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'name': name,
    };
  }
}