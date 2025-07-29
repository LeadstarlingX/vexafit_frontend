import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vexafit_frontend/data/models/exercise/exercise_dto.dart';
import 'package:vexafit_frontend/presentation/widgets/loading_indicator.dart';

import '../../viewmodels/exercise/exercise_view_model.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
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

  // Debounce search to avoid excessive API calls while typing.
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
      // The main AppBar is handled by MainShellScreen.
      // We add a simple search bar here using a nested AppBar.
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search exercises...',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: _onSearchChanged,
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
        if (viewModel.exercises.isEmpty) {
          return const Center(child: Text('No exercises found.'));
        }
        return _CategorizedExerciseList(
          categorizedExercises: viewModel.categorizedExercises,
        );
      case ViewState.idle:
      default:
        return const SizedBox.shrink();
    }
  }
}



class _CategorizedExerciseList extends StatelessWidget {
  final Map<String, List<ExerciseDTO>> categorizedExercises;
  const _CategorizedExerciseList({required this.categorizedExercises});

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
                subtitle: Text(
                  exercise.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  // TODO: Navigate to exercise details screen.
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}