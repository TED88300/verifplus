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
import 'package:verifplus/Widget/GestCo/DCL_Devis_Det.dart';
import 'package:verifplus/Widget/Widget_Tools/ImagePainterTools.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gPhotos.dart';

class gDialogs {
  gDialogs();

  static Future<void> Dialog_QrCode(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => const QrCodeDialog(),
    );
  }

  static Future<void> Dialog_Photo(BuildContext context, String wTxt, String wTxt2, String wTxt3) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => PhotoDialog(wTxt: wTxt, wTxt2: wTxt2, wTxt3: wTxt3),
    );
  }

  static Future<void> Dialog_MsgBox(BuildContext context, String wTxt, String wTxt2, String wTxt3, String wImg, String wLabel1, String wLabel2) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => MsgBoxDialog(wTxt: wTxt, wTxt2: wTxt2, wTxt3: wTxt3, wImg: wImg, wLabel1: wLabel1, wLabel2: wLabel2),
    );
  }

  static Future<void> Dialog_MsgBox2(BuildContext context, String wTxt, String wImg, String wLabel1, String wLabel2) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => MsgBoxDialog2(wTxt: wTxt, wImg: wImg, wLabel1: wLabel1, wLabel2: wLabel2),
    );
  }

  static Future<void> Dialog_MiseEnServ(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => const MiseEnServDialog(),
    );
  }

  static Future<void> Dialog_CdeDate(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => const CdeDateDialog(),
    );
  }

  static Future<void> Dialog_SelPeriode(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => const SelPeriodeDialog(),
    );
  }

  static Future<void> Dialog_Action(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => const ActionDialog(),
    );
  }

  static Future<void> Dialog_ActionSel(BuildContext context) async {
    await showDialog(
      context: context,
      barrierColor: const Color(0xC8000000),
      builder: (BuildContext context) => const ActionDialogSel(),
    );
  }

  static Future<void> Dialog_ActionType(BuildContext context) async {
    await showDialog(
      context: context,
      barrierColor: const Color(0xC8000000),
      builder: (BuildContext context) => const ActionDialogType(),
    );
  }

  static Future<void> Dialog_ActionLigne(BuildContext context) async {
    await showDialog(
      context: context,
      barrierColor: const Color(0xC8000000),
      builder: (BuildContext context) => const ActionLigneDialog(),
    );
  }

  static Future<void> Dialog_ActionDevis(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => const ActionDialogDevis(),
    );
  }
}

//**********************************
//**********************************
//**********************************

class ActionDialogType extends StatefulWidget {
  const ActionDialogType({super.key});

  @override
  _ActionDialogTypeState createState() => _ActionDialogTypeState();
}

class _ActionDialogTypeState extends State<ActionDialogType> {
  bool isType = false;

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      insetPadding: const EdgeInsets.only(left: 0, bottom: 0),
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.transparent,
      backgroundColor: gColors.transparent,
      shadowColor: gColors.transparent,
      children: [
        Container(
            color: gColors.transparent,
            height: 470,
            margin: const EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: Column(
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            child: Container(
                              width: 470,
                              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Choisissez un document de vente",
                                    style: gColors.bodyTitle1_B_W24,
                                  ),
                                  const Spacer(),
                                  SvgPicture.asset(
                                    "assets/images/Btn_Clear.svg",
                                    width: 60,
                                  ),
                                ],
                              ),
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                              child: Container(
                                width: 120,
                                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: BoxDecoration(
                                  color: gColors.transparent,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Tous',
                                      style: gColors.bodyTitle1_B_W24,
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                Srv_DbTools.gSelDCL_Ent = Srv_DbTools.gSelDCL_EntBase;
                                Navigator.pop(context);
                              }),
                          Text(
                            'Tous',
                            style: gColors.bodyTitle1_B_W24,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                              child: Container(
                                width: 120,
                                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: BoxDecoration(
                                  color: gColors.transparent,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'DEV',
                                      style: gColors.bodyTitle1_B_W24,
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                Srv_DbTools.gSelDCL_Ent = "Devis";
                                Navigator.pop(context);
                              }),
                          SizedBox(
                            width: 300,
                            child: Text(
                              'Devis (DEV)',
                              style: gColors.bodyTitle1_B_W24,
                            ),
                          ),
                          Container(
                            width: 12,
                            height: 32,
                            color: gColors.TypeCDE_DEV,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                              child: Container(
                                width: 120,
                                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: BoxDecoration(
                                  color: gColors.transparent,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'BDC',
                                      style: gColors.bodyTitle1_B_W24,
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                Srv_DbTools.gSelDCL_Ent = "Commande";
                                Navigator.pop(context);
                              }),
                          SizedBox(
                            width: 300,
                            child: Text(
                              'Bon de Commande (BDC)',
                              style: gColors.bodyTitle1_B_W24,
                            ),
                          ),
                          Container(
                            width: 12,
                            height: 32,
                            color: gColors.TypeCDE_BDC,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                              child: Container(
                                width: 120,
                                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: BoxDecoration(
                                  color: gColors.transparent,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'BDL',
                                      style: gColors.bodyTitle1_B_W24,
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                Srv_DbTools.gSelDCL_Ent = "Bon de livraison";
                                Navigator.pop(context);
                              }),
                          SizedBox(
                            width: 300,
                            child: Text(
                              'Bon de Livraison (BDL)',
                              style: gColors.bodyTitle1_B_W24,
                            ),
                          ),
                          Container(
                            width: 12,
                            height: 32,
                            color: gColors.TypeCDE_BDL,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                              child: Container(
                                width: 120,
                                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: BoxDecoration(
                                  color: gColors.transparent,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'BDR',
                                      style: gColors.bodyTitle1_B_W24,
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                Srv_DbTools.gSelDCL_Ent = "Bon de retour";
                                Navigator.pop(context);
                              }),
                          SizedBox(
                            width: 300,
                            child: Text(
                              'Bon de Retours (BDR)',
                              style: gColors.bodyTitle1_B_W24,
                            ),
                          ),
                          Container(
                            width: 12,
                            height: 32,
                            color: gColors.TypeCDE_BDR,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ],
    );
  }
}

//**********************************
//**********************************
//**********************************

class ActionLigneDialog extends StatefulWidget {
  const ActionLigneDialog({super.key});

  @override
  _ActionLigneDialogState createState() => _ActionLigneDialogState();
}

class _ActionLigneDialogState extends State<ActionLigneDialog> {
  bool isSel = false;

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    DCL_Devis_Det.gLongPressAction = 0;

    return SimpleDialog(
      insetPadding: const EdgeInsets.only(left: 180, top: 240),
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      backgroundColor: gColors.transparent,
      shadowColor: gColors.transparent,
      children: [
        Container(
          color: gColors.transparent,
          height: 550,
          child: Stack(
            children: [
              Positioned(
                right: 0,
                bottom: 0,
                width: 60,
                height: 550,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 65, 15, 10),
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 270,
                              padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                              child: Text(
                                'Ajouter ligne de texte',
                                textAlign: TextAlign.right,
                                style: gColors.bodyTitle1_N_W24,
                              ),
                            ),
                            gColors.gCircle(gColors.TextColor2, wSize: 30),
                          ],
                        ),
                      ),
                      onTap: () async {
                        DCL_Devis_Det.gLongPressAction = 1;
                        Navigator.pop(context);
                      }),
                  InkWell(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 15, 10),
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 270,
                              padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                              child: Text(
                                'Dupliquer la ligne',
                                textAlign: TextAlign.right,
                                style: Srv_DbTools.gDCL_Det.DCL_DetID == -1 ? gColors.bodyTitle1_N_GD24 : gColors.bodyTitle1_N_W24,
                              ),
                            ),
                            gColors.gCircle(gColors.TextColor2, wSize: 30),
                          ],
                        ),
                      ),
                      onTap: () async {
                        if (Srv_DbTools.gDCL_Det.DCL_DetID == -1) return;
                        DCL_Devis_Det.gSaveDCL_Det = Srv_DbTools.gDCL_Det;
                        DCL_Devis_Det.gLongPressAction = 2;
                        Navigator.pop(context);
                      }),
                  InkWell(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 15, 10),
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 270,
                              padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                              child: Text(
                                'Copier',
                                textAlign: TextAlign.right,
                                style: Srv_DbTools.gDCL_Det.DCL_DetID == -1 ? gColors.bodyTitle1_N_GD24 : gColors.bodyTitle1_N_W24,
                              ),
                            ),
                            gColors.gCircle(gColors.TextColor2, wSize: 30),
                          ],
                        ),
                      ),
                      onTap: () async {
                        if (Srv_DbTools.gDCL_Det.DCL_DetID == -1) return;
                        DCL_Devis_Det.gSaveDCL_Det = Srv_DbTools.gDCL_Det;
                        DCL_Devis_Det.gLongPressAction = 3;
                        Navigator.pop(context);
                      }),
                  InkWell(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 15, 10),
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 270,
                              padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                              child: Text(
                                'Coller',
                                textAlign: TextAlign.right,
                                style: DCL_Devis_Det.gSaveDCL_Det.DCL_DetID == -1 ? gColors.bodyTitle1_N_GD24 : gColors.bodyTitle1_N_W24,
                              ),
                            ),
                            gColors.gCircle(gColors.TextColor2, wSize: 30),
                          ],
                        ),
                      ),
                      onTap: () async {
                        if (DCL_Devis_Det.gSaveDCL_Det.DCL_DetID == -1) return;
                        DCL_Devis_Det.gLongPressAction = 4;
                        Navigator.pop(context);
                      }),
                  InkWell(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 15, 10),
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 270,
                              padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                              child: Text(
                                'Couper',
                                textAlign: TextAlign.right,
                                style: Srv_DbTools.gDCL_Det.DCL_DetID == -1 ? gColors.bodyTitle1_N_GD24 : gColors.bodyTitle1_N_W24,
                              ),
                            ),
                            gColors.gCircle(gColors.TextColor2, wSize: 30),
                          ],
                        ),
                      ),
                      onTap: () async {
                        if (Srv_DbTools.gDCL_Det.DCL_DetID == -1) return;
                        DCL_Devis_Det.gSaveDCL_Det = Srv_DbTools.gDCL_Det;
                        DCL_Devis_Det.gLongPressAction = 5;
                        Navigator.pop(context);
                      }),
                  InkWell(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 15, 10),
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 270,
                              padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                              child: Text(
                                'Ajouter sous-total',
                                textAlign: TextAlign.right,
                                style: gColors.bodyTitle1_N_W24,
                              ),
                            ),
                            gColors.gCircle(gColors.TextColor2, wSize: 30),
                          ],
                        ),
                      ),
                      onTap: () async {
                        DCL_Devis_Det.gLongPressAction = 6;
                        Navigator.pop(context);
                      }),
                  InkWell(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 15, 10),
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 270,
                              padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                              child: Text(
                                'Ajouter saut de page',
                                textAlign: TextAlign.right,
                                style: gColors.bodyTitle1_N_W24,
                              ),
                            ),
                            gColors.gCircle(gColors.TextColor2, wSize: 30),
                          ],
                        ),
                      ),
                      onTap: () async {
                        DCL_Devis_Det.gLongPressAction = 7;
                        Navigator.pop(context);
                      }),
                ],
              ),
              Positioned(
                right: 0,
                top: 8,
                width: 60,
                height: 60,
                child: InkWell(
                    child: SvgPicture.asset(
                      DCL_Devis_Det.wUpDown ? "assets/images/DCL_FlH.svg" : "assets/images/DCL_FlB.svg",
                      height: 40,
                      width: 40,
                    ),
                    onTap: () async {
                      print("wUpDown");
                      DCL_Devis_Det.wUpDown = !DCL_Devis_Det.wUpDown;
                      setState(() {});
                    }),
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

class SelPeriodeDialog extends StatefulWidget {
  const SelPeriodeDialog({super.key});

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
                                child: Tooltip(textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal), decoration: const BoxDecoration(color: Colors.orange), message: "Filtre Date", child: SizedBox(width: 10, height: 10, child: Image.asset("assets/images/DCL_Date.png"))),
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
                                        Container(padding: const EdgeInsets.only(right: 8.0), child: const Icon(Icons.date_range)),
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
                                        Container(padding: const EdgeInsets.only(right: 8.0), child: const Icon(Icons.date_range)),
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
                                        Container(padding: const EdgeInsets.only(right: 8.0), child: const Icon(Icons.date_range)),
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
                                        Container(padding: const EdgeInsets.only(right: 8.0), child: const Icon(Icons.date_range)),
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
                                        Container(padding: const EdgeInsets.only(right: 8.0), child: const Icon(Icons.date_range)),
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
                                        Container(padding: const EdgeInsets.only(right: 8.0), child: const Icon(Icons.date_range)),
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
                                        Container(padding: const EdgeInsets.only(right: 8.0), child: const Icon(Icons.date_range)),
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
                                        Container(padding: const EdgeInsets.only(right: 8.0), child: const Icon(Icons.date_range)),
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
                                        Container(padding: const EdgeInsets.only(right: 8.0), child: const Icon(Icons.date_range)),
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
                                        Container(padding: const EdgeInsets.only(right: 8.0), child: const Icon(Icons.date_range)),
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
                                        Container(padding: const EdgeInsets.only(right: 8.0), child: const Icon(Icons.date_range)),
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

class ActionDialog extends StatefulWidget {
  const ActionDialog({super.key});

  @override
  _ActionDialogState createState() => _ActionDialogState();
}

class _ActionDialogState extends State<ActionDialog> {
  bool isSel = false;

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      insetPadding: const EdgeInsets.only(left: 200, bottom: 300),
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.transparent,
      backgroundColor: gColors.transparent,
      shadowColor: gColors.transparent,
      children: [
        Container(
            color: gColors.transparent,
            height: 272,
            margin: const EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: Column(
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${Srv_DbTools.gDCL_Ent.DCL_Ent_Statut == 'Préparation' ? '✔︎ ' : ''}Préparation',
                                  style: gColors.bodyTitle1_N_W24,
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {
                            Srv_DbTools.gDCL_Ent.DCL_Ent_Statut = 'Préparation';
                            Srv_DbTools.setDCL_Ent(Srv_DbTools.gDCL_Ent);
                            Navigator.pop(context);
                          }),
                      InkWell(
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${Srv_DbTools.gDCL_Ent.DCL_Ent_Statut == 'En cours' ? '✔︎ ' : ''}En cours',
                                  style: gColors.bodyTitle1_N_W24,
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {
                            Srv_DbTools.gDCL_Ent.DCL_Ent_Statut = 'En cours';
                            Srv_DbTools.setDCL_Ent(Srv_DbTools.gDCL_Ent);
                            Navigator.pop(context);
                          }),
                      InkWell(
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            decoration: BoxDecoration(
                              color: gColors.primaryGreen,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${Srv_DbTools.gDCL_Ent.DCL_Ent_Statut == 'Accepté' ? '✔︎ ' : ''}Accepté',
                                  style: gColors.bodyTitle1_N_W24,
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {
                            Srv_DbTools.gDCL_Ent.DCL_Ent_Statut = 'Accepté';
                            Srv_DbTools.setDCL_Ent(Srv_DbTools.gDCL_Ent);
                            Navigator.pop(context);
                          }),
                      InkWell(
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            decoration: BoxDecoration(
                              color: gColors.red,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${Srv_DbTools.gDCL_Ent.DCL_Ent_Statut == 'Refusé' ? '✔︎ ' : ''}Refusé',
                                  style: gColors.bodyTitle1_N_W24,
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {
                            Srv_DbTools.gDCL_Ent.DCL_Ent_Statut = 'Refusé';
                            Srv_DbTools.setDCL_Ent(Srv_DbTools.gDCL_Ent);
                            Navigator.pop(context);
                          }),
                    ],
                  ),
                ),
              ],
            )),
      ],
    );
  }
}

//**********************************
//**********************************
//**********************************

class ActionDialogSel extends StatefulWidget {
  const ActionDialogSel({super.key});

  @override
  _ActionDialogSelState createState() => _ActionDialogSelState();
}

class _ActionDialogSelState extends State<ActionDialogSel> {
  bool isSel = false;

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      insetPadding: const EdgeInsets.only(left: 0, bottom: 0),
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.transparent,
      backgroundColor: gColors.transparent,
      shadowColor: gColors.transparent,
      children: [
        Container(
            color: gColors.transparent,
            height: 450,
            margin: const EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: Column(
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            child: Container(
                              width: 450,
                              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Choisissez l'état du Devis",
                                    style: gColors.bodyTitle1_B_W24,
                                  ),
                                  const Spacer(),
                                  SvgPicture.asset(
                                    "assets/images/Btn_Clear.svg",
                                    width: 60,
                                  ),
                                ],
                              ),
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                              child: Container(
                                width: 140,
                                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: BoxDecoration(
                                  color: gColors.LinearGradient4,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'État',
                                      style: gColors.bodyTitle1_N_W24,
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                DbTools.wStatusCde = 'Tous';

                                Navigator.pop(context);
                              }),
                          Text(
                            'État',
                            style: gColors.bodyTitle1_N_W24,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                              child: Container(
                                width: 140,
                                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: BoxDecoration(
                                  color: Colors.orangeAccent,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Prépa',
                                      style: gColors.bodyTitle1_N_W24,
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                DbTools.wStatusCde = 'Préparation';

                                Navigator.pop(context);
                              }),
                          SizedBox(
                            width: 250,
                            child: Text(
                              'Devis en préparation',
                              style: gColors.bodyTitle1_N_W24,
                            ),
                          ),
                          gColors.gCircle(Colors.orangeAccent, wSize: 32),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                              child: Container(
                                width: 140,
                                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'En cours',
                                      style: gColors.bodyTitle1_N_W24,
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                DbTools.wStatusCde = 'En cours';
                                Navigator.pop(context);
                              }),
                          SizedBox(
                            width: 250,
                            child: Text(
                              'Devis en cours',
                              style: gColors.bodyTitle1_N_W24,
                            ),
                          ),
                          gColors.gCircle(Colors.blueAccent, wSize: 32),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                              child: Container(
                                width: 140,
                                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: BoxDecoration(
                                  color: gColors.primaryGreen,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Accepté',
                                      style: gColors.bodyTitle1_N_W24,
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                DbTools.wStatusCde = 'Accepté';
                                Navigator.pop(context);
                              }),
                          SizedBox(
                            width: 250,
                            child: Text(
                              'Devis Accepté',
                              style: gColors.bodyTitle1_N_W24,
                            ),
                          ),
                          gColors.gCircle(gColors.primaryGreen, wSize: 32),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                              child: Container(
                                width: 140,
                                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: BoxDecoration(
                                  color: gColors.red,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Refusé',
                                      style: gColors.bodyTitle1_N_W24,
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                DbTools.wStatusCde = 'Refusé';
                                Navigator.pop(context);
                              }),
                          SizedBox(
                            width: 250,
                            child: Text(
                              'Devis Refusé',
                              style: gColors.bodyTitle1_N_W24,
                            ),
                          ),
                          gColors.gCircle(gColors.red, wSize: 32),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ],
    );
  }
}

//**********************************
//**********************************
//**********************************
class ActionDialogDevis extends StatefulWidget {
  const ActionDialogDevis({super.key});

  @override
  _ActionDialogDevisState createState() => _ActionDialogDevisState();
}

class _ActionDialogDevisState extends State<ActionDialogDevis> {
  bool isSel = false;

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(48.0))),
      surfaceTintColor: Colors.transparent,
      backgroundColor: gColors.white,
      shadowColor: gColors.transparent,
      children: [
        Container(
            color: gColors.transparent,
            height: 372,
            child: Stack(
              children: [
                Positioned(
                    top: 30,
                    right: 10,
                    child: InkWell(
                      child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: gColors.LinearGradient4,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(
                            Icons.clear,
                            size: 18,
                            color: Colors.white,
                          )),
                      onTap: () async {
                        Navigator.pop(context);
                      },
                    )),
                Positioned(
                  top: 90,
                  left: 0,
                  child: Container(
                    width: 280,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                            child: Container(
                                child: Column(
                              children: [
                                gColors.wLigne(),
                                Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  height: 57,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Relancer le devis maintenant',
                                        style: gColors.bodyTitle1_N_Gr,
                                      ),
                                      SvgPicture.asset(
                                        "assets/images/DCL_Relance.svg",
                                        width: 28,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                            onTap: () async {
                              Navigator.pop(context);
                            }),
                        InkWell(
                            child: Container(
                                child: Column(
                              children: [
                                gColors.wLigne(),
                                Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  height: 57,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Duppliquer le devis',
                                        style: gColors.bodyTitle1_N_Gr,
                                      ),
                                      SvgPicture.asset(
                                        "assets/images/DCL_Dupliquer.svg",
                                        width: 28,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                            onTap: () async {
                              Navigator.pop(context);
                            }),
                        InkWell(
                            child: Container(
                                child: Column(
                              children: [
                                gColors.wLigne(),
                                Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  height: 57,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Réviser le devis ',
                                        style: gColors.bodyTitle1_N_Gr,
                                      ),
                                      SvgPicture.asset(
                                        "assets/images/DCL_Reviser.svg",
                                        width: 28,
                                      ),
                                    ],
                                  ),
                                ),
                                gColors.wLigne(),
                              ],
                            )),
                            onTap: () async {
                              Navigator.pop(context);
                            }),
                      ],
                    ),
                  ),
                ),
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
  Future initLib() async {}

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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            child: Image.asset(
              "assets/images/${widget.wImg}.png",
              fit: BoxFit.cover,
              height: 100,
              width: 100,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 4),
            width: wWidth,
            child: Text(
              widget.wLabel1,
              style: gColors.bodyTitle1_B_G,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: wWidth,
            child: Text(
              widget.wLabel2,
              style: gColors.bodyTitle1_B_G,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
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
                          SizedBox(
                            width: wWidth,
                            child: Text(
                              widget.wTxt,
                              style: gColors.bodyTitle1_B_G,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: wWidth,
                            child: Text(
                              widget.wTxt2,
                              style: gColors.bodyTitle1_N_G,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
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
                            child: Ctrl,
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

class MsgBoxDialog2 extends StatefulWidget {
  static bool gRep = false;

  final String wTxt;

  final String wImg;
  final String wLabel1;
  final String wLabel2;

  const MsgBoxDialog2({Key? key, required this.wTxt, required this.wImg, required this.wLabel1, required this.wLabel2}) : super(key: key);
  @override
  _MsgBoxDialog2State createState() => _MsgBoxDialog2State();
}

class _MsgBoxDialog2State extends State<MsgBoxDialog2> {
  @override
  Future initLib() async {}

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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            child: Image.asset(
              "assets/images/${widget.wImg}.png",
              fit: BoxFit.cover,
              height: 100,
              width: 100,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 4),
            width: wWidth,
            child: Text(
              widget.wLabel1,
              style: gColors.bodyTitle1_B_G,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: wWidth,
            child: Text(
              widget.wLabel2,
              style: gColors.bodyTitle1_B_G,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
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
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: BoxDecoration(
                        color: Colors.yellowAccent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          SizedBox(
                            width: wWidth,
                            child: Text(
                              widget.wTxt,
                              style: gColors.bodyTitle1_B_G,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Spacer(),
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
                                  MsgBoxDialog2.gRep = false;
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
                                  MsgBoxDialog2.gRep = true;
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
                            child: Ctrl,
                          ),
                          const Spacer(),
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
      var wparcImgs = DbTools.glfParc_Imgs[i];
      var bytes = base64Decode(wparcImgs.Parc_Imgs_Data!);
      Widget wWidget = Container();
      if (bytes.isNotEmpty) {
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

        imgList.add(wWidget);
        Uint8ListList.add(bytes);

        if (!isPrinc) {
          if (wparcImgs.Parc_Imgs_Principale == 1) {
            isPrinc = true;
          }
        } else {
          wparcImgs.Parc_Imgs_Principale = 0;
        }

        lParc_Imgs.add(wparcImgs);
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
    print(" PhotoDialog build");

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
                          SizedBox(
                            width: wWidth,
                            child: Text(
                              widget.wTxt,
                              style: gColors.bodyTitle1_B_G,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: wWidth,
                            child: Text(
                              widget.wTxt2,
                              style: gColors.bodyTitle1_N_G,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
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
                                  print(" PHOTO Valider ${lParc_Imgs.length}");
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
    var formatter = DateFormat('dd/MM/yy');
    var inputFormat = DateFormat('yyyy-MM-dd');

    print("photo >>>>>>>>< ${imgList.length}");

    return SizedBox(
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
                  gPhotos.wImg = 0;
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => const gPhotos()));

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
                      initLib();
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
                  String formattedDate = formatter.format(DateTime.now());
                  try {
                    formattedDate = lParc_Imgs[Itemindex].Parc_Imgs_Date!;
                  } catch (e) {}
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
                                formattedDate,
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
                                    print("SWITCH $value ${lParc_Imgs[Itemindex].Parc_Imgs_Principale}");
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
    var formatter = DateFormat('dd/MM/yy');
    var inputFormat = DateFormat('yyyy-MM-dd');

    String formattedDate = lParc_Imgs[zoomIndex].Parc_Imgs_Date!;

//    var wParc_Imgs_Date = inputFormat.parse(lParc_Imgs[zoomIndex].Parc_Imgs_Date!);
//    String formattedDate = formatter.format(wParc_Imgs_Date);

    var wparcImgs = DbTools.glfParc_Imgs[zoomIndex];
    var bytes = base64Decode(wparcImgs.Parc_Imgs_Data!);
    Widget wWidget = Container();
    if (bytes.isNotEmpty) {
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

    return SizedBox(
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
                            formattedDate,
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
                    padding: const EdgeInsets.only(right: 12),
                    child: Image.asset(
                      "assets/images/ico5b.png",
                      fit: BoxFit.contain,
                      height: 50,
                    ),
                  ),
                  onTap: () async {
                    await gDialogs.Dialog_MsgBox(
                      context,
                      DbTools.DescAff,
                      DbTools.DescAff2,
                      DbTools.DescAff3,
                      "ico5b",
                      "Êtes-vous sur de vouloir",
                      "éffacer la photo ?",
                    );
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
  const CdeDateDialog({super.key});

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
    var formatter = DateFormat('dd/MM/yyyy');
    String fseldclDatedeb = formatter.format(Srv_DbTools.SelDCL_DateDeb);

    String fseldclDatefin = formatter.format(Srv_DbTools.SelDCL_DateFin);

    return SimpleDialog(
      insetPadding: const EdgeInsets.only(bottom: 400, right: 300),
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
                          InkWell(
                            child: Container(
                                width: 260,
                                height: 80,
                                padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Du ",
                                          style: gColors.bodySaisie_B_G,
                                        ),
                                        Text(
                                          fseldclDatedeb,
                                          style: gColors.bodySaisie_N_G,
                                        ),
                                      ],
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
                                        setState(() {});
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                )),
                            onTap: () async {
                              selectedDate = Srv_DbTools.SelDCL_DateDeb;
                              await _selectDate(context, DateTime(1900), DateTime(DateTime.now().year + 1, 12, 31));
                              Srv_DbTools.SelDCL_DateDeb = selectedDate;
                              isSel = true;
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                      Container(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            child: Container(
                                width: 260,
                                height: 80,
                                padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Au ",
                                          style: gColors.bodySaisie_B_G,
                                        ),
                                        Text(
                                          fseldclDatefin,
                                          style: gColors.bodySaisie_N_G,
                                        ),
                                      ],
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
                                        setState(() {});
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                )),
                            onTap: () async {
                              selectedDate = Srv_DbTools.SelDCL_DateFin;
                              await _selectDate(context, DateTime(1900), DateTime(DateTime.now().year + 1, 12, 31));
                              Srv_DbTools.SelDCL_DateFin = selectedDate;
                              isSel = true;
                              setState(() {});
                            },
                          ),
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
    print("selectedDate >> $selectedDate");
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: firstDate,
        lastDate: lastDate,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(
              dividerColor: gColors.LinearGradient5,
              colorScheme: const ColorScheme.light(
                primary: gColors.LinearGradient5,
                onPrimary: Colors.white, // header text color
                surface: Colors.white, // fond
                onSurface: Colors.black, // body text color`
              ),
            ),
            child: child!,
          );
        });

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        print("selectedDate << $selectedDate");
      });
    }
  }

  Widget popMenu() {
    double hLigne = 72;

    return PopupMenuButton(
      child: Tooltip(textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal), decoration: const BoxDecoration(color: Colors.orange), message: "Filtre Date", child: SizedBox(width: 40, height: 40, child: SvgPicture.asset("assets/images/Icon_circle_down2.svg", height: 40, width: 40, colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn), semanticsLabel: 'A red up arrow'))),
      onSelected: (value) async {
        print(" onSelected $value");

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
              Container(padding: const EdgeInsets.only(right: 8.0), child: const Icon(Icons.date_range)),
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
              Container(padding: const EdgeInsets.only(right: 8.0), child: const Icon(Icons.date_range)),
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
              Container(padding: const EdgeInsets.only(right: 8.0), child: const Icon(Icons.date_range)),
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
              Container(padding: const EdgeInsets.only(right: 8.0), child: const Icon(Icons.date_range)),
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
              Container(padding: const EdgeInsets.only(right: 8.0), child: const Icon(Icons.date_range)),
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
              Container(padding: const EdgeInsets.only(right: 8.0), child: const Icon(Icons.date_range)),
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
              Container(padding: const EdgeInsets.only(right: 8.0), child: const Icon(Icons.date_range)),
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
              Container(padding: const EdgeInsets.only(right: 8.0), child: const Icon(Icons.date_range)),
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
              Container(padding: const EdgeInsets.only(right: 8.0), child: const Icon(Icons.date_range)),
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
              Container(padding: const EdgeInsets.only(right: 8.0), child: const Icon(Icons.date_range)),
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
              Container(padding: const EdgeInsets.only(right: 8.0), child: const Icon(Icons.date_range)),
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
  const MiseEnServDialog({super.key});

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

    return SizedBox(
      width: 250,
      height: 60,
      child: Card(
        color: BgColor,
        elevation: 0.2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0), side: const BorderSide(width: 1, color: Colors.grey)),
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
          ElevatedButton(
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
          ElevatedButton(
            onPressed: () async {
              if (isSel) {
                await HapticFeedback.vibrate();

                if (wSel[0]) {
                  print("MS MS MS DbTools.gParc_Ent.Parcs_CodeArticle! ${DbTools.gParc_Ent.Parcs_CodeArticle!}");
                  Article_Ebp warticleEbp = Srv_DbTools.IMPORT_Article_Ebp(DbTools.gParc_Ent.Parcs_CodeArticle!);
                  Parc_Art wparcArt = Parc_Art.Parc_ArtInit(DbTools.gParc_Ent.ParcsId!);
                  wparcArt.ParcsArt_Id = "${DbTools.gParc_Ent.Parcs_CodeArticle}";
                  wparcArt.ParcsArt_Type = "MS";
                  wparcArt.ParcsArt_Lib = warticleEbp.Article_descriptionCommercialeEnClair;
                  wparcArt.ParcsArt_Qte = 1;
                  wparcArt.ParcsArt_Fact = "Fact.";
                  wparcArt.ParcsArt_Livr = "Livré";
                  DbTools.gParc_Art_MS = wparcArt;
                } else if (wSel[2]) {
                  print("MS MS MS DbTools.gParc_Ent.Parcs_CodeArticle! ${DbTools.gParc_Ent.Parcs_CodeArticle!}");
                  Article_Ebp warticleEbp = Srv_DbTools.IMPORT_Article_Ebp(DbTools.gParc_Ent.Parcs_CodeArticle!);
                  Parc_Art wparcArt = Parc_Art.Parc_ArtInit(DbTools.gParc_Ent.ParcsId!);
                  wparcArt.ParcsArt_Id = "${DbTools.gParc_Ent.Parcs_CodeArticle}";
                  wparcArt.ParcsArt_Type = "MS";
                  wparcArt.ParcsArt_Lib = warticleEbp.Article_descriptionCommercialeEnClair;
                  wparcArt.ParcsArt_Qte = 1;
                  wparcArt.ParcsArt_Fact = "Devis";
                  wparcArt.ParcsArt_Livr = "Reliquat";
                  DbTools.gParc_Art_MS = wparcArt;
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
  const QrCodeDialog({super.key});

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
      child: SizedBox(
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
                    "Code:  $QrcValue",
                    style: gColors.bodyTitle1_B_Gr,
                  ),
                ],
              ),
              Container(
                height: 20,
              ),
              Text(
                ErrorQrc,
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
          ElevatedButton(
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
          ElevatedButton(
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
