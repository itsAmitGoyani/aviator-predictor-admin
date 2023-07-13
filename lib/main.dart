import 'package:aviator_predictor_admin/screens/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aviator Predictor Admin',
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: const ColorScheme.dark(background: Colors.black)
            .copyWith(secondary: Colors.green),
      ),
      themeMode: ThemeMode.dark,
      home: const SplashScreen(),
    );
  }
}
