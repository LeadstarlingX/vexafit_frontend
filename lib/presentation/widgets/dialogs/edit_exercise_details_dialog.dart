import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/models/workout/workout_exercise_dto.dart';

class EditExerciseDetailsDialog extends StatefulWidget {
  final WorkoutExerciseDTO workoutExercise;

  const EditExerciseDetailsDialog({super.key, required this.workoutExercise});

  @override
  State<EditExerciseDetailsDialog> createState() => _EditExerciseDetailsDialogState();
}

class _EditExerciseDetailsDialogState extends State<EditExerciseDetailsDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _setsController;
  late final TextEditingController _repsController;
  late final TextEditingController _weightController;
  late final TextEditingController _durationController;

  @override
  void initState() {
    super.initState();
    _setsController = TextEditingController(text: widget.workoutExercise.sets.toString());
    _repsController = TextEditingController(text: widget.workoutExercise.reps.toString());
    _weightController = TextEditingController(text: widget.workoutExercise.weightKg?.toString() ?? '');
    _durationController = TextEditingController(text: widget.workoutExercise.durationSeconds?.toString() ?? '');
  }

  @override
  void dispose() {
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final details = {
        'sets': int.tryParse(_setsController.text),
        'reps': int.tryParse(_repsController.text),
        'weightKg': _weightController.text.isNotEmpty ? int.tryParse(_weightController.text) : null,
        'durationSeconds': _durationController.text.isNotEmpty ? int.tryParse(_durationController.text) : null,
      };
      Navigator.of(context).pop(details);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit ${widget.workoutExercise.exercise?.name ?? 'Exercise'}'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _setsController,
                decoration: const InputDecoration(labelText: 'Sets'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty || int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid number of sets';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _repsController,
                decoration: const InputDecoration(labelText: 'Reps'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty || int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid number of reps';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Weight (kg)', hintText: 'Optional'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value != null && value.isNotEmpty && (int.tryParse(value) == null || int.parse(value) < 0)) {
                    return 'Please enter a valid weight';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Duration (s)', hintText: 'Optional'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value != null && value.isNotEmpty && (int.tryParse(value) == null || int.parse(value) < 0)) {
                    return 'Please enter a valid duration';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ElevatedButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
