import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles_Ebp.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles_Fam_Ebp.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Art.dart';
import 'package:verifplus/Widget/GestCo/DCL_Article_Det.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

//**********************************
//**********************************
//**********************************

class DCL_Articles extends StatefulWidget {
  final VoidCallback onSaisie;
  final String art_Type;
  final bool isDevis;

  const DCL_Articles({
    Key? key,
    required this.onSaisie,
    required this.art_Type,
    required this.isDevis,
  }) : super(key: key);

  @override
  DCL_ArticlesState createState() => DCL_ArticlesState();
}

class DCL_ArticlesState extends State<DCL_Articles> {
  Widget wIco = Container();

  List<Widget> views = <Widget>[
    Text('Pièces Détachées'),
    Text('Catalogue Articles'),
  ];

  final List<bool> _selectedView = <bool>[true, false, false];
  final Search_TextController = TextEditingController();

  String FiltreGrp = "Tous";
  static List<String> ListParam_FiltreGrp = [];

  static List<String> ListParam_FiltreFam = [];
  static List<String> ListParam_FiltreFamID = [];
  String FiltreFam = "Tous";
  String FiltreFamID = "";

  static List<String> ListParam_FiltreSousFam = [];
  static List<String> ListParam_FiltreSousFamID = [];
  String FiltreSousFam = "Tous";
  String FiltreSousFamID = "";

  double wDialogHeight = 0;
  double wDialogWidth = 0;
  double wLabel = 0;
  double wDropdown = 0;

  bool affEdtFilter = false;
  double icoWidth = 40;
  TextEditingController ctrlFilter = new TextEditingController();
  String filterText = '';
  static List<Parc_Art> searchParcs_Art = [];

  int wBtn = 0;
  bool wBtnFam = false;
  bool wBtnSearch = false;

  bool btnSel_Aff = true;

  var formatter = NumberFormat('#,##,###.00');



  Future Reload() async {
    ListParam_FiltreSousFam.clear();
    ListParam_FiltreSousFamID.clear();
    ListParam_FiltreSousFam.add("Tous");
    ListParam_FiltreSousFamID.add("");

    Srv_DbTools.ListArticle_Fam_Ebp_Fam.clear();
    for (int i = 0; i < Srv_DbTools.ListArticle_Fam_Ebp.length; i++) {
      Article_Fam_Ebp wArticle_Fam_Ebp = Srv_DbTools.ListArticle_Fam_Ebp[i];
      if (wArticle_Fam_Ebp.Article_Fam_Code_Parent.compareTo(FiltreFamID) == 0) {
        ListParam_FiltreSousFam.add(wArticle_Fam_Ebp.Article_Fam_Libelle);
        ListParam_FiltreSousFamID.add(wArticle_Fam_Ebp.Article_Fam_Code);
      }
    }
    FiltreSousFam = ListParam_FiltreSousFam[0];
    FiltreSousFamID = ListParam_FiltreSousFamID[0];

    ListParam_FiltreGrp.clear();
    ListParam_FiltreFam.clear();
    ListParam_FiltreSousFam.clear();

    ListParam_FiltreGrp.add("Tous");
    FiltreGrp = "Tous";
    List<String> wListParam_FiltreGrp = [];
    for (int i = 0; i < Srv_DbTools.list_Article_GrpFamSsFam_Ebp.length; i++) {
      Article_GrpFamSsFam_Ebp wArticle_GrpFamSsFam_Ebp = Srv_DbTools.list_Article_GrpFamSsFam_Ebp[i];
      if (!wListParam_FiltreGrp.contains(wArticle_GrpFamSsFam_Ebp.Article_GrpFamSsFam_Groupe)) wListParam_FiltreGrp.add(wArticle_GrpFamSsFam_Ebp.Article_GrpFamSsFam_Groupe);
    }
    wListParam_FiltreGrp.sort();
    ListParam_FiltreGrp.addAll(wListParam_FiltreGrp);
    await Filtre();
  }

  Future Filtre() async {
    Srv_DbTools.ListArticle_Ebp.forEach((element) {
      element.Art_Sel = false;
    });

    List<Article_Ebp> ListArtsearchresultTmp = [];
    List<Article_Ebp> ListArtsearchresultTmpF = [];

    ListArtsearchresultTmp.clear();

    Srv_DbTools.ListArticle_Ebpsearchresult.clear();

    if (filterText.isEmpty) {
      ListArtsearchresultTmp.addAll(Srv_DbTools.ListArticle_Ebp);
    } else {
      print("_buildFieldTextSearch liste ${filterText}");
      for (int i = 0; i < Srv_DbTools.ListArticle_Ebp.length; i++) {
        Article_Ebp wArticle_Ebp = Srv_DbTools.ListArticle_Ebp[i];
        if (wArticle_Ebp.DescRech().toLowerCase().contains(filterText.toLowerCase())) {
          ListArtsearchresultTmp.add(wArticle_Ebp);
        }
      }
    }

    if (FiltreGrp == "Tous" && FiltreFam == "Tous" && FiltreSousFam == "Tous") {
      Srv_DbTools.ListArticle_Ebpsearchresult.addAll(ListArtsearchresultTmp);
      print("RECH et TOUS VIDES ${Srv_DbTools.ListArticle_Ebpsearchresult.length}");

      ListParam_FiltreFam.clear();
      ListParam_FiltreFam.add("Tous");
      FiltreFam = "Tous";
      for (int i = 0; i < Srv_DbTools.list_Article_GrpFamSsFam_Ebp.length; i++) {
        Article_GrpFamSsFam_Ebp wArticle_GrpFamSsFam_Ebp = Srv_DbTools.list_Article_GrpFamSsFam_Ebp[i];
        if (!ListParam_FiltreFam.contains(wArticle_GrpFamSsFam_Ebp.Article_GrpFamSsFam_Fam)) ListParam_FiltreFam.add(wArticle_GrpFamSsFam_Ebp.Article_GrpFamSsFam_Fam);
      }
      print(" ListParam_FiltreFam ${ListParam_FiltreFam.length}");

      ListParam_FiltreSousFam.clear();
      ListParam_FiltreSousFam.add("Tous");
      FiltreSousFam = "Tous";
      for (int i = 0; i < Srv_DbTools.list_Article_GrpFamSsFam_Ebp.length; i++) {
        Article_GrpFamSsFam_Ebp wArticle_GrpFamSsFam_Ebp = Srv_DbTools.list_Article_GrpFamSsFam_Ebp[i];
        if (!ListParam_FiltreSousFam.contains(wArticle_GrpFamSsFam_Ebp.Article_GrpFamSsFam_Sous_Fam)) ListParam_FiltreSousFam.add(wArticle_GrpFamSsFam_Ebp.Article_GrpFamSsFam_Sous_Fam);
      }
      print(" ListParam_FiltreSousFam ${ListParam_FiltreSousFam.length}");

      setState(() {});
      return;
    }

    ListArtsearchresultTmp.forEach((element) {
      bool TestGrp = (FiltreGrp == "Tous") || (FiltreGrp == element.Article_Groupe);
      bool TestFam = (FiltreFam == "Tous") || (FiltreFam == element.Article_Fam);
      bool TestSousFam = (FiltreSousFam == "Tous") || (FiltreSousFam == element.Article_Sous_Fam);
      if (TestGrp && TestFam && TestSousFam) Srv_DbTools.ListArticle_Ebpsearchresult.add(element);
    });

    print("Filtre ListArticle_Ebpsearchresult ${Srv_DbTools.ListArticle_Ebpsearchresult.length}");

//    await GetImage();

    setState(() {});
  }

  @override
  void initLib() async {
    Srv_DbTools.ListArticle_Ebp.forEach((element) {
      element.Art_Sel = false;
    });

    ListParam_FiltreFam.clear();
    ListParam_FiltreFamID.clear();
    ListParam_FiltreFam.add("Tous");
    ListParam_FiltreFamID.add("");

    Srv_DbTools.ListArticle_Fam_Ebp_Fam.clear();
    for (int i = 0; i < Srv_DbTools.ListArticle_Fam_Ebp.length; i++) {
      Article_Fam_Ebp wArticle_Fam_Ebp = Srv_DbTools.ListArticle_Fam_Ebp[i];
      if (wArticle_Fam_Ebp.Article_Fam_Code_Parent.isEmpty) {
        ListParam_FiltreFam.add("${wArticle_Fam_Ebp.Article_Fam_Libelle}");
        ListParam_FiltreFamID.add(wArticle_Fam_Ebp.Article_Fam_Code);
      }
    }
    FiltreFam = ListParam_FiltreFam[0];
    FiltreFamID = ListParam_FiltreFamID[0];

    await Reload();
  }

  @override
  void initState() {
    _selectedView.clear();
    for (int i = 0; i < views.length; i++) {
      _selectedView.add(i == 0);
    }

    initLib();
    super.initState();
  }

  void onSaisie() async {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  double wWidthDialog = 950;
  double wHeightDet2 = 747;

  @override
  Widget build(BuildContext context) {
    double heightPos = 70;

    double wHeightTitre = 70;
//    double wHeightPied = 125;
    double wHeightPied = 105;

    double wLeft = 0; //Magic Number

    double wHeightBtnValider = 50;

    double wBtnHeight = 60;

    double wHeight = wHeightTitre + wHeightDet2 + wHeightPied;

    wDialogHeight = MediaQuery.of(context).size.height;
    wDialogWidth = MediaQuery.of(context).size.width;

    List<Article_Ebp> ListArticle_Ebpsearchresult = Srv_DbTools.ListArticle_Ebpsearchresult.where((element) => element.Art_Sel == true).toList();

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
                      width: wWidthDialog,
                      height: wHeightTitre,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      decoration: BoxDecoration(
                        color: gColors.LinearGradient2,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: wWidthDialog,
                            child: Text(
                              "Catalogue rapide",
                              style: gColors.bodyTitle1_B_G_20,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            height: 10,
                          ),
                        ],
                      ),
                    ),

                    Container(
                      height: wHeightDet2 - 30,
                    ),

// Pied
                    Container(
                        child: Container(
                      width: wWidthDialog,
                      height: wHeightPied,
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      decoration: BoxDecoration(
                        color: gColors.LinearGradient2,
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
                                    backgroundColor: ListArticle_Ebpsearchresult.length > 0 ? gColors.blueCyan : gColors.LinearGradient4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    )),
                                child: Container(
                                  width: 110,
                                  height: wHeightBtnValider,
                                  padding: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                                  child: Text(
                                    "Ouvrir",
                                    style: gColors.bodyTitle1_B_W24,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                onPressed: () async {
                                  if (ListArticle_Ebpsearchresult.length > 0) {
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) => DCL_Article_Det(
                                        wTitre: "Listing",
                                      ),
                                    );
                                  }
                                },
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
                                    "Ajouter",
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

            // Content
            Positioned(
                top: wHeightTitre - 15,
                left: wLeft,
                child: Container(
                  color: Colors.white,
                  height: wHeightDet2,
                  width: wWidthDialog,
                  child: Container(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Entete_Btn_Search(),
                          Container(
                            height: 0,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.9),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 3,
                          ),
                          buildDesc(context),

//Spacer(),
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ],
    );
  }

  //**********************************
  //**********************************
  //**********************************

  Widget Valider(BuildContext context) {
    return Container(
      width: 540,
//      color: Colors.red,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            color: gColors.primary,
            width: 8,
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () async {
              Srv_DbTools.gArticle_EbpSelRef = Article_Ebp.Article_EbpInit();
              await HapticFeedback.vibrate();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: gColors.primaryRed,
            ),
            child: Text('Annuler', style: gColors.bodyTitle1_N_W),
          ),
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

  Widget DropdownFiltreGrp() {
    return Container(
        child: Row(children: [
      Container(
        width: 140,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Groupe',
              style: gColors.bodyTitle1_B_W,
            ),
          ],
        ),
      ),
      if (ListParam_FiltreGrp.length > 0)
        Container(
          width: 308,
          child: DropdownButtonHideUnderline(
              child: DropdownButton2(
            hint: Text(
              '  Séléctionner un groupe',
              style: gColors.bodyTitle1_N_Gr,
            ),
            items: ListParam_FiltreGrp.map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Container(
                    width: 284,
                    child: Text(
                      "  ${item}",
                      maxLines: 1,
                      style: gColors.bodyTitle1_N_Gr,
                    ),
                  ),
                )).toList(),
            value: FiltreGrp,
            onChanged: (value) {
              setState(() {
                String sValue = value as String;
                if (FiltreGrp != sValue) {
                  FiltreGrp = sValue as String;
                  print(">>>>>>>>>>>>>>>>> FiltreGrp ${FiltreGrp}");

                  if (FiltreGrp == "Tous") {
                    ListParam_FiltreFam.clear();
                    ListParam_FiltreFam.add("Tous");
                    FiltreFam = "Tous";
                    for (int i = 0; i < Srv_DbTools.list_Article_GrpFamSsFam_Ebp.length; i++) {
                      Article_GrpFamSsFam_Ebp wArticle_GrpFamSsFam_Ebp = Srv_DbTools.list_Article_GrpFamSsFam_Ebp[i];
                      if (!ListParam_FiltreFam.contains(wArticle_GrpFamSsFam_Ebp.Article_GrpFamSsFam_Fam)) ListParam_FiltreFam.add(wArticle_GrpFamSsFam_Ebp.Article_GrpFamSsFam_Fam);
                    }
                    ListParam_FiltreSousFam.clear();
                    ListParam_FiltreSousFam.add("Tous");
                    FiltreSousFam = "Tous";
                    for (int i = 0; i < Srv_DbTools.list_Article_GrpFamSsFam_Ebp.length; i++) {
                      Article_GrpFamSsFam_Ebp wArticle_GrpFamSsFam_Ebp = Srv_DbTools.list_Article_GrpFamSsFam_Ebp[i];
                      if (!ListParam_FiltreSousFam.contains(wArticle_GrpFamSsFam_Ebp.Article_GrpFamSsFam_Sous_Fam)) ListParam_FiltreSousFam.add(wArticle_GrpFamSsFam_Ebp.Article_GrpFamSsFam_Sous_Fam);
                    }
                  } else {
                    ListParam_FiltreFam.clear();
                    ListParam_FiltreFam.add("Tous");
                    FiltreFam = "Tous";

                    ListParam_FiltreSousFam.clear();
                    ListParam_FiltreSousFam.add("Tous");
                    FiltreSousFam = "Tous";
                    for (int i = 0; i < Srv_DbTools.list_Article_GrpFamSsFam_Ebp.length; i++) {
                      Article_GrpFamSsFam_Ebp wArticle_GrpFamSsFam_EbpGrp = Srv_DbTools.list_Article_GrpFamSsFam_Ebp[i];

                      if (wArticle_GrpFamSsFam_EbpGrp.Article_GrpFamSsFam_Groupe == FiltreGrp) {
                        if (!ListParam_FiltreFam.contains(wArticle_GrpFamSsFam_EbpGrp.Article_GrpFamSsFam_Fam)) {
                          ListParam_FiltreFam.add(wArticle_GrpFamSsFam_EbpGrp.Article_GrpFamSsFam_Fam);

                          for (int i = 0; i < Srv_DbTools.list_Article_GrpFamSsFam_Ebp.length; i++) {
                            Article_GrpFamSsFam_Ebp wArticle_GrpFamSsFam_EbpFam = Srv_DbTools.list_Article_GrpFamSsFam_Ebp[i];
                            if (wArticle_GrpFamSsFam_EbpFam.Article_GrpFamSsFam_Fam == wArticle_GrpFamSsFam_EbpGrp.Article_GrpFamSsFam_Fam) {
                              if (!ListParam_FiltreSousFam.contains(wArticle_GrpFamSsFam_EbpFam.Article_GrpFamSsFam_Sous_Fam)) ListParam_FiltreSousFam.add(wArticle_GrpFamSsFam_EbpFam.Article_GrpFamSsFam_Sous_Fam);
                            }
                          }
                        }
                      }
                    }

                    Filtre();
                  }
                }
              });
            },
            buttonStyleData: ButtonStyleData(
              height: 44,
              width: wDropdown,
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 32,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 750,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.black,
                ),
                color: Colors.white,
              ),
            ),
          )),
        ),
      if (ListParam_FiltreGrp.length > 0)
        InkWell(
          onTap: () async {
            FiltreGrp = "Tous";
            ListParam_FiltreFam.clear();
            ListParam_FiltreFam.add("Tous");
            FiltreFam = "Tous";
            for (int i = 0; i < Srv_DbTools.list_Article_GrpFamSsFam_Ebp.length; i++) {
              Article_GrpFamSsFam_Ebp wArticle_GrpFamSsFam_Ebp = Srv_DbTools.list_Article_GrpFamSsFam_Ebp[i];
              if (!ListParam_FiltreFam.contains(wArticle_GrpFamSsFam_Ebp.Article_GrpFamSsFam_Fam)) ListParam_FiltreFam.add(wArticle_GrpFamSsFam_Ebp.Article_GrpFamSsFam_Fam);
            }
            ListParam_FiltreSousFam.clear();
            ListParam_FiltreSousFam.add("Tous");
            FiltreSousFam = "Tous";
            for (int i = 0; i < Srv_DbTools.list_Article_GrpFamSsFam_Ebp.length; i++) {
              Article_GrpFamSsFam_Ebp wArticle_GrpFamSsFam_Ebp = Srv_DbTools.list_Article_GrpFamSsFam_Ebp[i];
              if (!ListParam_FiltreSousFam.contains(wArticle_GrpFamSsFam_Ebp.Article_GrpFamSsFam_Sous_Fam)) ListParam_FiltreSousFam.add(wArticle_GrpFamSsFam_Ebp.Article_GrpFamSsFam_Sous_Fam);
            }
            setState(() {});
          },
          child: Image.asset(
            "assets/images/Btn_Clear.png",
            height: icoWidth,
            width: icoWidth,
            color: gColors.greyDark2,
          ),
        ),
    ]));
  }

  Widget DropdownFiltreFam() {
    return Container(
        child: Row(children: [
      Container(
        width: 140,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Famille',
              style: gColors.bodyTitle1_B_W,
            ),
          ],
        ),
      ),
      if (ListParam_FiltreFam.length > 0)
        Container(
          width: 308,
          child: DropdownButtonHideUnderline(
              child: DropdownButton2(
            hint: Text(
              '  Séléctionner une Famille',
              style: gColors.bodyTitle1_N_Gr,
            ),
            items: ListParam_FiltreFam.map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Container(
                    width: 284,
                    child: Text(
                      "  ${item}",
                      maxLines: 1,
                      style: gColors.bodyTitle1_N_Gr,
                    ),
                  ),
                )).toList(),
            value: FiltreFam,
            onChanged: (value) {
              setState(() {
                String sValue = value as String;

                if (FiltreFam != value) {
                  FiltreFam = value as String;

                  ListParam_FiltreSousFam.clear();
                  ListParam_FiltreSousFam.add("Tous");
                  FiltreSousFam = "Tous";
                  for (int i = 0; i < Srv_DbTools.list_Article_GrpFamSsFam_Ebp.length; i++) {
                    Article_GrpFamSsFam_Ebp wArticle_GrpFamSsFam_Ebp = Srv_DbTools.list_Article_GrpFamSsFam_Ebp[i];
                    if (wArticle_GrpFamSsFam_Ebp.Article_GrpFamSsFam_Fam == FiltreFam) {
                      if (!ListParam_FiltreSousFam.contains(wArticle_GrpFamSsFam_Ebp.Article_GrpFamSsFam_Sous_Fam)) ListParam_FiltreSousFam.add(wArticle_GrpFamSsFam_Ebp.Article_GrpFamSsFam_Sous_Fam);
                    }
                  }
                }
                Filtre();
              });
            },
            buttonStyleData: ButtonStyleData(
              height: 44,
              width: wDropdown,
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 32,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 750,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.black,
                ),
                color: Colors.white,
              ),
            ),
          )),
        ),
      if (ListParam_FiltreFam.length > 0)
        InkWell(
          onTap: () async {
            ListParam_FiltreFam.clear();
            ListParam_FiltreFam.add("Tous");
            FiltreFam = "Tous";
            for (int i = 0; i < Srv_DbTools.list_Article_GrpFamSsFam_Ebp.length; i++) {
              Article_GrpFamSsFam_Ebp wArticle_GrpFamSsFam_Ebp = Srv_DbTools.list_Article_GrpFamSsFam_Ebp[i];
              if (!ListParam_FiltreFam.contains(wArticle_GrpFamSsFam_Ebp.Article_GrpFamSsFam_Fam)) ListParam_FiltreFam.add(wArticle_GrpFamSsFam_Ebp.Article_GrpFamSsFam_Fam);
            }
            ListParam_FiltreSousFam.clear();
            ListParam_FiltreSousFam.add("Tous");
            FiltreSousFam = "Tous";
            for (int i = 0; i < Srv_DbTools.list_Article_GrpFamSsFam_Ebp.length; i++) {
              Article_GrpFamSsFam_Ebp wArticle_GrpFamSsFam_Ebp = Srv_DbTools.list_Article_GrpFamSsFam_Ebp[i];
              if (!ListParam_FiltreSousFam.contains(wArticle_GrpFamSsFam_Ebp.Article_GrpFamSsFam_Sous_Fam)) ListParam_FiltreSousFam.add(wArticle_GrpFamSsFam_Ebp.Article_GrpFamSsFam_Sous_Fam);
            }
            setState(() {});
          },
          child: Image.asset(
            "assets/images/Btn_Clear.png",
            height: icoWidth,
            width: icoWidth,
            color: gColors.greyDark2,
          ),
        ),
    ]));
  }

  Widget DropdownFiltreSousFam() {
    return Container(
        child: Row(children: [
      Container(
        width: 140,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sous-famille',
              style: gColors.bodyTitle1_B_W,
            ),
          ],
        ),
      ),
      if (ListParam_FiltreSousFam.length > 0)
        Container(
          width: 308,
          child: DropdownButtonHideUnderline(
              child: DropdownButton2(
            hint: Text(
              '  Séléctionner une SousFamille',
              style: gColors.bodyTitle1_N_Gr,
            ),
            items: ListParam_FiltreSousFam.map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Container(
                    width: 284,
                    child: Text(
                      "  ${item}",
                      maxLines: 1,
                      style: gColors.bodyTitle1_N_Gr,
                    ),
                  ),
                )).toList(),
            value: FiltreSousFam,
            onChanged: (value) {
              String sValue = value as String;
              FiltreSousFam = sValue as String;
              Filtre();
            },
            buttonStyleData: ButtonStyleData(
              height: 44,
              width: wDropdown,
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 32,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 750,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.black,
                ),
                color: Colors.white,
              ),
            ),
          )),
        ),
      if (ListParam_FiltreFam.length > 0)
        InkWell(
          onTap: () async {
            ListParam_FiltreSousFam.clear();
            ListParam_FiltreSousFam.add("Tous");
            FiltreSousFam = "Tous";
            for (int i = 0; i < Srv_DbTools.list_Article_GrpFamSsFam_Ebp.length; i++) {
              Article_GrpFamSsFam_Ebp wArticle_GrpFamSsFam_Ebp = Srv_DbTools.list_Article_GrpFamSsFam_Ebp[i];
              if (!ListParam_FiltreSousFam.contains(wArticle_GrpFamSsFam_Ebp.Article_GrpFamSsFam_Sous_Fam)) ListParam_FiltreSousFam.add(wArticle_GrpFamSsFam_Ebp.Article_GrpFamSsFam_Sous_Fam);
            }
            setState(() {});
          },
          child: Image.asset(
            "assets/images/Btn_Clear.png",
            height: icoWidth,
            width: icoWidth,
            color: gColors.greyDark2,
          ),
        ),
    ]));
  }

  //********************************************************************
  //********************************************************************
  //********************************************************************

  @override
  Widget buildDesc(BuildContext context) {
    double LargeurCol = 300;
    double LargeurCol2 = 540 - LargeurCol;

    double H = 4;
    double H2 = 4;

    int wCount = 0;
    bool bSup50 = false;
    List<Article_Ebp> ListArticle_Ebpsearchresult = [];
    for (int i = 0; i < Srv_DbTools.ListArticle_Ebpsearchresult.length; i++) {
      Article_Ebp wArticle_Ebp = Srv_DbTools.ListArticle_Ebpsearchresult[i];
      if (wBtn == 0) {
        if (wCount++ > 50) {
          bSup50 = true;
          break;
        }
      }

      if (wBtn == 1 && wArticle_Ebp.Article_New) {
        if (wCount++ > 50) {
          bSup50 = true;
          break;
        }
      }
    }

    double wHeigth = wHeightDet2 - 75;
    if (wBtnFam)
      wHeigth = wHeigth - 250;
    else if (wBtnSearch) wHeigth = wHeigth - 100;

    return Container(
      padding: EdgeInsets.fromLTRB(0, btnSel_Aff ? 00 : 0, 0, 0),
      height: wHeigth,
      color: gColors.LinearGradient2,
      width: 560,
      child: Container(
        color: gColors.greyDark,
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          color: gColors.LinearGradient2,
          child: Scrollbar(
              child: ListView.separated(
            padding: const EdgeInsets.all(0.0),
            shrinkWrap: true,
            itemCount: bSup50 ? 52 : Srv_DbTools.ListArticle_Ebpsearchresult.length,
            itemBuilder: (context, index) {
              Article_Ebp element = Srv_DbTools.ListArticle_Ebpsearchresult[index];
              Widget wRowSaisie = Container();

              if (bSup50 && index == 51) {
                wRowSaisie = Container(
                  width: 100,
                  height: 40,
                  child: Text(
                    "    Lignes > 50 ...",
                    style: gColors.bodyTitle1_B_G24,
                  ),
                );
              } else {
                if (btnSel_Aff) {
                  if (wBtn == 0) wRowSaisie = RowSaisieBig(element, LargeurCol, LargeurCol2, H2);
                  if (wBtn == 1 && element.Article_New) wRowSaisie = RowSaisieBig(element, LargeurCol, LargeurCol2, H2);
                } else {
                  if (wBtn == 0) wRowSaisie = RowSaisie(element, LargeurCol, LargeurCol2, H2);
                  if (wBtn == 1 && element.Article_New) wRowSaisie = RowSaisie(element, LargeurCol, LargeurCol2, H2);
                }
              }

              return wRowSaisie;
            },
            separatorBuilder: (BuildContext context, int index) => Container(height: btnSel_Aff ? 0 : 1, width: double.infinity, color: gColors.greyDark),
          )),
        ),
      ),
    );
  }

  double IcoWidth = 40;

  Future<Image> GetImage(Article_Ebp art, double wIcoWidth) async {
    if (art.wImgeTrv) return art.wImage!;

    print("  row ${art.Article_codeArticle}");

    String wImgPath = "${Srv_DbTools.SrvImg}ArticlesImg_Ebp_${art.Article_codeArticle}.jpg";
    gObj.pic = await gObj.networkImageToByte(wImgPath);
    if (gObj.pic.length > 0) {
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
    ;
    return art.wImage!;
  }

  Widget buildImage(BuildContext context, Article_Ebp art) {
    return new FutureBuilder(
      future: GetImage(art, 80),
      builder: (BuildContext context, AsyncSnapshot<Image> image) {
        if (image.hasData) {
          return image.data!;
        } else {
          return new Container(width: 30);
        }
      },
    );
  }

  Widget buildImageBig(BuildContext context, Article_Ebp art) {
    return new FutureBuilder(
      future: GetImage(art, 100),
      builder: (BuildContext context, AsyncSnapshot<Image> image) {
        if (image.hasData) {
          return image.data!;
        } else {
          return new Container(width: 100);
        }
      },
    );
  }

  Widget RowSaisie(Article_Ebp art, double LargeurCol, double LargeurCol2, double H2) {
    return Container(
      color: Colors.white,
      height: 45,
      child: Row(
        children: [
          Container(
            width: 10,
          ),
          buildImage(context, art),
          Container(
            width: 10,
          ),
          Container(
            width: 100,
            height: 20,
            padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
            child: Text(
              "${art.Article_codeArticle}",
              style: gColors.bodyTitle1_N_Gr,
            ),
          ),
          Expanded(
            child: Container(
              height: 20,
              padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
              child: Text(
                "${art.Article_descriptionCommercialeEnClair}",
                style: gColors.bodyTitle1_N_Gr,
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              await HapticFeedback.vibrate();
              print("onTap ${art.Desc()}");
              if (widget.art_Type.contains("ES") || widget.art_Type.contains("G")) {
                print("onTap E or G");
                if (!art.Art_Sel) {
                  print("onTap E ${art.Art_Sel}");
                  for (int i = 0; i < Srv_DbTools.ListArticle_Ebpsearchresult.length; i++) {
                    Article_Ebp element = Srv_DbTools.ListArticle_Ebpsearchresult[i];
                    element.Art_Sel = false;
                  }
                }
              }

              art.Art_Sel = !art.Art_Sel;

              setState(() {});
            },
            child: Image.asset(
              art.Art_Sel ? "assets/images/Plus_Sel.png" : "assets/images/Plus_No_Sel.png",
              height: IcoWidth,
              width: IcoWidth,
            ),
          ),
          Container(
            width: 10,
          ),
        ],
      ),
    );
  }

  Widget RowSaisieBig(Article_Ebp art, double LargeurCol, double LargeurCol2, double H2) {
    return Container(
      color: gColors.LinearGradient2,
      height: 115,
      child: Column(
        children: [
          Container(
            height: 100,
            color: gColors.white,
            padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                ),
                buildImageBig(context, art),
                Container(
                  width: 10,
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
                      padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
                      child: Text(
                        "${art.Article_descriptionCommercialeEnClair}",
                        style: gColors.bodyTitle1_B_Gr,
                        maxLines: 2,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 20,
                          padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
                          child: Text(
                            "${art.Article_codeArticle}",
                            style: gColors.bodyTitle1_N_Gr,
                          ),
                        ),
                        Container(
                          height: 20,
                          padding: EdgeInsets.fromLTRB(0, 2, 18, 0),
                          child: Text(
                            "PV HT ${formatter.format(art.Article_PVHT).replaceAll(',', ' ')}€",
                            style: gColors.bodyTitle1_N_Gr,
                          ),
                        ),
                      ],
                    )
                  ],
                )),
                InkWell(
                  onTap: () async {
                    await HapticFeedback.vibrate();
                    print("onTap ${art.Desc()}");

                    art.Art_Sel = !art.Art_Sel;
                    setState(() {});
                  },
                  child: Image.asset(
                    art.Art_Sel ? "assets/images/Plus_Sel.png" : "assets/images/Plus_No_Sel.png",
                    height: IcoWidth,
                    width: IcoWidth,
                  ),
                ),
                Container(
                  width: 10,
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: gColors.LinearGradient4,
          ),
          Container(
            height: 0,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.9),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
          Container(
            height: 3,
          ),
        ],
      ),
    );
  }

  ///////
  ///////
  ///////

  @override
  Widget Entete_Btn_Search() {
    double wHeigth = 72;
    if (wBtnFam)
      wHeigth = 307;
    else if (wBtnSearch) wHeigth = 147;

    return Container(
        color: gColors.LinearGradient2,
        height: wHeigth,
        width: 560,
        padding: EdgeInsets.only(top: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: [
              InkWell(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 6, 0),
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
                    padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
                    child: SvgPicture.asset(
                      "assets/images/DCL_Rap.svg",
                      height: 40,
                      width: 40,
                      color: (wBtn == 0) ? null : gColors.LinearGradient4,
                    ),
                  ),
                  onTap: () async {
                    wBtn = 0;
                    setState(() {});
                  }),
              Container(
                width: 8,
              ),
              InkWell(
                  child: Container(
                    width: 90,
                    height: 36,
                    decoration: BoxDecoration(
                      color: (wBtn == 1 ? gColors.blueCyan : Colors.transparent),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        width: wBtn == 1 ? 0 : 1,
                        color: wBtn == 1 ? gColors.blueCyan : gColors.greyDark2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'New',
                          style: wBtn == 1 ? gColors.bodyTitle1_N_W24 : gColors.bodyTitle1_N_GD24,
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    wBtn = 1;
                    setState(() {});
                  }),
              Container(
                width: 8,
              ),
              InkWell(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                    child: SvgPicture.asset(
                      "assets/images/DCL_Fav.svg",
                      height: 40,
                      width: 40,
                      color: (wBtn == 2) ? null : gColors.LinearGradient4,
                    ),
                  ),
                  onTap: () async {
                    wBtn = 2;
                    setState(() {});
                  }),
              Container(
                width: 8,
              ),
              InkWell(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(12, 4, 12, 0),
                    child: SvgPicture.asset(
                      "assets/images/DCL_Filtre.svg",
                      height: 40,
                      width: 40,
                      color: (wBtnFam) ? null : gColors.LinearGradient4,
                    ),
                  ),
                  onTap: () async {
                    wBtnFam = !wBtnFam;
                    wBtnSearch = false;
                    setState(() {});
                  }),
              Container(
                width: 8,
              ),
              InkWell(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                    child: SvgPicture.asset(
                      "assets/images/DCL_Rech.svg",
                      height: 40,
                      width: 40,
                      color: (wBtnSearch) ? null : gColors.LinearGradient4,
                    ),
                  ),
                  onTap: () async {
                    wBtnSearch = !wBtnSearch;
                    wBtnFam = false;
                    setState(() {});
                  }),
            ]),
            if (wBtnFam)
              Container(
                width: 560,
                height: 255,
                child: Column(
                  children: [
                    Container(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                            onTap: () async {
                              FiltreGrp = "Tous";
                              ListParam_FiltreFam.clear();
                              ListParam_FiltreFam.add("Tous");
                              FiltreFam = "Tous";
                              for (int i = 0; i < Srv_DbTools.list_Article_GrpFamSsFam_Ebp.length; i++) {
                                Article_GrpFamSsFam_Ebp wArticle_GrpFamSsFam_Ebp = Srv_DbTools.list_Article_GrpFamSsFam_Ebp[i];
                                if (!ListParam_FiltreFam.contains(wArticle_GrpFamSsFam_Ebp.Article_GrpFamSsFam_Fam)) ListParam_FiltreFam.add(wArticle_GrpFamSsFam_Ebp.Article_GrpFamSsFam_Fam);
                              }
                              ListParam_FiltreSousFam.clear();
                              ListParam_FiltreSousFam.add("Tous");
                              FiltreSousFam = "Tous";
                              for (int i = 0; i < Srv_DbTools.list_Article_GrpFamSsFam_Ebp.length; i++) {
                                Article_GrpFamSsFam_Ebp wArticle_GrpFamSsFam_Ebp = Srv_DbTools.list_Article_GrpFamSsFam_Ebp[i];
                                if (!ListParam_FiltreSousFam.contains(wArticle_GrpFamSsFam_Ebp.Article_GrpFamSsFam_Sous_Fam)) ListParam_FiltreSousFam.add(wArticle_GrpFamSsFam_Ebp.Article_GrpFamSsFam_Sous_Fam);
                              }
                              Filtre();
                            },
                            child: Row(
                              children: [
                                Text(
                                  'Réinitialiser',
                                  style: gColors.bodySaisie_B_G.copyWith(color: gColors.primaryGreen),
                                ),
                                Image.asset(
                                  "assets/images/Btn_Clear.png",
                                  height: icoWidth,
                                  width: icoWidth,
                                  color: gColors.primaryGreen,
                                ),
                                Container(
                                  width: 41,
                                )
                              ],
                            )),
                      ],
                    ),
                    Container(
                      width: 560,
                      height: 45,
                      margin: EdgeInsets.fromLTRB(30, 10, 30, 0),
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          width: 1,
                          color: gColors.greyDark2,
                        ),
                      ),
                      child: DropdownFiltreGrp(),
                    ),
                    Container(
                      width: 560,
                      height: 45,
                      margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          width: 1,
                          color: gColors.greyDark2,
                        ),
                      ),
                      child: DropdownFiltreFam(),
                    ),
                    Container(
                      width: 560,
                      height: 45,
                      margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          width: 1,
                          color: gColors.greyDark2,
                        ),
                      ),
                      child: DropdownFiltreSousFam(),
                    ),
                  ],
                ),
              ),
            if (wBtnSearch)
              Container(
                width: 560,
                height: 45,
                margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
                padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 1,
                    color: gColors.greyDark2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: TextField(
                      style: gColors.bodyTitle1_N_Gr,
                      onChanged: (text) {
                        filterText = text;
                        Filtre();
                      },
                      controller: ctrlFilter,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Rechercher un article',
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
                            color: gColors.greyDark2,
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
          ],
        ));
  }

  Widget EdtFilterWidget() {
    return !affEdtFilter
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
            ));
  }
}
