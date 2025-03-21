import 'package:flutter/material.dart';

class AviatoDrawer extends StatelessWidget {
  final Function(int) onItemTapped;

  const AviatoDrawer({Key? key, required this.onItemTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromRGBO(169, 190, 109, 1),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Botón para cerrar el Drawer
          ListTile(
            title: Container(
              margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              alignment: Alignment.centerLeft,
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 40,
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.pop(context); // Cierra el drawer
            },
          ),
          
          // Elementos del Drawer
          _buildDrawerItem(
            icon: Icons.home,
            text: 'Home',
            onTap: () => _handleTap(context, 0),
          ),
          _buildDrawerItem(
            icon: Icons.add,
            text: 'Add',
            onTap: () => _handleTap(context, 1),
          ),
          _buildDrawerItem(
            icon: Icons.show_chart,
            text: 'Stats',
            onTap: () => _handleTap(context, 2),
          ),
        ],
      ),
    );
  }

  // Función para manejar la navegación y cerrar el Drawer
  void _handleTap(BuildContext context, int index) {
    onItemTapped(index);
    Navigator.pop(context);
  }

  // Widget para evitar código repetitivo en los ListTile
  Widget _buildDrawerItem({required IconData icon, required String text, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(text, style: const TextStyle(color: Colors.white)),
        onTap: onTap,
      ),
    );
  }
}
