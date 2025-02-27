import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:verifplus/Tools/Api_Gouv.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles_Fam_Ebp.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Param.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/shared_pref.dart';
import 'package:verifplus/Widget/1-login.dart';
import 'package:verifplus/Widget/2-home.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';

import '../Tools/DbSrv/Srv_Articles_Ebp.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  var _visible = true;
  var IsRememberLogin = false;
  var milliseconds = 1000;

  late AnimationController animationController;
  late Animation<double> animation;

  String wSt = "";

  startTime() async {
    var duration = Duration(milliseconds: milliseconds); //SetUp duration here
    return Timer(duration, navigationPage);
  }

  void navigationPage() async {
    setState(() {
      wSt = "Initialisation Base de données";
    });

    await DbTools.initSqlite();


    Srv_DbTools.getParam_ParamAll();

    DbTools.gTxTVA = 20;
    Srv_DbTools.getParam_ParamMemDet("Param_Div", "TxTVA");
    if (Srv_DbTools.ListParam_Param.isNotEmpty) DbTools.gTxTVA = double.tryParse(Srv_DbTools.ListParam_Param[0].Param_Param_Text) ?? 20.0;




    Srv_DbTools.gSelGroupe = Srv_DbTools.gSelGroupeBase;
    Srv_DbTools.gSelIntervention = Srv_DbTools.gSelInterventionBase;

    DbTools.gIsRememberLogin = await SharedPref.getBoolKey("IsRememberLogin", false);

    int timestampLogin = await SharedPref.getIntKey("timestampLogin", 0);
    DateTime dttimestampLogin = DateTime.fromMillisecondsSinceEpoch(timestampLogin);
    Duration wDT = dttimestampLogin.difference(DateTime.now());
    if (wDT.inDays < -10) DbTools.gIsRememberLogin = false;

    DbTools.gUsername = await SharedPref.getStrKey("username", "");
    DbTools.gPassword = await SharedPref.getStrKey("password", "");
    DbTools.packageInfo = await PackageInfo.fromPlatform();
    DbTools.gVersion = "V${DbTools.packageInfo.version} b${DbTools.packageInfo.buildNumber}";
    print("DbTools.gVersion ${DbTools.gVersion}");

    Srv_DbTools.ListPlanning_Intervention = await DbTools.getPlanning_InterventionAll();

    Srv_DbTools.ListPlanning = await DbTools.getPlanningAll();
    Srv_DbTools.ListIntervention = await  DbTools.getInterventionsAll();
    Srv_DbTools.ListInterMission = await  DbTools.getInterMissions();


    bool wResult = await Srv_DbTools.getUserAll();


    print("Srv_DbTools.ListIntervention.length ${Srv_DbTools.ListIntervention.length}");
    Srv_DbTools.ListParam_ParamAll = await  DbTools.getParam_Param();
    print("Srv_DbTools.ListParam_ParamAll.length ${Srv_DbTools.ListParam_ParamAll.length}");

    Srv_DbTools.ListParam_Param_Civ.clear();
    for (var element in Srv_DbTools.ListParam_ParamAll) {
      if (element.Param_Param_Type.compareTo("Civ") == 0) {
        Srv_DbTools.ListParam_Param_Civ.add(element);
      }
    }

    Srv_DbTools.ListParam_Param_Status_Interv.clear();
    for (var element in Srv_DbTools.ListParam_ParamAll) {
      if (element.Param_Param_Type.compareTo("Status_Interv") == 0) {
        Srv_DbTools.ListParam_Param_Status_Interv.add(element);
      }
    }

    Srv_DbTools.ListParam_Param_Etat_Devis.clear();
    for (var element in Srv_DbTools.ListParam_ParamAll) {
      if (element.Param_Param_Type.compareTo("Etat_Devis") == 0) {
        Srv_DbTools.ListParam_Param_Etat_Devis.add(element);
      }
    }


    Srv_DbTools.ListParam_Param_Etat_Cde.clear();
    for (var element in Srv_DbTools.ListParam_ParamAll) {
      if (element.Param_Param_Type.compareTo("Etat_Commandes") == 0) {
        Srv_DbTools.ListParam_Param_Etat_Cde.add(element);
      }
    }

    Srv_DbTools.ListParam_Param_Etat_Livr.clear();
    for (var element in Srv_DbTools.ListParam_ParamAll) {
      if (element.Param_Param_Type.compareTo("Etat_Livraison") == 0) {
        Srv_DbTools.ListParam_Param_Etat_Livr.add(element);
      }
    }

    
    Srv_DbTools.ListParam_Param_Affaire.clear();
    for (var element in Srv_DbTools.ListParam_ParamAll) {
      if (element.Param_Param_Type.compareTo("Affaire") == 0) {
        Srv_DbTools.ListParam_Param_Affaire.add(element);
      }
    }

    Srv_DbTools.ListParam_Param_Proba.clear();
    for (var element in Srv_DbTools.ListParam_ParamAll) {
      if (element.Param_Param_Type.compareTo("Proba") == 0) {
        Srv_DbTools.ListParam_Param_Proba.add(element);
      }
    }

    
    Srv_DbTools.ListParam_Param_Validite_devis.clear();
    for (var element in Srv_DbTools.ListParam_ParamAll) {
      if (element.Param_Param_Type.compareTo("Validite_devis") == 0) {
        Srv_DbTools.ListParam_Param_Validite_devis.add(element);
      }
    }

    Srv_DbTools.ListParam_Param_Livraison_prev.clear();
    for (var element in Srv_DbTools.ListParam_ParamAll) {
      if (element.Param_Param_Type.compareTo("Livraison_prev") == 0) {
        Srv_DbTools.ListParam_Param_Livraison_prev.add(element);
      }
    }

    Srv_DbTools.ListParam_Param_Mode_rglt.clear();
    for (var element in Srv_DbTools.ListParam_ParamAll) {
      if (element.Param_Param_Type.compareTo("Mode_rglt") == 0) {
        Srv_DbTools.ListParam_Param_Mode_rglt.add(element);
      }
    }

    Srv_DbTools.ListParam_Param_Moyen_paiement.clear();
    for (var element in Srv_DbTools.ListParam_ParamAll) {
      if (element.Param_Param_Type.compareTo("Moyen_paiement") == 0) {
        Srv_DbTools.ListParam_Param_Moyen_paiement.add(element);
      }
    }

    Srv_DbTools.ListParam_Param_Pref_Aff.clear();
    for (var element in Srv_DbTools.ListParam_ParamAll) {
      if (element.Param_Param_Type.compareTo("Pref_Aff") == 0) {
        Srv_DbTools.ListParam_Param_Pref_Aff.add(element);
      }
    }

    Srv_DbTools.ListParam_Param_Rel_Auto.clear();
    for (var element in Srv_DbTools.ListParam_ParamAll) {
      if (element.Param_Param_Type.compareTo("Rel_Auto") == 0) {
        Srv_DbTools.ListParam_Param_Rel_Auto.add(element);
      }
    }


    Srv_DbTools.ListParam_Param_Rel_Anniv.clear();
    for (var element in Srv_DbTools.ListParam_ParamAll) {
      if (element.Param_Param_Type.compareTo("Rel_Anniv") == 0) {
        Srv_DbTools.ListParam_Param_Rel_Anniv.add(element);
      }
    }


    Srv_DbTools.ListParam_Param_TitresRel.clear();
    for (var wParam_Param in Srv_DbTools.ListParam_ParamAll) {
      if (wParam_Param.Param_Param_Type.compareTo("TitresRel") == 0) {
        Srv_DbTools.ListParam_Param_TitresRel.add(wParam_Param);
      }
    }



    Srv_DbTools.ListParam_ParamCiv.clear();
    Srv_DbTools.ListParam_ParamCiv.add("");
    for (int i = 0; i < Srv_DbTools.ListParam_Param_Civ.length; i++) {
      Param_Param wparamParam = Srv_DbTools.ListParam_Param_Civ[i];
      if (wparamParam.Param_Param_Text == "C") {
        Srv_DbTools.ListParam_ParamCiv.add(wparamParam.Param_Param_ID);
      }
    }

    Srv_DbTools.ListParam_ParamForme.clear();
    Srv_DbTools.ListParam_ParamForme.add("");
    for (int i = 0; i < Srv_DbTools.ListParam_Param_Civ.length; i++) {
      Param_Param wparamParam = Srv_DbTools.ListParam_Param_Civ[i];
      if (wparamParam.Param_Param_Text != "C") {
        Srv_DbTools.ListParam_ParamForme.add(wparamParam.Param_Param_ID);
      }
    }


    Srv_DbTools.ListParam_Saisie = await  DbTools.getParam_SaisieAll();
    Srv_DbTools.ListParam_Saisie_ParamAll = await  DbTools.getParam_Saisie_ParamAll();
    Srv_DbTools.ListUser_Hab = await  DbTools.getUser_Hab();
    Srv_DbTools.ListUser_Desc = await  DbTools.getUser_Desc();

    DbTools.glfNF074_Gammes = await  DbTools.getNF074_Gammes();
    DbTools.glfNF074_Mixte_Produit = await  DbTools.getNF074_Mixte_Produit();
    DbTools.glfNF074_Pieces_Det_Inc = await  DbTools.getNF074_Pieces_Det_Inc();
    DbTools.glfNF074_Pieces_Det = await  DbTools.getNF074_Pieces_Det();
    DbTools.glfNF074_Histo_Normes = await  DbTools.getNF074_Histo_Normes();
    DbTools.glfNF074_Pieces_Actions = await  DbTools.getNF074_Pieces_Actions();
    Srv_DbTools.ListArticle_Ebp = await Article_Ebp.getArticle_Ebp();
    await Srv_DbTools.IMPORT_Article_Ebp_ES();
    print("SplashScreen ListArticle_Ebp ${Srv_DbTools.ListArticle_Ebp.length}");

    await Srv_DbTools.IMPORT_Article_Fam_EbpAll();
    print("SplashScreen ListArticle_Fam_Ebp ${Srv_DbTools.ListArticle_Fam_Ebp.length}");

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

    print("SplashScreen Srv_DbTools.list_Article_GrpFamSsFam_Ebp ${Srv_DbTools.list_Article_GrpFamSsFam_Ebp.length}");

    DbTools.genParam();

    if (DbTools.gIsRememberLogin) DbTools.gIsRememberLogin = await Srv_DbTools.getUserLogin(DbTools.gUsername, DbTools.gPassword);

    if (DbTools.gIsRememberLogin) {
//      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
      if (DbTools.gTED) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Home()));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Home()));
      }
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Login()));
    }
  }

  void initLib() async {
    DbTools.gOffLine = await Api_Gouv.inseeToken();
  }

  @override
  void initState() {
    super.initState();
    initLib();

    if (DbTools.gTED) {
      milliseconds = 800;
    }

    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation = CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    animation.addListener(() => setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  dispose() {
    animationController.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    gColors.MediaQuerysizewidth = MediaQuery.of(context).size.width;

    FocusScope.of(context).unfocus();

    SystemChannels.textInput.invokeMethod('TextInput.hide');

    final double width = MediaQuery.of(context).size.width * 0.9;
    final double height = MediaQuery.of(context).size.height * 0.9;

    double w = animation.value * 700;
    double h = animation.value * 700;

    if (w > width) w = width;
    if (h > height) h = height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/AppIco.png',
                width: w,
                height: h,
              ),
              Text(
                wSt,
                style: gColors.bodyTitle1_N_G24,
              ),
              Container(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Outils de vérification  ",
                    style: gColors.bodyTitle1_B_P,
                  ),
                  Text(
                    "Incendie",
                    style: gColors.bodyTitle1_B_S,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
