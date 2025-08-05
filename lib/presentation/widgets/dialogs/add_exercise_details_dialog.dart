import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vexafit_frontend/presentation/widgets/primary_button.dart';
import '../../../data/models/exercise/exercise_dto.dart';


class AddExerciseDetailsDialog extends StatefulWidget {
  final ExerciseDTO exercise;

  const AddExerciseDetailsDialog({super.key, required this.exercise});

  @override
  State<AddExerciseDetailsDialog> createState() => _AddExerciseDetailsDialogState();
}

class _AddExerciseDetailsDialogState extends State<AddExerciseDetailsDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _setsController;
  late final TextEditingController _repsController;
  late final TextEditingController _weightController;
  late final TextEditingController _durationController;

  @override
  void initState() {
    super.initState();
    _setsController = TextEditingController();
    _repsController = TextEditingController();
    _weightController = TextEditingController();
    _durationController = TextEditingController();
  }

  @override
  void dispose() {
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final details = {
        'sets': int.parse(_setsController.text),
        'reps': int.parse(_repsController.text),
        'weightKg': _weightController.text.isNotEmpty ? int.parse(_weightController.text) : null,
        'durationSeconds': _durationController.text.isNotEmpty ? int.parse(_durationController.text) : null,
      };
      Navigator.of(context).pop(details);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Text('Add "${widget.exercise.name}"'),
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
                validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _repsController,
                decoration: const InputDecoration(labelText: 'Reps'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(labelText: 'Weight (kg, optional)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _durationController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(labelText: 'Duration (seconds, optional)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        PrimaryButton(
          text: 'Add to Workout',
          onPressed: _onSave,
        ),
      ],
    );
  }
}
