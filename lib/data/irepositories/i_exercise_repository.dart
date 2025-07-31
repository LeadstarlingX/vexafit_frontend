import 'package:vexafit_frontend/data/models/exercise/exercise_dto.dart';

abstract class IExerciseRepository {
  Future<List<ExerciseDTO>> getAllExercises({String? name, String? description});
}
