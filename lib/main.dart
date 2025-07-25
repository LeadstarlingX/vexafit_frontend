import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vexafit_frontend/core/dio/dio_client.dart';
import 'package:vexafit_frontend/core/theme/app_theme.dart';
import 'package:vexafit_frontend/infrastructure/repositories/auth_repository.dart';
import 'package:vexafit_frontend/infrastructure/repositories/workout_repository.dart';
import 'package:vexafit_frontend/infrastructure/services/workout_api_service.dart';
import 'package:vexafit_frontend/presentation/routes/app_router.dart';
import 'package:vexafit_frontend/presentation/viewmodels/auth/auth_view_model.dart';
import 'package:vexafit_frontend/presentation/viewmodels/workout/workout_view_model.dart';


void main() {
  // --- Dependency Injection Setup ---
  final dioClient = DioClient();
  final authRepository = AuthRepository(dioClient: dioClient);
  final workoutApiService = WorkoutApiService(dioClient: dioClient);
  final workoutRepository = WorkoutRepository(workoutApiService: workoutApiService);

  runApp(
    // Use MultiProvider to provide multiple ViewModels to the app
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel(authRepository)),
        ChangeNotifierProvider(create: (_) => WorkoutViewModel(workoutRepository)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Vexafit',
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
