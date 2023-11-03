// ignore_for_file: prefer_const_constructors, unused_import

import 'package:animate_do/animate_do.dart';
import 'package:espeee/GridView.dart';


import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loadscreen extends StatefulWidget {
  const Loadscreen({Key? key}) : super(key: key);

  @override
  _LoadscreenState createState() => _LoadscreenState();
}

class _LoadscreenState extends State<Loadscreen> {
  @override
  void initState() {
    super.initState();
    
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => GridPage(), 
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFC0CB) ,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInDown(
              duration: Duration(seconds: 1),
              child: Lottie.network(
                'https://lottie.host/5e2741ba-a730-44b1-845d-fe6d92fa2431/6i3sZIrk11.json',
              ),
            ),
            FadeInDown(
              delay: Duration(milliseconds: 500),
              child: Text("Please wait,",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic,
                fontFamily: 'Poppins',
                color: Colors.white)),
            ),
            FadeInDown(
              delay: Duration(milliseconds: 500),
              child: Text("we're loading your data.",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Colors.white),),
            )
          ],
        ),
      ),
    );
  }
}
