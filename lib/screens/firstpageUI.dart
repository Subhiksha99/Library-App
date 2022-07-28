import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_app/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UIDesign extends StatefulWidget {
  const UIDesign({Key? key}) : super(key: key);

  @override
  State<UIDesign> createState() => _UIDesignState();
}

class _UIDesignState extends State<UIDesign> {
  List displayList=[];
  @override
  void initState(){
    super.initState();
    print("inside initstate");
    fetchData();
  }
  fetchData() async{
    DatabaseManager db=new DatabaseManager();
    print("db connected");
    var querySnapshot = await DatabaseManager.books.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
    print("getin");
    displayList.add(data);
    }
    print("length");
    print(displayList.length);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(

        child:ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          children:<Widget>[
            Padding(
                padding: EdgeInsets.only(left:25,top:25),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Hi user',style:GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    )),
                    Text('Discover Knowledge ',style:GoogleFonts.openSans(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    )),
                  ],
                )


            ),
            Container(
              height: 39,
              margin:EdgeInsets.only(left:25,right: 25,top:18),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black12
              ),
              child:Stack(
                children: <Widget>[
                  TextField(
                    style: GoogleFonts.openSans(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w600
                    ),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left:19,right:50,bottom:10),
                        border:InputBorder.none,
                        hintText: 'Search book..',
                        hintStyle: GoogleFonts.openSans(
                            fontSize: 12,
                            color: Colors.black12,
                            fontWeight: FontWeight.w600
                        )

                    ),
                  ),
                  Positioned(
                      right: 0,
                      child:IconButton(
                        icon: Icon(Icons.search),
                        onPressed: (){},
                      )
                  )
                ],
              ),
            ),
            Container(
              height: 25,
              margin:EdgeInsets.only(top:30),
              padding:EdgeInsets.only(left:25),
              child:Text("Popular book",style:GoogleFonts.openSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              )),
            ),
            Container(
                margin:EdgeInsets.only(top:21),
                height:210,
                child:ListView.builder(
                    itemCount: 3,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index)
                    {return Container(
                      height: 210,
                      width:153,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.cyan,
                        /*image:DecorationImage(
                          image: NetworkImage(
                            (displayList[index]['image']),
                          ),
                        ),*/
                      ),
                    );

                    }
                )
            ),
            Padding(
                padding: EdgeInsets.only(left:25,top:25),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Book Stack',style:GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    )),

                  ],
                )
            ),
            Column(
            children:<Widget>[
              ListView.builder(
              itemCount: 2,
                itemBuilder: (context,index){
                return Container(
                  child:Text('hello'),
                );
                })
        ]
            ),


           /*ListView.builder(itemCount:displayList.length,itemBuilder: (context,index){
              return Container(
                margin:EdgeInsets.only(bottom:19),
                height:81,
                width: 10,
                color:Colors.black12,
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 81,
                      width:62,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image:DecorationImage(
                          image: NetworkImage(
                            (displayList[index]['image']),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width:21),
                    Column(
                      children: <Widget>[
                        Text(displayList[index]['Author']),
                      ],
                    )
                  ],
                ),
              );
            })*/
          ],
        ),
      ),
    );
  }
}


/*class UIDesign extends StatelessWidget {
   UIDesign({Key? key}
   ) : super(key: key);

   Future _getThingsOnStartup() async {
     await Future.delayed(Duration(seconds: 2));
   }  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        child:ListView(
          children:<Widget>[
            Padding(
              padding: EdgeInsets.only(left:25,top:25),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Hi user',style:GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  )),
                  Text('Discover Knowledge ',style:GoogleFonts.openSans(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  )),
                ],
              )


            ),
            Container(
              height: 39,
                margin:EdgeInsets.only(left:25,right: 25,top:18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black12
                ),
                child:Stack(
                children: <Widget>[
                  TextField(maxLengthEnforced: true,
                      style: GoogleFonts.openSans(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w600
                      ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left:19,right:50,bottom:10),
                      border:InputBorder.none,
                      hintText: 'Search book..',
                      hintStyle: GoogleFonts.openSans(
                        fontSize: 12,
                        color: Colors.black12,
                        fontWeight: FontWeight.w600
                      )

                    ),
                  ),
                  Positioned(
                    right: 0,
                      child:IconButton(
                    icon: Icon(Icons.search),
                    onPressed: (){},
                  )
                  )
                ],
            ),
            ),
            Container(
              height: 25,
                margin:EdgeInsets.only(top:30),
              padding:EdgeInsets.only(left:25),
              child:Text("Popular book",style:GoogleFonts.openSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              )),
            ),
            Container(
              margin:EdgeInsets.only(top:21),
              height:210,
              child:ListView.builder(
                itemCount: 3,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context,index)
              {return Container(
                height: 210,
                  width:153,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.cyan,
                    image:DecorationImage(
                      image: NetworkImage(
                    (AssessBooks().displayList[index]['image']),
                  ),
                    ),
                  ),
              );

              }
              )
            ),
            Padding(
                padding: EdgeInsets.only(left:25,top:25),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Book Stack',style:GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    )),

                  ],
                )
   ),

            ListView.builder(itemCount: AssessBooks().displayList.length,itemBuilder: (context,index){
              return Container(
                margin:EdgeInsets.only(bottom:19),
                height:81,
                width: 10,
                color:Colors.black12,
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 81,
                      width:62,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image:DecorationImage(
                          image: NetworkImage(
                            (AssessBooks().displayList[index]['image']),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width:21),
                    Column(
                      children: <Widget>[
                        Text(AssessBooks().displayList[index]['book']),
                      ],
                    )
                  ],
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}*/
