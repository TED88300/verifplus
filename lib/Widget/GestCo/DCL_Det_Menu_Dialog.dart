import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DCL_Ent.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/GestCo/DCL_Ent_Param.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'dart:async';

import 'package:verifplus/Widget/Widget_Tools/gDialogs.dart';

class DCL_Det_Menu_Dialog {
  DCL_Det_Menu_Dialog();
  static Future<void> Dialogs_DCL_Det_Menu(BuildContext context) async {
    await showDialog(
      context: context,
      barrierColor: Color(0x00000000),
      builder: (BuildContext context) => DCL_DetMenuDialog(),
    );
  }
}

//**********************************
//**********************************
//**********************************

class DCL_DetMenuDialog extends StatefulWidget {
  const DCL_DetMenuDialog({
    Key? key,
  }) : super(key: key);
  @override
  _DCL_DetMenuDialogState createState() => _DCL_DetMenuDialogState();
}

class _DCL_DetMenuDialogState extends State<DCL_DetMenuDialog> {
//  String DbTools.ParamTypeOg = "";
//  List<String> subLibArray = [];

  bool ModeParams = false;
  bool ModeParamsDevis = false;
  String wParamType = "";
  String wParamTypeOg = DbTools.ParamTypeOg;

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
    print("_TypeOrgDialog initState");
  }

  @override
  Widget build(BuildContext context) {
    double icoWidth = 40;

    double wHeight = 800;
    double wWidth = MediaQuery.of(context).size.width;

    var formatter = DateFormat('dd/MM/yyyy');

    DateTime fSelDCL_Date = new DateFormat("dd/MM/yyyy").parse(Srv_DbTools.gDCL_Ent.DCL_Ent_Date!);

    String Validite =  Srv_DbTools.gUserLogin.User_DCL_Ent_Validite;
    String sValidite = Validite.replaceAll(new RegExp(r'[^0-9]'),''); // '23'
    int iValidite = int.parse(sValidite);

    DateTime fSelDCL_DateValiditeDef = DateTime.now();
    if (Validite.contains("mois"))
      {
        fSelDCL_DateValiditeDef = fSelDCL_DateValiditeDef.add(Duration(days: iValidite * 30));
      }
    else
    {
      fSelDCL_DateValiditeDef = fSelDCL_DateValiditeDef.add(Duration(days: iValidite));
    }
    DateTime fSelDCL_DateValidite = new DateFormat("dd/MM/yyyy").tryParse(Srv_DbTools.gDCL_Ent.DCL_Ent_Validite!) ?? fSelDCL_DateValiditeDef;

    print(" B U I L D  $ModeParams ");
    return
      !ModeParams ?
        SimpleDialog(
      insetPadding: const EdgeInsets.fromLTRB(0, 200, 0, 0),
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      backgroundColor: gColors.white,
      shadowColor: gColors.transparent,
      children: [
        Column(
          children: [
            Container(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                color: gColors.LinearGradient3,
                height: wHeight,
                width: wWidth,
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
                      Container(
                        width: 16,
                      ),
                      InkWell(
                          child: Container(
                            width: icoWidth + 10,
                            child: Stack(children: <Widget>[
                              Image.asset(
                                "assets/images/Btn_Burger.png",
                                color: Colors.red,
                                height: icoWidth,
                                width: icoWidth,
                              ),
                            ]),
                          ),
                          onTap: () async {
                            await HapticFeedback.vibrate();
                            print("ModeParams $ModeParams");
                                Navigator.of(context).pop();


                          }),
                      Expanded(
                          child: Container(
                              padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                              child: Text(
                                "Menu du Devis",
                                maxLines: 1,
                                textAlign: TextAlign.left,
                                style: gColors.bodySaisie_B_O,
                              ))),
                    ]),
                    Container(
                        padding: const EdgeInsets.fromLTRB(0, 45, 0, 0),
                        child: Column(
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                              Container(
                                  child: Text(
                                "Choisissez une Date",
                                maxLines: 1,
                                textAlign: TextAlign.left,
                                style: gColors.bodyTitle1_B_G.copyWith(color: gColors.LinearGradient5),
                              )),
                            ]),
                            Container(
                              padding: const EdgeInsets.fromLTRB(25, 15, 25, 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          color: gColors.transparent,
                                          height: 210,
                                          child: Column(
                                            children: [
                                              Container(
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
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.circular(12),
                                                                border: Border.all(
                                                                  color: Colors.black,
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                              width: 580,
                                                              height: 71,
                                                              padding: const EdgeInsets.fromLTRB(16, 0, 35, 0),
                                                              child: Row(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        width : 200,
                                                                        child: Text(
                                                                          "Date du Devis",
                                                                          style: gColors.bodySaisie_B_G,
                                                                        ),
                                                                      ),

                                                                      Text(
                                                                        "${DateFormat('dd/MM/yyyy').format(fSelDCL_Date)}",
                                                                        style: gColors.bodySaisie_N_G,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Spacer(),

                                                                  Container(
                                                                    width: 16,
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
                                                            selectedDate = fSelDCL_Date;
                                                            await _selectDate(context, DateTime(1900), DateTime(DateTime.now().year + 1, 12, 31));
                                                            fSelDCL_Date = selectedDate;
                                                            var formatter = new DateFormat('dd/MM/yyyy');
                                                            Srv_DbTools.gDCL_Ent.DCL_Ent_Date = formatter.format(selectedDate);
                                                            await Srv_DbTools.setDCL_Ent(Srv_DbTools.gDCL_Ent);
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
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.circular(12),
                                                                border: Border.all(
                                                                  color: Colors.black,
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                              width: 580,
                                                              height: 71,
                                                              padding: const EdgeInsets.fromLTRB(16, 0, 35, 0),
                                                              child: Row(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        width : 200,
                                                                        child: Text(
                                                                          "Date de validité du Devis",
                                                                          style: gColors.bodySaisie_B_G,
                                                                        ),
                                                                      ),

                                                                      Text(
                                                                        "${DateFormat('dd/MM/yyyy').format(fSelDCL_DateValidite)}",
                                                                        style: gColors.bodySaisie_N_G,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Spacer(),
                                                                  Container(
                                                                    width: 16,
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
                                                            selectedDate = fSelDCL_DateValidite;
                                                            await _selectDate(context, DateTime(1900), DateTime(DateTime.now().year + 1, 12, 31));
                                                            fSelDCL_DateValidite = selectedDate;

                                                            Srv_DbTools.gDCL_Ent.DCL_Ent_Validite = DateFormat('dd/MM/yyyy').format(selectedDate);
                                                            await Srv_DbTools.setDCL_Ent(Srv_DbTools.gDCL_Ent);

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
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                    gColors.wLigne(),

                    AffBtnParam("", "Paramètres du Devis", "", "DCL_Param.svg", gColors.LinearGradient3, gColors.primaryBlue, "DEV"),
                    Container(
                      height: 6,
                    ),

                    AffBtnParam("", "Adresse de Facturation/Livraison", "", "DCL_Adr.svg", gColors.LinearGradient3, gColors.primaryBlue, "ADR"),
                    Container(
                      height: 6,
                    ),

                    AffBtnParam("", "Statistiques (Historique client/articles)", "", "DCL_Stat.svg", gColors.LinearGradient3, gColors.primaryBlue, "STAT"),
                    Container(
                      height: 6,
                    ),

                    AffBtnParam("", "TVA", "", "DCL_Tva.svg", gColors.LinearGradient3, gColors.primaryBlue, "TVA"),
                    Container(
                      height: 6,
                    ),

                  ],
                )),
          ],
        ),
      ],
    ) :


      !ModeParamsDevis ?
        SimpleDialog(
      insetPadding: const EdgeInsets.fromLTRB(0, 200, 0, 0),
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      backgroundColor: gColors.white,
      shadowColor: gColors.transparent,
      children: [
        Column(
          children: [
            Container(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                color: gColors.LinearGradient3,
                height: wHeight,
                width: wWidth,
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
                      Container(
                        width: 16,
                      ),
                      InkWell(
                          child: Container(
                            width: icoWidth + 10,
                            child: Stack(children: <Widget>[
                              Image.asset(
                                "assets/images/Btn_Burger.png",
                                color: Colors.red,
                                height: icoWidth,
                                width: icoWidth,
                              ),
                            ]),
                          ),
                          onTap: () async {
                            await HapticFeedback.vibrate();
                            ModeParams = false;
                            setState(() {

                            });
                          }),
                      Expanded(
                          child: Container(
                              padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                              child: Text(
                                "Menu documents de vente",
                                maxLines: 1,
                                textAlign: TextAlign.left,
                                style: gColors.bodySaisie_B_O,
                              ))),
                    ]),

                    Container(
                      height: 16,
                    ),



                    AffBtnParam("", "Paramètres des Devis", "", "DCL_Param.svg", gColors.LinearGradient3, gColors.primaryBlue, "Devis"),
                    Container(
                      height: 6,
                    ),

                    AffBtnParam("", "Paramètres des bons de commande", "", "DCL_Param.svg", gColors.LinearGradient3, gColors.primaryBlue, "BDC"),
                    Container(
                      height: 6,
                    ),

                    AffBtnParam("", "Paramètres des bons de livraison", "", "DCL_Param.svg", gColors.LinearGradient3, gColors.primaryBlue, "BDL"),
                    Container(
                      height: 6,
                    ),
                    AffBtnParam("", "Paramètres des bons de retour", "", "DCL_Param.svg", gColors.LinearGradient3, gColors.primaryBlue, "BDR``"),
                    Container(
                      height: 6,
                    ),


                  ],
                )),
          ],
        ),
      ],
    ) :

    SimpleDialog(
      insetPadding: const EdgeInsets.fromLTRB(0, 200, 0, 0),
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      backgroundColor: gColors.white,
      shadowColor: gColors.transparent,
      children: [
        Column(
          children: [
            Container(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                color: gColors.red,
                height: 300,
                width: wWidth,
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(
                        width: 16,
                      ),
                      InkWell(
                          child: Container(
                            width: icoWidth + 10,
                            child: Stack(children: <Widget>[
                              Image.asset(
                                "assets/images/Btn_Burger.png",
                                color: Colors.red,
                                height: icoWidth,
                                width: icoWidth,
                              ),
                            ]),
                          ),
                          onTap: () async {
                            await HapticFeedback.vibrate();
                            ModeParamsDevis = false;
                            setState(() {

                            });
                          }),
                      Expanded(
                          child: Container(
                              padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                              child: Text(
                                "Menu Paramètres Devis",
                                maxLines: 1,
                                textAlign: TextAlign.left,
                                style: gColors.bodySaisie_B_O,
                              ))),
                    ]),







                  ],
                )),
          ],
        ),
      ],
    );




  }

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context, DateTime firstDate, DateTime lastDate) async {
    print("selectedDate >> ${selectedDate}");
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: firstDate,
        lastDate: lastDate,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(
              dividerColor: gColors.LinearGradient5,
              colorScheme: ColorScheme.light(
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

  //***************************
  //***************************
  //***************************


  Widget AffBtnParam(String wChamps, String wTitle, String wValue, String ImgL, Color BckGrd, Color ForeGrd, String wParam, {String wChampsNote = "", bool bLigne = true}) {
    return TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () async {
          print("onPressed");
          await HapticFeedback.vibrate();
          if (wParam == "Param") {
            await HapticFeedback.vibrate();
            ModeParams = true;
          }
          if (wParam == "Devis") {
            await HapticFeedback.vibrate();
            await showDialog(
              context: context,
              barrierColor: Color(0x00000000),
              builder: (BuildContext context) => DCL_Ent_Param(),
            );

          }

          setState(() {});
        },
        child: Column(
          children: [
            AffLigne(wTitle, "$wValue >", BckGrd, ImgL, ForeGrd, bLigne: bLigne),
          ],
        ));
  }

  Widget AffLigne(String wTextL, String wTextR, Color BckGrd, String ImgL, Color ForeGrd, {bool bLigne = true}) {
    double wHeight = 71;
    double mTop = 28;
    double icoWidth = 48;
    return Container(
        padding: EdgeInsets.fromLTRB(20, 0, 40, 0),
        color: BckGrd,
        child: Column(
          children: [
            Row(
              children: <Widget>[
                ImgL.isEmpty
                    ? Container()
                    : ImgL.contains(".svg")
                    ? Container(
                  padding: EdgeInsets.only(left: 10),
                  child: SvgPicture.asset(
                    "assets/images/${ImgL}",
                    height: icoWidth,
                    width: icoWidth,
                  ),
                )
                    : Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Image.asset(
                    "assets/images/${ImgL}.png",
                    height: icoWidth,
                    width: icoWidth,
                  ),
                ),
                Expanded(
                  child: Container(
                      padding: EdgeInsets.only(left: 10, top: mTop),
                      height: wHeight,
                      child: Text(
                        "${wTextL}",
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        style: gColors.bodySaisie_B_B,
                      )),
                ),
                SvgPicture.asset(
                  "assets/images/DCL_FlDr.svg",
                  height: 40,
                  width: 40,
                ),

              ],
            ),

          ],
        ));
  }





}
