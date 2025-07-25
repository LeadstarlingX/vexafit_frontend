import '../models/auth/login_dto.dart';
import '../models/auth/register_dto.dart';
import '../models/auth/user_profile_dto.dart';

abstract class IAuthRepository {
  Future<UserProfileDTO> login(LoginDTO dto);
  Future<void> logout();
  Future<UserProfileDTO?> getAuthenticated();
  Future<void> register(RegisterDTO dto);
}
