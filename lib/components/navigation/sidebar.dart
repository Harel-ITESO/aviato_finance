import 'package:aviato_finance/components/application_button.dart';
import 'package:aviato_finance/modules/authentication/auth_service.dart';
import 'package:aviato_finance/utils/Providers/dark_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/colors.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DarkModeProvider>(
      builder: (
        BuildContext context,
        DarkModeProvider provider,
        Widget? child,
      ) {
        return Drawer(
          backgroundColor: customGreen,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    Row(
                      children: [
                        Text("Dark mode"),
                        Switch(
                          value: provider.getDarkModeValue(),
                          activeColor: Colors.black,
                          onChanged: (bool value) {
                            setState(() {
                              provider.setDarkMode(value);
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(45),
                child: ApplicationButton(
                  type: ButtonType.contrast,
                  onPressed: () async {
                    final authService = AuthService();
                    await authService.signOut();
                    if (context.mounted) {
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil('/login', (route) => false);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.logout), Text("Logout")],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
