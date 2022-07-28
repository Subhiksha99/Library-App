import 'package:flutter/material.dart';
import 'addrecordpage.dart';
import 'deleterecordpage.dart';
import 'updaterecordpage.dart';
import 'Issuebook.dart';

class AdminControlPage extends StatefulWidget {
  const AdminControlPage({Key? key}) : super(key: key);

  @override
  State<AdminControlPage> createState() => _AdminControlPageState();
}

class _AdminControlPageState extends State<AdminControlPage> {
  int currentIndex = 0;
  final screens = [
    AddRecordPage(),
    DeleteRecordPage(),
    Issuebook(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        backgroundColor: Colors.green,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        iconSize: 25,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delete),
            label: 'Delete',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Issue',
          ),
        ],
      ),
    );
  }
}