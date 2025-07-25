import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/workout/workout_dto.dart';
import '../viewmodels/auth/auth_view_model.dart';
import '../viewmodels/workout/workout_view_model.dart';
import '../widgets/loading_indicator.dart';
class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data when the screen is first loaded.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authViewModel = context.read<AuthViewModel>();
      context.read<WorkoutViewModel>().fetchWorkouts(authViewModel.user?.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WorkoutViewModel>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // We use a nested AppBar for the TabBar
        appBar: AppBar(
          toolbarHeight: 0, // Hide the default AppBar
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Predefined'),
              Tab(text: 'My Workouts'),
            ],
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        body: _buildBody(viewModel),
      ),
    );
  }

  Widget _buildBody(WorkoutViewModel viewModel) {
    switch (viewModel.state) {
      case ViewState.loading:
        return const LoadingIndicator();
      case ViewState.error:
        return Center(child: Text(viewModel.errorMessage ?? 'An error occurred.'));
      case ViewState.success:
        return TabBarView(
          children: [
            _WorkoutList(workouts: viewModel.predefinedWorkouts),
            _WorkoutList(workouts: viewModel.customWorkouts),
          ],
        );
      case ViewState.idle:
      default:
        return const SizedBox.shrink();
    }
  }
}

// A helper widget to display a list of workouts
class _WorkoutList extends StatelessWidget {
  final List<WorkoutDTO> workouts;
  const _WorkoutList({required this.workouts});

  @override
  Widget build(BuildContext context) {
    if (workouts.isEmpty) {
      return const Center(child: Text('No workouts found.'));
    }

    return ListView.builder(
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        final workout = workouts[index];
        return Card(
          child: ListTile(
            title: Text(workout.name, style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text(
              workout.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () {
              // Navigate to workout details screen
            },
          ),
        );
      },
    );
  }
}
