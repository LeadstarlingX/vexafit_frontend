import '../../data/models/workout/workout_dto.dart';

abstract class IWorkoutRepository {
  Future<List<WorkoutDTO>> getAllWorkouts();

  Future<WorkoutDTO?> getWorkoutById(int id);

  Future<WorkoutDTO> createWorkout(WorkoutDTO workout);

  Future<WorkoutDTO> updateWorkout(int id, WorkoutDTO workout);

  Future<bool> deleteWorkout(int id);
}
