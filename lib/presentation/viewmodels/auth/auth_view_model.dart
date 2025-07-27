import 'package:flutter/material.dart';
import 'package:vexafit_frontend/data/models/auth/login_dto.dart';
import 'package:vexafit_frontend/data/models/auth/user_profile_dto.dart';
import 'package:vexafit_frontend/data/irepositories/i_auth_repository.dart';

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

  /// This logout method is now more robust.
  Future<void> logout() async {
    try {
      // Attempt to log out from the server.
      await _authRepository.logout();
    } catch (e) {
      // If the server call fails, we print the error but DO NOT stop.
      // The user must be logged out on the device regardless.
      debugPrint("Server logout failed, but proceeding with local logout: $e");
    } finally {
      // This 'finally' block ALWAYS runs, even if the 'try' block fails.
      // This guarantees the local token and state are cleared.
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
