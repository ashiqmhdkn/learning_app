import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_app/controller/authcontroller.dart';
import 'package:learning_app/widgets/customButtonOne.dart';
import 'package:learning_app/widgets/customTextBox.dart';

class NewRegisterPage extends ConsumerStatefulWidget {
  const NewRegisterPage({super.key});

  @override
  ConsumerState<NewRegisterPage> createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<NewRegisterPage> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _selectedRole='student';

  @override
  void dispose() {
    _emailcontroller.dispose();
    _namecontroller.dispose();
    _passwordcontroller.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Register",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('lib/assets/image.png'),
                radius: 80,
              ),

              const SizedBox(height: 30),

              Customtextbox(
                hinttext: 'User name',
                textController: _namecontroller,
                textFieldIcon: Icons.person_outline_rounded,
              ),

              const SizedBox(height: 15),

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
                  hintStyle: TextStyle(color: Colors.black),
                  hintText: "Password",
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: Colors.black,
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
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.black),
                  hintText: "Confirm Password",
                  prefixIcon: const Icon(
                    Icons.lock_reset_rounded,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Custombuttonone(
                text: 'Sign Up',
                onTap: () async {
                  if (_emailcontroller.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("email field free")),
                    );
                    return;
                  }
                  if (_namecontroller.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("name field free")),
                    );
                    return;
                  }
                  if (_selectedRole == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select a role")),
                    );
                    return;
                  }

                  if (_passwordcontroller.text !=
                      _confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Passwords do not match")),
                    );
                    return;
                  }

                  try {
                    // final hashedPassword = hashPasswordWithSalt(
                    //   _passwordcontroller.text,
                    //   "y6SsdIR",
                    // );
                     await ref
                        .read(authControllerProvider.notifier)
                        .register(
                          email: _emailcontroller.text,
                          name: _namecontroller.text,
                          role: _selectedRole!,
                          password: _passwordcontroller.text,
                        );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registration successful')),
                    );

                    GoRouter.of(context).go('/login');
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Registration failed: $e')),
                    );
                  }
                },
              ),
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
