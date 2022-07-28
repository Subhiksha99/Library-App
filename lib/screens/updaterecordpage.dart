import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:syncfusion_flutter_pdf/pdf.dart';

class UpdateRecordPage extends StatefulWidget {
  @override
  State<UpdateRecordPage> createState() => _UpdateRecordPageState();
}

class _UpdateRecordPageState extends State<UpdateRecordPage> {
  CollectionReference ref = FirebaseFirestore.instance.collection('book');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Book Details"),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder(
        stream: ref.snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            print("come inside");
            //var book=FirebaseFirestore.instance.collection("book").get();
            print(snapshot.data?.docs.length);
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  dynamic doc = snapshot.data?.docs[index].data;
                  List item=[];
                  item.add(doc);
                  print("inside");
                  print(item[index]['Author']);
                  return ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.grey,
                      onPressed: () {},
                    ),
                    title: Text(
                      item[index]['e-book'],
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Column(
                      children: <Widget>[
                        Text(
                          doc['Author'],
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          doc['Availability'],
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  );
                });
          } else
            return Text('');
        },
      ),
    );
  }
}