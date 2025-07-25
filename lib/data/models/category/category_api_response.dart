import './category_dto.dart';

class CategoryApiResponse {
  final int code;
  final String? message;
  final bool result;
  final CategoryDTO? data;

  CategoryApiResponse({
    required this.code,
    this.message,
    required this.result,
    this.data,
  });

  factory CategoryApiResponse.fromJson(Map<String, dynamic> json) {
    return CategoryApiResponse(
      code: json['code'] ?? 0,
      message: json['message'],
      result: json['result'] ?? false,
      data: json['data'] != null ? CategoryDTO.fromJson(json['data']) : null,
    );
  }
}
