import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vexafit_frontend/data/models/auth/register_dto.dart';
import 'package:vexafit_frontend/presentation/widgets/primary_button.dart';
import '../../viewmodels/auth/auth_view_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late final AuthViewModel _authViewModel;

  bool _isLengthValid = false;
  bool _hasUppercase = false;
  bool _hasDigit = false;
  bool _hasSpecialChar = false;

  @override
  void initState() {
    super.initState();
    _authViewModel = context.read<AuthViewModel>();
    _authViewModel.addListener(_onAuthStatusChanged);
    _passwordController.addListener(_validatePasswordRules);
  }

  @override
  void dispose() {
    _authViewModel.removeListener(_onAuthStatusChanged);
    _passwordController.removeListener(_validatePasswordRules);

    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePasswordRules() {
    final password = _passwordController.text;
    setState(() {
      _isLengthValid = password.length >= 6;
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasDigit = password.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  void _onAuthStatusChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (_authViewModel.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_authViewModel.errorMessage ?? 'An unknown registration error occurred.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        _authViewModel.acknowledgeError();
      }
      else if (_authViewModel.status == AuthStatus.authenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful! Please log in.'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/login');
      }
    });
  }

  Future<void> _onRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      final dto = RegisterDTO(
        userName: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        confirmPassword: _confirmPasswordController.text.trim(),
        role: RoleEnum.user,
      );

      final success = await _authViewModel.register(dto);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful! Please log in.'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authStatus = context.watch<AuthViewModel>().status;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) => (value == null || value.isEmpty) ? 'Please enter a username' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter an email';
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) return 'Please enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a password';
                  if (!_isLengthValid || !_hasUppercase || !_hasDigit || !_hasSpecialChar) {
                    return 'Please fulfill all password requirements.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _PasswordRequirement(text: 'At least 6 characters', isValid: _isLengthValid),
              _PasswordRequirement(text: 'An uppercase letter (A-Z)', isValid: _hasUppercase),
              _PasswordRequirement(text: 'A digit (0-9)', isValid: _hasDigit),
              _PasswordRequirement(text: 'A special character (e.g., !, @, #)', isValid: _hasSpecialChar),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text) return 'Passwords do not match';
                  return null;
                },
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Sign Up',
                isLoading: authStatus == AuthStatus.loading,
                onPressed: _onRegister,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/login'),
                child: const Text('Already have an account? Sign In'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _PasswordRequirement extends StatelessWidget {
  final String text;
  final bool isValid;
  const _PasswordRequirement({required this.text, required this.isValid});

  @override
  Widget build(BuildContext context) {
    final color = isValid ? Colors.green : Colors.red;
    final icon = isValid ? Icons.check_circle : Icons.cancel;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}