import 'package:auto_size_text/auto_size_text.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DCL_Det.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_ImportExport.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Param.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/Client/Client_DCL_Ent_Type_Dialog.dart';
import 'package:verifplus/Widget/GestCo/HTML_Text.dart';
import 'package:verifplus/Widget/GestCo/DCL_Article.dart';

import 'package:verifplus/Widget/Widget_Tools/gColors.dart';

class DCL_Devis_Det extends StatefulWidget {
  @override
  DCL_Devis_DetState createState() => DCL_Devis_DetState();
}

class DCL_Devis_DetState extends State<DCL_Devis_Det> with SingleTickerProviderStateMixin {
  bool isChecked = false;
  bool affAll = true;
  bool affEdtFilter = false;

  TextEditingController ctrlFilter = new TextEditingController();

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

  void Reload() async {
    await Srv_ImportExport.getErrorSync();

    bool wRes = await Srv_DbTools.getDCL_All_DetID();

    Filtre();
  }

  void Filtre() {
    isAll = true;
    Srv_DbTools.ListDCL_Detsearchresult.clear();
    String wFilterText = filterText.trim().toUpperCase();
    if (wFilterText.isEmpty) {
      Srv_DbTools.ListDCL_Detsearchresult.addAll(Srv_DbTools.ListDCL_Det);
    } else
      Srv_DbTools.ListDCL_Det.forEach((element) async {
        if (element.Desc().toUpperCase().contains(wFilterText)) Srv_DbTools.ListDCL_Detsearchresult.add(element);
      });
    setState(() {});
  }

  @override
  void initLib() async {
    Reload();
  }

  void initState() {
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
        height: 57,
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
  Widget Entete_Tot_Search() {
    return Container(
        height: 57,
        child: Row(
          children: [
            Container(
              width: 8,
            ),
            InkWell(
                child: Container(
                  width: icoWidth + 10,
                  child: Stack(children: <Widget>[
                    Image.asset(
                      "assets/images/DCL_Total.png",
                      height: icoWidth,
                      width: icoWidth,
                    ),
                  ]),
                ),
                onTap: () async {
                  await HapticFeedback.vibrate();
                  Filtre();
                }),
            Container(
                child: Text(
              "(${Srv_DbTools.ListDCL_Entsearchresult.length})",
              maxLines: 1,
              textAlign: TextAlign.left,
              style: gColors.bodySaisie_B_B,
            ))
          ],
        ));
  }

  @override
  Widget Entete_Ico_Search() {
    return Container(
        decoration: BoxDecoration(
          color: gColors.LinearGradient3,
        ),
        height: 57,
        child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            width: 16,
          ),
          InkWell(
              child: Container(
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
                await Client_DCL_Ent_Type_Dialog.Dialogs_DCL_Ent_Type(context);
                Filtre();
              }),
          Container(
            width: 8,
          ),
          InkWell(
              child: Container(
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
              child: Container(
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
              child: Container(
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
          InkWell(
              child: Container(
                width: icoWidth + 10,
                child: Stack(children: <Widget>[
                  SvgPicture.asset(
                    "assets/images/DCL_Param.svg",
                    height: 40,
                    width: 40,
                  ),
                ]),
              ),
              onTap: () async {
                await HapticFeedback.vibrate();

                Filtre();
              }),
          Spacer(),
          Container(
            width: 44,
            child: Text(
              "Qté",
              maxLines: 1,
              textAlign: TextAlign.right,
              style: gColors.bodySaisie_B_B,
            ),
          ),
          Container(
            width: 15,
          ),
        ]));
  }

  double icoWidth = 40;

  Widget EdtFilterWidget() {
    return Container(
        child: !affEdtFilter
            ? InkWell(
                child: Padding(
                  padding: EdgeInsets.only(right: 8),
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
            : Container(
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

  @override
  Widget build(BuildContext context) {
    double LargeurLabel = 140;

    Param_Param wParam_Param = Srv_DbTools.getParam_Param_in_Mem("Type_Organe", Srv_DbTools.gSelDCL_Ent);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      //    endDrawer: DbTools.gIsMedecinLogin! ? C_SideDrawer() : I_SideDrawer(),

      backgroundColor: Colors.white,

      appBar: appBar(),
      body: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            children: [
              Entete_Btn_Search(),
              gColors.wLigne(),
              Entete_Tot_Search(),
              gColors.wLigne(),
              Entete_Ico_Search(),
              gColors.wLigne(),
              Expanded(
                child: DCL_Devis_DetGridWidget(),
              ),
            ],
          )),
      floatingActionButton: !affAll
          ? Container()
          : Container(
              padding: EdgeInsets.fromLTRB(0, 0, 50, 60),
              child: new FloatingActionButton(
                  elevation: 0.0,
                  child: new Icon(Icons.add),
                  backgroundColor: gColors.secondary,
                  onPressed: () async {


                    await showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          DCL_Articles(
                        onSaisie: onSaisie,
                        art_Type: "Listing",
                        isDevis : false,
                      ),
                    );



                    Reload();
                  }),
            ),
    );
  }

  //***************************
  //***************************
  //***************************

  Widget DetGrid_Row_T(DCL_Det wDCL_Det) {
//    print("DetGrid_Row_T ${wDCL_Det.DCL_Det_Lib}");

    String wDCL_Det_Lib = wDCL_Det.DCL_Det_Lib!.replaceAll("<p>", "").replaceAll("</p>", "");

    wDCL_Det_Lib = " <style lang='scss'>"
            ".ql-align-right {text-align: right;}"
            ".ql-align-center {text-align: center;}"
            ".ql-align-left {text-align: left;}"
            "</style>" +
        wDCL_Det_Lib;

    print("wDCL_Det_Lib ${wDCL_Det_Lib}");

    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        children: [
          Expanded(
              child: Html(
            data: "${wDCL_Det_Lib}",

            style: {
              "html": Style(
                lineHeight: LineHeight(.1),
              ),
            },

//           textStyle:  TextStyle(height: 5) ,
          ))
        ],
      ),
    );
  }

  Widget DetGrid_Row_A(DCL_Det wDCL_Det) {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 0, 15, 0),
        height: 57,
        child: Row(
          children: [
            Image.asset(
              "assets/images/DCL_Det.png",
              height: 50,
              width: 50,
            ),
            Container(
              width: 80,
              child: Text(
                "${wDCL_Det.DCL_Det_NoArt}",
                maxLines: 1,
                textAlign: TextAlign.right,
                style: gColors.bodySaisie_B_B.copyWith(color: (Srv_DbTools.gDCL_Det == wDCL_Det) ? Colors.white : Colors.black),
              ),
            ),
            Container(
              width: 10,
            ),
            Container(
              width: 430,
              child: Text(
                "${wDCL_Det.DCL_Det_Lib}",
                maxLines: 1,
                textAlign: TextAlign.left,
                style: gColors.bodySaisie_B_B.copyWith(color: (Srv_DbTools.gDCL_Det == wDCL_Det) ? Colors.white : Colors.black),
              ),
            ),
            Spacer(),
            Container(
              width: 30,
              child: Text(
                "${wDCL_Det.DCL_Det_Qte}",
                maxLines: 1,
                textAlign: TextAlign.right,
                style: gColors.bodySaisie_B_B.copyWith(color: (Srv_DbTools.gDCL_Det == wDCL_Det) ? Colors.white : Colors.black),
              ),
            ),
          ],
        ));
  }

  Widget DetGrid_Row_P(DCL_Det wDCL_Det) {
    return Container(
        color: gColors.LinearGradient2,
        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
        height: 24,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text(
                "Saut de page",
                maxLines: 1,
                textAlign: TextAlign.left,
                style: gColors.bodySaisie_N_B.copyWith(color: (Srv_DbTools.gDCL_Det == wDCL_Det) ? Colors.white : Colors.black),
              ),
            ),
          ],
        ));
  }

  Widget DetGrid_Row_S(DCL_Det wDCL_Det) {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        height: 24,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text(
                "Sous Total : 10",
                maxLines: 1,
                textAlign: TextAlign.left,
                style: gColors.bodySaisie_N_B.copyWith(color: (Srv_DbTools.gDCL_Det == wDCL_Det) ? Colors.white : Colors.black),
              ),
            ),
          ],
        ));
  }

  //********************************************************************
  //********************************************************************
  //********************************************************************
  //********************************************************************

  Widget DCL_Devis_DetGridWidget() {
    double posX = 0;

    return Listener(
        onPointerDown: (PointerDownEvent event) {
          posX = event.position.dx;
        },
        child: Container(
            color: gColors.LinearGradient2,
            child: ListView.builder(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                itemCount: Srv_DbTools.ListDCL_Detsearchresult.length,
                itemBuilder: (BuildContext context, int index) {
                  DCL_Det wDCL_Det = Srv_DbTools.ListDCL_Detsearchresult[index];
                  Color wColor = Colors.transparent;
                  Color wColorBack = Colors.transparent;
                  Color wColorBack2 = Colors.white;
                  Color wColorText = Colors.black;

                  if (Srv_DbTools.gDCL_Det == wDCL_Det) {
                    if (!btnSel_Aff) wColorBack = gColors.backgroundColor;
                    wColorBack2 = gColors.backgroundColor;
                    wColorText = Colors.white;
                  }
                  String wDCL_Det_Lib = "${wDCL_Det.DCL_Det_Lib}";

                  return Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Flexible(
                          child: Container(
                              color: wColorBack2,
                              child: GestureDetector(
                                  onTap: () async {
                                    await HapticFeedback.vibrate();

                                    if (posX < 120) {
                                      if (Srv_DbTools.gDCL_Det == wDCL_Det) {
                                        Srv_DbTools.gDCL_Det = DCL_Det();
                                      } else {
                                        Srv_DbTools.gDCL_Det = wDCL_Det;
                                      }

                                      setState(() {});
                                    } else {
                                      Srv_DbTools.gDCL_Det = wDCL_Det;
                                      print("Selection FIN ligne qqqqq");

                                      if (wDCL_Det.DCL_Det_Type == "T") {
                                        print(" HTML");

                                        print(" HTML ${wDCL_Det.DCL_Det_Lib}");
                                        HTML_Text.gHTML_Text = "${wDCL_Det.DCL_Det_Lib}";
                                        await HTML_Text.Dialogs_HTMLText(context, "Saisie Texte Ligne N° ${wDCL_Det.DCL_DetID}");
                                        wDCL_Det.DCL_Det_Lib = HTML_Text.gHTML_Text;
                                        print(" HTML retour ${wDCL_Det.DCL_Det_Lib}");
                                        Srv_DbTools.setDCL_Det_Lib(wDCL_Det);
                                        setState(() {});
                                      }
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            width: 640,
                                            child: wDCL_Det.DCL_Det_Type == "T"
                                                ? DetGrid_Row_T(wDCL_Det)
                                                : wDCL_Det.DCL_Det_Type == "A"
                                                    ? DetGrid_Row_A(wDCL_Det)
                                                    : wDCL_Det.DCL_Det_Type == "S"
                                                        ? DetGrid_Row_S(wDCL_Det)
                                                        : DetGrid_Row_P(wDCL_Det),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 1,
                                        color: gColors.LinearGradient4,
                                      ),
                                    ],
                                  )))),
                    ],
                  );
                })));
  }
}
