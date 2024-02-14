import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marquee/marquee.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:http/http.dart' as http;
import 'package:davi/davi.dart';


class Certif {
  Certif(this.ON, this.Type, this.Delivrance, this.Reserve, this.Url);
  final String ON;
  final String Type;
  final String Delivrance;
  final String Reserve;
  final String Url;
}

class gObj {
  gObj();
  static double LargeurScreen = 0;

  static double LargeurLabel = 150;

  static Uint8List pic = Uint8List.fromList([0]);
  static Uint8List picUser = Uint8List.fromList([0]);
  static late Image wImage;

  static String gTitre = "";
  static String gTitre2 = "";
  static String gTitre3 = "";
  static String gTitre4 = "";

  static String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  static String printDurationHHMM(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
  }

  static Widget SquareRoundIcon(BuildContext context, double wsize, double wradius, Color bckcolor, Color color, IconData icon, VoidCallback onTapVoidCallback) {
    return InkWell(
      child: Container(
        width: wsize,
        height: wsize,
        decoration: BoxDecoration(color: bckcolor, borderRadius: BorderRadius.all(Radius.circular(wradius)), border: Border.all(color: gColors.LinearGradient1)),
        child: Icon(
          icon,
          color: color,
          size: wsize * 0.8,
        ),
      ),
      onTap: () async {
        print("SquareRoundIcon TAP");

        onTapVoidCallback();
      },
    );
  }

  static Widget InterventionTitleWidgetCalc(BuildContext context, String wTitre, {String wTitre2 = "", String wTitre3 = "", String wTitre4 = "", int wTimer = 0}) {
    final now = Duration(seconds: wTimer);
    double tpwidth = 0;
    double tpwidth2 = 0;
    double tpwidth3 = 0;
    double tpwidth4 = 0;

    String wString2Tmp = "";
    var textspan = TextSpan(
      text: "${wTitre}",
      style: gColors.bodyTitle1_B_Gr,
    );
    var tp = TextPainter(text: textspan, textDirection: TextDirection.ltr);
    tp.layout();
    tpwidth = tp.width;

    if (wTitre2.isNotEmpty) {
      var textspan = TextSpan(
        text: " / $wTitre2",
        style: gColors.bodyTitle1_N_Gr,
      );
      var tp = TextPainter(text: textspan, textDirection: TextDirection.ltr);
      tp.layout();
      tpwidth2 = tp.width;
    }
    if (wTitre3.isNotEmpty) {
      var textspan = TextSpan(
        text: " / $wTitre3",
        style: gColors.bodyTitle1_N_Gr,
      );
      var tp = TextPainter(text: textspan, textDirection: TextDirection.ltr);
      tp.layout();
      tpwidth3 = tp.width;
    }
    if (wTitre4.isNotEmpty) {
      var textspan = TextSpan(
        text: " / $wTitre4",
        style: gColors.bodyTitle1_N_Gr,
      );
      var tp = TextPainter(text: textspan, textDirection: TextDirection.ltr);
      tp.layout();
      tpwidth4 = tp.width;
    }

    double wLargeurScreen = gObj.LargeurScreen - 20;
    if ((tpwidth + tpwidth2 + tpwidth3 + tpwidth4) <= wLargeurScreen) {
      if (wTitre2.isNotEmpty) wString2Tmp = "$wString2Tmp / $wTitre2";
      if (wTitre3.isNotEmpty) wString2Tmp = "$wString2Tmp / $wTitre3";
      if (wTitre4.isNotEmpty) wString2Tmp = "$wString2Tmp / $wTitre4";
    } else if ((tpwidth + tpwidth3 + tpwidth4) <= wLargeurScreen) {
      if (wTitre2.isNotEmpty) wString2Tmp = "$wString2Tmp /...";
      if (wTitre3.isNotEmpty) wString2Tmp = "$wString2Tmp / $wTitre3";
      if (wTitre4.isNotEmpty) wString2Tmp = "$wString2Tmp / $wTitre4";
    } else if ((tpwidth + tpwidth4) <= wLargeurScreen) {
      if (wTitre2.isNotEmpty) wString2Tmp = "$wString2Tmp /...";
      if (wTitre3.isNotEmpty) wString2Tmp = "$wString2Tmp /...";
      if (wTitre4.isNotEmpty) wString2Tmp = "$wString2Tmp / $wTitre4";
    }

    return Material(
        elevation: 4,
        child: InkWell(
          onTap: () async {
            gTitre = wTitre;
            gTitre2 = wTitre2;
            gTitre3 = wTitre3;
            gTitre4 = wTitre4;

            await HapticFeedback.vibrate();
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Container(padding: EdgeInsets.fromLTRB(30, 0, 30, 30), child: Titre_Popup());
                });
          },
          child: Container(
            height: 57,
            padding: EdgeInsets.fromLTRB(10, 12, 10, 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
//          Spacer(),
              Text(
                "${wTitre}",
                style: gColors.bodyTitle1_B_Gr,
                textAlign: TextAlign.center,
              ),
              wTitre2.isEmpty
                  ? Container()
                  : Text(
                      "$wString2Tmp",
                      style: gColors.bodyTitle1_N_Gr,
                      textAlign: TextAlign.center,
                    ),
              Spacer(),
              wTimer == 0
                  ? Container()
                  : Text(
                      "${printDurationHHMM(now)}",
                    ),
            ]),
          ),
        ));
  }

  static Widget InterventionTitleWidget(String wTitre, {String wTitre2 = "", int wTimer = 0}) {
    final now = Duration(seconds: wTimer);
    var textspan = TextSpan(
      text: "${wTitre}",
      style: gColors.bodyTitle1_B_Gr,
    );
    var tp = TextPainter(text: textspan, textDirection: TextDirection.ltr);
    tp.layout();
    var textspan2 = TextSpan(
      text: " / $wTitre2",
      style: gColors.bodyTitle1_N_Gr,
    );
    var tp2 = TextPainter(text: textspan2, textDirection: TextDirection.ltr);
    tp2.layout();
//    print(' text width: ${tp.width} ${tp2.width}');

    return Material(
      color: gColors.LinearGradient2,
      elevation: 4,
      child: Container(
        height: 57,
        padding: EdgeInsets.fromLTRB(10, 12, 10, 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
//          Spacer(),
          Text(
            "${wTitre}",
            style: gColors.bodyTitle1_B_Gr,
            textAlign: TextAlign.center,
          ),
          wTitre2.isEmpty
              ? Container()
              : AutoSizeText(
                  " / $wTitre2",
                  style: gColors.bodyTitle1_N_Gr,
                  textAlign: TextAlign.center,
                ),
          Spacer(),
          wTimer == 0
              ? Container()
              : Text(
                  "${printDurationHHMM(now)}",
                ),
        ]),
      ),
    );
  }

  static Widget InterventionTitleWidgetScroll(String wTitre, {String wTitre2 = "", int wTimer = 0}) {
    final now = Duration(seconds: wTimer);

    return Material(
      elevation: 4,
      child: Container(
        height: 57,
        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
        child: Marquee(
          text: "${wTitre}  / $wTitre2",
          style: gColors.bodyTitle1_B_G_20,
          scrollAxis: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          blankSpace: 100.0,
          velocity: 50.0,
          pauseAfterRound: Duration(seconds: 3),
          startPadding: 10.0,
          accelerationDuration: Duration(seconds: 1),
          accelerationCurve: Curves.linear,
          decelerationDuration: Duration(seconds: 1),
          decelerationCurve: Curves.easeOut,
        ),
      ),
    );
  }

  static Widget InterventionTitleWidget2(int count) {
    final now = Duration(seconds: count);
    return Material(
      elevation: 4,
      child: Container(
        height: 57,
        padding: EdgeInsets.fromLTRB(10, 12, 10, 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            width: 68,
          ),
          Spacer(),
          Text(
            "${Srv_DbTools.gIntervention.Intervention_Type}/${Srv_DbTools.gIntervention.Intervention_Parcs_Type} - ${Srv_DbTools.gIntervention.Intervention_Status} - Cr N° : ${Srv_DbTools.gIntervention.InterventionId} -Anthony FUNDONI",
            style: gColors.bodySaisie_B_G,
            textAlign: TextAlign.center,
          ),
          Spacer(),
          Container(
            width: 50,
            child: Text("${printDurationHHMM(now)}"),
          ),
          Container(
            width: 8,
          ),
        ]),
      ),
    );
  }

  static Widget InfoWidget(BuildContext context, bool isModifiable) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 8, 10, 0),
      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: BoxDecoration(
          border: Border.all(
            color: gColors.LinearGradient1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: LargeurLabel,
                padding: EdgeInsets.fromLTRB(0, 0, 12, 0),
                child: Text(
                  "Status :",
                  style: gColors.bodySaisie_N_G,
                  textAlign: TextAlign.right,
                ),
              ),
              Text(
                "${Srv_DbTools.gIntervention.Intervention_Status}",
                style: gColors.bodySaisie_N_G,
              ),
            ],
          ),
          Container(
            height: 8,
          ),
          Row(
            children: [
              Container(
                width: LargeurLabel,
                padding: EdgeInsets.fromLTRB(0, 0, 12, 0),
                child: Text(
                  "Inrevenant(s) :",
                  style: gColors.bodySaisie_N_G,
                  textAlign: TextAlign.right,
                ),
              ),
              Text(
                "16-Anthony FUNDONI / 107-Romain RACIOPPI",
                style: gColors.bodySaisie_N_G,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget Adr_Fact(BuildContext context) {
    return Container(
      width: 584,
      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: BoxDecoration(
          border: Border.all(
            color: gColors.LinearGradient1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Container(
                width: LargeurLabel,
                padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: Text(
                  "Adresse de facturation : ",
                  style: gColors.bodySaisie_B_G,
                  textAlign: TextAlign.right,
                ),
              ),
              Text(
                "${Srv_DbTools.gAdresse.Adresse_Adr1}",
                style: gColors.bodySaisie_B_G,
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: LargeurLabel,
              ),
              Text(
                "${Srv_DbTools.gAdresse.Adresse_Adr2}",
                style: gColors.bodySaisie_B_G,
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: LargeurLabel,
              ),
              Text(
                "${Srv_DbTools.gAdresse.Adresse_CP} ${Srv_DbTools.gAdresse.Adresse_Ville}",
                style: gColors.bodySaisie_B_G,
              ),
            ],
          ),
        ]),
        Container(
          height: 8,
        ),
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width - 16,
          color: gColors.LinearGradient3,
        ),
        Container(
          height: 8,
        ),
        Row(
          children: [
            Container(
              width: LargeurLabel,
              padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: Text(
                "Contact de facturation : ",
                style: gColors.bodySaisie_B_B,
                textAlign: TextAlign.right,
              ),
            ),
            Text(
              "${Srv_DbTools.gContact.Contact_Prenom} ${Srv_DbTools.gContact.Contact_Nom}",
              style: gColors.bodySaisie_B_G,
            ),
          ],
        ),
        Container(
          height: 8,
        ),
        Row(
          children: [
            Container(
              width: LargeurLabel,
              padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: Text(
                "Tel Fixe : ",
                style: gColors.bodySaisie_N_B,
                textAlign: TextAlign.right,
              ),
            ),
            Text(
              "${Srv_DbTools.gContact.Contact_Tel1}",
              style: gColors.bodySaisie_N_G,
            ),
          ],
        ),
        Container(
          height: 8,
        ),
        Row(
          children: [
            Container(
              width: LargeurLabel,
              padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: Text(
                "Tel Portable : ",
                style: gColors.bodySaisie_N_B,
                textAlign: TextAlign.right,
              ),
            ),
            Text(
              "${Srv_DbTools.gContact.Contact_Tel2}",
              style: gColors.bodySaisie_N_G,
            ),
          ],
        ),
        Container(
          height: 8,
        ),
        Row(
          children: [
            Container(
              width: LargeurLabel,
              padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: Text(
                "Mail Contact : ",
                style: gColors.bodySaisie_N_B,
                textAlign: TextAlign.right,
              ),
            ),
            Text(
              "${Srv_DbTools.gContact.Contact_eMail}",
              style: gColors.bodySaisie_N_G,
            ),
          ],
        ),
        Container(
          height: 8,
        ),
        Row(
          children: [
            Container(
              width: LargeurLabel,
              padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: Text(
                "Service : ",
                style: gColors.bodySaisie_N_B,
                textAlign: TextAlign.right,
              ),
            ),
            Text(
              "${Srv_DbTools.gContact.Contact_Service} ${Srv_DbTools.gContact.Contact_Fonction}",
              style: gColors.bodySaisie_N_G,
            ),
          ],
        ),
      ]),
    );
  }

  static Widget Adr_Site(BuildContext context) {
    return Container(
      width: 584,
      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: BoxDecoration(
          border: Border.all(
            color: gColors.LinearGradient1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Container(
                width: LargeurLabel,
                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Text(
                  "Adresse du site : ",
                  style: gColors.bodySaisie_B_B,
                  textAlign: TextAlign.right,
                ),
              ),
              Text(
                "${Srv_DbTools.gSite.Site_Nom}",
                style: gColors.bodySaisie_B_G,
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: LargeurLabel,
              ),
              Text(
                "${Srv_DbTools.gSite.Site_Adr1}",
                style: gColors.bodySaisie_B_G,
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: LargeurLabel,
              ),
              Text(
                "${Srv_DbTools.gSite.Site_Adr2}",
                style: gColors.bodySaisie_B_G,
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: LargeurLabel,
              ),
              Text(
                "${Srv_DbTools.gSite.Site_CP} ${Srv_DbTools.gSite.Site_Ville}",
                style: gColors.bodySaisie_B_G,
              ),
            ],
          ),
        ]),
        Container(
          height: 8,
        ),
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width - 16,
          color: gColors.LinearGradient3,
        ),
        Container(
          height: 8,
        ),
        Row(
          children: [
            Container(
              width: LargeurLabel,
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text(
                "Contact du site : ",
                style: gColors.bodySaisie_B_B,
                textAlign: TextAlign.right,
              ),
            ),
            Text(
              "${Srv_DbTools.gContact.Contact_Prenom} ${Srv_DbTools.gContact.Contact_Nom}",
              style: gColors.bodySaisie_B_G,
            ),
          ],
        ),
        Container(
          height: 8,
        ),
        Row(
          children: [
            Container(
              width: LargeurLabel,
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text(
                "Tel Fixe : ",
                style: gColors.bodySaisie_N_B,
                textAlign: TextAlign.right,
              ),
            ),
            Text(
              "${Srv_DbTools.gContact.Contact_Tel1}",
              style: gColors.bodySaisie_N_G,
            ),
          ],
        ),
        Container(
          height: 8,
        ),
        Row(
          children: [
            Container(
              width: LargeurLabel,
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text(
                "Tel Portable : ",
                style: gColors.bodySaisie_N_B,
                textAlign: TextAlign.right,
              ),
            ),
            Text(
              "${Srv_DbTools.gContact.Contact_Tel2}",
              style: gColors.bodySaisie_N_G,
            ),
          ],
        ),
        Container(
          height: 8,
        ),
        Row(
          children: [
            Container(
              width: LargeurLabel,
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text(
                "Mail Contact : ",
                style: gColors.bodySaisie_N_B,
                textAlign: TextAlign.right,
              ),
            ),
            Text(
              "${Srv_DbTools.gContact.Contact_eMail}",
              style: gColors.bodySaisie_N_G,
            ),
          ],
        ),
        Container(
          height: 8,
        ),
        Row(
          children: [
            Container(
              width: LargeurLabel,
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text(
                "Service : ",
                style: gColors.bodySaisie_N_B,
                textAlign: TextAlign.right,
              ),
            ),
            Text(
              "${Srv_DbTools.gContact.Contact_Service} / ${Srv_DbTools.gContact.Contact_Fonction}",
              style: gColors.bodySaisie_N_G,
            ),
          ],
        ),
      ]),
    );
  }

  static Widget Adr_Client(BuildContext context) {
    return Container(
      width: 584,
      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: BoxDecoration(
          border: Border.all(
            color: gColors.LinearGradient1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Container(
                width: LargeurLabel,
                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Text(
                  "Adresse Client : ",
                  style: gColors.bodySaisie_B_B,
                  textAlign: TextAlign.right,
                ),
              ),
              Text(
                "${Srv_DbTools.gAdresse.Adresse_Adr1}",
                style: gColors.bodySaisie_B_G,
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: LargeurLabel,
              ),
              Text(
                "${Srv_DbTools.gAdresse.Adresse_Adr2}",
                style: gColors.bodySaisie_B_G,
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: LargeurLabel,
              ),
              Text(
                "${Srv_DbTools.gAdresse.Adresse_CP} ${Srv_DbTools.gAdresse.Adresse_Ville}",
                style: gColors.bodySaisie_B_G,
              ),
            ],
          ),
        ]),
        Container(
          height: 8,
        ),
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width - 16,
          color: gColors.LinearGradient3,
        ),
        Container(
          height: 8,
        ),
        Row(
          children: [
            Container(
              width: LargeurLabel,
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text(
                "Contact Client : ",
                style: gColors.bodySaisie_B_B,
                textAlign: TextAlign.right,
              ),
            ),
            Text(
              "${Srv_DbTools.gContact.Contact_Prenom} ${Srv_DbTools.gContact.Contact_Nom}",
              style: gColors.bodySaisie_B_G,
            ),
          ],
        ),
        Container(
          height: 8,
        ),
        Row(
          children: [
            Container(
              width: LargeurLabel,
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text(
                "Tel Fixe : ",
                style: gColors.bodySaisie_N_B,
                textAlign: TextAlign.right,
              ),
            ),
            Text(
              "${Srv_DbTools.gContact.Contact_Tel1}",
              style: gColors.bodySaisie_N_G,
            ),
          ],
        ),
        Container(
          height: 8,
        ),
        Row(
          children: [
            Container(
              width: LargeurLabel,
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text(
                "Tel Portable : ",
                style: gColors.bodySaisie_N_B,
                textAlign: TextAlign.right,
              ),
            ),
            Text(
              "${Srv_DbTools.gContact.Contact_Tel2}",
              style: gColors.bodySaisie_N_G,
            ),
          ],
        ),
        Container(
          height: 8,
        ),
        Row(
          children: [
            Container(
              width: LargeurLabel,
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text(
                "Mail Contact : ",
                style: gColors.bodySaisie_N_B,
                textAlign: TextAlign.right,
              ),
            ),
            Text(
              "${Srv_DbTools.gContact.Contact_eMail}",
              style: gColors.bodySaisie_N_G,
            ),
          ],
        ),
        Container(
          height: 8,
        ),
        Row(
          children: [
            Container(
              width: LargeurLabel,
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text(
                "Service : ",
                style: gColors.bodySaisie_N_B,
                textAlign: TextAlign.right,
              ),
            ),
            Text(
              "${Srv_DbTools.gContact.Contact_Service} / ${Srv_DbTools.gContact.Contact_Fonction}",
              style: gColors.bodySaisie_N_G,
            ),
          ],
        ),
      ]),
    );
  }

  static Widget Adr_Groupe(BuildContext context) {
    return Container(
      width: 584,
      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: BoxDecoration(
          border: Border.all(
            color: gColors.LinearGradient1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Container(
                width: LargeurLabel,
                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Text(
                  "Adresse Groupe : ",
                  style: gColors.bodySaisie_B_B,
                  textAlign: TextAlign.right,
                ),
              ),
              Text(
                "${Srv_DbTools.gGroupe.Groupe_Nom}",
                style: gColors.bodySaisie_B_G,
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: LargeurLabel,
              ),
              Text(
                "${Srv_DbTools.gGroupe.Groupe_Adr1}",
                style: gColors.bodySaisie_B_G,
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: LargeurLabel,
              ),
              Text(
                "${Srv_DbTools.gGroupe.Groupe_Adr2}",
                style: gColors.bodySaisie_B_G,
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: LargeurLabel,
              ),
              Text(
                "${Srv_DbTools.gGroupe.Groupe_CP} ${Srv_DbTools.gGroupe.Groupe_Ville}",
                style: gColors.bodySaisie_B_G,
              ),
            ],
          ),
        ]),
      ]),
    );
  }

  static Widget AffCertif() {
    DaviModel<Certif>? _model;

    List<Certif> rows = [
      Certif('Oui', "N4", "01/01/2018", "Non", ""),
      Certif('Oui', "Q4", "01/01/2019", "Non", ""),
      Certif('Oui', "Q4", "01/01/2020", "Non", ""),
      Certif('Oui', "Q4", "01/01/2021", "Oui", ""),
    ];

    _model = DaviModel<Certif>(rows: rows, columns: [
      DaviColumn(
        name: 'O/N',
        width: 45,
        stringValue: (row) => row.ON,
        headerAlignment: Alignment.center,
        cellAlignment: Alignment.center,
      ),
      DaviColumn(
        name: 'Type',
        width: 50,
        stringValue: (row) => row.Type,
        headerAlignment: Alignment.center,
        cellAlignment: Alignment.center,
      ),
      DaviColumn(
        name: 'Délivrance',
        width: 90,
        stringValue: (row) => row.Delivrance,
        headerAlignment: Alignment.center,
        cellAlignment: Alignment.center,
      ),
      DaviColumn(
        name: 'Réserve(s)',
        width: 90,
        stringValue: (row) => row.Reserve,
        headerAlignment: Alignment.center,
        cellAlignment: Alignment.center,
      ),
      DaviColumn(
          name: 'Dossier PDF',
          width: 100,
          headerAlignment: Alignment.center,
          cellAlignment: Alignment.center,
          cellBuilder: (BuildContext context, DaviRow<Certif> data) {
            return Icon(
              Icons.file_download,
            );
          }),
    ]);

    return Container(
        width: 584,
        margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
        padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
        decoration: BoxDecoration(
            border: Border.all(
              color: gColors.LinearGradient1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: LargeurLabel,
                padding: EdgeInsets.fromLTRB(8, 12, 0, 0),
                child: Text(
                  "Site certifé APSAD",
                  style: gColors.bodySaisie_N_B,
                ),
              ),
              Container(
                width: 382,
                child: DaviTheme(
                  child: Davi<Certif>(
                    _model,
                    visibleRowsCount: 4,
                  ),
                  data: DaviThemeData(
                    header: HeaderThemeData(
                      color: gColors.LinearGradient3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]));
  }

  static Future<Widget> getAssetImage(String path) async {
    //print("getAssetImage path ${path}");
    try {
      await rootBundle.load(path);
      return Image.asset(
        path,
        height: 140,
      );
    } catch (_) {
      return SizedBox(); // Return this widget
    }
  }

  static Future<Uint8List> networkImageToByte(String path) async {
    try {
      var response = await http.get(Uri.parse(path.toString()));
      if (response.statusCode == 200) {
//        print("networkImageToByte 200");
        return response.bodyBytes;
      } else {
//        print("networkImageToByte Error");
        return new Uint8List(0);
      }
    } catch (e) {
      return new Uint8List(0);
    }
  }

  static Future<void> AffMessageInfo(BuildContext context, String title, String body) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => new AlertDialog(
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              title: Text(
                "${title}",
                style: gColors.bodyTitle1_B_Pr,
                textAlign: TextAlign.center,
              ),
              content: Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0), // TED
                child: Text(
                  "${body}",
                  style: gColors.bodyTitle1_N_G,
                  textAlign: TextAlign.center,
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        alignment: Alignment.center,
                        backgroundColor: Colors.grey,
                        //padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      ),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )
              ],
            ));
  }

/*

  static Widget DropdownButtonMission(String initValue, Function(String? Value) onChanged, List<String> wlistTypeinter, List<String> wlistTypeinterid) {

    print("DropdownButtonTypeInter ${wlistTypeinter.length}");
    print("DropdownButtonTypeInter initValue $initValue");
    print("DropdownButtonTypeInter wList_TypeInter ${wlistTypeinter.toString()}");
    print("DropdownButtonTypeInter wList_TypeInterID ${wlistTypeinterid.toString()}");

    if (wlistTypeinter.length == 0) return Container();

    List<DropdownMenuItem> dropdownlist = wlistTypeinter
        .map((item) => DropdownMenuItem<String>(
      value: item,
      child: Text(
        "$item",
        style: gColors.bodySaisie_B_B,
      ),
    ))
        .toList();


    if (wlistTypeinter.indexOf(initValue) <0)
      return Container();

    String wID = wlistTypeinterid[wlistTypeinter.indexOf(initValue)];


    return Row(children: [

      Container(
        child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              items: dropdownlist,
              value: initValue,
              onChanged: (value) {
                initValue = value as String;
                onChanged(initValue);
              },
              buttonHeight: 30,
              dropdownMaxHeight: 800,
              itemHeight: 32,
            )),
      ),
    ]);
  }


*/

/*
  static Widget DropdownButtonFam(double lWidth, double wWidth, String wLabel, String initValue, Function(String? Value) onChanged, List<String> wListParam_ParamFam, List<String> wListParam_ParamFamID) {
    if (wListParam_ParamFam.length == 0) return Container();

    List<DropdownMenuItem> dropdownlist = wListParam_ParamFam
        .map((item) => DropdownMenuItem<String>(
      value: item,
      child:
      Text(
        "${item}",
      ),
    ))
        .toList();

    print("DropdownButtonFam initValue ${initValue}");
    String wID = wListParam_ParamFamID[wListParam_ParamFam.indexOf(initValue!)];
    print("DropdownButtonFam wID ${wID}");

    return

      Row(children: [
        Container(
          width: 60,
          child: Text(
            "${wLabel} :",
            style: gColors.bodySaisie_B_G,
          ),
        ),

        Container(
        child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              items: dropdownlist,
              value: initValue,
              onChanged: (value) {
                initValue = value as String;
                onChanged(initValue);
              },
              buttonPadding: const EdgeInsets.only(left: 5, right: 5),
              buttonHeight: 30,
              dropdownMaxHeight: 800,
              itemHeight: 32,
            )),
      ),
    ]);
  }
  static Widget DropdownButtonDepot(double lWidth, double wWidth, String wLabel, String initValue, Function(String? Value) onChanged, List<String> wListParam_ParamDepot, List<String> wListParam_ParamDepotID) {
    if (wListParam_ParamDepot.length == 0) return Container();

    List<DropdownMenuItem> dropdownlist = wListParam_ParamDepot
        .map((item) => DropdownMenuItem<String>(
      value: item,
      child: Text(
        "${item}",
      ),
    ))
        .toList();

    print("DropdownButtonDepot initValue ${initValue}");
    String wID = wListParam_ParamDepotID[wListParam_ParamDepot.indexOf(initValue!)];
    print("DropdownButtonDepot wID ${wID}");

    return

      Row(children: [
        Container(
          width: 60,
          child: Text(
            "${wLabel} :",
            style: gColors.bodySaisie_B_G,
          ),
        ),

        Container(
          child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                items: dropdownlist,
                value: initValue,
                onChanged: ( value) {
                  initValue = value as String;
                  onChanged(initValue);
                },
                buttonPadding: const EdgeInsets.only(left: 5, right: 5),
                buttonHeight: 30,
                dropdownMaxHeight: 800,
                itemHeight: 32,
              )),
        ),
      ]);
  }
  static Widget DropdownButtonType(double lWidth, double wWidth, String wLabel, String initValue, Function(String? Value) onChanged, List<Param_Saisie_Param> wListParam_Saisie_Param) {

    print("DropdownButtonType > wListParam_Saisie_Param.length ${wListParam_Saisie_Param.length} (${initValue})");

    if (initValue == 0) return Container();
    if (wListParam_Saisie_Param.length == 0) return Container();

    List<DropdownMenuItem> dropdownlist = wListParam_Saisie_Param
        .map((item) => DropdownMenuItem<String>(
      value: item.Param_Saisie_Param_Label,
      child: Text(
        "${item.Param_Saisie_Param_Label}",
      ),
    ))
        .toList();



    return Row(children: [
      Container(
        width: 60,
        child: Text(
          "${wLabel} :",
          style: gColors.bodySaisie_B_G,
        ),
      ),

      Container(
        child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              items: dropdownlist,
              value: initValue,
              onChanged: (value) {
                initValue = value as String;
                onChanged(initValue);
              },
              buttonPadding: const EdgeInsets.only(left: 5, right: 5),
              buttonHeight: 30,
              dropdownMaxHeight: 800,
              itemHeight: 32,
            )),
      ),
    ]);
  }
*/
}

//**********************************
//**********************************
//**********************************

class Titre_Popup extends StatefulWidget {
  @override
  Titre_PopupState createState() => Titre_PopupState();
}

class Titre_PopupState extends State<Titre_Popup> {
  void Reload() async {
    setState(() {});
  }

  @override
  void initLib() async {
    Reload();
  }

  @override
  void initState() {
    initLib();
  }

  @override
  Widget build(BuildContext context) {
    double wDialogHeight = 160;

    String wTitre = "";
    if (gObj.gTitre2.isNotEmpty) {wTitre = "$wTitre ${gObj.gTitre2}\n";}
    if (gObj.gTitre3.isNotEmpty) {wTitre = "$wTitre ${gObj.gTitre3}\n";}
    if (gObj.gTitre4.isNotEmpty) {wTitre = "$wTitre ${gObj.gTitre4}\n";}

    return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
        backgroundColor: gColors.white,
        title: Container(
            color: gColors.white,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
            child: Column(
              children: [
                Text(
                  "${gObj.gTitre}",
                  textAlign: TextAlign.center,
                  style: gColors.bodyTitle1_B_G_20,
                ),
                Container(
                  height: 8,
                ),
              ],
            )),
        contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
        content: SingleChildScrollView(
          // won't be scrollable
          child: Container(
              color: gColors.greyLight,
              height: wDialogHeight,
//          width: 600,
              child: Column(
                children: [
                  Container(
                    color: gColors.black,
                    height: 1,
                  ),
                  Container(
                    color: gColors.greyLight,
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                    child: Text(
                      "${wTitre}",
                      textAlign: TextAlign.center,
                      style: gColors.bodyTitle1_N_G_20,
                    ),
                  ),
                ],
              )),
        ));
  }
}
