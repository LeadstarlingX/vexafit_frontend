import 'package:flutter/material.dart';

// A simple button to avoid needing your PrimaryButton widget for this test.
class SimpleButton extends StatelessWidget {
  final String text;
  const SimpleButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(text),
    );
  }
}

// This is the screen we will test.
class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We are building the layout directly here.
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              const Text(
                'Welcome to Vexafit',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign in to continue',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const Spacer(flex: 2),
              const TextField(
                decoration: InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 20),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              const Spacer(flex: 3),
              const SimpleButton(text: 'Login'),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {},
                child: const Text("Don't have an account? Sign Up"),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}