import 'package:flutter/material.dart';
import 'package:vexafit_frontend/data/irepositories/i_workout_repository.dart';

import '../../../core/utils/view_state.dart';
import '../../../data/models/workout/workout_dto.dart';

// A separate state for actions like deleting to avoid disrupting the main view state.
enum DetailsActionState { idle, loading, success, error }

class WorkoutDetailsViewModel extends ChangeNotifier {
  final IWorkoutRepository _workoutRepository;

  WorkoutDetailsViewModel(this._workoutRepository);

  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  DetailsActionState _actionState = DetailsActionState.idle;
  DetailsActionState get actionState => _actionState;

  WorkoutDTO? _workout;
  WorkoutDTO? get workout => _workout;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void setWorkout(WorkoutDTO workout) {
    _workout = workout;
    _state = ViewState.success;
    notifyListeners();
  }

  /// Deletes the current workout.
  Future<void> deleteWorkout() async {
    if (_workout == null) return;

    _actionState = DetailsActionState.loading;
    notifyListeners();

    try {
      await _workoutRepository.deleteWorkout(_workout!.id);
      _actionState = DetailsActionState.success;
    } catch (e) {
      _actionState = DetailsActionState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  /// Resets the action state after an operation is complete.
  void resetActionState() {
    _actionState = DetailsActionState.idle;
    _errorMessage = null;
  }
}
