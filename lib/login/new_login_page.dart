import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_app/api/profileapi.dart';
import 'package:learning_app/controller/authcontroller.dart';
import 'package:learning_app/login/otp_page.dart';
import 'package:learning_app/models/user_model.dart';
import 'package:learning_app/utils/app_snackbar.dart';
import 'package:learning_app/widgets/customBoldText.dart';
import 'package:learning_app/widgets/customButtonOne.dart';
import 'package:learning_app/widgets/customTextBox.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewLoginPage extends ConsumerStatefulWidget {
  const NewLoginPage({super.key});

  @override
  ConsumerState<NewLoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<NewLoginPage> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      // appBar: AppBar(
      //   scrolledUnderElevation: 0,
      //   title:const Center(
      //     child: Customboldtext(
      //       text: "Login", fontValue: 30, 
      //     ),
      //   ),
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment:MainAxisAlignment.spaceEvenly ,
            children: [
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: const CircleAvatar(
                  backgroundImage: AssetImage('lib/assets/image.png'),
                  radius: 100,
                ),
              ),
              Customboldtext(text: "Login", fontValue: 30),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // const SizedBox(height: 30,),
                  Customtextbox(
                    hinttext: 'Email',
                    textController: _emailcontroller,
                    textFieldIcon: Icons.email,
                  ),
                  const SizedBox(height: 15),
                
              TextField(
                controller: _passwordcontroller,
                obscureText: _obscurePassword,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock_outline_rounded,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Password",
                  hintStyle: const TextStyle(color: Colors.black),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
                
              const SizedBox(height: 15),
                
              Custombuttonone(
                text: authState == "loading" ? 'Signing In...' : 'Sign In',
                onTap: () async {
                  FocusScope.of(context).unfocus();
                
                  // final pass = hashPasswordWithSalt(
                  //   _passwordcontroller.text,
                  //   "y6SsdIR",
                  // );
                  if (!isValidEmail(_emailcontroller.text, context)) return;
                  if (!isValidPassword(_passwordcontroller.text, context))
                    return;
                  bool success = await ref
                      .read(authControllerProvider.notifier)
                      .login(_emailcontroller.text, _passwordcontroller.text);
                  if (!success) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Invalid email or password'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    return;
                  }
                  final token = await ref
                      .read(authControllerProvider.notifier)
                      .getToken();
                
                  if (token == null) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Authentication error'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    return;
                  }
                  User person = await profileapi(token);
                  GoRouter.of(context).go('/');
                },
              ),
                
              // const SizedBox(height: 10),
                
             
                ],
              ),
                
               Custombuttonone(
                text: 'Go to Register',
                onTap: () {
                  context.push('/register');
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  String hashPasswordWithSalt(String password, String salt) {
    final combined = password + salt;
    final bytes = utf8.encode(combined);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}

bool isValidEmail(String email, BuildContext context) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  if (email.isEmpty) {
    AppSnackBar.show(
      context,
      message: "Email cannot be empty",
      type: SnackType.error,
    );
    return false;
  }

  if (!emailRegex.hasMatch(email)) {
    AppSnackBar.show(
      context,
      message: "Enter a valid email address",
      type: SnackType.error,
    );
    return false;
  }

  return true;
}

bool isValidPassword(String password, BuildContext context) {
  if (password.isEmpty) {
    AppSnackBar.show(
      context,
      message: "Password cannot be empty",
      type: SnackType.error,
    );
    return false;
  }

  if (password.length < 8) {
    AppSnackBar.show(
      context,
      message: "Password must be at least 8 characters",
      type: SnackType.error,
    );
    return false;
  }

  if (!RegExp(r'[A-Z]').hasMatch(password)) {
    AppSnackBar.show(
      context,
      message: "Password must contain at least 1 uppercase letter",
      type: SnackType.error,
    );
    return false;
  }

  if (!RegExp(r'[a-z]').hasMatch(password)) {
    AppSnackBar.show(
      context,
      message: "Password must contain at least 1 lowercase letter",
      type: SnackType.error,
    );
    return false;
  }

  if (!RegExp(r'[0-9]').hasMatch(password)) {
    AppSnackBar.show(
      context,
      message: "Password must contain at least 1 number",
      type: SnackType.error,
    );
    return false;
  }

  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
    AppSnackBar.show(
      context,
      message: "Password must contain at least 1 special character",
      type: SnackType.error,
    );
    return false;
  }

  return true;
}
