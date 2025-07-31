import 'package:flutter/material.dart';
import 'package:vexafit_frontend/data/models/auth/login_dto.dart';
import 'package:vexafit_frontend/data/models/auth/user_profile_dto.dart';
import 'package:vexafit_frontend/data/irepositories/i_auth_repository.dart';
import '../../../data/models/auth/register_dto.dart';

enum AuthStatus { unknown, idle, loading, authenticated, unauthenticated, error }

class AuthViewModel extends ChangeNotifier {
  final IAuthRepository _authRepository;

  AuthViewModel(this._authRepository);

  AuthStatus _status = AuthStatus.unknown;
  String? _errorMessage;
  UserProfileDTO? _user;

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  UserProfileDTO? get user => _user;

  Future<bool> register(RegisterDTO dto) async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      await _authRepository.register(dto);
      _status = AuthStatus.idle;
      notifyListeners();
      return true;

    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> checkInitialAuth() async {
    try {
      _user = await _authRepository.getAuthenticated();
      _status = _user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    } catch (_) {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<void> login(LoginDTO dto) async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      _user = await _authRepository.login(dto);
      _status = AuthStatus.authenticated;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
    } catch (e) {
      debugPrint("Server logout failed, but proceeding with local logout: $e");
    } finally {
      _user = null;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  void acknowledgeError() {
    _status = AuthStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }
}
