import 'dart:developer';

import 'package:aviato_finance/components/application_button.dart';
import 'package:aviato_finance/modules/authentication/widgets/form_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aviato_finance/modules/authentication/auth_service.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();
  String errorMessage = "";

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void register() async {
    try {
      // first register the user
      var user = await authService.value.createAccount(
        email: emailController.text,
        password: passwordController.text,
      );

      var email = user.user?.email;

      // login the user
      await authService.value.signIn(
        email: email!,
        password: passwordController.text,
      );
      goToApp(context);
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message ?? "An error occurred";
    }
  }

  void goToApp(BuildContext context) {
    Navigator.of(context).pushNamed("/app");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          FormInput(
            controller: emailController,
            hint: Text("E-mail"),
            leadingIcon: Icon(Icons.email_outlined),
          ),

          SizedBox(height: 20),
          FormInput(
            controller: passwordController,
            leadingIcon: Icon(Icons.key_outlined),
            isPassword: true,
            hint: Text("Password"),
          ),

          SizedBox(height: 20),
          FormInput(
            controller: repeatPasswordController,
            leadingIcon: Icon(Icons.key_outlined),
            isPassword: true,
            hint: Text("Confirm password"),
          ),
          SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ApplicationButton(
              type: ButtonType.primary,
              isDark: true,
              onPressed: () {
                if (passwordController.text == repeatPasswordController.text) {
                  register();
                } else {
                  print("Passwords do not match");
                }
              },
              child: Text("Sign up"),
            ),
          ),
        ],
      ),
    );
  }
}
