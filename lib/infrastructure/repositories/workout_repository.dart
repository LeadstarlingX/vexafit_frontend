import 'package:dio/dio.dart';
import 'package:vexafit_frontend/data/irepositories/i_workout_repository.dart';
import '../../core/constants/api_routes.dart';
import '../../core/dio/dio_client.dart';
import '../../data/models/api_response.dart';
import '../../data/models/workout/workout_dto.dart';

class WorkoutRepository implements IWorkoutRepository {
  final DioClient _dioClient;

  WorkoutRepository({required DioClient dioClient}) : _dioClient = dioClient;

  // Get all workouts
  @override
  Future<List<WorkoutDTO>> getAllWorkouts() async {
    try {
      final response = await _dioClient.dio.get(ApiRoutes.workoutGetAll);

      final apiResponse = ApiResponse<List<WorkoutDTO>>.fromJson(
        response.data,
            (data) {
          return (data as List).map((e) {
            print('🧪 Parsing workout item: $e');
            return WorkoutDTO.fromJson(e);
          }).toList();
        },
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw Exception(apiResponse.message ?? 'Failed to fetch workouts');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
    catch (e, stack){
      print("----------------------------------");
      print("Workout Repository");
      print('❌ Exception caught: $e');
      print('🔍 Stack trace:\n$stack');
      print("----------------------------------");
      throw Exception(e);
    }
  }

  // Get workout by ID
  @override
  Future<WorkoutDTO?> getWorkoutById(int id) async {
    try {
      final response = await _dioClient.dio.get(ApiRoutes.workoutGetById(id));

      final apiResponse = ApiResponse<WorkoutDTO>.fromJson(
        response.data,
            (data) => WorkoutDTO.fromJson(data),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw Exception(apiResponse.message ?? 'Failed to fetch workout');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  // Create a new workout
  @override
  Future<WorkoutDTO> createWorkout(WorkoutDTO workout) async {
    try {
      final response = await _dioClient.dio.post(
        ApiRoutes.workoutInsert,
        data: workout.toJson(),
      );

      final apiResponse = ApiResponse<WorkoutDTO>.fromJson(
        response.data,
            (data) => WorkoutDTO.fromJson(data),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw Exception(apiResponse.message ?? 'Failed to create workout');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  // Update an existing workout
  @override
  Future<WorkoutDTO> updateWorkout(int id, WorkoutDTO workout) async {
    try {
      final response = await _dioClient.dio.put(
        ApiRoutes.workoutUpdate(id),
        data: workout.toJson(),
      );

      final apiResponse = ApiResponse<WorkoutDTO>.fromJson(
        response.data,
            (data) => WorkoutDTO.fromJson(data),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw Exception(apiResponse.message ?? 'Failed to update workout');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  // Delete workout by ID
  @override
  Future<bool> deleteWorkout(int id) async {
    try {
      final response = await _dioClient.dio.delete(ApiRoutes.workoutDelete(id));

      final apiResponse = ApiResponse<void>.fromJson(
        response.data,
        null,
      );

      if (apiResponse.isSuccess) {
        return true;
      } else {
        throw Exception(apiResponse.message ?? 'Failed to delete workout');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}
