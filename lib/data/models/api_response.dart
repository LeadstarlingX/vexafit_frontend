class ApiResponse<T> {
  final int code;
  final String? message;
  final bool success;
  final T? data;

  ApiResponse({
    required this.code,
    this.message,
    required this.success,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic)? fromJsonT) {
    return ApiResponse<T>(
      code: json['Code'] ?? json['code'] ?? 0,
      message: json['Message'] ?? json['message'],
      success: json['Result'] ?? json['result'] ?? false,
      data: json['Data'] != null && fromJsonT != null
          ? fromJsonT(json['Data'])
          : json['Data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Code': code,
      'Message': message,
      'Success': success,
      'Data': data,
    };
  }

  bool get isSuccess => success;
  bool get isFailure => !success;

}