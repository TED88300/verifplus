import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Art.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';

class Client_Groupe_Parc_Inter_ArticleAv_Dialog {
  Client_Groupe_Parc_Inter_ArticleAv_Dialog();

  static Future<void> Dialogs_SaisieAv(
    BuildContext context,
  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => Client_Groupe_Parc_Inter_ArticleDialog(),
    );
  }
}

//**********************************
//**********************************
//**********************************

class Client_Groupe_Parc_Inter_ArticleDialog extends StatefulWidget {
  const Client_Groupe_Parc_Inter_ArticleDialog({
    Key? key,
  }) : super(key: key);

  @override
  Client_Groupe_Parc_Inter_ArticleDialogState createState() => Client_Groupe_Parc_Inter_ArticleDialogState();
}

class Client_Groupe_Parc_Inter_ArticleDialogState extends State<Client_Groupe_Parc_Inter_ArticleDialog> {
  Widget wIco = Container();

  Parc_Art save_Parc_Art = Parc_Art();

  int currentIndex = 0;

  List<Widget> widgets = [];
  final pageController = PageController(keepPage: false);

  @override
  void initLib() async {}

  @override
  void initState() {
    initLib();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget wTitre() {
    return
      Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
        child:
        Row(
          children: [
            Image.asset(
              "assets/images/Icon_Warning.png",
              height: 70,
            ),
            Container(
              width: 20,
            ),
            Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Avertissement - ${DbTools.gParam_Av.Param_Av_No}",
                textAlign: TextAlign.center,
                style: gColors.bodyTitle1_B_G_20,
              ),
              Container(
                height: 4,
              ),
              Text(
                "N° de Certification NF 074 : ${DbTools.gParc_Ent.Parcs_NCERT}",
                textAlign: TextAlign.center,
                style: gColors.smallSaisie_N_G,
              ),
              Container(
                height: 2,
              ),
              Text(
                "Fabricant : ${DbTools.gParc_Ent.Parcs_FAB}",
                textAlign: TextAlign.center,
                style: gColors.smallSaisie_N_G,
              ),
              Container(
                height: 8,
              ),
            ]),
          ],
        )
      );

  }

  Widget wDet() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            gColors.DescTextSmall(context, 539, DbTools.gParam_Av.Param_Av_Det, 90),
          ],
        ),
      ),
    );
  }

  Widget wProc() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            gColors.DescTextSmall(context, 539, DbTools.gParam_Av.Param_Av_Proc, 90),
          ],
        ),
      ),
    );
  }

  Widget wLnk() {
    List<Widget> Btns = [];

    List<String> Lnks = DbTools.gParam_Av.Param_Av_Lnk.split("]");
    for (int i = 0; i < Lnks.length; i++) {
      String Lnk = Lnks[i];
      List<String> Lbls = Lnk.split("[");
      if (Lbls.length == 2) {
        Widget Btn = ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: gColors.white,
            elevation: 0,
          ),
          child: Container(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: Text(
              '${Lbls[0].trim()}',
              style: gColors.smallSaisie_N_G.copyWith(color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
          onPressed: () async {
            await HapticFeedback.vibrate();
            print("LNK ${Lbls[1].trim()}");
            var url = Uri.parse('${Lbls[1].trim()}');
            if (await canLaunchUrl(url)) {
              await launchUrl(url, webOnlyWindowName: '_blank');
            } else {
              throw 'Could not launch $url';
            }
          },
        );

        Btns.add(Btn);
      }
    }

    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Scrollbar(
                child: ListView.separated(
              padding: const EdgeInsets.all(0.0),
              shrinkWrap: true,
              itemCount: Btns.length,
              itemBuilder: (context, index) {
                return Btns[index];
              },
              separatorBuilder: (BuildContext context, int index) => Container(height: 0, width: double.infinity, color: gColors.greyDark),
            )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController(initialScrollOffset: 0);
    double wDialogHeight = MediaQuery.of(context).size.height;
    double IcoWidth = 40;

    print("  AffisOU ");

    widgets = [
      wDet(),
      wProc(),
      wLnk(),
    ];

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      backgroundColor: Colors.yellow,
      title: wTitre(),
      contentPadding: EdgeInsets.zero,
      content: Container(
        color: gColors.white,
        height: wDialogHeight,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              color: gColors.black,
              height: 1,
            ),
            Container(
              color: gColors.greyLight,
              height: 10,
            ),
            Container(
              color: gColors.greyLight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  new ElevatedButton(
                    onPressed: () async {
                      await HapticFeedback.vibrate();
                      pageController.jumpToPage(0);
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // <-- Radius
                        ),
                        elevation: 0,
                        backgroundColor: currentIndex == 0 ? gColors.LinearGradient4 : gColors.greyLight,
                        side: const BorderSide(
                          width: 1.0,
                          color: gColors.greyLight,
                        )),
                    child: Container(
                      width: 120,
                      height: 50,
                      child: Center(
                        child: Text('Détails', style: currentIndex == 0 ? gColors.bodyTitle1_N_G_20 : gColors.bodyTitle1_N_Gr),
                      ),
                    ),
                  ),
                  new ElevatedButton(
                      onPressed: () async {
                        await HapticFeedback.vibrate();
                        pageController.jumpToPage(1);
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // <-- Radius
                          ),
                          elevation: 0,
                          backgroundColor: currentIndex == 1 ? gColors.LinearGradient4 : gColors.greyLight,
                          side: const BorderSide(
                            width: 1.0,
                            color: gColors.greyLight,
                          )),
                      child: Container(
                          width: 120,
                          height: 50,
                          child: Center(
                            child: Text('Procédure', style: currentIndex == 1 ? gColors.bodyTitle1_N_G_20 : gColors.bodyTitle1_N_Gr),
                          ))),
                  new ElevatedButton(
                    onPressed: () async {
                      await HapticFeedback.vibrate();
                      pageController.jumpToPage(2);
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // <-- Radius
                        ),
                        elevation: 0,
                        backgroundColor: currentIndex == 2 ? gColors.LinearGradient4 : gColors.greyLight,
                        side: const BorderSide(
                          width: 1.0,
                          color: gColors.greyLight,
                        )),
                    child: Container(
                        width: 120,
                        height: 50,
                        child: Center(
                          child: Text('Liens', style: currentIndex == 2 ? gColors.bodyTitle1_N_G_20 : gColors.bodyTitle1_N_Gr),
                        )),
                  ),
                ],
              ),
            ),
            Container(
              color: gColors.greyLight,
              height: 10,
            ),
            Container(
              color: gColors.greyDark,
              height: 1,
            ),
            Expanded(
              child: PageView(
                children: widgets,
                controller: pageController,
                onPageChanged: onBottomIconPressed,
              ),
            ),
            Container(
              color: gColors.black,
              height: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Valider(context),
              ],
            ),
            Container(
              color: Colors.white,
              height: 1,
            ),
          ],
        ),
      ),
    );
  }

  void onBottomIconPressed(int index) async {
    currentIndex = index;
    setState(() {});
  }

  Valider(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
      width: 560,
      color: gColors.greyLight,
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
          Spacer(),

          new ElevatedButton(
              onPressed: () async {
                await HapticFeedback.vibrate();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // <-- Radius
                  ),
                  elevation: 0,
                  backgroundColor: gColors.primaryGreen,                  side: const BorderSide(
                    width: 1.0,
                    color: gColors.greyLight,
                  )),
              child: Container(
                  width: 120,
                  height: 50,
                  child: Center(
                    child: Text('Valider', style:gColors.bodyTitle1_B_Wr ),
                  ))),

        ],
      ),
    );
  }
}
