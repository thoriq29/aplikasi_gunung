import 'package:aplikasi_gunung/user/home.dart';
import 'package:flutter/material.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 5000), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/splashscreen.png',
                height: 65,
                width: double.infinity,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Made With \u2665  |  \u00A9 2022',
                style: TextStyle(
                  fontSize: 11,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
