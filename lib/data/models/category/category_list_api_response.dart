import './category_dto.dart';

class CategoryListApiResponse {
  final int code;
  final String? message;
  final bool result;
  final List<CategoryDTO>? data;

  CategoryListApiResponse({
    required this.code,
    this.message,
    required this.result,
    this.data,
  });

  factory CategoryListApiResponse.fromJson(Map<String, dynamic> json) {
    return CategoryListApiResponse(
      code: json['code'] ?? 0,
      message: json['message'],
      result: json['result'] ?? false,
      data: json['data'] != null
          ? (json['data'] as List).map((e) => CategoryDTO.fromJson(e)).toList()
          : null,
    );
  }
}