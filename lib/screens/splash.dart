import 'package:aviator_predictor_admin/screens/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
        builder: (BuildContext context) => HomeScreen(),
      ),
    );
  }

  @override
  void initState() {
    navigate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0.0),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Text(
            "Aviator Predictor Admin",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 34.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
