import 'package:attendancemanagerapp/src/screens/about_screen.dart';
import 'package:flutter/material.dart';
class CustomDrawer extends StatelessWidget {
  final String name;
  final VoidCallback logOut;
  final VoidCallback addStudent;

  CustomDrawer({Key key, this.name, this.logOut, this.addStudent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: Text(""),
            accountName: Text('$name'),
            currentAccountPicture: CircleAvatar(
              child: Image(image: AssetImage('assets/images/user.png')),
              maxRadius: 30,
              minRadius: 10,
              backgroundColor: Colors.transparent,
            ),
          ),
          ListTile(
            title: Text('Add Students'),
            leading: Icon(Icons.person),
            onTap: addStudent,
          ),
          ListTile(
            title: Text('Feedback'),
            leading: Icon(Icons.feedback),
            onTap: () {},
          ),
          ListTile(
            title: Text('About'),
            leading: Icon(Icons.info),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutUsScreen(),
                ),
              );
            },
          ),
          Divider(
            height: 10.0,
          ),
          ListTile(
            title: Text('Log out'),
            leading: Icon(Icons.exit_to_app),
            onTap: logOut,
          ),
        ],
      ),
    );
  }
}
