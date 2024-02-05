import 'dart:async';

import 'package:flutter/material.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_NF074.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie_Param.dart';
import 'package:verifplus/Tools/DbSrv/Srv_User_Desc.dart';
import 'package:verifplus/Tools/DbSrv/Srv_User_Hab.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';

class Import_Data_Dialog {
  Import_Data_Dialog();

  static Future<void> Dialogs_Saisie(
    BuildContext context,
    VoidCallback onSaisie,
  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => Import_DataDialog(
        onSaisie: onSaisie,
      ),
    );
  }
}

//**********************************
//**********************************
//**********************************

class Import_DataDialog extends StatefulWidget {
  final VoidCallback onSaisie;

  const Import_DataDialog({
    Key? key,
    required this.onSaisie,
  }) : super(key: key);

  @override
  Import_DataDialogState createState() => Import_DataDialogState();
}

class Import_DataDialogState extends State<Import_DataDialog> with TickerProviderStateMixin {
  late AnimationController acontroller;
  bool iStrfExp = false;

  String wSt = "début";
  Future Reload() async {

    //**********************************
    //**********************************
    //**********************************

    setState(() {
      acontroller.forward();
      acontroller.repeat(reverse: true);
      iStrfExp = true;
      wSt = "► NF074\n";
    });


    //***********************************
    //***********************************
    //***********************************


    await Srv_DbTools.getParam_SaisieAll();
    print("Import_DataDialog ListParam_Saisie ${Srv_DbTools.ListParam_Saisie.length}");
    await DbTools.TrunckParam_Saisie();
    for (int i = 0; i < Srv_DbTools.ListParam_Saisie.length; i++) {
      Param_Saisie wParam_Saisie = Srv_DbTools.ListParam_Saisie[i];
      await DbTools.inserParam_Saisie(wParam_Saisie);
    }
    Srv_DbTools.ListParam_Saisie = await  DbTools.getParam_Saisie();
    print("Import_DataDialog Srv_DbTools.ListParam_Saisie ${Srv_DbTools.ListParam_Saisie}");
    setState(() {
      wSt = "► Param_Saisie : ${Srv_DbTools.ListParam_Saisie.length} Param\n";
    });

    Srv_DbTools.ListParam_Param_Abrev.clear();
    Srv_DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("Abrev") == 0) {
        Srv_DbTools.ListParam_Param_Abrev.add(element);
      }
    });

    //***********************************
    //***********************************
    //***********************************

    await Srv_DbTools.getParam_Saisie_ParamAll();
    print("Import_DataDialog ListParam_Saisie_ParamAll ${Srv_DbTools.ListParam_Saisie_ParamAll.length}");
    await DbTools.TrunckParam_Saisie_Param();
    for (int i = 0; i < Srv_DbTools.ListParam_Saisie_ParamAll.length; i++) {
      Param_Saisie_Param wParam_Saisie_Param = Srv_DbTools.ListParam_Saisie_ParamAll[i];
      await DbTools.inserParam_Saisie_Param(wParam_Saisie_Param);
    }
    Srv_DbTools.ListParam_Saisie_ParamAll = await  DbTools.getParam_Saisie_Param();
    print("Import_DataDialog Srv_DbTools.ListParam_Saisie_ParamAll ${Srv_DbTools.ListParam_Saisie_ParamAll}");
    setState(() {
      wSt += "► Param_Saisie_Param : ${Srv_DbTools.ListParam_Saisie_ParamAll.length} Param\n";
    });

    //***********************************
    //***********************************
    //***********************************

    await Srv_DbTools.getUser_Hab(Srv_DbTools.gUserLogin.UserID);
    print("Import_DataDialog ListUser_Hab ${Srv_DbTools.ListUser_Hab.length}");

    await DbTools.TrunckUser_Hab();
    for (int i = 0; i < Srv_DbTools.ListUser_Hab.length; i++) {
      User_Hab wUser_Hab = Srv_DbTools.ListUser_Hab[i];
      await DbTools.inserUser_Hab(wUser_Hab);
    }
    Srv_DbTools.ListUser_Hab = await  DbTools.getUser_Hab();
    print("Import_DataDialog Srv_DbTools.ListUser_Hab ${Srv_DbTools.ListUser_Hab}");
    setState(() {
      wSt += "► User_Hab : ${Srv_DbTools.ListUser_Hab.length} Param\n";
    });

    await Srv_DbTools.getUser_Desc(Srv_DbTools.gUserLogin.UserID);
    print("Import_DataDialog ListUser_Desc ${Srv_DbTools.ListUser_Desc.length}");

    await DbTools.TrunckUser_Desc();
    for (int i = 0; i < Srv_DbTools.ListUser_Desc.length; i++) {
      User_Desc wUser_Desc = Srv_DbTools.ListUser_Desc[i];
      await DbTools.inserUser_Desc(wUser_Desc);
    }
    Srv_DbTools.ListUser_Desc = await  DbTools.getUser_Desc();
    print("Import_DataDialog Srv_DbTools.ListUser_Desc ${Srv_DbTools.ListUser_Desc}");
    setState(() {
      wSt += "► User_Desc : ${Srv_DbTools.ListUser_Desc.length} Param\n";
    });



    //***********************************
    //***********************************
    //***********************************

    await Srv_DbTools.Import_Srv_NF074_Gammes();
    print("Import_DataDialog ListNF074_Gammes ${Srv_DbTools.ListNF074_Gammes.length}");
    DbTools.TrunckNF074_Gammes();
    for (int i = 0; i < Srv_DbTools.ListNF074_Gammes.length; i++) {
      NF074_Gammes nF074_Gammes = Srv_DbTools.ListNF074_Gammes[i];
      DbTools.insertNF074_Gammes(nF074_Gammes);
    }
    DbTools.glfNF074_Gammes = await  DbTools.getNF074_Gammes();
    print("Import_DataDialog glfNF074_Gammes ${DbTools.glfNF074_Gammes.length}");
    setState(() {
      wSt += "\n► NF074 : ${DbTools.glfNF074_Gammes.length} Gammes\n";
    });


    //**********************************

    await Srv_DbTools.Import_Srv_NF074_Histo_Normes();
    print("Import_DataDialog ListNF074_Histo_Normes ${Srv_DbTools.ListNF074_Histo_Normes.length}");
    DbTools.TrunckNF074_Histo_Normes();
    for (int i = 0; i < Srv_DbTools.ListNF074_Histo_Normes.length; i++) {
      NF074_Histo_Normes nF074_Histo_Normes = Srv_DbTools.ListNF074_Histo_Normes[i];
      DbTools.insertNF074_Histo_Normes(nF074_Histo_Normes);
    }
    DbTools.glfNF074_Histo_Normes = await  DbTools.getNF074_Histo_Normes();
    print("Import_DataDialog glfNF074_Histo_Normes ${DbTools.glfNF074_Histo_Normes.length}");
    setState(() {
      wSt += "► NF074 : ${DbTools.glfNF074_Histo_Normes.length} Normes\n";
    });

    //**********************************

    await Srv_DbTools.Import_Srv_NF074_Pieces_Det();
    print("Import_DataDialog ListNF074_Pieces_Det ${Srv_DbTools.ListNF074_Pieces_Det.length}");
    DbTools.TrunckNF074_Pieces_Det();
    for (int i = 0; i < Srv_DbTools.ListNF074_Pieces_Det.length; i++) {
      NF074_Pieces_Det nF074_Pieces_Det = Srv_DbTools.ListNF074_Pieces_Det[i];
      DbTools.insertNF074_Pieces_Det(nF074_Pieces_Det);
    }
    DbTools.glfNF074_Pieces_Det = await  DbTools.getNF074_Pieces_Det();
    print("Import_DataDialog glfNF074_Pieces_Det ${DbTools.glfNF074_Pieces_Det.length}");
    setState(() {
      wSt += "► NF074 : ${DbTools.glfNF074_Pieces_Det.length} Pièces détachées\n";
    });

    //**********************************

    await Srv_DbTools.Import_Srv_NF074_Pieces_Det_Inc();
    print("Import_DataDialog ListNF074_Pieces_Det_Inc ${Srv_DbTools.ListNF074_Pieces_Det_Inc.length}");
    DbTools.TrunckNF074_Pieces_Det_Inc();
    for (int i = 0; i < Srv_DbTools.ListNF074_Pieces_Det_Inc.length; i++) {
      NF074_Pieces_Det_Inc nF074_Pieces_Det_Inc = Srv_DbTools.ListNF074_Pieces_Det_Inc[i];
      DbTools.insertNF074_Pieces_Det_Inc(nF074_Pieces_Det_Inc);
    }
    DbTools.glfNF074_Pieces_Det_Inc = await  DbTools.getNF074_Pieces_Det_Inc();
    print("Import_DataDialog glfNF074_Pieces_Det_Inc ${DbTools.glfNF074_Pieces_Det_Inc.length}");
    setState(() {
      wSt += "► NF074 : ${DbTools.glfNF074_Pieces_Det_Inc.length} Pièces Articles inconnus\n";
    });

    //**********************************

    await Srv_DbTools.Import_Srv_NF074_Mixte_Produit();
    print("Import_DataDialog ListNF074_Mixte_Produit ${Srv_DbTools.ListNF074_Mixte_Produit.length}");
    DbTools.TrunckNF074_Mixte_Produit();
    for (int i = 0; i < Srv_DbTools.ListNF074_Mixte_Produit.length; i++) {
      NF074_Mixte_Produit nF074_Mixte_Produit = Srv_DbTools.ListNF074_Mixte_Produit[i];
      DbTools.insertNF074_Mixte_Produit(nF074_Mixte_Produit);
    }
    DbTools.glfNF074_Mixte_Produit = await  DbTools.getNF074_Mixte_Produit();
    print("Import_DataDialog glfNF074_Mixte_Produit ${DbTools.glfNF074_Mixte_Produit.length}");
    setState(() {
      wSt += "► NF074 : ${DbTools.glfNF074_Mixte_Produit.length} Mixte produits\n";
    });

    //**********************************

    await Srv_DbTools.Import_Srv_NF074_Pieces_Actions();
    print("Import_DataDialog ListNF074_Pieces_Actions ${Srv_DbTools.ListNF074_Pieces_Actions.length}");
    DbTools.TrunckNF074_Pieces_Actions();
    for (int i = 0; i < Srv_DbTools.ListNF074_Pieces_Actions.length; i++) {
      NF074_Pieces_Actions nF074_Pieces_Actions = Srv_DbTools.ListNF074_Pieces_Actions[i];
      DbTools.insertNF074_Pieces_Actions(nF074_Pieces_Actions);
    }
    DbTools.glfNF074_Pieces_Actions = await  DbTools.getNF074_Pieces_Actions();
    print("Import_DataDialog glfNF074_Pieces_Actions ${DbTools.glfNF074_Pieces_Actions.length}");
    setState(() {
      wSt += "► NF074 : ${DbTools.glfNF074_Pieces_Actions.length} Pièces / Actions\n";
    });




    // Familles EBP
    await Srv_DbTools.getArticle_Fam_EbpAll();
    // Articles EBP
    await Srv_DbTools.getArticle_EbpAll();
    // Articles EBP ES (Echange Standard)
    await Srv_DbTools.getArticle_Ebp_ES();
    print("Import_DataDialog ListArticle_Ebp ${Srv_DbTools.ListArticle_Ebp.length}");

    setState(() {
      wSt += "► NF074 : ${Srv_DbTools.ListArticle_Ebp.length} Articles EBP\n";
    });

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
    await Reload();
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      backgroundColor: gColors.white,
      title: Container(
          color: gColors.white,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
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
          height: 500,
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
}
