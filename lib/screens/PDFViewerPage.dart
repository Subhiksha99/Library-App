import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';
//import 'package:syncfusion_flutter_pdf/pdf.dart';
//import 'package:fluttertoast/fluttertoast.dart';

import 'home_screen.dart';

class PDFViewerPage extends StatefulWidget {
  final File file;

  const PDFViewerPage({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  late PDFViewController controller;
  int pages = 0;
  int indexPage = 0;

  @override
  Widget build(BuildContext context) {
    final name = basename(widget.file.path);
    print("file name"+name);
    final text = '${indexPage + 1} of $pages';





      return Scaffold(
        appBar: AppBar(
          title: Text(name),
          backgroundColor: Colors.green[300],
          actions: pages >= 2
              ? [
            Center(child: Text(text)),
            IconButton(
              icon: Icon(Icons.chevron_left, size: 32),
              onPressed: () {
                final page = indexPage == 0 ? pages : indexPage - 1;
                controller.setPage(page);
              },
            ),
            IconButton(
              icon: Icon(Icons.chevron_right, size: 32),
              onPressed: () {
                final page = indexPage == pages - 1 ? 0 : indexPage + 1;
                controller.setPage(page);
              },
            ),
          ]
              : null,
          leading: IconButton(
            icon: Icon(Icons.search),
            onPressed: (){

            },
          ),
        ),
        body: PDFView(
          filePath: widget.file.path,

        ),
      );
    }
  }