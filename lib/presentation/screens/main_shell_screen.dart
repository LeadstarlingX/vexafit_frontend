import 'package:flutter/material.dart';

import 'exercise_screen.dart';
import 'profile_screen.dart';
import 'workout/workouts_screen.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _selectedIndex = 0;

  // The pages that correspond to the tabs in the navigation bar.
  static const List<Widget> _widgetOptions = <Widget>[
    WorkoutsScreen(),
    ExerciseScreen(),
    ProfileScreen(),
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
    // The router now handles redirection, so we don't need to listen for auth changes here.
    // This makes the widget simpler and more reliable.

    return Scaffold(
      appBar: AppBar(
        title: Text(_widgetTitles.elementAt(_selectedIndex)),
        automaticallyImplyLeading: false,
      ),
      // Using IndexedStack preserves the state of each screen when switching tabs.
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
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
      ),
    );
  }
}
