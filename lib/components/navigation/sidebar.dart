import 'dart:io';
import 'package:aviato_finance/components/application_button.dart';
import 'package:aviato_finance/modules/authentication/auth_service.dart';
import 'package:aviato_finance/utils/Providers/dark_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  final authS = AuthService();
  final picker = ImagePicker();
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _loadImagePath();
  }

  Future<void> _loadImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _imagePath = prefs.getString('profileImagePath');
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImagePath', pickedFile.path);
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userName = authS.currentUser?.email ?? '';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final bgColor = isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFe5f4e3);

    return Consumer<DarkModeProvider>(
      builder: (context, provider, child) {
        return Drawer(
          backgroundColor: bgColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDarkMode ? Colors.white54 : Colors.green,
                            width: 3,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: _imagePath != null ? FileImage(File(_imagePath!)) : null,
                          backgroundColor: Colors.white,
                          child: _imagePath == null
                              ? Icon(Icons.person, size: 50, color: Colors.grey)
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Divider(color: Colors.grey.shade400),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Dark Mode",
                          style: TextStyle(fontSize: 16, color: textColor),
                        ),
                        Switch(
                          value: provider.getDarkModeValue(),
                          activeColor: Colors.green,
                          onChanged: (value) => provider.setDarkMode(value),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: ApplicationButton(
                  type: ButtonType.contrast,
                  onPressed: () async {
                    await authS.signOut();
                    if (context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout),
                      SizedBox(width: 8),
                      Text("Logout"),
                    ],
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