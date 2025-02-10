import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multi_dropdown/models/value_item.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DCL_Ent_Img.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_User.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/PdfView.dart';
import 'package:verifplus/Widget/Widget_Tools/ImagePainterTools.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gDialogs.dart';
import 'package:verifplus/Widget/Widget_Tools/gPhotos.dart';

List<String> listRegl = [
  "Règle APSAD R1 / Sprinkleurs",
  "Règle APSAD D2 / Brouillard d'eau",
  "Règle APSAD R3 / Maintenance colonnes incendies",
  "Règle APSAD R4 / Extincteurs portatifs et mobiles",
  "Règle APSAD R5 / RIA et PIA",
  "Règle APSAD R7  / Détection incendie",
  "Règle APSAD R12 / Extinction mousse à haut foisonnement",
  "Règle APSAD R13 / Extinction automatique à gaz",
  "Règle APSAD R16 / Compartimentage",
  "Règle APSAD R17 / Désenfumage naturel",
  "ERT (Etablissement recevant des travailleurs)",
  "ERP (Etablissement recevant du public)",
  "IGH (Immeuble de grander hauteur)",
  "DREAL (Direction régionale de l'environnement, de l'aménagement et du logement)",
  "Autres",
];

class DCL_Param_Dialog {
  DCL_Param_Dialog();

  static String wSel = "";
  static List<String> ListParam = [];
  static String wNote = "";

  static String RelanceMode = "Mail";
  static String wContact = "";
  static String wMail = "";
  static String wTel = "";

  static Future<void> Dialogs_DCL_Param(BuildContext context, String wTitre) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => DCLParamDialog(wTitre: wTitre),
    );
  }

  static Future<void> Dialogs_DCL_ParamNote(BuildContext context, String wTitre, String wNote) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => DCLParamDialog_Note(wTitre: wTitre, wNote: wNote),
    );
  }

  static Future<void> Dialogs_DCL_ParamText(BuildContext context, String wTitre, String wNote) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => DCLParamDialog_Text(wTitre: wTitre, wNote: wNote),
    );
  }

  static Future<void> Dialogs_DCL_ParamRelance(BuildContext context, String wTitre, String wContact, String wMail, String wTel) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => DCLParamDialog_Relance(wTitre: wTitre, wContact: wContact, wMail: wMail, wTel: wTel),
    );
  }

  static Future<void> Dialogs_DCL_ScanDoc(BuildContext context, String wTitre, String wNote) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => DCLParamDialog_ScanDoc(wTitre: wTitre, wNote: wNote),
    );
  }

  static Future<void> Dialogs_DCL_Rglt(BuildContext context, String wTitre, String wNote) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => DCLParamDialog_Rglt(wTitre: wTitre, wNote: wNote),
    );
  }

  static Future<void> Dialogs_DCL_Partage(BuildContext context, String wTitre, String wNote) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => DCLParamDialog_Partage(wTitre: wTitre, wNote: wNote),
    );
  }

  static Future<void> Dialogs_DCL_Contributeurs(BuildContext context, String wTitre, String wNote) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => DCLParamDialog_Contributeurs(wTitre: wTitre, wNote: wNote),
    );
  }

  static Future<void> Dialogs_DCL_aideTech(BuildContext context, String wTitre, String wNote) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => DCLParamDialog_aideTech(wTitre: wTitre, wNote: wNote),
    );
  }

  static Future<void> Dialogs_DCL_ssTr(BuildContext context, String wTitre, String wNote) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => DCLParamDialog_ssTr(wTitre: wTitre, wNote: wNote),
    );
  }
}

//**********************************
//**********************************
//**********************************

class DCLParamDialog_ssTr extends StatefulWidget {
  final String wTitre;
  final String wNote;
  const DCLParamDialog_ssTr({Key? key, required this.wTitre, required this.wNote}) : super(key: key);

  @override
  _DCLParamDialog_ssTrState createState() => _DCLParamDialog_ssTrState();
}

class _DCLParamDialog_ssTrState extends State<DCLParamDialog_ssTr> {
  List<User> listUser = [];
  static List<bool> itemlistApp = [];

  Widget ssTr(BuildContext context) {
    double wWidth = 510;
    double wHeightBtn = 45;

    User wUser = User.UserInit();
    var witemlistApp = false;

    print("ssTr ${Srv_DbTools.ListUser.length}");

    List<Widget> cclistMes = [];

    for (int i = 0; i < Srv_DbTools.ListUser.length; i++) {
      wUser = Srv_DbTools.ListUser[i];
      if (wUser.User_TypeUser != "Admin" || wUser.User_Matricule == "2") continue;
      witemlistApp = itemlistApp[i];

      cclistMes.add(GestureDetector(
        onTap: () async {
          setState(() {
            for (int j = 0; j < itemlistApp.length; j++) {
              if (i != j)
                itemlistApp[j] = false;
              else
                itemlistApp[i] = !itemlistApp[i];
            }
          });
        },
        child: Container(
            decoration: BoxDecoration(
              color: gColors.white,
              border: Border.all(
                width: 0.7,
                color: gColors.black,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            height: wHeightBtn,
            width: wWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text("${wUser.User_Matricule} / ${wUser.User_Nom} ${wUser.User_Prenom}", textAlign: TextAlign.left, maxLines: 1, style: gColors.bodyTitle1_N_Gr),
                ),
                gColors.gCircle(witemlistApp ? gColors.primaryGreen : gColors.LinearGradient5, wSize: 24),
              ],
            )),
      ));
    }

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: cclistMes.length, // number of items in your list
      itemBuilder: (BuildContext context, int Itemindex) {
        return Container(
          height: 80,
          child: cclistMes[Itemindex],
        );
      },
    );
  }

  Future Reload() async {
    setState(() {});
  }

  @override
  void initLib() async {
    Reload();
  }

  @override
  void initState() {
    itemlistApp.clear();
    List<int> list = Srv_DbTools.gDCL_Ent.DCL_Ent_DemSsT!.split(',').map<int>((e) {
      return int.tryParse(e) ?? 0;
    }).toList();
    for (int i = 0; i < Srv_DbTools.ListUser.length; i++) {
      User wUser = Srv_DbTools.ListUser[i];
      bool wTmp = list.contains(int.parse(wUser.User_Matricule));
      itemlistApp.add(wTmp);
    }

    initLib();
  }

  @override
  Widget build(BuildContext context) {
    print(" Srv_DbTools.SelDCL_DateDeb ${Srv_DbTools.SelDCL_DateDeb}");

    double wWidth = 550;
    double wHeight = 1024;
    double wHeightDet2 = 610;
    double wHeightBtnValider = 40;

    return SimpleDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.transparent,
      backgroundColor: gColors.transparent,
      shadowColor: gColors.transparent,
      children: [
        Column(
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
                      height: 99,
                      margin: const EdgeInsets.fromLTRB(0, 90, 0, 0),
                      padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                      decoration: BoxDecoration(color: Colors.yellowAccent, borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: wWidth,
                            child: Text(
                              widget.wTitre,
                              style: gColors.bodyTitle1_B_G,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            height: 30,
                          ),
                          Container(
                            color: gColors.black,
                            height: 1,
                          ),
                        ],
                      ),
                    )),

// CONTENT
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      height: wHeightDet2,
                      width: wWidth,
                      child: ssTr(context),
                    ),

// Pied
                    Container(
                        child: Container(
                      width: wWidth,
                      height: 100,
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: BoxDecoration(color: gColors.LinearGradient3, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
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
                                  DCL_Param_Dialog.wSel = "";
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
                                  User wUser = User.UserInit();
                                  var witemlistApp = false;
                                  String wValues = "";
                                  for (int i = 0; i < Srv_DbTools.ListUser.length; i++) {
                                    wUser = Srv_DbTools.ListUser[i];
                                    witemlistApp = itemlistApp[i];
                                    if (witemlistApp) wValues += "${wUser.User_Matricule},";
                                  }
                                  Srv_DbTools.gDCL_Ent.DCL_Ent_DemSsT = wValues;
                                  Srv_DbTools.setDCL_Ent(Srv_DbTools.gDCL_Ent);
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
          ],
        ),
      ],
    );
  }
}

//**********************************
//**********************************
//**********************************

class DCLParamDialog_aideTech extends StatefulWidget {
  final String wTitre;
  final String wNote;
  const DCLParamDialog_aideTech({Key? key, required this.wTitre, required this.wNote}) : super(key: key);

  @override
  _DCLParamDialog_aideTechState createState() => _DCLParamDialog_aideTechState();
}

class _DCLParamDialog_aideTechState extends State<DCLParamDialog_aideTech> {
  List<User> listUser = [];
  static List<bool> itemlistApp = [];

  Widget aideTech(BuildContext context) {
    double wWidth = 510;
    double wHeightBtn = 45;

    User wUser = User.UserInit();
    var witemlistApp = false;

    print("aideTech ${Srv_DbTools.ListUser.length}");

    List<Widget> cclistMes = [];

    for (int i = 0; i < Srv_DbTools.ListUser.length; i++) {
      wUser = Srv_DbTools.ListUser[i];
      if (wUser.User_TypeUser != "Admin" || wUser.User_Matricule == "2") continue;
      witemlistApp = itemlistApp[i];

      cclistMes.add(GestureDetector(
        onTap: () async {
          setState(() {
            for (int j = 0; j < itemlistApp.length; j++) {
              if (i != j)
                itemlistApp[j] = false;
              else
                itemlistApp[i] = !itemlistApp[i];
            }
          });
        },
        child: Container(
            decoration: BoxDecoration(
              color: gColors.white,
              border: Border.all(
                width: 0.7,
                color: gColors.black,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            height: wHeightBtn,
            width: wWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text("${wUser.User_Matricule} / ${wUser.User_Nom} ${wUser.User_Prenom}", textAlign: TextAlign.left, maxLines: 1, style: gColors.bodyTitle1_N_Gr),
                ),
                gColors.gCircle(witemlistApp ? gColors.primaryGreen : gColors.LinearGradient5, wSize: 24),
              ],
            )),
      ));
    }

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: cclistMes.length, // number of items in your list
      itemBuilder: (BuildContext context, int Itemindex) {
        return Container(
          height: 80,
          child: cclistMes[Itemindex],
        );
      },
    );
  }

  Future Reload() async {
    setState(() {});
  }

  @override
  void initLib() async {
    Reload();
  }

  @override
  void initState() {
    itemlistApp.clear();
    List<int> list = Srv_DbTools.gDCL_Ent.DCL_Ent_DemTech!.split(',').map<int>((e) {
      return int.tryParse(e) ?? 0;
    }).toList();
    for (int i = 0; i < Srv_DbTools.ListUser.length; i++) {
      User wUser = Srv_DbTools.ListUser[i];
      bool wTmp = list.contains(int.parse(wUser.User_Matricule));
      itemlistApp.add(wTmp);
    }

    initLib();
  }

  @override
  Widget build(BuildContext context) {
    print(" Srv_DbTools.SelDCL_DateDeb ${Srv_DbTools.SelDCL_DateDeb}");

    double wWidth = 550;
    double wHeight = 1024;
    double wHeightDet2 = 610;
    double wHeightBtnValider = 40;

    return SimpleDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.transparent,
      backgroundColor: gColors.transparent,
      shadowColor: gColors.transparent,
      children: [
        Column(
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
                      height: 99,
                      margin: const EdgeInsets.fromLTRB(0, 90, 0, 0),
                      padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                      decoration: BoxDecoration(color: Colors.yellowAccent, borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: wWidth,
                            child: Text(
                              widget.wTitre,
                              style: gColors.bodyTitle1_B_G,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            height: 30,
                          ),
                          Container(
                            color: gColors.black,
                            height: 1,
                          ),
                        ],
                      ),
                    )),

// CONTENT
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      height: wHeightDet2,
                      width: wWidth,
                      child: aideTech(context),
                    ),

// Pied
                    Container(
                        child: Container(
                      width: wWidth,
                      height: 100,
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: BoxDecoration(color: gColors.LinearGradient3, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
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
                                  DCL_Param_Dialog.wSel = "";
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
                                  User wUser = User.UserInit();
                                  var witemlistApp = false;
                                  String wValues = "";
                                  for (int i = 0; i < Srv_DbTools.ListUser.length; i++) {
                                    wUser = Srv_DbTools.ListUser[i];
                                    witemlistApp = itemlistApp[i];
                                    if (witemlistApp) wValues += "${wUser.User_Matricule},";
                                  }
                                  Srv_DbTools.gDCL_Ent.DCL_Ent_DemTech = wValues;
                                  Srv_DbTools.setDCL_Ent(Srv_DbTools.gDCL_Ent);
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
          ],
        ),
      ],
    );
  }
}

//**********************************
//**********************************
//**********************************

class DCLParamDialog_Contributeurs extends StatefulWidget {
  final String wTitre;
  final String wNote;
  const DCLParamDialog_Contributeurs({Key? key, required this.wTitre, required this.wNote}) : super(key: key);

  @override
  _DCLParamDialog_ContributeursState createState() => _DCLParamDialog_ContributeursState();
}

class _DCLParamDialog_ContributeursState extends State<DCLParamDialog_Contributeurs> {
  List<User> listUser = [];
  static List<bool> itemlistApp = [];

  Widget Contributeurs(BuildContext context) {
    double wWidth = 510;
    double wHeightBtn = 45;

    User wUser = User.UserInit();
    var witemlistApp = false;

    print("Contributeurs ${Srv_DbTools.ListUser.length}");

    List<Widget> cclistMes = [];

    for (int i = 0; i < Srv_DbTools.ListUser.length; i++) {
      wUser = Srv_DbTools.ListUser[i];
      witemlistApp = itemlistApp[i];

      cclistMes.add(GestureDetector(
        onTap: () async {
          setState(() {
            itemlistApp[i] = !itemlistApp[i];
          });
        },
        child: Container(
            decoration: BoxDecoration(
              color: gColors.white,
              border: Border.all(
                width: 0.7,
                color: gColors.black,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            height: wHeightBtn,
            width: wWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text("${wUser.User_Matricule} / ${wUser.User_Nom} ${wUser.User_Prenom}", textAlign: TextAlign.left, maxLines: 1, style: gColors.bodyTitle1_N_Gr),
                ),
                gColors.gCircle(witemlistApp ? gColors.primaryGreen : gColors.LinearGradient5, wSize: 24),
              ],
            )),
      ));
    }

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: cclistMes.length, // number of items in your list
      itemBuilder: (BuildContext context, int Itemindex) {
        return Container(
          height: 80,
          child: cclistMes[Itemindex],
        );
      },
    );
  }

  Future Reload() async {
    setState(() {});
  }

  @override
  void initLib() async {
    Reload();
  }

  @override
  void initState() {
    itemlistApp.clear();
    List<int> list = Srv_DbTools.gDCL_Ent.DCL_Ent_Contributeurs!.split(',').map<int>((e) {
      return int.tryParse(e) ?? 0;
    }).toList();
    for (int i = 0; i < Srv_DbTools.ListUser.length; i++) {
      User wUser = Srv_DbTools.ListUser[i];
      bool wTmp = list.contains(int.parse(wUser.User_Matricule));
      itemlistApp.add(wTmp);
    }

    initLib();
  }

  @override
  Widget build(BuildContext context) {
    print(" Srv_DbTools.SelDCL_DateDeb ${Srv_DbTools.SelDCL_DateDeb}");

    double wWidth = 550;
    double wHeight = 1024;
    double wHeightDet2 = 610;
    double wHeightBtnValider = 40;

    return SimpleDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.transparent,
      backgroundColor: gColors.transparent,
      shadowColor: gColors.transparent,
      children: [
        Column(
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
                      height: 99,
                      margin: const EdgeInsets.fromLTRB(0, 90, 0, 0),
                      padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                      decoration: BoxDecoration(color: Colors.yellowAccent, borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: wWidth,
                            child: Text(
                              widget.wTitre,
                              style: gColors.bodyTitle1_B_G,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            height: 30,
                          ),
                          Container(
                            color: gColors.black,
                            height: 1,
                          ),
                        ],
                      ),
                    )),

// CONTENT
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      height: wHeightDet2,
                      width: wWidth,
                      child: Contributeurs(context),
                    ),

// Pied
                    Container(
                        child: Container(
                      width: wWidth,
                      height: 100,
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: BoxDecoration(color: gColors.LinearGradient3, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
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
                                  DCL_Param_Dialog.wSel = "";
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
                                  User wUser = User.UserInit();
                                  var witemlistApp = false;
                                  String wValues = "";
                                  for (int i = 0; i < Srv_DbTools.ListUser.length; i++) {
                                    wUser = Srv_DbTools.ListUser[i];
                                    witemlistApp = itemlistApp[i];
                                    if (witemlistApp) wValues += "${wUser.User_Matricule},";
                                  }
                                  Srv_DbTools.gDCL_Ent.DCL_Ent_Contributeurs = wValues;
                                  Srv_DbTools.setDCL_Ent(Srv_DbTools.gDCL_Ent);
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
          ],
        ),
      ],
    );
  }
}

//**********************************
//**********************************
//**********************************

class DCLParamDialog_Partage extends StatefulWidget {
  final String wTitre;
  final String wNote;
  const DCLParamDialog_Partage({Key? key, required this.wTitre, required this.wNote}) : super(key: key);

  @override
  _DCLParamDialog_PartageState createState() => _DCLParamDialog_PartageState();
}

class _DCLParamDialog_PartageState extends State<DCLParamDialog_Partage> {
  List<User> listUser = [];
  static List<bool> itemlistApp = [];

  Widget Partage(BuildContext context) {
    double wWidth = 510;
    double wHeightBtn = 45;

    User wUser = User.UserInit();
    var witemlistApp = false;

    print("Partage ${Srv_DbTools.ListUser.length}");

    List<Widget> cclistMes = [];

    for (int i = 0; i < Srv_DbTools.ListUser.length; i++) {
      wUser = Srv_DbTools.ListUser[i];

      witemlistApp = itemlistApp[i];

      cclistMes.add(GestureDetector(
        onTap: () async {
          setState(() {
            itemlistApp[i] = !itemlistApp[i];
          });
        },
        child: Container(
            decoration: BoxDecoration(
              color: gColors.white,
              border: Border.all(
                width: 0.7,
                color: gColors.black,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            height: wHeightBtn,
            width: wWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text("${wUser.User_Matricule} / ${wUser.User_Nom} ${wUser.User_Prenom}", textAlign: TextAlign.left, maxLines: 1, style: gColors.bodyTitle1_N_Gr),
                ),
                gColors.gCircle(witemlistApp ? gColors.primaryGreen : gColors.LinearGradient5, wSize: 24),
              ],
            )),
      ));
    }

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: cclistMes.length, // number of items in your list
      itemBuilder: (BuildContext context, int Itemindex) {
        return Container(
          height: 80,
          child: cclistMes[Itemindex],
        );
      },
    );
  }

  Future Reload() async {
    setState(() {});
  }

  @override
  void initLib() async {
    Reload();
  }

  @override
  void initState() {
    itemlistApp.clear();
    List<int> list = Srv_DbTools.gDCL_Ent.DCL_Ent_Partage!.split(',').map<int>((e) {
      return int.tryParse(e) ?? 0;
    }).toList();
    for (int i = 0; i < Srv_DbTools.ListUser.length; i++) {
      User wUser = Srv_DbTools.ListUser[i];
      bool wTmp = list.contains(int.parse(wUser.User_Matricule));
      itemlistApp.add(wTmp);
    }

    initLib();
  }

  @override
  Widget build(BuildContext context) {
    print(" Srv_DbTools.SelDCL_DateDeb ${Srv_DbTools.SelDCL_DateDeb}");

    double wWidth = 550;
    double wHeight = 1024;
    double wHeightDet2 = 610;
    double wHeightBtnValider = 40;

    return SimpleDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.transparent,
      backgroundColor: gColors.transparent,
      shadowColor: gColors.transparent,
      children: [
        Column(
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
                      height: 99,
                      margin: const EdgeInsets.fromLTRB(0, 90, 0, 0),
                      padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                      decoration: BoxDecoration(color: Colors.yellowAccent, borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: wWidth,
                            child: Text(
                              widget.wTitre,
                              style: gColors.bodyTitle1_B_G,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            height: 30,
                          ),
                          Container(
                            color: gColors.black,
                            height: 1,
                          ),
                        ],
                      ),
                    )),

// CONTENT
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      height: wHeightDet2,
                      width: wWidth,
                      child: Partage(context),
                    ),

// Pied
                    Container(
                        child: Container(
                      width: wWidth,
                      height: 100,
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: BoxDecoration(color: gColors.LinearGradient3, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
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
                                  DCL_Param_Dialog.wSel = "";
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
                                  User wUser = User.UserInit();
                                  var witemlistApp = false;
                                  String wValues = "";
                                  for (int i = 0; i < Srv_DbTools.ListUser.length; i++) {
                                    wUser = Srv_DbTools.ListUser[i];
                                    witemlistApp = itemlistApp[i];
                                    if (witemlistApp) wValues += "${wUser.User_Matricule},";
                                  }
                                  Srv_DbTools.gDCL_Ent.DCL_Ent_Partage = wValues;
                                  Srv_DbTools.setDCL_Ent(Srv_DbTools.gDCL_Ent);
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
          ],
        ),
      ],
    );
  }
}

//**********************************
//**********************************
//**********************************

class DCLParamDialog_Rglt extends StatefulWidget {
  final String wTitre;
  final String wNote;
  const DCLParamDialog_Rglt({Key? key, required this.wTitre, required this.wNote}) : super(key: key);

  @override
  _DCLParamDialog_RgltState createState() => _DCLParamDialog_RgltState();
}

class _DCLParamDialog_RgltState extends State<DCLParamDialog_Rglt> {
  static List<bool> itemlistApp = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  Widget RGLT(BuildContext context) {
    double wWidth = 510;
    double wHeightBtn = 45;

    print("_buildPopupDialog");

    List<Widget> cclistMes = [];
    for (int i = 0; i < listRegl.length; i++) {
      var wlistMes = listRegl[i];
      var witemlistApp = false;
      if (i < itemlistApp.length) {
        witemlistApp = itemlistApp[i];
      }
      cclistMes.add(GestureDetector(
        onTap: () async {
          setState(() {
            print("itemlistApp $i ${itemlistApp.length}");
            itemlistApp[i] = !itemlistApp[i];
          });
        },
        child: Container(
            decoration: BoxDecoration(
              color: gColors.white,
              border: Border.all(
                width: 0.7,
                color: gColors.black,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            height: wHeightBtn,
            width: wWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text("$wlistMes", textAlign: TextAlign.left, maxLines: 1, style: gColors.bodyTitle1_N_Gr),
                ),
                gColors.gCircle(witemlistApp ? gColors.primaryGreen : gColors.LinearGradient5, wSize: 24),
              ],
            )),
      ));
    }

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: cclistMes.length, // number of items in your list
      itemBuilder: (BuildContext context, int Itemindex) {
        return Container(
          height: 80,
          child: cclistMes[Itemindex],
        );
      },
    );
  }

  Future Reload() async {
    String wRegl = Srv_DbTools.gDCL_Ent.DCL_Ent_Regl!;
    if (wRegl.isNotEmpty) {
      itemlistApp = json.decode(wRegl).cast<bool>().toList();
      for (int i = 0; i < itemlistApp.length; i++) {
        var element = itemlistApp[i];
        if (element) {
          wRegl = "$wRegl${wRegl.isNotEmpty ? ", " : ""}${listRegl[i]}";
        }
      }
    }

    setState(() {});
  }

  @override
  void initLib() async {
    Reload();
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
    double wHeightDet = 585;
    double wHeightDet2 = 610;

    double wHeightBtn = 45;

    double wHeightBtnValider = 40;

    return SimpleDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.transparent,
      backgroundColor: gColors.transparent,
      shadowColor: gColors.transparent,
      children: [
        Column(
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
                      height: 99,
                      margin: const EdgeInsets.fromLTRB(0, 90, 0, 0),
                      padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                      decoration: BoxDecoration(color: Colors.yellowAccent, borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: wWidth,
                            child: Text(
                              widget.wTitre,
                              style: gColors.bodyTitle1_B_G,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            height: 30,
                          ),
                          Container(
                            color: gColors.black,
                            height: 1,
                          ),
                        ],
                      ),
                    )),

// CONTENT
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      height: wHeightDet2,
                      width: wWidth,
                      child: RGLT(context),
                    ),

// Pied
                    Container(
                        child: Container(
                      width: wWidth,
                      height: 100,
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: BoxDecoration(color: gColors.LinearGradient3, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
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
                                  DCL_Param_Dialog.wSel = "";
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
                                  Srv_DbTools.gDCL_Ent.DCL_Ent_Regl = itemlistApp.toString();
                                  Srv_DbTools.setDCL_Ent(Srv_DbTools.gDCL_Ent);
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
          ],
        ),
      ],
    );
  }
}

//**********************************
//**********************************
//**********************************

class DCLParamDialog_ScanDoc extends StatefulWidget {
  final String wTitre;
  final String wNote;
  const DCLParamDialog_ScanDoc({Key? key, required this.wTitre, required this.wNote}) : super(key: key);

  @override
  _DCLParamDialog_ScanDocState createState() => _DCLParamDialog_ScanDocState();
}

class _DCLParamDialog_ScanDocState extends State<DCLParamDialog_ScanDoc> {
  String wFile1 = "";
  String wFile2 = "";
  String wFile3 = "";
  List<DCL_Ent_Img> lDCL_Ent_Img = [];
  List<DCL_Ent_Img> lDCL_Ent_Doc = [];

  List<Uint8List> Uint8ListList = [];
  List<Widget> imgList = [];

  bool isZoom = false;
  int zoomIndex = 0;

  Future Reload() async {
    imgList.clear();
    Uint8ListList.clear();
    lDCL_Ent_Img.clear();

    await Srv_DbTools.getDCL_Ent_ImgID(Srv_DbTools.gDCL_Ent.DCL_EntID!, "D");

    print("getDCL_Ent_ImgID ADD");

    print("getDCL_Ent_ImgID ADD");
    DCL_Ent_Img wDCL_Ent_Img = DCL_Ent_Img();
    wDCL_Ent_Img.dCLEntImgEntID = Srv_DbTools.gDCL_Ent.DCL_EntID;
    wDCL_Ent_Img.DCL_Ent_Img_Type = "D";
    wDCL_Ent_Img.DCL_Ent_Img_No = 0;
    wDCL_Ent_Img.DCL_Ent_Img_Name = "";
    wDCL_Ent_Img.dCLEntImgData = "";
    await Srv_DbTools.InsertUpdateDCL_Ent_Img_Srv(wDCL_Ent_Img);

    wDCL_Ent_Img = DCL_Ent_Img();
    wDCL_Ent_Img.dCLEntImgEntID = Srv_DbTools.gDCL_Ent.DCL_EntID;
    wDCL_Ent_Img.DCL_Ent_Img_Type = "D";
    wDCL_Ent_Img.DCL_Ent_Img_No = 1;
    wDCL_Ent_Img.DCL_Ent_Img_Name = "";
    wDCL_Ent_Img.dCLEntImgData = "";
    await Srv_DbTools.InsertUpdateDCL_Ent_Img_Srv(wDCL_Ent_Img);

    wDCL_Ent_Img = DCL_Ent_Img();
    wDCL_Ent_Img.dCLEntImgEntID = Srv_DbTools.gDCL_Ent.DCL_EntID;
    wDCL_Ent_Img.DCL_Ent_Img_Type = "D";
    wDCL_Ent_Img.DCL_Ent_Img_No = 2;
    wDCL_Ent_Img.DCL_Ent_Img_Name = "";
    wDCL_Ent_Img.dCLEntImgData = "";
    await Srv_DbTools.InsertUpdateDCL_Ent_Img_Srv(wDCL_Ent_Img);

    await Srv_DbTools.getDCL_Ent_ImgID(Srv_DbTools.gDCL_Ent.DCL_EntID!, "D");

    lDCL_Ent_Doc.clear();
    for (int i = 0; i < Srv_DbTools.ListDCL_Ent_Img.length; i++) {
      var wDCL_Ent_Img = Srv_DbTools.ListDCL_Ent_Img[i];
      lDCL_Ent_Doc.add(wDCL_Ent_Img);
    }

    print("Reload ${Srv_DbTools.ListDCL_Ent_Img.length} ${lDCL_Ent_Doc.length}");

    await Srv_DbTools.getDCL_Ent_ImgID(Srv_DbTools.gDCL_Ent.DCL_EntID!, "I");

    for (int i = 0; i < Srv_DbTools.ListDCL_Ent_Img.length; i++) {
      var wDCL_Ent_Img = Srv_DbTools.ListDCL_Ent_Img[i];
      var bytes = base64Decode(wDCL_Ent_Img.dCLEntImgData!);
      Widget wWidget = Container();
      if (bytes.length > 0) {
        wWidget = Container(
          height: 130,
          width: 130,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              width: 1,
              color: gColors.greyDark2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.0),
            child: Image.memory(
              bytes,
              fit: BoxFit.contain,
            ),
          ),
        );
        lDCL_Ent_Img.add(wDCL_Ent_Img);
        Uint8ListList.add(bytes);
      } else {
        wWidget = Container(
          height: 130,
          width: 130,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              width: 1,
              color: gColors.greyDark2,
            ),
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(24.0),
              child: Container(
                child: SvgPicture.asset(
                  "assets/images/DCL_Doc.svg",
                ),
              )),
        );
        Uint8List wUint8List = Uint8List.fromList([]);
        Uint8ListList.add(wUint8List);
      }

      imgList.add(wWidget);
    }

    for (int i = imgList.length; i < 3; i++) {
      Widget wWidget = Container();
      wWidget = Container(
        height: 130,
        width: 130,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            width: 1,
            color: gColors.greyDark2,
          ),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(24.0),
            child: Container(
              child: SvgPicture.asset(
                "assets/images/DCL_Doc.svg",
              ),
            )),
      );

      imgList.add(wWidget);
      Uint8List wUint8List = Uint8List.fromList([]);
      Uint8ListList.add(wUint8List);
    }

    setState(() {});
  }

  @override
  void initLib() async {
    Reload();
  }

  @override
  void initState() {
    initLib();
  }

  Widget Photo2(BuildContext context) {
    var gDCL_Ent_Img = Srv_DbTools.ListDCL_Ent_Img[zoomIndex];
    var bytes = base64Decode(gDCL_Ent_Img.dCLEntImgData!);
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28.0),
              child: Image.memory(
                bytes,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      width: 550,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Column(
            children: [
              Container(
                  padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                  height: 580,
                  color: Colors.white,
                  child: GestureDetector(
                    onTap: () async {
                      Uint8List wUint8List = Uint8ListList[zoomIndex];
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ImagePainterTools2(wUint8List: wUint8List, wDCL_Ent_Img: Srv_DbTools.ListDCL_Ent_Img[zoomIndex]),
                        ),
                      );
                      await Reload();
                    },
                    child: Container(
                      child: Column(
                        children: [
                          wWidget,
                          Container(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
          Positioned(
              top: 40,
              right: 20,
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
                    await gDialogs.Dialog_MsgBox2(context, "${Srv_DbTools.gDCL_Ent.DCL_Ent_Num} - ${Srv_DbTools.gDCL_Ent.DCL_Ent_Date}", "ico5b", "Êtes-vous sur de vouloir", "éffacer la photo ?");

                    if (MsgBoxDialog2.gRep) {
                      await Srv_DbTools.delDCL_Ent_Img_Srv(Srv_DbTools.ListDCL_Ent_Img[zoomIndex].dCLEntImgid!);
                    }

                    isZoom = false;
                    initLib();
                  })),
        ],
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: gColors.trred,
      margin: EdgeInsets.fromLTRB(0, 10, 0, 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(Icons.delete, color: Colors.red, size: 40),
          SizedBox(
            width: 40,
          ),
        ],
      ),
    );
  }

  Widget DialogSuppr(BuildContext context, String wTitre) {
    double heightPos = 70;
    double wHeightPied = 105;
    double wLeft = 0;
    double wHeightBtnValider = 50;
    double wLabelWidth = 120;

    double wHeightDet2 = 502;
    double wWidth = 520;
    double wHeightTitre = 135;

    double wHeight = wHeightTitre + wHeightDet2 + wHeightPied - 30;

    print(" B U I L D ");

    return SimpleDialog(
      insetPadding: EdgeInsets.all(60),
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.transparent,
      backgroundColor: gColors.white,
      shadowColor: gColors.transparent,
      children: [
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              color: Colors.transparent,
              height: wHeight,
              width: wWidth,
            ),

////////////
// ENTETE
////////////
            Positioned(
              top: 0,
              left: 0,
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                child: Container(
                  height: wHeightTitre,
                  width: wWidth,
                  decoration: BoxDecoration(color: Colors.yellowAccent, borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
                  child: Container(
                      color: Colors.transparent,
                      height: wHeightTitre - 26,
                      padding: const EdgeInsets.fromLTRB(30, 0, 10, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/images/DCL_Warning.svg",
                                height: 60,
                                width: 60,
                              ),
                              Container(width: 5),
                              Text(
                                "Supprimer le document ?",
                                style: gColors.bodyTitle1_B_G24,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                        ],
                      )),
                ),
              ),
            ),

///////////
// PIED
///////////

            Positioned(
              top: wHeightTitre + wHeightDet2 - 30,
              left: wLeft,
              child: Container(
                  child: Container(
                width: wWidth,
                height: wHeightPied,
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
                      color: gColors.LinearGradient4,
                      height: 1,
                    ),
                    Container(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 20,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: gColors.primaryRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Container(
                            width: 110,
                            height: wHeightBtnValider,
                            padding: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                            child: Text(
                              "Non",
                              style: gColors.bodyTitle1_B_W24,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                        ),
                        Container(
                          width: 20,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: gColors.primaryGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              )),
                          child: Container(
                            width: 110,
                            height: wHeightBtnValider,
                            padding: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                            child: Text(
                              "Oui",
                              style: gColors.bodyTitle1_B_W24,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onPressed: () async {
                            await Srv_DbTools.delDCL_Ent_Img(Srv_DbTools.gDCL_Ent_Img.dCLEntImgid!);
                            Navigator.pop(context);
                            await Reload();
                          },
                        ),
                        Container(
                          width: 20,
                        ),
                      ],
                    )
                  ],
                ),
              )),
            ),

////////////
// CONTENT
////////////

            Positioned(
              top: wHeightTitre + 8,
              left: wLeft,
              child: Container(
                padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                height: wHeightDet2 - 24,
                width: wWidth,
                color: gColors.white,
                child: Column(
                  children: [
                    Text(
                      "${wTitre}",
                      maxLines: 3,
                      style: gColors.bodyTitle1_B_G24,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (lDCL_Ent_Doc.length == 0) return Container();

    print(" Srv_DbTools.SelDCL_DateDeb ${Srv_DbTools.SelDCL_DateDeb}");

    double wWidth = 550;
    double wHeight = 1024;
    double wHeightDet = 585;
    double wHeightDet2 = 610;

    double wHeightBtn = 45;

    double wHeightBtnValider = 40;

    String DCL_Ent_Img_Name0 = "";
    String DCL_Ent_Img_Name1 = "";
    String DCL_Ent_Img_Name2 = "";

    try {
      DCL_Ent_Img_Name0 = lDCL_Ent_Doc[0].DCL_Ent_Img_Name!;
    } catch (_) {}
    try {
      DCL_Ent_Img_Name1 = lDCL_Ent_Doc[1].DCL_Ent_Img_Name!;
    } catch (_) {}
    try {
      DCL_Ent_Img_Name2 = lDCL_Ent_Doc[2].DCL_Ent_Img_Name!;
    } catch (_) {}

    print(" DCL_Ent_Img_Name0 ${DCL_Ent_Img_Name0} ${lDCL_Ent_Doc.length}");
    print(" DCL_Ent_Img_Name1 ${DCL_Ent_Img_Name1}");
    print(" DCL_Ent_Img_Name2 ${DCL_Ent_Img_Name2}");

    return SimpleDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.transparent,
      backgroundColor: gColors.transparent,
      shadowColor: gColors.transparent,
      children: [
        Column(
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
                      height: 99,
                      margin: const EdgeInsets.fromLTRB(0, 90, 0, 0),
                      padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                      decoration: BoxDecoration(color: Colors.yellowAccent, borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: wWidth,
                            child: Text(
                              widget.wTitre,
                              style: gColors.bodyTitle1_B_G,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            height: 30,
                          ),
                          Container(
                            color: gColors.black,
                            height: 1,
                          ),
                        ],
                      ),
                    )),

// CONTENT
                    isZoom
                        ? Photo2(context)
                        : Container(
                            color: Colors.white,
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            height: wHeightDet2,
                            width: wWidth,
                            child: Column(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      color: gColors.primaryGreen,
                                      border: Border.all(
                                        width: 0.7,
                                        color: gColors.primaryGreen,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                    margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    height: wHeightBtn,
                                    width: wWidth,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [Text("Sélectionner un fichier", textAlign: TextAlign.left, maxLines: 1, style: gColors.bodyTitle1_B_W)],
                                    )),
                                Dismissible(
                                  background: slideLeftBackground(),
                                  secondaryBackground: slideLeftBackground(),
                                  direction: DismissDirection.endToStart,
                                  key: ValueKey<int>(0),
                                  confirmDismiss: (DismissDirection direction) async {
                                    await HapticFeedback.vibrate();
                                    Srv_DbTools.gDCL_Ent_Img = lDCL_Ent_Doc[0];
                                    ;
                                    await showDialog(context: context, builder: (BuildContext context) => DialogSuppr(context, lDCL_Ent_Doc[0].DCL_Ent_Img_Name!));
                                    print("confirmDismiss");
                                  },
                                  child: GestureDetector(
                                    onTap: () async {
                                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                                        type: FileType.custom,
                                        allowedExtensions: ['pdf'],
                                      );

                                      if (result != null) {
                                        File docFile = File(result.files.single.path!);
                                        Uint8List fileBytes = docFile.readAsBytesSync();

                                        if (wFile1.isEmpty) {
                                          DCL_Ent_Img wDCL_Ent_Img = lDCL_Ent_Doc[0];
                                          wDCL_Ent_Img.DCL_Ent_Img_Name = result.files.single.name;
                                          wDCL_Ent_Img.dCLEntImgData = await base64Encode(fileBytes);
                                          await Srv_DbTools.setDCL_Ent_Img(wDCL_Ent_Img);
                                          await Reload();
                                        }
                                      } else {
                                        // User canceled the picker
                                      }
                                    },
                                    child: Container(
                                        margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
                                        height: 57,
                                        width: wWidth,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/images/DCL_SelectFile.svg",
                                              width: 40,
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: Text("${DCL_Ent_Img_Name0}", textAlign: TextAlign.left, maxLines: 1, style: gColors.bodyTitle1_N_G),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                print("GestureDetector");
                                                late SfPdfViewer wSfPdfViewer;
                                                PdfViewerController wPdfViewerController = PdfViewerController();
                                                print("wDocPath ${lDCL_Ent_Doc[1].DCL_Ent_Img_Name} ");
                                                var _bytes = base64Decode(lDCL_Ent_Doc[0].dCLEntImgData!);
                                                print("wDocPath  length ${_bytes.length}");
                                                if (_bytes.length > 0) {
                                                  wSfPdfViewer = await SfPdfViewer.memory(
                                                    controller: wPdfViewerController,
                                                    initialZoomLevel: 1,
                                                    maxZoomLevel: 12,
                                                    _bytes,
                                                    enableDocumentLinkAnnotation: false,
                                                    enableTextSelection: false,
                                                    interactionMode: PdfInteractionMode.pan,
                                                  );
                                                  await Navigator.push(context, MaterialPageRoute(builder: (context) => PdfView(pdf: wSfPdfViewer)));
                                                  Reload();
                                                }
                                              },
                                              child: SvgPicture.asset(
                                                "assets/images/DCL_UpdFile.svg",
                                                width: 40,
                                              ),
                                            )
                                          ],
                                        )),
                                  ),
                                ),
                                Dismissible(
                                    background: slideLeftBackground(),
                                    secondaryBackground: slideLeftBackground(),
                                    direction: DismissDirection.endToStart,
                                    key: ValueKey<int>(1),
                                    confirmDismiss: (DismissDirection direction) async {
                                      await HapticFeedback.vibrate();
                                      Srv_DbTools.gDCL_Ent_Img = lDCL_Ent_Doc[1];
                                      ;
                                      await showDialog(context: context, builder: (BuildContext context) => DialogSuppr(context, lDCL_Ent_Doc[1].DCL_Ent_Img_Name!));
                                    },
                                    child: GestureDetector(
                                      onTap: () async {
                                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                                          type: FileType.custom,
                                          allowedExtensions: ['pdf'],
                                        );

                                        if (result != null) {
                                          File docFile = File(result.files.single.path!);
                                          Uint8List fileBytes = docFile.readAsBytesSync();

                                          if (wFile1.isEmpty) {
                                            DCL_Ent_Img wDCL_Ent_Img = lDCL_Ent_Doc[1];
                                            wDCL_Ent_Img.DCL_Ent_Img_Name = result.files.single.name;
                                            wDCL_Ent_Img.dCLEntImgData = await base64Encode(fileBytes);
                                            await Srv_DbTools.setDCL_Ent_Img(wDCL_Ent_Img);
                                            await Reload();
                                          }
                                        } else {
                                          // User canceled the picker
                                        }
                                      },
                                      child: Container(
                                          margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
                                          height: 57,
                                          width: wWidth,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/images/DCL_SelectFile.svg",
                                                width: 40,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: Text("${DCL_Ent_Img_Name1}", textAlign: TextAlign.left, maxLines: 1, style: gColors.bodyTitle1_N_G),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  print("GestureDetector");
                                                  late SfPdfViewer wSfPdfViewer;
                                                  PdfViewerController wPdfViewerController = PdfViewerController();
                                                  print("wDocPath ${lDCL_Ent_Doc[1].DCL_Ent_Img_Name} ");
                                                  var _bytes = base64Decode(lDCL_Ent_Doc[1].dCLEntImgData!);
                                                  print("wDocPath  length ${_bytes.length}");
                                                  if (_bytes.length > 0) {
                                                    wSfPdfViewer = await SfPdfViewer.memory(
                                                      controller: wPdfViewerController,
                                                      initialZoomLevel: 1,
                                                      maxZoomLevel: 12,
                                                      _bytes,
                                                      enableDocumentLinkAnnotation: false,
                                                      enableTextSelection: false,
                                                      interactionMode: PdfInteractionMode.pan,
                                                    );
                                                    await Navigator.push(context, MaterialPageRoute(builder: (context) => PdfView(pdf: wSfPdfViewer)));
                                                    Reload();
                                                  }
                                                },
                                                child: SvgPicture.asset(
                                                  "assets/images/DCL_UpdFile.svg",
                                                  width: 40,
                                                ),
                                              )
                                            ],
                                          )),
                                    )),
                                Dismissible(
                                  background: slideLeftBackground(),
                                  secondaryBackground: slideLeftBackground(),
                                  direction: DismissDirection.endToStart,
                                  key: ValueKey<int>(2),
                                  confirmDismiss: (DismissDirection direction) async {
                                    await HapticFeedback.vibrate();
                                    Srv_DbTools.gDCL_Ent_Img = lDCL_Ent_Doc[2];
                                    await showDialog(context: context, builder: (BuildContext context) => DialogSuppr(context, lDCL_Ent_Doc[2].DCL_Ent_Img_Name!));
                                  },
                                  child: GestureDetector(
                                    onTap: () async {
                                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                                        type: FileType.custom,
                                        allowedExtensions: ['pdf'],
                                      );

                                      if (result != null) {
                                        File docFile = File(result.files.single.path!);
                                        Uint8List fileBytes = docFile.readAsBytesSync();

                                        if (wFile1.isEmpty) {
                                          DCL_Ent_Img wDCL_Ent_Img = lDCL_Ent_Doc[2];
                                          wDCL_Ent_Img.DCL_Ent_Img_Name = result.files.single.name;
                                          wDCL_Ent_Img.dCLEntImgData = await base64Encode(fileBytes);
                                          await Srv_DbTools.setDCL_Ent_Img(wDCL_Ent_Img);
                                          await Reload();
                                        }
                                      } else {
                                        // User canceled the picker
                                      }
                                    },
                                    child: Container(
                                        margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
                                        height: 57,
                                        width: wWidth,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/images/DCL_SelectFile.svg",
                                              width: 40,
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: Text("${DCL_Ent_Img_Name2}", textAlign: TextAlign.left, maxLines: 1, style: gColors.bodyTitle1_N_G),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                print("GestureDetector");
                                                late SfPdfViewer wSfPdfViewer;
                                                PdfViewerController wPdfViewerController = PdfViewerController();
                                                print("wDocPath ${lDCL_Ent_Doc[1].DCL_Ent_Img_Name} ");
                                                var _bytes = base64Decode(lDCL_Ent_Doc[2].dCLEntImgData!);
                                                print("wDocPath  length ${_bytes.length}");
                                                if (_bytes.length > 0) {
                                                  wSfPdfViewer = await SfPdfViewer.memory(
                                                    controller: wPdfViewerController,
                                                    initialZoomLevel: 1,
                                                    maxZoomLevel: 12,
                                                    _bytes,
                                                    enableDocumentLinkAnnotation: false,
                                                    enableTextSelection: false,
                                                    interactionMode: PdfInteractionMode.pan,
                                                  );
                                                  await Navigator.push(context, MaterialPageRoute(builder: (context) => PdfView(pdf: wSfPdfViewer)));
                                                  Reload();
                                                }
                                              },
                                              child: SvgPicture.asset(
                                                "assets/images/DCL_UpdFile.svg",
                                                width: 40,
                                              ),
                                            )
                                          ],
                                        )),
                                  ),
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                      color: gColors.primaryGreen,
                                      border: Border.all(
                                        width: 0.7,
                                        color: gColors.primaryGreen,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                    margin: EdgeInsets.fromLTRB(50, 0, 50, 50),
                                    // TED
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    // TED
                                    height: wHeightBtn,
                                    width: wWidth,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [Text("Prendre une photo", textAlign: TextAlign.left, maxLines: 1, style: gColors.bodyTitle1_B_W)],
                                    )),
                                Spacer(),
                                Container(
                                  margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  height: 250,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: imgList.length, // number of items in your list
                                      itemBuilder: (BuildContext context, int Itemindex) {
                                        return Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                print("onTap $Itemindex ${Uint8ListList[Itemindex].length}");

                                                if (Uint8ListList[Itemindex].length == 0) {
                                                  print("onTap $Itemindex VIDE");

                                                  DbTools.gImagePath = "";
                                                  gPhotos.wImg = 1;
                                                  gPhotos.ImgDoc = Itemindex;

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

                                                    setState(() async {
                                                      await Reload();
                                                    });
                                                  }
                                                } else {
                                                  print("onTap $Itemindex IMAGE");

                                                  zoomIndex = Itemindex;
                                                  isZoom = true;
                                                  setState(() {});
                                                }

                                                ;
                                              },
                                              child: Container(
                                                child: Column(
                                                  children: [
                                                    imgList[Itemindex],
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
                                Spacer(),
                              ],
                            )),

// Pied
                    Container(
                        child: Container(
                      width: wWidth,
                      height: 100,
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: BoxDecoration(color: gColors.LinearGradient3, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
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
                                  DCL_Param_Dialog.wSel = "";
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
                                  if (isZoom) {
                                    isZoom = false;
                                    setState(() {});
                                  } else
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
          ],
        ),
      ],
    );
  }
}

//**********************************
//**********************************
//**********************************

class DCLParamDialog_Relance extends StatefulWidget {
  final String wTitre;
  final String wContact;
  final String wMail;
  final String wTel;
  const DCLParamDialog_Relance({Key? key, required this.wTitre, required this.wContact, required this.wMail, required this.wTel}) : super(key: key);

  @override
  _DCLParamDialog_RelanceState createState() => _DCLParamDialog_RelanceState();
}

class _DCLParamDialog_RelanceState extends State<DCLParamDialog_Relance> {
  TextEditingController wContactController = new TextEditingController();
  TextEditingController wMailController = new TextEditingController();
  TextEditingController wTelController = new TextEditingController();

  void Reload() async {
    setState(() {});
  }

  @override
  void initLib() async {
    Reload();
  }

  @override
  void initState() {
    wContactController.text = widget.wContact;
    wMailController.text = widget.wMail;
    wTelController.text = widget.wTel;
    initLib();
  }

  @override
  Widget build(BuildContext context) {
    double wWidth = 550;
    double wHeight = 1024;
    double wHeightDet = 585;
    double wHeightDet2 = 610;

    double wHeightBtn = 45;

    double wHeightBtnValider = 40;

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
                      height: 110,
                      margin: const EdgeInsets.fromLTRB(0, 90, 0, 0),
                      padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
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
                              widget.wTitre,
                              style: gColors.bodyTitle1_B_G,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            height: 30,
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
                      height: 110,
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
                                  DCL_Param_Dialog.wSel = "";
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
              top: 190,
              left: 5,
              child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  height: wHeightDet2,
                  width: wWidth,
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: DCL_Param_Dialog.ListParam.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = DCL_Param_Dialog.ListParam[index];

                          return InkWell(
                              onTap: () async {
                                await HapticFeedback.vibrate();
                                DCL_Param_Dialog.wSel = item;
                                setState(() {});
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: (item.compareTo(DCL_Param_Dialog.wSel) == 0) ? gColors.primaryGreen : Colors.transparent,
                                    border: Border.all(
                                      width: 0.7,
                                      color: (item.compareTo(DCL_Param_Dialog.wSel) == 0) ? gColors.primaryGreen : gColors.grey,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                  margin: EdgeInsets.fromLTRB(50, 0, 50, 20),
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  height: wHeightBtn,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(item,
                                          textAlign: TextAlign.left,
                                          maxLines: 1,
                                          style: gColors.bodyTitle1_B_Gr.copyWith(
                                            color: (item.compareTo(DCL_Param_Dialog.wSel) == 0) ? gColors.white : gColors.primary,
                                            fontWeight: (item.compareTo(DCL_Param_Dialog.wSel) == 0) ? FontWeight.bold : FontWeight.normal,
                                          ))
                                    ],
                                  )));
                        },
                      ),
                      Container(
                        color: gColors.black,
                        height: 1,
                      ),
                      Container(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        width: wWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                                onTap: () async {
                                  await HapticFeedback.vibrate();
                                  DCL_Param_Dialog.RelanceMode = "Mail";
                                  setState(() {});
                                },
                                child: Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: DCL_Param_Dialog.RelanceMode == "Mail" ? gColors.primaryGreen : Colors.transparent,
                                      border: Border.all(
                                        width: 0.7,
                                        color: DCL_Param_Dialog.RelanceMode == "Mail" ? gColors.primaryGreen : gColors.grey,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                    // TED
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    // TED
                                    height: wHeightBtn,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("Mail",
                                            textAlign: TextAlign.left,
                                            maxLines: 1,
                                            style: gColors.bodyTitle1_B_Gr.copyWith(
                                              color: DCL_Param_Dialog.RelanceMode == "Mail" ? gColors.white : gColors.primary,
                                              fontWeight: DCL_Param_Dialog.RelanceMode == "Mail" ? FontWeight.bold : FontWeight.normal,
                                            ))
                                      ],
                                    ))),
                            InkWell(
                                onTap: () async {
                                  await HapticFeedback.vibrate();
                                  DCL_Param_Dialog.RelanceMode = "SMS";
                                  setState(() {});
                                },
                                child: Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: DCL_Param_Dialog.RelanceMode == "SMS" ? gColors.primaryGreen : Colors.transparent,
                                      border: Border.all(
                                        width: 0.7,
                                        color: DCL_Param_Dialog.RelanceMode == "SMS" ? gColors.primaryGreen : gColors.grey,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                    // TED
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    // TED
                                    height: wHeightBtn,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("SMS",
                                            textAlign: TextAlign.left,
                                            maxLines: 1,
                                            style: gColors.bodyTitle1_B_Gr.copyWith(
                                              color: DCL_Param_Dialog.RelanceMode == "SMS" ? gColors.white : gColors.primary,
                                              fontWeight: DCL_Param_Dialog.RelanceMode == "SMS" ? FontWeight.bold : FontWeight.normal,
                                            ))
                                      ],
                                    ))),
                            InkWell(
                                onTap: () async {
                                  await HapticFeedback.vibrate();
                                  DCL_Param_Dialog.RelanceMode = "WhatsApp";
                                  setState(() {});
                                },
                                child: Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: DCL_Param_Dialog.RelanceMode == "WhatsApp" ? gColors.primaryGreen : Colors.transparent,
                                      border: Border.all(
                                        width: 0.7,
                                        color: DCL_Param_Dialog.RelanceMode == "WhatsApp" ? gColors.primaryGreen : gColors.grey,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                    // TED
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    // TED
                                    height: wHeightBtn,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("WhatsApp",
                                            textAlign: TextAlign.left,
                                            maxLines: 1,
                                            style: gColors.bodyTitle1_B_Gr.copyWith(
                                              color: DCL_Param_Dialog.RelanceMode == "WhatsApp" ? gColors.white : gColors.primary,
                                              fontWeight: DCL_Param_Dialog.RelanceMode == "WhatsApp" ? FontWeight.bold : FontWeight.normal,
                                            ))
                                      ],
                                    ))),
                          ],
                        ),
                      ),
                      Container(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            width: 0.7,
                            color: gColors.grey,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 20), // TED
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0), // TED
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: "Contact :",
                            labelStyle: gColors.bodyTitle1_B_Gr,
                          ),
                          keyboardType: TextInputType.name,
                          controller: wContactController,
                          minLines: 1,
                          maxLines: 1,
                          onChanged: (value) {
                            DCL_Param_Dialog.wContact = value;
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            width: 0.7,
                            color: gColors.grey,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 20), // TED
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0), // TED
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: "Mail :",
                            labelStyle: gColors.bodyTitle1_B_Gr,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          controller: wMailController,
                          minLines: 1,
                          maxLines: 1,
                          onChanged: (value) {
                            DCL_Param_Dialog.wMail = value;
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            width: 0.7,
                            color: gColors.grey,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 20), // TED
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0), // TED
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: "Tél :",
                            labelStyle: gColors.bodyTitle1_B_Gr,
                          ),
                          keyboardType: TextInputType.phone,
                          controller: wTelController,
                          minLines: 1,
                          maxLines: 1,
                          onChanged: (value) {
                            DCL_Param_Dialog.wTel = value;
                          },
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ],
    );
  }
}

//**********************************
//**********************************
//**********************************

class DCLParamDialog_Note extends StatefulWidget {
  final String wTitre;
  final String wNote;
  const DCLParamDialog_Note({Key? key, required this.wTitre, required this.wNote}) : super(key: key);

  @override
  _DCLParamDialog_NoteState createState() => _DCLParamDialog_NoteState();
}

class _DCLParamDialog_NoteState extends State<DCLParamDialog_Note> {
  TextEditingController wNoteController = new TextEditingController();

  void Reload() async {
    setState(() {});
  }

  @override
  void initLib() async {
    Reload();
  }

  @override
  void initState() {
    wNoteController.text = widget.wNote;
    initLib();
  }

  @override
  Widget build(BuildContext context) {
    print(" Srv_DbTools.SelDCL_DateDeb ${Srv_DbTools.SelDCL_DateDeb}");

    double wWidth = 550;
    double wHeight = 1024;
    double wHeightDet = 585;
    double wHeightDet2 = 610;

    double wHeightBtn = 45;

    double wHeightBtnValider = 40;

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
                      height: 110,
                      margin: const EdgeInsets.fromLTRB(0, 90, 0, 0),
                      padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
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
                              widget.wTitre,
                              style: gColors.bodyTitle1_B_G,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            height: 30,
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
                      height: 110,
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
                                  DCL_Param_Dialog.wSel = "";
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
              top: 190,
              left: 5,
              child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  height: wHeightDet2,
                  width: wWidth,
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: DCL_Param_Dialog.ListParam.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = DCL_Param_Dialog.ListParam[index];

                          return InkWell(
                              onTap: () async {
                                await HapticFeedback.vibrate();
                                DCL_Param_Dialog.wSel = item;
                                setState(() {});
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: (item.compareTo(DCL_Param_Dialog.wSel) == 0) ? gColors.primaryGreen : Colors.transparent,
                                    border: Border.all(
                                      width: 0.7,
                                      color: (item.compareTo(DCL_Param_Dialog.wSel) == 0) ? gColors.primaryGreen : gColors.grey,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                  margin: EdgeInsets.fromLTRB(50, 0, 50, 20),
                                  // TED
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  // TED
                                  height: wHeightBtn,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(item,
                                          textAlign: TextAlign.left,
                                          maxLines: 1,
                                          style: gColors.bodyTitle1_B_Gr.copyWith(
                                            color: (item.compareTo(DCL_Param_Dialog.wSel) == 0) ? gColors.white : gColors.primary,
                                            fontWeight: (item.compareTo(DCL_Param_Dialog.wSel) == 0) ? FontWeight.bold : FontWeight.normal,
                                          ))
                                    ],
                                  )));
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            width: 0.7,
                            color: gColors.grey,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        margin: EdgeInsets.fromLTRB(50, 0, 50, 20), // TED
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0), // TED

                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          controller: wNoteController,
                          minLines: 10,
                          maxLines: 10,
                          onChanged: (value) {
                            DCL_Param_Dialog.wNote = value;
                          },
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ],
    );
  }
}

//**********************************
//**********************************
//**********************************

class DCLParamDialog_Text extends StatefulWidget {
  final String wTitre;
  final String wNote;
  const DCLParamDialog_Text({Key? key, required this.wTitre, required this.wNote}) : super(key: key);

  @override
  _DCLParamDialog_TextState createState() => _DCLParamDialog_TextState();
}

class _DCLParamDialog_TextState extends State<DCLParamDialog_Text> {
  TextEditingController wNoteController = new TextEditingController();

  void Reload() async {
    setState(() {});
  }

  @override
  void initLib() async {
    Reload();
  }

  @override
  void initState() {
    wNoteController.text = widget.wNote;
    initLib();
  }

  @override
  Widget build(BuildContext context) {
    print(" Srv_DbTools.SelDCL_DateDeb ${Srv_DbTools.SelDCL_DateDeb}");

    double wWidth = 550;
    double wHeight = 1024;
    double wHeightDet = 585;
    double wHeightDet2 = 610;

    double wHeightBtn = 45;

    double wHeightBtnValider = 40;

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
                      height: 110,
                      margin: const EdgeInsets.fromLTRB(0, 90, 0, 0),
                      padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
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
                              widget.wTitre,
                              style: gColors.bodyTitle1_B_G,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            height: 30,
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
                      height: 110,
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
                                  DCL_Param_Dialog.wSel = "";
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
              top: 190,
              left: 5,
              child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  height: wHeightDet2,
                  width: wWidth,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            width: 0.7,
                            color: gColors.grey,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        margin: EdgeInsets.fromLTRB(50, 0, 50, 20), // TED
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0), // TED

                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          controller: wNoteController,
                          minLines: 20,
                          maxLines: 20,
                          onChanged: (value) {
                            DCL_Param_Dialog.wNote = value;
                          },
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ],
    );
  }
}

//**********************************
//**********************************
//**********************************

class DCLParamDialog extends StatefulWidget {
  final String wTitre;
  const DCLParamDialog({Key? key, required this.wTitre}) : super(key: key);

  @override
  _DCLParamDialogState createState() => _DCLParamDialogState();
}

class _DCLParamDialogState extends State<DCLParamDialog> {
  void Reload() async {
    setState(() {});
  }

  @override
  void initLib() async {
    Reload();
  }

  @override
  void initState() {
    initLib();
  }

  @override
  Widget build(BuildContext context) {
    print(" Srv_DbTools.SelDCL_DateDeb ${Srv_DbTools.SelDCL_DateDeb}");

    double wWidth = 550;
    double wHeight = 1084;
    double wHeightDet = 645;
    double wHeightDet2 = 670;

    double wHeightBtn = 45;

    double wHeightBtnValider = 40;

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
                      height: 110,
                      margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
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
                              widget.wTitre,
                              style: gColors.bodyTitle1_B_G,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            height: 30,
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
                      height: 110,
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
                                  DCL_Param_Dialog.wSel = "";
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
              top: 130,
              left: 5,
              child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  height: wHeightDet2,
                  width: wWidth,
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: DCL_Param_Dialog.ListParam.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = DCL_Param_Dialog.ListParam[index];

                          return InkWell(
                              onTap: () async {
                                await HapticFeedback.vibrate();
                                DCL_Param_Dialog.wSel = item;
                                setState(() {});
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: (item.compareTo(DCL_Param_Dialog.wSel) == 0) ? gColors.primaryGreen : Colors.transparent,
                                    border: Border.all(
                                      width: 0.7,
                                      color: (item.compareTo(DCL_Param_Dialog.wSel) == 0) ? gColors.primaryGreen : gColors.grey,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                  margin: EdgeInsets.fromLTRB(50, 0, 50, 20), // TED
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0), // TED
                                  height: wHeightBtn,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(item,
                                          textAlign: TextAlign.left,
                                          maxLines: 1,
                                          style: gColors.bodyTitle1_B_Gr.copyWith(
                                            color: (item.compareTo(DCL_Param_Dialog.wSel) == 0) ? gColors.white : gColors.primary,
                                            fontWeight: (item.compareTo(DCL_Param_Dialog.wSel) == 0) ? FontWeight.bold : FontWeight.normal,
                                          ))
                                    ],
                                  )));
                        },
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ],
    );
  }

//***************************
//***************************
//***************************
}
