import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'adminlogin.dart';
import 'login_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("READS"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Image(image: AssetImage('assets/lib.png')),
      ),
      /*RaisedButton(
        color: Colors.green,
        child: Text('Click'),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AdminLogin()));
        },
      ),*/
      floatingActionButton: SpeedDial(
          icon: Icons.login_outlined,
          backgroundColor: Colors.green,
          children: [
            SpeedDialChild(
              child: const Icon(
                Icons.admin_panel_settings_outlined,
                color: Colors.white,
              ),
              label: 'ADMIN',
              backgroundColor: Colors.green[300],
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>  AdminLogin()));
              },
            ),
            SpeedDialChild(
              child: const Icon(
                Icons.supervised_user_circle_rounded,
                color: Colors.white,
              ),
              label: 'USER',
              backgroundColor: Colors.green[300],
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginScreen()));
              },
            ),
          ]),
    );
  }
}