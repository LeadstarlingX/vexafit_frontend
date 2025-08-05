import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vexafit_frontend/presentation/widgets/view_state_handler.dart';
import '../../../core/utils/dialog_helper.dart';
import '../../../core/utils/view_state.dart';
import '../../../data/models/exercise/exercise_dto.dart';
import '../../../data/models/workout/workout_dto.dart';
import '../../../data/models/workout/workout_exercise_dto.dart';
import '../../viewmodels/auth/auth_view_model.dart';
import '../../viewmodels/workout/workout_details_view_model.dart';
import '../../viewmodels/workout/workout_view_model.dart';
import '../../widgets/workout_details_view.dart';


class WorkoutDetailsScreen extends StatefulWidget {
  final WorkoutDTO workout;

  const WorkoutDetailsScreen({super.key, required this.workout});

  @override
  State<WorkoutDetailsScreen> createState() => _WorkoutDetailsScreenState();
}

class _WorkoutDetailsScreenState extends State<WorkoutDetailsScreen> {
  late final WorkoutDetailsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<WorkoutDetailsViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _viewModel.fetchWorkoutById(widget.workout.id);
      }
    });

    _viewModel.addListener(_onActionStateChanged);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onActionStateChanged);
    super.dispose();
  }

  void _onActionStateChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (_viewModel.actionState == DetailsActionState.success) {
        if (_viewModel.workout == null) {
          context.pop();
        }
        context.read<WorkoutViewModel>().fetchWorkouts();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Action successful!'), backgroundColor: Colors.green),
        );
      } else if (_viewModel.actionState == DetailsActionState.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_viewModel.errorMessage ?? 'An error occurred.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
      _viewModel.resetActionState();
    });
  }

  Future<void> _navigateAndAddExercise() async {
    final selectedExercise = await context.push<ExerciseDTO>('/home/select-exercise');

    if (selectedExercise != null && mounted) {
      final details = await DialogHelpers.showAddExerciseDetails(context, exercise: selectedExercise);

      if (details != null && mounted) {
        await _viewModel.addExerciseToWorkout(
          exerciseToAdd: selectedExercise,
          sets: details['sets']!,
          reps: details['reps']!,
          weightKg: details['weightKg'],
          durationSeconds: details['durationSeconds'],
        );
        await _viewModel.refreshWorkout();
      }
    }
  }

  Future<void> _editExercise(WorkoutExerciseDTO workoutExercise) async {
    final details = await DialogHelpers.showEditExerciseDetails(context, workoutExercise: workoutExercise);

    if (details != null && mounted) {
      await _viewModel.updateExerciseInWorkout(
        workoutExerciseId: workoutExercise.id,
        sets: details['sets']!,
        reps: details['reps']!,
        weightKg: details['weightKg'],
        durationSeconds: details['durationSeconds'],
      );
      await _viewModel.refreshWorkout();
    }
  }

  Future<void> _editWorkout() async {
    final workout = _viewModel.workout;
    if (workout == null) return;

    final details = await DialogHelpers.showEditWorkoutDetails(context, workout: workout);

    if (details != null && mounted) {
      await _viewModel.updateWorkoutDetails(
        name: details['name']!,
        description: details['description']!,
      );
      await _viewModel.refreshWorkout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authUser = context.watch<AuthViewModel>().user;
    final viewModel = context.watch<WorkoutDetailsViewModel>();

    // This null check is important for the initial build before the view model has a workout.
    if (viewModel.workout == null && viewModel.state != ViewState.loading) {
      // If the workout is null and we are not loading, it might be an error or post-deletion state.
      // A loading indicator or an empty scaffold is appropriate.
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        // Use the workout from the view model, but have a fallback.
        title: Text(viewModel.workout?.name ?? widget.workout.name),
        actions: [
          // We can only determine if it's a custom workout if the workout object exists.
          if (viewModel.workout != null && viewModel.workout!.userId == authUser?.id) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _editWorkout,
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
              onPressed: () => DialogHelpers.showDeleteConfirmation(
                context,
                onConfirm: _viewModel.deleteWorkout,
              ),
            ),
          ]
        ],
      ),
      body: ViewStateHandler(
        viewState: viewModel.state,
        errorMessage: viewModel.errorMessage,
        successBuilder: (context) {
          final workout = viewModel.workout!;
          final isCustomWorkout = workout.userId == authUser?.id;
          return WorkoutDetailsView(
            workout: workout,
            isCustomWorkout: isCustomWorkout,
            onEditExercise: _editExercise,
            onRemoveExercise: _viewModel.removeExerciseFromWorkout,
          );
        },
      ),
      floatingActionButton: (viewModel.workout != null && viewModel.workout!.userId == authUser?.id)
          ? FloatingActionButton(
        onPressed: _navigateAndAddExercise,
        child: const Icon(Icons.add),
      )
          : null,
    );
  }
}
