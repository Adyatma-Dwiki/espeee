// ignore_for_file: must_be_immutable, unnecessary_null_comparison

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final firebaseService = FirebaseDataService();
  List<String> upper150 = [];

  HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFFFC0CB), // Set scaffold background color to pink
      appBar: AppBar(
        title: const Text('Control Panel'),
        backgroundColor:
            Colors.transparent, // Make app bar background transparent
        elevation: 0, // Remove app bar elevation
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(11),
            child: Container(
              // Container for the image
              height: 300, // Adjust the height as needed
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/home.gif'), // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            // Container for the grid
            padding: EdgeInsets.only(left: 10, right: 10, top: 20),
            margin: const EdgeInsets.only(
                top:
                    300), // Adjust the margin to position the grid below the image
            child: StreamBuilder<List<DataItem>>(
              stream: FirebaseDataService().getDataStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                final data = snapshot.data;

                if (data == null || data.isEmpty) {
                  return const Center(
                    child: Text('No data available'),
                  );
                }

                List<String> upper150 = [];

                data.forEach((item) {
                  if (item.width >= 95) {
                    upper150.add(item.location);
                  }
                });

                if (upper150.isNotEmpty) {
                  showBelow100WidthDialog(context, upper150);
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return DataCard(
                      item: item,
                      firebaseService: firebaseService,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DataCard extends StatelessWidget {
  const DataCard({
    super.key,
    required this.item,
    required this.firebaseService,
  });

  final DataItem item;
  final FirebaseDataService firebaseService;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      margin: const EdgeInsets.all(2),
      child: Container(
        width: double
            .infinity, // Make the container take the full width of the screen
        child: FractionallySizedBox(
          widthFactor: 0.9, // Adjust the factor as needed for responsiveness
          child: Stack(
            children: [
              ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(top: 5, left: 5),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          children: [
                            Icon(Icons.location_pin),
                            SizedBox(width: 10),
                            Text('${item.location}'),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.toggle_on_rounded),
                          SizedBox(width: 10),
                          Text('Alat: ${item.state ? 'Nyala' : 'Mati'}')
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/tissue.png',
                            width: 24,
                            height: 24,
                          ),
                          SizedBox(width: 10),
                          Text('sisa: ${item.width} mm'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.01,
                right: MediaQuery.of(context).size.width * 0.02,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          title: const Text('Confirm Deletion'),
                          content: const Text(
                              'Are you sure you want to delete this item?'),
                          actions: [
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Delete'),
                              onPressed: () {
                                // Delete the item from Firebase
                                firebaseService.deleteData(item.id);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Delete'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FirebaseDataService {
  Stream<List<DataItem>> getDataStream() {
    final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    return databaseReference.onValue.map((event) {
      final Map<String, dynamic> dataMap =
          jsonDecode(jsonEncode(event.snapshot.value)) as Map<String, dynamic>;
      if (dataMap == null) {
        return <DataItem>[];
      }

      List<DataItem> dataList = [];

      dataMap.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          dataList.add(DataItem(
            id: key,
            location: value['Location'] ?? 'Unknown Location',
            state: value['State'] ?? false,
            width: value['Width'] ?? 0,
          ));
        }
      });

      return dataList;
    });
  }

  Future<void> deleteData(String id) async {
    final DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child(id);
    await databaseReference.remove();
  }
}

class DataItem {
  final String id;
  final String location;
  final bool state;
  final int width;

  DataItem(
      {required this.id,
      required this.location,
      required this.state,
      required this.width});
}

void showBelow100WidthDialog(BuildContext context, List<String> upper150) {
  if (upper150.isNotEmpty) {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
            title: const Text('Tissue sudah mau habis!'),
            content: Text(
                'Silakan ganti tissue ditempat ini: ${upper150.join(', ')}'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }
}
