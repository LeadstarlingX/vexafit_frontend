import 'package:flutter/material.dart';
import 'package:vexafit_frontend/data/irepositories/i_workout_repository.dart';
import '../../../core/utils/view_state.dart';
import '../../../data/models/workout/workout_dto.dart';
import '../../../data/models/workout/workout_enum.dart';
import '../auth/auth_view_model.dart';


class WorkoutViewModel extends ChangeNotifier {
  final IWorkoutRepository _workoutRepository;
  final AuthViewModel _authViewModel;

  WorkoutViewModel(this._workoutRepository, this._authViewModel);

  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  List<WorkoutDTO> _predefinedWorkouts = [];
  List<WorkoutDTO> get predefinedWorkouts => _predefinedWorkouts;

  List<WorkoutDTO> _customWorkouts = [];
  List<WorkoutDTO> get customWorkouts => _customWorkouts;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Called by the ProxyProvider to update the ViewModel with the latest auth state.
  void update() {
    // Fetch workouts only if the user is authenticated and we haven't fetched them yet.
    if (_authViewModel.status == AuthStatus.authenticated && _state == ViewState.idle) {
      fetchWorkouts();
    }
    // If the user logs out, clear the data.
    else if (_authViewModel.status == AuthStatus.unauthenticated && _state != ViewState.idle) {
      _clearWorkouts();
    }
  }


  Future<void> createWorkout({
    required String name,
    required String description,
  }) async {
    // Use a temporary loading state for the action
    _state = ViewState.loading;
    notifyListeners();

    try {
      // Create a DTO object to pass to the repository


      await _workoutRepository.createWorkout(name: name, description: description);

      // After creating, immediately refetch the workouts to update the UI.
      await fetchWorkouts();
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = e.toString();
      // Important: notify listeners even on error to stop the loading indicator
      notifyListeners();
    }
  }

  Future<void> fetchWorkouts() async {
    final userId = _authViewModel.user?.id;
    _state = ViewState.loading;
    notifyListeners();

    try {
      _predefinedWorkouts = await _workoutRepository.getAllWorkouts(
        discriminator: WorkoutType.Predefined,
      );

      if (userId != null) {
        _customWorkouts = await _workoutRepository.getAllWorkouts(
          discriminator: WorkoutType.Custom,
          userId: userId,
        );
      }

      _state = ViewState.success;
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  void _clearWorkouts() {
    _predefinedWorkouts = [];
    _customWorkouts = [];
    _state = ViewState.idle;
    notifyListeners();
  }

  void removeWorkoutFromList(int workoutId) {
    _customWorkouts.removeWhere((workout) => workout.id == workoutId);
    notifyListeners();
  }
}
