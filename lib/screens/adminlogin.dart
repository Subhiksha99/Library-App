import 'package:flutter/material.dart';
import 'admincontrolpage.dart';

class AdminLogin extends StatelessWidget {
  String email="";
  String passw="";
  InputDecoration decoration(String label) => InputDecoration(
    labelText: label,
    border: OutlineInputBorder(),
  );
    AdminLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADMIN LOGIN PAGE'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Image(image: AssetImage('assets/login.png')),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
              decoration: decoration('EMAIL'),
          onChanged: (val){
                email = val;
          },
          keyboardType: TextInputType.emailAddress

          ),

          const SizedBox(
            height: 24,
          ),
          TextField(
              decoration: decoration('PASSSWORD'),
              onChanged: (val){
                passw = val;
              },
              keyboardType: TextInputType.visiblePassword),
          const SizedBox(
            height: 24,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
            ),
            child: Text("LOGIN"),
            onPressed: () {
              if(email=="admin"){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminControlPage()));
              }else{
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>  AdminLogin()));
              }

            },
          )
        ],
      ),
    );
  }
}