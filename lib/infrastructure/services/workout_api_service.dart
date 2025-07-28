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
    final Map<String, dynamic> queryParameters = {};
    if (name != null) queryParameters['Name'] = name;
    if (description != null) queryParameters['Description'] = description;
    if (discriminator != null) queryParameters['Discriminator'] = discriminator.index;
    if (userId != null) queryParameters['UserId'] = userId;

    return await _dioClient.dio.get(
      ApiRoutes.workoutGetAll,
      queryParameters: queryParameters,
    );
  }

  Future<Response> createWorkout({required String name, required String description}) async {
    return await _dioClient.dio.post(
      ApiRoutes.workoutInsert,
      queryParameters: {'Name': name, 'Description': description},
    );
  }

  Future<Response> updateWorkout({required int workoutId, String? name, String? description}) async {
    final queryParameters = <String, dynamic>{'Id': workoutId};
    if (name != null) queryParameters['Name'] = name;
    if (description != null) queryParameters['Description'] = description;

    return await _dioClient.dio.put(
      ApiRoutes.workoutUpdate,
      queryParameters: queryParameters,
    );
  }

  Future<Response> deleteWorkout(int workoutId) async {
    return await _dioClient.dio.delete(
      ApiRoutes.workoutDelete,
      queryParameters: {'Id': workoutId},
    );
  }

  // --- NEW AND UPDATED METHODS ---
  Future<Response> addExerciseToWorkout({
    required int workoutId,
    required int exerciseId,
    required int sets,
    required int reps,
    int? weightKg,
    int? durationSeconds,
  }) async {
    final queryParameters = <String, dynamic>{
      'workoutId': workoutId,
      'exerciseId': exerciseId,
      'Sets': sets,
      'Reps': reps,
    };
    if (weightKg != null) queryParameters['WeightKg'] = weightKg;
    if (durationSeconds != null) queryParameters['DurationSeconds'] = durationSeconds;

    return await _dioClient.dio.post( // As per swagger
      ApiRoutes.workoutAddToWorkout,
      queryParameters: queryParameters,
    );
  }

  Future<Response> updateExerciseInWorkout({
    required int workoutExerciseId,
    required int sets,
    required int reps,
    int? weightKg,
    int? durationSeconds,
  }) async {
    final queryParameters = <String, dynamic>{
      'WorkoutExerciseId': workoutExerciseId,
      'Sets': sets,
      'Reps': reps,
    };
    if (weightKg != null) queryParameters['WeightKg'] = weightKg;
    if (durationSeconds != null) queryParameters['DurationSeconds'] = durationSeconds;

    return await _dioClient.dio.put(
      ApiRoutes.workoutUpdateExerciseInWorkout,
      queryParameters: queryParameters,
    );
  }

  Future<Response> removeExerciseFromWorkout(int workoutExerciseId) async {
    return await _dioClient.dio.put( // As per swagger
      ApiRoutes.workoutDeleteFromWorkout,
      queryParameters: {'Id': workoutExerciseId},
    );
  }
}
