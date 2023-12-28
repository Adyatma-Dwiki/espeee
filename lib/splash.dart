// ignore_for_file: prefer_const_constructors, unused_import

import 'package:animate_do/animate_do.dart';
import 'package:espeee/loadingscreen.dart';
import 'package:flutter/material.dart';

import 'components/mybutton.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 192, 203, 1),
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
                  'assets/images/tr.gif',
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
                        builder: (context) => Loadscreen(),
                      ),
                    );
                  },
                  text: 'Tissuein Aja!',
                ))),
          ],
        ),
      ),
    );
  }
}
