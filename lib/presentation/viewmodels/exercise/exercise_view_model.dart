import 'package:flutter/material.dart';
import 'package:vexafit_frontend/data/irepositories/i_exercise_repository.dart';
import 'package:vexafit_frontend/data/models/exercise/exercise_dto.dart';

// We can reuse this enum for different view states.
enum ViewState { idle, loading, success, error }

class ExerciseViewModel extends ChangeNotifier {
  final IExerciseRepository _exerciseRepository;

  ExerciseViewModel(this._exerciseRepository);

  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  List<ExerciseDTO> _exercises = [];
  List<ExerciseDTO> get exercises => _exercises;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Fetches all exercises from the repository.
  Future<void> fetchAllExercises({String? name}) async {
    _state = ViewState.loading;
    notifyListeners();

    try {
      _exercises = await _exerciseRepository.getAllExercises(name: name);
      _state = ViewState.success;
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }
}
