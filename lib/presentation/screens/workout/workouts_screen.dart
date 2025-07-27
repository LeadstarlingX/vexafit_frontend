import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vexafit_frontend/presentation/widgets/loading_indicator.dart';

import '../../../core/utils/view_state.dart';
import '../../../data/models/workout/workout_dto.dart';
import '../../viewmodels/workout/workout_view_model.dart';

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    // --- THIS IS THE FIX ---
    // We no longer need to call fetchWorkouts() here.
    // The ViewModel does it automatically when the user logs in.
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WorkoutViewModel>();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Predefined'),
            Tab(text: 'My Workouts'),
          ],
        ),
      ),
      body: _buildBody(viewModel),
      floatingActionButton: _tabController.index == 1
          ? FloatingActionButton(
        onPressed: () {
          context.go('/home/create-workout');
        },
        child: const Icon(Icons.add),
      )
          : null,
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
          controller: _tabController,
          children: [
            _WorkoutList(workouts: viewModel.predefinedWorkouts),
            _WorkoutList(workouts: viewModel.customWorkouts),
          ],
        );
      case ViewState.idle:
      default:
        return const Center(child: Text('Welcome! Select a tab.'));
    }
  }
}

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
            title: Text(workout.name),
            subtitle: Text(
              workout.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              context.go('/home/workout-details', extra: workout);
            },
          ),
        );
      },
    );
  }
}
