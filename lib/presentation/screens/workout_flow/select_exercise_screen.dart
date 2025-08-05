import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vexafit_frontend/presentation/widgets/debounced_search_field.dart';
import 'package:vexafit_frontend/presentation/widgets/view_state_handler.dart';
import '../../viewmodels/exercise/exercise_view_model.dart';
import '../../widgets/categorized_exercise_list.dart';

class SelectExerciseScreen extends StatefulWidget {
  const SelectExerciseScreen({super.key});

  @override
  State<SelectExerciseScreen> createState() => _SelectExerciseScreenState();
}

class _SelectExerciseScreenState extends State<SelectExerciseScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch initial list of exercises without any filter.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExerciseViewModel>().fetchAllExercises();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ExerciseViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select an Exercise'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: DebouncedSearchField(
              hintText: 'Search exercises...',
              onDebounced: (query) {
                viewModel.fetchAllExercises(name: query);
              },
            ),
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
          return CategorizedExerciseList(
            categorizedExercises: viewModel.categorizedExercises,
          );
        },
      ),
    );
  }
}
