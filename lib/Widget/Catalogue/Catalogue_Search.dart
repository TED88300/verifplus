import 'dart:async';
import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';


//**********************************
//**********************************
//**********************************

class Catalogue_Search extends StatefulWidget {
  @override
  Catalogue_SearchState createState() => Catalogue_SearchState();
}

class Catalogue_SearchState extends State<Catalogue_Search> {
  Widget wIco = Container();

  final Search_TextController = TextEditingController();

  static List<String> ListParam_FiltreGroupe = [];
  static List<String> ListParam_FiltreGroupeID = [];
  String FiltreGroupe = "Tous";
  String FiltreGroupeID = "";
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

  double wHeightSel  = 42;


  Future Reload() async {
    ListParam_FiltreSousFam.clear();
    ListParam_FiltreSousFamID.clear();
    ListParam_FiltreSousFam.add("Tous");
    ListParam_FiltreSousFamID.add("*");
    Srv_DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("${FiltreFamID}") == 0) {
        ListParam_FiltreSousFam.add(element.Param_Param_Text);
        ListParam_FiltreSousFamID.add(element.Param_Param_ID);
      }
    });
    FiltreSousFam = ListParam_FiltreSousFam[0];
    FiltreSousFamID = ListParam_FiltreSousFamID[0];

    Filtre();
  }

  Future Filtre() async {
    List<Art> ListArtsearchresultTmp = [];
    List<Art> ListArtsearchresultTmpG = [];
    List<Art> ListArtsearchresultTmpF = [];

    ListArtsearchresultTmp.clear();

    print("_buildFieldTextSearch Filtre ${Search_TextController.text}");

    if (Search_TextController.text.isEmpty) {
      ListArtsearchresultTmp.addAll(Srv_DbTools.ListArt);
    } else {
      print("_buildFieldTextSearch liste ${Search_TextController.text}");
      Srv_DbTools.ListArt.forEach((element) {
        print("_buildFieldTextSearch element ${element.Desc()}");
        if (element.Art_Lib.toLowerCase().contains(Search_TextController.text.toLowerCase())) {
          ListArtsearchresultTmp.add(element);
        }
      });
    }

    if (FiltreGroupe.compareTo("Tous") == 0) {
      ListArtsearchresultTmpG.addAll(ListArtsearchresultTmp);
    } else {
      ListArtsearchresultTmp.forEach((element) {
        if (FiltreGroupe.compareTo(element.Art_Groupe) == 0) ListArtsearchresultTmpG.add(element);
      });
    }

    if (FiltreFam.compareTo("Tous") == 0) {
      ListArtsearchresultTmpF.addAll(ListArtsearchresultTmpG);
    } else {
      ListArtsearchresultTmpG.forEach((element) {
        if (FiltreFam.compareTo(element.Art_Fam) == 0) ListArtsearchresultTmpF.add(element);
      });
    }

    Srv_DbTools.ListArtsearchresult.clear();

    if (FiltreSousFam.compareTo("Tous") == 0) {
      Srv_DbTools.ListArtsearchresult.addAll(ListArtsearchresultTmpF);
    } else {
      ListArtsearchresultTmpF.forEach((element) {
        if (FiltreSousFam.compareTo(element.Art_Sous_Fam) == 0) Srv_DbTools.ListArtsearchresult.add(element);
      });
    }

    setState(() {});
  }

  @override
  void initLib() async {
    await Srv_DbTools.getParam_ParamAll();

    await Srv_DbTools.getArtAllFam();

    ListParam_FiltreGroupe.clear();
    ListParam_FiltreGroupeID.clear();
    ListParam_FiltreGroupe.add("Tous");
    ListParam_FiltreGroupeID.add("*");

//    print("Desc ${Srv_DbTools.ListParam_ParamAll.length}");
    Srv_DbTools.ListParam_ParamAll.forEach((element) {
      //    print("Desc ${element.Desc()}");
      if (element.Param_Param_Type.compareTo("GrpHab") == 0) {
        ListParam_FiltreGroupe.add(element.Param_Param_Text);
        ListParam_FiltreGroupeID.add(element.Param_Param_ID);
      }
    });
    FiltreGroupe = ListParam_FiltreGroupe[0];
    FiltreGroupeID = ListParam_FiltreGroupeID[0];
/*
    print("FiltreGroupeID ${FiltreGroupeID}");
    print("FiltreGroupe ${FiltreGroupe}");
*/

    ListParam_FiltreFam.clear();
    ListParam_FiltreFamID.clear();
    ListParam_FiltreFam.add("Tous");
    ListParam_FiltreFamID.add("*");

//    print("Desc ${Srv_DbTools.ListParam_ParamAll.length}");
    Srv_DbTools.ListParam_ParamAll.forEach((element) {
      //    print("Desc ${element.Desc()}");
      if (element.Param_Param_Type.compareTo("Fam") == 0) {
        ListParam_FiltreFam.add(element.Param_Param_Text);
        ListParam_FiltreFamID.add(element.Param_Param_ID);
      }
    });
    FiltreFam = ListParam_FiltreFam[0];
    FiltreFamID = ListParam_FiltreFamID[0];
/*
    print("FiltreFamID ${FiltreFamID}");
    print("FiltreFam ${FiltreFam}");
*/

    await Reload();
  }

  @override
  void initState() {
    initLib();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    wDialogHeight = MediaQuery.of(context).size.height;
    wDialogWidth = MediaQuery.of(context).size.width;
    wLabel = 120;
    wDropdown = wDialogWidth - wLabel - 17;

    return Container(
        color: gColors.greyLight,
        height: wDialogHeight,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              color: gColors.black,
              height: 1,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownFiltreFam(),
                  Container(
                    height: 5,
                  ),
                  DropdownFiltreSousFam(),
                  Container(
                    height: 5,
                  ),
                  _buildFieldTextSearch(),
                  Container(
                    height: 5,
                  ),
                  buildDesc(context),
                ],
              ),
            ),
            Spacer(),
            Container(
              color: gColors.black,
              height: 1,
            ),
          ],
        ));
  }

  //**********************************
  //**********************************
  //**********************************

  Widget _buildFieldTextSearch() {
    return Container(
        decoration: BoxDecoration(
          color: gColors.greyDark,
          border: Border.all(
            color: gColors.greyDark,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: wLabel - 5,
              height: 34,
              alignment: Alignment.center,
              child: Text(
                "Recherche",
                style: gColors.bodyTitle1_B_W,
              ),
            ),
            Container(
              width: 10,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              width: wDropdown - 1,
              height: wHeightSel,
              color: gColors.transparent,
              child: TextFormField(
                controller: Search_TextController,
                style: gColors.bodyTitle1_N_Gr,
                onChanged: (String? value) async {
//        Search_TextController.text = value!;
                  print("_buildFieldTextSearch search ${Search_TextController.text}");
                  await Filtre();
                },
                decoration: InputDecoration(
                  filled: true, //<-- SEE HERE
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.transparent),

                  ),
//                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ],
        ));
  }

  Widget DropdownFiltreFam() {
    if (ListParam_FiltreFam.length == 0) return Container();

    return Container(
        decoration: BoxDecoration(
          color: gColors.secondary,
          border: Border.all(
            color: gColors.secondary,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: Row(children: [
          Container(
            width: 5,
          ),
          Container(
            width: wLabel,
            alignment: Alignment.center,
            child: Text(
              "Famille",
              style: gColors.bodyTitle1_B_W,
            ),
          ),
          Container(
            child: DropdownButtonHideUnderline(
                child: DropdownButton2(
              hint: Text(
                'Séléctionner une Famille',
                style: gColors.bodyTitle1_N_Gr,
              ),
              items: ListParam_FiltreFam.map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      "  ${item}",
                      style: gColors.bodyTitle1_N_Gr,
                    ),
                  )).toList(),
              value: FiltreFam,
              onChanged: (value) {
                setState(() {
                  String sValue = value as String;
                  FiltreFamID = ListParam_FiltreFamID[ListParam_FiltreFam.indexOf(sValue)];
                  FiltreFam = value as String;
                  print(">>>>>>>>>>>>>>>>> FiltreFam ${FiltreFamID} ${FiltreFam}");

                  ListParam_FiltreSousFam.clear();
                  ListParam_FiltreSousFamID.clear();
                  ListParam_FiltreSousFam.add("Tous");
                  ListParam_FiltreSousFamID.add("*");
                  Srv_DbTools.ListParam_ParamAll.forEach((element) {
                    if (element.Param_Param_Type.compareTo("${FiltreFamID}") == 0) {
                      ListParam_FiltreSousFam.add(element.Param_Param_Text);
                      ListParam_FiltreSousFamID.add(element.Param_Param_ID);
                    }
                  });
                  FiltreSousFam = ListParam_FiltreSousFam[0];
                  FiltreSousFamID = ListParam_FiltreSousFamID[0];
                  print(">>>>>>>>>>>>>>>>> FiltreSousFam ${FiltreSousFamID} ${FiltreSousFam}");
                  Filtre();
                });
              },
              buttonPadding: const EdgeInsets.only(left: 14, right: 14),
              buttonDecoration: BoxDecoration(
                border: Border.all(
                  color: Colors.orange,
                ),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              buttonHeight: wHeightSel,
              buttonWidth: wDropdown,
              dropdownMaxHeight: 250,
              itemHeight: 32,
            )),
          ),
        ]));
  }

  Widget DropdownFiltreSousFam() {
    if (ListParam_FiltreSousFam.length == 0) return Container();

    return Container(
        decoration: BoxDecoration(
          color: gColors.secondary,
          border: Border.all(
            color: gColors.secondary,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: Row(children: [
          Container(
            width: 5,
          ),
          Container(
            width: wLabel,
            alignment: Alignment.center,
            child: Text(
              "Sous-Famille",
              style: gColors.bodyTitle1_B_W,
            ),
          ),
          Container(
            child: DropdownButtonHideUnderline(
                child: DropdownButton2(
              hint: Text(
                'Séléctionner une SousFamille',
                style: gColors.bodyTitle1_N_Gr,
              ),
              items: ListParam_FiltreSousFam.map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      "  ${item}",
                      style: gColors.bodyTitle1_N_Gr,
                    ),
                  )).toList(),
              value: FiltreSousFam,
              onChanged: (value) {
                String sValue = value as String;

                FiltreSousFamID = ListParam_FiltreSousFam[ListParam_FiltreSousFam.indexOf(sValue)];
                FiltreSousFam = value as String;
                print("FiltreSousFam ${FiltreSousFamID} ${FiltreSousFam}");

                Filtre();
              },
              buttonPadding: const EdgeInsets.only(left: 14, right: 14),
              buttonDecoration: BoxDecoration(
                border: Border.all(
                  color: Colors.orange,
                ),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              buttonHeight: wHeightSel,
              buttonWidth: wDropdown,
              dropdownMaxHeight: 250,
              itemHeight: 32,
            )),
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

    List<Widget> RowSaisies = [];
    for (int i = 0; i < Srv_DbTools.ListArtsearchresult.length; i++) {
      Art element = Srv_DbTools.ListArtsearchresult[i];

//      print("buildDesc ${element.Art_Lib} ${element.Art_Sel}");

      RowSaisies.add(RowSaisie(element, LargeurCol, LargeurCol2, H2));
    }

    double wb = MediaQuery.of(context).viewInsets.bottom;

    double bas = 277 + wb;
    return Container(
      height: wDialogHeight - bas,
      width: 599,
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
        color: gColors.greyDark,
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          color: gColors.greyLight,
          child: Scrollbar(
              child: ListView.separated(
            padding: const EdgeInsets.all(0.0),
            shrinkWrap: true,
            itemCount: RowSaisies.length,
            itemBuilder: (context, index) {
              return RowSaisies[index];
            },
            separatorBuilder: (BuildContext context, int index) => Container(height: 1, width: double.infinity, color: gColors.greyDark),
          )),
        ),
      ),
    );
  }

  Widget RowSaisie(Art art, double LargeurCol, double LargeurCol2, double H2) {
    double IcoWidth = 200;

    String wTxt =
        "Le Lorem Ipsum est simplement du faux texte employé dans la composition et la mise en page avant impression. Le Lorem Ipsum est le faux texte standard de l'imprimerie depuis les années 1500, quand un imprimeur anonyme assembla ensemble des morceaux de texte pour réaliser un livre spécimen de polices de texte. Il n'a pas fait que survivre cinq siècles, mais s'est aussi adapté à la bureautique informatique, sans que son contenu n'en soit modifié. Il a été popularisé dans les années 1960 grâce à la vente de feuilles Letraset contenant des passages du Lorem Ipsum, et, plus récemment, par son inclusion dans des applications de mise en page de texte, comme Aldus PageMaker.";

    print("wTxt ${wTxt.length}");

    Random random = new Random();

    int randomNumber = random.nextInt(wTxt.length - 100) + 100;
    int randomCode = random.nextInt(1000 - 100) + 100;
    int randomPrix = random.nextInt(300 - 100) + 100;

    return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        color: Colors.white,
        child: InkWell(
            onTap: () async {
              await HapticFeedback.vibrate();
              print("onTap ${art.Desc()}");

              setState(() {});
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FiltreFam.compareTo("Tous") == 0 ?
                Row(children: [

                  Expanded(
                    child: Container(
                      height: 32,
                      color: gColors.secondary,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 2),
                      child: Text(
                        "${art.Art_Fam}",
                        style: gColors.bodyTitle1_B_Wr,
                        textAlign: TextAlign.center,

                      ),
                    ),
                  ),
                ]) : Container(),

                Row(children: [
                  Container(
                    width: 100,
                    height: 32,
                    color: gColors.greyLight,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 2),
                    child: Text(
                      "Code",
                      style: gColors.bodyTitle1_B_Sr,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: FiltreSousFam.compareTo("Tous") == 0 ? Container(
                      height: 32,
                      color: gColors.greyDark,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 2),
                      child: Text(
                        "${art.Art_Sous_Fam}",
                        style: gColors.bodyTitle1_B_Wr,
                        textAlign: TextAlign.center,

                      ),
                    ) : Container(),
                  ),
                  Container(
                    width: 100,
                    height: 32,
                    color: gColors.greyLight,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 2),
                    child: Text(
                      "Prix HT",
                      style: gColors.bodyTitle1_B_Sr,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),

                Row(children: [
                  Container(
                    width: 100,
                    height: 32,
                    color: gColors.greyLight,

                    padding: EdgeInsets.fromLTRB(0, 5, 0, 2),
                    child: Text(
                      "${randomCode}",
                      style: gColors.bodyTitle1_B_Sr,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 32,
                      color: gColors.white,

                      padding: EdgeInsets.fromLTRB(10, 5, 0, 2),
                      child: Text(
                        "${art.Art_Lib}",
                        style: gColors.bodyTitle1_B_G_20,
                        textAlign: TextAlign.left,

                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 32,
                    color: gColors.greyLight,
                    padding: EdgeInsets.fromLTRB(0, 5, 10, 2),
                    child: Text(
                      "${randomCode}€",
                      style: gColors.bodyTitle1_B_Sr,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ]),



                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/Aide_Ico_PP.png",
                      height: IcoWidth,
                      width: IcoWidth,
                    ),
                    Expanded(
                      child: Container(
//                        height: 200,
                        padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
                        child: Text(
                          wTxt.substring(0, randomNumber),
                          style: gColors.bodyTitle1_N_Gr,
                          maxLines: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 20,
                ),
              ],
            )));
  }
}
