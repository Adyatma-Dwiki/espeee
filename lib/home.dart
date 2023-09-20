// ignore_for_file: prefer_const_constructors, unused_import

import 'package:animate_do/animate_do.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double rollerSpeedValue = 0.0; // Initial roller speed
  final double speedIncrement = 100.0; // Speed increment step
  final double speedDecrement = 100.0; // Speed decrement step
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference();
  String length = '- cm';
  String rollerSpeed = 'rpm';

  @override
  void initState() {
    super.initState();
    listenToLength();
    listenToRollerSpeed();
  }

  void updateRollerSpeed() {
    // Update the roller speed value in the database
    _databaseReference.child('Controller/RollerSpeed').set(rollerSpeedValue);
  }

  void listenToLength() {
    _databaseReference.child('Controller/Length').onValue.listen((event) {
      final value = event.snapshot.value;
      if (value != null && value is int) {
        setState(() {
          length = value.toString();
        });

        print('Length Value: $value'); // Add this line for debugging

        if (value <= 100) {
          print('Showing Popup...'); // Add this line for debugging

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Color.fromARGB(228, 113, 58, 190),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/danger.png',
                      fit: BoxFit.contain,
                    ),
                    Text(
                      'Warning!',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                        fontStyle: FontStyle.italic,
                        color: Color(0xffffffff),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Your tissue is almost done for doing his job, You must replace it with the other one',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                        color: Color(0xffffffff),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'OK',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }
      }
    });
  }

  void listenToRollerSpeed() {
    _databaseReference.child('Controller/RollerSpeed').onValue.listen((event) {
      final value = event.snapshot.value;
      if (value != null) {
        setState(() {
          rollerSpeed = value.toString();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5CFF7),
      body: ListView(// Wrap with ListView to enable scrolling
          children: [
        RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          onRefresh: () async {
            listenToLength();
            listenToRollerSpeed();
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FadeInDown(
                  duration: Duration(seconds: 1),
                  child: Container(
                    margin: EdgeInsets.only(top: 80),
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Image.asset(
                      'assets/images/snowglobe.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                FadeInDown(
                  duration: Duration(seconds: 1),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color(0x725b0888),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Center(
                      child: Text(
                        'Length : $length cm',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                          fontStyle: FontStyle.italic,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                FadeInDown(
                  duration: Duration(seconds: 1),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color(0x725b0888),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Center(
                      child: Text(
                        'Roller Speed : $rollerSpeed rpm',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                          fontStyle: FontStyle.italic,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          rollerSpeedValue += speedIncrement;
                          updateRollerSpeed();
                        });
                      },
                      icon: Icon(Icons.add),
                    ),
                    Text(
                      rollerSpeedValue
                          .toStringAsFixed(1), // Display roller speed value
                      style: TextStyle(fontSize: 20),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          rollerSpeedValue -= speedDecrement;
                          updateRollerSpeed();
                        });
                      },
                      icon: Icon(Icons.remove),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
