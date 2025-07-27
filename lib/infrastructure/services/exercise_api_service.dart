import 'package:dio/dio.dart';
import 'package:vexafit_frontend/core/dio/dio_client.dart';
import 'package:vexafit_frontend/core/constants/api_routes.dart';

class ExerciseApiService {
  final DioClient _dioClient;

  ExerciseApiService({required DioClient dioClient}) : _dioClient = dioClient;

  /// Fetches the raw list of exercises from the API.
  Future<Response> getExercises({String? name, String? description}) async {
    try {
      final Map<String, dynamic> queryParameters = {};
      if (name != null) queryParameters['Name'] = name;
      if (description != null) queryParameters['Description'] = description;

      final response = await _dioClient.dio.get(
        ApiRoutes.exerciseGetAll,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to fetch exercises: ${e.message}');
    }
  }
}
