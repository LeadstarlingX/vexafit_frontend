import 'package:vexafit_frontend/data/models/exercise/exercise_dto.dart';

abstract class IExerciseRepository {
  /// Fetches a list of all exercises from the API.
  Future<List<ExerciseDTO>> getAllExercises({String? name, String? description});
}
