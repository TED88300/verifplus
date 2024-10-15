import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:verifplus/Tools/Api_Gouv.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Param.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/shared_pref.dart';
import 'package:verifplus/Widget/1-login.dart';
import 'package:verifplus/Widget/2-home.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';

import '../Tools/DbSrv/Srv_Articles_Ebp.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  var _visible = true;
  var IsRememberLogin = false;
  var milliseconds = 1000;

  late AnimationController animationController;
  late Animation<double> animation;

  String wSt = "";

  startTime() async {
    var _duration = new Duration(milliseconds: milliseconds); //SetUp duration here
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    setState(() {
      wSt = "Initialisation Base de données";
    });

    await DbTools.initSqlite();

//    await Srv_ImportExport.ExportNotSync();
//    Srv_DbTools.ListArticle_Ebp = await Article_Ebp.getArticle_Ebp();
//    Srv_DbTools.getParam_ParamAll();

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



    print("Srv_DbTools.ListIntervention.length ${Srv_DbTools.ListIntervention.length}");
    Srv_DbTools.ListParam_ParamAll = await  DbTools.getParam_Param();
    print("Srv_DbTools.ListParam_ParamAll.length ${Srv_DbTools.ListParam_ParamAll.length}");

    Srv_DbTools.ListParam_Param_Civ.clear();
    Srv_DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("Civ") == 0) {
        Srv_DbTools.ListParam_Param_Civ.add(element);
      }
    });

    Srv_DbTools.ListParam_Param_Status_Interv.clear();
    Srv_DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("Status_Interv") == 0) {
        Srv_DbTools.ListParam_Param_Status_Interv.add(element);
      }
    });




    Srv_DbTools.ListParam_ParamCiv.clear();
    Srv_DbTools.ListParam_ParamCiv.add("");
    for (int i = 0; i < Srv_DbTools.ListParam_Param_Civ.length; i++) {
      Param_Param wParam_Param = Srv_DbTools.ListParam_Param_Civ[i];
      if (wParam_Param.Param_Param_Text == "C")
        Srv_DbTools.ListParam_ParamCiv.add(wParam_Param.Param_Param_ID);
    }

    Srv_DbTools.ListParam_ParamForme.clear();
    Srv_DbTools.ListParam_ParamForme.add("");
    for (int i = 0; i < Srv_DbTools.ListParam_Param_Civ.length; i++) {
      Param_Param wParam_Param = Srv_DbTools.ListParam_Param_Civ[i];
      if (wParam_Param.Param_Param_Text != "C")
        Srv_DbTools.ListParam_ParamForme.add(wParam_Param.Param_Param_ID);
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

    DbTools.genParam();

    if (DbTools.gIsRememberLogin) DbTools.gIsRememberLogin = await Srv_DbTools.getUserLogin(DbTools.gUsername, DbTools.gPassword);

    if (DbTools.gIsRememberLogin) {
//      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
      if (DbTools.gTED)
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
//          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Client_Groupe_Parc_Inter()));
      else
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
    } else
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
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

    animationController = new AnimationController(vsync: this, duration: new Duration(seconds: 2));
    animation = new CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    animation.addListener(() => this.setState(() {}));
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
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
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
