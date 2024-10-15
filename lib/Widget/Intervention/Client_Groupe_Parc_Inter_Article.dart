import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles_Ebp.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles_Fam_Ebp.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles_Link_Ebp.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles_Link_Verif_Ebp.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_NF074.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Art.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Desc.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Ent.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

class Client_Groupe_Parc_Inter_Article_Dialog {
  Client_Groupe_Parc_Inter_Article_Dialog();

  static Future<void> Dialogs_Saisie(
    BuildContext context,
    VoidCallback onSaisie,
    String art_Type,
  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => Client_Groupe_Parc_Inter_ArticleDialog(
        onSaisie: onSaisie,
        art_Type: art_Type,
      ),
    );
  }
}

//**********************************
//**********************************
//**********************************

class Client_Groupe_Parc_Inter_ArticleDialog extends StatefulWidget {
  final VoidCallback onSaisie;
  final String art_Type;

  const Client_Groupe_Parc_Inter_ArticleDialog({
    Key? key,
    required this.onSaisie,
    required this.art_Type,
  }) : super(key: key);

  @override
  Client_Groupe_Parc_Inter_ArticleDialogState createState() => Client_Groupe_Parc_Inter_ArticleDialogState();
}

class Client_Groupe_Parc_Inter_ArticleDialogState extends State<Client_Groupe_Parc_Inter_ArticleDialog> {
  Widget wIco = Container();

  List<Widget> views = <Widget>[
    Text('Pièces Détachées'),
    Text('Catalogue Articles'),
  ];

  final List<bool> _selectedView = <bool>[true, false, false];



  final Search_TextController = TextEditingController();

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

  bool isProp = true;
  bool isRef = false;
  bool isGamme = false;
  bool isES = false;

  bool affEdtFilter = false;
  double icoWidth = 40;
  TextEditingController ctrlFilter = new TextEditingController();
  String filterText = '';
  static List<Parc_Art> searchParcs_Art = [];



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

    await Filtre();
  }

  Future Filtre() async {
    print("Client_Groupe_Parc_Inter_ArticleDialog filtre ${widget.art_Type} isGamme ${isGamme} isProp ${isProp} isES ${isES}");

    Srv_DbTools.ListArticle_Ebp.forEach((element) {
      element.Art_Sel = false;
    });

    if (isGamme) {
      Srv_DbTools.ListArticle_Ebpsearchresult.clear();
      for (int i = 0; i < Srv_DbTools.ListArticle_Ebp.length; i++) {
        Article_Ebp element = Srv_DbTools.ListArticle_Ebp[i];
        for (int i = 0; i < DbTools.glfNF074_Gammes.length; i++) {
          NF074_Gammes wNF074_Gammes = DbTools.glfNF074_Gammes[i];
          if (element.Article_codeArticle.compareTo(wNF074_Gammes.NF074_Gammes_REF) == 0) {
            bool trv = false;
            for (int j = 0; j < Srv_DbTools.ListArticle_Ebpsearchresult.length; j++) {
              Article_Ebp elementAdd = Srv_DbTools.ListArticle_Ebpsearchresult[j];
              if (elementAdd.Article_codeArticle.compareTo(wNF074_Gammes.NF074_Gammes_REF) == 0) trv = true;
            }
            if (!trv) Srv_DbTools.ListArticle_Ebpsearchresult.add(element);
          }
        }
      }
      setState(() {});
      return;
    }

    if (isES) {
      List<Article_Ebp> ListArtsearchresultTmp = [];
      Srv_DbTools.ListArticle_Ebpsearchresult.clear();
      ListArtsearchresultTmp.clear();
//      Srv_DbTools.ListArticle_Ebpsearchresult.addAll(Srv_DbTools.ListArticle_Ebp_ES);

      Parc_Art parc_Art = Parc_Art.Parc_ArtInit(DbTools.gParc_Ent.ParcsId!);
      String ParcsArt_Id = "";

      DbTools.lParcs_Art = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "ES");
      if (DbTools.lParcs_Art.length > 0) {
        parc_Art = DbTools.lParcs_Art[0];
        ParcsArt_Id = parc_Art.ParcsArt_Id!;
        print("parc_Art RECH ${parc_Art.toString()}");
      } else {
        ParcsArt_Id = Srv_DbTools.gArticle_EbpEnt.Article_codeArticle;
      }

      for (int i = 0; i < Srv_DbTools.ListArticle_Ebp_ES.length; i++) {
        Article_Ebp wArticle_Ebp = Srv_DbTools.ListArticle_Ebp_ES[i];
        if (wArticle_Ebp.Article_codeArticle.compareTo(ParcsArt_Id) == 0) {
          print("parc_Art trv");
          wArticle_Ebp.Art_Sel = true;
          ListArtsearchresultTmp.insert(0, wArticle_Ebp);
        } else
          ListArtsearchresultTmp.add(wArticle_Ebp);
      }

      if (Search_TextController.text.isEmpty) {
        Srv_DbTools.ListArticle_Ebpsearchresult.addAll(ListArtsearchresultTmp);
      } else {
        print("_buildFieldTextSearch liste ${Search_TextController.text}");
        ListArtsearchresultTmp.forEach((element) {
          if (element.Article_codeArticle.toLowerCase().contains(Search_TextController.text.toLowerCase())) {
            Srv_DbTools.ListArticle_Ebpsearchresult.add(element);
          }
        });
      }


      isRef = false;
      setState(() {});
      return;
    }



    print("Filtre isProp $isProp widget.art_Type ${widget.art_Type} ");
    print("Filtre ListResult_Article_Link_Verif_PROP ${Srv_DbTools.ListResult_Article_Link_Verif_PROP.length}");
    print("Filtre ListResult_Article_Link_Verif_PROP_Mixte ${Srv_DbTools.ListResult_Article_Link_Verif_PROP_Mixte.length}");

    if (isProp) {


      Srv_DbTools.ListArticle_Ebpsearchresult.clear();

      if (widget.art_Type.compareTo("P") == 0) {
        for (int i = 0; i < Srv_DbTools.ListArticle_Ebp.length; i++) {
          Article_Ebp element = Srv_DbTools.ListArticle_Ebp[i];

          for (int i = 0; i < Srv_DbTools.ListResult_Article_Link_Verif_PROP.length; i++) {
            Result_Article_Link_Verif wResult_Article_Link_Verif = Srv_DbTools.ListResult_Article_Link_Verif_PROP[i];
            if (element.Article_codeArticle.compareTo(wResult_Article_Link_Verif.ChildID) == 0) {
              Srv_DbTools.ListArticle_Ebpsearchresult.add(element);
              break;
            }
          }


        }
      }

      if (widget.art_Type.compareTo("M") == 0) {
        for (int i = 0; i < Srv_DbTools.ListArticle_Ebp.length; i++) {
          Article_Ebp element = Srv_DbTools.ListArticle_Ebp[i];
          for (int i = 0; i < Srv_DbTools.ListResult_Article_Link_Verif_PROP_Mixte.length; i++) {
            Result_Article_Link_Verif wResult_Article_Link_Verif = Srv_DbTools.ListResult_Article_Link_Verif_PROP_Mixte[i];
            if (element.Article_codeArticle.compareTo(wResult_Article_Link_Verif.ChildID) == 0) {
              Srv_DbTools.ListArticle_Ebpsearchresult.add(element);
              break;
            }
          }
        }
      }

      if (widget.art_Type.compareTo("Serv") == 0) {
        for (int i = 0; i < Srv_DbTools.ListArticle_Ebp.length; i++) {
          Article_Ebp element = Srv_DbTools.ListArticle_Ebp[i];
          for (int i = 0; i < Srv_DbTools.ListResult_Article_Link_Verif_PROP_Service.length; i++) {
            Result_Article_Link_Verif wResult_Article_Link_Verif = Srv_DbTools.ListResult_Article_Link_Verif_PROP_Service[i];
            if (element.Article_codeArticle.compareTo(wResult_Article_Link_Verif.ChildID) == 0) {
              Srv_DbTools.ListArticle_Ebpsearchresult.add(element);
              break;
            }
          }
        }
      }

      List<Article_Ebp> ListArtsearchresultTmp = [];
      ListArtsearchresultTmp.addAll(Srv_DbTools.ListArticle_Ebpsearchresult);
      Srv_DbTools.ListArticle_Ebpsearchresult.clear();

      print("Filtre isProp $isProp widget.art_Type ${ListArtsearchresultTmp.length} filterText ${filterText} ");


      if (filterText.isEmpty) {
        Srv_DbTools.ListArticle_Ebpsearchresult.addAll(ListArtsearchresultTmp);
      } else {
        print("_buildFieldTextSearch liste ${filterText}");
        ListArtsearchresultTmp.forEach((element) {
          String wComp = "${element.Article_codeArticle} ${element.Article_descriptionCommercialeEnClair}";
          if (wComp.toLowerCase().contains(filterText.toLowerCase())) {
            Srv_DbTools.ListArticle_Ebpsearchresult.add(element);
          }
        });
      }



      setState(() {});

      return;
    }

    List<Article_Ebp> ListArtsearchresultTmp = [];
    List<Article_Ebp> ListArtsearchresultTmpF = [];

    ListArtsearchresultTmp.clear();

    Srv_DbTools.ListArticle_Ebpsearchresult.clear();

    if (Search_TextController.text.isEmpty && FiltreSousFam.compareTo("Tous") == 0 && FiltreFam.compareTo("Tous") == 0) {
      print("TOUT VIDES");
//      await GetImage();

      setState(() {});

      return;
    }

    if (Search_TextController.text.isEmpty) {
      ListArtsearchresultTmp.addAll(Srv_DbTools.ListArticle_Ebp);
    } else {
      print("_buildFieldTextSearch liste ${Search_TextController.text}");

      Srv_DbTools.ListArticle_Ebp.forEach((element) {
        if (element.Article_codeArticle.toLowerCase().compareTo(Search_TextController.text.toLowerCase()) == 0) {
          ListArtsearchresultTmp.add(element);
        }
      });

      Srv_DbTools.ListArticle_Ebp.forEach((element) {
        if (element.Article_codeArticle.toLowerCase().contains(Search_TextController.text.toLowerCase())) {
          int index = ListArtsearchresultTmp.indexWhere((a) => a.Article_codeArticle.compareTo(element.Article_codeArticle) == 0);
          if (index < 0) {
            ListArtsearchresultTmp.add(element);
          }
        } else if (element.Article_descriptionCommercialeEnClair.toLowerCase().contains(Search_TextController.text.toLowerCase())) {
          int index = ListArtsearchresultTmp.indexWhere((a) => a.Article_codeArticle.compareTo(element.Article_codeArticle) == 0);
          if (index < 0) {
            ListArtsearchresultTmp.add(element);
          }
        }
      });
    }

    if (FiltreSousFam.compareTo("Tous") == 0 && FiltreFam.compareTo("Tous") == 0) {
      Srv_DbTools.ListArticle_Ebpsearchresult.addAll(ListArtsearchresultTmp);

      print("RECH et TOUS VIDES ${Srv_DbTools.ListArticle_Ebpsearchresult.length}");
//      await GetImage();

      setState(() {});
      return;
    }

    if (FiltreFam.compareTo("Tous") == 0) {
      print("Filtre ListArtsearchresultTmp ${ListArtsearchresultTmp.length}");

      ListArtsearchresultTmpF.addAll(ListArtsearchresultTmp);
    } else {
      ListArtsearchresultTmp.forEach((element) {
        if (FiltreFam.compareTo(element.Article_Fam) == 0) ListArtsearchresultTmpF.add(element);
      });
    }

    print("Filtre ListArtsearchresultTmpF ${ListArtsearchresultTmpF.length}");

    if (FiltreSousFam.compareTo("Tous") == 0) {
      Srv_DbTools.ListArticle_Ebpsearchresult.addAll(ListArtsearchresultTmpF);
    } else {
      ListArtsearchresultTmpF.forEach((element) {
        if (FiltreSousFam.compareTo(element.Article_Sous_Fam) == 0) Srv_DbTools.ListArticle_Ebpsearchresult.add(element);
      });
    }

    print("Filtre ListArticle_Ebpsearchresult ${Srv_DbTools.ListArticle_Ebpsearchresult.length}");

//    await GetImage();

    setState(() {});
  }

  @override
  void initLib() async {
    if (isGamme) {
      await Filtre();
      return;
    }

    Srv_DbTools.ListArticle_Ebp.forEach((element) {
      element.Art_Sel = false;
    });

    if (Srv_DbTools.REF_Lib.isNotEmpty) {
      isRef = true;
    } else {
      isRef = false;
    }

    print("ARTICLES ${Srv_DbTools.REF_Lib} => ${isRef}");

    if (!isRef) isProp = false;

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

    if (widget.art_Type.compareTo("G") == 0) {
      isGamme = true;
    } else if (widget.art_Type.compareTo("ES") == 0) {
      isES = true;
    }

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


    if (isProp)
      {
        wDialogHeight += 137;
        wDialogHeight -= 55;

      }
    if (isES) wDialogHeight -= 50;

    wLabel = 120;
    wDropdown = wDialogWidth - wLabel - 97;

    print("ARTICLES wDialogHeight $wDialogHeight");

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.white,
      backgroundColor: gColors.white,
      title: Container(
          color: gColors.white,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
          child: Column(
            children: [
              Text(
                "Articles ${widget.art_Type.compareTo("M") == 0 ? "Mixte" : widget.art_Type.compareTo("G") == 0 ? "Gammes" : "Pièces"}",
                textAlign: TextAlign.center,
                style: gColors.bodyTitle1_B_G_20,
              ),
              Container(
                height: 8,
              ),
            ],
          )),
      contentPadding: EdgeInsets.zero,
      content: Container(
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
                padding: const EdgeInsets.fromLTRB(5, 25, 5, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isProp ? Container() : DropdownFiltreFam(),
                    isProp
                        ? Container()
                        : Container(
                            height: 10,
                          ),
                    isProp ? Container() : DropdownFiltreSousFam(),
                    isProp
                        ? Container()
                        : Container(
                            height: 10,
                          ),
                    isProp ? Container() : _buildFieldTextSearch(),
                    isES ? _buildFieldTextSearch() : Container(),
                    isES
                        ? Container(
                            height: 10,
                          )
                        : Container(),
                    isProp
                        ? Container()
                        : Container(
                            height: 10,
                          ),
                    !isProp
                        ? Container()
                        : Entete_Btn_Search(),

                    buildDesc(context),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 30,
                        ),
                        Valider(context),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
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


          !isRef
              ? Container() :
          ToggleButtons(
            direction: Axis.horizontal,
            onPressed: (int index) async {
              for (int i = 0; i < _selectedView.length; i++) {
                _selectedView[i] = i == index;
                isProp = (index == 0);
                Filtre();
              }
            },
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            selectedBorderColor: Colors.white,
            selectedColor: Colors.white,
            fillColor: gColors.primary,
            color: gColors.primary,
            constraints: const BoxConstraints(
              minHeight: 36.0,
              minWidth: 160.0,
            ),
            isSelected: _selectedView,
            children: views,
          ),

          Spacer(),
          new ElevatedButton(
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
          new ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();

              DbTools.lParcs_Art = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, widget.art_Type);
              if (widget.art_Type.contains("G")) {
                print(" Saisie Article GGGGGGGGGGG ");
                for (int i = 0; i < Srv_DbTools.ListArticle_Ebpsearchresult.length; i++) {
                  Article_Ebp art = Srv_DbTools.ListArticle_Ebpsearchresult[i];
                  if (art.Art_Sel) {
                    Srv_DbTools.gArticle_EbpSelRef = art;
                    print(" Saisie Article GGGGGGGGGGG ${Srv_DbTools.gArticle_EbpSelRef.Article_codeArticle}");
                  }
                }
              } else if (widget.art_Type.contains("ES")) {


                print(" SES deleteParc_Art");

                // Effacement interne
                for (int i = 0; i < DbTools.lParcs_Art.length; i++) {
                  Parc_Art parc_Art = DbTools.lParcs_Art[i];
                  await DbTools.deleteParc_Art(parc_Art.ParcsArtId!);
                }

                // Effacement externe
                Parc_Ent wParc_Ent = await DbTools.getParcs_Ent_Parcs_UUID_Child(DbTools.gParc_Ent.Parcs_UUID!);
                print(" SES  deleteParc_EntTrigger}");
                if (wParc_Ent.Parcs_InterventionId != -1) {
                  await DbTools.deleteParc_EntTrigger(wParc_Ent.ParcsId!);
                }

                for (int i = 0; i < Srv_DbTools.ListArticle_Ebpsearchresult.length; i++) {
                  Article_Ebp art = Srv_DbTools.ListArticle_Ebpsearchresult[i];

                  if (art.Art_Sel) {

                    print(" SES Art_Sel ${art.toMap()}");


                    Parc_Art wParc_Art = Parc_Art.Parc_ArtInit(DbTools.gParc_Ent.ParcsId!);
                    wParc_Art.ParcsArt_Id = art.Article_codeArticle;
                    wParc_Art.ParcsArt_Type = widget.art_Type;
                    wParc_Art.ParcsArt_Lib = "${art.Article_descriptionCommercialeEnClair}";
                    wParc_Art.ParcsArt_Qte = 1;

                    print(" SES > insertParc_Art ${wParc_Art.toString()}");
                    await DbTools.insertParc_Art(wParc_Art);
                    print(" SES < insertParc_Art ");

                    List<Parc_Art> xParcs_Art = await DbTools.getParcs_Art_AllType(DbTools.gParc_Ent.ParcsId!);
                    for (int i = 0; i < xParcs_Art.length; i++) {
                      Parc_Art xparc_Art = xParcs_Art[i];
                      print(" SES xparc_Art ${xparc_Art.Desc()} ");
                    }



                    //Construction Parc_Ent
                    wParc_Ent = Parc_Ent.Parc_EntInit(Srv_DbTools.gIntervention.InterventionId!, DbTools.gParc_Ent.Parcs_Type!, DbTools.gParc_Ent.Parcs_order!);
                    wParc_Ent.Parcs_UUID_Parent = DbTools.gParc_Ent.Parcs_UUID;

                    wParc_Ent.Parcs_FREQ_Id = DbTools.gParc_Ent.Parcs_FREQ_Id;
                    wParc_Ent.Parcs_FREQ_Label = DbTools.gParc_Ent.Parcs_FREQ_Label;

                    wParc_Ent.Parcs_ANN_Id = DbTools.gParc_Ent.Parcs_ANN_Id;
                    DateTime now = DateTime.now();
                    String formattedDate = DateFormat('MM-yyyy').format(now);
                    wParc_Ent.Parcs_ANN_Label = formattedDate;

                    wParc_Ent.Parcs_NIV_Id = DbTools.gParc_Ent.Parcs_NIV_Id;
                    wParc_Ent.Parcs_NIV_Label = DbTools.gParc_Ent.Parcs_NIV_Label;
                    wParc_Ent.Parcs_ZNE_Id = DbTools.gParc_Ent.Parcs_ZNE_Id;
                    wParc_Ent.Parcs_ZNE_Label = DbTools.gParc_Ent.Parcs_ZNE_Label;
                    wParc_Ent.Parcs_EMP_Id = DbTools.gParc_Ent.Parcs_EMP_Id;
                    wParc_Ent.Parcs_EMP_Label = DbTools.gParc_Ent.Parcs_EMP_Label;

                    await DbTools.insertParc_Ent(wParc_Ent);

                    print(" SES  insertParc_Ent ${wParc_Ent.toString()}");
                    print("Set Article ${art.Article_descriptionCommercialeEnClair}");

                    for (int i = 0; i < DbTools.glfNF074_Gammes.length; i++) {
                      NF074_Gammes wNF074_Gammes = DbTools.glfNF074_Gammes[i];
                      if (art.Article_codeArticle.compareTo(wNF074_Gammes.NF074_Gammes_REF) == 0) {
                        print("Selection wParam_Gamme ${wNF074_Gammes.NF074_Gammes_CODF} gLastID ${DbTools.gLastID}");


                        print("Selection wParam_Gamme ${wNF074_Gammes.toMap()}");


                        List<Parc_Desc> wParcs_Desc = [];
                        wParcs_Desc.addAll(DbTools.glfParcs_Desc);

                        for (int i = 0; i < wParcs_Desc.length; i++) {
                          var element2 = wParcs_Desc[i];
                          element2.ParcsDesc_ParcsId = DbTools.gLastID;

                          if ((element2.ParcsDesc_Type!.compareTo("FREG") == 0) || (element2.ParcsDesc_Type!.compareTo("EMP") == 0) || (element2.ParcsDesc_Type!.compareTo("ZNE") == 0) || (element2.ParcsDesc_Type!.compareTo("NIV") == 0) || (element2.ParcsDesc_Type!.compareTo("ANN") == 0)) {
                            print("INSERT ParcsDesc_Type ${element2.ParcsDesc_Type} ParcsDesc_Id ${element2.ParcsDesc_Id} ParcsDesc_Lib ${element2.ParcsDesc_Lib}");
                            await DbTools.insertIntoParc_Desc(element2);
                          } else if (element2.ParcsDesc_Type!.compareTo("DESC") == 0) {
                            element2.ParcsDesc_Id = "";
                            element2.ParcsDesc_Lib = wNF074_Gammes.NF074_Gammes_DESC;
                            print("INSERT ParcsDesc_Type ${element2.ParcsDesc_Type} ParcsDesc_Id ${element2.ParcsDesc_Id} ParcsDesc_Lib ${element2.ParcsDesc_Lib}");
                            await DbTools.insertIntoParc_Desc(element2);
                          } else if (element2.ParcsDesc_Type!.compareTo("FAB") == 0) {
                            element2.ParcsDesc_Id = "";
                            element2.ParcsDesc_Lib = wNF074_Gammes.NF074_Gammes_FAB;
                            await DbTools.insertIntoParc_Desc(element2);
                          } else if (element2.ParcsDesc_Type!.compareTo("PRS") == 0) {
                            element2.ParcsDesc_Id = "";
                            element2.ParcsDesc_Lib = wNF074_Gammes.NF074_Gammes_PRS;
                            await DbTools.insertIntoParc_Desc(element2);
                          } else if (element2.ParcsDesc_Type!.compareTo("CLF") == 0) {
                            element2.ParcsDesc_Id = "";
                            element2.ParcsDesc_Lib = wNF074_Gammes.NF074_Gammes_CLF;
                            await DbTools.insertIntoParc_Desc(element2);
                          } else if (element2.ParcsDesc_Type!.compareTo("MOB") == 0) {
                            element2.ParcsDesc_Id = "";
                            element2.ParcsDesc_Lib = wNF074_Gammes.NF074_Gammes_MOB;
                            await DbTools.insertIntoParc_Desc(element2);
                          } else if (element2.ParcsDesc_Type!.compareTo("PDT") == 0) {
                            element2.ParcsDesc_Id = "";
                            element2.ParcsDesc_Lib = wNF074_Gammes.NF074_Gammes_PDT;
                            await DbTools.insertIntoParc_Desc(element2);
                          } else if (element2.ParcsDesc_Type!.compareTo("POIDS") == 0) {
                            element2.ParcsDesc_Id = "";
                            element2.ParcsDesc_Lib = wNF074_Gammes.NF074_Gammes_POIDS;
                            await DbTools.insertIntoParc_Desc(element2);
                          } else if (element2.ParcsDesc_Type!.compareTo("GAM") == 0) {
                            element2.ParcsDesc_Id = "";
                            element2.ParcsDesc_Lib = wNF074_Gammes.NF074_Gammes_GAM;
                            Srv_DbTools.GAM_ID = element2.ParcsDesc_Id.toString();
                            await DbTools.insertIntoParc_Desc(element2);
                          }
                        }
                      }
                    }
//                    await DbTools.Parc_Ent_List();
                    FBroadcast.instance().broadcast("Gen_Articles");
                  }
                }
              } else {
                for (int i = 0; i < Srv_DbTools.ListArticle_Ebpsearchresult.length; i++) {
                  Article_Ebp art = Srv_DbTools.ListArticle_Ebpsearchresult[i];
                  if (art.Art_Sel) {
                    bool Trv = false;
                    for (int i = 0; i < DbTools.lParcs_Art.length; i++) {
                      Parc_Art parc_Art = DbTools.lParcs_Art[i];
                      if (parc_Art.ParcsArt_Id!.compareTo(art.Article_codeArticle) == 0) {
//                        parc_Art.ParcsArt_Qte =  1;
                        //                      await DbTools.updateParc_Art(parc_Art);
                        Trv = true;
                        break;
                      }
                    }

                    if (!Trv) {
                      Parc_Art wParc_Art = Parc_Art.Parc_ArtInit(DbTools.gParc_Ent.ParcsId!);
                      wParc_Art.ParcsArt_Id = art.Article_codeArticle;
                      wParc_Art.ParcsArt_Type = widget.art_Type;
                      wParc_Art.ParcsArt_Lib = art.Article_descriptionCommercialeEnClair;
                      wParc_Art.ParcsArt_Qte = 1;
                      await DbTools.insertParc_Art(wParc_Art);
                    }
                  }
                }
              }

              print(" Saisie Article getParcs_Art > ");
              DbTools.lParcs_Art = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, widget.art_Type);
              print(" Saisie Article getParcs_Art < ");

              widget.onSaisie();
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

  Widget _buildFieldTextSearch() {
    return Container(
        decoration: BoxDecoration(
          color: gColors.greyDark,
          border: Border.all(
            color: gColors.greyDark,
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
              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              width: wDropdown - 1,
              height: 32,
              color: gColors.white,
              child: TextFormField(
                controller: Search_TextController,
                style: gColors.bodyTitle1_N_Gr,
                onChanged: (String? value) async {
//        Search_TextController.text = value!;
                  print("_buildFieldTextSearch search ${Search_TextController.text}");
                  Filtre();
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
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
          color: Colors.orange,
          border: Border.all(
            color: Colors.orange,
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
                  print(">>>>>>>>>>>>>>>>> FiltreSousFam ${FiltreSousFamID} ${FiltreSousFam}");
                  Filtre();
                });
              },

                  buttonStyleData:  ButtonStyleData(
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    height: 34,
                    width:  wDropdown,
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 32,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 750,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.orange,
                      ),
                      color: Colors.white,
                    ),
                  ),





            )),
          ),
        ]));
  }

  Widget DropdownFiltreSousFam() {
    if (ListParam_FiltreSousFam.length == 0) return Container();

    return Container(
        decoration: BoxDecoration(
          color: Colors.orange,
          border: Border.all(
            color: Colors.orange,
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
                  buttonStyleData:  ButtonStyleData(
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    height: 34,
                    width:  wDropdown,
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 32,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 750,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.orange,
                      ),
                      color: Colors.white,
                    ),
                  ),

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

    //print("buildDesc ListArticle_Ebpsearchresult ${Srv_DbTools.ListArticle_Ebpsearchresult.length}");

    List<Widget> RowSaisies = [];
    for (int i = 0; i < Srv_DbTools.ListArticle_Ebpsearchresult.length; i++) {
      Article_Ebp element = Srv_DbTools.ListArticle_Ebpsearchresult[i];

      //print("buildDesc ${element.Article_Libelle} ${element.Art_Sel}");

      RowSaisies.add(RowSaisie(element, LargeurCol, LargeurCol2, H2));
    }
    double wb = MediaQuery.of(context).viewInsets.bottom;
    double bas = 380 + wb;

    return Container(
      height: wDialogHeight - bas,
      width: 699,
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

  double IcoWidth = 40;

  Future<Image> GetImage(Article_Ebp art) async {
    if (art.wImgeTrv) return art.wImage!;

    if (art.Art_Sel || isProp) {
      String wImgPath = "${Srv_DbTools.SrvImg}ArticlesImg_Ebp_${art.Article_codeArticle}.jpg";
      gObj.pic = await gObj.networkImageToByte(wImgPath);
      if (gObj.pic.length > 0) {
        art.wImgeTrv = true;
        art.wImage = Image.memory(
          gObj.pic,
          fit: BoxFit.scaleDown,
          width: IcoWidth,
          height: IcoWidth,
        );
        return art.wImage!;
      }
    }
    return Image.asset(
      "assets/images/Audit_det.png",
      height: IcoWidth,
      width: IcoWidth,
    );
  }

  Widget buildImage(BuildContext context, Article_Ebp art) {
    return new FutureBuilder(
      future: GetImage(art),
      builder: (BuildContext context, AsyncSnapshot<Image> image) {
        if (image.hasData) {
          return image.data!;
        } else {
          return new Container(width: 30);
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


  @override
  Widget Entete_Btn_Search() {
    return Container(
        height: 57,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            width: 8,
          ),

          Spacer(),

          EdtFilterWidget(),
        ]));
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
