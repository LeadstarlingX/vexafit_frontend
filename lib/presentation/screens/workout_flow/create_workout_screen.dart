import 'package:flutter/material.dart';
import '../../widgets/create_workout_form.dart';

class CreateWorkoutScreen extends StatelessWidget {
  const CreateWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Workout'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: CreateWorkoutForm(),
      ),
    );
  }
}
