import 'package:flutter/material.dart';

import '../../../data/irepositories/i_workout_repository.dart';
import '../../../data/models/workout/workout_dto.dart';

class WorkoutViewModel extends ChangeNotifier {
  final IWorkoutRepository _workoutRepository;

  WorkoutViewModel(this._workoutRepository);

  List<WorkoutDTO> _workouts = [];
  List<WorkoutDTO> get workouts => _workouts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchWorkouts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _workouts = await _workoutRepository.getAllWorkouts();
    } catch (e) {

      // print("----------------------------------");
      // print("workout view model");
      // print('❌ Exception caught: $e');
      // print('🔍 Stack trace:\n$stack');
      // print("----------------------------------");

      _error = e.toString();
      _workouts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
