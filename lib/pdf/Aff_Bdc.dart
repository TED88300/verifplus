
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:printing/printing.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/pdf/BondeCommande.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';

class Aff_Bdc extends StatefulWidget {
  const Aff_Bdc({Key? key}) : super(key: key);

  @override
  Aff_BdcState createState() {
    return Aff_BdcState();
  }
}

class Aff_BdcState extends State<Aff_Bdc> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }



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
      title: InkWell(
        onTap: () async {
          await HapticFeedback.vibrate();
          Navigator.of(context).pop();
          },
        child:
        Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
          AutoSizeText(
            "BON DE COMMANDE",
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

      backgroundColor: gColors.white,
    );
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: appBar(),
      body: PdfPreview(
        maxPageWidth: 700,
        build: (format) => generateBC(),
        canDebug : false,
        canChangePageFormat : false,
        canChangeOrientation : false,

        onPrinted: _showPrintedToast,
        onShared: _showSharedToast,
      ),

    );
  }




}
