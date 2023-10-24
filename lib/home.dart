// ignore_for_file: prefer_const_constructors, unused_import, unused_local_variable

import 'package:animate_do/animate_do.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

import 'home2.dart';

class HomePage extends StatelessWidget {
  final String id;

  const HomePage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final firebaseService = FirebaseDataService();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE5CFF7),
        elevation: 0.00,
      ),
      backgroundColor: const Color(0xFFE5CFF7),
      body: StreamBuilder<List<DataItem>>(
        stream: firebaseService.getDataStream(item: id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text('No data available'),
            );
          }
        
          
          final item = snapshot.data![0];
        
        return SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FadeInDown(
                  duration: Duration(seconds: 1),
                  child: Container(
                    margin: EdgeInsets.only(top: 30),
                    width: MediaQuery.of(context).size.width *
                        0.8, // 80% of screen width
                    height: MediaQuery.of(context).size.width *
                        0.8, // 80% of screen width
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Image.asset(
                      'assets/images/home.gif',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 20), // Adjust spacing as needed
                FadeInDown(
                  duration: Duration(seconds: 2),
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        1, // 90% of screen width
                    height: MediaQuery.of(context).size.height * 1,
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 20), // Adjust spacing as needed
                          Text('ID: ${item.id}'),
                          SizedBox(height: 20),
                          Text('Location: ${item.location}'),
                          Text('State: ${item.state! ? 'True' : 'False'}'),
                          SizedBox(height: 20),
                          Text('Width: ${item.width}'),
                          SizedBox(height: 20),
                          CupertinoSwitch(
                            value: item.state!,
                            onChanged: (value) {
                               print("Switch value: $value");
                              FirebaseDatabase.instance
                                  .ref()
                                  .child(item.id!)
                                  .update({'State': value});
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
  }),
    );
  }
}

  // class _HomePageState extends State<HomePage> {
  //   double rollerSpeedValue = 0.0; // Initial roller speed
  //   final double speedIncrement = 100.0; // Speed increment step
  //   final double speedDecrement = 100.0; // Speed decrement step
  //   final DatabaseReference _databaseReference =
  //       FirebaseDatabase.instance.reference();
  //   String length = '- cm';
  //   String rollerSpeed = 'rpm';

  //   @override
  //   void initState() {
  //     super.initState();
  //     listenToLength();
  //   }

    
  //   void listenToLength() {
  //     _databaseReference.child('Controller/Length').onValue.listen((event) {
  //       final value = event.snapshot.value;
  //       if (value != null && value is double) {
  //         setState(() {
  //           length = value.toString();
  //         });

  //         print('Length Value: $value'); // Add this line for debugging

  //         if (value <= 100) {
  //           print('Showing Popup...'); // Add this line for debugging

  //           showDialog(
  //             context: context,
  //             builder: (BuildContext context) {
  //               return AlertDialog(
  //                 backgroundColor: Color.fromARGB(228, 113, 58, 190),
  //                 content: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Image.asset(
  //                       'assets/images/danger.png',
  //                       fit: BoxFit.contain,
  //                     ),
  //                     Text(
  //                       'Warning!',
  //                       style: TextStyle(
  //                         fontFamily: 'Poppins',
  //                         fontSize: 30,
  //                         fontWeight: FontWeight.w600,
  //                         height: 1.5,
  //                         fontStyle: FontStyle.italic,
  //                         color: Color(0xffffffff),
  //                       ),
  //                     ),
  //                     SizedBox(height: 10),
  //                     Text(
  //                       'Your tissue is almost done for doing his job, You must replace it with the other one',
  //                       style: TextStyle(
  //                         fontFamily: 'Poppins',
  //                         fontSize: 15,
  //                         fontWeight: FontWeight.w600,
  //                         height: 1.5,
  //                         color: Color(0xffffffff),
  //                       ),
  //                     ),
  //                     SizedBox(height: 10),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         TextButton(
  //                           onPressed: () {
  //                             Navigator.pop(context);
  //                           },
  //                           child: Text(
  //                             'OK',
  //                             style: TextStyle(
  //                               color: Colors.white,
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             },
  //           );
  //         }
  //       }
  //     });
  //   }

  //   @override
  //   Widget build(BuildContext context) {
  //     return Scaffold(
  //       backgroundColor: const Color(0xFFE5CFF7),
  //       appBar: AppBar(
  //         backgroundColor: const Color(0xFFE5CFF7),
  //         elevation: 0.0,
  //       ),
  //       body: Center(// Wrap with ListView to enable scrolling
  //           child: 
  //         RefreshIndicator(
  //           triggerMode: RefreshIndicatorTriggerMode.anywhere,
  //           onRefresh: () async {
  //             listenToLength();
  //           },
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start, 
  //             children: [
  //               FadeInDown(
  //                 duration: Duration(seconds: 1),
  //                 child: Container(
  //                   margin: EdgeInsets.only(top: 30),
  //                   width: 300,
  //                   height: 300,
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(20.0),
  //                   ),
  //                   child: 
  //                   // Image.asset(
  //                   //   'assets/images/snowglobe.png',
  //                   //   fit: BoxFit.contain,
  //                   // ),
                 
  //                    Image.asset('assets/images/home.gif', fit: BoxFit.contain,
  //                  )
  //                 ),
  //               ),
  //               SizedBox(height: 20),
  //               FadeInDown(
  //                 duration: Duration(seconds: 2),
  //                 child: Container(
  //                   width: 406,
  //                   height: 350,
  //                   decoration: BoxDecoration(
  //                     color: Color(0xffffffff),
  //                     borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(50),
  //                       topRight: Radius.circular(50),
  //                     ),
  //                   ),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment
  //                         .center, // Center the content horizontally
  //                     children: [
  //                       SizedBox(height: 40),
  //                       FadeInDown(
  //                         duration: Duration(seconds: 1),
  //                         child: Container(
  //                           width: MediaQuery.of(context).size.width - 40,
  //                           height: 50,
  //                           decoration: BoxDecoration(
  //                             color: Color(0x725b0888),
  //                             borderRadius: BorderRadius.circular(40),
  //                           ),
  //                           child: Center(
  //                             child:
  //                             Text(
  //                               'Length : $length cm',
  //                               textAlign: TextAlign.center,
  //                               style: TextStyle(
  //                                 fontFamily: 'Poppins',
  //                                 fontSize: 18,
  //                                 fontWeight: FontWeight.w600,
  //                                 height: 1.5,
  //                                 fontStyle: FontStyle.italic,
  //                                 color: Color(0xffffffff),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(height: 20),
                       
                        
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ]),
  //           ),
  //         ),
  //       );
  //   }
  // }


