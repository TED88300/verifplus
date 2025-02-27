import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_ImportExport.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/shared_pref.dart';
import 'package:verifplus/Widget/1-login.dart';
import 'package:verifplus/Widget/Catalogue_Grig/Catalogue_Grid.dart';
import 'package:verifplus/Widget/Client/Clients_Liste.dart';
import 'package:verifplus/Widget/GestCo/DCL_List.dart';
import 'package:verifplus/Widget/Import_ASync.dart';
import 'package:verifplus/Widget/Import_Data.dart';
import 'package:verifplus/Widget/Import_Menu.dart';
import 'package:verifplus/Widget/Intervention/Intervention_Liste.dart';
import 'package:verifplus/Widget/Planning/Planning.dart';
import 'package:verifplus/Widget/Widget_Tools/bottom_navigation_bar.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  bool isChecked = false;

  String notificationTitle = 'No Title';
  String notificationBody = 'No Body';
  String notificationData = 'No Data';
  late BuildContext ctx;

  final ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  List<String> P_itemsTitre = <String>[
    "",
    "INTERVENTIONS",
    "CATALOGUE",
    "PLANNING",
    "DOCUMENTS DE VENTE",
  ];

  List<Widget> P_children = [];

  @override
  void initLib() async {
//    await reload();
  }


  @override
  Future reload() async {
    await Srv_ImportExport.getErrorSync();
    await DbTools.checkConnection();

    if (Srv_DbTools.ListParam_ParamAll.isEmpty)
      {
        print("⚄⚄⚄⚄⚄⚄⚄ Call import Param >");
      await Import_Data_Dialog.Dialogs_Saisie(context, onSaisie, "Param");
        print("⚄⚄⚄⚄⚄⚄⚄ Call import Param <");

        print("⚄⚄⚄⚄⚄⚄⚄ Call import NF74 >");
        await Import_Data_Dialog.Dialogs_Saisie(context, onSaisie, "NF74");
        print("⚄⚄⚄⚄⚄⚄⚄ Call import NF74 <");

        FBroadcast.instance().broadcast("MAJCLIENT");
      reload();
      }

  /*  DbTools.glfNF074_Gammes = await  DbTools.getNF074_Gammes();
    if (DbTools.glfNF074_Gammes.length == 0)
    {
      print("⚄⚄⚄⚄⚄⚄⚄ Call import NF74 >");
      await Import_Data_Dialog.Dialogs_Saisie(context, onSaisie, "NF74");
      print("⚄⚄⚄⚄⚄⚄⚄ Call import NF74 <");
      FBroadcast.instance().broadcast("MAJCLIENT");
      reload();
    }*/
    setState(() {});
  }

  void onBackPress() {
    if (Navigator.of(ctx).canPop()) {
      Navigator.of(ctx).pop();
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state)
  {
    print('');
    print('  $state  ${state == AppLifecycleState.resumed}');
    print('');

    if (state == AppLifecycleState.resumed)
      {
        FBroadcast.instance().broadcast("Maj_Planning");
        FBroadcast.instance().broadcast("MAJCLIENT");
        FBroadcast.instance().broadcast("Maj_Intervention");

      }



  }


  Widget wListe_Clients = Container();

  @override
  void initState() {

    WidgetsBinding.instance.addObserver(this);

    P_children = [
      Liste_Clients(onSaisie: onSaisie),
      const Interventions_Liste(),
      const Catalogue_Grid(),
      const Planning(),
//      P_Notifications(),
      const DCL_List(),
    ];

    print("HOME initState");
    FlutterAppBadger.removeBadge();
    super.initState();
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    initLib();
  }




  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException {
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    print(" initConnectivity");

    return reload();
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    print("HOME _updateConnectionStatus");
    await DbTools.checkConnection();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Block_MenuApp(context);
  }

  void onSaisie() async {
    setState(() {});
  }

  Widget wchildren = Container();
  final pageController = PageController(initialPage : DbTools.gCurrentIndex);

  @override
  Widget Block_MenuApp(BuildContext context) {
    String titleString = P_itemsTitre[DbTools.gCurrentIndex];
    print("Block_MenuApp $titleString");

    return Scaffold(
      resizeToAvoidBottomInset: false,
      //    endDrawer: DbTools.gIsMedecinLogin! ? C_SideDrawer() : I_SideDrawer(),
      backgroundColor: Colors.transparent,
      appBar: AppBar(
//        centerTitle: true,
        title: (titleString.isEmpty)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    titleString,
                    maxLines: 1,
                    style: gColors.bodyTitle1_B_G24,
                  ),
                ],
              ),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: IconButton(
            icon: DbTools.gBoolErrorSync
                ? Image.asset(
                    "assets/images/IcoWErr.png",
                  )
                : Image.asset("assets/images/IcoW.png"),
            onPressed: () async {
              await Srv_ImportExport.ExportNotSync();
              FBroadcast.instance().broadcast("MAJCLIENT");
              setState(() {});
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          ),
        ),
        actions: <Widget>[

          IconButton(
            icon: const Icon(
               Icons.sync_problem ,
              color: Colors.orange,
            ),
            onPressed: () async {
              await Import_ASync_Dialog.Dialogs_ASync(context, onSaisie);

            },
          ),

          IconButton(
            icon: Icon(
              DbTools.hasConnection ? Icons.cloud_download : Icons.cloud_off,
              color: DbTools.hasConnection ? Colors.green : Colors.red,
            ),
            onPressed: () async {
              await Import_Menu_Dialog.Dialogs_Saisie(context, onSaisie);
              FBroadcast.instance().broadcast("MAJCLIENT");
              reload();
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
                MaterialPageRoute(builder: (context) => const Login()),
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
            PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: onBottomIconPressed,
              children: P_children,
            ),
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

  void onBottomIconPressed(int index) async {
    if (DbTools.gCurrentIndex != index) {
      DbTools.gCurrentIndex = index;
      pageController.jumpToPage(index);
      if (DbTools.gCurrentIndex == 1) await Srv_ImportExport.ImportClient();
    }
    reload();
  }

  void AffMessage(String title, String body) {
    print('AffMessage');

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              surfaceTintColor: Colors.white,
              title: Column(
                  //Slide3
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage('assets/images/AppIco.png'),
                      height: 50,
                    ),
                    const SizedBox(height: 8.0),
                    Container(color: Colors.grey, height: 1.0),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ]),
              content: Text(body),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text(
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
