import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vexafit_frontend/presentation/widgets/loading_indicator.dart';
import '../../data/models/exercise/exercise_dto.dart';
import '../viewmodels/exercise/exercise_view_model.dart';


class SelectExerciseScreen extends StatefulWidget {
  const SelectExerciseScreen({super.key});

  @override
  State<SelectExerciseScreen> createState() => _SelectExerciseScreenState();
}

class _SelectExerciseScreenState extends State<SelectExerciseScreen> {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Fetch all exercises when the screen is first loaded.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExerciseViewModel>().fetchAllExercises();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<ExerciseViewModel>().fetchAllExercises(name: query);
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
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search exercises...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
        ),
      ),
      body: _buildBody(viewModel),
    );
  }

  Widget _buildBody(ExerciseViewModel viewModel) {
    switch (viewModel.state) {
      case ViewState.loading:
        return const LoadingIndicator();
      case ViewState.error:
        return Center(child: Text(viewModel.errorMessage ?? 'An error occurred.'));
      case ViewState.success:
        if (viewModel.categorizedExercises.isEmpty) {
          return const Center(child: Text('No exercises found.'));
        }
        // --- THIS IS THE NEW UI ---
        return _CategorizedSelectList(
          categorizedExercises: viewModel.categorizedExercises,
        );
      case ViewState.idle:
      default:
        return const SizedBox.shrink();
    }
  }
}


/// A new widget to display the categorized list for selection.
class _CategorizedSelectList extends StatelessWidget {
  final Map<String, List<ExerciseDTO>> categorizedExercises;
  const _CategorizedSelectList({required this.categorizedExercises});

  @override
  Widget build(BuildContext context) {
    final categories = categorizedExercises.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final categoryName = categories[index];
        final exercisesInCategory = categorizedExercises[categoryName]!;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ExpansionTile(
            title: Text(
              categoryName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            children: exercisesInCategory.map((exercise) {
              return ListTile(
                title: Text(exercise.name),
                onTap: () {
                  // When an exercise is tapped, pop the screen and return
                  // the selected exercise object as the result.
                  context.pop(exercise);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}