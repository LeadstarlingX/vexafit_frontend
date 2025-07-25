import '../../data/models/workout/workout_dto.dart';
import '../models/workout/workout_enum.dart';

abstract class IWorkoutRepository {
  Future<List<WorkoutDTO>> getAllWorkouts({
    String? name,
    String? description,
    WorkoutType? discriminator,
    String? userId,
  });

  Future<WorkoutDTO?> getWorkoutById(int id);

  Future<WorkoutDTO> createWorkout(WorkoutDTO workout);

  Future<WorkoutDTO> updateWorkout(int id, WorkoutDTO workout);

  Future<bool> deleteWorkout(int id);
}
