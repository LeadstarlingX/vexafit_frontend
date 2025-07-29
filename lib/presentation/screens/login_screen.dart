import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vexafit_frontend/data/models/auth/login_dto.dart';
import 'package:vexafit_frontend/presentation/widgets/primary_button.dart';
import '../viewmodels/auth/auth_view_model.dart';

// This is now a simple StatelessWidget as the router handles navigation logic.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    final authViewModel = context.watch<AuthViewModel>();
    final authStatus = authViewModel.status;

    // This listener handles showing error messages.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authViewModel.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authViewModel.errorMessage ?? 'An unknown error occurred.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        authViewModel.acknowledgeError();
      }
    });

    return Scaffold(
      // By removing the AppBar and SingleChildScrollView, the Column
      // is now correctly centered within the screen's boundaries.
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- THIS TEXT WILL NOW BE VISIBLE ---
              Text(
                'Welcome to Vexafit',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to continue',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 48),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Login',
                isLoading: authStatus == AuthStatus.loading,
                onPressed: () {
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();
                  if (email.isNotEmpty && password.isNotEmpty) {
                    final loginDto = LoginDTO(email: email, password: password);
                    context.read<AuthViewModel>().login(loginDto);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/register'),
                child: const Text("Don't have an account? Sign Up"),
              )
            ],
          ),
        ),
      ),
    );
  }
}