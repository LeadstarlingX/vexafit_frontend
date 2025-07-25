import 'exercise_dto.dart';

class ExerciseApiResponse {
  final int code;
  final String? message;
  final bool result;
  final ExerciseDTO? data;

  ExerciseApiResponse({
    required this.code,
    this.message,
    required this.result,
    this.data,
  });

  factory ExerciseApiResponse.fromJson(Map<String, dynamic> json) {
    return ExerciseApiResponse(
      code: json['code'] ?? 0,
      message: json['message'],
      result: json['result'] ?? false,
      data: json['data'] != null ? ExerciseDTO.fromJson(json['data']) : null,
    );
  }
}