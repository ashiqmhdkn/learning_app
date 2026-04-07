import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_app/api/profileapi.dart';
import 'package:learning_app/controller/authcontroller.dart';
import 'package:learning_app/utils/app_snackbar.dart';
// your AuthController

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final token = await ref.read(authControllerProvider.notifier).getToken();

    if (token == null || token == "loading") {
      // No token → go to login
      GoRouter.of(context).go('/login');
    }
    // If you need profile API call:
    final user = await profileapi(token!);
    if (user != Error() && user.role == 'student') {
      GoRouter.of(context).go("/");
    } else {
      AppSnackBar.show(context, message: "unsuccessfull user fetch");
      GoRouter.of(context).go('/login');
    }
    // );
  }

  @override
  Widget build(BuildContext context) {
    // set theme according to system
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: CircleAvatar(
              radius: 80,
              backgroundImage: Image.asset('lib/assets/image.png').image,
            ),
            // simple splash loader
          ),
          const SizedBox(height: 30),
          Text(
            "A LEGACY OF SUCCESS FOR GENERATIONS",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
