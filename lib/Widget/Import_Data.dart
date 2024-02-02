import 'dart:async';

import 'package:flutter/material.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_NF074.dart';
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
      wSt = "Import NF074\n";
    });

    await Srv_DbTools.Import_Srv_NF074_Gammes();
    print("SplashScreenState ListNF074_Gammes ${Srv_DbTools.ListNF074_Gammes.length}");
    DbTools.TrunckNF074_Gammes();
    for (int i = 0; i < Srv_DbTools.ListNF074_Gammes.length; i++) {
      NF074_Gammes nF074_Gammes = Srv_DbTools.ListNF074_Gammes[i];
      DbTools.insertNF074_Gammes(nF074_Gammes);
    }
    DbTools.glfNF074_Gammes = await  DbTools.getNF074_Gammes();
    print("SplashScreenState glfNF074_Gammes ${DbTools.glfNF074_Gammes.length}");
    setState(() {
      wSt = "Import NF074 : ${DbTools.glfNF074_Gammes.length} Gammes\n";
    });


    //**********************************

    await Srv_DbTools.Import_Srv_NF074_Histo_Normes();
    print("SplashScreenState ListNF074_Histo_Normes ${Srv_DbTools.ListNF074_Histo_Normes.length}");
    DbTools.TrunckNF074_Histo_Normes();
    for (int i = 0; i < Srv_DbTools.ListNF074_Histo_Normes.length; i++) {
      NF074_Histo_Normes nF074_Histo_Normes = Srv_DbTools.ListNF074_Histo_Normes[i];
      DbTools.insertNF074_Histo_Normes(nF074_Histo_Normes);
    }
    DbTools.glfNF074_Histo_Normes = await  DbTools.getNF074_Histo_Normes();
    print("SplashScreenState glfNF074_Histo_Normes ${DbTools.glfNF074_Histo_Normes.length}");
    setState(() {
      wSt += "Import NF074 : ${DbTools.glfNF074_Histo_Normes.length} Normes\n";
    });

    //**********************************

    await Srv_DbTools.Import_Srv_NF074_Pieces_Det();
    print("SplashScreenState ListNF074_Pieces_Det ${Srv_DbTools.ListNF074_Pieces_Det.length}");
    DbTools.TrunckNF074_Pieces_Det();
    for (int i = 0; i < Srv_DbTools.ListNF074_Pieces_Det.length; i++) {
      NF074_Pieces_Det nF074_Pieces_Det = Srv_DbTools.ListNF074_Pieces_Det[i];
      DbTools.insertNF074_Pieces_Det(nF074_Pieces_Det);
    }
    DbTools.glfNF074_Pieces_Det = await  DbTools.getNF074_Pieces_Det();
    print("SplashScreenState glfNF074_Pieces_Det ${DbTools.glfNF074_Pieces_Det.length}");
    setState(() {
      wSt += "Import NF074 : ${DbTools.glfNF074_Pieces_Det.length} Pièces détachées\n";
    });

    //**********************************

    await Srv_DbTools.Import_Srv_NF074_Pieces_Det_Inc();
    print("SplashScreenState ListNF074_Pieces_Det_Inc ${Srv_DbTools.ListNF074_Pieces_Det_Inc.length}");
    DbTools.TrunckNF074_Pieces_Det_Inc();
    for (int i = 0; i < Srv_DbTools.ListNF074_Pieces_Det_Inc.length; i++) {
      NF074_Pieces_Det_Inc nF074_Pieces_Det_Inc = Srv_DbTools.ListNF074_Pieces_Det_Inc[i];
      DbTools.insertNF074_Pieces_Det_Inc(nF074_Pieces_Det_Inc);
    }
    DbTools.glfNF074_Pieces_Det_Inc = await  DbTools.getNF074_Pieces_Det_Inc();
    print("SplashScreenState glfNF074_Pieces_Det_Inc ${DbTools.glfNF074_Pieces_Det_Inc.length}");
    setState(() {
      wSt += "Import NF074 : ${DbTools.glfNF074_Pieces_Det_Inc.length} Pièces Articles inconnus\n";
    });

    //**********************************

    await Srv_DbTools.Import_Srv_NF074_Mixte_Produit();
    print("SplashScreenState ListNF074_Mixte_Produit ${Srv_DbTools.ListNF074_Mixte_Produit.length}");
    DbTools.TrunckNF074_Mixte_Produit();
    for (int i = 0; i < Srv_DbTools.ListNF074_Mixte_Produit.length; i++) {
      NF074_Mixte_Produit nF074_Mixte_Produit = Srv_DbTools.ListNF074_Mixte_Produit[i];
      DbTools.insertNF074_Mixte_Produit(nF074_Mixte_Produit);
    }
    DbTools.glfNF074_Mixte_Produit = await  DbTools.getNF074_Mixte_Produit();
    print("SplashScreenState glfNF074_Mixte_Produit ${DbTools.glfNF074_Mixte_Produit.length}");
    setState(() {
      wSt += "Import NF074 : ${DbTools.glfNF074_Mixte_Produit.length} Mixte produits\n";
    });

    //**********************************

    await Srv_DbTools.Import_Srv_NF074_Pieces_Actions();
    print("SplashScreenState ListNF074_Pieces_Actions ${Srv_DbTools.ListNF074_Pieces_Actions.length}");
    DbTools.TrunckNF074_Pieces_Actions();
    for (int i = 0; i < Srv_DbTools.ListNF074_Pieces_Actions.length; i++) {
      NF074_Pieces_Actions nF074_Pieces_Actions = Srv_DbTools.ListNF074_Pieces_Actions[i];
      DbTools.insertNF074_Pieces_Actions(nF074_Pieces_Actions);
    }
    DbTools.glfNF074_Pieces_Actions = await  DbTools.getNF074_Pieces_Actions();
    print("SplashScreenState glfNF074_Pieces_Actions ${DbTools.glfNF074_Pieces_Actions.length}");
    setState(() {
      wSt += "Import NF074 : ${DbTools.glfNF074_Pieces_Actions.length} Pièces / Actions\n";
    });



    // Gammes
//    await Srv_DbTools.getParam_GammeAll();
    // Param_Saisie_Param
    await Srv_DbTools.getParam_Saisie_ParamAll();

    // Users_Hab de l'utilisateur
    await Srv_DbTools.getUser_Hab(Srv_DbTools.gUserLogin.UserID);
    // Users_Desc de l'utilisateur
    await Srv_DbTools.getUser_Desc(Srv_DbTools.gUserLogin.UserID);



    // Familles EBP
    await Srv_DbTools.getArticle_Fam_EbpAll();
    // Articles EBP
    await Srv_DbTools.getArticle_EbpAll();
    // Articles EBP ES (Echange Standard)
    await Srv_DbTools.getArticle_Ebp_ES();
    print("SplashScreenState ListArticle_Ebp ${Srv_DbTools.ListArticle_Ebp.length}");

    setState(() {
      wSt += "Import NF074 : ${Srv_DbTools.ListArticle_Ebp.length} Articles EBP\n";
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
