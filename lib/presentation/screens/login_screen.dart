import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vexafit_frontend/data/models/auth/login_dto.dart';
import 'package:vexafit_frontend/presentation/widgets/primary_button.dart';

import '../viewmodels/auth/auth_view_model.dart';

// Converted to a StatefulWidget for more robust event handling.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    // We add a dedicated listener to the ViewModel in initState.
    // This is the most reliable way to react to state changes for one-time events.
    final authViewModel = context.read<AuthViewModel>();
    authViewModel.addListener(_onAuthStatusChanged);
  }

  @override
  void dispose() {
    // It's crucial to remove the listener and dispose controllers
    // to prevent memory leaks when the screen is destroyed.
    context.read<AuthViewModel>().removeListener(_onAuthStatusChanged);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// This function is the single handler for auth status changes.
  void _onAuthStatusChanged() {
    final authViewModel = context.read<AuthViewModel>();

    // Use a post-frame callback to safely handle navigation and UI events
    // immediately after the current build cycle is complete.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Check if the widget is still in the tree before trying to use its context.
      if (!mounted) return;

      if (authViewModel.status == AuthStatus.authenticated) {
        context.go('/home');
      }

      if (authViewModel.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authViewModel.errorMessage ?? 'An unknown error occurred.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        // After showing the error, reset the ViewModel's state so the user can try again.
        authViewModel.acknowledgeError();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // We use context.watch() here to rebuild the UI (specifically the button)
    // whenever the authStatus changes.
    final authStatus = context.watch<AuthViewModel>().status;

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
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Login',
                isLoading: authStatus == AuthStatus.loading,
                onPressed: () {
                  final email = _emailController.text.trim();
                  final password = _passwordController.text.trim();
                  if (email.isNotEmpty && password.isNotEmpty) {
                    final loginDto = LoginDTO(email: email, password: password);
                    // We use context.read() inside a callback as we only want to trigger an action, not listen.
                    context.read<AuthViewModel>().login(loginDto);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
