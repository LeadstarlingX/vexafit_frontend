
import '../exercise/exercise_dto.dart';

class WorkoutDTO {
  final int id;
  final String name;
  final String description;
  final String? userId;
  final List<ExerciseDTO> exercises;

  WorkoutDTO({
    required this.id,
    required this.name,
    required this.description,
    this.userId,
    required this.exercises,
  });

  factory WorkoutDTO.fromJson(Map<String, dynamic> json) {
    var exerciseList = (json['Exercises'] as List<dynamic>?)
        ?.map((e) => ExerciseDTO.fromJson(e))
        .toList() ??
        [];

    return WorkoutDTO(
      // Using PascalCase for all response fields
      id: json['Id'] ?? 0,
      name: json['Name'] ?? 'Unnamed Workout',
      description: json['Description'] ?? '',
      userId: json['UserId'],
      exercises: exerciseList,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'userId': userId,
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }

}
