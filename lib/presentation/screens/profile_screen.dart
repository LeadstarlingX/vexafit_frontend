import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vexafit_frontend/presentation/viewmodels/theme/theme_view_model.dart';
import 'package:vexafit_frontend/presentation/widgets/primary_button.dart';
import '../viewmodels/auth/auth_view_model.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final themeViewModel = context.watch<ThemeViewModel>();
    final user = authViewModel.user;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const Spacer(flex: 2),
            const Icon(Icons.account_circle, size: 80),
            const SizedBox(height: 16),
            Text(
              user?.userName ?? 'Guest User',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              user?.email ?? 'No email available',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(flex: 1),

            // --- THIS IS THE NEW WIDGET ---
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: themeViewModel.themeMode == ThemeMode.dark,
              onChanged: (bool value) {
                themeViewModel.toggleTheme();
              },
              secondary: Icon(
                themeViewModel.themeMode == ThemeMode.dark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
              ),
            ),

            const Spacer(flex: 2),
            PrimaryButton(
              text: 'Logout',
              onPressed: () {
                context.read<AuthViewModel>().logout();
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
