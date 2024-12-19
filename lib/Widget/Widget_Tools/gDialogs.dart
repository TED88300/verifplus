import 'dart:convert';
import 'dart:io';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles_Ebp.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Art.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Img.dart';
import 'package:verifplus/Widget/Widget_Tools/ImagePainterTools.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gPhotos.dart';

class gDialogs {
  gDialogs();

  static Future<void> Dialog_QrCode(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => QrCodeDialog(),
    );
  }

  static Future<void> Dialog_Photo(BuildContext context, String wTxt, String wTxt2, String wTxt3) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => PhotoDialog(wTxt: wTxt, wTxt2: wTxt2, wTxt3: wTxt3),
    );
  }

  static Future<void> Dialog_MsgBox(BuildContext context, String wTxt, String wTxt2, String wTxt3, String wImg,  String wLabel1,  String wLabel2) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => MsgBoxDialog(wTxt: wTxt, wTxt2: wTxt2, wTxt3: wTxt3, wImg :wImg, wLabel1 :wLabel1, wLabel2 :wLabel2),
    );
  }



  static Future<void> Dialog_MiseEnServ(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => MiseEnServDialog(),
    );
  }

  static Future<void> Dialog_CdeDate(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => CdeDateDialog(),
    );
  }

  static Future<void> Dialog_SelPeriode(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => SelPeriodeDialog(),
    );
  }
}

//**********************************
//**********************************
//**********************************

class SelPeriodeDialog extends StatefulWidget {
  @override
  _SelPeriodeDialogState createState() => _SelPeriodeDialogState();
}

class _SelPeriodeDialogState extends State<SelPeriodeDialog> {
  bool isSel = false;

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      insetPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.transparent,
      backgroundColor: gColors.transparent,
      shadowColor: gColors.transparent,
      children: [
        Container(
            color: gColors.transparent,
            height: 220,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: 260,
                              height: 800,
                              padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: PopupMenuButton(
                                child: Tooltip(textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.normal), decoration: BoxDecoration(color: Colors.orange), message: "Filtre Date", child: Container(width: 10, height: 10, child: Image.asset("assets/images/DCL_Date.png"))),
                                onSelected: (value) async {
                                  if (value == "S0") {
                                    Srv_DbTools.selDateTools(0);
                                  }
                                  if (value == "S1") {
                                    Srv_DbTools.selDateTools(1);
                                  }
                                  if (value == "S2") {
                                    Srv_DbTools.selDateTools(2);
                                  }
                                  if (value == "S3") {
                                    Srv_DbTools.selDateTools(3);
                                  }
                                  if (value == "S4") {
                                    Srv_DbTools.selDateTools(4);
                                  }
                                  if (value == "S5") {
                                    Srv_DbTools.selDateTools(5);
                                  }
                                  if (value == "S6") {
                                    Srv_DbTools.selDateTools(6);
                                  }
                                  if (value == "S7") {
                                    Srv_DbTools.selDateTools(7);
                                  }
                                  if (value == "S8") {
                                    Srv_DbTools.selDateTools(8);
                                  }
                                  if (value == "S9") {
                                    Srv_DbTools.selDateTools(9);
                                  }
                                  if (value == "S1") {
                                    Srv_DbTools.selDateTools(1);
                                  }
                                },
                                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                                  PopupMenuItem(
                                    value: "S0",
                                    height: 36,
                                    child: Row(
                                      children: [
                                        Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
                                        Text(
                                          "Aujourd'hui",
                                          style: gColors.bodySaisie_N_G,
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: "S1",
                                    height: 36,
                                    child: Row(
                                      children: [
                                        Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
                                        Text(
                                          "Hier",
                                          style: gColors.bodySaisie_N_G,
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: "S2",
                                    height: 36,
                                    child: Row(
                                      children: [
                                        Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
                                        Text(
                                          "Avant hier",
                                          style: gColors.bodySaisie_N_G,
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: "S3",
                                    height: 36,
                                    child: Row(
                                      children: [
                                        Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
                                        Text(
                                          "Semaine courante",
                                          style: gColors.bodySaisie_N_G,
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: "S4",
                                    height: 36,
                                    child: Row(
                                      children: [
                                        Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
                                        Text(
                                          "Semaine précédente",
                                          style: gColors.bodySaisie_N_G,
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: "S5",
                                    height: 36,
                                    child: Row(
                                      children: [
                                        Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
                                        Text(
                                          "Semaine précédent la précédente",
                                          style: gColors.bodySaisie_N_G,
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: "S6",
                                    height: 36,
                                    child: Row(
                                      children: [
                                        Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
                                        Text(
                                          "Mois courant",
                                          style: gColors.bodySaisie_N_G,
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: "S7",
                                    height: 36,
                                    child: Row(
                                      children: [
                                        Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
                                        Text(
                                          "Mois précédent",
                                          style: gColors.bodySaisie_N_G,
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: "S8",
                                    height: 36,
                                    child: Row(
                                      children: [
                                        Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
                                        Text(
                                          "Mois précédent le précédent",
                                          style: gColors.bodySaisie_N_G,
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: "S9",
                                    height: 36,
                                    child: Row(
                                      children: [
                                        Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
                                        Text(
                                          "Année courante",
                                          style: gColors.bodySaisie_N_G,
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: "S10",
                                    height: 36,
                                    child: Row(
                                      children: [
                                        Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
                                        Text(
                                          "Année précédente",
                                          style: gColors.bodySaisie_N_G,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            )),
      ],
    );
  }
}


//**********************************
//**********************************
//**********************************

class MsgBoxDialog extends StatefulWidget {
  final String wTxt;
  final String wTxt2;
  final String wTxt3;

  final String wImg;
  final String wLabel1;
  final String wLabel2;



  const MsgBoxDialog({Key? key, required this.wTxt, required this.wTxt2, required this.wTxt3, required this.wImg, required this.wLabel1, required this.wLabel2}) : super(key: key);
  @override
  _MsgBoxDialogState createState() => _MsgBoxDialogState();
}

class _MsgBoxDialogState extends State<MsgBoxDialog> {


  static bool gRep = false;

  @override
  Future initLib() async {

  }

  @override
  void initState() {
    initLib();
  }

  @override
  Widget build(BuildContext context) {
    print(" Srv_DbTools.SelDCL_DateDeb ${Srv_DbTools.SelDCL_DateDeb}");

    double wWidth = 550;
    double wHeight = 1024;
    double wHeightDet = 580;
    double wHeightDet2 = 610;

    double wHeightBtn = 45;

    double wHeightBtnValider = 40;

    Widget Ctrl = Container(
      child:
      Column(

        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 8),
          child: Image.asset(
            "assets/images/${widget.wImg}.png",
            fit: BoxFit.cover,
            height: 100,
            width: 100,
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 4),
          width: wWidth,
          child: Text(
            widget.wLabel1,
            style: gColors.bodyTitle1_B_G,
            textAlign: TextAlign.center,
          ),
        ),
        Container(

          width: wWidth,
          child: Text(
            widget.wLabel2,
            style: gColors.bodyTitle1_B_G,
            textAlign: TextAlign.center,
          ),
        ),
      ],)
      ,
    );






    return SimpleDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.transparent,
      backgroundColor: gColors.transparent,
      shadowColor: gColors.transparent,
      children: [
        Stack(
          children: [
            Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                color: Colors.transparent,
                height: wHeight,
                child: Column(
                  children: [
// Titre
                    Container(
                        child: Container(
                          width: wWidth,
                          height: 155,
                          margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                          decoration: BoxDecoration(
                            color: Colors.yellowAccent,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: wWidth,
                                child: Text(
                                  widget.wTxt,
                                  style: gColors.bodyTitle1_B_G,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                width: wWidth,
                                child: Text(
                                  widget.wTxt2,
                                  style: gColors.bodyTitle1_N_G,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                width: wWidth,
                                child: Text(
                                  widget.wTxt3,
                                  style: gColors.bodyTitle1_N_G,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                height: 15,
                              ),
                              Container(
                                color: gColors.black,
                                height: 1,
                              ),
                            ],
                          ),
                        )),

                    Container(
                      height: wHeightDet,
                    ),


// Pied
                    Container(
                        child: Container(
                          width: wWidth,
                          height: 106,
                          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                          decoration: BoxDecoration(
                            color: gColors.LinearGradient3,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: gColors.black,
                                height: 1,
                              ),
                              Container(
                                height: 22,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: gColors.primaryRed,
                                    ),
                                    child: Container(
                                      width: 140,
                                      height: wHeightBtnValider,
                                      padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                                      child: Text(
                                        "Annuler",
                                        style: gColors.bodyTitle1_B_W24,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    onPressed: () async {
                                      gRep = false;
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: gColors.primaryGreen,
                                        side: const BorderSide(
                                          width: 1.0,
                                          color: gColors.primaryGreen,
                                        )),
                                    child: Container(
                                      width: 140,
                                      height: wHeightBtnValider,
                                      padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                                      child: Text(
                                        "Valider",
                                        style: gColors.bodyTitle1_B_W24,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    onPressed: () async {
                                      gRep = true;
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              )
                            ],
                          ),
                        )),
                  ],
                )),

            // Content
            Positioned(
                top: 190,
                left: 5,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  height: wHeightDet2,
                  width: wWidth,
                  child: Container(
                      color: gColors.white,
                      height: 540,
                      child: Column(
                        children: [
                          Container(
                            color: gColors.black,
                            height: 1,
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child:
                            Ctrl,

                          ),
                          const Spacer(),
                          Container(
                            color: gColors.black,
                            height: 1,
                          ),
                        ],
                      )),
                )),
          ],
        ),
      ],
    );
  }


}



//**********************************
//**********************************
//**********************************

class PhotoDialog extends StatefulWidget {
  final String wTxt;
  final String wTxt2;
  final String wTxt3;
  const PhotoDialog({Key? key, required this.wTxt, required this.wTxt2, required this.wTxt3}) : super(key: key);
  @override
  _PhotoDialogState createState() => _PhotoDialogState();
}

class _PhotoDialogState extends State<PhotoDialog> {
  List<Widget> imgList = [];
  List<Uint8List> Uint8ListList = [];
  List<Parc_Img> lParc_Imgs = [];

  bool isZoom = false;
  int zoomIndex = 0;

  @override
  Future initLib() async {
    imgList.clear();
    Uint8ListList.clear();
    lParc_Imgs.clear();

    print("  PhotoDialog DbTools.glfParc_Imgs.length ${DbTools.glfParc_Imgs.length}");

    bool isPrinc = false;


    DbTools.glfParc_Imgs = await DbTools.getParc_Imgs(DbTools.gParc_Ent.ParcsId!, 1);

    for (int i = 0; i < DbTools.glfParc_Imgs.length; i++) {
      var wParc_Imgs = DbTools.glfParc_Imgs[i];
      var bytes = base64Decode(wParc_Imgs.Parc_Imgs_Data!);
      Widget wWidget = Container();
      if (bytes.length > 0) {
        wWidget = Column(
          children: [
            Container(

              height: 240,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  width: 1,
                  color: gColors.greyDark2,
                ),
              ),
              child:
              ClipRRect(
                borderRadius: BorderRadius.circular(28.0),
                child:  Image.memory(
                  bytes,
                  fit: BoxFit.contain,
                ),
              ),




            ),
          ],
        );

        imgList.add(wWidget);
        Uint8ListList.add(bytes);

        if (!isPrinc) {
          if (wParc_Imgs.Parc_Imgs_Principale == 1) {
            isPrinc = true;
          }
        } else {
          wParc_Imgs.Parc_Imgs_Principale = 0;
        }

        lParc_Imgs.add(wParc_Imgs);
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    initLib();
  }

  @override
  Widget build(BuildContext context) {
    print(" Srv_DbTools.SelDCL_DateDeb ${Srv_DbTools.SelDCL_DateDeb}");

    double wWidth = 550;
    double wHeight = 1024;
    double wHeightDet = 580;
    double wHeightDet2 = 610;

    double wHeightBtn = 45;

    double wHeightBtnValider = 40;

    Widget Ctrl = Container();
    Ctrl = Photo(context);

    if (isZoom) Ctrl = Photo2(context);

    return SimpleDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.transparent,
      backgroundColor: gColors.transparent,
      shadowColor: gColors.transparent,
      children: [
        Stack(
          children: [
            Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                color: Colors.transparent,
                height: wHeight,
                child: Column(
                  children: [
// Titre
                    Container(
                        child: Container(
                      width: wWidth,
                      height: 155,
                      margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      decoration: BoxDecoration(
                        color: Colors.yellowAccent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: wWidth,
                            child: Text(
                              widget.wTxt,
                              style: gColors.bodyTitle1_B_G,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: wWidth,
                            child: Text(
                              widget.wTxt2,
                              style: gColors.bodyTitle1_N_G,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: wWidth,
                            child: Text(
                              widget.wTxt3,
                              style: gColors.bodyTitle1_N_G,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            height: 15,
                          ),
                          Container(
                            color: gColors.black,
                            height: 1,
                          ),
                        ],
                      ),
                    )),

                    Container(
                      height: wHeightDet,
                    ),

// Pied
                    Container(
                        child: Container(
                      width: wWidth,
                      height: 106,
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      decoration: BoxDecoration(
                        color: gColors.LinearGradient3,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: gColors.black,
                            height: 1,
                          ),
                          Container(
                            height: 22,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: gColors.primaryRed,
                                ),
                                child: Container(
                                  width: 140,
                                  height: wHeightBtnValider,
                                  padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                                  child: Text(
                                    "Annuler",
                                    style: gColors.bodyTitle1_B_W24,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                onPressed: () async {
                                  Navigator.pop(context);
                                },
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: gColors.primaryGreen,
                                    side: const BorderSide(
                                      width: 1.0,
                                      color: gColors.primaryGreen,
                                    )),
                                child: Container(
                                  width: 140,
                                  height: wHeightBtnValider,
                                  padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                                  child: Text(
                                    "Valider",
                                    style: gColors.bodyTitle1_B_W24,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                onPressed: () async {
                                  for (int i = 0; i < lParc_Imgs.length; i++) {
                                    DbTools.setParc_Img(lParc_Imgs[i]);
                                  }

                                  Navigator.pop(context);
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    )),
                  ],
                )),
            Positioned(
                top: 191,
                left: 5,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  height: wHeightDet2,
                  width: wWidth,
                  child: Container(
                      color: gColors.white,
                      height: 540,
                      child: Column(
                        children: [
                          Container(
                            color: gColors.black,
                            height: 1,
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Ctrl,
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            color: gColors.black,
                            height: 1,
                          ),
                        ],
                      )),
                )),
          ],
        ),
      ],
    );
  }

  Widget Photo(BuildContext context) {
    var formatter = new DateFormat('dd/MM/yy');
    var inputFormat = DateFormat('yyyy-MM-dd');

    return Container(
      width: 530,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  child: GestureDetector(
                onTap: () async {
                  print(" PHOTO ADD");

                  DbTools.gImagePath = "";
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => gPhotos()));

                  print("gImagePath ${DbTools.gImagePath}");
                  if (DbTools.gImagePath != "") {
                    print("Add ${DbTools.gImagePath}");
                    Widget wWidget = Container(
                      child: Image.file(
                        File(DbTools.gImagePath!),
                        width: 200,
                        height: 300,
                      ),
                    );

                    setState(() {
                      imgList.add(wWidget);
                      print("Add photo ${imgList.length}");
                      print("setState");
                    });
                  }
                },
                child: SvgPicture.asset(
                  "assets/images/Icon_Photo.svg",
                  width: 100,
                ),
              )),
            ],
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
            width: 560,
            height: 400,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imgList.length, // number of items in your list
                itemBuilder: (BuildContext context, int Itemindex) {
                  var wParc_Imgs_Date = inputFormat.parse(lParc_Imgs[Itemindex].Parc_Imgs_Date!);
                  String formattedDate = formatter.format(wParc_Imgs_Date);

                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          zoomIndex = Itemindex;
                          isZoom = true;
                          setState(() {});
                        },
                        child: Container(
                          child: Column(
                            children: [
                              Text(
                                "${formattedDate}",
                                style: gColors.bodySaisie_B_G,
                              ),
                              Container(
                                height: 10,
                              ),
                              imgList[Itemindex],
                              Container(
                                height: 10,
                              ),
                              lParc_Imgs[Itemindex].Parc_Imgs_Principale == 1
                                  ? Text(
                                      "Principal VF",
                                      style: gColors.bodySaisie_B_G,
                                    )
                                  : Text(
                                      "Secondaire VF",
                                      style: gColors.bodySaisie_N_G,
                                    ),
                              Switch(
                                activeColor: Colors.green,
                                value: lParc_Imgs[Itemindex].Parc_Imgs_Principale == 1,
                                onChanged: (bool value) {
                                  setState(() {
                                    if (value) {
                                      for (int i = 0; i < lParc_Imgs.length; i++) {
                                        lParc_Imgs[i].Parc_Imgs_Principale = 0;
                                      }
                                    }
                                    lParc_Imgs[Itemindex].Parc_Imgs_Principale = value ? 1 : 0;
                                    print("SWITCH ${value} ${lParc_Imgs[Itemindex].Parc_Imgs_Principale}");
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 30,
                      ),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget Photo2(BuildContext context) {
    var formatter = new DateFormat('dd/MM/yy');
    var inputFormat = DateFormat('yyyy-MM-dd');
    var wParc_Imgs_Date = inputFormat.parse(lParc_Imgs[zoomIndex].Parc_Imgs_Date!);
    String formattedDate = formatter.format(wParc_Imgs_Date);

    var wParc_Imgs = DbTools.glfParc_Imgs[zoomIndex];
    var bytes = base64Decode(wParc_Imgs.Parc_Imgs_Data!);
    Widget wWidget = Container();
    if (bytes.length > 0) {
      wWidget = Column(
        children: [
          Container(
            height: 400,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                width: 1,
                color: gColors.greyDark2,
              ),
            ),
            child:

            ClipRRect(
              borderRadius: BorderRadius.circular(28.0),
              child:  Image.memory(
                bytes,
                fit: BoxFit.contain,
              ),
            ),



          ),
        ],
      );
    }

    return Container(
      width: 530,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Column(
            children: [
              Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  width: 560,
                  height: 580,
                  child: GestureDetector(
                    onTap: () async {
                      Uint8List wUint8List = Uint8ListList[zoomIndex];
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ImagePainterTools(wUint8List: wUint8List, wParc_Img: lParc_Imgs[zoomIndex]),
                        ),
                      );
                      await initLib();
                    },
                    child: Container(
                      child: Column(
                        children: [
                          Text(
                            "${formattedDate}",
                            style: gColors.bodyTitle1_B_G_20,
                          ),
                          Container(
                            height: 16,
                          ),
                          wWidget,
                          Container(
                            height: 10,
                          ),
                          lParc_Imgs[zoomIndex].Parc_Imgs_Principale == 1
                              ? Text(
                                  "Principal VF",
                                  style: gColors.bodyTitle1_B_G_20,
                                )
                              : Text(
                                  "Secondaire VF",
                                  style: gColors.bodyTitle1_N_G_20,
                                ),


                        ],
                      ),
                    ),
                  )),
            ],
          ),
          Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                  child: Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Image.asset(
                      "assets/images/ico5b.png",
                      fit: BoxFit.contain,
                      height: 50,
                    ),
                  ),
                  onTap: () async {
                    await gDialogs.Dialog_MsgBox(context, "${DbTools.DescAff}","${DbTools.DescAff2}","${DbTools.DescAff3}","ico5b","Êtes-vous sur de vouloir","éffacer la photo ?",);
                    if (_MsgBoxDialogState.gRep) {
                      await DbTools.deleteParc_ImgAllType(lParc_Imgs[zoomIndex].Parc_Imgid!);
                    }
                    isZoom = false;
                    initLib();
                  })),
        ],
      ),
    );
  }
}

//**********************************
//**********************************
//**********************************

class CdeDateDialog extends StatefulWidget {
  @override
  _CdeDateDialogState createState() => _CdeDateDialogState();
}

class _CdeDateDialogState extends State<CdeDateDialog> {
  bool isSel = false;

  @override
  void initState() {
    print("_CdeDateDialog  initState");
  }

  @override
  Widget build(BuildContext context) {
    print(" Srv_DbTools.SelDCL_DateDeb ${Srv_DbTools.SelDCL_DateDeb}");

    var formatter = DateFormat('dd/MM/yyyy');
    String fSelDCL_DateDeb = formatter.format(Srv_DbTools.SelDCL_DateDeb);
    String fSelDCL_DateFin = formatter.format(Srv_DbTools.SelDCL_DateFin);

    return SimpleDialog(
      insetPadding: EdgeInsets.only(bottom: 420, right: 400),
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.transparent,
      backgroundColor: gColors.transparent,
      shadowColor: gColors.transparent,
      children: [
        Container(
            color: gColors.transparent,
            height: 220,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: 260,
                              height: 80,
                              padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  InkWell(
                                    child: Row(
                                      children: [
                                        Text(
                                          "Du ",
                                          style: gColors.bodySaisie_B_G,
                                        ),
                                        Text(
                                          "${fSelDCL_DateDeb}",
                                          style: gColors.bodySaisie_N_G,
                                        ),
                                      ],
                                    ),
                                    onTap: () async {
                                      selectedDate = Srv_DbTools.SelDCL_DateDeb;
                                      await _selectDate(context, DateTime(1900), DateTime(DateTime.now().year, 12, 31));
                                      Srv_DbTools.SelDCL_DateDeb = selectedDate;
                                      isSel = true;
                                      setState(() {});
                                    },
                                  ),
                                  Container(
                                    width: 30,
                                  ),
                                  popMenu(),
                                  Container(
                                    width: 10,
                                  ),
                                  InkWell(
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/DCL_Date.png",
                                          height: 40,
                                          width: 40,
                                        ),
                                      ],
                                    ),
                                    onTap: () async {
                                      selectedDate = Srv_DbTools.SelDCL_DateDeb;
                                      await _selectDate(context, DateTime(1900), DateTime(DateTime.now().year, 12, 31));
                                      Srv_DbTools.SelDCL_DateDeb = selectedDate;
                                      isSel = true;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ))
                        ],
                      ),
                      Container(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: 260,
                              height: 80,
                              padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  InkWell(
                                    child: Row(
                                      children: [
                                        Text(
                                          "Au ",
                                          style: gColors.bodySaisie_B_G,
                                        ),
                                        Text(
                                          "${fSelDCL_DateFin}",
                                          style: gColors.bodySaisie_N_G,
                                        ),
                                      ],
                                    ),
                                    onTap: () async {
                                      selectedDate = Srv_DbTools.SelDCL_DateFin;
                                      await _selectDate(context, DateTime(1900), DateTime.now());
                                      Srv_DbTools.SelDCL_DateFin = selectedDate;
                                      isSel = true;
                                      setState(() {});
                                    },
                                  ),
                                  Container(
                                    width: 30,
                                  ),
                                  popMenu(),
                                  Container(
                                    width: 10,
                                  ),
                                  InkWell(
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/DCL_Date.png",
                                          height: 40,
                                          width: 40,
                                        ),
                                      ],
                                    ),
                                    onTap: () async {
                                      selectedDate = Srv_DbTools.SelDCL_DateFin;
                                      await _selectDate(context, DateTime(1900), DateTime.now());
                                      Srv_DbTools.SelDCL_DateFin = selectedDate;
                                      isSel = true;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            )),
      ],
    );
  }

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context, DateTime firstDate, DateTime lastDate) async {
    print("selectedDate >> ${selectedDate}");

    final DateTime? picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: firstDate, lastDate: lastDate);
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        print("selectedDate << ${selectedDate}");
      });
    }
  }

  Widget popMenu() {
    double hLigne = 72;

    return PopupMenuButton(
      child: Tooltip(textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.normal), decoration: BoxDecoration(color: Colors.orange), message: "Filtre Date", child: Container(width: 40, height: 40, child: SvgPicture.asset("assets/images/Icon_circle_down2.svg", height: 40, width: 40, colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn), semanticsLabel: 'A red up arrow'))),
      onSelected: (value) async {
        print(" onSelected ${value}");

        if (value == "S0") {
          Srv_DbTools.selDateTools(0);
        }
        if (value == "S1") {
          Srv_DbTools.selDateTools(1);
        }
        if (value == "S2") {
          Srv_DbTools.selDateTools(2);
        }
        if (value == "S3") {
          Srv_DbTools.selDateTools(3);
        }
        if (value == "S4") {
          Srv_DbTools.selDateTools(4);
        }
        if (value == "S5") {
          Srv_DbTools.selDateTools(5);
        }
        if (value == "S6") {
          Srv_DbTools.selDateTools(6);
        }
        if (value == "S7") {
          Srv_DbTools.selDateTools(7);
        }
        if (value == "S8") {
          Srv_DbTools.selDateTools(8);
        }
        if (value == "S9") {
          Srv_DbTools.selDateTools(9);
        }
        if (value == "S10") {
          Srv_DbTools.selDateTools(10);
        }
        setState(() {});
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          value: "S0",
          height: hLigne,
          child: Row(
            children: [
              Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
              Text(
                "Aujourd'hui",
                style: gColors.bodySaisie_N_G,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: "S1",
          height: hLigne,
          child: Row(
            children: [
              Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
              Text(
                "Hier",
                style: gColors.bodySaisie_N_G,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: "S2",
          height: hLigne,
          child: Row(
            children: [
              Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
              Text(
                "Avant hier",
                style: gColors.bodySaisie_N_G,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: "S3",
          height: hLigne,
          child: Row(
            children: [
              Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
              Text(
                "Semaine courante",
                style: gColors.bodySaisie_N_G,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: "S4",
          height: hLigne,
          child: Row(
            children: [
              Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
              Text(
                "Semaine précédente",
                style: gColors.bodySaisie_N_G,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: "S5",
          height: hLigne,
          child: Row(
            children: [
              Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
              Text(
                "Semaine précédent la précédente",
                style: gColors.bodySaisie_N_G,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: "S6",
          height: hLigne,
          child: Row(
            children: [
              Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
              Text(
                "Mois courant",
                style: gColors.bodySaisie_N_G,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: "S7",
          height: hLigne,
          child: Row(
            children: [
              Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
              Text(
                "Mois précédent",
                style: gColors.bodySaisie_N_G,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: "S8",
          height: hLigne,
          child: Row(
            children: [
              Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
              Text(
                "Mois précédent le précédent",
                style: gColors.bodySaisie_N_G,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: "S9",
          height: hLigne,
          child: Row(
            children: [
              Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
              Text(
                "Année courante",
                style: gColors.bodySaisie_N_G,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: "S10",
          height: hLigne,
          child: Row(
            children: [
              Container(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.date_range)),
              Text(
                "Année précédente",
                style: gColors.bodySaisie_N_G,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//**********************************
//**********************************
//**********************************

class MiseEnServDialog extends StatefulWidget {
  @override
  _MiseEnServDialogState createState() => _MiseEnServDialogState();
}

class _MiseEnServDialogState extends State<MiseEnServDialog> {
  bool isSel = false;

  @override
  void initState() {
    print("_MiseEnServDialog  initState");
  }

  List<bool> wSel = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.white,
      backgroundColor: gColors.white,
      title: Container(
          color: gColors.white,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
          child: Column(
            children: [
              Text(
                "Mise en service",
                textAlign: TextAlign.center,
                style: gColors.bodyTitle1_B_G_20,
              ),
              Text(
                "Selection du mode de mise en service",
                textAlign: TextAlign.center,
                style: gColors.bodyTitle1_N_Gr,
              ),
              Container(
                height: 8,
              ),
            ],
          )),
      contentPadding: EdgeInsets.zero,
      content: Container(
          color: gColors.greyLight,
          height: 220,
          child: Column(
            children: [
              Container(
                color: gColors.black,
                height: 1,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BtnCard("Mise en service Neuf", 0),
                        BtnCard("Mise en service sur devis", 2),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BtnCard("Mise en service sans organe", 1),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                color: gColors.black,
                height: 1,
              ),
              Valider(context),
            ],
          )),
      actions: <Widget>[
        Container(
          height: 8,
        ),
      ],
    );
  }

  Widget BtnCard(String wText, int iSel) {
    Color BgColor = gColors.white;
    Color TxtColor = gColors.black;

    if (wSel[iSel]) {
      BgColor = gColors.primaryGreen;
      TxtColor = gColors.white;
    }

    return new Container(
      width: 250,
      height: 60,
      child: Card(
        color: BgColor,
        elevation: 0.2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0), side: BorderSide(width: 1, color: Colors.grey)),
        child: InkWell(
          onTap: () async {
            await HapticFeedback.vibrate();
            wSel[0] = false;
            wSel[1] = false;
            wSel[2] = false;
            wSel[iSel] = true;
            isSel = true;

            print("iSel $iSel ${wSel[iSel]} ");
            setState(() {});
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                wText,
                textAlign: TextAlign.center,
                style: wSel[iSel]
                    ? gColors.bodyTitle1_B_Gr.copyWith(
                        color: TxtColor,
                      )
                    : gColors.bodyTitle1_N_Gr.copyWith(
                        color: TxtColor,
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //**********************************
  //**********************************
  //**********************************

  Widget Valider(BuildContext context) {
    return Container(
      width: 620,
      alignment: Alignment.centerRight,
      color: gColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
//          Text(widget.param_Saisie.Param_Saisie_Controle),
          Container(
            color: gColors.primary,
            width: 8,
          ),
          new ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();
              DbTools.gParc_Art_MS.ParcsArtId = -98;

              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: gColors.primaryRed,
            ),
            child: Text('Annuler', style: gColors.bodyTitle1_B_W),
          ),
          Container(
            color: gColors.primary,
            width: 8,
          ),
          new ElevatedButton(
            onPressed: () async {
              if (isSel) {
                await HapticFeedback.vibrate();

                if (wSel[0]) {
                  print("MS MS MS DbTools.gParc_Ent.Parcs_CodeArticle! ${DbTools.gParc_Ent.Parcs_CodeArticle!}");
                  Article_Ebp wArticle_Ebp = Srv_DbTools.IMPORT_Article_Ebp(DbTools.gParc_Ent.Parcs_CodeArticle!);
                  Parc_Art wParc_Art = Parc_Art.Parc_ArtInit(DbTools.gParc_Ent.ParcsId!);
                  wParc_Art.ParcsArt_Id = "${DbTools.gParc_Ent.Parcs_CodeArticle}";
                  wParc_Art.ParcsArt_Type = "MS";
                  wParc_Art.ParcsArt_Lib = "${wArticle_Ebp.Article_descriptionCommercialeEnClair}";
                  wParc_Art.ParcsArt_Qte = 1;
                  wParc_Art.ParcsArt_Fact = "Fact.";
                  wParc_Art.ParcsArt_Livr = "Livré";
                  DbTools.gParc_Art_MS = wParc_Art;
                } else if (wSel[2]) {
                  print("MS MS MS DbTools.gParc_Ent.Parcs_CodeArticle! ${DbTools.gParc_Ent.Parcs_CodeArticle!}");
                  Article_Ebp wArticle_Ebp = Srv_DbTools.IMPORT_Article_Ebp(DbTools.gParc_Ent.Parcs_CodeArticle!);
                  Parc_Art wParc_Art = Parc_Art.Parc_ArtInit(DbTools.gParc_Ent.ParcsId!);
                  wParc_Art.ParcsArt_Id = "${DbTools.gParc_Ent.Parcs_CodeArticle}";
                  wParc_Art.ParcsArt_Type = "MS";
                  wParc_Art.ParcsArt_Lib = "${wArticle_Ebp.Article_descriptionCommercialeEnClair}";
                  wParc_Art.ParcsArt_Qte = 1;
                  wParc_Art.ParcsArt_Fact = "Devis";
                  wParc_Art.ParcsArt_Livr = "Reliquat";
                  DbTools.gParc_Art_MS = wParc_Art;
                }

                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: isSel ? gColors.primaryGreen : gColors.GrdBtn_Colors3,
                side: BorderSide(
                  width: 1.0,
                  color: isSel ? gColors.primaryGreen : gColors.GrdBtn_Colors3,
                )),
            child: Text('Valider', style: gColors.bodyTitle1_B_W),
          ),

          Container(
            color: gColors.primary,
            width: 20,
          ),
        ],
      ),
    );
  }
}

//**********************************
//**********************************
//**********************************

class QrCodeDialog extends StatefulWidget {
  @override
  _QrCodeDialogState createState() => _QrCodeDialogState();
}

class _QrCodeDialogState extends State<QrCodeDialog> {
  @override
  void initState() {
    QrcValue = DbTools.gParc_Ent.Parcs_QRCode!;
    print("_QrCodeDialog  initState");
  }

  @override
  Widget build(BuildContext context) {
    Widget Ctrl = Container();
    Ctrl = Qrc(context);

    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.white,
      backgroundColor: gColors.white,
      title: Container(
          color: gColors.white,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
          child: Column(
            children: [
              Text(
                "QR Code",
                textAlign: TextAlign.center,
                style: gColors.bodyTitle1_B_G_20,
              ),
              Text(
                "Scanner l'étiquette QR Code",
                textAlign: TextAlign.center,
                style: gColors.bodyTitle1_N_Gr,
              ),
              Container(
                height: 8,
              ),
            ],
          )),
      contentPadding: EdgeInsets.zero,
      content: Container(
          color: gColors.greyLight,
          height: 140,
          child: Column(
            children: [
              Container(
                color: gColors.black,
                height: 1,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 30,
                        ),
                        Ctrl,
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                color: gColors.black,
                height: 1,
              ),
            ],
          )),
      actions: <Widget>[
        Container(
          height: 8,
        ),
      ],
    );
  }

  //**********************************
  //**********************************
  //**********************************

  String ErrorQrc = "";
  String QrcValue = "";
  Widget Qrc(BuildContext context) {
    return InkWell(
      onTap: () async {
        await HapticFeedback.vibrate();
        var result = await BarcodeScanner.scan();
        print("result.type ${result.type}");
        print("result.rawContent ${result.rawContent}");
        print("result.format ${result.format}");

        QrcValue = "";
        ErrorQrc = "Erreur de lecture ou de QR Code";
        if (result.type.toString().compareTo("Barcode") == 0) {
          if (result.format.toString().compareTo("qr") == 0) {
            if (result.rawContent.toString().startsWith("M")) {
              if (result.rawContent.toString().endsWith("F")) {
                QrcValue = result.rawContent;
                ErrorQrc = "";
              }
            }
          }
        }

        setState(() {});
      },
      child: Container(
          width: 350,
//              color: Colors.amberAccent,
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.qr_code),
                  Container(
                    width: 20,
                  ),
                  Text(
                    "Code:  ${QrcValue}",
                    style: gColors.bodyTitle1_B_Gr,
                  ),
                ],
              ),
              Container(
                height: 20,
              ),
              Text(
                "${ErrorQrc}",
                style: gColors.bodyTitle1_B_Gr.copyWith(
                  color: gColors.primaryRed,
                ),
              ),
              Valider(context),
            ],
          )),
    );
  }

  //**********************************
  //**********************************
  //**********************************

  Widget Valider(BuildContext context) {
    return Container(
      width: 450,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
//          Text(widget.param_Saisie.Param_Saisie_Controle),
          Container(
            color: gColors.primary,
            width: 8,
          ),
          new ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();

              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: gColors.primaryRed,
            ),
            child: Text('Annuler', style: gColors.bodyTitle1_B_W),
          ),
          Container(
            color: gColors.primary,
            width: 8,
          ),
          new ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();
              DbTools.gParc_Ent.Parcs_QRCode = QrcValue;
              print("DbTools.gParc_Ent ${DbTools.gParc_Ent.ParcsId} ${DbTools.gParc_Ent.Parcs_QRCode}");
              print(" updateParc_Ent D");
              await DbTools.updateParc_Ent(DbTools.gParc_Ent);

              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: gColors.primaryGreen,
                side: const BorderSide(
                  width: 1.0,
                  color: gColors.primaryGreen,
                )),
            child: Text('Valider', style: gColors.bodyTitle1_B_W),
          ),
        ],
      ),
    );
  }
}

//**********************************
//**********************************
//**********************************
