import 'dart:async';
import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:verifplus/Tools/DbSrv/Srv_Articles_Ebp.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles_Fam_Ebp.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DCL_Det.dart';
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
    const Text('Pièces Détachées'),
    const Text('Catalogue Articles'),
  ];

  final List<bool> _selectedView = <bool>[true, false, false];
  final Search_TextController = TextEditingController();

  String FiltreGrp = "";
  static List<String> ListParam_FiltreGrp = [];
  static List<String> ListParam_FiltreFam = [];
  static List<String> ListParam_FiltreFamID = [];
  String FiltreFam = "";
  String FiltreFamID = "";

  static List<String> ListParam_FiltreSousFam = [];
  static List<String> ListParam_FiltreSousFamID = [];
  String FiltreSousFam = "";
  String FiltreSousFamID = "";

  double wDialogHeight = 0;
  double wDialogWidth = 0;
  double wLabel = 0;
  double wDropdown = 0;

  bool affEdtFilter = false;
  double icoWidth = 40;
  TextEditingController ctrlFilter = TextEditingController();
  String filterText = '';
  static List<Parc_Art> searchParcs_Art = [];

  int wBtn = 0;
  bool wBtnFam = false;
  bool wBtnSearch = false;

  bool btnSel_Aff = true;

  var formatter = NumberFormat('###,###.00');

  Future Reload() async {

/*
    ListParam_FiltreSousFam.clear();
    ListParam_FiltreSousFamID.clear();

    Srv_DbTools.ListArticle_Fam_Ebp_Fam.clear();
    for (int i = 0; i < Srv_DbTools.ListArticle_Fam_Ebp.length; i++) {
      Article_Fam_Ebp wArticle_Fam_Ebp = Srv_DbTools.ListArticle_Fam_Ebp[i];
      if (wArticle_Fam_Ebp.Article_Fam_Code_Parent.compareTo(FiltreFamID) == 0) {
        ListParam_FiltreSousFam.add(wArticle_Fam_Ebp.Article_Fam_Libelle);
        ListParam_FiltreSousFamID.add(wArticle_Fam_Ebp.Article_Fam_Code);
      }
    }
*/
    FiltreSousFam = ""; //ListParam_FiltreSousFam[0];
    FiltreSousFamID = ""; //ListParam_FiltreSousFamID[0];

    ListParam_FiltreGrp.clear();
    ListParam_FiltreFam.clear();
    ListParam_FiltreSousFam.clear();

    FiltreGrp = "";
    List<String> wlistparamFiltregrp = [];
    for (int i = 0; i < Srv_DbTools.list_Article_GrpFamSsFam_Ebp.length; i++) {
      Article_GrpFamSsFam_Ebp warticleGrpfamssfamEbp = Srv_DbTools.list_Article_GrpFamSsFam_Ebp[i];
      if (!wlistparamFiltregrp.contains(warticleGrpfamssfamEbp.Article_GrpFamSsFam_Groupe)) wlistparamFiltregrp.add(warticleGrpfamssfamEbp.Article_GrpFamSsFam_Groupe);
    }
    wlistparamFiltregrp.sort();
    ListParam_FiltreGrp.addAll(wlistparamFiltregrp);

    await Filtre();
  }

  Future Filtre() async {
    print(" FILTRE");

    for (int i = 0; i < Srv_DbTools.ListArticle_Ebp.length; i++) {
      Article_Ebp warticleEbp = Srv_DbTools.ListArticle_Ebp[i];
      warticleEbp.Art_Sel = false;
      warticleEbp.Art_Qte = 1;
    }

    List<Article_Ebp> ListArtsearchresultTmp = [];
    List<Article_Ebp> ListArtsearchresultTmpF = [];

    ListArtsearchresultTmp.clear();

    Srv_DbTools.ListArticle_Ebpsearchresult.clear();

    if (filterText.isEmpty) {
      print("_buildFieldTextSearch VIDE $filterText");
      ListArtsearchresultTmp.addAll(Srv_DbTools.ListArticle_Ebp);
    } else {
      print("_buildFieldTextSearch liste $filterText");
      for (int i = 0; i < Srv_DbTools.ListArticle_Ebp.length; i++) {
        Article_Ebp warticleEbp = Srv_DbTools.ListArticle_Ebp[i];
        if (warticleEbp.DescRech().toLowerCase().contains(filterText.toLowerCase())) {
          ListArtsearchresultTmp.add(warticleEbp);
        }
      }
    }



    if (FiltreGrp == "" && FiltreFam == "" && FiltreSousFam == "") {
      Srv_DbTools.ListArticle_Ebpsearchresult.addAll(ListArtsearchresultTmp);

      print(" FILTRE  ListParam_FiltreGrp ${ListParam_FiltreGrp.length}");
      print(" FILTRE  ListParam_FiltreFam ${ListParam_FiltreFam.length}");
      print(" FILTRE  ListParam_FiltreSousFam ${ListParam_FiltreSousFam.length}");

      ListParam_FiltreFam.clear();
      FiltreFam = "";
      for (int i = 0; i < Srv_DbTools.list_Article_GrpFamSsFam_Ebp.length; i++) {
        Article_GrpFamSsFam_Ebp warticleGrpfamssfamEbp = Srv_DbTools.list_Article_GrpFamSsFam_Ebp[i];
        if (!ListParam_FiltreFam.contains(warticleGrpfamssfamEbp.Article_GrpFamSsFam_Fam))
          {

            ListParam_FiltreFam.add(warticleGrpfamssfamEbp.Article_GrpFamSsFam_Fam);
          }
      }

      ListParam_FiltreSousFam.clear();
      FiltreSousFam = "";
      for (int i = 0; i < Srv_DbTools.list_Article_GrpFamSsFam_Ebp.length; i++) {
        Article_GrpFamSsFam_Ebp warticleGrpfamssfamEbp = Srv_DbTools.list_Article_GrpFamSsFam_Ebp[i];
        if (!ListParam_FiltreSousFam.contains(warticleGrpfamssfamEbp.Article_GrpFamSsFam_Sous_Fam)) ListParam_FiltreSousFam.add(warticleGrpfamssfamEbp.Article_GrpFamSsFam_Sous_Fam);
      }

      print(" FILTRE VIDES ListParam_FiltreGrp ${ListParam_FiltreGrp.length}");
      print(" FILTRE VIDES ListParam_FiltreFam ${ListParam_FiltreFam.length}");
      print(" FILTRE VIDES ListParam_FiltreSousFam ${ListParam_FiltreSousFam.length}");

      setState(() {});
      return;
    }

    print(" FILTRE  ListParam_FiltreGrp ${ListParam_FiltreGrp.length}");
    print(" FILTRE  ListParam_FiltreFam ${ListParam_FiltreFam.length}");
    print(" FILTRE  ListParam_FiltreSousFam ${ListParam_FiltreSousFam.length}");

    print("FILTRE PAS VIDES FiltreGrp $FiltreGrp FiltreFam $FiltreFam FiltreSousFam $FiltreSousFam");

    Srv_DbTools.ListArticle_Ebpsearchresult.clear();
    for (var element in ListArtsearchresultTmp) {
      bool TestGrp = (FiltreGrp == "") || (FiltreGrp.contains(element.Article_Groupe));
      bool TestFam = (FiltreFam == "") || (FiltreFam.contains(element.Article_LibelleFamilleArticle) && element.Article_LibelleFamilleArticle.isNotEmpty);
      bool TestSousFam = (FiltreSousFam == "") || (FiltreSousFam.contains(element.Article_LibelleSousFamilleArticle)  && element.Article_LibelleSousFamilleArticle.isNotEmpty);

      if (TestGrp && TestFam && TestSousFam)
        {
          Srv_DbTools.ListArticle_Ebpsearchresult.add(element);
        }

    }

    print("Filtre ListArticle_Ebpsearchresult ${Srv_DbTools.ListArticle_Ebpsearchresult.length}");

    setState(() {});
  }

  @override
  void initLib() async {
    for (var element in Srv_DbTools.ListArticle_Ebp) {
      element.Art_Sel = false;
    }

    ListParam_FiltreFam.clear();
    ListParam_FiltreFamID.clear();

    Srv_DbTools.ListArticle_Fam_Ebp_Fam.clear();
    for (int i = 0; i < Srv_DbTools.ListArticle_Fam_Ebp.length; i++) {
      Article_Fam_Ebp warticleFamEbp = Srv_DbTools.ListArticle_Fam_Ebp[i];
      if (warticleFamEbp.Article_Fam_Code_Parent.isEmpty) {
        ListParam_FiltreFam.add(warticleFamEbp.Article_Fam_Libelle);
        ListParam_FiltreFamID.add(warticleFamEbp.Article_Fam_Code);
      }
    }
    FiltreFam = "";
    FiltreFamID = "";

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

    List<Article_Ebp> listarticleEbpsearchresult = Srv_DbTools.ListArticle_Ebpsearchresult.where((element) => element.Art_Sel == true).toList();

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
              width: wWidthDialog,
            ),

////////////
// ENTETE
////////////

            Positioned(
              top: 0,
              left: 0,
              child: Material(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                child: Container(
                  height: wHeightTitre - 9,
                  width: 560,
                  decoration: const BoxDecoration(color: gColors.LinearGradient2,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Text(
                          "Catalogue rapide",
                          style: gColors.bodyTitle1_B_G_20,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
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
                width: 560,
                height: wHeightPied,
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                decoration: BoxDecoration(
                  color: gColors.LinearGradient2,
                  borderRadius: BorderRadius.circular(24),
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
                              backgroundColor: listarticleEbpsearchresult.isNotEmpty ? gColors.blueCyan : gColors.LinearGradient4,
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
                            if (listarticleEbpsearchresult.isNotEmpty) {
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) => const DCL_Article_Det(
                                  wTitre: "Listing",
                                ),
                              );
                              setState(() {});
                            }
                          },
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: listarticleEbpsearchresult.isNotEmpty ? gColors.primaryGreen : gColors.LinearGradient4,
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
                              if (listarticleEbpsearchresult.isNotEmpty) {
                                int wOrder = Srv_DbTools.getLastOrder() + 1;
                                if (Srv_DbTools.gDCL_Det.DCL_DetID != -1) {
                                  wOrder = Srv_DbTools.gDCL_Det.DCL_Det_Ordre!;
                                }

                                for (int i = 0; i < Srv_DbTools.ListArticle_Ebpsearchresult.length; i++) {
                                  Article_Ebp warticleEbp = Srv_DbTools.ListArticle_Ebpsearchresult[i];

                                  if (!warticleEbp.Art_Sel) continue;


                                  DCL_Det adclDet = DCL_Det();
                                  adclDet.DCL_Det_EntID = Srv_DbTools.gDCL_Ent.DCL_EntID;
                                  adclDet.DCL_Det_Type = "A";
                                  adclDet.DCL_Det_ParcsArtId = 0;
                                  adclDet.DCL_Det_Ordre = wOrder++;
                                  adclDet.DCL_Det_NoArt = warticleEbp.Article_codeArticle;
                                  adclDet.DCL_Det_Lib = warticleEbp.Article_descriptionCommercialeEnClair;
                                  adclDet.DCL_Det_Qte = warticleEbp.Art_Qte;
                                  adclDet.DCL_Det_PU = warticleEbp.Article_Promo_PVHT > 0 ? warticleEbp.Article_Promo_PVHT : warticleEbp.Article_PVHT;
                                  adclDet.DCL_Det_RemP = 0;
                                  adclDet.DCL_Det_RemMt = 0;
                                  adclDet.DCL_Det_TVA = 0;
                                  adclDet.DCL_Det_Livr = 0;
                                  adclDet.DCL_Det_DateLivr = "";
                                  adclDet.DCL_Det_Rel = 0;
                                  adclDet.DCL_Det_DateRel = "";
                                  adclDet.DCL_Det_Statut = "Facturable";
                                  adclDet.DCL_Det_Note = "";
                                  adclDet.DCL_Det_Garantie = "";
                                  adclDet.DCL_Det_Garantie = warticleEbp.DCL_Det_Garantie;


                                  print(" aDCL_Det.DCL_Det_Garantie ${adclDet.DCL_Det_Garantie}");


                                  await Srv_DbTools.InsertUpdateDCL_Det(adclDet);
                                }
                              }
                              Navigator.pop(context);
                            })
                      ],
                    )
                  ],
                ),
              )),
            ),

///////////
// Content
///////////

            Positioned(
                top: wHeightTitre - 15,
                left: wLeft,
                child: Container(
                  color: Colors.white,
                  height: wHeightDet2,
                  width: 560,
                  child: Container(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Entete_Btn_Search(),
                          gColors.ombre(),
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
          const Spacer(),
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

  List<String> selectedItems_Grp = [];
  final TextEditingController searchCtrl_Grp = TextEditingController();

  Widget DropdownFiltreGrp() {
    print(" DropdownFiltreGrp ListParam_FiltreGrp ${ListParam_FiltreGrp.length}");


    if (ListParam_FiltreGrp.isEmpty) return Container();

    return Container(
        child: Row(children: [
      Container(
        width: 140,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
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
      SizedBox(
        width: 310,
        child: DropdownButtonHideUnderline(
            child: DropdownButton2(
          hint: Text(
            '  Séléctionner un groupe',
            style: gColors.bodyTitle1_N_Gr,
          ),
          // isExpanded: true,
          items: ListParam_FiltreGrp.map((item) {
            return DropdownMenuItem(
              value: item,
              enabled: false,
              child: StatefulBuilder(
                builder: (context, menuSetState) {
                  final isSelected = selectedItems_Grp.contains(item);
                  return InkWell(
                    onTap: () {
                      isSelected ? selectedItems_Grp.remove(item) : selectedItems_Grp.add(item);
                      onChangegrp();
                      menuSetState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      color: Colors.white,
                      height: 56,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item,
                              style: gColors.bodyTitle1_N_Gr,
                            ),
                          ),
                          if (isSelected) const Icon(Icons.check)
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }).toList(),
          onChanged: (value) {
            print("zz");
          },
          value: selectedItems_Grp.isEmpty ? null : selectedItems_Grp.last,
          selectedItemBuilder: (context) {
            return ListParam_FiltreGrp.map(
              (item) {
                return Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  width: 252,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    selectedItems_Grp.join(', '),
                    style: gColors.bodyTitle1_N_Gr,
                    maxLines: 1,
                  ),
                );
              },
            ).toList();
          },
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.fromLTRB(1, 0, 0, 0),
            height: 57,
          ),
          dropdownSearchData: DropdownSearchData(
            searchController: searchCtrl_Grp,
            searchInnerWidgetHeight: 40,
            searchInnerWidget: Column(
              children: [
                Container(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Filter les éléments',
                      style: gColors.bodyTitle1_B_Gr,
                    ),
                  ],
                ),
                Container(
                  height: 10,
                ),
                Container(
                  height: 1,
                  color: gColors.LinearGradient3,
                ),
                gColors.ombre(),
                Container(
                  height: 2,
                ),
              ],
            ),
            searchMatchFn: (item, searchValue) {
              return item.value.toString().toLowerCase().contains(searchValue.toLowerCase());
            },
          ),

          dropdownStyleData: DropdownStyleData(
            maxHeight: 750,
            width: 358,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            scrollPadding: const EdgeInsets.fromLTRB(0, 0, 2, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.black,
              ),
              color: gColors.LinearGradient2,
            ),
          ),
        )),
      ),


    if (ListParam_FiltreGrp.isNotEmpty)
        InkWell(
          onTap: () async {
            FiltreGrp = "";
            selectedItems_Grp.clear();
            selectedItems_Fam.clear();
            ListParam_FiltreFam.clear();
            FiltreFam = "";
            selectedItems_SousFam.clear();
            ListParam_FiltreSousFam.clear();
            FiltreSousFam = "";
            onChangegrp();
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

  void onChangegrp() {
    print(" ONCHANGE ONCHANGE ONCHANGE ONCHANGE");

    setState(() {
      String sValue = selectedItems_Grp.join(', ');

      FiltreGrp = sValue;
      print(">>>>>>>>>>>>>>>>> FiltreGrp $FiltreGrp");

      if (FiltreGrp == "") {
        ListParam_FiltreFam.clear();
        FiltreFam = "";
        for (int i = 0; i < Srv_DbTools.list_Article_GrpFamSsFam_Ebp.length; i++) {
          Article_GrpFamSsFam_Ebp warticleGrpfamssfamEbp = Srv_DbTools.list_Article_GrpFamSsFam_Ebp[i];
          if (!ListParam_FiltreFam.contains(warticleGrpfamssfamEbp.Article_GrpFamSsFam_Fam)) ListParam_FiltreFam.add(warticleGrpfamssfamEbp.Article_GrpFamSsFam_Fam);
        }
        ListParam_FiltreSousFam.clear();
        FiltreSousFam = "";
        for (int i = 0; i < Srv_DbTools.list_Article_GrpFamSsFam_Ebp.length; i++) {
          Article_GrpFamSsFam_Ebp warticleGrpfamssfamEbp = Srv_DbTools.list_Article_GrpFamSsFam_Ebp[i];
          if (!ListParam_FiltreSousFam.contains(warticleGrpfamssfamEbp.Article_GrpFamSsFam_Sous_Fam)) ListParam_FiltreSousFam.add(warticleGrpfamssfamEbp.Article_GrpFamSsFam_Sous_Fam);
        }
      } else {
        ListParam_FiltreFam.clear();
        FiltreFam = "";

        ListParam_FiltreSousFam.clear();
        FiltreSousFam = "";
        for (int i = 0; i < Srv_DbTools.list_Article_GrpFamSsFam_Ebp.length; i++) {
          Article_GrpFamSsFam_Ebp warticleGrpfamssfamEbpgrp = Srv_DbTools.list_Article_GrpFamSsFam_Ebp[i];

          if (FiltreGrp.contains(warticleGrpfamssfamEbpgrp.Article_GrpFamSsFam_Groupe)) {
            if (!ListParam_FiltreFam.contains(warticleGrpfamssfamEbpgrp.Article_GrpFamSsFam_Fam)) {
              ListParam_FiltreFam.add(warticleGrpfamssfamEbpgrp.Article_GrpFamSsFam_Fam);

              for (int i = 0; i < Srv_DbTools.list_Article_GrpFamSsFam_Ebp.length; i++) {
                Article_GrpFamSsFam_Ebp warticleGrpfamssfamEbpfam = Srv_DbTools.list_Article_GrpFamSsFam_Ebp[i];
                if (warticleGrpfamssfamEbpfam.Article_GrpFamSsFam_Fam == warticleGrpfamssfamEbpgrp.Article_GrpFamSsFam_Fam) {
                  if (!ListParam_FiltreSousFam.contains(warticleGrpfamssfamEbpfam.Article_GrpFamSsFam_Sous_Fam)) ListParam_FiltreSousFam.add(warticleGrpfamssfamEbpfam.Article_GrpFamSsFam_Sous_Fam);
                }
              }
            }
          }
        }

        Filtre();
      }
    });
  }

  List<String> selectedItems_Fam = [];
  final TextEditingController searchCtrl_Fam = TextEditingController();

  Widget DropdownFiltreFam() {
    print(" DropdownFiltreFam ListParam_FiltreFam ${ListParam_FiltreFam.length}");

    if (ListParam_FiltreFam.isEmpty) return Container();


      return Container(
        child: Row(children: [
      Container(
        width: 140,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
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
      SizedBox(
        width: 310,
        child: DropdownButtonHideUnderline(
            child: DropdownButton2(
          hint: Text(
            '  Séléctionner une famille',
            style: gColors.bodyTitle1_N_Gr,
          ),
          // isExpanded: true,

          items: ListParam_FiltreFam.map((item) {
            return DropdownMenuItem(
              value: item,
              enabled: false,
              child: StatefulBuilder(
                builder: (context, menuSetState) {
                  final isSelected = selectedItems_Fam.contains(item);
                  return InkWell(
                    onTap: () {
                      isSelected ? selectedItems_Fam.remove(item) : selectedItems_Fam.add(item);
                      onChangeFam();
                      menuSetState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      color: Colors.white,
                      height: 56,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item,
                              style: gColors.bodyTitle1_N_Gr,
                            ),
                          ),
                          if (isSelected) const Icon(Icons.check)
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }).toList(),
              onChanged: (value) {
                print("zz");
              },

          value: selectedItems_Fam.isEmpty ? null : selectedItems_Fam.last,
          selectedItemBuilder: (context) {
            return ListParam_FiltreFam.map(
              (item) {
                return Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  width: 252,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    selectedItems_Fam.join(', '),
                    style: gColors.bodyTitle1_N_Gr,
                    maxLines: 1,
                  ),
                );
              },
            ).toList();
          },

          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.fromLTRB(1, 0, 0, 0),
            height: 57,
          ),
          dropdownSearchData: DropdownSearchData(
            searchController: searchCtrl_Fam,
            searchInnerWidgetHeight: 40,
            searchInnerWidget: Column(
              children: [
                Container(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Filter les éléments',
                      style: gColors.bodyTitle1_B_Gr,
                    ),
                  ],
                ),
                Container(
                  height: 10,
                ),
                Container(
                  height: 1,
                  color: gColors.LinearGradient3,
                ),
                gColors.ombre(),
                Container(
                  height: 2,
                ),
              ],
            ),
            searchMatchFn: (item, searchValue) {
              return item.value.toString().toLowerCase().contains(searchValue.toLowerCase());
            },
          ),

          dropdownStyleData: DropdownStyleData(
            maxHeight: 750,
            width: 358,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            scrollPadding: const EdgeInsets.fromLTRB(0, 0, 2, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.black,
              ),
              color: gColors.LinearGradient2,
            ),
          ),
        )),
      ),
      if (ListParam_FiltreFam.isNotEmpty)
        InkWell(
          onTap: () async {
            FiltreFam = "";
            selectedItems_Fam.clear();
            ListParam_FiltreFam.clear();
            onChangeFam();
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

  void onChangeFam() {
    print(" ONCHANGE ONCHANGE ONCHANGE ONCHANGE");

    String value = selectedItems_Fam.join(', ');

    if (FiltreFam != value) {
      FiltreFam = value;

      ListParam_FiltreSousFam.clear();
      FiltreSousFam = "";
      for (int i = 0; i < Srv_DbTools.list_Article_GrpFamSsFam_Ebp.length; i++) {
        Article_GrpFamSsFam_Ebp warticleGrpfamssfamEbp = Srv_DbTools.list_Article_GrpFamSsFam_Ebp[i];
        if (FiltreFam.contains(warticleGrpfamssfamEbp.Article_GrpFamSsFam_Fam)) {
          if (!ListParam_FiltreSousFam.contains(warticleGrpfamssfamEbp.Article_GrpFamSsFam_Sous_Fam)) ListParam_FiltreSousFam.add(warticleGrpfamssfamEbp.Article_GrpFamSsFam_Sous_Fam);
        }
      }
    }
    Filtre();
  }

  List<String> selectedItems_SousFam = [];
  final TextEditingController searchCtrl_SousFam = TextEditingController();

  Widget DropdownFiltreSousFam() {
    print(" DropdownFiltreSousFam ListParam_FiltreSousFam ${ListParam_FiltreSousFam.length}");

    if (ListParam_FiltreSousFam.isEmpty) return Container();

    return Container(
        child: Row(children: [
      Container(
        width: 140,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
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
              'SousFamille',
              style: gColors.bodyTitle1_B_W,
            ),
          ],
        ),
      ),
      SizedBox(
        width: 310,
        child: DropdownButtonHideUnderline(
            child: DropdownButton2(
          hint: Text(
            '  Séléctionner une SousFamille',
            style: gColors.bodyTitle1_N_Gr,
          ),
          // isExpanded: true,

          items: ListParam_FiltreSousFam.map((item) {
            return DropdownMenuItem(
              value: item,
              enabled: false,
              child: StatefulBuilder(
                builder: (context, menuSetState) {
                  final isSelected = selectedItems_SousFam.contains(item);
                  return InkWell(
                    onTap: () {
                      isSelected ? selectedItems_SousFam.remove(item) : selectedItems_SousFam.add(item);
                      onChangeSousFam();
                      menuSetState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      color: Colors.white,
                      height: 56,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item,
                              style: gColors.bodyTitle1_N_Gr,
                            ),
                          ),
                          if (isSelected) const Icon(Icons.check)
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }).toList(),
              onChanged: (value) {
                print("zz");
              },

          value: selectedItems_SousFam.isEmpty ? null : selectedItems_SousFam.last,
          selectedItemBuilder: (context) {
            return ListParam_FiltreSousFam.map(
              (item) {
                return Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  width: 252,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    selectedItems_SousFam.join(', '),
                    style: gColors.bodyTitle1_N_Gr,
                    maxLines: 1,
                  ),
                );
              },
            ).toList();
          },

          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.fromLTRB(1, 0, 0, 0),
            height: 57,
          ),
          dropdownSearchData: DropdownSearchData(
            searchController: searchCtrl_SousFam,
            searchInnerWidgetHeight: 40,
            searchInnerWidget: Column(
              children: [
                Container(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Filter les éléments',
                      style: gColors.bodyTitle1_B_Gr,
                    ),
                  ],
                ),
                Container(
                  height: 10,
                ),
                Container(
                  height: 1,
                  color: gColors.LinearGradient3,
                ),
                gColors.ombre(),
                Container(
                  height: 2,
                ),
              ],
            ),
            searchMatchFn: (item, searchValue) {
              return item.value.toString().toLowerCase().contains(searchValue.toLowerCase());
            },
          ),

          dropdownStyleData: DropdownStyleData(
            maxHeight: 750,
            width: 358,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            scrollPadding: const EdgeInsets.fromLTRB(0, 0, 2, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.black,
              ),
              color: gColors.LinearGradient2,
            ),
          ),
        )),
      ),
      if (ListParam_FiltreSousFam.isNotEmpty)
        InkWell(
          onTap: () async {
            FiltreSousFam = "";
            selectedItems_SousFam.clear();
            ListParam_FiltreSousFam.clear();
            onChangeSousFam();
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

  void onChangeSousFam() {
    print(" ONCHANGE ONCHANGE ONCHANGE ONCHANGE");

    String value = selectedItems_SousFam.join(', ');

    if (FiltreSousFam != value) {
      FiltreSousFam = value;
    }
    Filtre();
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

    List<Article_Ebp> listarticleEbpsearchresult = [];
    if (wBtn == 1) {
      listarticleEbpsearchresult = Srv_DbTools.ListArticle_Ebpsearchresult.where((element) => element.Article_New == true).toList();
    } else if (wBtn == 2) {
      listarticleEbpsearchresult = Srv_DbTools.ListArticle_Ebpsearchresult.where((element) => Srv_DbTools.gUserLogin_Art_Fav.contains(element.Article_codeArticle)).toList();
      print("wBtn == 2 ${listarticleEbpsearchresult.length}");
    } else {
      listarticleEbpsearchresult = Srv_DbTools.ListArticle_Ebpsearchresult;
    }

    int wLen = listarticleEbpsearchresult.length;
    if (listarticleEbpsearchresult.length > 50) {
      wLen = 52;
      bSup50 = true;
    }

    double wHeigth = wHeightDet2 - 78;
    if (wBtnFam) {
      wHeigth = wHeigth - 250;
    } else if (wBtnSearch) wHeigth = wHeigth - 100;

    return Container(
      padding: EdgeInsets.fromLTRB(0, btnSel_Aff ? 00 : 0, 0, 0),
      height: wHeigth,
      color: gColors.LinearGradient2,
      width: 560,
      child: Container(
        color: gColors.greyDark,
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          color: gColors.LinearGradient2,
          child: Scrollbar(
              child: ListView.separated(
            padding: const EdgeInsets.all(0.0),
            shrinkWrap: true,
//            itemCount: bSup50 ? 52 : Srv_DbTools.ListArticle_Ebpsearchresult.length,
            itemCount: wLen,
            itemBuilder: (context, index) {
              Article_Ebp element = listarticleEbpsearchresult[index];
              Widget wRowSaisie = Container();

              if (bSup50 && index == 51) {
                wRowSaisie = SizedBox(
                  width: 100,
                  height: 40,
                  child: Text(
                    "    Lignes > 50 ...",
                    style: gColors.bodyTitle1_B_G24,
                  ),
                );
              } else {
                if (btnSel_Aff) {
                  wRowSaisie = RowSaisieBig(element, LargeurCol, LargeurCol2, H2);
                } else {
                  wRowSaisie = RowSaisie(element, LargeurCol, LargeurCol2, H2);
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

    await Srv_DbTools.getArticlesImg_Ebp( art.Article_codeArticle);
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

  Widget buildImage(BuildContext context, Article_Ebp art) {
    return FutureBuilder(
      future: GetImage(art, 80),
      builder: (BuildContext context, AsyncSnapshot<Image> image) {
        if (image.hasData) {
          return image.data!;
        } else {
          return Container(width: 30);
        }
      },
    );
  }

  Widget buildImageBig(BuildContext context, Article_Ebp art) {
    return FutureBuilder(
      future: GetImage(art, 100),
      builder: (BuildContext context, AsyncSnapshot<Image> image) {
        if (image.hasData) {
          return image.data!;
        } else {
          return Container(height: 100);
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
            padding: const EdgeInsets.fromLTRB(0, 2, 8, 0),
            child: Text(
              art.Article_codeArticle,
              style: gColors.bodyTitle1_N_Gr,
            ),
          ),
          Expanded(
            child: Container(
              height: 20,
              padding: const EdgeInsets.fromLTRB(0, 2, 8, 0),
              child: Text(
                art.Article_descriptionCommercialeEnClair,
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
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
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
                      height: 68,
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text(
                        art.Article_descriptionCommercialeEnClair,
                        style: gColors.bodyTitle1_B_Gr,
                        maxLines: 3,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 16,
                          padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                          child: Text(
                            art.Article_codeArticle,
                            style: gColors.bodyTitle1_N_Gr,
                          ),
                        ),
                        Container(
                          height: 16,
                          padding: const EdgeInsets.fromLTRB(0, 0, 18, 0),
                          child: Text(
                            "PV HT ${formatter.format(art.Article_PVHT).replaceAll(',', ' ').replaceAll('.', ',')}€",
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
            color: gColors.LinearGradient3,
          ),
          gColors.ombre(),
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
    if (wBtnFam) {
      wHeigth = 307;
    } else if (wBtnSearch) wHeigth = 147;

    print(" BUILD ListParam_FiltreGrp ${ListParam_FiltreGrp.length}");
    print(" BUILD ListParam_FiltreFam ${ListParam_FiltreFam.length}");
    print(" BUILD ListParam_FiltreSousFam ${ListParam_FiltreSousFam.length}");

    return Container(
        color: gColors.LinearGradient2,
        height: wHeigth,
        width: 560,
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: [
              InkWell(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 6, 0),
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
                    padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
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
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
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
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
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
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
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
              SizedBox(
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
                              FiltreGrp = "";
                              selectedItems_Grp.clear();
                              ListParam_FiltreGrp.clear();

                              FiltreFam = "";
                              selectedItems_Fam.clear();
                              ListParam_FiltreFam.clear();

                              FiltreSousFam = "";
                              selectedItems_SousFam.clear();
                              ListParam_FiltreSousFam.clear();
                              Reload();
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
                      margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                      margin: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                      margin: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                margin: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
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
            ));
  }
}
