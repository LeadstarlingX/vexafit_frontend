import 'package:vexafit_frontend/data/irepositories/i_workout_repository.dart';
import 'package:vexafit_frontend/data/models/api_response.dart';
import 'package:vexafit_frontend/infrastructure/services/workout_api_service.dart';
import '../../data/models/workout/workout_dto.dart';
import '../../data/models/workout/workout_enum.dart';



class WorkoutRepository implements IWorkoutRepository {
  final WorkoutApiService _workoutApiService;

  WorkoutRepository({required WorkoutApiService workoutApiService})
      : _workoutApiService = workoutApiService;

  @override
  Future<List<WorkoutDTO>> getAllWorkouts({
    String? name,
    String? description,
    WorkoutType? discriminator,
    String? userId,
  }) async {
    try {
      final response = await _workoutApiService.getWorkouts(
        name: name,
        description: description,
        discriminator: discriminator,
        userId: userId,
      );

      final apiResponse = ApiResponse<List<WorkoutDTO>>.fromJson(
        response.data,
            (data) => (data as List<dynamic>)
            .map((item) => WorkoutDTO.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw Exception(apiResponse.message ?? 'Failed to fetch workouts');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> createWorkout({required String name, required String description}) async {
    try {
      await _workoutApiService.createWorkout(name: name, description: description);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateWorkout({required int workoutId, String? name, String? description}) async {
    try {
      await _workoutApiService.updateWorkout(workoutId: workoutId, name: name, description: description);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteWorkout(int workoutId) async {
    try {
      await _workoutApiService.deleteWorkout(workoutId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addExerciseToWorkout({required int workoutId, required int exerciseId}) async {
    try {
      await _workoutApiService.addExerciseToWorkout(workoutId: workoutId, exerciseId: exerciseId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeExerciseFromWorkout({required int workoutId, required int exerciseId}) async {
    try {
      await _workoutApiService.removeExerciseFromWorkout(workoutId: workoutId, exerciseId: exerciseId);
    } catch (e) {
      rethrow;
    }
  }
}
