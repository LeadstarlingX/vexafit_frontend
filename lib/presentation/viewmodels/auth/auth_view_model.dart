import 'package:flutter/material.dart';
import '../../../core/utils/token_storage.dart';
import '../../../data/models/auth/login_dto.dart';
import '../../../data/models/auth/register_dto.dart';
import '../../../data/models/auth/user_profile_dto.dart';
import '../../../data/irepositories/i_auth_repository.dart';

enum AuthStatus { idle, loading, authenticated, unauthenticated, error }

class AuthViewModel extends ChangeNotifier {
  final IAuthRepository _authRepository;

  AuthViewModel(this._authRepository);

  AuthStatus _status = AuthStatus.idle;
  String? _errorMessage;
  UserProfileDTO? _user;

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  UserProfileDTO? get user => _user;

  Future<void> login(LoginDTO dto) async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      _user = await _authRepository.login(dto);
      await TokenStorage.saveToken(_user!.token?.jwtToken ?? '');
      _status = AuthStatus.authenticated;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  Future<void> register(RegisterDTO dto) async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      await _authRepository.register(dto);
      _status = AuthStatus.unauthenticated;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  Future<void> logout() async {
    await _authRepository.logout();
    await TokenStorage.clearToken();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> checkAuthenticated() async {
    try {
      _user = await _authRepository.getAuthenticated();
      _status = _user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    } catch (_) {
      _status = AuthStatus.unauthenticated;
    }

    notifyListeners();
  }
}
