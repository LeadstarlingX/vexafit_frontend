import 'package:flutter/material.dart';
import '../../../core/constants/api_routes.dart';
import '../../../data/models/workout/workout_exercise_dto.dart';

class ExerciseDetailCard extends StatelessWidget {
  final WorkoutExerciseDTO workoutExercise;
  final bool isEditable;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ExerciseDetailCard({
    super.key,
    required this.workoutExercise,
    required this.isEditable,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final exercise = workoutExercise.exercise;
    if (exercise == null) return const SizedBox.shrink();
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (exercise.firstImageUrl != null && exercise.firstImageUrl!.isNotEmpty)
            Image.network(
              ApiRoutes.images + exercise.firstImageUrl!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.grey[600],
                    size: 50,
                  ),
                );
              },
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        exercise.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    if (isEditable)
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') onEdit();
                          if (value == 'delete') onDelete();
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Text('Remove', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  exercise.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn('Sets', workoutExercise.sets.toString()),
                    _buildStatColumn('Reps', workoutExercise.reps.toString()),
                    if (workoutExercise.weightKg != null)
                      _buildStatColumn('Weight', '${workoutExercise.weightKg} kg'),
                    if (workoutExercise.durationSeconds != null)
                      _buildStatColumn('Time', '${workoutExercise.durationSeconds}s'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
