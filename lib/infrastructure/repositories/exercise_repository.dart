import 'package:vexafit_frontend/data/irepositories/i_exercise_repository.dart';
import 'package:vexafit_frontend/data/models/api_response.dart';
import 'package:vexafit_frontend/data/models/exercise/exercise_dto.dart';
import 'package:vexafit_frontend/infrastructure/services/exercise_api_service.dart';

class ExerciseRepository implements IExerciseRepository {
  final ExerciseApiService _exerciseApiService;

  ExerciseRepository({required ExerciseApiService exerciseApiService})
      : _exerciseApiService = exerciseApiService;

  @override
  Future<List<ExerciseDTO>> getAllExercises({String? name, String? description}) async {
    try {
      final response = await _exerciseApiService.getExercises(
        name: name,
        description: description,
      );

      final apiResponse = ApiResponse<List<ExerciseDTO>>.fromJson(
        response.data,
            (data) => (data as List<dynamic>)
            .map((item) => ExerciseDTO.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw Exception(apiResponse.message ?? 'Failed to fetch exercises');
      }
    } catch (e) {
      rethrow;
    }
  }
}
