import 'package:aviato_finance/home.dart';
import 'package:aviato_finance/modules/app_layout.dart';
import 'package:aviato_finance/modules/authentication/login/login_view.dart';
import 'package:aviato_finance/modules/authentication/register/register_view.dart';
import 'package:aviato_finance/modules/authentication/widgets/auth_gate.dart';
import 'package:aviato_finance/utils/Providers/dark_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:aviato_finance/modules/data_add/data_add_view.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) => DarkModeProvider(),
      child: const AviatoFinanceApp(),
    ),
  );
}

/* Consumer<DarkModeProvider>(
        builder: (context, darkMode ,child)=>{ */
class AviatoFinanceApp extends StatelessWidget {
  const AviatoFinanceApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DarkModeProvider>(
      create: (_) => DarkModeProvider(),
      child: Consumer<DarkModeProvider>(
        builder:
            (context, DarkModeProvider, child) => MaterialApp(
              title: 'Flutter Demo',
              theme:
                  DarkModeProvider.getDarkModeValue()
                      ? ThemeData.dark()
                      : ThemeData(
                        colorScheme: ColorScheme.fromSeed(
                          seedColor: Colors.deepPurple,
                        ),
                      ),

              home: const AuthGate(),
              //Add the routes here and then go to home.dart to add the navigation
              routes: {
                '/login': (context) => const LoginView(),
                '/register': (context) => const RegisterView(),
                '/app': (context) => const AppLayout(),
              },
            ),
      ),
    );
  }
}
