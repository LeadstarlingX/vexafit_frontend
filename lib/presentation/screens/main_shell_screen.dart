import 'package:flutter/material.dart';
import 'package:vexafit_frontend/presentation/screens/workouts_screen.dart';

// --- Placeholder Pages for the other Tabs ---
class ExercisesPagePlaceholder extends StatelessWidget {
  const ExercisesPagePlaceholder({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Exercises Page'));
}

class ProfilePagePlaceholder extends StatelessWidget {
  const ProfilePagePlaceholder({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Profile Page'));
}
// ------------------------------------

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _selectedIndex = 0;

  // The pages that correspond to the tabs in the navigation bar.
  static const List<Widget> _widgetOptions = <Widget>[
    // Replaced the placeholder with our real WorkoutsScreen!
    WorkoutsScreen(),
    ExercisesPagePlaceholder(),
    ProfilePagePlaceholder(),
  ];

  // The titles for the AppBar that correspond to each page.
  static const List<String> _widgetTitles = <String>[
    'Workouts',
    'Exercise Library',
    'Profile',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_widgetTitles.elementAt(_selectedIndex)),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workouts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Exercises',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        // Use the theme colors for the navigation bar
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.white70,
      ),
    );
  }
}
