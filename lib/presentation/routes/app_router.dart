import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/workout/workout_dto.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/main_app/main_shell_screen.dart';
import '../screens/workout_flow/select_exercise_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/workout_flow/create_workout_screen.dart';
import '../screens/workout_flow/workout_details_screen.dart';
import '../viewmodels/auth/auth_view_model.dart';

GoRouter createAppRouter(AuthViewModel authViewModel) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: authViewModel,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainShellScreen(),
        routes: [
          GoRoute(
            path: 'workout-details',
            builder: (context, state) {
              final workout = state.extra as WorkoutDTO?;
              if (workout == null) {
                return const Scaffold(body: Center(child: Text('Error: Workout data missing.')));
              }
              return WorkoutDetailsScreen(workout: workout);
            },
          ),
          GoRoute(
            path: 'create-workout',
            builder: (context, state) => const CreateWorkoutScreen(),
          ),
          GoRoute(
            path: 'select-exercise',
            builder: (context, state) => const SelectExerciseScreen(),
          ),
        ],
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final authStatus = authViewModel.status;
      final isLoggedIn = authStatus == AuthStatus.authenticated;

      // Define all public routes
      final isSplashScreen = state.matchedLocation == '/';
      final isLoggingIn = state.matchedLocation == '/login';
      final isRegistering = state.matchedLocation == '/register';

      if (authStatus == AuthStatus.unknown && isSplashScreen) {
        return null;
      }

      if (isLoggedIn && isLoggingIn) {
        return '/home';
      }


      if (!isLoggedIn && !isLoggingIn && !isRegistering) {
        return '/login';
      }

      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );
}
