import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:learning_app/api/profileapi.dart';
import 'package:learning_app/controller/authcontroller.dart';
import 'package:learning_app/model_save/user.dart';
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
    final setuser=User()
    ..userId=user.userId!
    ..name=user.username
    ..email=user.email
    ..phone=user.phone.toString()??"00"
    ..image=user.image!
    ..role=user.role;
    final userBox =Hive.box<User>('userBox');
    await userBox.put('currentUser', setuser);
    // Timer(Duration(seconds: 5),()=>context.go('/test'));
    if (user == Error()) {
            SnackBar(content: Text("unsuccessfull user fetch"),);
            GoRouter.of(context).go('/login');
        } else {
      print(user); 
      GoRouter.of(context).go("/");
        }
    // );
  }

  @override
  Widget build(BuildContext context) {
    // set theme according to system
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: CircleAvatar(
          radius: 80,
          backgroundImage: Image.asset('lib/assets/image.png').image,
        ), // simple splash loader
      ),
    );
  }
}
