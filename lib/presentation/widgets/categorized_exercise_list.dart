import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/api_routes.dart';
import '../../../data/models/exercise/exercise_dto.dart';


class CategorizedExerciseList extends StatelessWidget {
  final Map<String, List<ExerciseDTO>> categorizedExercises;
  const CategorizedExerciseList({super.key, required this.categorizedExercises});

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
