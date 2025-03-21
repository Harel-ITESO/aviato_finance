import 'package:aviato_finance/components/application_button.dart';
import 'package:aviato_finance/modules/authentication/login/widgets/other_options.dart';
import 'package:aviato_finance/modules/authentication/widgets/form_input.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          FormInput(
            controller: emailController,
            leadingIcon: Icon(Icons.mail_outline),
            hint: Text("E-mail"),
          ),
          SizedBox(height: 20),
          FormInput(
            controller: passwordController,
            leadingIcon: Icon(Icons.key_outlined),
            isPassword: true,
            hint: Text("Password"),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ApplicationButton(
              type: ButtonType.primary,
              isDark: true,
              onPressed: () {
                Navigator.pushNamed(context, "/home");
              },
              child: Text("Log In"),
            ),
          ),
          SizedBox(height: 20),
          OtherOptionsSection(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80, // Adjust the width as needed
                height: 1,
                color: Colors.white,
              ),
              const SizedBox(width: 16), // Space between the divider and text
              const Text('or', style: TextStyle(color: Colors.white)),
              const SizedBox(width: 16), // Space between the text and divider
              Container(
                width: 80, // Adjust the width as needed
                height: 1,
                color: Colors.white,
              ),
            ],
          ),

          // other login options
          SizedBox(height: 20),

          ApplicationButton(
            type: ButtonType.contrast,
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  width: 60,
                  "https://imgs.search.brave.com/cMeR-TEzSzc3L_T_t4c0ZKSZu5B4BxkMPGrZ48urikE/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9jZG4x/Lmljb25maW5kZXIu/Y29tL2RhdGEvaWNv/bnMvZ29vZ2xlLXMt/bG9nby8xNTAvR29v/Z2xlX0ljb25zLTA5/LTUxMi5wbmc",
                ),
                Text("Sign in with Google"),
              ],
            ),
          ),

          SizedBox(height: 10),
          ApplicationButton(
            type: ButtonType.contrast,
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  width: 50,
                  "https://cdn3.iconfinder.com/data/icons/picons-social/57/16-apple-512.png",
                ),
                Text("Sign in with Apple"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
