import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vexafit_frontend/core/dio/dio_client.dart';
import 'package:vexafit_frontend/core/theme/app_theme.dart';
import 'package:vexafit_frontend/infrastructure/repositories/auth_repository.dart';
import 'package:vexafit_frontend/infrastructure/repositories/exercise_repository.dart';
import 'package:vexafit_frontend/infrastructure/repositories/workout_repository.dart';
import 'package:vexafit_frontend/infrastructure/services/exercise_api_service.dart';
import 'package:vexafit_frontend/infrastructure/services/workout_api_service.dart';
import 'package:vexafit_frontend/presentation/routes/app_router.dart';
import 'package:vexafit_frontend/presentation/viewmodels/auth/auth_view_model.dart';
import 'package:vexafit_frontend/presentation/viewmodels/exercise/exercise_view_model.dart';
import 'package:vexafit_frontend/presentation/viewmodels/theme/theme_view_model.dart';
import 'package:vexafit_frontend/presentation/viewmodels/workout/workout_details_view_model.dart';
import 'package:vexafit_frontend/presentation/viewmodels/workout/workout_view_model.dart';


void main()  {

  final dioClient = DioClient();
  final authRepository = AuthRepository(dioClient: dioClient);
  final workoutApiService = WorkoutApiService(dioClient: dioClient);
  final workoutRepository = WorkoutRepository(workoutApiService: workoutApiService);
  final exerciseApiService = ExerciseApiService(dioClient: dioClient);
  final exerciseRepository = ExerciseRepository(exerciseApiService: exerciseApiService);
  final authViewModel = AuthViewModel(authRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authViewModel),
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),

        ChangeNotifierProxyProvider<AuthViewModel, WorkoutViewModel>(
          create: (context) => WorkoutViewModel(workoutRepository, authViewModel),
          update: (context, auth, previousWorkoutViewModel) {
            previousWorkoutViewModel!..update();
            return previousWorkoutViewModel;
          },
        ),

        ChangeNotifierProvider(create: (_) => ExerciseViewModel(exerciseRepository)),
        ChangeNotifierProvider(create: (_) => WorkoutDetailsViewModel(workoutRepository)),
      ],
      child: Consumer<ThemeViewModel>(
        builder: (context, themeViewModel, child) {
          return MyApp(
            authViewModel: authViewModel,
            themeViewModel: themeViewModel,
          );
        },
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthViewModel authViewModel;
  final ThemeViewModel themeViewModel;

  const MyApp({
    super.key,
    required this.authViewModel,
    required this.themeViewModel,
  });

  @override
  Widget build(BuildContext context) {
    final GoRouter router = createAppRouter(authViewModel);

    return MaterialApp.router(
      title: 'Vexafit',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeViewModel.themeMode,
      routerConfig: router,
    );
  }
}
