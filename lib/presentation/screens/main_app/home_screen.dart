import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vexafit_frontend/presentation/widgets/loading_indicator.dart';
import '../../../core/utils/view_state.dart';
import '../../../data/models/workout/workout_dto.dart';
import '../../viewmodels/auth/auth_view_model.dart';
import '../../viewmodels/workout/workout_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {

      context.read<WorkoutViewModel>().fetchWorkouts();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch for changes in the WorkoutViewModel.
    final viewModel = context.watch<WorkoutViewModel>();

    // Use a DefaultTabController to manage the state of the tabs.
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // We use a nested AppBar here to hold the TabBar.
        // The main AppBar title is provided by MainShellScreen.
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 0, // Effectively hides the AppBar's own height
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
        // The body of the scaffold shows content based on the ViewModel's state.
        body: _buildBody(viewModel),
      ),
    );
  }

  /// Builds the main content area based on the current state of the ViewModel.
  Widget _buildBody(WorkoutViewModel viewModel) {
    switch (viewModel.state) {
      case ViewState.loading:
        return const LoadingIndicator();
      case ViewState.error:
        return Center(child: Text(viewModel.errorMessage ?? 'An error occurred.'));
      case ViewState.success:
      // When data is successfully loaded, show the tabbed content.
        return TabBarView(
          children: [
            _WorkoutList(workouts: viewModel.predefinedWorkouts),
            _WorkoutList(workouts: viewModel.customWorkouts),
          ],
        );
      case ViewState.idle:
      default:
      // Show nothing by default.
        return const SizedBox.shrink();
    }
  }
}

/// A reusable helper widget to display a list of workouts in a Card format.
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
              // TODO: Navigate to workout details screen
            },
          ),
        );
      },
    );
  }
}
