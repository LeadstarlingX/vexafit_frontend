import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vexafit_frontend/presentation/widgets/view_state_handler.dart';
import '../../viewmodels/workout/workout_view_model.dart';
import '../../widgets/workout_list.dart';

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
    // Add listener to rebuild when tab changes to update FAB visibility
    _tabController.addListener(() => setState(() {}));
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
      body: ViewStateHandler(
        viewState: viewModel.state,
        errorMessage: viewModel.errorMessage,
        successBuilder: (context) {
          return TabBarView(
            controller: _tabController,
            children: [
              WorkoutList(workouts: viewModel.predefinedWorkouts),
              WorkoutList(workouts: viewModel.customWorkouts),
            ],
          );
        },
      ),
      floatingActionButton: _tabController.index == 1
          ? FloatingActionButton(
        onPressed: () => context.go('/home/create-workout'),
        child: const Icon(Icons.add),
      )
          : null,
    );
  }
}
