

import 'package:vexafit_frontend/data/models/workout/workout_exercise_dto.dart';

class WorkoutDTO {
  final int id;
  final String name;
  final String description;
  final String? userId;
  final List<WorkoutExerciseDTO> workoutExercises;

  WorkoutDTO({
    required this.id,
    required this.name,
    required this.description,
    this.userId,
    required this.workoutExercises,
  });

  factory WorkoutDTO.fromJson(Map<String, dynamic> json) {
    var exerciseList = (json['WorkoutExercises'] as List<dynamic>?)
        ?.map((e) => WorkoutExerciseDTO.fromJson(e))
        .toList() ??
        [];

    return WorkoutDTO(
      id: json['Id'] ?? 0,
      name: json['Name'] ?? 'Unnamed Workout',
      description: json['Description'] ?? '',
      userId: json['UserId'],
      workoutExercises: exerciseList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'userId': userId,
      'workoutExercises': workoutExercises.map((e) => e.toJson()).toList(),
    };
  }
}
