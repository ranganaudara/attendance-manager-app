import 'package:attendancemanagerapp/src/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget numberOfDays(_uid) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance
        .collection('users')
        .where("teacherUid", isEqualTo: _uid)
        .snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return Loading();
        default:
          return ListView(
            children:
            snapshot.data.documents.map((DocumentSnapshot document) {
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Image(image: AssetImage('assets/images/user.png')),
                    maxRadius: 20.0,
                    minRadius: 5.0,
                    backgroundColor: Colors.transparent,
                  ),
                  title: Text(document.data['firstName'] +
                      " " +
                      document.data['lastName']),
                  subtitle: Text(document.data['indexNum']),
                  trailing: Text(document.data['attendance'].toString()),
                ),
              );
            }).toList(),
          );
      }
    },
  );
}