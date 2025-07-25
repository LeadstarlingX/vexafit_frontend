// lib/presentation/screens/auth/auth_wrapper.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth/auth_view_model.dart';
import '../../screens/auth/login_screen.dart';
import '../home_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    switch (authVM.status) {
      case AuthStatus.loading:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      case AuthStatus.authenticated:
        return const HomeScreen(); // you can replace with your main screen
      case AuthStatus.unauthenticated:
      case AuthStatus.error:
      case AuthStatus.idle:
      default:
        return LoginScreen();
    }
  }
}
