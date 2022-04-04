import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PreviewPdf extends StatefulWidget {
  String url, name;
  PreviewPdf({Key? key, required this.url, required this.name})
      : super(key: key);

  @override
  State<PreviewPdf> createState() => _PreviewPdfState();
}

class _PreviewPdfState extends State<PreviewPdf> {
  // PDFDocument? document;
  final PdfViewerController _pdfViewerController = PdfViewerController();
  GlobalKey<SfPdfViewerState> _key = GlobalKey();
  @override
  void initState() {
    super.initState();
    // setPdfPreview();
  }

  // setPdfPreview() async {
  //   try {
  //     PDFDocument doc = await PDFDocument.fromURL(
  //         "https://firebasestorage.googleapis.com/v0/b/go-to-chanthaburi.appspot.com/o/pdf%2FTest_PDF.pdf?alt=media&token=afb56d12-3261-4050-952d-73b85aedef80");
  //     setState(() {
  //       document = doc;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       document = null;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.themeApp,
        title: Text(widget.name),
      ),
      body: Center(
        child: widget.url.isEmpty
            ? const Center(
                child: Text("ไม่พบไฟล์"),
              )
            : SfPdfViewer.network(
                widget.url,
                controller: _pdfViewerController,
                key: _key,
                onDocumentLoadFailed: (details) => const Center(
                  child: Text("ไม่พบไฟล์"),
                ),
                onDocumentLoaded: (details) => const PouringHourGlass(),
              ),
      ),
    );
  }
}
