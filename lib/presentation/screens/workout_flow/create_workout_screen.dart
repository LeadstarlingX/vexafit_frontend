import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vexafit_frontend/presentation/widgets/primary_button.dart';

import '../../../core/utils/view_state.dart';
import '../../viewmodels/workout/workout_view_model.dart';

class CreateWorkoutScreen extends StatefulWidget {
  const CreateWorkoutScreen({super.key});

  @override
  State<CreateWorkoutScreen> createState() => _CreateWorkoutScreenState();
}

class _CreateWorkoutScreenState extends State<CreateWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveWorkout() async {
    // Validate the form fields.
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim();

      // Call the createWorkout method from the ViewModel.
      await context.read<WorkoutViewModel>().createWorkout(
        name: name,
        description: description,
      );

      // After saving, navigate back to the previous screen.
      if (mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the viewmodel to get the loading state.
    final workoutState = context.watch<WorkoutViewModel>().state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Workout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Workout Name',
                  hintText: 'e.g., "Leg Day"',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a workout name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'e.g., "Focus on quads and hamstrings"',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description.';
                  }
                  return null;
                },
              ),
              const Spacer(),
              PrimaryButton(
                text: 'Save Workout',
                isLoading: workoutState == ViewState.loading,
                onPressed: _saveWorkout,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
