import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:group_button/group_button.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Param.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/GestCo/DCL_Param.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';

class DCL_Ent_Param extends StatefulWidget {
  const DCL_Ent_Param({super.key});

  @override
  DCL_Ent_ParamState createState() => DCL_Ent_ParamState();
}

class DCL_Ent_ParamState extends State<DCL_Ent_Param> with SingleTickerProviderStateMixin {
  List<Widget> views = <Widget>[
    const Text('Paramètres'),
    const Text('Business'),
  ];

  final List<bool> _selectedView = <bool>[true, false];

  List<Widget> widgets = [];
  final pageController = PageController(keepPage: false, initialPage: DbTools.gCurrentIndex4);
  List<Widget> ListWidget = [];
  List<Widget> ListWidget2 = [];

  final groupButtonController = GroupButtonController();

  void Reload() async {

    bool wMAj = false;
    if (Srv_DbTools.gUserLogin.User_DCL_Ent_Validite.isEmpty) {
      Srv_DbTools.gUserLogin.User_DCL_Ent_Validite = Srv_DbTools.ListParam_Param_Validite_devis[0].Param_Param_Text;
      wMAj = true;
    }
    if (Srv_DbTools.gUserLogin.User_DCL_Ent_LivrPrev.isEmpty) {
      Srv_DbTools.gUserLogin.User_DCL_Ent_LivrPrev = Srv_DbTools.ListParam_Param_Livraison_prev[0].Param_Param_Text;
      wMAj = true;
    }
    if (Srv_DbTools.gUserLogin.User_DCL_Ent_ModeRegl.isEmpty) {
      Srv_DbTools.gUserLogin.User_DCL_Ent_ModeRegl = Srv_DbTools.ListParam_Param_Mode_rglt[0].Param_Param_Text;
      wMAj = true;
    }
    if (Srv_DbTools.gUserLogin.User_DCL_Ent_MoyRegl.isEmpty) {
      Srv_DbTools.gUserLogin.User_DCL_Ent_MoyRegl = Srv_DbTools.ListParam_Param_Moyen_paiement[0].Param_Param_Text;
      wMAj = true;
    }

    if (Srv_DbTools.gUserLogin.User_DCL_Ent_PrefAff.isEmpty) {
      Srv_DbTools.gUserLogin.User_DCL_Ent_PrefAff = Srv_DbTools.ListParam_Param_Pref_Aff[0].Param_Param_Text;
      wMAj = true;
    }
    if (Srv_DbTools.gUserLogin.User_DCL_Ent_RelAuto.isEmpty) {
      Srv_DbTools.gUserLogin.User_DCL_Ent_RelAuto = Srv_DbTools.ListParam_Param_Rel_Auto[0].Param_Param_Text;
      wMAj = true;
    }
    if (Srv_DbTools.gUserLogin.User_DCL_Ent_RelAnniv.isEmpty) {
      Srv_DbTools.gUserLogin.User_DCL_Ent_RelAnniv = Srv_DbTools.ListParam_Param_Rel_Anniv[0].Param_Param_Text;
      wMAj = true;
    }
    if (Srv_DbTools.gUserLogin.User_DCL_Ent_CopRel.isEmpty) {
      Srv_DbTools.gUserLogin.User_DCL_Ent_CopRel = "0";
      wMAj = true;
    }

    if (wMAj)   await Srv_DbTools.setUser_DCL(Srv_DbTools.gUserLogin);



    setState(() {});
  }

  @override
  Future initLib() async {
    ListWidget = [
      gColors.wLigne(),
      AffBtnParam("", "Validité du devis", Srv_DbTools.gUserLogin.User_DCL_Ent_Validite, "DCL_Date", gColors.white, gColors.primaryBlue, "Validité du Devis"),
      AffBtnParam("", "Livraison prévisionnelle", Srv_DbTools.gUserLogin.User_DCL_Ent_LivrPrev, "DCL_Date2", gColors.white, gColors.primaryBlue, "Livraison prévisionnelle"),
      AffBtnParam("", "Mode de règlement", Srv_DbTools.gUserLogin.User_DCL_Ent_ModeRegl, "DCL_ModeReglt.svg", gColors.white, gColors.primaryBlue, "Mode de règlement"),
      AffBtnParam("", "Moyen de paiement", Srv_DbTools.gUserLogin.User_DCL_Ent_MoyRegl, "DCL_MoyenPaiement.svg", gColors.white, gColors.primaryBlue, "Moyen de paiement"),
      AffBtnParamSwitch("", "Non-valorisé/Valorisé", Srv_DbTools.gUserLogin.User_DCL_Ent_Valo, "DCL_Valorise.svg", gColors.white, gColors.primaryBlue, "Non-valorisé/Valorisé"),
      AffBtnParam("", "Préférence d'affichage", Srv_DbTools.gUserLogin.User_DCL_Ent_PrefAff, "DCL_Aff", gColors.white, gColors.primaryBlue, "Préférence d'affichage"),
    ];

    ListWidget2 = [
      gColors.wLigne(),
      AffBtnParam("", "Relance client auto", Srv_DbTools.gUserLogin.User_DCL_Ent_RelAuto, "DCL_Relance.svg", gColors.white, gColors.primaryBlue, "Relance client auto"),
      AffBtnParam("", "Relance anniversaire", Srv_DbTools.gUserLogin.User_DCL_Ent_RelAnniv, "DCL_Aniv.svg", gColors.white, gColors.primaryBlue, "Relance anniversaire"),
      AffBtnParamSwitch("", "Me mettre en copie des relances", int.tryParse(Srv_DbTools.gUserLogin.User_DCL_Ent_CopRel) ?? 0, "DCL_CopieRel.svg", gColors.white, gColors.primaryBlue, "Me mettre en copie des relances"),
    ];
    widgets = [Parametres(), Business()];

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

    for (int p = 0; p < Srv_DbTools.ListParam_Param_Validite_devis.length; p++) {
      Param_Param wparamParam = Srv_DbTools.ListParam_Param_Validite_devis[p];
      print("ListParam_Param_Validite_devis ${wparamParam.Desc()}");
    }

    if (Srv_DbTools.gUserLogin.User_DCL_Ent_Validite.isEmpty) {
      Srv_DbTools.gUserLogin.User_DCL_Ent_Validite = Srv_DbTools.ListParam_Param_Validite_devis[0].Param_Param_Text;
    }

    initLib();
  }


  @override
  Widget build(BuildContext context) {
    double icoWidth = 40;
    double wHeight = 800;
    double wWidth = MediaQuery.of(context).size.width;

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
                        buttons: const ['Paramètres', 'Business'],
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
    double wHeight = 57;
    double mTop = 22;
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
                            padding: const EdgeInsets.only(left: 16),
                            child: SvgPicture.asset(
                              "assets/images/$ImgL",
                              height: icoWidth,
                              width: icoWidth,
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.only(left: 16),
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
                      style: gColors.bodySaisie_B_B,
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
                        if (wTextL == "Non-valorisé/Valorisé") Srv_DbTools.gUserLogin.User_DCL_Ent_Valo = value ? 1 : 0;
                        if (wTextL == "Me mettre en copie des relances") Srv_DbTools.gUserLogin.User_DCL_Ent_CopRel = value ? "1" : "0";
                        await Srv_DbTools.setUser_DCL(Srv_DbTools.gUserLogin);
                        await initLib();
                      });
                    },
                  ),
                ),
              ],
            ),
            gColors.wLigne(),
            gColors.ombre(),
            Container(
              height: 6,
              color: gColors.LinearGradient3,
            ),

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
            DCL_Param_Dialog.wSel = DCL_Param_Dialog.ListParam[0];
            print("DCL_Param_Dialog.wSel $DCL_Param_Dialog.wSel");

            print("wStatus ${Srv_DbTools.gUserLogin.User_DCL_Ent_Validite}");

            for (int i = 0; i < DCL_Param_Dialog.ListParam.length; i++) {
              String element = DCL_Param_Dialog.ListParam[i];
              if (element == Srv_DbTools.gUserLogin.User_DCL_Ent_Validite) {
                DCL_Param_Dialog.wSel = element;
                break;
              }
            }
            await DCL_Param_Dialog.Dialogs_DCL_Param(context, wParam);
            if (DCL_Param_Dialog.wSel != "") {
              Srv_DbTools.gUserLogin.User_DCL_Ent_Validite = DCL_Param_Dialog.wSel;
              await Srv_DbTools.setUser_DCL(Srv_DbTools.gUserLogin);
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

            DCL_Param_Dialog.wSel = DCL_Param_Dialog.ListParam[0];
            print("DCL_Param_Dialog.wSel $DCL_Param_Dialog.wSel");

            print("wStatus ${Srv_DbTools.gUserLogin.User_DCL_Ent_LivrPrev}");

            for (int i = 0; i < DCL_Param_Dialog.ListParam.length; i++) {
              String element = DCL_Param_Dialog.ListParam[i];
              if (element == Srv_DbTools.gUserLogin.User_DCL_Ent_LivrPrev) {
                DCL_Param_Dialog.wSel = element;
                break;
              }
            }
            await DCL_Param_Dialog.Dialogs_DCL_Param(context, wParam);
            if (DCL_Param_Dialog.wSel != "") {
              Srv_DbTools.gUserLogin.User_DCL_Ent_LivrPrev = DCL_Param_Dialog.wSel;
              await Srv_DbTools.setUser_DCL(Srv_DbTools.gUserLogin);
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

            print("wStatus ${Srv_DbTools.gUserLogin.User_DCL_Ent_ModeRegl}");

            for (int i = 0; i < DCL_Param_Dialog.ListParam.length; i++) {
              String element = DCL_Param_Dialog.ListParam[i];
              if (element == Srv_DbTools.gUserLogin.User_DCL_Ent_ModeRegl) {
                DCL_Param_Dialog.wSel = element;
                break;
              }
            }
            await DCL_Param_Dialog.Dialogs_DCL_Param(context, wParam);
            if (DCL_Param_Dialog.wSel != "") {
              Srv_DbTools.gUserLogin.User_DCL_Ent_ModeRegl = DCL_Param_Dialog.wSel;
              await Srv_DbTools.setUser_DCL(Srv_DbTools.gUserLogin);
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

            print("wStatus ${Srv_DbTools.gUserLogin.User_DCL_Ent_MoyRegl}");

            for (int i = 0; i < DCL_Param_Dialog.ListParam.length; i++) {
              String element = DCL_Param_Dialog.ListParam[i];
              if (element == Srv_DbTools.gUserLogin.User_DCL_Ent_MoyRegl) {
                DCL_Param_Dialog.wSel = element;
                break;
              }
            }
            await DCL_Param_Dialog.Dialogs_DCL_Param(context, wParam);
            if (DCL_Param_Dialog.wSel != "") {
              Srv_DbTools.gUserLogin.User_DCL_Ent_MoyRegl = DCL_Param_Dialog.wSel;
              await Srv_DbTools.setUser_DCL(Srv_DbTools.gUserLogin);
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

            print("wStatus ${Srv_DbTools.gUserLogin.User_DCL_Ent_PrefAff}");

            for (int i = 0; i < DCL_Param_Dialog.ListParam.length; i++) {
              String element = DCL_Param_Dialog.ListParam[i];
              if (element == Srv_DbTools.gUserLogin.User_DCL_Ent_PrefAff) {
                DCL_Param_Dialog.wSel = element;
                break;
              }
            }
            await DCL_Param_Dialog.Dialogs_DCL_Param(context, wParam);
            if (DCL_Param_Dialog.wSel != "") {
              Srv_DbTools.gUserLogin.User_DCL_Ent_PrefAff = DCL_Param_Dialog.wSel;
              await Srv_DbTools.setUser_DCL(Srv_DbTools.gUserLogin);
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

            print("wStatus ${Srv_DbTools.gUserLogin.User_DCL_Ent_RelAuto}");
            for (int i = 0; i < DCL_Param_Dialog.ListParam.length; i++) {
              String element = DCL_Param_Dialog.ListParam[i];
              if (element == Srv_DbTools.gUserLogin.User_DCL_Ent_RelAuto) {
                DCL_Param_Dialog.wSel = element;
                break;
              }
            }

            await DCL_Param_Dialog.Dialogs_DCL_Param(context, wParam);
            if (DCL_Param_Dialog.wSel != "") {
              Srv_DbTools.gUserLogin.User_DCL_Ent_RelAuto = DCL_Param_Dialog.wSel;
              await Srv_DbTools.setUser_DCL(Srv_DbTools.gUserLogin);
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

            print("wStatus ${Srv_DbTools.gUserLogin.User_DCL_Ent_RelAnniv}");
            for (int i = 0; i < DCL_Param_Dialog.ListParam.length; i++) {
              String element = DCL_Param_Dialog.ListParam[i];
              if (element == Srv_DbTools.gUserLogin.User_DCL_Ent_RelAnniv) {
                DCL_Param_Dialog.wSel = element;
                break;
              }
            }

            await DCL_Param_Dialog.Dialogs_DCL_Param(context, wParam);
            if (DCL_Param_Dialog.wSel != "") {
              Srv_DbTools.gUserLogin.User_DCL_Ent_RelAnniv = DCL_Param_Dialog.wSel;
              await Srv_DbTools.setUser_DCL(Srv_DbTools.gUserLogin);
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
                            padding: const EdgeInsets.only(left: 16),
                            child: SvgPicture.asset(
                              "assets/images/$ImgL",
                              height: icoWidth,
                              width: icoWidth,
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.only(left: 16),
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
                        padding: EdgeInsets.only(right: 16, top: mTop),
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
            gColors.wLigne(),
            gColors.ombre(),
            Container(
              height: 6,
              color: gColors.LinearGradient3,
            ),
          ],
        ));
  }
}
