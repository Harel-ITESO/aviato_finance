import 'package:aviato_finance/home.dart';
import 'package:aviato_finance/modules/data_add/data_add_view.dart';
import 'package:aviato_finance/modules/stats/stats_view.dart';
import 'package:aviato_finance/utils/colors.dart';
import 'package:flutter/material.dart';

// Type of page
class Page {
  final String title;
  final Widget page;

  Page({required this.title, required this.page});
}

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class BottomNavigationBarIcon {}

class _AppLayoutState extends State<AppLayout> {
  final List<Page> _pages = [
    Page(title: "Aviato", page: HomePage()),
    Page(title: "Add", page: AddData()),
    Page(title: "Statistics", page: Stats()),
  ];
  int _currentPage = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  // Dynamically sets icon color if selected
  Color? setIconColor(int index) {
    if (_currentPage == index) {
      return Colors.white;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(backgroundColor: customGreen),
      appBar: AppBar(
        title: Text(_pages[_currentPage].title),
        surfaceTintColor: Colors.transparent,
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(child: _pages[_currentPage].page),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onItemTapped,
        indicatorColor: customGreen,
        selectedIndex: _currentPage,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home, color: setIconColor(0)),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline, color: setIconColor(1)),
            label: 'Add',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_rounded, color: setIconColor(2)),
            label: 'Stats',
          ),
        ],
      ),
    );
  }
}
