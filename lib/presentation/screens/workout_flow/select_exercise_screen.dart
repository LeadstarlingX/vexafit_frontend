import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vexafit_frontend/core/constants/api_routes.dart';
import 'package:vexafit_frontend/presentation/widgets/loading_indicator.dart';
import '../../../core/utils/view_state.dart';
import '../../../data/models/exercise/exercise_dto.dart';
import '../../viewmodels/exercise/exercise_view_model.dart';


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
        return _CategorizedSelectList(
          categorizedExercises: viewModel.categorizedExercises,
        );
      case ViewState.idle:
      default:
        return const SizedBox.shrink();
    }
  }
}


/// A widget to display the categorized list for selection with images.
class _CategorizedSelectList extends StatelessWidget {
  final Map<String, List<ExerciseDTO>> categorizedExercises;
  const _CategorizedSelectList({required this.categorizedExercises});

  @override
  Widget build(BuildContext context) {
    final categories = categorizedExercises.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final categoryName = categories[index];
        final exercisesInCategory = categorizedExercises[categoryName]!;
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          clipBehavior: Clip.antiAlias,
          child: ExpansionTile(
            title: Text(
              categoryName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            children: exercisesInCategory.map((exercise) {
              // ✨ UPDATED: The ListTile now includes a leading image
              return ListTile(
                leading: SizedBox(
                  width: 56,
                  height: 56,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: exercise.firstImageUrl != null && exercise.firstImageUrl!.isNotEmpty
                        ? Image.network(
                      ApiRoutes.images + exercise.firstImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported, color: Colors.grey),
                      loadingBuilder: (context, child, progress) =>
                      progress == null ? child : const Center(child: CircularProgressIndicator()),
                    )
                        : Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.fitness_center, color: Colors.grey),
                    ),
                  ),
                ),
                title: Text(exercise.name),
                subtitle: Text(
                  exercise.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  // When an exercise is tapped, pop the screen and return the selected object.
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
