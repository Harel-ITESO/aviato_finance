import 'package:aviato_finance/home.dart';
import 'package:aviato_finance/modules/app_layout.dart';
import 'package:aviato_finance/modules/authentication/login/login_view.dart';
import 'package:aviato_finance/modules/authentication/register/register_view.dart';
import 'package:flutter/material.dart';
import 'package:aviato_finance/modules/data_add/data_add_view.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      home: const AppLayout(),
      //Add the routes here and then go to home.dart to add the navigation
      routes: {
        '/addData': (context) => const AddData(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
      },
    );
  }
}
