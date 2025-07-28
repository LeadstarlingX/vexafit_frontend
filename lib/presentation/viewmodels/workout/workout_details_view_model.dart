import 'package:flutter/material.dart';
import 'package:vexafit_frontend/data/irepositories/i_workout_repository.dart';

import '../../../core/utils/view_state.dart';
import '../../../data/models/exercise/exercise_dto.dart';
import '../../../data/models/workout/workout_dto.dart';

enum DetailsActionState { idle, loading, success, error }

class WorkoutDetailsViewModel extends ChangeNotifier {
  final IWorkoutRepository _workoutRepository;

  WorkoutDetailsViewModel(this._workoutRepository);

  ViewState _state = ViewState.idle;
  DetailsActionState _actionState = DetailsActionState.idle;
  WorkoutDTO? _workout;
  String? _errorMessage;

  ViewState get state => _state;
  DetailsActionState get actionState => _actionState;
  WorkoutDTO? get workout => _workout;
  String? get errorMessage => _errorMessage;

  void setWorkout(WorkoutDTO workout) {
    _workout = workout;
    _state = ViewState.success;
    // We don't notify listeners here to avoid the "setState during build" error.
    // The screen's initState will handle the initial setup.
  }

  /// Refreshes the workout data from the server.
  Future<void> refreshWorkout() async {
    if (_workout == null) return;
    // This assumes a getWorkoutById method exists in your repository.
    // For now, we'll rely on the main list refreshing.
    // A full implementation would fetch the single workout again.
  }

  // --- NEW AND UPDATED METHODS ---

  Future<void> addExerciseToWorkout({
    required ExerciseDTO exerciseToAdd,
    required int sets,
    required int reps,
    int? weightKg,
    int? durationSeconds,
  }) async {
    if (_workout == null) return;

    _actionState = DetailsActionState.loading;
    notifyListeners();

    try {
      await _workoutRepository.addExerciseToWorkout(
        workoutId: _workout!.id,
        exerciseId: exerciseToAdd.id,
        sets: sets,
        reps: reps,
        weightKg: weightKg,
        durationSeconds: durationSeconds,
      );
      _actionState = DetailsActionState.success;
    } catch (e) {
      _actionState = DetailsActionState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> updateExerciseInWorkout({
    required int workoutExerciseId,
    required int sets,
    required int reps,
    int? weightKg,
    int? durationSeconds,
  }) async {
    if (_workout == null) return;
    _actionState = DetailsActionState.loading;
    notifyListeners();

    try {
      await _workoutRepository.updateExerciseInWorkout(
        workoutExerciseId: workoutExerciseId,
        sets: sets,
        reps: reps,
        weightKg: weightKg,
        durationSeconds: durationSeconds,
      );
      _actionState = DetailsActionState.success;
    } catch (e) {
      _actionState = DetailsActionState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> removeExerciseFromWorkout(int workoutExerciseId) async {
    if (_workout == null) return;

    _actionState = DetailsActionState.loading;
    notifyListeners();

    try {
      await _workoutRepository.removeExerciseFromWorkout(workoutExerciseId);
      // For instant UI feedback, remove the exercise from the local list.
      _workout!.workoutExercises.removeWhere((we) => we.id == workoutExerciseId);
      _actionState = DetailsActionState.success;
    } catch (e) {
      _actionState = DetailsActionState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  // ------------------------------------

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

  void resetActionState() {
    _actionState = DetailsActionState.idle;
    _errorMessage = null;
    // We don't notify here to prevent unnecessary rebuilds.
  }
}
