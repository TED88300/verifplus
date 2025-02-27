import 'dart:async';
import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles_Ebp.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles_Fam_Ebp.dart';

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
    String artType,
  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => Client_Groupe_Parc_Inter_ArticleDialog(
        onSaisie: onSaisie,
        art_Type: artType,
          isDevis : false,
      ),
    );
  }

  static Future<void> Dialogs_SaisieDevis(
      BuildContext context,
      VoidCallback onSaisie,
      String artType,
      ) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => Client_Groupe_Parc_Inter_ArticleDialog(
        onSaisie: onSaisie,
        art_Type: artType,
        isDevis : true,
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
  final bool isDevis;


  const Client_Groupe_Parc_Inter_ArticleDialog({
    Key? key,
    required this.onSaisie,
    required this.art_Type,
    required this.isDevis,

  }) : super(key: key);

  @override
  Client_Groupe_Parc_Inter_ArticleDialogState createState() => Client_Groupe_Parc_Inter_ArticleDialogState();
}

class Client_Groupe_Parc_Inter_ArticleDialogState extends State<Client_Groupe_Parc_Inter_ArticleDialog> {
  Widget wIco = Container();

  List<Widget> views = <Widget>[
    const Text('Pièces Détachées'),
    const Text('Catalogue Articles'),
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
  bool isSO = false;

  bool affEdtFilter = false;
  double icoWidth = 40;
  TextEditingController ctrlFilter = TextEditingController();
  String filterText = '';
  static List<Parc_Art> searchParcs_Art = [];



  Future Reload() async {
    ListParam_FiltreSousFam.clear();
    ListParam_FiltreSousFamID.clear();
    ListParam_FiltreSousFam.add("Tous");
    ListParam_FiltreSousFamID.add("");

    Srv_DbTools.ListArticle_Fam_Ebp_Fam.clear();
    for (int i = 0; i < Srv_DbTools.ListArticle_Fam_Ebp.length; i++) {
      Article_Fam_Ebp warticleFamEbp = Srv_DbTools.ListArticle_Fam_Ebp[i];
      if (warticleFamEbp.Article_Fam_Code_Parent.compareTo(FiltreFamID) == 0) {
        ListParam_FiltreSousFam.add(warticleFamEbp.Article_Fam_Libelle);
        ListParam_FiltreSousFamID.add(warticleFamEbp.Article_Fam_Code);
      }
    }
    FiltreSousFam = ListParam_FiltreSousFam[0];
    FiltreSousFamID = ListParam_FiltreSousFamID[0];

    await Filtre();
  }

  Future Filtre() async {
    print("Client_Groupe_Parc_Inter_ArticleDialog filtre ${widget.art_Type} isGamme $isGamme isProp $isProp isES $isES");

    for (var element in Srv_DbTools.ListArticle_Ebp) {
      element.Art_Sel = false;
    }

    if (isGamme) {
      Srv_DbTools.ListArticle_Ebpsearchresult.clear();
      for (int i = 0; i < Srv_DbTools.ListArticle_Ebp.length; i++) {
        Article_Ebp element = Srv_DbTools.ListArticle_Ebp[i];
        for (int i = 0; i < DbTools.glfNF074_Gammes.length; i++) {
          NF074_Gammes wnf074Gammes = DbTools.glfNF074_Gammes[i];
          if (element.Article_codeArticle.compareTo(wnf074Gammes.NF074_Gammes_REF) == 0) {
            bool trv = false;
            for (int j = 0; j < Srv_DbTools.ListArticle_Ebpsearchresult.length; j++) {
              Article_Ebp elementAdd = Srv_DbTools.ListArticle_Ebpsearchresult[j];
              if (elementAdd.Article_codeArticle.compareTo(wnf074Gammes.NF074_Gammes_REF) == 0) trv = true;
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

      Parc_Art parcArt = Parc_Art.Parc_ArtInit(DbTools.gParc_Ent.ParcsId!);
      String parcsartId = "";

      DbTools.lParcs_Art = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "ES");
      if (DbTools.lParcs_Art.isNotEmpty) {
        parcArt = DbTools.lParcs_Art[0];
        parcsartId = parcArt.ParcsArt_Id!;
        print("parc_Art RECH ${parcArt.toString()}");
      } else {
        parcsartId = Srv_DbTools.gArticle_EbpEnt.Article_codeArticle;
      }

      for (int i = 0; i < Srv_DbTools.ListArticle_Ebp_ES.length; i++) {
        Article_Ebp warticleEbp = Srv_DbTools.ListArticle_Ebp_ES[i];
        if (warticleEbp.Article_codeArticle.compareTo(parcsartId) == 0) {
          print("parc_Art trv");
          warticleEbp.Art_Sel = true;
          ListArtsearchresultTmp.insert(0, warticleEbp);
        } else {
          ListArtsearchresultTmp.add(warticleEbp);
        }
      }

      if (Search_TextController.text.isEmpty) {
        Srv_DbTools.ListArticle_Ebpsearchresult.addAll(ListArtsearchresultTmp);
      } else {
        print("_buildFieldTextSearch liste ${Search_TextController.text}");
        for (var element in ListArtsearchresultTmp) {
          if (element.Article_codeArticle.toLowerCase().contains(Search_TextController.text.toLowerCase())) {
            Srv_DbTools.ListArticle_Ebpsearchresult.add(element);
          }
        }
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
            Result_Article_Link_Verif wresultArticleLinkVerif = Srv_DbTools.ListResult_Article_Link_Verif_PROP[i];
            if (element.Article_codeArticle.compareTo(wresultArticleLinkVerif.ChildID) == 0) {
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
            Result_Article_Link_Verif wresultArticleLinkVerif = Srv_DbTools.ListResult_Article_Link_Verif_PROP_Mixte[i];
            if (element.Article_codeArticle.compareTo(wresultArticleLinkVerif.ChildID) == 0) {
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
            Result_Article_Link_Verif wresultArticleLinkVerif = Srv_DbTools.ListResult_Article_Link_Verif_PROP_Service[i];
            if (element.Article_codeArticle.compareTo(wresultArticleLinkVerif.ChildID) == 0) {
              Srv_DbTools.ListArticle_Ebpsearchresult.add(element);
              break;
            }
          }
        }
      }

      List<Article_Ebp> ListArtsearchresultTmp = [];
      ListArtsearchresultTmp.addAll(Srv_DbTools.ListArticle_Ebpsearchresult);
      Srv_DbTools.ListArticle_Ebpsearchresult.clear();

      print("Filtre isProp $isProp widget.art_Type ${ListArtsearchresultTmp.length} filterText $filterText ");


      if (filterText.isEmpty) {
        Srv_DbTools.ListArticle_Ebpsearchresult.addAll(ListArtsearchresultTmp);
      } else {
        print("_buildFieldTextSearch liste $filterText");
        for (var element in ListArtsearchresultTmp) {
          String wComp = "${element.Article_codeArticle} ${element.Article_descriptionCommercialeEnClair}";
          if (wComp.toLowerCase().contains(filterText.toLowerCase())) {
            Srv_DbTools.ListArticle_Ebpsearchresult.add(element);
          }
        }
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

      for (var element in Srv_DbTools.ListArticle_Ebp) {
        if (element.Article_codeArticle.toLowerCase().compareTo(Search_TextController.text.toLowerCase()) == 0) {
          ListArtsearchresultTmp.add(element);
        }
      }

      for (var element in Srv_DbTools.ListArticle_Ebp) {
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
      }
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
      for (var element in ListArtsearchresultTmp) {
        if (FiltreFam.compareTo(element.Article_Fam) == 0) ListArtsearchresultTmpF.add(element);
      }
    }

    print("Filtre ListArtsearchresultTmpF ${ListArtsearchresultTmpF.length}");

    if (FiltreSousFam.compareTo("Tous") == 0) {
      Srv_DbTools.ListArticle_Ebpsearchresult.addAll(ListArtsearchresultTmpF);
    } else {
      for (var element in ListArtsearchresultTmpF) {
        if (FiltreSousFam.compareTo(element.Article_Sous_Fam) == 0) Srv_DbTools.ListArticle_Ebpsearchresult.add(element);
      }
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

    for (var element in Srv_DbTools.ListArticle_Ebp) {
      element.Art_Sel = false;
    }

    if (Srv_DbTools.REF_Lib.isNotEmpty) {
      isRef = true;
    } else {
      isRef = false;
    }

    print("ARTICLES ${Srv_DbTools.REF_Lib} => $isRef");

    if (!isRef) isProp = false;

    ListParam_FiltreFam.clear();
    ListParam_FiltreFamID.clear();
    ListParam_FiltreFam.add("Tous");
    ListParam_FiltreFamID.add("");

    Srv_DbTools.ListArticle_Fam_Ebp_Fam.clear();
    for (int i = 0; i < Srv_DbTools.ListArticle_Fam_Ebp.length; i++) {
      Article_Fam_Ebp warticleFamEbp = Srv_DbTools.ListArticle_Fam_Ebp[i];
      if (warticleFamEbp.Article_Fam_Code_Parent.isEmpty) {
        ListParam_FiltreFam.add(warticleFamEbp.Article_Fam_Libelle);
        ListParam_FiltreFamID.add(warticleFamEbp.Article_Fam_Code);
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
    else if (widget.art_Type.compareTo("SO") == 0) {
      isSO = true;
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

    if (isSO) isProp = false;

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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.white,
      backgroundColor: gColors.white,
      title: Container(
          color: gColors.white,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
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
              const Spacer(),
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


          !isRef || isSO
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

              if (widget.art_Type.contains("SO")) {
                print(" Saisie Article SOSOSOSOSOS ");

                for (int i = 0; i < Srv_DbTools.ListArticle_Ebpsearchresult.length; i++) {
                  Article_Ebp art = Srv_DbTools.ListArticle_Ebpsearchresult[i];
                  if (art.Art_Sel) {
                    print(" Saisie Article SOSOSOSOSOS ${art.Article_codeArticle}");


                    Parc_Art wparcArt = Parc_Art.Parc_ArtInit(Srv_DbTools.gIntervention.InterventionId);
                    wparcArt.ParcsArt_Id = art.Article_codeArticle;
                    wparcArt.ParcsArt_Type = widget.art_Type;
                    wparcArt.ParcsArt_Lib = "SO ${art.Article_descriptionCommercialeEnClair}";
                    wparcArt.ParcsArt_Qte = 1;
                    wparcArt.ParcsArt_lnk = "SO";
                    if(widget.isDevis)
                      {
                        wparcArt.ParcsArt_Fact = "Devis";
                        wparcArt.ParcsArt_Livr = "Reliquat";

                      }
                    print(" SOSOSOSOSOS > insertParc_Art ${wparcArt.toString()}");
                    await DbTools.insertParc_Art(wparcArt);


                  }
                }
                Navigator.of(context).pop();
                return;
              }

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
                  Parc_Art parcArt = DbTools.lParcs_Art[i];
                  await DbTools.deleteParc_Art(parcArt.ParcsArtId!);
                }

                // Effacement externe
                Parc_Ent wparcEnt = await DbTools.getParcs_Ent_Parcs_UUID_Child(DbTools.gParc_Ent.Parcs_UUID!);
                print(" SES  deleteParc_EntTrigger}");
                if (wparcEnt.Parcs_InterventionId != -1) {
                  await DbTools.deleteParc_EntTrigger(wparcEnt.ParcsId!);
                }

                for (int i = 0; i < Srv_DbTools.ListArticle_Ebpsearchresult.length; i++) {
                  Article_Ebp art = Srv_DbTools.ListArticle_Ebpsearchresult[i];

                  if (art.Art_Sel) {

                    print(" SES Art_Sel ${art.toMap()}");
                    DbTools.gParc_Ent.Parcs_CodeArticleES =  art.Article_codeArticle;
                    DbTools.updateParc_Ent(DbTools.gParc_Ent);


                    Parc_Art wparcArt = Parc_Art.Parc_ArtInit(DbTools.gParc_Ent.ParcsId!);
                    wparcArt.ParcsArt_Id = art.Article_codeArticle;
                    wparcArt.ParcsArt_Type = widget.art_Type;
                    wparcArt.ParcsArt_Lib = art.Article_descriptionCommercialeEnClair;
                    wparcArt.ParcsArt_Qte = 1;

                    print(" SES > insertParc_Art ${wparcArt.toString()}");
                    await DbTools.insertParc_Art(wparcArt);
                    print(" SES < insertParc_Art ");

                    List<Parc_Art> xparcsArt = await DbTools.getParcs_Art_AllType(DbTools.gParc_Ent.ParcsId!);
                    for (int i = 0; i < xparcsArt.length; i++) {
                      Parc_Art xparcArt = xparcsArt[i];
                      print(" SES xparc_Art ${xparcArt.Desc()} ");
                    }



                    //Construction Parc_Ent
                    wparcEnt = Parc_Ent.Parc_EntInit(Srv_DbTools.gIntervention.InterventionId, DbTools.gParc_Ent.Parcs_Type!, DbTools.gParc_Ent.Parcs_order!);
                    wparcEnt.Parcs_UUID_Parent = DbTools.gParc_Ent.Parcs_UUID;

                    wparcEnt.Parcs_FREQ_Id = DbTools.gParc_Ent.Parcs_FREQ_Id;
                    wparcEnt.Parcs_FREQ_Label = DbTools.gParc_Ent.Parcs_FREQ_Label;

                    wparcEnt.Parcs_ANN_Id = DbTools.gParc_Ent.Parcs_ANN_Id;
                    DateTime now = DateTime.now();
                    String formattedDate = DateFormat('MM-yyyy').format(now);
                    wparcEnt.Parcs_ANN_Label = formattedDate;
                    wparcEnt.Parcs_FAB_Label = formattedDate;

                    wparcEnt.Parcs_NIV_Id = DbTools.gParc_Ent.Parcs_NIV_Id;
                    wparcEnt.Parcs_NIV_Label = DbTools.gParc_Ent.Parcs_NIV_Label;
                    wparcEnt.Parcs_ZNE_Id = DbTools.gParc_Ent.Parcs_ZNE_Id;
                    wparcEnt.Parcs_ZNE_Label = DbTools.gParc_Ent.Parcs_ZNE_Label;
                    wparcEnt.Parcs_EMP_Id = DbTools.gParc_Ent.Parcs_EMP_Id;
                    wparcEnt.Parcs_EMP_Label = DbTools.gParc_Ent.Parcs_EMP_Label;

                    wparcEnt.Parcs_CodeArticle =  art.Article_codeArticle;
                    DbTools.updateParc_Ent(DbTools.gParc_Ent);



                    await DbTools.insertParc_Ent(wparcEnt);

                    print(" SES  insertParc_Ent ${wparcEnt.toString()}");
                    print("Set Article ${art.Article_descriptionCommercialeEnClair}");

                    for (int i = 0; i < DbTools.glfNF074_Gammes.length; i++) {
                      NF074_Gammes wnf074Gammes = DbTools.glfNF074_Gammes[i];
                      if (art.Article_codeArticle.compareTo(wnf074Gammes.NF074_Gammes_REF) == 0) {
                        print("Selection wParam_Gamme ${wnf074Gammes.NF074_Gammes_CODF} gLastID ${DbTools.gLastID}");


                        print("Selection wParam_Gamme ${wnf074Gammes.toMap()}");


                        List<Parc_Desc> wparcsDesc = [];
                        wparcsDesc.addAll(DbTools.glfParcs_Desc);

                        for (int i = 0; i < wparcsDesc.length; i++) {
                          var element2 = wparcsDesc[i];
                          element2.ParcsDesc_ParcsId = DbTools.gLastID;

                          if ((element2.ParcsDesc_Type!.compareTo("FREG") == 0) || (element2.ParcsDesc_Type!.compareTo("EMP") == 0) || (element2.ParcsDesc_Type!.compareTo("ZNE") == 0) || (element2.ParcsDesc_Type!.compareTo("NIV") == 0) || (element2.ParcsDesc_Type!.compareTo("ANN") == 0)) {
                            print("INSERT ParcsDesc_Type ${element2.ParcsDesc_Type} ParcsDesc_Id ${element2.ParcsDesc_Id} ParcsDesc_Lib ${element2.ParcsDesc_Lib}");
                            await DbTools.insertIntoParc_Desc(element2);
                          } else if (element2.ParcsDesc_Type!.compareTo("DESC") == 0) {
                            element2.ParcsDesc_Id = "";
                            element2.ParcsDesc_Lib = wnf074Gammes.NF074_Gammes_DESC;
                            print("INSERT ParcsDesc_Type ${element2.ParcsDesc_Type} ParcsDesc_Id ${element2.ParcsDesc_Id} ParcsDesc_Lib ${element2.ParcsDesc_Lib}");
                            await DbTools.insertIntoParc_Desc(element2);
                          } else if (element2.ParcsDesc_Type!.compareTo("FAB") == 0) {
                            element2.ParcsDesc_Id = "";
                            element2.ParcsDesc_Lib = wnf074Gammes.NF074_Gammes_FAB;
                            await DbTools.insertIntoParc_Desc(element2);
                          } else if (element2.ParcsDesc_Type!.compareTo("PRS") == 0) {
                            element2.ParcsDesc_Id = "";
                            element2.ParcsDesc_Lib = wnf074Gammes.NF074_Gammes_PRS;
                            await DbTools.insertIntoParc_Desc(element2);
                          } else if (element2.ParcsDesc_Type!.compareTo("CLF") == 0) {
                            element2.ParcsDesc_Id = "";
                            element2.ParcsDesc_Lib = wnf074Gammes.NF074_Gammes_CLF;
                            await DbTools.insertIntoParc_Desc(element2);
                          } else if (element2.ParcsDesc_Type!.compareTo("MOB") == 0) {
                            element2.ParcsDesc_Id = "";
                            element2.ParcsDesc_Lib = wnf074Gammes.NF074_Gammes_MOB;
                            await DbTools.insertIntoParc_Desc(element2);
                          } else if (element2.ParcsDesc_Type!.compareTo("PDT") == 0) {
                            element2.ParcsDesc_Id = "";
                            element2.ParcsDesc_Lib = wnf074Gammes.NF074_Gammes_PDT;
                            await DbTools.insertIntoParc_Desc(element2);
                          } else if (element2.ParcsDesc_Type!.compareTo("POIDS") == 0) {
                            element2.ParcsDesc_Id = "";
                            element2.ParcsDesc_Lib = wnf074Gammes.NF074_Gammes_POIDS;
                            await DbTools.insertIntoParc_Desc(element2);
                          } else if (element2.ParcsDesc_Type!.compareTo("GAM") == 0) {
                            element2.ParcsDesc_Id = "";
                            element2.ParcsDesc_Lib = wnf074Gammes.NF074_Gammes_GAM;
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
                      Parc_Art parcArt = DbTools.lParcs_Art[i];
                      if (parcArt.ParcsArt_Id!.compareTo(art.Article_codeArticle) == 0) {
//                        parc_Art.ParcsArt_Qte =  1;
                        //                      await DbTools.updateParc_Art(parc_Art);
                        Trv = true;
                        break;
                      }
                    }

                    if (!Trv) {
                      Parc_Art wparcArt = Parc_Art.Parc_ArtInit(DbTools.gParc_Ent.ParcsId!);
                      wparcArt.ParcsArt_Id = art.Article_codeArticle;
                      wparcArt.ParcsArt_Type = widget.art_Type;
                      wparcArt.ParcsArt_Lib = art.Article_descriptionCommercialeEnClair;
                      wparcArt.ParcsArt_Qte = 1;
                      await DbTools.insertParc_Art(wparcArt);
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
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
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
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ],
        ));
  }

  Widget DropdownFiltreFam() {
    if (ListParam_FiltreFam.isEmpty) return Container();

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
                      "  $item",
                      style: gColors.bodyTitle1_N_Gr,
                    ),
                  )).toList(),
              value: FiltreFam,
              onChanged: (value) {
                setState(() {
                  String sValue = value as String;
                  FiltreFamID = ListParam_FiltreFamID[ListParam_FiltreFam.indexOf(sValue)];
                  FiltreFam = value;
                  print(">>>>>>>>>>>>>>>>> FiltreFam $FiltreFamID $FiltreFam");

                  ListParam_FiltreSousFam.clear();
                  ListParam_FiltreSousFamID.clear();
                  ListParam_FiltreSousFam.add("Tous");
                  ListParam_FiltreSousFamID.add("*");
                  Srv_DbTools.ListArticle_Fam_Ebp_Fam.clear();
                  for (int i = 0; i < Srv_DbTools.ListArticle_Fam_Ebp.length; i++) {
                    Article_Fam_Ebp warticleFamEbp = Srv_DbTools.ListArticle_Fam_Ebp[i];
                    if (warticleFamEbp.Article_Fam_Code_Parent.compareTo(FiltreFamID) == 0) {
                      ListParam_FiltreSousFam.add(warticleFamEbp.Article_Fam_Libelle);
                      ListParam_FiltreSousFamID.add(warticleFamEbp.Article_Fam_Code);
                    }
                  }
                  FiltreSousFam = ListParam_FiltreSousFam[0];
                  FiltreSousFamID = ListParam_FiltreSousFamID[0];
                  print(">>>>>>>>>>>>>>>>> FiltreSousFam $FiltreSousFamID $FiltreSousFam");
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
    if (ListParam_FiltreSousFam.isEmpty) return Container();

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
                      "  $item",
                      style: gColors.bodyTitle1_N_Gr,
                    ),
                  )).toList(),
              value: FiltreSousFam,
              onChanged: (value) {
                String sValue = value as String;

                FiltreSousFamID = ListParam_FiltreSousFam[ListParam_FiltreSousFam.indexOf(sValue)];
                FiltreSousFam = value;
                print("FiltreSousFam $FiltreSousFamID $FiltreSousFam");

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

    return SizedBox(
      height: wDialogHeight - bas,
      width: 699,
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 1, 0, 0),
        color: gColors.greyDark,
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
      await Srv_DbTools.getArticlesImg_Ebp( art.Article_codeArticle);
      gObj.pic = base64Decode(Srv_DbTools.gArticlesImg_Ebp.ArticlesImg_Image);
      if (gObj.pic.isNotEmpty) {
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
    return FutureBuilder(
      future: GetImage(art),
      builder: (BuildContext context, AsyncSnapshot<Image> image) {
        if (image.hasData) {
          return image.data!;
        } else {
          return Container(width: 30);
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


  @override
  Widget Entete_Btn_Search() {
    return SizedBox(
        height: 57,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            width: 8,
          ),

          const Spacer(),

          EdtFilterWidget(),
        ]));
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
