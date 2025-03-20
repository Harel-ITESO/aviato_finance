import 'package:aviato_finance/home.dart';
import 'package:flutter/material.dart';
import 'package:aviato_finance/screens/add_Data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
      //Add the routes here and then go to home.dart to add the navigation
      routes: {
        '/addData': (context) => const AddData(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
