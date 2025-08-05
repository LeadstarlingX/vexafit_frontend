import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/workout/workout_dto.dart';
import '../../../data/models/workout/workout_exercise_dto.dart';
import 'exercise_detail_card.dart';

class WorkoutDetailsView extends StatelessWidget {
  final WorkoutDTO workout;
  final bool isCustomWorkout;
  final void Function(WorkoutExerciseDTO) onEditExercise;
  final void Function(int) onRemoveExercise;

  const WorkoutDetailsView({
    super.key,
    required this.workout,
    required this.isCustomWorkout,
    required this.onEditExercise,
    required this.onRemoveExercise,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(workout.name, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(workout.description, style: Theme.of(context).textTheme.bodyLarge),
          const Divider(height: 40),
          Text('Exercises', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          if (workout.workoutExercises.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('This workout has no exercises yet.'),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: workout.workoutExercises.length,
              itemBuilder: (context, index) {
                final workoutExercise = workout.workoutExercises[index];
                return ExerciseDetailCard(
                  workoutExercise: workoutExercise,
                  isEditable: isCustomWorkout,
                  onDelete: () => onRemoveExercise(workoutExercise.id),
                  onEdit: () => onEditExercise(workoutExercise),
                );
              },
            ),
        ],
      ),
    );
  }
}
