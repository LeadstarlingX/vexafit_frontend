

import '../models/workout/workout_dto.dart';
import '../models/workout/workout_enum.dart';

abstract class IWorkoutRepository {
  Future<List<WorkoutDTO>> getAllWorkouts({
    String? name,
    String? description,
    WorkoutType? discriminator,
    String? userId,
  });

  Future<void> createWorkout({required String name, required String description});

  Future<void> updateWorkout({required int workoutId, String? name, String? description});

  Future<void> deleteWorkout(int workoutId);

  // --- NEW AND UPDATED METHODS ---
  Future<void> addExerciseToWorkout({
    required int workoutId,
    required int exerciseId,
    required int sets,
    required int reps,
    int? weightKg,
    int? durationSeconds,
  });

  Future<void> updateExerciseInWorkout({
    required int workoutExerciseId, // This is the ID of the link, not the exercise
    required int sets,
    required int reps,
    int? weightKg,
    int? durationSeconds,
  });

  // This now takes the ID of the WorkoutExercise link, as per your new swagger file.
  Future<void> removeExerciseFromWorkout(int workoutExerciseId);
}
