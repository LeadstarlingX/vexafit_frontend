import 'package:flutter/material.dart';
import 'package:vexafit_frontend/data/models/auth/login_dto.dart';
import 'package:vexafit_frontend/data/models/auth/user_profile_dto.dart';
import 'package:vexafit_frontend/data/irepositories/i_auth_repository.dart';

// Added 'unknown' for the initial state before we know if user is logged in.
enum AuthStatus { unknown, idle, loading, authenticated, unauthenticated, error }

class AuthViewModel extends ChangeNotifier {
  final IAuthRepository _authRepository;

  AuthViewModel(this._authRepository);

  // Start with 'unknown' status.
  AuthStatus _status = AuthStatus.unknown;
  String? _errorMessage;
  UserProfileDTO? _user;

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  UserProfileDTO? get user => _user;

  /// NEW METHOD: Checks for a saved token on app startup.
  Future<void> checkInitialAuth() async {
    try {
      // This method attempts to get the user profile using a stored token.
      _user = await _authRepository.getAuthenticated();
      if (_user != null) {
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (_) {
      // If any error occurs (e.g., token expired, network error), treat as unauthenticated.
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
    await _authRepository.logout();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

// Other methods like register() would go here...
}
