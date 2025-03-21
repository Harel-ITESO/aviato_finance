import 'package:aviato_finance/modules/authentication/login/widgets/login_form.dart';
import 'package:aviato_finance/utils/colors.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: appColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/logo.png", width: 50),
            SizedBox(width: 15),
            Text("Aviato", style: TextStyle(color: Colors.white, fontSize: 40)),
          ],
        ),
      ),
      backgroundColor: appColor,
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Center(child: LoginForm()),
      ),
    );
  }
}
