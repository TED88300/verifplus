import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:group_button/group_button.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Param.dart';
import 'package:verifplus/Tools/DbSrv/Srv_User.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/GestCo/DCL_Param.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';

class DCL_Det_Param extends StatefulWidget {
  const DCL_Det_Param({super.key});

  @override
  DCL_Det_ParamState createState() => DCL_Det_ParamState();
}

class DCL_Det_ParamState extends State<DCL_Det_Param> with SingleTickerProviderStateMixin {
  List<Widget> views = <Widget>[
    const Text('Paramètres'),
    const Text('Business'),
  ];

  final List<bool> _selectedView = <bool>[true, false];

  List<Widget> widgets = [];
  final pageController = PageController(keepPage: false, initialPage: DbTools.gCurrentIndex4);
  List<Widget> ListWidget = [];
  List<Widget> ListWidget2 = [];
  List<Widget> ListWidget3 = [];

  final groupButtonController = GroupButtonController();

  void Reload() async {
    setState(() {});
  }

  @override
  Future initLib() async {
    String strRegl = "";
    String wRegl = Srv_DbTools.gDCL_Ent.DCL_Ent_Regl!;
    print(" wRegl $wRegl");
    if (wRegl.isNotEmpty) {
      List<bool> itemlistApp = json.decode(wRegl).cast<bool>().toList();
      for (int i = 0; i < itemlistApp.length; i++) {
        var element = itemlistApp[i];
        if (element) {
          strRegl = "${listRegl[i]}, ...";
          break;
        }
      }
    }

    String strPartage = "";
    List<int> list = Srv_DbTools.gDCL_Ent.DCL_Ent_Partage!.split(',').map<int>((e) {
      return int.tryParse(e) ?? 0;
    }).toList();
    for (int i = 0; i < Srv_DbTools.ListUser.length; i++) {
      User wUser = Srv_DbTools.ListUser[i];
      bool wTmp = list.contains(int.parse(wUser.User_Matricule));
      if (wTmp) {
        strPartage = "${wUser.User_Nom} ${wUser.User_Prenom}, ...";
        break;
      }
    }

    String strContributeurs = "";
    list = Srv_DbTools.gDCL_Ent.DCL_Ent_Contributeurs!.split(',').map<int>((e) {
      return int.tryParse(e) ?? 0;
    }).toList();
    for (int i = 0; i < Srv_DbTools.ListUser.length; i++) {
      User wUser = Srv_DbTools.ListUser[i];
      bool wTmp = list.contains(int.parse(wUser.User_Matricule));
      if (wTmp) {
        strContributeurs = "${wUser.User_Nom} ${wUser.User_Prenom}, ...";
        break;
      }
    }

    String strDemTech = "";
    list = Srv_DbTools.gDCL_Ent.DCL_Ent_DemTech!.split(',').map<int>((e) {
      return int.tryParse(e) ?? 0;
    }).toList();
    for (int i = 0; i < Srv_DbTools.ListUser.length; i++) {
      User wUser = Srv_DbTools.ListUser[i];
      bool wTmp = list.contains(int.parse(wUser.User_Matricule));
      if (wTmp) {
        strDemTech = "${wUser.User_Nom} ${wUser.User_Prenom}, ...";
        break;
      }
    }

    String strDemSsT = "";
    list = Srv_DbTools.gDCL_Ent.DCL_Ent_DemSsT!.split(',').map<int>((e) {
      return int.tryParse(e) ?? 0;
    }).toList();
    for (int i = 0; i < Srv_DbTools.ListUser.length; i++) {
      User wUser = Srv_DbTools.ListUser[i];
      bool wTmp = list.contains(int.parse(wUser.User_Matricule));
      if (wTmp) {
        strDemSsT = "${wUser.User_Nom} ${wUser.User_Prenom}, ...";
        break;
      }
    }

    ListWidget = [
      gColors.wLigne(),
      AffTxtParam(
        "Collaborateur",
        "${Srv_DbTools.gUserLogin.User_Nom} / ${Srv_DbTools.gUserLogin.User_Depot}",
        "DCL_Collab.svg",
        gColors.white,
        gColors.primaryBlue,
      ),
      AffBtnParam("", "Affaire", "${Srv_DbTools.gDCL_Ent.DCL_Ent_Affaire}", "DCL_Date", gColors.white, gColors.primaryBlue, "Affaire", wChampsNote: "DCL_Ent_AffaireNote"),
      AffBtnParamSwitch("", "Non-valorisé/Valorisé", Srv_DbTools.gDCL_Ent.DCL_Ent_Valo!, "DCL_Valorise.svg", gColors.white, gColors.primaryBlue, "Non-valorisé/Valorisé"),
    ];

    ListWidget2 = [
      gColors.wLigne(),
      AffBtnParam("", "Relance client automatique", "${Srv_DbTools.gDCL_Ent.DCL_Ent_RelAuto}", "DCL_Relance.svg", gColors.white, gColors.primaryBlue, "Relance client auto", bLigne: false),
      AffBtnParamSwitch("", "Activation", int.tryParse(Srv_DbTools.gDCL_Ent.DCL_Ent_RelanceAuto.toString()) ?? 0, "DCL_Activation.svg", gColors.white, gColors.primaryBlue, "ActivationAuto"),
      gColors.wLigne(),
      AffBtnParam("", "Relance anniversaire", "${Srv_DbTools.gDCL_Ent.DCL_Ent_RelAnniv}", "DCL_Aniv.svg", gColors.white, gColors.primaryBlue, "Relance anniversaire", bLigne: false),
      AffBtnParamSwitch("", "Activation", (int.tryParse(Srv_DbTools.gDCL_Ent.DCL_Ent_RelanceAnniv.toString()) ?? 0), "DCL_Activation.svg", gColors.white, gColors.primaryBlue, "ActivationAnniv"),
      gColors.wLigne(),
      AffBtnParamSwitch("", "Me mettre en copie des relances", int.tryParse(Srv_DbTools.gDCL_Ent.DCL_Ent_CopRel!) ?? 0, "DCL_CopieRel.svg", gColors.white, gColors.primaryBlue, "Me mettre en copie des relances"),
      AffBtnParam("", "Probabilités d'acceptation", "${Srv_DbTools.gDCL_Ent.DCL_Ent_Proba}", "DCL_Proba.svg", gColors.white, gColors.primaryBlue, "Proba", wChampsNote: "DCL_Ent_Proba_Note"),
      AffBtnParam("", "Conccurent", "${Srv_DbTools.gDCL_Ent.DCL_Ent_Concurent}", "DCL_Conccurent.svg", gColors.white, gColors.primaryBlue, "Conccurent"),
      AffBtnParam("", "Note interne", "${Srv_DbTools.gDCL_Ent.DCL_Ent_Note}", "DCL_Note.svg", gColors.white, gColors.primaryBlue, "Note"),
      AffBtnParam("", "Scanner un document/PJ", "", "DCL_Doc.svg", gColors.white, gColors.primaryBlue, "Scanner"),
    ];

    ListWidget3 = [
      gColors.wLigne(),
      AffBtnParam("", "Règlementations technique applicables", strRegl, "DCL_Reglementations.svg", gColors.white, gColors.primaryBlue, "Rglt"),
      AffBtnParam("", "Paratge commercial", strPartage, "DCL_Paratge.svg", gColors.white, gColors.primaryBlue, "Paratge"),
      AffBtnParam("", "Contributeurs commerciaux", strContributeurs, "DCL_Contributeurs.svg", gColors.white, gColors.primaryBlue, "Contributeurs"),
      AffBtnParam("", "Demander de l'aide technique", strDemTech, "DCL_aidetechnique.svg", gColors.white, gColors.primaryBlue, "aideTech"),
      AffBtnParam("", "Demander un sous-traitants", strDemSsT, "DCL_soustraitants.svg", gColors.white, gColors.primaryBlue, "ssTr"),
    ];

    widgets = [Parametres(), Business(), Technique()];
    Reload();
  }

  @override
  void initState() {
    super.initState();

    groupButtonController.selectIndex(0);
    _selectedView.clear();
    for (int i = 0; i < views.length; i++) {
      _selectedView.add(i == 0);
    }

    if (Srv_DbTools.gDCL_Ent.DCL_Ent_Validite!.isEmpty) {
      Srv_DbTools.gDCL_Ent.DCL_Ent_Validite = Srv_DbTools.ListParam_Param_Validite_devis[0].Param_Param_Text;
    }

    if (Srv_DbTools.gDCL_Ent.DCL_Ent_Affaire!.isEmpty) {
      Srv_DbTools.gDCL_Ent.DCL_Ent_Affaire = Srv_DbTools.ListParam_Param_Affaire[0].Param_Param_Text;
    }

    initLib();
  }

  @override
  Widget build(BuildContext context) {
    String wTitre2 = "${Srv_DbTools.gDCL_Ent.DCL_Ent_GroupeNom} / ${Srv_DbTools.gDCL_Ent.DCL_Ent_SiteNom} / ${Srv_DbTools.gDCL_Ent.DCL_Ent_ZoneNom}";
    if (Srv_DbTools.gDCL_Ent.DCL_Ent_GroupeNom == Srv_DbTools.gDCL_Ent.DCL_Ent_SiteNom) wTitre2 = "";

    double icoWidth = 40;
    double wHeight = 800;
    double wWidth = MediaQuery.of(context).size.width;

/*

    return SimpleDialog(insetPadding: const EdgeInsets.fromLTRB(0, 200, 0, 0),
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        backgroundColor: gColors.red,
        shadowColor: gColors.transparent, children: [
          Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(children: [
                SizedBox(
                  height: 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                            buttons: const ['Paramètres', 'Business', 'Technique'],
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
                    controller: pageController,
                    onPageChanged: onBottomIconPressed,
                    children: widgets,
                  ),
                ),
              ])),

      */
/*    Scaffold(
          body: Stack(
        children: [
          Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(children: [
                SizedBox(
                  height: 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                            buttons: const ['Paramètres', 'Business', 'Technique'],
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
                    controller: pageController,
                    onPageChanged: onBottomIconPressed,
                    children: widgets,
                  ),
                ),
              ])),
        ],
      )),*//*

    ]);

*/

    return SimpleDialog(insetPadding: const EdgeInsets.fromLTRB(0, 200, 0, 0), titlePadding: EdgeInsets.zero, contentPadding: EdgeInsets.zero, surfaceTintColor: Colors.transparent, backgroundColor: gColors.LinearGradient3, shadowColor: gColors.transparent, children: [
      Container(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          height: wHeight,
          width: wWidth,
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
              Container(
                width: 16,
              ),
              InkWell(
                  child: SizedBox(
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
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
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
            SizedBox(
              height: 100,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                        buttons: const ['Paramètres', 'Business', 'Technique'],
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
                controller: pageController,
                children: widgets,
//                      onPageChanged: onBottomIconPressed,
              ),
            ),
          ])),
    ]);


  }

  void onBottomIconPressed(int index) async {
    groupButtonController.selectIndex(index);
    setState(() {});
  }

  Widget Parametres() {
    return Column(
      children: [
        Expanded(
          child: ListWidget.isEmpty
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
          child: ListWidget2.isEmpty
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

  Widget Technique() {
    return Column(
      children: [
        Expanded(
          child: ListWidget3.isEmpty
              ? Container()
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: ListWidget3.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListWidget3[index];
                  },
                ),
        ),
      ],
    );
  }

  Widget AffBtnParamSwitch(String wChamps, String wTitle, int wValue, String ImgL, Color BckGrd, Color ForeGrd, String wParam, {bool bLigne = true}) {
    return Column(
      children: [
        AffLigneSwitch(wTitle, wValue == 1, BckGrd, ImgL, ForeGrd, wParam, bLigne),
      ],
    );
  }

  Widget AffLigneSwitch(
    String wTextL,
    bool bSwitch,
    Color BckGrd,
    String ImgL,
    Color ForeGrd,
    String wParam,
    bool bLigne,
  ) {
    double wHeight = 71;
    double mTop = 28;
    double icoWidth = 32;

    return Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        color: BckGrd,
        child: Column(
          children: [
            Row(
              children: <Widget>[
                ImgL.isEmpty
                    ? Container()
                    : ImgL.contains(".svg")
                        ? Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: SvgPicture.asset(
                              "assets/images/$ImgL",
                              height: icoWidth,
                              width: icoWidth,
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: Image.asset(
                              "assets/images/$ImgL.png",
                              height: icoWidth,
                              width: icoWidth,
                            ),
                          ),
                Container(
                    padding: EdgeInsets.only(left: 10, top: mTop),
                    height: wHeight,
                    child: Text(
                      wTextL,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: gColors.bodyTitle1_B_Gr,
                    )),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.only(right: 10, top: 0),
                  height: wHeight,
                  child: Switch(
                    activeColor: Colors.green,
                    value: bSwitch,
                    onChanged: (bool value) {
                      setState(() async {
                        bSwitch = value;
                        if (wParam == "Non-valorisé/Valorisé") Srv_DbTools.gDCL_Ent.DCL_Ent_Valo = value ? 1 : 0;
                        if (wParam == "Me mettre en copie des relances") Srv_DbTools.gDCL_Ent.DCL_Ent_CopRel = value ? "1" : "0";
                        if (wParam == "ActivationAuto") Srv_DbTools.gDCL_Ent.DCL_Ent_RelanceAuto = value ? 1 : 0;
                        if (wParam == "ActivationAnniv") Srv_DbTools.gDCL_Ent.DCL_Ent_RelanceAnniv = value ? 1 : 0;

                        await Srv_DbTools.setDCL_Ent(Srv_DbTools.gDCL_Ent);

                        await initLib();
                      });
                    },
                  ),
                ),
              ],
            ),
            if (bLigne) gColors.wLigne(),
          ],
        ));
  }

  Widget AffTxtParam(
    String wTitle,
    String wValue,
    String ImgL,
    Color BckGrd,
    Color ForeGrd,
  ) {
    return AffLigne(wTitle, wValue, BckGrd, ImgL, ForeGrd);
  }

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

          //**************************************************
          //**************************************************
          //**************************************************
          if (wParam == "Affaire") {
            DCL_Param_Dialog.ListParam.clear();
            for (int i = 0; i < Srv_DbTools.ListParam_Param_Affaire.length; i++) {
              Param_Param element = Srv_DbTools.ListParam_Param_Affaire[i];
              DCL_Param_Dialog.ListParam.add(element.Param_Param_Text);
            }

            DCL_Param_Dialog.wSel = DCL_Param_Dialog.ListParam[0];
            print("DCL_Param_Dialog.wSel $DCL_Param_Dialog.wSel");

            print("wStatus ${Srv_DbTools.gDCL_Ent.DCL_Ent_Affaire}");

            for (int i = 0; i < DCL_Param_Dialog.ListParam.length; i++) {
              String element = DCL_Param_Dialog.ListParam[i];
              if (element == Srv_DbTools.gDCL_Ent.DCL_Ent_Affaire) {
                DCL_Param_Dialog.wSel = element;
                break;
              }
            }

            if (wChampsNote.isNotEmpty) {
              print("Affaire AAAAA ${Srv_DbTools.gDCL_Ent.DCL_Ent_Affaire}");
              await DCL_Param_Dialog.Dialogs_DCL_ParamNote(context, wParam, "${Srv_DbTools.gDCL_Ent.DCL_Ent_AffaireNote}");
            } else {
              print("Affaire BBBBBB ${Srv_DbTools.gDCL_Ent.DCL_Ent_Affaire}");
              await DCL_Param_Dialog.Dialogs_DCL_Param(context, wParam);
            }
            if (DCL_Param_Dialog.wSel != "") {
              if (DCL_Param_Dialog.wNote != "") {
                Srv_DbTools.gDCL_Ent.DCL_Ent_AffaireNote = DCL_Param_Dialog.wNote;
              }
              Srv_DbTools.gDCL_Ent.DCL_Ent_Affaire = DCL_Param_Dialog.wSel;
              await Srv_DbTools.setDCL_Ent(Srv_DbTools.gDCL_Ent);
            }
          }

          //**************************************************
          //**************************************************
          //**************************************************
          if (wParam == "Proba") {
            DCL_Param_Dialog.ListParam.clear();
            for (int i = 0; i < Srv_DbTools.ListParam_Param_Proba.length; i++) {
              Param_Param element = Srv_DbTools.ListParam_Param_Proba[i];
              DCL_Param_Dialog.ListParam.add(element.Param_Param_Text);
            }

            DCL_Param_Dialog.wSel = DCL_Param_Dialog.ListParam[0];
            print("DCL_Param_Dialog.wSel $DCL_Param_Dialog.wSel");

            print("wStatus ${Srv_DbTools.gDCL_Ent.DCL_Ent_Proba}");

            for (int i = 0; i < DCL_Param_Dialog.ListParam.length; i++) {
              String element = DCL_Param_Dialog.ListParam[i];
              if (element == Srv_DbTools.gDCL_Ent.DCL_Ent_Proba) {
                DCL_Param_Dialog.wSel = element;
                break;
              }
            }

            if (wChampsNote.isNotEmpty) {
              await DCL_Param_Dialog.Dialogs_DCL_ParamNote(context, wParam, "${Srv_DbTools.gDCL_Ent.DCL_Ent_Proba_Note}");
            } else {
              await DCL_Param_Dialog.Dialogs_DCL_Param(context, wParam);
            }
            if (DCL_Param_Dialog.wSel != "") {
              if (DCL_Param_Dialog.wNote != "") {
                Srv_DbTools.gDCL_Ent.DCL_Ent_Proba_Note = DCL_Param_Dialog.wNote;
              }
              Srv_DbTools.gDCL_Ent.DCL_Ent_Proba = int.tryParse(DCL_Param_Dialog.wSel) ?? 20;
              await Srv_DbTools.setDCL_Ent(Srv_DbTools.gDCL_Ent);
            }
          }

          //**************************************************
          //**************************************************
          //**************************************************

          if (wParam == "Conccurent") {
            DCL_Param_Dialog.ListParam.clear();
            await DCL_Param_Dialog.Dialogs_DCL_ParamText(context, wParam, "${Srv_DbTools.gDCL_Ent.DCL_Ent_Concurent}");
            Srv_DbTools.gDCL_Ent.DCL_Ent_Concurent = DCL_Param_Dialog.wNote;
            await Srv_DbTools.setDCL_Ent(Srv_DbTools.gDCL_Ent);
          }

          if (wParam == "Note") {
            DCL_Param_Dialog.ListParam.clear();
            await DCL_Param_Dialog.Dialogs_DCL_ParamText(context, wParam, "${Srv_DbTools.gDCL_Ent.DCL_Ent_Note}");
            Srv_DbTools.gDCL_Ent.DCL_Ent_Note = DCL_Param_Dialog.wNote;
            await Srv_DbTools.setDCL_Ent(Srv_DbTools.gDCL_Ent);
          }

          if (wParam == "Scanner") {
            DCL_Param_Dialog.ListParam.clear();
            await DCL_Param_Dialog.Dialogs_DCL_ScanDoc(context, "Scanner un document/PJ", "${Srv_DbTools.gDCL_Ent.DCL_Ent_Note}");
          }

          if (wParam == "Rglt") {
            DCL_Param_Dialog.ListParam.clear();
            await DCL_Param_Dialog.Dialogs_DCL_Rglt(context, "Règlementations technique applicables", "zzz");
          }

          if (wParam == "Paratge") {
            DCL_Param_Dialog.ListParam.clear();
            await DCL_Param_Dialog.Dialogs_DCL_Partage(context, "Paratge commercial", "zzz");
          }

          if (wParam == "Contributeurs") {
            DCL_Param_Dialog.ListParam.clear();
            await DCL_Param_Dialog.Dialogs_DCL_Contributeurs(context, "Contributeurs commerciaux", "zzz");
          }

          if (wParam == "aideTech") {
            DCL_Param_Dialog.ListParam.clear();
            await DCL_Param_Dialog.Dialogs_DCL_aideTech(context, "Demander de l'aide technique", "zzz");
          }

          if (wParam == "ssTr") {
            DCL_Param_Dialog.ListParam.clear();
            await DCL_Param_Dialog.Dialogs_DCL_ssTr(context, "Demander un sous-traitants", "zzz");
          }

          //**************************************************
          //**************************************************
          //**************************************************
          if (wParam == "Validité du Devis") {
            DCL_Param_Dialog.ListParam.clear();
            for (int i = 0; i < Srv_DbTools.ListParam_Param_Validite_devis.length; i++) {
              Param_Param element = Srv_DbTools.ListParam_Param_Validite_devis[i];
              DCL_Param_Dialog.ListParam.add(element.Param_Param_Text);
            }

            DCL_Param_Dialog.wSel = DCL_Param_Dialog.ListParam[0];
            print("DCL_Param_Dialog.wSel $DCL_Param_Dialog.wSel");

            print("wStatus ${Srv_DbTools.gDCL_Ent.DCL_Ent_Validite}");

            for (int i = 0; i < DCL_Param_Dialog.ListParam.length; i++) {
              String element = DCL_Param_Dialog.ListParam[i];
              if (element == Srv_DbTools.gDCL_Ent.DCL_Ent_Validite) {
                DCL_Param_Dialog.wSel = element;
                break;
              }
            }
            await DCL_Param_Dialog.Dialogs_DCL_Param(context, wParam);
            if (DCL_Param_Dialog.wSel != "") {
              Srv_DbTools.gDCL_Ent.DCL_Ent_Validite = DCL_Param_Dialog.wSel;
              await Srv_DbTools.setDCL_Ent(Srv_DbTools.gDCL_Ent);
            }
          }

          //**************************************************
          //**************************************************
          if (wParam == "Livraison prévisionnelle") {
            DCL_Param_Dialog.ListParam.clear();
            for (int i = 0; i < Srv_DbTools.ListParam_Param_Livraison_prev.length; i++) {
              Param_Param element = Srv_DbTools.ListParam_Param_Livraison_prev[i];
              DCL_Param_Dialog.ListParam.add(element.Param_Param_Text);
            }
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

            DCL_Param_Dialog.wContact = Srv_DbTools.gDCL_Ent.DCL_Ent_RelanceContact!;
            DCL_Param_Dialog.wMail = Srv_DbTools.gDCL_Ent.DCL_Ent_RelanceMail!;
            DCL_Param_Dialog.wTel = Srv_DbTools.gDCL_Ent.DCL_Ent_RelanceTel!;
            await DCL_Param_Dialog.Dialogs_DCL_ParamRelance(context, wParam, DCL_Param_Dialog.wContact, DCL_Param_Dialog.wMail, DCL_Param_Dialog.wTel);

            if (DCL_Param_Dialog.wSel != "") {
              Srv_DbTools.gDCL_Ent.DCL_Ent_RelAuto = DCL_Param_Dialog.wSel;

              Srv_DbTools.gDCL_Ent.DCL_Ent_RelanceContact = DCL_Param_Dialog.wContact;
              Srv_DbTools.gDCL_Ent.DCL_Ent_RelanceMail = DCL_Param_Dialog.wMail;
              Srv_DbTools.gDCL_Ent.DCL_Ent_RelanceTel = DCL_Param_Dialog.wTel;

              await Srv_DbTools.setDCL_Ent(Srv_DbTools.gDCL_Ent);
            }
          }

          if (wParam == "Relance anniversaire") {
            DCL_Param_Dialog.ListParam.clear();
            for (int i = 0; i < Srv_DbTools.ListParam_Param_Rel_Anniv.length; i++) {
              Param_Param element = Srv_DbTools.ListParam_Param_Rel_Anniv[i];
              DCL_Param_Dialog.ListParam.add(element.Param_Param_Text);
            }
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

            DCL_Param_Dialog.wContact = Srv_DbTools.gDCL_Ent.DCL_Ent_RelanceContact!;
            DCL_Param_Dialog.wMail = Srv_DbTools.gDCL_Ent.DCL_Ent_RelanceMail!;
            DCL_Param_Dialog.wTel = Srv_DbTools.gDCL_Ent.DCL_Ent_RelanceTel!;
            await DCL_Param_Dialog.Dialogs_DCL_ParamRelance(context, wParam, DCL_Param_Dialog.wContact, DCL_Param_Dialog.wMail, DCL_Param_Dialog.wTel);

            if (DCL_Param_Dialog.wSel != "") {
              Srv_DbTools.gDCL_Ent.DCL_Ent_RelAnniv = DCL_Param_Dialog.wSel;

              Srv_DbTools.gDCL_Ent.DCL_Ent_RelanceContact = DCL_Param_Dialog.wContact;
              Srv_DbTools.gDCL_Ent.DCL_Ent_RelanceMail = DCL_Param_Dialog.wMail;
              Srv_DbTools.gDCL_Ent.DCL_Ent_RelanceTel = DCL_Param_Dialog.wTel;

              await Srv_DbTools.setDCL_Ent(Srv_DbTools.gDCL_Ent);
            }
          }

          await initLib();
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
    double icoWidth = 32;
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        color: BckGrd,
        child: Column(
          children: [
            Row(
              children: <Widget>[
                ImgL.isEmpty
                    ? Container()
                    : ImgL.contains(".svg")
                        ? Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: SvgPicture.asset(
                              "assets/images/$ImgL",
                              height: icoWidth,
                              width: icoWidth,
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: Image.asset(
                              "assets/images/$ImgL.png",
                              height: icoWidth,
                              width: icoWidth,
                            ),
                          ),
                Container(
                    padding: EdgeInsets.only(left: 10, top: mTop),
                    height: wHeight,
                    child: Text(
                      wTextL,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: gColors.bodyTitle1_B_Gr,
                    )),
                Expanded(
                    child: Container(
                        padding: EdgeInsets.only(right: 10, top: mTop),
                        height: wHeight,
                        child: Text(
                          wTextR,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          style: gColors.bodyTitle1_B_Gr.copyWith(color: ForeGrd),
                        ))),
              ],
            ),
            if (bLigne) gColors.wLigne(),
          ],
        ));
  }
}
