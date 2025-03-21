import 'package:flutter/material.dart';

class OtherOptionsSection extends StatelessWidget {
  const OtherOptionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: Text("Forgot password?"),
          ),

          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, "/register");
            },
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: Text("Sign up"),
          ),
        ],
      ),
    );
  }
}
