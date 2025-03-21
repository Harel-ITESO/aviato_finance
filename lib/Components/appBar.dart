import 'package:aviato_finance/Components/globalVariables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';

class AviatoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AviatoAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Icon(Icons.monetization_on_outlined, size: 40),
          Text(
            " Aviato",
            style: TextStyle(fontSize: 35, color: customGreen),
          ),
        ],
      ),
      leadingWidth: 100,
      leading: Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: const Icon(
              Icons.menu_rounded,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
