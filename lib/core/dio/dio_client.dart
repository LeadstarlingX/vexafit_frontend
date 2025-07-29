import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../constants/api_routes.dart';
import '../utils/token_storage.dart';

class DioClient {
  // Singleton instance
  static final DioClient _instance = DioClient._internal();
  late final Dio dio;

  factory DioClient() => _instance;

  DioClient._internal() {
    // Initialize Dio with base options
    dio = Dio(
      BaseOptions(
        baseUrl: ApiRoutes.url,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _addLoggingInterceptor();
    _addAuthInterceptor();
    _addErrorInterceptor();
  }

  void _addLoggingInterceptor() {
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: (object) => debugPrint(object.toString()),
      ),
    );
  }

  void _addAuthInterceptor() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  void _addErrorInterceptor() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, handler) async {
          // Handle 401 Unauthorized
          if (e.response?.statusCode == 401) {
            // Optionally: Refresh token logic here
            await TokenStorage.clearToken();
            // You might want to navigate to login screen here
            // navigatorKey.currentState?.pushNamed('/login');
          }

          // Format error message
          final errorMessage = _formatErrorMessage(e);

          // Create a custom error object
          final customError = DioException(
            requestOptions: e.requestOptions,
            error: errorMessage,
            response: e.response,
            type: e.type,
          );

          return handler.next(customError);
        },
      ),
    );
  }

  String _formatErrorMessage(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return 'Connection timeout. Please check your internet connection.';
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return 'Server took too long to respond.';
    } else if (e.type == DioExceptionType.badResponse) {
      // Try to get server error message
      final data = e.response?.data;
      if (data != null && data is Map<String, dynamic>) {
        return data['message'] ?? 'An error occurred';
      }
      return 'Server responded with error: ${e.response?.statusCode}';
    }
    return 'Network error occurred. Please try again.';
  }

  // Helper method for common GET requests
  Future<Response> get(
      String path, {
        Map<String, dynamic>? queryParameters,
      }) async {
    return dio.get(
      path,
      queryParameters: queryParameters,
    );
  }

  // Helper method for common POST requests
  Future<Response> post(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
      }) async {
    return dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
    );
  }

  // Helper method for file uploads
  Future<Response> uploadFile(
      String path, {
        required String filePath,
        required String fieldName,
        Map<String, dynamic>? data,
      }) async {
    final formData = FormData.fromMap({
      ...?data,
      fieldName: await MultipartFile.fromFile(filePath),
    });


    return dio.post(
      path,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );
  }

  Future<Response> put(String path, {dynamic data}) async => dio.put(path, data: data);
  Future<Response> delete(String path) async => dio.delete(path);
}
