import '../models/workout/workout_dto.dart';
import '../models/workout/workout_enum.dart';

abstract class IWorkoutRepository {
  Future<List<WorkoutDTO>> getAllWorkouts({
    String? name,
    String? description,
    WorkoutType? discriminator,
    String? userId,
  });

  Future<WorkoutDTO> getWorkoutById(int workoutId);

  Future<void> createWorkout({required String name, required String description});

  Future<void> updateWorkout({required int workoutId, String? name, String? description});

  Future<void> deleteWorkout(int workoutId);


  Future<void> addExerciseToWorkout({
    required int workoutId,
    required int exerciseId,
    required int sets,
    required int reps,
    int? weightKg,
    int? durationSeconds,
  });

  Future<void> updateExerciseInWorkout({
    required int workoutExerciseId,
    required int sets,
    required int reps,
    int? weightKg,
    int? durationSeconds,
  });

  Future<void> removeExerciseFromWorkout(int workoutExerciseId);
}
