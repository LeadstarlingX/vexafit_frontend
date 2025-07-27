import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vexafit_frontend/presentation/widgets/loading_indicator.dart';
import '../../../core/utils/view_state.dart';
import '../../../data/models/workout/workout_dto.dart';
import '../../viewmodels/auth/auth_view_model.dart';
import '../../viewmodels/workout/workout_details_view_model.dart';
import '../../viewmodels/workout/workout_view_model.dart';

class WorkoutDetailsScreen extends StatefulWidget {
  final WorkoutDTO workout;

  const WorkoutDetailsScreen({super.key, required this.workout});

  @override
  State<WorkoutDetailsScreen> createState() => _WorkoutDetailsScreenState();
}

class _WorkoutDetailsScreenState extends State<WorkoutDetailsScreen> {
  // --- THIS IS THE FIX (Part 1) ---
  // Store a reference to the ViewModel.
  late final WorkoutDetailsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    // Get the ViewModel instance once and store it.
    _viewModel = context.read<WorkoutDetailsViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _viewModel.resetActionState();
        _viewModel.setWorkout(widget.workout);
      }
    });

    _viewModel.addListener(_onActionStateChanged);
  }

  @override
  void dispose() {
    // --- THIS IS THE FIX (Part 2) ---
    // Use the stored reference to remove the listener, not context.read().
    _viewModel.removeListener(_onActionStateChanged);
    super.dispose();
  }

  void _onActionStateChanged() {
    // We can still use the stored _viewModel here.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (_viewModel.actionState == DetailsActionState.success) {
        context.read<WorkoutViewModel>().removeWorkoutFromList(widget.workout.id);
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workout deleted successfully!'), backgroundColor: Colors.green),
        );
      } else if (_viewModel.actionState == DetailsActionState.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_viewModel.errorMessage ?? 'Failed to delete workout.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
      _viewModel.resetActionState();
    });
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
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // Use the stored viewModel to call the delete method.
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
    // We still watch here to rebuild the UI when the state changes.
    final viewModel = context.watch<WorkoutDetailsViewModel>();

    final isCustomWorkout = widget.workout.userId == authUser?.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.name),
        actions: [
          if (isCustomWorkout)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // TODO: Navigate to an edit screen.
              },
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
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.workout.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              widget.workout.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Divider(height: 40),
            Text(
              'Exercises',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (widget.workout.exercises.isEmpty)
              const Center(child: Text('This workout has no exercises yet.'))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.workout.exercises.length,
                itemBuilder: (context, index) {
                  final exercise = widget.workout.exercises[index];
                  return Card(
                    child: ListTile(
                      title: Text(exercise.name),
                      subtitle: Text(
                        exercise.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        // TODO: Navigate to this specific exercise's details page.
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
