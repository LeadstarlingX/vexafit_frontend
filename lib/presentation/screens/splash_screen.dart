import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vexafit_frontend/presentation/widgets/loading_indicator.dart';
import '../viewmodels/auth/auth_view_model.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthViewModel>().checkInitialAuth();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authStatus = context.watch<AuthViewModel>().status;

    if (authStatus == AuthStatus.authenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/home');
      });
    } else if (authStatus == AuthStatus.unauthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/login');
      });
    }

    return const Scaffold(
      body: LoadingIndicator(),
    );
  }
}
