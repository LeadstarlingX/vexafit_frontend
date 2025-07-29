import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vexafit_frontend/presentation/widgets/loading_indicator.dart';

import '../../../core/utils/view_state.dart';
import '../../../data/models/exercise/exercise_dto.dart';
import '../../../data/models/workout/workout_dto.dart';
import '../../../data/models/workout/workout_exercise_dto.dart';
import '../../viewmodels/auth/auth_view_model.dart';
import '../../viewmodels/workout/workout_details_view_model.dart';
import '../../viewmodels/workout/workout_view_model.dart';
import '../add_exercise_details_dialog.dart';

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
        // After a successful action, refresh the main workout list and show a message.
        context.read<WorkoutViewModel>().fetchWorkouts();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Action successful!'), backgroundColor: Colors.green),
        );
        // If the workout itself was deleted, pop the screen.
        if (_viewModel.workout == null) {
          context.pop();
        }
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
    // Navigate to the selection screen and wait for the user to pick an exercise.
    final selectedExercise = await context.push<ExerciseDTO>('/home/select-exercise');

    if (selectedExercise != null && mounted) {
      // If an exercise was selected, show the details dialog.
      final details = await showDialog<Map<String, int?>>(
        context: context,
        builder: (_) => AddExerciseDetailsDialog(exercise: selectedExercise),
      );

      if (details != null && mounted) {
        // If details were entered, call the ViewModel to add the exercise.
        await _viewModel.addExerciseToWorkout(
          exerciseToAdd: selectedExercise,
          sets: details['sets']!,
          reps: details['reps']!,
          weightKg: details['weightKg'],
          durationSeconds: details['durationSeconds'],
        );
        // After adding, we should refresh the workout to see the new exercise.
        await _viewModel.refreshWorkout();
      }
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text('Delete Workout'),
          content: const Text('Are you sure you want to delete this workout? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(dialogContext).pop()),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _viewModel.deleteWorkout();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authUser = context.watch<AuthViewModel>().user;
    final viewModel = context.watch<WorkoutDetailsViewModel>();

    final isCustomWorkout = widget.workout.userId == authUser?.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.name),
        actions: [
          if (isCustomWorkout)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () { /* TODO: Implement edit workout name/desc */ },
            ),
          if (isCustomWorkout)
            IconButton(
              icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
              onPressed: _showDeleteConfirmationDialog,
            ),
        ],
      ),
      body: viewModel.state == ViewState.loading || viewModel.state == ViewState.idle
          ? const LoadingIndicator()
          : _buildWorkoutDetails(context, viewModel.workout!, isCustomWorkout),
      floatingActionButton: isCustomWorkout
          ? FloatingActionButton(
        onPressed: _navigateAndAddExercise,
        child: const Icon(Icons.add),
      )
          : null,
    );
  }

  Widget _buildWorkoutDetails(BuildContext context, WorkoutDTO workout, bool isCustomWorkout) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(workout.name, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(workout.description, style: Theme.of(context).textTheme.bodyLarge),
          const Divider(height: 40),
          Text('Exercises', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          if (workout.workoutExercises.isEmpty)
            const Center(child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text('This workout has no exercises yet.'),
            ))
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: workout.workoutExercises.length,
              itemBuilder: (context, index) {
                final workoutExercise = workout.workoutExercises[index];
                return _ExerciseDetailCard(
                  workoutExercise: workoutExercise,
                  isEditable: isCustomWorkout,
                  onDelete: () {
                    _viewModel.removeExerciseFromWorkout(workoutExercise.id);
                  },
                  onEdit: () {
                    // TODO: Show a dialog to edit sets, reps, etc.
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}

class _ExerciseDetailCard extends StatelessWidget {
  final WorkoutExerciseDTO workoutExercise;
  final bool isEditable;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _ExerciseDetailCard({
    required this.workoutExercise,
    required this.isEditable,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final exercise = workoutExercise.exercise;
    if (exercise == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    exercise.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                if (isEditable)
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') onEdit();
                      if (value == 'delete') onDelete();
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('Remove', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              exercise.description,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn('Sets', workoutExercise.sets.toString()),
                _buildStatColumn('Reps', workoutExercise.reps.toString()),
                if (workoutExercise.weightKg != null)
                  _buildStatColumn('Weight', '${workoutExercise.weightKg} kg'),
                if (workoutExercise.durationSeconds != null)
                  _buildStatColumn('Time', '${workoutExercise.durationSeconds}s'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
