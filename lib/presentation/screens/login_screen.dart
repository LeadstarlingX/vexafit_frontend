import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vexafit_frontend/data/models/auth/login_dto.dart';
import 'package:vexafit_frontend/presentation/widgets/primary_button.dart';

import '../viewmodels/auth/auth_view_model.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    // --- THIS IS THE FIX ---
    // We use a Consumer to listen for changes and rebuild parts of the UI.
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {

        // This listener will handle navigation and showing errors.
        // It runs after the build is complete to avoid errors.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (authViewModel.status == AuthStatus.authenticated) {
            // Use go() to clear the navigation stack and go to home.
            context.go('/home');
          }
          if (authViewModel.status == AuthStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(authViewModel.errorMessage ?? 'An unknown error occurred.'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        });

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                    // The button's loading state is now tied to the ViewModel.
                    isLoading: authViewModel.status == AuthStatus.loading,
                    onPressed: () {
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();
                      if (email.isNotEmpty && password.isNotEmpty) {
                        final loginDto = LoginDTO(email: email, password: password);
                        // We use context.read() here because we are calling a function, not listening.
                        context.read<AuthViewModel>().login(loginDto);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
