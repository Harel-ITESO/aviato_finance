import 'package:aviato_finance/utils/Providers/dark_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/colors.dart';

class SideBar extends StatefulWidget {
  const SideBar({
    super.key,
  });

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DarkModeProvider>(
      builder: (BuildContext context, DarkModeProvider provider, Widget? child) {  
        return Drawer(
          backgroundColor: customGreen,
          child: Column(
            children:[
              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
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
                    )
                  ],
                ),
              )

            ],
          ),
        );
      },
    );
  }
}