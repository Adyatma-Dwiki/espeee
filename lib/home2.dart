// ignore_for_file: prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'home.dart';

class HomePageList extends StatelessWidget {
  const HomePageList({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5CFF7),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInDown(
              duration: Duration(seconds: 2),
              child: StreamDataGrid(),
            ),
          ],
        ),
      ),
    );
  }
}

class StreamDataGrid extends StatelessWidget {
  const StreamDataGrid({Key? key});

  @override
  Widget build(BuildContext context) {
    final firebaseService = FirebaseDataService();

    return StreamBuilder<List<DataItem>>(
      stream: firebaseService.getDataStream(item: null),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final data = snapshot.data;

          if (data != null && data.isNotEmpty) {
                return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: data.map((item) {
                  return GestureDetector(
                    onTap: (){  Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => HomePage(id: item.id!),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.all(10),
                      height: 150,
                      width: 600,
                      decoration: BoxDecoration(
                        color: Color(0xffffffff),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ID: ${item.id}'),
                                Text('Location: ${item.location}'),
                                Text('State: ${item.state! ? 'True' : 'False'}'),
                                Text('Width: ${item.width}'),
                              ],
                            ),
                          ),
                          
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}


class FirebaseDataService {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  Stream<List<DataItem>> getDataStream({param ='', required item}) {
    return _databaseReference.onValue.map((event) {
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
}

class DataItem {
  final String? id;
  final String? location;
  final bool? state;
  final int? width;

  DataItem({this.id, this.location, this.state, this.width});
}



