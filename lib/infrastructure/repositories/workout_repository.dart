import 'package:vexafit_frontend/data/irepositories/i_workout_repository.dart';
import 'package:vexafit_frontend/infrastructure/services/workout_api_service.dart';

import '../../data/models/api_response.dart';
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

      // The actual list of workouts is nested inside the 'data' key.
      final apiResponse = ApiResponse<List<WorkoutDTO>>.fromJson(
        response.data,
            (data) => (data as List<dynamic>)
            .map((item) => WorkoutDTO.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

      // 3. Check if the API call was successful and return the data.
      if (apiResponse.isSuccess && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        // If the API call failed, throw an exception with the server's message.
        throw Exception(apiResponse.message ?? 'Failed to fetch workouts');
      }
    } catch (e) {
      // Propagate the error to be handled by the ViewModel.
      rethrow;
    }
  }

  @override
  Future<WorkoutDTO> createWorkout(WorkoutDTO workout) {
    // TODO: implement createWorkout
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteWorkout(int id) {
    // TODO: implement deleteWorkout
    throw UnimplementedError();
  }

  @override
  Future<WorkoutDTO?> getWorkoutById(int id) {
    // TODO: implement getWorkoutById
    throw UnimplementedError();
  }

  @override
  Future<WorkoutDTO> updateWorkout(int id, WorkoutDTO workout) {
    // TODO: implement updateWorkout
    throw UnimplementedError();
  }
}
