import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:verifplus/Tools/Api_Gouv.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_NF074.dart';
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

    Srv_DbTools.ListArticle_Ebp = await Article_Ebp.getArticle_Ebp();
    print("getArticle_Ebp ${Srv_DbTools.ListArticle_Ebp.length}");

    Srv_DbTools.gSelGroupe = Srv_DbTools.gSelGroupeBase;
    Srv_DbTools.gSelIntervention = Srv_DbTools.gSelInterventionBase;

    DbTools.gIsRememberLogin = await SharedPref.getBoolKey("IsRememberLogin", false);
    DbTools.gUsername = await SharedPref.getStrKey("username", "");
    DbTools.gPassword = await SharedPref.getStrKey("password", "");
    DbTools.packageInfo = await PackageInfo.fromPlatform();
    DbTools.gVersion = "V${DbTools.packageInfo.version} b${DbTools.packageInfo.buildNumber}";
    print("DbTools.gVersion ${DbTools.gVersion}");

    Srv_DbTools.getParam_ParamAll();

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
