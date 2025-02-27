import 'dart:async';

import 'package:flutter/material.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles_Ebp.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles_Fam_Ebp.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Groupes.dart';
import 'package:verifplus/Tools/DbSrv/Srv_ImportExport.dart';
import 'package:verifplus/Tools/DbSrv/Srv_NF074.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Av.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Param.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie_Param.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Planning.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Sites.dart';
import 'package:verifplus/Tools/DbSrv/Srv_User_Desc.dart';
import 'package:verifplus/Tools/DbSrv/Srv_User_Hab.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Zones.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';

import '../Tools/DbTools/Db_Param_Av.dart';

class Import_Data_Dialog {
  Import_Data_Dialog();

  static Future<void> Dialogs_Saisie(
    BuildContext context,
    VoidCallback onSaisie,
    String ImportType,
  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => Import_DataDialog(
        onSaisie: onSaisie,
        ImportType: ImportType,
      ),
    );
  }
}

//**********************************
//**********************************
//**********************************

class Import_DataDialog extends StatefulWidget {
  final VoidCallback onSaisie;
  final String ImportType;

  const Import_DataDialog({
    Key? key,
    required this.onSaisie,
    required this.ImportType,
  }) : super(key: key);

  @override
  Import_DataDialogState createState() => Import_DataDialogState();
}

class Import_DataDialogState extends State<Import_DataDialog> with TickerProviderStateMixin {
  late AnimationController acontroller;
  bool iStrfExp = false;

  String wSt = "début";


  static List<String> List_UserInter = [];
  static List<String> List_UserInterID = [];


  Future Reload_Listing() async {

    //**********************************
    //**********************************
    //**********************************

    setState(() {
      acontroller.forward();
      acontroller.repeat(reverse: true);
      iStrfExp = true;
      wSt = "◉◉◉ ${widget.ImportType}\n";
    });



    //**********************************
    //**********************************
    //**********************************

    await Srv_ImportExport.ImportClient();
    setState(() {
      wSt += "► Client : ${Srv_DbTools.ListClient.length} Clients\n";
    });

    //**********************************
    //**********************************
    //**********************************
    await Srv_ImportExport.ImportAdresse();
    setState(() {
      wSt += "► Adresse : ${Srv_DbTools.ListAdresse.length} Adresses\n";
    });
    
    //**********************************
    //**********************************
    //**********************************
    await Srv_ImportExport.ImportContact();
    setState(() {
      wSt += "► Contact : ${Srv_DbTools.ListContact.length} Contacts\n";
    });

    //**********************************
    //**********************************
    //**********************************

    await Srv_DbTools.getPlanning_All();
    print("Import_DataDialog ListPlanning ${Srv_DbTools.ListPlanning.length}");
    await DbTools.TrunckPlanning();
    for (int i = 0; i < Srv_DbTools.ListPlanning.length; i++) {
      Planning wPlanning = Srv_DbTools.ListPlanning[i];
      await DbTools.inserPlanning(wPlanning);
    }
    Srv_DbTools.ListPlanning = await  DbTools.getPlanningAll();
    print("Import_DataDialog Srv_DbTools.ListPlanning ${Srv_DbTools.ListPlanning}");
    setState(() {
      wSt += "► Planning : ${Srv_DbTools.ListPlanning.length} Plannings\n";
    });

    //**********************************
    //**********************************
    //**********************************

    await Srv_DbTools.getGroupeAll();
    print("Import_DataDialog ListGroupe ${Srv_DbTools.ListGroupe.length}");
    await DbTools.TrunckGroupes();
    for (int i = 0; i < Srv_DbTools.ListGroupe.length; i++) {
      Groupe wGroupe = Srv_DbTools.ListGroupe[i];
      await DbTools.inserGroupes(wGroupe);
    }
    Srv_DbTools.ListGroupe = await  DbTools.getGroupesAll();
    print("Import_DataDialog Srv_DbTools.ListGroupe ${Srv_DbTools.ListGroupe}");
    setState(() {
      wSt += "► Groupe : ${Srv_DbTools.ListGroupe.length} Groupes\n";
    });

    //**********************************
    //**********************************
    //**********************************

    await Srv_DbTools.getSiteAll();
    print("Import_DataDialog ListSite ${Srv_DbTools.ListSite.length}");
    await DbTools.TrunckSites();
    for (int i = 0; i < Srv_DbTools.ListSite.length; i++) {
      Site wSite = Srv_DbTools.ListSite[i];
      await DbTools.inserSites(wSite);
    }

    Srv_DbTools.ListSite = await  DbTools.getSitesAll();
    setState(() {
      wSt += "► Site : ${Srv_DbTools.ListSite.length} Sites\n";
    });


    //**********************************
    //**********************************
    //**********************************

    await Srv_DbTools.getZoneAll();
    print("Import_DataDialog ListZone ${Srv_DbTools.ListZone.length}");
    await DbTools.TrunckZones();
    for (int i = 0; i < Srv_DbTools.ListZone.length; i++) {
      Zone wZone = Srv_DbTools.ListZone[i];
      await DbTools.inserZones(wZone);
    }
    Srv_DbTools.ListZone = await  DbTools.getZonesAll();
    print("Import_DataDialog Srv_DbTools.ListZone ${Srv_DbTools.ListZone}");
    setState(() {
      wSt += "► Zone : ${Srv_DbTools.ListZone.length} Zones\n";
    });


    await Srv_ImportExport.ImportIntervention();
    setState(() {
      wSt += "► Intervention : ${Srv_DbTools.ListIntervention.length} Interventions\n";
    });


    //**********************************
    //**********************************
    //**********************************

    await Srv_ImportExport.ImportPlanning_Intervention();
    setState(() {
      wSt += "► Planning_Intervention : ${Srv_DbTools.ListPlanning_Intervention.length} Interventions\n";
    });

    //**********************************
    //**********************************
    //**********************************

    
    
    await Srv_ImportExport.ImportInterMission();
    setState(() {
      wSt += "► InterMission : ${Srv_DbTools.ListInterMission.length} InterMissions\n";
    });


    //**********************************
    //**********************************
    //**********************************

    await Srv_ImportExport.ImportUsers();
    Srv_DbTools.List_UserInter.clear();
    Srv_DbTools.List_UserInterID.clear();

    for (int i = 0; i < Srv_DbTools.ListUser.length; i++) {
      var element = Srv_DbTools.ListUser[i];
      Srv_DbTools.List_UserInter.add("${element.User_Nom} ${element.User_Prenom}");
      Srv_DbTools.List_UserInterID.add("${element.UserID}");
    }
    setState(() {
      wSt += "► User : ${Srv_DbTools.ListUser.length} Utilisateurs\n";
    });

    //**********************************
    //**********************************
    //**********************************

    await Srv_ImportExport.ImportDCL_Ent();
    setState(() {
      wSt += "► Devis Ent : ${Srv_DbTools.ListDCL_Ent.length} DCL_Ent\n";
    });

    await Srv_ImportExport.ImportDCL_Det();
    setState(() {
      wSt += "► Devis Det : ${Srv_DbTools.ListDCL_Det.length} DCL_Det\n";
    });

    //**********************************
    //**********************************
    //**********************************

    setState(() {
      acontroller.stop();
      iStrfExp = false;
    });
  }

  Future Reload_Param() async {

    //**********************************
    //**********************************
    //**********************************

    setState(() {
      acontroller.forward();
      acontroller.repeat(reverse: true);
      iStrfExp = true;
      wSt = "◉◉◉ ${widget.ImportType}\n";
    });

    //***********************************
    //***********************************
    //***********************************


    await Srv_DbTools.getParam_SaisieAll();
    print("Import_DataDialog ListParam_Saisie ${Srv_DbTools.ListParam_Saisie.length}");
    await DbTools.TrunckParam_Saisie();
    for (int i = 0; i < Srv_DbTools.ListParam_Saisie.length; i++) {
      Param_Saisie wparamSaisie = Srv_DbTools.ListParam_Saisie[i];

      print(" Import_DataDialog wParam_Saisie ${wparamSaisie.Param_Saisie_Type} ${wparamSaisie.Param_Saisie_Triger}");

      await DbTools.inserParam_Saisie(wparamSaisie);
    }


    Srv_DbTools.ListParam_Saisie = await  DbTools.getParam_SaisieAll();
    print("Import_DataDialog Srv_DbTools.ListParam_Saisie ${Srv_DbTools.ListParam_Saisie}");
    setState(() {
      wSt += "► Param_Saisie : ${Srv_DbTools.ListParam_Saisie.length} Params\n";
    });

    //***********************************
    //***********************************
    //***********************************


    await Srv_DbTools.getParam_ParamAll();
    print("Import_DataDialog ListParam_ParamAll ${Srv_DbTools.ListParam_ParamAll.length}");
    await DbTools.TrunckParam_Param();
    for (int i = 0; i < Srv_DbTools.ListParam_ParamAll.length; i++) {
      Param_Param wparamParam = Srv_DbTools.ListParam_ParamAll[i];
      await DbTools.inserParam_Param(wparamParam);
    }

    Srv_DbTools.ListParam_ParamAll = await  DbTools.getParam_Param();
    print("Import_DataDialog Srv_DbTools.ListParam_ParamAll ${Srv_DbTools.ListParam_ParamAll}");
    setState(() {
      wSt += "► Param_Param : ${Srv_DbTools.ListParam_ParamAll.length} Params\n";
    });

    DbTools.genParam();

    //***********************************
    //***********************************
    //***********************************

    await Srv_DbTools.getParam_Saisie_ParamAll();
    print("Import_DataDialog ListParam_Saisie_ParamAll ${Srv_DbTools.ListParam_Saisie_ParamAll.length}");
    await DbTools.TrunckParam_Saisie_Param();
    for (int i = 0; i < Srv_DbTools.ListParam_Saisie_ParamAll.length; i++) {
      Param_Saisie_Param wparamSaisieParam = Srv_DbTools.ListParam_Saisie_ParamAll[i];
      await DbTools.inserParam_Saisie_Param(wparamSaisieParam);
    }
    Srv_DbTools.ListParam_Saisie_ParamAll = await  DbTools.getParam_Saisie_ParamAll();

    print("Import_DataDialog Srv_DbTools.ListParam_Saisie_ParamAll ${Srv_DbTools.ListParam_Saisie_ParamAll}");
    setState(() {
      wSt += "► Param_Saisie_Param : ${Srv_DbTools.ListParam_Saisie_ParamAll.length} Params\n";
    });

    //***********************************
    //***********************************
    //***********************************


    await Srv_DbTools.getParam_Av(Srv_DbTools.gUserLogin.UserID);
    print("Import_DataDialog ListParam_Av ${Srv_DbTools.ListParam_Av.length}");

    await DbTools.TrunckParam_Av();
    for (int i = 0; i < Srv_DbTools.ListParam_Av.length; i++) {
      SrvParam_Av wparamAv = Srv_DbTools.ListParam_Av[i];
      await DbTools.inserParam_Av(wparamAv);
    }

    List<Param_Av> listparamAv = await  DbTools.getParam_Av();
    print("Import_DataDialog Srv_DbTools.ListParam_Av ${listparamAv.length}");
    setState(() {
      wSt += "► Param_Av : ${listparamAv.length} Params\n";
    });


    //***********************************
    //***********************************
    //***********************************

    await Srv_DbTools.getUser_Hab(Srv_DbTools.gUserLogin.UserID);
    print("Import_DataDialog ListUser_Hab ${Srv_DbTools.ListUser_Hab.length}");

    await DbTools.TrunckUser_Hab();
    for (int i = 0; i < Srv_DbTools.ListUser_Hab.length; i++) {
      User_Hab wuserHab = Srv_DbTools.ListUser_Hab[i];
      await DbTools.inserUser_Hab(wuserHab);
    }
    Srv_DbTools.ListUser_Hab = await  DbTools.getUser_Hab();
    print("Import_DataDialog Srv_DbTools.ListUser_Hab ${Srv_DbTools.ListUser_Hab}");
    setState(() {
      wSt += "► User_Hab : ${Srv_DbTools.ListUser_Hab.length} Params\n";
    });

    

    await Srv_DbTools.getUser_Desc(Srv_DbTools.gUserLogin.UserID);
    print("Import_DataDialog ListUser_Desc ${Srv_DbTools.ListUser_Desc.length}");

    await DbTools.TrunckUser_Desc();
    for (int i = 0; i < Srv_DbTools.ListUser_Desc.length; i++) {
      User_Desc wuserDesc = Srv_DbTools.ListUser_Desc[i];
      await DbTools.inserUser_Desc(wuserDesc);
    }
    Srv_DbTools.ListUser_Desc = await  DbTools.getUser_Desc();
    print("Import_DataDialog Srv_DbTools.ListUser_Desc ${Srv_DbTools.ListUser_Desc}");
    setState(() {
      wSt += "► User_Desc : ${Srv_DbTools.ListUser_Desc.length} Params\n";
    });



    //**********************************
    //**********************************
    //**********************************

    setState(() {
      acontroller.stop();
      iStrfExp = false;
    });
  }

  Future Reload_NF74() async {

    //**********************************
    //**********************************
    //**********************************

    setState(() {
      acontroller.forward();
      acontroller.repeat(reverse: true);
      iStrfExp = true;
      wSt = "◉◉◉ ${widget.ImportType}\n";
    });



    //***********************************
    //***********************************
    //***********************************

/*
    await Srv_DbTools.IMPORT_ArticlesImg_Ebp(500, 0);
    print("Import_DataDialog ListArticlesImg_Ebp ${Srv_DbTools.ListArticlesImg_Ebp.length}");

    setState(() {
      wSt += "► ${Srv_DbTools.ListArticlesImg_Ebp.length} IMAGES Articles EBP\n";
    });
return;
*/

    await Srv_DbTools.IMPORT_Srv_RIA_Gammes();
    print("IMPORT_DataDialog ListRIA_Gammes ${Srv_DbTools.ListRIA_Gammes.length}");
    DbTools.TrunckRIA_Gammes();
    for (int i = 0; i < Srv_DbTools.ListRIA_Gammes.length; i++) {
      RIA_Gammes wriaGammes = Srv_DbTools.ListRIA_Gammes[i];
      DbTools.insertRIA_Gammes(wriaGammes);
    }
    DbTools.glfRIA_Gammes = await  DbTools.getRIA_Gammes();
    print("IMPORT_DataDialog glfRIA_Gammes ${DbTools.glfRIA_Gammes.length}");
    setState(() {
      wSt += "► RIA : ${DbTools.glfRIA_Gammes.length} Gammes\n";
    });

    await Srv_DbTools.IMPORT_Srv_NF074_Gammes();
    print("IMPORT_DataDialog ListNF074_Gammes ${Srv_DbTools.ListNF074_Gammes.length}");
    DbTools.TrunckNF074_Gammes();
    for (int i = 0; i < Srv_DbTools.ListNF074_Gammes.length; i++) {
      NF074_Gammes nf074Gammes = Srv_DbTools.ListNF074_Gammes[i];
      DbTools.insertNF074_Gammes(nf074Gammes);
    }
    DbTools.glfNF074_Gammes = await  DbTools.getNF074_Gammes();
    print("IMPORT_DataDialog glfNF074_Gammes ${DbTools.glfNF074_Gammes.length}");
    setState(() {
      wSt += "► NF074 : ${DbTools.glfNF074_Gammes.length} Gammes\n";
    });


    //**********************************

    await Srv_DbTools.IMPORT_Srv_NF074_Histo_Normes();
    print("IMPORT_DataDialog ListNF074_Histo_Normes ${Srv_DbTools.ListNF074_Histo_Normes.length}");
    DbTools.TrunckNF074_Histo_Normes();
    for (int i = 0; i < Srv_DbTools.ListNF074_Histo_Normes.length; i++) {
      NF074_Histo_Normes nf074HistoNormes = Srv_DbTools.ListNF074_Histo_Normes[i];
      DbTools.insertNF074_Histo_Normes(nf074HistoNormes);
    }
    DbTools.glfNF074_Histo_Normes = await  DbTools.getNF074_Histo_Normes();
    print("IMPORT_DataDialog glfNF074_Histo_Normes ${DbTools.glfNF074_Histo_Normes.length}");
    setState(() {
      wSt += "► NF074 : ${DbTools.glfNF074_Histo_Normes.length} Normes\n";
    });

    //**********************************

    await Srv_DbTools.IMPORT_Srv_NF074_Pieces_Det();
    print("IMPORT_DataDialog ListNF074_Pieces_Det ${Srv_DbTools.ListNF074_Pieces_Det.length}");
    DbTools.TrunckNF074_Pieces_Det();
    for (int i = 0; i < Srv_DbTools.ListNF074_Pieces_Det.length; i++) {
      NF074_Pieces_Det nf074PiecesDet = Srv_DbTools.ListNF074_Pieces_Det[i];
      DbTools.insertNF074_Pieces_Det(nf074PiecesDet);
    }
    DbTools.glfNF074_Pieces_Det = await  DbTools.getNF074_Pieces_Det();
    print("IMPORT_DataDialog glfNF074_Pieces_Det ${DbTools.glfNF074_Pieces_Det.length}");
    setState(() {
      wSt += "► NF074 : ${DbTools.glfNF074_Pieces_Det.length} Pièces détachées\n";
    });

    //**********************************

    await Srv_DbTools.IMPORT_Srv_NF074_Pieces_Det_Inc();
    print("IMPORT_DataDialog ListNF074_Pieces_Det_Inc ${Srv_DbTools.ListNF074_Pieces_Det_Inc.length}");
    DbTools.TrunckNF074_Pieces_Det_Inc();
    for (int i = 0; i < Srv_DbTools.ListNF074_Pieces_Det_Inc.length; i++) {
      NF074_Pieces_Det_Inc nf074PiecesDetInc = Srv_DbTools.ListNF074_Pieces_Det_Inc[i];
      DbTools.insertNF074_Pieces_Det_Inc(nf074PiecesDetInc);
    }
    DbTools.glfNF074_Pieces_Det_Inc = await  DbTools.getNF074_Pieces_Det_Inc();
    print("IMPORT_DataDialog glfNF074_Pieces_Det_Inc ${DbTools.glfNF074_Pieces_Det_Inc.length}");
    setState(() {
      wSt += "► NF074 : ${DbTools.glfNF074_Pieces_Det_Inc.length} Pièces Articles inconnus\n";
    });

    //**********************************

    await Srv_DbTools.IMPORT_Srv_NF074_Mixte_Produit();
    print("IMPORT_DataDialog ListNF074_Mixte_Produit ${Srv_DbTools.ListNF074_Mixte_Produit.length}");
    DbTools.TrunckNF074_Mixte_Produit();
    for (int i = 0; i < Srv_DbTools.ListNF074_Mixte_Produit.length; i++) {
      NF074_Mixte_Produit nf074MixteProduit = Srv_DbTools.ListNF074_Mixte_Produit[i];
      DbTools.insertNF074_Mixte_Produit(nf074MixteProduit);
    }
    DbTools.glfNF074_Mixte_Produit = await  DbTools.getNF074_Mixte_Produit();
    print("IMPORT_DataDialog glfNF074_Mixte_Produit ${DbTools.glfNF074_Mixte_Produit.length}");
    setState(() {
      wSt += "► NF074 : ${DbTools.glfNF074_Mixte_Produit.length} Mixte produits\n";
    });

    //**********************************

    await Srv_DbTools.IMPORT_Srv_NF074_Pieces_Actions();
    print("IMPORT_DataDialog ListNF074_Pieces_Actions ${Srv_DbTools.ListNF074_Pieces_Actions.length}");
    DbTools.TrunckNF074_Pieces_Actions();
    for (int i = 0; i < Srv_DbTools.ListNF074_Pieces_Actions.length; i++) {
      NF074_Pieces_Actions nf074PiecesActions = Srv_DbTools.ListNF074_Pieces_Actions[i];
      DbTools.insertNF074_Pieces_Actions(nf074PiecesActions);
    }
    DbTools.glfNF074_Pieces_Actions = await  DbTools.getNF074_Pieces_Actions();
    print("IMPORT_DataDialog glfNF074_Pieces_Actions ${DbTools.glfNF074_Pieces_Actions.length}");
    setState(() {
      wSt += "► NF074 : ${DbTools.glfNF074_Pieces_Actions.length} Pièces / Actions\n";
    });



    // Familles EBP
    await Srv_DbTools.IMPORT_Article_Fam_EbpAll();

    await Srv_DbTools.IMPORT_Article_Ebp_ES();



    await Article_Fam_Ebp.TrunckArticle_Fam_Ebp();
    for (int i = 0; i < Srv_DbTools.ListArticle_Fam_Ebp.length; i++) {
      Article_Fam_Ebp articleFamEbp = Srv_DbTools.ListArticle_Fam_Ebp[i];
      Article_Fam_Ebp.insertArticle_Fam_Ebp(articleFamEbp);
    }

    

    setState(() {
      wSt += "► ${Srv_DbTools.ListArticle_Fam_Ebp.length} Famille EBP\n";
    });


    // Articles EBP
    await Srv_DbTools.IMPORT_Article_EbpAll();

    await Article_Ebp.TrunckArticle_Ebp();
    for (int i = 0; i < Srv_DbTools.ListArticle_Ebp.length; i++) {
      Article_Ebp articleEbp = Srv_DbTools.ListArticle_Ebp[i];
      if (articleEbp.Article_Groupe.startsWith("0") || articleEbp.Article_Groupe.startsWith("1"))
        {
          Article_Ebp.insertArticle_Ebp(articleEbp);
        }
    }
    Srv_DbTools.ListArticle_Ebp = await Article_Ebp.getArticle_Ebp();
    print("getArticle_Ebp ${Srv_DbTools.ListArticle_Ebp.length}");

    setState(() {
      wSt += "► ${Srv_DbTools.ListArticle_Ebp.length} Articles EBP\n";
    });



    // Articles EBP ES (Echange Standard)
    await Srv_DbTools.IMPORT_Article_Ebp_ES();
    print("Import_DataDialog ListArticle_Ebp_ES ${Srv_DbTools.ListArticle_Ebp_ES.length}");

    setState(() {
      wSt += "► ${Srv_DbTools.ListArticle_Ebp_ES.length} Articles EBP ES\n";
    });



    Srv_DbTools.list_Article_GrpFamSsFam_Ebp.clear();
    for (int i = 0; i < Srv_DbTools.ListArticle_Ebp.length; i++) {
      Article_Ebp art = Srv_DbTools.ListArticle_Ebp[i];
      Article_GrpFamSsFam_Ebp warticleGrpfamssfamEbp = Article_GrpFamSsFam_Ebp();
      warticleGrpfamssfamEbp.Article_GrpFamSsFam_Groupe = art.Article_Groupe;
      warticleGrpfamssfamEbp.Article_GrpFamSsFam_Fam = art.Article_LibelleFamilleArticle;
      warticleGrpfamssfamEbp.Article_GrpFamSsFam_Sous_Fam = art.Article_LibelleSousFamilleArticle;

      var contain = Srv_DbTools.list_Article_GrpFamSsFam_Ebp.where((element) => element.Article_GrpFamSsFam_Groupe == warticleGrpfamssfamEbp.Article_GrpFamSsFam_Groupe && element.Article_GrpFamSsFam_Fam == warticleGrpfamssfamEbp.Article_GrpFamSsFam_Fam && element.Article_GrpFamSsFam_Sous_Fam == warticleGrpfamssfamEbp.Article_GrpFamSsFam_Sous_Fam);
      if (contain.isEmpty)
      {
        if (warticleGrpfamssfamEbp.Article_GrpFamSsFam_Groupe.contains("03 - SERVICE"))
        {
          print("wArticle_GrpFamSsFam_Ebp ${warticleGrpfamssfamEbp.Article_GrpFamSsFam_Groupe} - ${warticleGrpfamssfamEbp.Article_GrpFamSsFam_Fam}  - ${warticleGrpfamssfamEbp.Article_GrpFamSsFam_Sous_Fam}");

        }
        Srv_DbTools.list_Article_GrpFamSsFam_Ebp.add(warticleGrpfamssfamEbp);

      }

    }
    print("SplashScreen list_Article_Groupe ${Srv_DbTools.list_Article_Groupe.length}");


/*


    await Srv_DbTools.IMPORT_ArticlesImg_Ebp();
    print("Import_DataDialog ListArticlesImg_Ebp ${Srv_DbTools.ListArticlesImg_Ebp.length}");

    setState(() {
      wSt += "► ${Srv_DbTools.ListArticlesImg_Ebp.length} IMAGES Articles EBP\n";
    });
*/






    //**********************************
    //**********************************
    //**********************************

    setState(() {
      acontroller.stop();
      iStrfExp = false;
    });
  }

  @override
  void initLib() async {
    if (widget.ImportType == "Listing") {
      await Reload_Listing();
    } else if (widget.ImportType == "Param")
      await Reload_Param();
    else if (widget.ImportType == "NF74")
      await Reload_NF74();



    return;
  }

  @override
  void initState() {
    acontroller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    acontroller.repeat(reverse: true);
    acontroller.stop();

    initLib();
    super.initState();
  }

  @override
  void dispose() {
    acontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                "Import Data",
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
          height: 900,
          width: MediaQuery.of(context).size.width,

          child: Column(
            children: [
              Container(
                color: gColors.black,
                height: 1,
              ),

              Container(
                height: 10,
              ),
              !iStrfExp ? Container() :
              CircularProgressIndicator(
                value: acontroller.value,
                semanticsLabel: 'Circular progress indicator',
              ),
              Container(
                height: 10,
              ),
           Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                width: MediaQuery.of(context).size.width,

                padding: const EdgeInsets.fromLTRB(50, 5, 5, 0),
                child: Text(
                  wSt,
                  style: gColors.bodyTitle1_N_G24,
                ),
              ),
              ]),
              const Spacer(),
              Container(
                color: gColors.black,
                height: 1,
              ),
            ],
          )),
      actions: <Widget>[
        iStrfExp ? Container() : ElevatedButton(
          child: const Text(
            "OK",
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          onPressed: () async {
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  //**********************************
  //**********************************
  //**********************************
}
