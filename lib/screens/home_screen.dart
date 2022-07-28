
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_app/main.dart';
import 'package:library_app/screens/firstpageUI.dart';
import 'package:library_app/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'firebase_options.dart';
//import packets for reading pdf
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:library_app/screens/signup_screen.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'MyBooks.dart';
import 'PDFViewerPage.dart';
import 'admincontrolpage.dart';
import 'imagesearch.dart';

/*void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
      home: homepage()),
  );
}*/
class homepage extends StatefulWidget {
  static const routeName = '/home';

  const homepage({Key? key}) : super(key: key);
  @override
  State<homepage> createState() => _homepageState();
}
class PDFApi{
  static Future<File> loadFirebase(String url) async {
    //try {
    final refPDF = FirebaseStorage.instance.ref().child(url);
    final  bytes = await refPDF.getData();
    print('inside bytes');
    print(bytes);
    return _storeFile(url, bytes!);
    //} catch (e) {
    //print(e);
    //}
  }

  static Future<File> _storeFile(String url, List<int> bytes) async {
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}
class DatabaseManager{
  static var books=FirebaseFirestore.instance.collection('book');
  static var mybooks=FirebaseFirestore.instance.collection('borrowTable');
  static var querySnapshot;
  List itemsList=[];
  List userbook=[];
  static List docList=[];
  List IssueList=[];
  String ebook="";
  Future getbooklist() async{
    querySnapshot = await books.get();
    //var doc_id = DatabaseManager.querySnapshot.docs.reference.id.toString();
    //print(doc_id);

    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      var documentID = queryDocumentSnapshot.id;
      print(documentID);
      docList.add(documentID);
      data['doc-id']=documentID;
      print('document id'+data['doc-id']);
      var name = data['book_name'];
      var phone = data['Author'];
      ebook=data['e-book'];
      print(name);
      print(phone);
      itemsList.add(data);
//      itemsList.add(phone);

    }
    return itemsList;
  }
  Future getmybooks() async{

    var querySnapshot = await mybooks.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      var uname = data['usermail'];
      if(uname==_homepageState.Data['email'])
        {
          var documentID = queryDocumentSnapshot.id;
          data['doc-id']=documentID;
          userbook.add(data);
        }
//      itemsList.add(phone);
    else{
      userbook.add("nodata");
      }
    }
    return userbook;
  }
  Future getIssuebooks() async{

    var querySnapshot = await mybooks.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      var documentID = queryDocumentSnapshot.id;
      data['doc-id']=documentID;
      IssueList.add(data);
    }
    return IssueList;
  }
}
class CustomSearchDelegate extends SearchDelegate {
  // Demo list to show quering
  List searchItems=[];
  CustomSearchDelegate() {
    createitem();
  }

  createitem() async{
    dynamic resultant=await DatabaseManager().getbooklist();
    searchItems=resultant;

  }
  Future queryData(String query)async{
    return FirebaseFirestore.instance.collection('book').where(
      'Author',isGreaterThanOrEqualTo: query
    ).get();
  }
  // first overrite to
  // clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  // second overrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  // third overrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List matchQuery=[];
    /*for (var book in searchItems) {
      if (book==query) {
        print("book found")
        matchQuery.add(book);
      }
    }*/
//dynamic list=queryData(query);
    for(int i=0;i<searchItems.length;i++)
    {
      Map<String, dynamic> dummy = searchItems[i];
      if(query == searchItems[i]['book_name'] || query==searchItems[i]['Author']) {
        print("found");
        matchQuery.add(dummy);
      }

    }
    print(matchQuery);
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text("Book Name:"+matchQuery[index]['book_name']),
                subtitle: Text("Author:"+matchQuery[index]['Author']+"\nAvailability:"+matchQuery[index]['Availability'].toString()+"\nCategory:"+matchQuery[index]['category']+"\n"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Text('Read Book Online'),
                    onPressed: () async{
                      print("came inside");
                      final url = matchQuery[index]['e-book'];
                      print(url);
                      final file = await PDFApi.loadFirebase(url);

                      if (file == null) return;
                      _homepageState.openPDF(context, file);
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

  // last overrite to show the
  // quering process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchItems) {
      if (fruit==query.toLowerCase) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}
class _homepageState extends State<homepage> {
  int currentIndex = 0;
  final screens = [
   const imagesearch(),
    const MyBook(),
  ];
  List displayList=[];
  LoginScreen obj=new LoginScreen();
  static Map<dynamic,dynamic> Data=LoginScreen.setUsername();
  //SignupScreen obj1=new SignupScreen();

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
      print("unable to retrive");
    }
    else{
      setState(() {
        displayList=resultant;
        print(displayList);
      });
    }
  }
  void search() {
    print("inside search");
    String key="Cormen";
    for(int i=0;i<displayList.length;i++)
    {
      if(key==displayList[i]['book_name'])
        print("found");
      else
      {
        if(key==displayList[i]['Author'])
          print("book searched by author");
        else{
          print("No result");
        }

      }
    }
  }
  /*final FirebaseAuth firebaseauth=FirebaseAuth.instance;
  final GoogleSignIn googlesignin=GoogleSignIn();
  signin () async {
  final GoogleSignInAccount? googleuser=await googlesignin.signIn();
  final GoogleSignInAuthentication googleauth=await googleuser!.authentication;
  final AuthCredential credential=GoogleAuthProvider.credential(
    idToken: googleauth.idToken,accessToken:googleauth.accessToken
  );
  await firebaseauth.signInWithCredential(credential);
  }*/

  @override
  Widget build(BuildContext context) {
    TextEditingController sampledata1 = new TextEditingController();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title:new Text("READS"),
          /*leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: (){

            },

          ),*/
          actions:<Widget>[
            IconButton(onPressed: (){
              showSearch(
                  context: context,
                  // delegate to customize the search bar
                  delegate: CustomSearchDelegate()
              );
            },
                icon: Icon(Icons.search)
            ),
          ],
          bottom:PreferredSize(
        child: Container(
        color:Colors.white,
          height: 600,
          width:double.infinity,
            child:ListView(
              //physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
            children:<Widget>[
        Padding(
        padding: EdgeInsets.only(left:25,top:25),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Text("Hi "+Data['email'].split("@")[0],style:GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  )),
                  Text('Discover Knowledge ',style:GoogleFonts.openSans(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  )),
                ],
              ),
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
                      controller: sampledata1,
                      onTap: (){
                        showSearch(
                            context: context,
                            // delegate to customize the search bar
                            delegate: CustomSearchDelegate()
                        );
                      },
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
                            onPressed: (){
                              /*showSearch(
                                  context: context,
                                  // delegate to customize the search bar
                                  delegate: CustomSearchDelegate()
                              );*/
                            },

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
                      itemCount: displayList.length,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context,index)
                      {return Container(
                        margin: EdgeInsets.only(right: 19),
                        height: 210,
                        width:153,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.cyan,
                          image:DecorationImage(
                          image: NetworkImage(
                            (displayList[index]['image']),
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

              ListView.builder(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                //scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: displayList.length,
                itemBuilder: (context,index){
                  return Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading:CircleAvatar(
                            radius:70,
                            backgroundColor: Colors.white,
                            child: Container(
                              height:200,
                                width:200,
                              child: Image.network(
                                (displayList[index]['image']),
                                height: 600,
                                width: 600,
                              ),
                            ),
                  ),
                          title: Text("Book Name:"+displayList[index]['book_name'],style:GoogleFonts.openSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          )),
                          subtitle: Text("Author:"+displayList[index]['Author']+"\nAvailability:"+displayList[index]['Availability'].toString()+"\nCategory:"+displayList[index]['category']+"\n",style:GoogleFonts.openSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          )),
                          onTap:() {
                           // DatabaseManager().querySnapshot.data!.docs[index].reference.delete();
                          }
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextButton(
                              child: const Text('Read Book Online'),
                              onPressed: () async{
                                print("came inside");
                                final url = displayList[index]['e-book'];
                                print(displayList[index]['e-book']);
                                final file = await PDFApi.loadFirebase(url);

                                if (file == null) return;
                                openPDF(context, file);
                              },
                            ),
                            TextButton(
                              child: const Text('Borrow Book'),
                              onPressed: () async{
                                String bookName=displayList[index]['book_name'];
                                String author=displayList[index]['Author'];
                                int count=displayList[index]['Availability'];
                                if(count>0) {
                                  //snapshot.data!.docs[index].reference.id.toString()
                                  print("docid"+displayList[index]['doc-id']);
                                  DatabaseManager.books.doc(displayList[index]['doc-id']).update({'Availability' : count-1}).then((_) {
                                    print('Updated');
                                    Map<String, dynamic> data1 = {
                                      "book name": displayList[index]['book_name'],
                                      "Author": displayList[index]['Author'],
                                      "usermail": Data['email'],
                                      "category":displayList[index]['category'],
                                      "Issued Date":"",
                                      "Due Date":""
                                    };
                                    FirebaseFirestore.instance.collection("borrowTable").add(data1);
                                  }

                                  )
                                      .catchError((error) => print('Update failed: $error'));

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _buildPopupDialog(context),
                                  );
                                }
                              },
                            ),
                            const SizedBox(width: 5),
                            /*Image.network(
                              (displayList[index]['image']),
                              height: 200,
                              width: 200,
                            ),*/

                          ],
                        ),
                      ],
                    ),
                  );

                },
              ),

          ],
            )

        ),
        preferredSize: Size.fromHeight(600),
      ),
        ),

        /*drawer: Drawer(
          elevation: 16.0,
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(Data['email']),
                accountEmail: Text('2019506099'),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.pinkAccent,
                ),
              ),
              ListTile(
                title: Text('My Books'),
                leading:Icon(Icons.book),
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyBook()));
                },
              ),
              Divider(
                height: 0.1,
              ),
              ListTile(
                title: Text('History'),
                leading:Icon(Icons.history),
              ),
              Divider(
                height: 0.1,
              )
            ],
          ),
        ),*/

        /*body:Container(
          child:ListView.builder(
            shrinkWrap: true,
            itemCount: displayList.length,
            itemBuilder: (context,index){
              return Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                     ListTile(

                      title: Text("Book Name:"+displayList[index]['book_name']),
                      subtitle: Text("Author:"+displayList[index]['Author']+"\nAvailability:"+displayList[index]['Availability'].toString()+"\nCategory:"+displayList[index]['category']+"\n"),

                     ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: const Text('Read Book Online'),
                          onPressed: () async{
                            print("came inside");
                            final url = displayList[index]['e-book'];
                            print(displayList[index]['e-book']);
                            final file = await PDFApi.loadFirebase(url);

                            if (file == null) return;
                            openPDF(context, file);
                          },
                        ),
                        const SizedBox(width: 5),
                        Image.network(
                          (displayList[index]['image']),
                          height: 200,
                          width: 200,
                        ),

                      ],
                    ),
                  ],
                ),
              );

            },
          ),
        ),*/

        /*bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          backgroundColor: Colors.green,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          iconSize: 25,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              label: 'Image Search',
            ),


            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Issue',
            ),
          ],
        ),*/


       bottomNavigationBar: BottomAppBar(
          color:Colors.green,
          child: Container(
            child: Row(
              children: [
                IconButton(
                    icon:Icon(Icons.supervised_user_circle),
                    onPressed:(){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AdminControlPage()));
                    }
                ),
                IconButton(
                    icon:Icon(Icons.camera),
                    onPressed:(){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const imagesearch()));
                    }
                ),
                IconButton(
                  icon:Icon(Icons.book),
                      onPressed:(){
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => MyBook()));
    },

                ),
              ],
            ),

          ),
        ),
      ),
    );
  }
  static void openPDF(BuildContext context, File file) => Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
  );
  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Book Allocated'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Book is allocated for you , get the book from admin within 1 day, otherwise your request get cancelled"),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }
}



/*class scanner extends StatefulWidget {
  const scanner({Key? key}) : super(key: key);

  @override
  State<scanner> createState() => _scannerState();
}

class _scannerState extends State<scanner> {
  final qrKey=GlobalKey(debugLabel:'QR');
  QRViewController?controller;
  Barcode?barcode;
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  void onQRViewCreated(QRViewController controller){
    setState(()=>this.controller=controller);

    controller.scannedDataStream.listen((barcode)=>setState(()=> this.barcode=barcode));
  }
  Widget buildQrView(BuildContext context)=>QRView(
    key:qrKey,
    onQRViewCreated:onQRViewCreated,
    overlay: QrScannerOverlayShape(
      borderColor: Theme.of(context).cardColor,
      borderLength: 20,
      borderRadius: 10,
      borderWidth: 10,
      cutOutSize: MediaQuery.of(context).size.width*0.8,
    ),
  );

  Widget buildResult()=>Container(
      child:Text(
        barcode!=null?'Result:${barcode!.code}':'scan a qr code',
      )
  );

  void menufunc(){

  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("READS"),
          leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: menufunc),
        ),

        body:Stack(
          alignment: Alignment.center,
          children: <Widget>[
            buildQrView(context),
            Positioned(bottom:10,child:buildResult()),
          ],
        ),
      ),
    );


  }
}*/




/*class MyhomeApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final qrkey=GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  void dispose() {
    controller?.dispose();
    super.dispose();
  }

void menufunc(){}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: menufunc,
          ),
          title: new Text("READS"),
        ),
        body:Stack(
          alignment: Alignment.center,
          children: <Widget>[
            buildQrView(context),
          ],
        ),

      )
    );


  }
  Widget buildQrView(BuildContext context)=>QRView(
    key:qrKey,
    onQRViewCreated:onQRViewCreated,
    overlay: QrScannerOverlayShape(
      borderColor: Theme.of(context).cardColor,
      borderLength: 20,
      borderRadius: 10,
      borderWidth: 10,
      cutOutSize: MediaQuery.of(context).size.width*0.8,
    ),
  );
  void onQRViewCreated(QRViewController controller){
    setState(()=>this.controller=controller);
  }


}*/
