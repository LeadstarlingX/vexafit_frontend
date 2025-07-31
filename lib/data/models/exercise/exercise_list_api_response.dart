import './exercise_dto.dart';

class ExerciseListApiResponse {
  final int code;
  final String? message;
  final bool result;
  final List<ExerciseDTO>? data;

  ExerciseListApiResponse({
    required this.code,
    this.message,
    required this.result,
    this.data,
  });

  factory ExerciseListApiResponse.fromJson(Map<String, dynamic> json) {
    return ExerciseListApiResponse(
      code: json['code'] ?? 0,
      message: json['message'],
      result: json['result'] ?? false,
      data: json['data'] != null
          ? (json['data'] as List).map((e) => ExerciseDTO.fromJson(e)).toList()
          : null,
    );
  }
}
