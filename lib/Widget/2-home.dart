import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/shared_pref.dart';
import 'package:verifplus/Tools/text_scroll.dart';
import 'package:verifplus/Widget/1-login.dart';
import 'package:verifplus/Widget/Catalogue_Grig/Catalogue_Grid.dart';
import 'package:verifplus/Widget/Client/Clients_Liste.dart';
import 'package:verifplus/Widget/Import_Data.dart';
import 'package:verifplus/Widget/P_Notifications.dart';
import 'package:verifplus/Widget/Planning/Planning.dart';
import 'package:verifplus/Widget/Widget_Tools/bottom_navigation_bar.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  bool isChecked = false;

  String notificationTitle = 'No Title';
  String notificationBody = 'No Body';
  String notificationData = 'No Data';
  late BuildContext ctx;

  List<String> P_itemsTitre = <String>[
    "",
    "SYNTHESE",
    "CATALOGUE",
    "PLANNING",
    "NOTIFICATIONS",
  ];

  List<Widget> P_children = [
    Liste_Clients(),
    Liste_Clients(),
    Catalogue_Grid(),
    Planning(),
    P_Notifications(),
  ];

  @override
  void initLib() async {
    await reload();
  }

  @override
  Future reload() async {
    setState(() {});
  }

  void onBackPress() {
    if (Navigator.of(ctx).canPop()) {
      Navigator.of(ctx).pop();
    }
  }

  @override
  void dispose() {
    //  WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    FlutterAppBadger.removeBadge();

    super.initState();
    initLib();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Block_MenuApp(context);
  }

  void onSaisie() async {
    setState(() {});
  }

  @override
  Widget Block_MenuApp(BuildContext context) {
    String title_string = P_itemsTitre[DbTools.gCurrentIndex];
    Widget wchildren = P_children[DbTools.gCurrentIndex];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      //    endDrawer: DbTools.gIsMedecinLogin! ? C_SideDrawer() : I_SideDrawer(),
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: (title_string.isEmpty)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "LISTING CLIENTS",
                    maxLines: 1,
                    style: gColors.bodyTitle1_B_G24,
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title_string,
                    maxLines: 1,
                    style: gColors.bodyTitle1_B_G24,
                  ),
                ],
              ),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(5, 10, 0, 10),
          child: Image.asset("assets/images/IcoW.png"),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.cloud_download_outlined,
              color: Colors.green,
            ),
            onPressed: () async {
              await Import_Data_Dialog.Dialogs_Saisie(context, onSaisie);
            },
          ),
          IconButton(
            iconSize: 40,
            icon: gColors.wBoxDecoration(context),
            onPressed: () async {
              gColors.AffUser(context);
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: gColors.grey,
            ),
            onPressed: () async {
              await SharedPref.setStrKey("username", "");
              await SharedPref.setStrKey("password", "");
              await SharedPref.setBoolKey("IsRememberLogin", false);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
        ],
        backgroundColor: gColors.white,
      ),

      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            wchildren,
            Positioned(
              bottom: 0,
              right: 0,
              child: CustomBottomNavigationBar(
                onIconPresedCallback: onBottomIconPressed,
              ),
            )
          ],
        ),
      ),
    );
  }

  void onBottomIconPressed(int index) {
    DbTools.gCurrentIndex = index;
    setState(() {});
  }

  void AffMessage(String title, String body) {
    print('AffMessage');

    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: Column(
                  //Slide3
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/images/AppIco.png'),
                      height: 50,
                    ),
                    SizedBox(height: 8.0),
                    Container(color: Colors.grey, height: 1.0),
                    SizedBox(height: 8.0),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ]),
              content: Text(body),
              actions: <Widget>[
                ElevatedButton(
                  child: Text(
                    "OK",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  onPressed: () async {
                    await reload();

                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }
}
