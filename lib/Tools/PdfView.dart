import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';


class PdfView extends StatefulWidget {

  final Widget pdf;

  const PdfView({Key? key, required this.pdf}) : super(key: key);


  @override
  _PdfViewState createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  void initLib() async {}

  @override
  void initState() {
    super.initState();
  }

  @override
  AppBar appBar() {
    return AppBar(
      title: InkWell(
        onTap: () async {
          await HapticFeedback.vibrate();
          Navigator.pop(context);
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
          AutoSizeText(
            "Vérif+ : Documents",
            maxLines: 1,
            style: gColors.bodyTitle1_B_G24,
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
      actions: <Widget>[
        IconButton(
          iconSize: 40,
          icon: gColors.wBoxDecoration(context),
          onPressed: () async {
            gColors.AffUser(context);
          },
        ),
      ],
      backgroundColor: gColors.white,
    );
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - 80;
    return Scaffold(
      appBar: appBar(),
      backgroundColor: gColors.primary,
      body: Container(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        color: gColors.white,
        child: Column(
          children: <Widget>[
            SizedBox(
              width: width,
              height: height,
              child: widget.pdf,
            )


          ],
        ),
      ),
    );
  }


}
