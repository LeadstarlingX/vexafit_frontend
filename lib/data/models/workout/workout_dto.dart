import 'package:vexafit_frontend/data/models/exercise/exercise_dto.dart';

class WorkoutDTO {
  final int id;
  final String name;
  final String description;
  final String? userId;
  final int? durationInMinutes;
  final List<ExerciseDTO>? exercises;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WorkoutDTO({
    required this.id,
    required this.name,
    required this.description,
    this.userId,
    this.durationInMinutes,
    this.exercises,
    this.createdAt,
    this.updatedAt,
  });

  factory WorkoutDTO.fromJson(Map<String, dynamic> json) {
    try {
      return WorkoutDTO(
        id: json['Id'] ?? 0,
        name: json['Name'] ?? '',
        description: json['Description'] ?? '',
        userId: json['UserId'], // Can be null or empty string — that's fine

        durationInMinutes: json['DurationInMinutes'] != null
            ? int.tryParse(json['DurationInMinutes'].toString())
            : null,

        exercises: (json['Exercises'] as List<dynamic>?)
            ?.map((e) => ExerciseDTO.fromJson(e))
            .toList() ??
            [],

        createdAt: json['CreationDate'] != null
            ? DateTime.tryParse(json['CreationDate'])
            : null,

        updatedAt: json['UpdatedAt'] != null
            ? DateTime.tryParse(json['UpdatedAt'])
            : null,
      );
    } catch (e, stack) {
      print('❌ Error parsing WorkoutDTO: $e');
      print('🔍 Stack trace:\n$stack');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
      'Description': description,
      'UserId': userId,
      'DurationInMinutes': durationInMinutes,
      'Exercises': exercises?.map((e) => e.toJson()).toList(),
      'CreationDate': createdAt?.toIso8601String(),
      'UpdatedAt': updatedAt?.toIso8601String(),
    };
  }
}
