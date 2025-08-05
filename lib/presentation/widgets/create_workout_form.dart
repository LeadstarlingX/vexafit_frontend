import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:vexafit_frontend/presentation/widgets/primary_button.dart';
import '../../../core/utils/view_state.dart';
import '../viewmodels/workout/workout_view_model.dart';


class CreateWorkoutForm extends StatefulWidget {
  const CreateWorkoutForm({super.key});

  @override
  State<CreateWorkoutForm> createState() => _CreateWorkoutFormState();
}

class _CreateWorkoutFormState extends State<CreateWorkoutForm> {
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
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim();

      await context.read<WorkoutViewModel>().createWorkout(
        name: name,
        description: description,
      );

      if (mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final workoutState = context.watch<WorkoutViewModel>().state;

    return Form(
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
    );
  }
}
