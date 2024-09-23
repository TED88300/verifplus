import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/pdf/Pdf_CR.dart';

import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/pdf/Pdf_CR_Ria.dart';

class Aff_CR_Ria extends StatefulWidget {
  const Aff_CR_Ria({Key? key}) : super(key: key);

  @override
  Aff_CR_RiaState createState() {
    return Aff_CR_RiaState();
  }
}

class Aff_CR_RiaState extends State<Aff_CR_Ria> with SingleTickerProviderStateMixin {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  Uint8List gwBdC = Uint8List.fromList([]);

  bool genBdC = false;

  @override
  void initLib() async {
    gwBdC = await generateCR();
    genBdC = true;
    setState(() {});
  }

  @override
  void initState() {
    initLib();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Color wColor = Colors.transparent;

  void _showPrintedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document printed successfully'),
      ),
    );
  }

  void _showSharedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document shared successfully'),
      ),
    );
  }

  @override
  AppBar appBar() {
    return AppBar(
      backgroundColor: gColors.white,
      automaticallyImplyLeading: false,
      title: InkWell(
        onTap: () async {
          await HapticFeedback.vibrate();
          Navigator.of(context).pop();
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
          AutoSizeText(
            "COMPTE-RENDU Ria",
            maxLines: 1,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
      ),
      leading: InkWell(
        onTap: () async {
          await HapticFeedback.vibrate();

          Navigator.of(context).pop();
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 10, 0, 10),
          child: DbTools.gBoolErrorSync
              ? Image.asset(
                  "assets/images/IcoWErr.png",
                )
              : Image.asset("assets/images/IcoW.png"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(),
        body: !genBdC
            ? Center(
                child: new Scaffold(
                    body: new Center(
                  child: new SizedBox(width: 40.0, height: 40.0, child: const CircularProgressIndicator()),
                )),
              )
            : PdfPreview(
                maxPageWidth: 700,
                build: (format) => generateCR_Ria(),
                canDebug: false,
                canChangePageFormat: false,
                canChangeOrientation: false,
                onPrinted: _showPrintedToast,
                onShared: _showSharedToast,
              ));
  }
}
