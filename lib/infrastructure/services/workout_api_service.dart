import 'package:dio/dio.dart';
import 'package:vexafit_frontend/core/dio/dio_client.dart';
import 'package:vexafit_frontend/core/constants/api_routes.dart';

import '../../data/models/workout/workout_enum.dart';

class WorkoutApiService {
  final DioClient _dioClient;

  WorkoutApiService({required DioClient dioClient}) : _dioClient = dioClient;

  /// Fetches the raw list of workouts from the /api/Workout/GetAll endpoint.
  Future<Response> getWorkouts({
    String? name,
    String? description,
    WorkoutType? discriminator,
    String? userId,
  }) async {
    try {
      // Build the query parameters, only including non-null values.
      final Map<String, dynamic> queryParameters = {};
      if (name != null) {
        queryParameters['Name'] = name;
      }
      if (description != null) {
        queryParameters['Description'] = description;
      }
      if (discriminator != null) {
        queryParameters['Discriminator'] = discriminator;
      }
      if (userId != null) {
        queryParameters['UserId'] = userId;
      }

      final response = await _dioClient.dio.get(
        ApiRoutes.workoutGetAll,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      // Re-throw a more specific exception to be handled by the repository.
      throw Exception('Failed to fetch workouts: ${e.message}');
    }
  }
}
