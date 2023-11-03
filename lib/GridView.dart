// ignore_for_file: must_be_immutable

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class GridPage extends StatelessWidget {
  final firebaseService = FirebaseDataService();
  
  List<String> below100IDs = [];

  GridPage({super.key});
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
              height: 350, // Adjust the height as needed
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
                    350), // Adjust the margin to position the grid below the image
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

                List<String> below100IDs = [];

                data.forEach((item) {
                  if (item.width <= 100) {
                    below100IDs.add(item.id);
                  }
                });

                if (below100IDs.isNotEmpty) {
                  showBelow100WidthDialog(context, below100IDs);
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
      elevation: 10, // Add elevation for a shadow effect
      margin: const EdgeInsets.all(10),

      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID: ${item.id}'),
              Text('Location: ${item.location}'),
              Text('State: ${item.state ? 'True' : 'False'}'),
              Text('Width: ${item.width} cm'),

              // Add buttons for actions
              const SizedBox(height: 90),
              Align(
                alignment: Alignment.bottomRight,
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
      final dataMap = event.snapshot.value as Map<String, dynamic>;
      List<DataItem> dataList = [];

      dataMap.forEach((key, value) {
        dataList.add(DataItem(
          id: key,
          location: value['Location'] ?? 'Unknown Location',
          state: value['State'] ?? false,
          width: value['Width'] ?? 0,
        ));
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

void showBelow100WidthDialog(BuildContext context, List<String> below100IDs) {
  if (below100IDs.isNotEmpty) {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Width Below 100'),
            content: Text(
                'The width of the toilet paper with ID(s) below 100 cm is: ${below100IDs.join(', ')}'),
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
