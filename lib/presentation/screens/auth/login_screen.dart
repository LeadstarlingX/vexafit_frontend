// lib/presentation/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth/auth_view_model.dart';
import '../../../data/models/auth/login_dto.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authVM.status == AuthStatus.error && authVM.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authVM.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: authVM.status == AuthStatus.loading
                  ? null
                  : () {
                final dto = LoginDTO(
                  email: emailController.text,
                  password: passwordController.text,
                );
                authVM.login(dto);
              },
              child: authVM.status == AuthStatus.loading
                  ? const CircularProgressIndicator()
                  : const Text("Login"),
            ),
            if (authVM.status == AuthStatus.error)
              Text(authVM.errorMessage ?? "Unknown error", style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
