import 'package:attendancemanagerapp/src/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PercentageTab extends StatefulWidget {
  PercentageTab(this._uid);
  final String _uid;

  @override
  _PercentageTabState createState() => _PercentageTabState();
}

class _PercentageTabState extends State<PercentageTab> {
  int totalClassDays = -1;
  @override
  void initState() {
    getTotalCLasses(widget._uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('users')
          .where("teacherUid", isEqualTo: widget._uid)
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
                    trailing: Text(
                        totalClassDays == -1 ? " " : ((document.data['attendance'] * 100 / totalClassDays).round()).toString() + "%"),
                  ),
                );
              }).toList(),
            );
        }
      },
    );
  }

  getTotalCLasses(String teacherUid) {
    Firestore.instance
        .collection('classes')
        .document(teacherUid)
        .get()
        .then((DocumentSnapshot ds) {
      // use ds as a snapshot
      setState(() {
        totalClassDays = ds["classDays"];
      });
    });
  }
}
