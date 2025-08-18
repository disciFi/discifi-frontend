import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../dashboard/home_screen.dart';
import 'login_screen.dart';
import 'auth_controller.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    switch (authState) {
      case AuthState.authenticated:
        return const HomeScreen();
      case AuthState.unauthenticated:
        return const LoginScreen();
      case AuthState.unknown:
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
    }
  }
}