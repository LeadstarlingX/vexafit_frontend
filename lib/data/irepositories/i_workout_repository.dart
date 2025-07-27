import '../models/workout/workout_dto.dart';
import '../models/workout/workout_enum.dart';

abstract class IWorkoutRepository {
  Future<List<WorkoutDTO>> getAllWorkouts({
    String? name,
    String? description,
    WorkoutType? discriminator,
    String? userId,
  });

  // Corrected to take simple parameters, not a full object.
  Future<void> createWorkout({required String name, required String description});

  // Corrected to take simple parameters.
  Future<void> updateWorkout({required int workoutId, String? name, String? description});

  Future<void> deleteWorkout(int workoutId);

  Future<void> addExerciseToWorkout({required int workoutId, required int exerciseId});

  Future<void> removeExerciseFromWorkout({required int workoutId, required int exerciseId});
}
