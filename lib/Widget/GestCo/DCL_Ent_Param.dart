import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:group_button/group_button.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Param.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/Client/Client_Interventions_Status.dart';
import 'package:verifplus/Widget/GestCo/DCL_Param.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

class DCL_Ent_Param extends StatefulWidget {
  @override
  DCL_Ent_ParamState createState() => DCL_Ent_ParamState();
}

class DCL_Ent_ParamState extends State<DCL_Ent_Param> with SingleTickerProviderStateMixin {
  List<Widget> views = <Widget>[
    Text('Paramètres'),
    Text('Business'),
  ];

  final List<bool> _selectedView = <bool>[true, false];

  List<Widget> widgets = [];
  final pageController = PageController(keepPage: false, initialPage: DbTools.gCurrentIndex4);
  List<Widget> ListWidget = [];
  List<Widget> ListWidget2 = [];

  final groupButtonController = GroupButtonController();

  void Reload() async {
    setState(() {});
  }

  @override
  Future initLib() async {
    ListWidget = [
      gColors.wLigne(),
      AffBtnParam("", "Validité du devis", "${Srv_DbTools.gDCL_Ent.DCL_Ent_Validite}", "DCL_Date", gColors.white, gColors.primaryBlue, "Validité du Devis"),
      AffBtnParam("", "Livraison prévisionnelle", "${Srv_DbTools.gDCL_Ent.DCL_Ent_LivrPrev}", "DCL_Date2", gColors.white, gColors.primaryBlue, "Livraison prévisionnelle"),
      AffBtnParam("", "Mode de règlement", "${Srv_DbTools.gDCL_Ent.DCL_Ent_ModeRegl}", "DCL_ModeReglt.svg", gColors.white, gColors.primaryBlue, "Mode de règlement"),
      AffBtnParam("", "Moyen de paiement", "${Srv_DbTools.gDCL_Ent.DCL_Ent_MoyRegl}", "DCL_MoyenPaiement.svg", gColors.white, gColors.primaryBlue, "Moyen de paiement"),
      AffBtnParamSwitch("", "Non-valorisé/Valorisé", Srv_DbTools.gDCL_Ent.DCL_Ent_Valo!, "DCL_Valorise.svg", gColors.white, gColors.primaryBlue, "Non-valorisé/Valorisé"),
      AffBtnParam("", "Préférence d'affichage", "${Srv_DbTools.gDCL_Ent.DCL_Ent_PrefAff}", "DCL_Aff", gColors.white, gColors.primaryBlue, "Préférence d'affichage"),
    ];

    ListWidget2 = [
      gColors.wLigne(),
      AffBtnParam("", "Relance client auto", "${Srv_DbTools.gDCL_Ent.DCL_Ent_RelAuto}", "DCL_Relance.svg", gColors.white, gColors.primaryBlue, "Relance client auto"),
      AffBtnParam("", "Relance anniversaire", "${Srv_DbTools.gDCL_Ent.DCL_Ent_RelAnniv}", "DCL_Aniv.svg", gColors.white, gColors.primaryBlue, "Relance anniversaire"),
      AffBtnParamSwitch("", "Me mettre en copie des relances", int.tryParse(Srv_DbTools.gDCL_Ent.DCL_Ent_CopRel!) ?? 0, "DCL_CopieRel.svg", gColors.white, gColors.primaryBlue, "Me mettre en copie des relances"),

    ];
    widgets = [Parametres(), Business()];

    Reload();
  }

  void initState() {
    super.initState();

    groupButtonController.selectIndex(0);
    _selectedView.clear();
    for (int i = 0; i < views.length; i++) {
      _selectedView.add(i == 0);
    }

    for (int p = 0; p < Srv_DbTools.ListParam_Param_Validite_devis.length; p++) {
      Param_Param wParam_Param = Srv_DbTools.ListParam_Param_Validite_devis[p];
      print("ListParam_Param_Validite_devis ${wParam_Param.Desc()}");
    }

    if (Srv_DbTools.gDCL_Ent.DCL_Ent_Validite!.isEmpty) {
      Srv_DbTools.gDCL_Ent.DCL_Ent_Validite = Srv_DbTools.ListParam_Param_Validite_devis[0].Param_Param_Text;
    }

    initLib();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  AppBar appBar() {
    return AppBar(
      title: InkWell(
        onTap: () async {
          await HapticFeedback.vibrate();
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
          AutoSizeText(
            "DEVIS",
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
    String wTitre2 = "${Srv_DbTools.gDCL_Ent.DCL_Ent_GroupeNom} / ${Srv_DbTools.gDCL_Ent.DCL_Ent_SiteNom} / ${Srv_DbTools.gDCL_Ent.DCL_Ent_ZoneNom}";
    if (Srv_DbTools.gDCL_Ent.DCL_Ent_GroupeNom == Srv_DbTools.gDCL_Ent.DCL_Ent_SiteNom) wTitre2 = "";
    return Scaffold(
        appBar: appBar(),
        body: Stack(
          children: [
            Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(children: [
                  gObj.InterventionTitleWidget("${Srv_DbTools.gDCL_Ent.DCL_Ent_ClientNom!.toUpperCase()}", wTitre2: wTitre2, wTimer: 0),
                  gColors.wLigne(),
                  Container(
                    height: 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      height: 40,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GroupButton(
                              controller: groupButtonController,
                              options: GroupButtonOptions(
                                borderRadius: BorderRadius.circular(8),
                                selectedTextStyle: gColors.bodyTitle1_B_Gr,
                                selectedBorderColor: Colors.white,
                                selectedColor: Colors.white,
                                selectedShadow: const [],
                                unselectedColor: Colors.grey,
                                unselectedBorderColor: Colors.grey,
                                unselectedTextStyle: gColors.bodyTitle1_B_Gr,
                                unselectedShadow: const [],
                                spacing: 10,
                                runSpacing: 10,
                                groupingType: GroupingType.wrap,
                                direction: Axis.horizontal,
                                buttonWidth: 150,
                                buttonHeight: 40,
                                textAlign: TextAlign.center,
                                textPadding: EdgeInsets.zero,
                                alignment: Alignment.center,
                                elevation: 0,
                              ),
                              buttons: ['Paramètres', 'Business'],
                              onSelected: (val, index, selected) {
                                pageController.animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                                setState(() {});
                              }),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      children: widgets,
                      controller: pageController,
//                      onPageChanged: onBottomIconPressed,
                    ),
                  ),
                ])),
          ],
        ));
  }

  Widget Parametres() {
    return Column(
      children: [
        Expanded(
          child: ListWidget.length == 0
              ? Container()
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: ListWidget.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListWidget[index];
                  },
                ),
        ),
      ],
    );
  }

  Widget Business() {
    return Column(
      children: [
        Expanded(
          child: ListWidget2.length == 0
              ? Container()
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: ListWidget2.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListWidget2[index];
                  },
                ),
        ),
      ],
    );
  }

  Widget AffBtnParamSwitch(String wChamps, String wTitle, int wValue, String ImgL, Color BckGrd, Color ForeGrd, String wParam) {
    return Column(
      children: [
        AffLigneSwitch(wTitle, wValue == 1, BckGrd, ImgL, ForeGrd),
      ],
    );
  }

  Widget AffLigneSwitch(
    String wTextL,
    bool bSwitch,
    Color BckGrd,
    String ImgL,
    Color ForeGrd,
  ) {
    double wHeight = 44;
    double mTop = 15;
    double icoWidth = 32;

    return Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                Container(
                    padding: EdgeInsets.only(left: 10, top: mTop),
                    height: wHeight,
                    child: Text(
                      "${wTextL}",
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: gColors.bodySaisie_B_B,
                    )),
               Spacer(),
               Container(
                  padding: EdgeInsets.only(right: 10, top: 0),
                  height: wHeight,
                  child: Switch(
                    activeColor: Colors.green,
                    value: bSwitch,
                    onChanged: (bool value) {
                      setState(() async {
                        bSwitch = value;
                        if (wTextL == "Non-valorisé/Valorisé") Srv_DbTools.gDCL_Ent.DCL_Ent_Valo = value ? 1 : 0;
                        if (wTextL == "Me mettre en copie des relances") Srv_DbTools.gDCL_Ent.DCL_Ent_CopRel = value ? "1" : "0";
                        await Srv_DbTools.setDCL_Ent(Srv_DbTools.gDCL_Ent);

                        await initLib();

                      });
                    },
                  ),
                ),
              ],
            ),
            gColors.wLigne(),
          ],
        ));
  }

  Widget AffBtnParam(String wChamps, String wTitle, String wValue, String ImgL, Color BckGrd, Color ForeGrd, String wParam) {
    return TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () async {
          print("onPressed");
          await HapticFeedback.vibrate();

          //**************************************************
          //**************************************************
          //**************************************************
          if (wParam == "Validité du Devis") {
            DCL_Param_Dialog.ListParam.clear();
            for (int i = 0; i < Srv_DbTools.ListParam_Param_Validite_devis.length; i++) {
              Param_Param element = Srv_DbTools.ListParam_Param_Validite_devis[i];
              DCL_Param_Dialog.ListParam.add(element.Param_Param_Text);
            }
            ;
            DCL_Param_Dialog.wSel = DCL_Param_Dialog.ListParam[0];
            print("DCL_Param_Dialog.wSel $DCL_Param_Dialog.wSel");

            print("wStatus ${Srv_DbTools.gDCL_Ent.DCL_Ent_Validite}");

            for (int i = 0; i < DCL_Param_Dialog.ListParam.length; i++) {
              String element = DCL_Param_Dialog.ListParam[i];
              if (element == Srv_DbTools.gDCL_Ent.DCL_Ent_Validite) {
                DCL_Param_Dialog.wSel = element;
                break;
              }
            };
            await DCL_Param_Dialog.Dialogs_DCL_Param(context, wParam);
            if (DCL_Param_Dialog.wSel != "") {
              Srv_DbTools.gDCL_Ent.DCL_Ent_Validite = DCL_Param_Dialog.wSel;
              await Srv_DbTools.setDCL_Ent(Srv_DbTools.gDCL_Ent);
            }
          }
          //**************************************************
          //**************************************************
          //**************************************************
          if (wParam == "Livraison prévisionnelle") {
            DCL_Param_Dialog.ListParam.clear();
            for (int i = 0; i < Srv_DbTools.ListParam_Param_Livraison_prev.length; i++) {
              Param_Param element = Srv_DbTools.ListParam_Param_Livraison_prev[i];
              DCL_Param_Dialog.ListParam.add(element.Param_Param_Text);
            }
            ;
            DCL_Param_Dialog.wSel = DCL_Param_Dialog.ListParam[0];
            print("DCL_Param_Dialog.wSel $DCL_Param_Dialog.wSel");

            print("wStatus ${Srv_DbTools.gDCL_Ent.DCL_Ent_LivrPrev}");

            for (int i = 0; i < DCL_Param_Dialog.ListParam.length; i++) {
              String element = DCL_Param_Dialog.ListParam[i];
              if (element == Srv_DbTools.gDCL_Ent.DCL_Ent_LivrPrev) {
                DCL_Param_Dialog.wSel = element;
                break;
              }
            }
            ;
            await DCL_Param_Dialog.Dialogs_DCL_Param(context, wParam);
            if (DCL_Param_Dialog.wSel != "") {
              Srv_DbTools.gDCL_Ent.DCL_Ent_LivrPrev = DCL_Param_Dialog.wSel;
              await Srv_DbTools.setDCL_Ent(Srv_DbTools.gDCL_Ent);
            }
          }
          //**************************************************
          //**************************************************
          //**************************************************
          if (wParam == "Mode de règlement") {
            DCL_Param_Dialog.ListParam.clear();
            for (int i = 0; i < Srv_DbTools.ListParam_Param_Mode_rglt.length; i++) {
              Param_Param element = Srv_DbTools.ListParam_Param_Mode_rglt[i];
              DCL_Param_Dialog.ListParam.add(element.Param_Param_Text);
            }
            ;
            DCL_Param_Dialog.wSel = DCL_Param_Dialog.ListParam[0];
            print("DCL_Param_Dialog.wSel $DCL_Param_Dialog.wSel");

            print("wStatus ${Srv_DbTools.gDCL_Ent.DCL_Ent_ModeRegl}");

            for (int i = 0; i < DCL_Param_Dialog.ListParam.length; i++) {
              String element = DCL_Param_Dialog.ListParam[i];
              if (element == Srv_DbTools.gDCL_Ent.DCL_Ent_ModeRegl) {
                DCL_Param_Dialog.wSel = element;
                break;
              }
            }
            ;
            await DCL_Param_Dialog.Dialogs_DCL_Param(context, wParam);
            if (DCL_Param_Dialog.wSel != "") {
              Srv_DbTools.gDCL_Ent.DCL_Ent_ModeRegl = DCL_Param_Dialog.wSel;
              await Srv_DbTools.setDCL_Ent(Srv_DbTools.gDCL_Ent);
            }
          }
          //**************************************************
          //**************************************************
          //**************************************************
          if (wParam == "Moyen de paiement") {
            DCL_Param_Dialog.ListParam.clear();
            for (int i = 0; i < Srv_DbTools.ListParam_Param_Moyen_paiement.length; i++) {
              Param_Param element = Srv_DbTools.ListParam_Param_Moyen_paiement[i];
              DCL_Param_Dialog.ListParam.add(element.Param_Param_Text);
            }
            ;
            DCL_Param_Dialog.wSel = DCL_Param_Dialog.ListParam[0];
            print("DCL_Param_Dialog.wSel $DCL_Param_Dialog.wSel");

            print("wStatus ${Srv_DbTools.gDCL_Ent.DCL_Ent_MoyRegl}");

            for (int i = 0; i < DCL_Param_Dialog.ListParam.length; i++) {
              String element = DCL_Param_Dialog.ListParam[i];
              if (element == Srv_DbTools.gDCL_Ent.DCL_Ent_MoyRegl) {
                DCL_Param_Dialog.wSel = element;
                break;
              }
            }
            ;
            await DCL_Param_Dialog.Dialogs_DCL_Param(context, wParam);
            if (DCL_Param_Dialog.wSel != "") {
              Srv_DbTools.gDCL_Ent.DCL_Ent_MoyRegl = DCL_Param_Dialog.wSel;
              await Srv_DbTools.setDCL_Ent(Srv_DbTools.gDCL_Ent);
            }
          }
          //**************************************************
          //**************************************************
          //**************************************************
          if (wParam == "Préférence d'affichage") {
            DCL_Param_Dialog.ListParam.clear();
            for (int i = 0; i < Srv_DbTools.ListParam_Param_Pref_Aff.length; i++) {
              Param_Param element = Srv_DbTools.ListParam_Param_Pref_Aff[i];
              DCL_Param_Dialog.ListParam.add(element.Param_Param_Text);
            }
            ;
            DCL_Param_Dialog.wSel = DCL_Param_Dialog.ListParam[0];
            print("DCL_Param_Dialog.wSel $DCL_Param_Dialog.wSel");

            print("wStatus ${Srv_DbTools.gDCL_Ent.DCL_Ent_PrefAff}");

            for (int i = 0; i < DCL_Param_Dialog.ListParam.length; i++) {
              String element = DCL_Param_Dialog.ListParam[i];
              if (element == Srv_DbTools.gDCL_Ent.DCL_Ent_PrefAff) {
                DCL_Param_Dialog.wSel = element;
                break;
              }
            }
            ;
            await DCL_Param_Dialog.Dialogs_DCL_Param(context, wParam);
            if (DCL_Param_Dialog.wSel != "") {
              Srv_DbTools.gDCL_Ent.DCL_Ent_PrefAff = DCL_Param_Dialog.wSel;
              await Srv_DbTools.setDCL_Ent(Srv_DbTools.gDCL_Ent);
            }
          }
          //**************************************************
          //**************************************************
          //**************************************************
          if (wParam == "Relance client auto") {
            DCL_Param_Dialog.ListParam.clear();
            for (int i = 0; i < Srv_DbTools.ListParam_Param_Rel_Auto.length; i++) {
              Param_Param element = Srv_DbTools.ListParam_Param_Rel_Auto[i];
              DCL_Param_Dialog.ListParam.add(element.Param_Param_Text);
            }
            ;
            DCL_Param_Dialog.wSel = DCL_Param_Dialog.ListParam[0];
            print("DCL_Param_Dialog.wSel $DCL_Param_Dialog.wSel");

            print("wStatus ${Srv_DbTools.gDCL_Ent.DCL_Ent_RelAuto}");
            for (int i = 0; i < DCL_Param_Dialog.ListParam.length; i++) {
              String element = DCL_Param_Dialog.ListParam[i];
              if (element == Srv_DbTools.gDCL_Ent.DCL_Ent_RelAuto) {
                DCL_Param_Dialog.wSel = element;
                break;
              }
            }
            ;

            await DCL_Param_Dialog.Dialogs_DCL_Param(context, wParam);
            if (DCL_Param_Dialog.wSel != "") {
              Srv_DbTools.gDCL_Ent.DCL_Ent_RelAuto = DCL_Param_Dialog.wSel;
              await Srv_DbTools.setDCL_Ent(Srv_DbTools.gDCL_Ent);
            }
          }

          if (wParam == "Relance anniversaire") {
            DCL_Param_Dialog.ListParam.clear();
            for (int i = 0; i < Srv_DbTools.ListParam_Param_Rel_Anniv.length; i++) {
              Param_Param element = Srv_DbTools.ListParam_Param_Rel_Anniv[i];
              DCL_Param_Dialog.ListParam.add(element.Param_Param_Text);
            }
            ;
            DCL_Param_Dialog.wSel = DCL_Param_Dialog.ListParam[0];
            print("DCL_Param_Dialog.wSel $DCL_Param_Dialog.wSel");

            print("wStatus ${Srv_DbTools.gDCL_Ent.DCL_Ent_RelAnniv}");
            for (int i = 0; i < DCL_Param_Dialog.ListParam.length; i++) {
              String element = DCL_Param_Dialog.ListParam[i];
              if (element == Srv_DbTools.gDCL_Ent.DCL_Ent_RelAnniv) {
                DCL_Param_Dialog.wSel = element;
                break;
              }
            }
            ;

            await DCL_Param_Dialog.Dialogs_DCL_Param(context, wParam);
            if (DCL_Param_Dialog.wSel != "") {
              Srv_DbTools.gDCL_Ent.DCL_Ent_RelAnniv = DCL_Param_Dialog.wSel;
              await Srv_DbTools.setDCL_Ent(Srv_DbTools.gDCL_Ent);
            }
          }

          await initLib();
          setState(() {});
        },
        child: Column(
          children: [
            AffLigne(wTitle, "$wValue >", BckGrd, ImgL, ForeGrd),
          ],
        ));
  }

  Widget AffLigne(
    String wTextL,
    String wTextR,
    Color BckGrd,
    String ImgL,
    Color ForeGrd,
  ) {
    double wHeight = 44;
    double mTop = 15;
    double icoWidth = 32;

    return Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                Container(
                    padding: EdgeInsets.only(left: 10, top: mTop),
                    height: wHeight,
                    child: Text(
                      "${wTextL}",
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: gColors.bodySaisie_B_B,
                    )),
                Expanded(
                    child: Container(
                        padding: EdgeInsets.only(right: 10, top: mTop),
                        height: wHeight,
                        child: Text(
                          "${wTextR}",
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          style: gColors.bodySaisie_B_B.copyWith(color: ForeGrd),
                        ))),
              ],
            ),
            gColors.wLigne(),
          ],
        ));
  }
}
