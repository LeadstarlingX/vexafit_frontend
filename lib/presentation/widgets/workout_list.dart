import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/workout/workout_dto.dart';

class WorkoutList extends StatelessWidget {
  final List<WorkoutDTO> workouts;
  const WorkoutList({super.key, required this.workouts});

  @override
  Widget build(BuildContext context) {
    if (workouts.isEmpty) {
      return const Center(child: Text('No workouts found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        final workout = workouts[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
