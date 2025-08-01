import 'package:flutter/material.dart';
import 'package:vexafit_frontend/data/irepositories/i_exercise_repository.dart';
import 'package:vexafit_frontend/data/models/exercise/exercise_dto.dart';
import '../../../core/utils/view_state.dart';


class ExerciseViewModel extends ChangeNotifier {
  final IExerciseRepository _exerciseRepository;

  ExerciseViewModel(this._exerciseRepository);

  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  List<ExerciseDTO> _exercises = [];
  List<ExerciseDTO> get exercises => _exercises;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Map<String, List<ExerciseDTO>> _categorizedExercises = {};

  Map<String, List<ExerciseDTO>> get categorizedExercises => _categorizedExercises;

  void _groupExercises() {
    _categorizedExercises = {};
    for (var exercise in _exercises) {
      if (exercise.categories.isEmpty) {
        (_categorizedExercises['Uncategorized'] ??= []).add(exercise);
      } else {
        for (var category in exercise.categories) {
          if (category.name != null) {
            (_categorizedExercises[category.name!] ??= []).add(exercise);
          }
        }
      }
    }
  }

  Future<void> fetchAllExercises({String? name}) async {
    _state = ViewState.loading;
    notifyListeners();

    try {
      _exercises = await _exerciseRepository.getAllExercises(name: name);
      _groupExercises();
      _state = ViewState.success;
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }
}
