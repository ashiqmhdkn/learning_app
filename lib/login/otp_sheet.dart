import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_app/api/otpapi.dart';
import 'package:learning_app/controller/authcontroller.dart';
import 'package:learning_app/models/user_model.dart';
import 'package:learning_app/utils/app_snackbar.dart';
import 'package:learning_app/widgets/customButtonOne.dart';

class OtpBottomSheet extends ConsumerStatefulWidget {
  final User user;
  final String password;

  const OtpBottomSheet({super.key, required this.password, required this.user});

  @override
  ConsumerState<OtpBottomSheet> createState() => _OtpBottomSheetState();
}

class _OtpBottomSheetState extends ConsumerState<OtpBottomSheet> {
  final List<TextEditingController> controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  String getOtp() {
    return controllers.map((c) => c.text).join();
  }

  void onOtpChange(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      sendOtp(widget.user.email);
      focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isFilled = getOtp().length == 6;

    return SafeArea(
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                "Verify Your E-mail",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),
              Text(
                "Please enter the 6-digit code we sent to",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 17),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 5),

              Text(
                widget.user.email,
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45,
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      controller: controllers[index],
                      focusNode: focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: "",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) => onOtpChange(index, value),
                    ),
                  );
                }),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () async {
                    final result = await sendOtp(widget.user.email);

                    AppSnackBar.show(
                      context,
                      message: result["message"],
                      type: result["success"]
                          ? SnackType.success
                          : SnackType.error,
                      showAtTop: true,
                    );
                  },
                  child: const Text(
                    "Send again",
                    style: TextStyle(color: Colors.blue, fontSize: 17),
                  ),
                ),
              ),
              const SizedBox(height: 5),

              Custombuttonone(
                text: "Continue",
                onTap: isFilled
                    ? () async {
                        final otp = getOtp();
                        final bool confirm = await verifyOtp(
                          email: widget.user.email,
                          otp: otp,
                        );
                        if (confirm) {
                          AppSnackBar.show(
                            context,
                            message: "OTP is correct",
                            type: SnackType.success,
                            showAtTop: true,
                          );
                          try {
                            final hashedPassword = hashPasswordWithSalt(
                              widget.password,
                              "y6SsdIR",
                            );

                            await ref
                                .read(authControllerProvider.notifier)
                                .register(
                                  email: widget.user.email,
                                  name: widget.user.username,
                                  role: widget.user.role,
                                  password: hashedPassword,
                                );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Registration successful'),
                              ),
                            );

                            GoRouter.of(context).go('/login');
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Registration failed: $e'),
                              ),
                            );
                          }
                        } else {
                          AppSnackBar.show(
                            context,
                            message: "Incorrect OTP",
                            type: SnackType.error,
                            showAtTop: true,
                          );
                        }
                      }
                    : null,
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
