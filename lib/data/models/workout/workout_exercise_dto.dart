

import '../exercise/exercise_dto.dart';

class WorkoutExerciseDTO {
  // Added the 'Id' field for the link itself.
  final int id;
  final int workoutId;
  final int exerciseId;
  final int sets;
  final int reps;
  final int? weightKg;
  final int? durationSeconds;
  final ExerciseDTO? exercise;

  WorkoutExerciseDTO({
    required this.id,
    required this.workoutId,
    required this.exerciseId,
    required this.sets,
    required this.reps,
    this.weightKg,
    this.durationSeconds,
    this.exercise,
  });

  factory WorkoutExerciseDTO.fromJson(Map<String, dynamic> json) {
    return WorkoutExerciseDTO(
      id: json['Id'] ?? 0,
      workoutId: json['WorkoutId'] ?? 0,
      exerciseId: json['ExerciseId'] ?? 0,
      sets: json['Sets'] ?? 0,
      reps: json['Reps'] ?? 0,
      weightKg: json['WeightKg'],
      durationSeconds: json['DurationSeconds'],
      exercise: json['Exercise'] != null
          ? ExerciseDTO.fromJson(json['Exercise'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workoutId': workoutId,
      'exerciseId': exerciseId,
      'sets': sets,
      'reps': reps,
      'weightKg': weightKg,
      'durationSeconds': durationSeconds,
      'exercise': exercise?.toJson(),
    };
  }
}
