import 'package:flutter/material.dart';
import 'package:vexafit_frontend/data/irepositories/i_workout_repository.dart';
import 'package:vexafit_frontend/data/models/workout/workout_enum.dart';
import '../../../data/models/workout/workout_dto.dart';

enum ViewState { idle, loading, success, error }

class WorkoutViewModel extends ChangeNotifier {
  final IWorkoutRepository _workoutRepository;

  WorkoutViewModel(this._workoutRepository);

  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  List<WorkoutDTO> _predefinedWorkouts = [];
  List<WorkoutDTO> get predefinedWorkouts => _predefinedWorkouts;

  List<WorkoutDTO> _customWorkouts = [];
  List<WorkoutDTO> get customWorkouts => _customWorkouts;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchWorkouts(String? userId) async {
    _state = ViewState.loading;
    notifyListeners();

    try {
      // Fetch predefined workouts (assuming discriminator 'Predefined' or similar)
      // Note: You might need to adjust the discriminator string based on your API
      _predefinedWorkouts = await _workoutRepository.getAllWorkouts(discriminator: WorkoutType.Predefined);

      // Fetch custom workouts for the logged-in user
      if (userId != null) {
        _customWorkouts = await _workoutRepository.getAllWorkouts(userId: userId);
      }

      _state = ViewState.success;
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }
}
