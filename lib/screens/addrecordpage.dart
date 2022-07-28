import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
class AddRecordPage extends StatefulWidget {
  const AddRecordPage({Key? key}) : super(key: key);
  @override
  State<AddRecordPage> createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage> {
  InputDecoration decoration(String label) => InputDecoration(
    labelText: label,
    border: OutlineInputBorder(),
  );
  TextEditingController sampledata1 = new TextEditingController();
  TextEditingController sampledata2 = new TextEditingController();
  TextEditingController sampledata3 = new TextEditingController();
  TextEditingController sampledata4 = new TextEditingController();
  TextEditingController sampledata5 = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Book Details"),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          const SizedBox(
            height: 30,
          ),
          TextField(
            controller: sampledata1,
            decoration: decoration('Book Name'),
          ),
          const SizedBox(
            height: 24,
          ),
          TextField(
            controller: sampledata2,
            decoration: decoration('Book Author'),
          ),
          const SizedBox(
            height: 24,
          ),
          TextField(
            controller: sampledata3,
            decoration: decoration('Book Edition'),
          ),
          const SizedBox(
            height: 24,
          ),
          TextField(
            controller: sampledata4,
            decoration: decoration('ISBN Number'),
          ),
          const SizedBox(
            height: 24,
          ),
          TextField(
            controller: sampledata5,
            decoration: decoration('Count'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(
            height: 24,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              child: Text("ADD"),
              onPressed: () {
                Map<String, dynamic> data = {
                  "BookName": sampledata1.text,
                  "BookAuthor": sampledata2.text,
                  "BookEdition": sampledata3.text,
                  "BookISBN": sampledata4.text,
                  "BookCount": sampledata5.text
                };
                FirebaseFirestore.instance.collection("books").add(data);
                //Navigator.of(context).pushNamed("addrecordpage");
                //Navigator.pop(context); -- this will go back to previous page
              })
        ],
      ),
    );
  }
}