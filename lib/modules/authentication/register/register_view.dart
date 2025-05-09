
import 'package:aviato_finance/modules/authentication/register/widgets/register_form.dart';
import 'package:aviato_finance/utils/colors.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        child: Center(child: RegisterForm()),
      ),
    );
  }
}
