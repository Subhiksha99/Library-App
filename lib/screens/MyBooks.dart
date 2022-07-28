import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'home_screen.dart';
class ExtractBook{

}
class MyBook extends StatefulWidget {
  static const routeName = '/MyBook';
  const MyBook({Key? key}) : super(key: key);

  @override
  State<MyBook> createState() => _MyBookState();
}

class _MyBookState extends State<MyBook> {
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
    dynamic resultant=await DatabaseManager().getmybooks();
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
      title: Text("Book Name:"+displayList[index]['book name']),
      subtitle: Text("category:"+displayList[index]['category']+"\nDue Date:"+displayList[index]['Due Date']+"\n"),

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
