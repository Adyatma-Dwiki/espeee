// ignore_for_file: prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:espeee/home.dart';
import 'package:flutter/material.dart';

import 'components/mybutton.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5CFF7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInDown(
              duration: Duration(seconds: 1),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Image.asset(
                  'assets/images/splash.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 40), // Add some spacing below the image
            FadeInDown(
                duration: Duration(seconds: 1),
                child: Center(
                    child: MyButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                  text: 'Tissue Whooper',
                ))),
          ],
        ),
      ),
    );
  }
}