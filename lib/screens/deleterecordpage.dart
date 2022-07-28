import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'home_screen.dart';

class DeleteRecordPage extends StatefulWidget {
  const DeleteRecordPage({Key? key}) : super(key: key);

  @override
  State<DeleteRecordPage> createState() => _DeleteRecordPageState();
}

class _DeleteRecordPageState extends State<DeleteRecordPage> {
  List displayList=[];
  bool fl=false;
  @override
  void initState(){
    super.initState();
    print("inside initstate");
    fetchData();
  }
  fetchData() async{
    print("getin");
    dynamic resultant=await DatabaseManager().getbooklist();
    if(resultant==null){
      print(" no record ");
    }
    else{
      setState(() {
        displayList=resultant;
        print(displayList);
        fl=true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home:Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green[500],
              title:new Text("My Books"),
            ),
            body:
            Container(

              child:ListView.builder(

                  itemCount: displayList.length,
                  itemBuilder: (context,index){
                    return Card(
                        child: ListTile(
                          title: Text("Book Name:"+displayList[index]['book_name']),
                          subtitle: Text("category:"+displayList[index]['category']),
                          onTap: ()async{
                            DatabaseManager.books.doc(displayList[index]['doc-id']).delete().then((_) {
                              print('deleted');
                            }
                            )

                                .catchError((error) => print('delete failed: $error'));
                            Navigator.of(context).pushNamed("DeleteRecordPage");
                          },
                        )

                    );
                  }
              )
              ,
            )
        )
    );
  }
}
