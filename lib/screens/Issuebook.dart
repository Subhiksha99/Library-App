import 'package:flutter/material.dart';

import 'home_screen.dart';

class Issuebook extends StatefulWidget {
  const Issuebook({Key? key}) : super(key: key);

  @override
  State<Issuebook> createState() => _IssuebookState();


}

class _IssuebookState extends State<Issuebook> {
  List displayList=[];
  void initState(){
    super.initState();
    print("inside initstate");
    fetchData();
  }
  fetchData() async{
    print("getin");
    dynamic resultant=await DatabaseManager().getIssuebooks();
    if(resultant==null){
      print(" no record ");
    }
    else{
      setState(() {
        displayList=resultant;
        print(displayList);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
          return ListView.builder(
          itemCount: displayList.length,
          itemBuilder: (context, index) {
            return Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text("Book Name:"+displayList[index]['book name']),
                    subtitle: Text("Author:"+displayList[index]['Author']+"\nCategory:"+displayList[index]['category']+"\nRequested User:"+displayList[index]['usermail']),
                          ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        child: const Text('issue book'),
                        onPressed: () async{
                          DateTime now = new DateTime.now();
                          DateTime date = new DateTime(now.year, now.month, now.day);
                           int duedt= now.day.toInt()+15;
                           String due=duedt.toString()+" "+now.month.toString()+" "+now.year.toString();
                          String datetime = date.toString();
                          print(datetime);

                         DatabaseManager.mybooks.doc(displayList[index]['doc-id']).update(
                              {'Due Date': due}).then((_) {
                            print('Updated');
                          }
                          )

                              .catchError((error) => print('Update failed: $error'));
                          /*DatabaseManager.mybooks.doc(displayList[index]['doc-id']).collection('borrowTable')
                              .doc(displayList[index]['doc-id']).update({
                            'Issued Date': datetime,
                            'Due Date' : due,
                          });*/

                        },

                      ),

                      const SizedBox(width: 5),
                    ],
                  ),
                ],
              ),
            );
          },
        );


  }
}
