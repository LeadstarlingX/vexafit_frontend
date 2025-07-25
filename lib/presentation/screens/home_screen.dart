import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/viewmodels/auth/auth_view_model.dart';
import '../../core/utils/token_storage.dart';
import '../viewmodels/workout/workout_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late WorkoutViewModel _workoutVM;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _workoutVM = context.read<WorkoutViewModel>();
      try {
        _workoutVM.fetchWorkouts();
      }
      catch (e,stack){
        print("----------------------------------");
        print("Home Screen");
        print('❌ Exception caught: $e');
        print('🔍 Stack trace:\n$stack');
        print("----------------------------------");
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();
    final user = authVM.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () async {
              await authVM.logout(); // clears auth state
              await TokenStorage.clearToken(); // clears stored token
            },
            icon: const Icon(Icons.logout, color: Colors.red),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Section
            Text(
              'Welcome, ${user?.userName ?? 'Guest'}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Email: ${user?.email ?? 'unknown'}'),
            const SizedBox(height: 12),
            const Text('Token:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            SelectableText(
              user?.token?.jwtToken ?? 'No token available',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),

            const Divider(height: 40),

            // Workouts Section
            const Text(
              'Your Workouts',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Consumer<WorkoutViewModel>(
              builder: (context, workoutVM, _) {
                if (workoutVM.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (workoutVM.error != null) {
                  return Center(child: Text('Error: ${workoutVM.error}'));
                } else if (workoutVM.workouts.isEmpty) {
                  return const Center(child: Text('No workouts found.'));
                } else {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: workoutVM.workouts.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final workout = workoutVM.workouts[index];
                      return ListTile(
                        title: Text(workout.name),
                        subtitle: Text(workout.description),
                        trailing: Text('${workout.durationInMinutes} min'),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
