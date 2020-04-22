import 'package:attendancemanagerapp/src/models/student.dart';
import 'package:attendancemanagerapp/src/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class PercentageTab extends StatefulWidget {
  PercentageTab(this.studentList,this._uid);
  final List<Student> studentList;
  final String _uid;

  @override
  _PercentageTabState createState() => _PercentageTabState();
}

class _PercentageTabState extends State<PercentageTab> {
  @override
  Widget build(BuildContext context) {
    List<Student> st = widget.studentList;
    List attendance  = [];
    st.forEach((s){
      s.attendance != null?
      attendance.add(s.attendance):attendance.add(0) ;
    });
    var largestValue = attendance.reduce((current, next) => current > next ? current : next);

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
                    trailing: Text(((document.data['attendance']*100/largestValue).round()).toString()+"%"),
                  ),
                );
              }).toList(),
            );
        }
      },
    );
  }
}
