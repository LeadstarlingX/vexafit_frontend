import 'package:dio/dio.dart';

import '../../core/constants/api_routes.dart';
import '../../core/dio/dio_client.dart';
import '../../core/utils/token_storage.dart';
import '../../data/irepositories/i_auth_repository.dart';
import '../../data/models/auth/login_dto.dart';
import '../../data/models/auth/register_dto.dart';
import '../../data/models/auth/user_profile_dto.dart';

class AuthRepository implements IAuthRepository {
  final DioClient _dioClient;

  AuthRepository({required DioClient dioClient}) : _dioClient = dioClient;


  @override
  Future<UserProfileDTO> login(LoginDTO dto) async {
    try {
      final response = await _dioClient.dio.post(
        ApiRoutes.login,
        data: dto.toJson(),
      );

      final userProfile = UserProfileDTO.fromJson(response.data['Data']);
      await TokenStorage.saveToken(userProfile.token!.jwtToken!);
      return userProfile;
    } on DioException catch (e) {
      throw _handleAuthError(e);
    }
  }


  @override
  Future<void> logout() async {
    try {
      await _dioClient.dio.post(ApiRoutes.logout);
      await TokenStorage.clearToken();
    } on DioException catch (e) {
      throw _handleAuthError(e);
    }
  }


  @override
  Future<UserProfileDTO?> getAuthenticated() async {
    try {
      final response = await _dioClient.dio.get(ApiRoutes.getAuthenticated);
      return UserProfileDTO.fromJson(response.data['Data']);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await TokenStorage.clearToken();
        return null;
      }
      throw _handleAuthError(e);
    }
  }


  @override
  Future<void> register(RegisterDTO dto) async {
    try {
      await _dioClient.dio.post(
        ApiRoutes.register,
        data: dto.toJson(),
      );
    } on DioException catch (e) {
      throw _handleAuthError(e);
    }
  }


  Exception _handleAuthError(DioException e) {
    final errorMessage = e.response?.data?['Message'] ??
        'Authentication failed. Please try again.';
    return Exception(errorMessage);
  }

}