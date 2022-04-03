import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';

class PreviewPdf extends StatefulWidget {
  String url,name;
  PreviewPdf({Key? key, required this.url,required this.name}) : super(key: key);

  @override
  State<PreviewPdf> createState() => _PreviewPdfState();
}

class _PreviewPdfState extends State<PreviewPdf> {
  PDFDocument? document;

  @override
  void initState() {
    super.initState();
    setPdfPreview();
  }

  setPdfPreview() async {
    PDFDocument doc = await PDFDocument.fromURL(widget.url);
    setState(() {
      document = doc;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Center(
        child: document == null
            ? Center(child: CircularProgressIndicator())
            : PDFViewer(document: document!),
      ),
    );
  }
}
