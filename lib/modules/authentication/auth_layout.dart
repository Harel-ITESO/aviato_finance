import 'package:aviato_finance/modules/authentication/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:aviato_finance/utils/app_loading_page.dart';
import 'package:aviato_finance/home.dart';
import 'package:aviato_finance/modules/authentication/login/login_view.dart';


class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    this.pageIfNotConnected,
  });

  final Widget? pageIfNotConnected;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, authService, child) {
        return StreamBuilder (
          stream: authService.authStateChanges,
           builder: (context, snapshot) {
          Widget widget;
          if (snapshot.connectionState == ConnectionState.waiting) {
            widget = AppLoadingPage();
          } else if (snapshot.hasData) {
            widget = const HomePage();
          } else {
            widget = pageIfNotConnected ?? const LoginView();
          }
          return widget;
        },
        );
      }
    );
  }
}