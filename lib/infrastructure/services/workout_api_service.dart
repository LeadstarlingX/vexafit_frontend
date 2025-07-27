import 'package:dio/dio.dart';
import 'package:vexafit_frontend/core/dio/dio_client.dart';
import 'package:vexafit_frontend/core/constants/api_routes.dart';

import '../../data/models/workout/workout_enum.dart';

class WorkoutApiService {
  final DioClient _dioClient;

  WorkoutApiService({required DioClient dioClient}) : _dioClient = dioClient;

  Future<Response> getWorkouts({
    String? name,
    String? description,
    WorkoutType? discriminator,
    String? userId,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {};
      if (name != null) queryParameters['Name'] = name;
      if (description != null) queryParameters['Description'] = description;
      // Convert the enum to its integer index before sending.
      if (discriminator != null) queryParameters['Discriminator'] = discriminator.index;
      if (userId != null) queryParameters['UserId'] = userId;

      return await _dioClient.dio.get(
        ApiRoutes.workoutGetAll,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw Exception('Failed to fetch workouts: ${e.message}');
    }
  }

  Future<Response> createWorkout({required String name, required String description}) async {
    try {
      return await _dioClient.dio.post(
        ApiRoutes.workoutInsert,
        queryParameters: {'Name': name, 'Description': description},
      );
    } on DioException catch (e) {
      throw Exception('Failed to create workout: ${e.message}');
    }
  }

  Future<Response> updateWorkout({required int workoutId, String? name, String? description}) async {
    try {
      final queryParameters = <String, dynamic>{'Id': workoutId};
      if (name != null) queryParameters['Name'] = name;
      if (description != null) queryParameters['Description'] = description;

      return await _dioClient.dio.put(
        ApiRoutes.workoutUpdate(workoutId),
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw Exception('Failed to update workout: ${e.message}');
    }
  }

  Future<Response> deleteWorkout(int workoutId) async {
    try {
      return await _dioClient.dio.delete(
        ApiRoutes.workoutDelete(workoutId),
        queryParameters: {'Id': workoutId},
      );
    } on DioException catch (e) {
      throw Exception('Failed to delete workout: ${e.message}');
    }
  }

  Future<Response> addExerciseToWorkout({required int workoutId, required int exerciseId}) async {
    try {
      return await _dioClient.dio.put(
        ApiRoutes.workoutAddToWorkout,
        queryParameters: {'workoutId': workoutId, 'exerciseId': exerciseId},
      );
    } on DioException catch (e) {
      throw Exception('Failed to add exercise: ${e.message}');
    }
  }

  Future<Response> removeExerciseFromWorkout({required int workoutId, required int exerciseId}) async {
    try {
      return await _dioClient.dio.put(
        ApiRoutes.workoutDeleteFromWorkout,
        queryParameters: {'workoutId': workoutId, 'exerciseId': exerciseId},
      );
    } on DioException catch (e) {
      throw Exception('Failed to remove exercise: ${e.message}');
    }
  }
}
