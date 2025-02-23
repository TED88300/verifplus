import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles_Ebp.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DCL_Det.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DCL_Ent_Img.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_ImportExport.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Param.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/GestCo/DCL_Det_Menu_Dialog.dart';
import 'package:verifplus/Widget/GestCo/DCL_Det_Param.dart';
import 'package:verifplus/Widget/GestCo/DCL_Det_Reglt.dart';
import 'package:verifplus/Widget/GestCo/HTML_Text.dart';
import 'package:verifplus/Widget/GestCo/DCL_Article.dart';
import 'package:verifplus/Widget/GestCo/DCL_Devis_Det_Article.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gDialogs.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

class DCL_Devis_Det extends StatefulWidget {
  static int gLongPressAction = 0;
  static bool wUpDown = true;
  static DCL_Det gSaveDCL_Det = DCL_Det.DCL_DetInit();
  static bool isParam = false;

  const DCL_Devis_Det({super.key});

  @override
  DCL_Devis_DetState createState() => DCL_Devis_DetState();
}

class DCL_Devis_DetState extends State<DCL_Devis_Det> with SingleTickerProviderStateMixin {
  var formatter = NumberFormat('###,###.00');

  bool isChecked = false;
  bool affAll = true;
  bool affEdtFilter = false;
  TextEditingController ctrlFilter = TextEditingController();
  String filterText = '';
  bool isAll = true;
  int PastilleType = 0;
  double textSize = 14.0;
  int SelCol = -1;
  int SelID = -1;
  bool onCellTap = false;
  String wAction = "";
  bool btnSel_Aff = true;
  bool bSortDate = false;
  bool isLongPress = false;

  bool isValo = false;
  int TotQTE = 0;
  double TotHT = 0.0;
  double TotTVA = 0.0;
  double TotTTC = 0.0;

  Future Reload() async {
    await Srv_DbTools.getDCL_Ent_ImgID(Srv_DbTools.gDCL_Ent.DCL_EntID!, "D");

    if (Srv_DbTools.ListDCL_Ent_Img.isEmpty) {
      print("getDCL_Ent_ImgID ADD");
      DCL_Ent_Img wdclEntImg = DCL_Ent_Img();
      wdclEntImg.dCLEntImgEntID = Srv_DbTools.gDCL_Ent.DCL_EntID;
      wdclEntImg.DCL_Ent_Img_Type = "D";
      wdclEntImg.DCL_Ent_Img_No = 0;
      wdclEntImg.DCL_Ent_Img_Name = "";
      wdclEntImg.dCLEntImgData = "";
      await Srv_DbTools.InsertUpdateDCL_Ent_Img_Srv(wdclEntImg);

      wdclEntImg = DCL_Ent_Img();
      wdclEntImg.dCLEntImgEntID = Srv_DbTools.gDCL_Ent.DCL_EntID;
      wdclEntImg.DCL_Ent_Img_Type = "D";
      wdclEntImg.DCL_Ent_Img_No = 1;
      wdclEntImg.DCL_Ent_Img_Name = "";
      wdclEntImg.dCLEntImgData = "";
      await Srv_DbTools.InsertUpdateDCL_Ent_Img_Srv(wdclEntImg);

      wdclEntImg = DCL_Ent_Img();
      wdclEntImg.dCLEntImgEntID = Srv_DbTools.gDCL_Ent.DCL_EntID;
      wdclEntImg.DCL_Ent_Img_Type = "D";
      wdclEntImg.DCL_Ent_Img_No = 2;
      wdclEntImg.DCL_Ent_Img_Name = "";
      wdclEntImg.dCLEntImgData = "";
      await Srv_DbTools.InsertUpdateDCL_Ent_Img_Srv(wdclEntImg);
    }

    await Srv_DbTools.getUserLoginid(Srv_DbTools.gUserLogin.UserID);
    await Srv_ImportExport.getErrorSync();

    bool wRes = await Srv_DbTools.getDCL_All_DetID();
    int order = 0;
    int sousTotal = 0;

    List<int> aId = [];
    List<int> aOrder = [];
    for (int i = 0; i < Srv_DbTools.ListDCL_Det.length; i++) {
      aId.add(Srv_DbTools.ListDCL_Det[i].DCL_DetID!);
      Srv_DbTools.ListDCL_Det[i].DCL_Det_Ordre = order;
      aOrder.add(order++);
    }

    print(" RELOAD *******");
//    Srv_DbTools.Call_StoreProc(aId.toString().replaceAll("[", "").replaceAll("]", "").replaceAll(" ", ""), aOrder.toString().replaceAll("[", "").replaceAll("]", "").replaceAll(" ", ""));

    for (int i = 0; i < Srv_DbTools.ListDCL_Det.length; i++) {
      if (Srv_DbTools.ListDCL_Det[i].DCL_Det_Type == "A") sousTotal += Srv_DbTools.ListDCL_Det[i].DCL_Det_Qte!;
      if (Srv_DbTools.ListDCL_Det[i].DCL_Det_Type == "S") {
        Srv_DbTools.ListDCL_Det[i].DCL_Det_Qte = sousTotal;
        sousTotal = 0;
      }
    }
    Filtre();
  }

  void Filtre() {
    isAll = true;
    Srv_DbTools.ListDCL_Detsearchresult.clear();
    String wFilterText = filterText.trim().toUpperCase();
    if (wFilterText.isEmpty) {
      Srv_DbTools.ListDCL_Detsearchresult.addAll(Srv_DbTools.ListDCL_Det);
    } else {
      Srv_DbTools.ListDCL_Det.forEach((element) async {
        if (element.Desc().toUpperCase().contains(wFilterText)) Srv_DbTools.ListDCL_Detsearchresult.add(element);
      });
    }

    TotQTE = 0;
    TotHT = 0.0;
    TotTVA = 0.0;
    TotTTC = 0.0;
    Srv_DbTools.ListDCL_Det.forEach((element) async {
      TotQTE += element.DCL_Det_Qte!;
      TotHT += element.DCL_Det_PU! * element.DCL_Det_Qte!;
      TotTVA += TotHT * element.DCL_Det_TVA! / 100;
    });
    TotTTC = TotHT + TotTVA;

    setState(() {});
  }

  @override
  void initLib() async {
    Reload();
  }

  @override
  void initState() {
    Srv_DbTools.gDCL_Det = DCL_Det.DCL_DetInit();
    initLib();
    super.initState();
    FBroadcast.instance().register("Maj_DCL_Det", (value, callback) {
      initLib();
    });
  }

  @override
  void dispose() {
    FBroadcast.instance().unregister(this);
    super.dispose();
  }

  void onSaisie() async {
    setState(() {});
  }

  @override
  Widget Entete_Btn_Search() {
    return Container(
        height: 71,
        width: MediaQuery.of(context).size.width,
        color: gColors.LinearGradient3,
        child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            width: 8,
          ),
          Expanded(
              child: Container(
                  child: Text(
            "${Srv_DbTools.gDCL_Ent.DCL_Ent_CCGSZ}",
            maxLines: 1,
            textAlign: TextAlign.left,
            style: gColors.bodySaisie_B_B,
          ))),
          Container(
            width: 8,
          ),
          EdtFilterWidget(),
        ]));
  }

  @override
  Widget Entete_VALO() {
    isValo = Srv_DbTools.gDCL_Ent.DCL_Ent_Valo == 1;

    return SizedBox(
        height: 71,
        child: Row(
          children: [
            Container(
              width: 8,
            ),
            InkWell(
                child: SizedBox(
                  width: icoWidth + 10,
                  child: Stack(children: <Widget>[
                    Image.asset(
                      "assets/images/DCL_Total.png",
                      color: isValo ? Colors.red : null,
                      height: icoWidth,
                      width: icoWidth,
                    ),
                  ]),
                ),
                onLongPress: () async {
                  await HapticFeedback.vibrate();
                  await showDialog(
                    context: context,
                    barrierColor: const Color(0x00000000),
                    builder: (BuildContext context) => const DCL_Det_Reglt(),
                  );



                  Reload();
                },


                onTap: () async {
                  await HapticFeedback.vibrate();
                  isValo = !isValo;
                  Filtre();
                }),
            Row(
              children: [
                Text(
                  "($TotQTE)",
                  maxLines: 1,
                  textAlign: TextAlign.right,
                  style: gColors.bodyTitle1_B_Gr,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  "${gObj.formatterformat(TotHT)}€ HT",
                  maxLines: 1,
                  textAlign: TextAlign.right,
                  style: gColors.bodyTitle1_B_Gr,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  "${gObj.formatterformat(TotTVA)}€ TVA",
                  maxLines: 1,
                  textAlign: TextAlign.right,
                  style: gColors.bodyTitle1_N_Gr,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  "${gObj.formatterformat(TotTTC)}€ TTC",
                  maxLines: 1,
                  textAlign: TextAlign.right,
                  style: gColors.bodyTitle1_N_Gr,
                ),
              ],
            )
          ],
        ));
  }

  @override
  Widget Entete_Ico_Search() {
    String wEtat = "Etat";
    Color wEtatColors = gColors.primaryGreen;
    if (Srv_DbTools.gDCL_Ent.DCL_Ent_Statut == 'Préparation') {
      wEtat = "Prépa";
      wEtatColors = Colors.orangeAccent;
    }
    if (Srv_DbTools.gDCL_Ent.DCL_Ent_Statut == 'En cours') {
      wEtat = "En cours";
      wEtatColors = Colors.blueAccent;
    }
    if (Srv_DbTools.gDCL_Ent.DCL_Ent_Statut == 'Accepté') {
      wEtat = "Accepté";
      wEtatColors = gColors.primaryGreen;
    }
    if (Srv_DbTools.gDCL_Ent.DCL_Ent_Statut == 'Refusé') {
      wEtat = "Refusé";
      wEtatColors = gColors.red;
    }

    return Container(
        decoration: const BoxDecoration(
          color: gColors.LinearGradient3,
        ),
        height: 71,
        child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            width: 16,
          ),
          InkWell(
              child: SizedBox(
                width: icoWidth + 10,
                child: Stack(children: <Widget>[
                  Image.asset(
                    "assets/images/Btn_Burger.png",
                    height: icoWidth,
                    width: icoWidth,
                  ),
                ]),
              ),
              onTap: () async {
                await HapticFeedback.vibrate();
                await DCL_Det_Menu_Dialog.Dialogs_DCL_Det_Menu(context);

                Filtre();
              }),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      width: 120,
                      decoration: BoxDecoration(
                        color: wEtatColors,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            wEtat,
                            style: gColors.bodyTitle1_N_W24,
                          ),
                        ],
                      ),
                    ),
                    onTap: () async {
                      await gDialogs.Dialog_Action(context);
                      setState(() {});
                    }),
                InkWell(
                    child: SizedBox(
                      width: icoWidth + 10,
                      child: Stack(children: <Widget>[
                        Image.asset(
                          btnSel_Aff ? "assets/images/DCL_AffSel.png" : "assets/images/DCL_Aff.png",
                          height: icoWidth,
                          width: icoWidth,
                        ),
                      ]),
                    ),
                    onTap: () async {
                      await HapticFeedback.vibrate();
                      btnSel_Aff = !btnSel_Aff;
                      Filtre();
                    }),
                InkWell(
                    child: SizedBox(
                      width: icoWidth + 10,
                      child: Stack(children: <Widget>[
                        Image.asset(
                          "assets/images/DCL_Impr.png",
                          height: icoWidth,
                          width: icoWidth,
                        ),
                      ]),
                    ),
                    onTap: () async {
                      await HapticFeedback.vibrate();
                      Filtre();
                    }),
                InkWell(
                    child: SizedBox(
                      width: icoWidth + 10,
                      child: Stack(children: <Widget>[
                        Image.asset(
                          "assets/images/DCL_Transf.png",
                          height: icoWidth,
                          width: icoWidth,
                        ),
                      ]),
                    ),
                    onTap: () async {
                      await HapticFeedback.vibrate();
                      Filtre();
                    }),
              ],
            ),
          ),



        ]));
  }

  double icoWidth = 40;

  Widget EdtFilterWidget() {
    return Container(
        child: !affEdtFilter
            ? InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Image.asset(
                    "assets/images/Btn_Loupe.png",
                    height: icoWidth,
                    width: icoWidth,
                  ),
                ),
                onTap: () async {
                  affEdtFilter = !affEdtFilter;
                  setState(() {});
                })
            : SizedBox(
                width: 320,
                child: Row(
                  children: [
                    InkWell(
                        child: Image.asset(
                          "assets/images/Btn_Loupe.png",
                          height: icoWidth,
                          width: icoWidth,
                        ),
                        onTap: () async {
                          affEdtFilter = !affEdtFilter;
                          setState(() {});
                        }),
                    Expanded(
                        child: TextField(
                      onChanged: (text) {
                        filterText = text;
                        Filtre();
                      },
                      controller: ctrlFilter,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            ctrlFilter.clear();
                            filterText = "";
                            Filtre();
                          },
                          icon: Image.asset(
                            "assets/images/Btn_Clear.png",
                            height: icoWidth,
                            width: icoWidth,
                          ),
                        ),
                      ),
                    ))
                  ],
                )));
  }

  @override
  AppBar appBar() {
    return AppBar(
      title: InkWell(
        onTap: () async {
          await HapticFeedback.vibrate();
//          await Client_Dialog.Dialogs_Client(context);
          Navigator.of(context).pop();
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
          AutoSizeText(
            "${Srv_DbTools.gDCL_Ent.DCL_Ent_Num} - ${Srv_DbTools.gDCL_Ent.DCL_Ent_Date}",
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

  Future LongPressAction() async {
    int bReOrder = 0;
    int wdclDetOrdre = -1;

    print("  DCL_Devis_Det.gLongPressAction ${DCL_Devis_Det.gLongPressAction}");
    if (DCL_Devis_Det.gLongPressAction == 1) {
      print(" gLongPressAction  1 ${Srv_DbTools.gDCL_Det.DCL_DetID}");

      DCL_Det adclDet = DCL_Det.DCL_DetInit();
      adclDet.DCL_Det_Ordre = 0;
      if (Srv_DbTools.gDCL_Det.DCL_DetID == -1) {
        adclDet.DCL_Det_Ordre = Srv_DbTools.getLastOrder() + 1;
      } else {
        print("avec Sel DCL_DetID ${Srv_DbTools.gDCL_Det.DCL_DetID}");
        print("avec Sel Ordre ${Srv_DbTools.gDCL_Det.DCL_Det_Ordre}");
        wdclDetOrdre = Srv_DbTools.gDCL_Det.DCL_Det_Ordre!;
        if (DCL_Devis_Det.wUpDown) {
          adclDet.DCL_Det_Ordre = wdclDetOrdre;
          bReOrder = 1;
        } else {
          adclDet.DCL_Det_Ordre = wdclDetOrdre + 1;
          bReOrder = 2;
        }
      }
      adclDet.DCL_Det_EntID = Srv_DbTools.gDCL_Ent.DCL_EntID;
      adclDet.DCL_Det_Type = "T";
      adclDet.DCL_Det_ParcsArtId = 0;
      adclDet.DCL_Det_NoArt = "";
      adclDet.DCL_Det_Lib = "Saisir Texte !!!";
      adclDet.DCL_Det_Qte = 0;
      adclDet.DCL_Det_PU = 0;
      adclDet.DCL_Det_RemP = 0;
      adclDet.DCL_Det_RemMt = 0;
      adclDet.DCL_Det_TVA = 0;
      adclDet.DCL_Det_Livr = 0;
      adclDet.DCL_Det_DateLivr = "";
      adclDet.DCL_Det_Rel = 0;
      adclDet.DCL_Det_DateRel = "";
      adclDet.DCL_Det_Statut = "";
      adclDet.DCL_Det_Note = "";
      await Srv_DbTools.InsertUpdateDCL_Det(adclDet);
    } else if (DCL_Devis_Det.gLongPressAction == 6) {
      print(" gLongPressAction  1 ${Srv_DbTools.gDCL_Det.DCL_DetID}");
      DCL_Det adclDet = DCL_Det.DCL_DetInit();
      adclDet.DCL_Det_Ordre = 0;
      if (Srv_DbTools.gDCL_Det.DCL_DetID == -1) {
        adclDet.DCL_Det_Ordre = Srv_DbTools.getLastOrder() + 1;
      } else {
        print("avec Sel DCL_DetID ${Srv_DbTools.gDCL_Det.DCL_DetID}");
        print("avec Sel Ordre ${Srv_DbTools.gDCL_Det.DCL_Det_Ordre}");
        wdclDetOrdre = Srv_DbTools.gDCL_Det.DCL_Det_Ordre!;
        if (DCL_Devis_Det.wUpDown) {
          adclDet.DCL_Det_Ordre = wdclDetOrdre;
          bReOrder = 1;
        } else {
          adclDet.DCL_Det_Ordre = wdclDetOrdre + 1;
          bReOrder = 2;
        }
      }
      adclDet.DCL_Det_EntID = Srv_DbTools.gDCL_Ent.DCL_EntID;
      adclDet.DCL_Det_Type = "S";
      adclDet.DCL_Det_ParcsArtId = 0;
      adclDet.DCL_Det_NoArt = "";
      adclDet.DCL_Det_Lib = "Saisir Texte !!!";
      adclDet.DCL_Det_Qte = 0;
      adclDet.DCL_Det_PU = 0;
      adclDet.DCL_Det_RemP = 0;
      adclDet.DCL_Det_RemMt = 0;
      adclDet.DCL_Det_TVA = 0;
      adclDet.DCL_Det_Livr = 0;
      adclDet.DCL_Det_DateLivr = "";
      adclDet.DCL_Det_Rel = 0;
      adclDet.DCL_Det_DateRel = "";
      adclDet.DCL_Det_Statut = "";
      adclDet.DCL_Det_Note = "";
      await Srv_DbTools.InsertUpdateDCL_Det(adclDet);
    } else if (DCL_Devis_Det.gLongPressAction == 7) {
      print(" gLongPressAction  1 ${Srv_DbTools.gDCL_Det.DCL_DetID}");
      DCL_Det adclDet = DCL_Det.DCL_DetInit();
      adclDet.DCL_Det_Ordre = 0;
      if (Srv_DbTools.gDCL_Det.DCL_DetID == -1) {
        adclDet.DCL_Det_Ordre = Srv_DbTools.getLastOrder() + 1;
      } else {
        print("avec Sel DCL_DetID ${Srv_DbTools.gDCL_Det.DCL_DetID}");
        print("avec Sel Ordre ${Srv_DbTools.gDCL_Det.DCL_Det_Ordre}");
        wdclDetOrdre = Srv_DbTools.gDCL_Det.DCL_Det_Ordre!;
        if (DCL_Devis_Det.wUpDown) {
          adclDet.DCL_Det_Ordre = wdclDetOrdre;
          bReOrder = 1;
        } else {
          adclDet.DCL_Det_Ordre = wdclDetOrdre + 1;
          bReOrder = 2;
        }
      }
      adclDet.DCL_Det_EntID = Srv_DbTools.gDCL_Ent.DCL_EntID;
      adclDet.DCL_Det_Type = "P";
      adclDet.DCL_Det_ParcsArtId = 0;
      adclDet.DCL_Det_NoArt = "";
      adclDet.DCL_Det_Lib = "Saisir Texte !!!";
      adclDet.DCL_Det_Qte = 0;
      adclDet.DCL_Det_PU = 0;
      adclDet.DCL_Det_RemP = 0;
      adclDet.DCL_Det_RemMt = 0;
      adclDet.DCL_Det_TVA = 0;
      adclDet.DCL_Det_Livr = 0;
      adclDet.DCL_Det_DateLivr = "";
      adclDet.DCL_Det_Rel = 0;
      adclDet.DCL_Det_DateRel = "";
      adclDet.DCL_Det_Statut = "";
      adclDet.DCL_Det_Note = "";
      await Srv_DbTools.InsertUpdateDCL_Det(adclDet);
    } else if (DCL_Devis_Det.gLongPressAction == 2) {
      print(" gLongPressAction 2 ${Srv_DbTools.gDCL_Det.DCL_DetID}");
      DCL_Det adclDet = DCL_Devis_Det.gSaveDCL_Det;
      {
        print("Dupliquer DCL_DetID ${adclDet.DCL_DetID}");
        print("Sans Sel Ordre ${adclDet.DCL_Det_Ordre}");
        wdclDetOrdre = adclDet.DCL_Det_Ordre!;
        if (DCL_Devis_Det.wUpDown) {
          adclDet.DCL_Det_Ordre = wdclDetOrdre;
          bReOrder = 1;
        } else {
          adclDet.DCL_Det_Ordre = wdclDetOrdre + 1;
          bReOrder = 2;
        }
      }
      await Srv_DbTools.InsertUpdateDCL_Det(adclDet);
    } else if (DCL_Devis_Det.gLongPressAction == 4) {
      print(" gLongPressAction 4 ${Srv_DbTools.gDCL_Det.DCL_DetID}");

      DCL_Det adclDet = DCL_Devis_Det.gSaveDCL_Det;
      if (Srv_DbTools.gDCL_Det.DCL_DetID == -1) {
        adclDet.DCL_Det_Ordre = Srv_DbTools.getLastOrder() + 1;
      } else {
        print("Dupliquer DCL_DetID ${adclDet.DCL_DetID}");
        print("Sans Sel Ordre ${adclDet.DCL_Det_Ordre}");

        wdclDetOrdre = Srv_DbTools.gDCL_Det.DCL_Det_Ordre!;
        if (DCL_Devis_Det.wUpDown) {
          adclDet.DCL_Det_Ordre = wdclDetOrdre;
          bReOrder = 1;
        } else {
          adclDet.DCL_Det_Ordre = wdclDetOrdre + 1;
          bReOrder = 2;
        }
      }
      await Srv_DbTools.InsertUpdateDCL_Det(adclDet);
    } else if (DCL_Devis_Det.gLongPressAction == 5) {
      await Srv_DbTools.delDCL_Det(DCL_Devis_Det.gSaveDCL_Det.DCL_DetID!);
    }
    List<int> aId = [];
    List<int> aOrder = [];

    if (bReOrder == 1) {
      int order = 0;
      for (int i = 0; i < Srv_DbTools.ListDCL_Det.length; i++) {
        if (order >= wdclDetOrdre) {
          aId.add(Srv_DbTools.ListDCL_Det[i].DCL_DetID!);
          aOrder.add(order + 1);
          Srv_DbTools.ListDCL_Det[i].DCL_Det_Ordre = order + 1;
        }
        order++;
      }
    } else if (bReOrder == 2) {
      int order = 0;
      for (int i = 0; i < Srv_DbTools.ListDCL_Det.length; i++) {
        if (order > wdclDetOrdre) {
          aId.add(Srv_DbTools.ListDCL_Det[i].DCL_DetID!);
          aOrder.add(order + 1);
          Srv_DbTools.ListDCL_Det[i].DCL_Det_Ordre = order + 1;
        }
        order++;
      }
    }

    Srv_DbTools.Call_StoreProc(aId.toString().replaceAll("[", "").replaceAll("]", "").replaceAll(" ", ""), aOrder.toString().replaceAll("[", "").replaceAll("]", "").replaceAll(" ", ""));
    Reload();
  }

  @override
  Widget build(BuildContext context) {
    double LargeurLabel = 140;
    Param_Param wparamParam = Srv_DbTools.getParam_Param_in_Mem("Type_Organe", Srv_DbTools.gSelDCL_Ent);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: appBar(),
      body: Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            children: [
              Expanded(
                child: DCL_Devis_DetGridWidget(),
              ),
            ],
          )),
      floatingActionButton: !affAll || DCL_Devis_Det.isParam
          ? Container()
          : Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 50, 30),
              child: InkWell(
                splashColor: Colors.blue,
                onLongPress: () async {
                  await HapticFeedback.vibrate();
                  await gDialogs.Dialog_ActionLigne(context);
                  await LongPressAction();
                  Reload();
                },
                child: FloatingActionButton(
                    elevation: 0.0,
                    backgroundColor: gColors.secondary,
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) => DCL_Articles(
                          onSaisie: onSaisie,
                          art_Type: "Listing",
                          isDevis: false,
                        ),
                      );
                      Reload();
                    },
                    child: const Icon(Icons.add)),
              )),
    );
  }

  //***************************
  //***************************
  //***************************

  Widget DetGrid_Row_T(DCL_Det wdclDet) {
//    print("DetGrid_Row_T ${wDCL_Det.DCL_Det_Lib}");

    String wdclDetLib = wdclDet.DCL_Det_Lib!.replaceAll("<p>", "").replaceAll("</p>", "");

    wdclDetLib = " <style lang='scss'>.ql-align-right {text-align: right;}.ql-align-center {text-align: center;}.ql-align-left {text-align: left;}</style>$wdclDetLib";

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        children: [
          Expanded(
              child: Html(
            data: wdclDetLib,
          ))
        ],
      ),
    );
  }

  Widget DetGrid_Row_A(DCL_Det wdclDet) {
    return Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 15, 0),
        height: 57,
        child: Row(
          children: [
            buildImage(context, wdclDet.DCL_Det_NoArt!),
            SizedBox(
              width: 80,
              child: Text(
                "${wdclDet.DCL_Det_NoArt}",
                maxLines: 1,
                textAlign: TextAlign.right,
                style: gColors.bodySaisie_B_B.copyWith(color: (Srv_DbTools.gDCL_Det.DCL_DetID == wdclDet.DCL_DetID) ? Colors.white : Colors.black),
              ),
            ),
            Container(
              width: 10,
            ),
            SizedBox(
              width: 265,
              child: Text(
                "${wdclDet.DCL_Det_Lib}",
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.left,
                style: gColors.bodySaisie_B_B.copyWith(color: (Srv_DbTools.gDCL_Det.DCL_DetID == wdclDet.DCL_DetID) ? Colors.white : Colors.black),
              ),
            ),
            const Spacer(),
            isValo
                ? Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          "${gObj.formatterformat(wdclDet.DCL_Det_PU!)}€",
                          maxLines: 1,
                          textAlign: TextAlign.right,
                          style: gColors.bodySaisie_B_B.copyWith(color: (Srv_DbTools.gDCL_Det.DCL_DetID == wdclDet.DCL_DetID) ? Colors.white : Colors.black),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: Text(
                          "${wdclDet.DCL_Det_Qte}",
                          maxLines: 1,
                          textAlign: TextAlign.right,
                          style: gColors.bodySaisie_B_B.copyWith(color: (Srv_DbTools.gDCL_Det.DCL_DetID == wdclDet.DCL_DetID) ? Colors.white : Colors.black),
                        ),
                      ),
                      SizedBox(
                        width: 90,
                        child: Text(
                          " ${gObj.formatterformat(wdclDet.DCL_Det_PU! * wdclDet.DCL_Det_Qte!)}€",
                          maxLines: 1,
                          textAlign: TextAlign.right,
                          style: gColors.bodySaisie_B_B.copyWith(color: (Srv_DbTools.gDCL_Det.DCL_DetID == wdclDet.DCL_DetID) ? Colors.white : Colors.black),
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 40,
                        child: Text(
                          "${wdclDet.DCL_Det_Qte}",
                          maxLines: 1,
                          textAlign: TextAlign.right,
                          style: gColors.bodySaisie_B_B.copyWith(color: (Srv_DbTools.gDCL_Det.DCL_DetID == wdclDet.DCL_DetID) ? Colors.white : Colors.black),
                        ),
                      ),
                    ],
                  ),
          ],
        ));
  }

  Widget DetGrid_Row_A_Big(DCL_Det wdclDet) {
    return Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 15, 0),
        height: 120,
        child: Row(
          children: [
            buildImageL(context, wdclDet.DCL_Det_NoArt!),
            Container(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 10,
                ),
                SizedBox(
                  width: 500,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          "${wdclDet.DCL_Det_NoArt}",
                          maxLines: 1,
                          style: gColors.bodyTitle1_N_Gr.copyWith(color: (Srv_DbTools.gDCL_Det.DCL_DetID == wdclDet.DCL_DetID) ? Colors.white : Colors.black),
                        ),
                      ),
                      SvgPicture.asset(
                        "assets/images/DCL_Check.svg",
                        width: 20,
                      ),
                      Text(
                        "En stock",
                        maxLines: 1,
                        style: gColors.bodyTitle1_N_Gr.copyWith(color: (Srv_DbTools.gDCL_Det.DCL_DetID == wdclDet.DCL_DetID) ? Colors.white : Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      Text(
                        "(L) 27/10/24",
                        maxLines: 1,
                        style: gColors.bodyTitle1_N_Gr.copyWith(color: (Srv_DbTools.gDCL_Det.DCL_DetID == wdclDet.DCL_DetID) ? Colors.white : gColors.primaryGreen),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 10,
                ),
                SizedBox(
                  width: 430,
                  child: Text(
                    "${wdclDet.DCL_Det_Lib}",
                    maxLines: 13,
                    textAlign: TextAlign.left,
                    style: gColors.bodyTitle1_N_Gr.copyWith(color: (Srv_DbTools.gDCL_Det.DCL_DetID == wdclDet.DCL_DetID) ? Colors.white : Colors.black),
                  ),
                ),
                const Spacer(),
                isValo
                    ? SizedBox(
                        width: 500,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "PU Net ${gObj.formatterformat(wdclDet.DCL_Det_PU!)}€",
                              maxLines: 1,
                              textAlign: TextAlign.right,
                              style: gColors.bodyTitle1_B_Gr.copyWith(color: (Srv_DbTools.gDCL_Det.DCL_DetID == wdclDet.DCL_DetID) ? Colors.white : Colors.black),
                            ),
                            Text(
                              "Qté ${wdclDet.DCL_Det_Qte}",
                              maxLines: 1,
                              textAlign: TextAlign.right,
                              style: gColors.bodyTitle1_B_Gr.copyWith(color: (Srv_DbTools.gDCL_Det.DCL_DetID == wdclDet.DCL_DetID) ? Colors.white : Colors.black),
                            ),
                            Text(
                              "Mt Net ${gObj.formatterformat(wdclDet.DCL_Det_PU! * wdclDet.DCL_Det_Qte!)}€",
                              maxLines: 1,
                              /**/
                              textAlign: TextAlign.right,
                              style: gColors.bodyTitle1_B_Gr.copyWith(color: (Srv_DbTools.gDCL_Det.DCL_DetID == wdclDet.DCL_DetID) ? Colors.white : Colors.black),
                            ),
                          ],
                        ))
                    : SizedBox(
                        width: 500,
                        child: Text(
                          "Qté ${wdclDet.DCL_Det_Qte}",
                          maxLines: 1,
                          textAlign: TextAlign.right,
                          style: gColors.bodyTitle1_B_Gr.copyWith(color: (Srv_DbTools.gDCL_Det.DCL_DetID == wdclDet.DCL_DetID) ? Colors.white : Colors.black),
                        ),
                      ),
                Container(
                  height: 10,
                ),
              ],
            )
          ],
        ));
  }

  Widget DetGrid_Row_P(DCL_Det wdclDet) {
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text(
//                "${wDCL_Det.DCL_DetID} ${wDCL_Det.DCL_Det_Ordre}  ---------------------------------------------------- Saut de page ---------------------------------------------------- ",
                " ---------------------------------------------------- Saut de page ---------------------------------------------------- ",
                maxLines: 1,
                textAlign: TextAlign.left,
                style: gColors.bodySaisie_Ni_B.copyWith(color: (Srv_DbTools.gDCL_Det.DCL_DetID == wdclDet.DCL_DetID) ? Colors.white : Colors.black),
              ),
            ),
          ],
        ));
  }

  Widget DetGrid_Row_S(DCL_Det wdclDet) {
    return Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text(
                "Sous Total : ${wdclDet.DCL_Det_Qte}",
                maxLines: 1,
                textAlign: TextAlign.left,
                style: gColors.bodySaisie_Ni_B.copyWith(color: (Srv_DbTools.gDCL_Det.DCL_DetID == wdclDet.DCL_DetID) ? Colors.white : Colors.black),
              ),
            ),
          ],
        ));
  }
  //********************************************************************
  //********************************************************************

  Widget slideLeftBackground() {
    return Container(
      color: gColors.trred,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 3),
      child: const Row(
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

  //********************************************************************
  //********************************************************************
  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              " Edit",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  Widget DCL_Devis_DetGridWidget() {
    double posX = 0;
    const minHeight = 60.0;
    const maxHeight = 320.0;
    final topPadding = MediaQuery.of(context).padding.top;

    return Listener(
        onPointerDown: (PointerDownEvent event) {
          posX = event.position.dx;
          print("posX $posX");
        },
        child: Container(
          color: isLongPress ? gColors.LinearGradient1 : gColors.LinearGradient2,
          child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverToBoxAdapter(
                        child: Container(
                      color: Colors.white,
//                      height: 200,
                      child: Column(
                        children: [
                          Entete_Btn_Search(),
                          gColors.wLigne(),
                          Entete_VALO(),
                          gColors.wLigne(),
                          Entete_Ico_Search(),
                          gColors.wLigne(),
                          gColors.ombre(),
                        ],
                      ),
                    ))
                  ],
              body: DCL_Devis_Det.isParam
                  ? const DCL_Det_Param()
                  : ReorderableListView.builder(
                      physics: const ClampingScrollPhysics(),
                      onReorder: (int oldIndex, int newIndex) {
                        if (newIndex >= Srv_DbTools.ListDCL_Detsearchresult.length) return;
                        print(oldIndex);
                        print(newIndex);
                        setState(() {
                          final DCL_Det wdclDet = Srv_DbTools.ListDCL_Detsearchresult.removeAt(oldIndex);
                          Srv_DbTools.ListDCL_Detsearchresult.insert(newIndex, wdclDet);
                        });
                      },
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      itemCount: Srv_DbTools.ListDCL_Detsearchresult.length,
                      itemBuilder: (BuildContext context, int index) {
                        DCL_Det wdclDet = Srv_DbTools.ListDCL_Detsearchresult[index];
                        Color wColor = Colors.transparent;
                        Color wColorBack = Colors.transparent;
                        Color wColorBack2 = Colors.white;
                        Color wColorText = Colors.black;

                        if (Srv_DbTools.gDCL_Det.DCL_DetID == wdclDet.DCL_DetID) {
                          if (!btnSel_Aff) wColorBack = gColors.backgroundColor;
                          wColorBack2 = gColors.backgroundColor;
                          wColorText = Colors.white;
                        }
                        print(" itemBuilder $index");

                        return ReorderableDragStartListener(
                          enabled: isLongPress,
                          index: index,
                          key: ValueKey(index),
                          child: Dismissible(
                            background: slideRightBackground(),
                            secondaryBackground: slideLeftBackground(),
                            direction: DismissDirection.endToStart,
                            key: ValueKey<int>(wdclDet.DCL_DetID!),
                            confirmDismiss: (DismissDirection direction) async {
                              await HapticFeedback.vibrate();
                              Srv_DbTools.gDCL_Det = wdclDet;
                              await showDialog(context: context, builder: (BuildContext context) => DialogSuppr(context, wdclDet.DCL_Det_Lib!));
                              return null;
                            },
                            child: Flex(
                              direction: Axis.horizontal,
                              children: <Widget>[
                                Flexible(
                                    child: Container(
                                        color: gColors.transparent,
                                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        child: GestureDetector(
                                            onLongPress: () async {
                                              if (posX < 120) {
                                                if (Srv_DbTools.gDCL_Det.DCL_DetID == wdclDet.DCL_DetID) {
                                                  Srv_DbTools.gDCL_Det = DCL_Det();
                                                  Srv_DbTools.gDCL_Det.DCL_DetID = -1;
                                                } else {
                                                  isLongPress = true;
                                                  await HapticFeedback.vibrate();
                                                  Srv_DbTools.ListDCL_DetsearchresultSave.clear();
                                                  Srv_DbTools.ListDCL_DetsearchresultSave.addAll(Srv_DbTools.ListDCL_Detsearchresult);
                                                  Srv_DbTools.gDCL_Det = wdclDet;
                                                }
                                                setState(() {});
                                              }
                                            },
                                            onTap: () async {
                                              await HapticFeedback.vibrate();

                                              if (posX < 120) {
                                                if (isLongPress) {
                                                  List<int> aId = [];
                                                  List<int> aOrder = [];
                                                  for (int i = 0; i < Srv_DbTools.ListDCL_Detsearchresult.length; i++) {
                                                    //if (Srv_DbTools.ListDCL_Detsearchresult[i].DCL_DetID != Srv_DbTools.ListDCL_DetsearchresultSave[i].DCL_DetID)
                                                    {
                                                      aId.add(Srv_DbTools.ListDCL_Detsearchresult[i].DCL_DetID!);
                                                      aOrder.add(i);
                                                      Srv_DbTools.ListDCL_Detsearchresult[i].DCL_Det_Ordre = i;
                                                    }
                                                  }

                                                  print(" FIN LONGPRESS *******");

                                                  Srv_DbTools.Call_StoreProc(aId.toString().replaceAll("[", "").replaceAll("]", "").replaceAll(" ", ""), aOrder.toString().replaceAll("[", "").replaceAll("]", "").replaceAll(" ", ""));
                                                  Reload();
                                                  isLongPress = false;
                                                  return;
                                                }

                                                if (Srv_DbTools.gDCL_Det.DCL_DetID == wdclDet.DCL_DetID) {
                                                  Srv_DbTools.gDCL_Det = DCL_Det();
                                                  Srv_DbTools.gDCL_Det.DCL_DetID = -1;
                                                } else {
                                                  Srv_DbTools.gDCL_Det = wdclDet;
                                                }

                                                setState(() {});
                                              } else {
                                                isLongPress = false;

                                                Srv_DbTools.gDCL_Det = wdclDet;
                                                print("Selection FIN ligne qqqqq");

                                                if (wdclDet.DCL_Det_Type == "T") {
                                                  print(" HTML");

                                                  print(" HTML ${wdclDet.DCL_Det_Lib}");
                                                  HTML_Text.gHTML_Text = "${wdclDet.DCL_Det_Lib}";
                                                  await HTML_Text.Dialogs_HTMLText(context, "Saisie Texte Ligne N° ${wdclDet.DCL_DetID}");

                                                  wdclDet.DCL_Det_Lib = HTML_Text.gHTML_Text;
                                                  print(" HTML retour ${wdclDet.DCL_Det_Lib}");
                                                  Srv_DbTools.setDCL_Det_Lib(wdclDet);
                                                  setState(() {});
                                                } else if (wdclDet.DCL_Det_Type == "A") {
                                                  print(" DCL_Det_NoArt ${wdclDet.DCL_Det_NoArt}");

                                                  var warticleEbp = Srv_DbTools.ListArticle_Ebp.where((element) => element.Article_codeArticle == wdclDet.DCL_Det_NoArt);
                                                  if (warticleEbp.length == 1) {
                                                    for (int i = 0; i < Srv_DbTools.ListArticle_Ebp.length; i++) {
                                                      Article_Ebp warticleEbp = Srv_DbTools.ListArticle_Ebp[i];
                                                      if (warticleEbp.Article_codeArticle == wdclDet.DCL_Det_NoArt) {
                                                        warticleEbp.Art_Sel = true;
                                                        warticleEbp.Art_Qte = wdclDet.DCL_Det_Qte!;
                                                      } else {
                                                        warticleEbp.Art_Sel = false;
                                                        warticleEbp.Art_Qte = 1;
                                                      }
                                                    }
                                                    Srv_DbTools.ListArticle_Ebpsearchresult.clear();
                                                    Srv_DbTools.ListArticle_Ebpsearchresult.addAll(Srv_DbTools.ListArticle_Ebp);
                                                    await showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) => const DCL_Devis_Det_Article(
                                                        wTitre: "Listing",
                                                      ),
                                                    );
                                                    Reload();
                                                  }
                                                }
                                              }
                                            },
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: <Widget>[
                                                    Container(
                                                      color: wColorBack2,
                                                      width: 640,
                                                      child: wdclDet.DCL_Det_Type == "T"
                                                          ? DetGrid_Row_T(wdclDet)
                                                          : wdclDet.DCL_Det_Type == "A"
                                                              ? (btnSel_Aff ? DetGrid_Row_A_Big(wdclDet) : DetGrid_Row_A(wdclDet))
                                                              : wdclDet.DCL_Det_Type == "S"
                                                                  ? DetGrid_Row_S(wdclDet)
                                                                  : DetGrid_Row_P(wdclDet),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  height: 1,
                                                  color: wColorBack2,
                                                ),
                                                gColors.ombre(),
                                              ],
                                            )))),
                              ],
                            ),
                          ),
                        );
                      })),
        ));
  }
//  await Srv_DbTools.delDCL_Det(wDCL_Det.DCL_DetID!);
//  Reload();

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
      insetPadding: const EdgeInsets.all(60),
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
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                child: Container(
                  height: wHeightTitre,
                  width: wWidth,
                  decoration: const BoxDecoration(color: Colors.yellowAccent, borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
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
                                (Srv_DbTools.gDCL_Det.DCL_Det_Type == "A") ? "Supprimer l'article ?" : "Supprimer l'élément ?",
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
                            await Srv_DbTools.delDCL_Det(Srv_DbTools.gDCL_Det.DCL_DetID!);
                            await Reload();
                            Navigator.pop(context);
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
                height: wHeightDet2 - 24,
                width: wWidth,
                color: gColors.white,
                child: Column(
                  children: [
                    (Srv_DbTools.gDCL_Det.DCL_Det_Type != "A")
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              buildImageEL(context, Srv_DbTools.gDCL_Det.DCL_Det_NoArt!),
                            ],
                          ),
                    (Srv_DbTools.gDCL_Det.DCL_Det_Type != "A")
                        ? Container()
                        : Text(
                            wTitre,
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
  //*****************************************************
  //*****************************************************
  //*****************************************************

  Future<Image> GetImage(Article_Ebp art, double wIcoWidth) async {
    if (art.wImgeTrv) return art.wImage!;

    await Srv_DbTools.getArticlesImg_Ebp(art.Article_codeArticle);
    gObj.pic = base64Decode(Srv_DbTools.gArticlesImg_Ebp.ArticlesImg_Image);

    if (gObj.pic.isNotEmpty) {
      art.wImgeTrv = true;
      art.wImage = Image.memory(
        gObj.pic,
        fit: BoxFit.scaleDown,
        width: wIcoWidth,
        height: wIcoWidth,
      );
      return art.wImage!;
    }
    art.wImgeTrv = true;
    art.wImage = Image.asset(
      "assets/images/Audit_det.png",
      height: wIcoWidth,
      width: wIcoWidth,
    );
    return art.wImage!;
  }

  Widget buildImage(BuildContext context, String dclDetNoart) {
    double wSize = 50;
    var warticleEbp = Srv_DbTools.ListArticle_Ebp.where((element) => element.Article_codeArticle == dclDetNoart);
    if (warticleEbp.isEmpty) {
      return SizedBox(
        width: wSize,
        height: wSize,
      );
    }
    Article_Ebp art = warticleEbp.first;
    return FutureBuilder(
      future: GetImage(art, wSize),
      builder: (BuildContext context, AsyncSnapshot<Image> image) {
        if (image.hasData) {
          return Container(width: wSize, height: wSize, color: gColors.white, child: image.data!);
        } else {
          return Container(width: wSize);
        }
      },
    );
  }

  //*****************************************************
  Future<Image> GetImageL(Article_Ebp art, double wIcoWidth) async {
    if (art.wImgeTrvL) return art.wImageL!;

    await Srv_DbTools.getArticlesImg_Ebp(art.Article_codeArticle);
    gObj.pic = base64Decode(Srv_DbTools.gArticlesImg_Ebp.ArticlesImg_Image);

    if (gObj.pic.isNotEmpty) {
      art.wImgeTrvL = true;
      art.wImageL = Image.memory(
        gObj.pic,
        fit: BoxFit.scaleDown,
        width: wIcoWidth,
        height: wIcoWidth,
      );
      return art.wImageL!;
    }
    art.wImgeTrvL = true;
    art.wImageL = Image.asset(
      "assets/images/Audit_det.png",
      height: wIcoWidth,
      width: wIcoWidth,
    );
    return art.wImageL!;
  }

  Widget buildImageL(BuildContext context, String dclDetNoart) {
    double wSize = 100;
    var warticleEbp = Srv_DbTools.ListArticle_Ebp.where((element) => element.Article_codeArticle == dclDetNoart);
    if (warticleEbp.isEmpty) {
      return SizedBox(
        width: wSize,
        height: wSize,
      );
    }
    Article_Ebp art = warticleEbp.first;
    return FutureBuilder(
      future: GetImageL(art, 400),
      builder: (BuildContext context, AsyncSnapshot<Image> image) {
        if (image.hasData) {
          return Container(width: wSize, height: wSize, color: gColors.white, child: image.data!);
        } else {
          return Container(width: wSize);
        }
      },
    );
  }

  Widget buildImageEL(BuildContext context, String dclDetNoart) {
    double wSize = 400;
    var warticleEbp = Srv_DbTools.ListArticle_Ebp.where((element) => element.Article_codeArticle == dclDetNoart);
    if (warticleEbp.isEmpty) {
      return SizedBox(
        width: wSize,
        height: wSize,
      );
    }
    Article_Ebp art = warticleEbp.first;
    return FutureBuilder(
      future: GetImageL(art, 400),
      builder: (BuildContext context, AsyncSnapshot<Image> image) {
        if (image.hasData) {
          return Container(width: wSize, height: wSize, color: gColors.white, child: image.data!);
        } else {
          return Container(width: wSize);
        }
      },
    );
  }
}

class MySliverAppBar extends StatelessWidget {
  final minHeight = 60.0;
  final maxHeight = 320.0;

  final tabBar = const TabBar(
    labelPadding: EdgeInsets.all(16),
    tabs: <Widget>[Text('Tab1'), Text('Tab2')],
  );

  const MySliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomHeight = tabBar.preferredSize.height;
    return SliverAppBar(
      pinned: true,
      stretch: true,
      toolbarHeight: minHeight - bottomHeight - topPadding,
      collapsedHeight: minHeight - bottomHeight - topPadding,
      expandedHeight: maxHeight - topPadding,
      titleSpacing: 0,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const <StretchMode>[
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Image.network(
          'https://pic1.zhimg.com/80/v2-fc35089cfe6c50f97324c98f963930c9_720w.jpg',
          fit: BoxFit.cover,
          alignment: const Alignment(0.0, 0.4),
        ),
      ),
    );
  }
}
