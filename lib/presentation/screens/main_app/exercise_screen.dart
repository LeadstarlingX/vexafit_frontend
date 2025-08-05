import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vexafit_frontend/presentation/widgets/debounced_search_field.dart';
import 'package:vexafit_frontend/presentation/widgets/view_state_handler.dart';
import '../../viewmodels/exercise/exercise_view_model.dart';
import '../../widgets/categorized_exercise_list.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch initial list of all exercises.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExerciseViewModel>().fetchAllExercises();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ExerciseViewModel>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: DebouncedSearchField(
            hintText: 'Search exercises...',
            onDebounced: (query) {
              viewModel.fetchAllExercises(name: query);
            },
          ),
        ),
      ),
      body: ViewStateHandler(
        viewState: viewModel.state,
        errorMessage: viewModel.errorMessage,
        successBuilder: (context) {
          if (viewModel.categorizedExercises.isEmpty) {
            return const Center(child: Text('No exercises found.'));
          }
          // Now using the reusable CategorizedExerciseList widget
          return CategorizedExerciseList(
            categorizedExercises: viewModel.categorizedExercises,
          );
        },
      ),
    );
  }
}
