import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:library_app/screens/home_screen.dart';

import 'PDFViewerPage.dart';
class imagesearch extends StatefulWidget {
  const imagesearch({Key? key}) : super(key: key);

  @override
  State<imagesearch> createState() => _imagesearchState();
}

class _imagesearchState extends State<imagesearch> {
  File? image;
  String? message;
  static int fl=0;
  List<String> bookDetails=[];
  Future pickImage() async{
    final image=await ImagePicker().pickImage(source: ImageSource.gallery);
    if(image==null) return;
    final imageTemp=File(image.path);
    setState(() {
      this.image=imageTemp;
    });

  }
  uploadImage() async{
    print("entered");
   final request= http.MultipartRequest("GET",Uri.parse("https://be5c-14-139-190-106.in.ngrok.io/upload"));
   final headers={"Content-type":"multipart/form-data"};

   request.files.add(http.MultipartFile('image',image!.readAsBytes().asStream(),
   image!.lengthSync(),
   filename: image!.path.split('/').last));

   request.headers.addAll(headers);
   //request.send();
   final response= await request.send();
   http.Response res=await http.Response.fromStream(response);
   print(res);
   //final resjson=jsonDecode(res.body);
    Map<String, dynamic> map = json.decode(res.body);
    message  = map["message"];
   //message=resjson;
   print(message);
   String temp="";
   for(int i=4;i<message!.length;i++)
     {
         temp+=message![i];
     }
   //temp=actual image name with page no
    bookDetails=temp.split('_'); //bd[0]=bname, bd[1]=pgno
print("book name"+bookDetails[0]);
   DatabaseManager db=new DatabaseManager();
   print("db connected");
    var querySnapshot = await DatabaseManager.books.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      if(data['image_key']==bookDetails[0])
        {
       final file = await PDFApi.loadFirebase(data['e-book']);
        fl=1;
       if (file == null) return;
       print("opening pdf");
       openPDF(context, file);
     }
   }
   setState(() {

   });
  }
  /*Future getImage()async{
    ImagePicker obj=new ImagePicker();
    final image=await obj.pickImage(source:ImageSource.camera);
    setState(() {
      _image=image as File;
    });
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[300],
        title: Text('Image Search'),
      ),
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            image==null?Text("press the camera button and take the photo to search an image"):Image.file(image!),
            TextButton.icon(onPressed: uploadImage, icon: Icon(Icons.search), label: Text("search")),
            if (fl==1)
              Text('Book Name:'+bookDetails[0]+"\n Pg no:"+bookDetails[1]),



          ],
        )


      ),

      floatingActionButton: FloatingActionButton(
        onPressed: pickImage,
        tooltip: 'Increment',
        child: Icon(Icons.camera_alt),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );

  }
  static void openPDF(BuildContext context, File file) => Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
  );
}
