import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Widget/Client/Client_Dialog.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter.dart';
import 'package:verifplus/Widget/Planning/Client_Groupe_Inter_Det_Popup.dart';
import 'package:verifplus/Widget/Planning/Missions_Dialog.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

class Client_Groupe_Inter_Det extends StatefulWidget {
  @override
  Client_Groupe_Inter_DetState createState() => Client_Groupe_Inter_DetState();
}

class Client_Groupe_Inter_DetState extends State<Client_Groupe_Inter_Det> {
  double icoWidth = 38;
  bool affEdtFilter = false;
  TextEditingController ctrlFilter = new TextEditingController();
  String filterText = '';

  DateTime minStartTime = DateTime(2900, 1, 1);
  DateTime maxEndTime = DateTime(1900, 1, 1);

  String Plannification = "";
  String wIntervenants = "";
  String wInterMission = "";
  String wAdresse = "";
  String wTel = "";

  List<Widget> ListContact = [];

  void onMaj() async {
    print("Parent onMaj() Relaod()");
  }

  Future Reload() async {
    Filtre();
  }

  void Filtre() {
    setState(() {});
  }

  @override
  void initLib() async {
    await Srv_DbTools.getPlanning_InterventionId(Srv_DbTools.gIntervention.InterventionId!);
    await Srv_DbTools.getPlanning_InterventionIdRes(Srv_DbTools.gIntervention.InterventionId!);
    await Srv_DbTools.getInterMissionsIntervention(Srv_DbTools.gIntervention.InterventionId!);

    bool wMin = false, wMax = false;
    for (int i = 0; i < Srv_DbTools.ListPlanning.length; i++) {
      var element = Srv_DbTools.ListPlanning[i];
      if (element.Planning_InterventionstartTime.isBefore(minStartTime)) {
        minStartTime = element.Planning_InterventionstartTime;
        wMin = true;
      }
      if (element.Planning_InterventionendTime.isAfter(maxEndTime)) {
        maxEndTime = element.Planning_InterventionendTime;
        wMax = true;
      }
    }

    if (minStartTime.year == maxEndTime.year && minStartTime.month == maxEndTime.month && minStartTime.day == maxEndTime.day) {
      String formattedDate = DateFormat('EEEE dd/MM/yy').format(minStartTime);
      String formattedDeb = DateFormat('hh:mm').format(minStartTime);
      String formattedFin = DateFormat('hh:mm').format(maxEndTime);
      Plannification = "Plannifiée $formattedDate $formattedDeb/$formattedFin";
    } else {
      String formattedDateDeb = DateFormat('dd/MM/yy hh:mm').format(minStartTime);
      String formattedDateFin = DateFormat('dd/MM/yy hh:mm').format(maxEndTime);
      Plannification = "Plannifiée $formattedDateDeb - $formattedDateFin";
    }

    for (int i = 0; i < Srv_DbTools.ListUserH.length; i++) {
      var element = Srv_DbTools.ListUserH[i];
      wIntervenants = "$wIntervenants ${wIntervenants.isNotEmpty ? ", " : ""}${element.User_Nom} ${element.User_Prenom} (${element.H}h)";
    }

    for (int i = 0; i < Srv_DbTools.ListInterMission.length; i++) {
      var element = Srv_DbTools.ListInterMission[i];

      if (i == 0)
        wInterMission = "$wInterMission ${element.InterMission_Nom}";
      else if (i == 1) wInterMission = "$wInterMission +";
    }

    if (Srv_DbTools.gZone.Zone_Adr1.isNotEmpty) wAdresse = wAdresse + " " + Srv_DbTools.gZone.Zone_Adr1;
    if (Srv_DbTools.gZone.Zone_Adr2.isNotEmpty) wAdresse = wAdresse + " " + Srv_DbTools.gZone.Zone_Adr2;
    if (Srv_DbTools.gZone.Zone_Adr3.isNotEmpty) wAdresse = wAdresse + " " + Srv_DbTools.gZone.Zone_Adr3;
    if (Srv_DbTools.gZone.Zone_Adr4.isNotEmpty) wAdresse = wAdresse + " " + Srv_DbTools.gZone.Zone_Adr4;
    if (Srv_DbTools.gZone.Zone_CP.isNotEmpty) wAdresse = wAdresse + " " + Srv_DbTools.gZone.Zone_CP;
    if (Srv_DbTools.gZone.Zone_Ville.isNotEmpty) wAdresse = wAdresse + " " + Srv_DbTools.gZone.Zone_Ville;

    ListContact = [
      AffLigne("Type d'intervention", "${Srv_DbTools.gIntervention.Intervention_Type}", gColors.greyLight, "Icon_Inter", Colors.black),
      AffLigne("Plannification", "${Plannification}", gColors.white, "", gColors.primaryOrange),
      AffLigne("Tech Affectés", "${wIntervenants}", gColors.white, "", Colors.black),
      AffLigneCercle("Ordre de mission", "${Srv_DbTools.ListInterMission.length}", gColors.greyLight, "Icon_Mission", gColors.primaryBlue),
      AffBtn("", "", "${wInterMission}", "", gColors.white, gColors.primaryBlue),
      AffLigne("Adresse", "", gColors.greyLight, "Icon_Adr2", gColors.primaryBlue),
      AffBtnMap("", "", "${wAdresse}", "", gColors.white, gColors.black),
      AffLigne("Contact", "", gColors.greyLight, "Icon_Cont2", gColors.primaryBlue),
    ];

    await Srv_DbTools.getContactClientAdrType(Srv_DbTools.gClient.ClientId, Srv_DbTools.gZone.ZoneId, "ZONE");
    for (int i = 0; i < Srv_DbTools.ListContact.length; i++) {
      var element = Srv_DbTools.ListContact[i];
      String wNom = "${element.Contact_Prenom} ${element.Contact_Nom}";
      if (element.Contact_Fonction.isNotEmpty) wNom = wNom + " - ${element.Contact_Fonction}";
      if (element.Contact_Service.isNotEmpty) wNom = wNom + "/${element.Contact_Service}";
      if (element.Contact_Tel1.isNotEmpty) wNom = wNom + " - ${element.Contact_Tel1}";
      if (element.Contact_Tel2.isNotEmpty) wNom = wNom + " - ${element.Contact_Tel2}";
      if (element.Contact_eMail.isNotEmpty) wNom = wNom + " - ${element.Contact_eMail}";
      print("ListContact ${wNom}");
      ListContact.add(AffLigne("    Contact Zone", "$wNom", gColors.white, "", gColors.primaryBlue));
    }

    await Srv_DbTools.getContactClientAdrType(Srv_DbTools.gClient.ClientId, Srv_DbTools.gSite.SiteId, "SITE");
    for (int i = 0; i < Srv_DbTools.ListContact.length; i++) {
      var element = Srv_DbTools.ListContact[i];
      String wNom = "${element.Contact_Prenom} ${element.Contact_Nom}";
      if (element.Contact_Tel1.isNotEmpty) wNom = wNom + " - ${element.Contact_Tel1}";
      if (element.Contact_Tel2.isNotEmpty) wNom = wNom + " - ${element.Contact_Tel2}";
      if (element.Contact_eMail.isNotEmpty) wNom = wNom + " - ${element.Contact_eMail}";
      print("ListContact ${wNom}");
      ListContact.add(AffLigne("    Contact Site", "$wNom", gColors.white, "", gColors.primaryBlue));
    }

    ListContact.add(AffLigne("Note", "", gColors.greyLight, "Icon_Note2", gColors.primaryBlue));

    ListContact.add(
      Expanded(
          child: Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Text(
                "${Srv_DbTools.gIntervention.Intervention_Remarque}",
                textAlign: TextAlign.start,
                maxLines: 10,
                style: gColors.bodySaisie_B_B,
              ))),
    );
    ListContact.add(AffBtnInter());

    print("ListContact ${ListContact.length}");
    Reload();
  }

  void initState() {
    initLib();
    super.initState();
  }

  @override
  AppBar appBar() {
    return AppBar(
      title: InkWell(
        onTap: () async {
          await HapticFeedback.vibrate();
          await Client_Dialog.Dialogs_Client(context);
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
          AutoSizeText(
            "INTERVENTION DÉTAILLÉE",
            maxLines: 1,
            style: gColors.bodyTitle1_B_G24,
          ),
        ]),
      ),
      leading: InkWell(
        onTap: () async {
          await HapticFeedback.vibrate();
          Navigator.of(context).pop();
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 10, 0, 10),
          child: Image.asset("assets/images/IcoW.png"),
        ),
      ),
      actions: <Widget>[
        IconButton(
          iconSize: 40,
          icon: gColors.wBoxDecoration(context),
          onPressed: () async {
            gColors.AffUser(context);
          },
        ),
      ],
      backgroundColor: gColors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: [
          gObj.InterventionTitleWidget("${Srv_DbTools.gClient.Client_Nom.toUpperCase()}", wTitre2: "${Srv_DbTools.gGroupe.Groupe_Nom} / ${Srv_DbTools.gSite.Site_Nom} / ${Srv_DbTools.gZone.Zone_Nom}", wTimer: 0),
          gColors.wLigne(),
          Expanded(
            child: build_Detail(),
          ),
        ],
      ),
    );
  }

  Widget build_Detail() {
    print("Srv_DbTools.gContact.Contact_Nom ${Srv_DbTools.gContact.Contact_Nom}");
    return ListView(children: ListContact);
  }

  @override
  Widget Entete_Btn_Search() {
    return Container(
        height: 57,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            width: 8,
          ),
          InkWell(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                Image.asset(
                  "assets/images/Filtre.png",
                  height: icoWidth,
                  width: icoWidth,
                ),
              ]),
              onTap: () async {
                await HapticFeedback.vibrate();
                setState(() {});
              }),
          Container(
            width: 8,
          ),
          Spacer(),
          EdtFilterWidget(),
        ]));
  }

  Widget EdtFilterWidget() {
    return !affEdtFilter
        ? InkWell(
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: Image.asset(
                "assets/images/Btn_Loupe.png",
                height: icoWidth,
                width: icoWidth,
              ),
            ),
            onTap: () async {
              affEdtFilter = !affEdtFilter;
              setState(() {});
            })
        : Container(
            width: 320,
            child: Row(
              children: [
                InkWell(
                    child: Image.asset(
                      "assets/images/Btn_Loupe.png",
                      height: icoWidth,
                      width: icoWidth,
                    ),
                    onTap: () async {
                      affEdtFilter = !affEdtFilter;
                      setState(() {});
                    }),
                Expanded(
                    child: TextField(
                  onChanged: (text) {
                    filterText = text;
                    Filtre();
                  },
                  controller: ctrlFilter,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        ctrlFilter.clear();
                        filterText = "";
                        Filtre();
                      },
                      icon: Image.asset(
                        "assets/images/Btn_Clear.png",
                        height: icoWidth,
                        width: icoWidth,
                      ),
                    ),
                  ),
                ))
              ],
            ));
  }

  Widget AffLigne(
    String wTextL,
    String wTextR,
    Color BckGrd,
    String ImgL,
    Color ForeGrd,
  ) {
    double wHeight = 44;
    double mTop = 15;
    double icoWidth = 32;

    return Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        color: BckGrd,
        child: Column(
          children: [
            Row(
              children: <Widget>[
                ImgL.isEmpty
                    ? Container()
                    : Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Image.asset(
                          "assets/images/${ImgL}.png",
                          height: icoWidth,
                          width: icoWidth,
                        ),
                      ),
                Container(
                    padding: EdgeInsets.only(left: 10, top: mTop),
                    height: wHeight,
                    child: Text(
                      "${wTextL}",
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: gColors.bodySaisie_B_B,
                    )),
                Expanded(
                    child: Container(
                        padding: EdgeInsets.only(right: 10, top: mTop),
                        height: wHeight,
                        child: Text(
                          "${wTextR}",
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          style: gColors.bodySaisie_B_B.copyWith(color: ForeGrd),
                        ))),
              ],
            ),
            gColors.wLigne(),
          ],
        ));
  }

  Widget AffLigneCercle(
    String wTextL,
    String wTextR,
    Color BckGrd,
    String ImgL,
    Color ForeGrd,
  ) {
    double wHeight = 44;
    double mTop = 15;
    double icoWidth = 32;

    return Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        color: BckGrd,
        child: Column(
          children: [
            Row(
              children: <Widget>[
                ImgL.isEmpty
                    ? Container()
                    : Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Image.asset(
                          "assets/images/${ImgL}.png",
                          height: icoWidth,
                          width: icoWidth,
                        ),
                      ),
                Container(
                    padding: EdgeInsets.only(left: 10, top: mTop),
                    height: wHeight,
                    child: Text(
                      "${wTextL}",
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: gColors.bodySaisie_B_B,
                    )),
                Spacer(),
                Container(
                    padding: EdgeInsets.only(right: 10, top: 0),
                    height: wHeight,
                    child: CircleAvatar(
                        radius: 15,
                        backgroundColor: ForeGrd,
                        child: Text(
                          "${wTextR}",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: gColors.bodySaisie_B_B.copyWith(color: Colors.white),
                        ))),
              ],
            ),
            gColors.wLigne(),
          ],
        ));
  }

  Widget AffBtnMap(
    String wChamps,
    String wTitle,
    String wValue,
    String ImgL,
    Color BckGrd,
    Color ForeGrd,
  ) {
    return TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () async {
          await HapticFeedback.vibrate();
          MapsLauncher.launchQuery("${wValue}");
        },
        child: Column(
          children: [
            AffLigne(wTitle, "$wValue >", BckGrd, ImgL, ForeGrd),
          ],
        ));
  }

  Widget AffBtnInter() {
    return Container(
      margin: EdgeInsets.only(top : 50,bottom: 50),
      child: ElevatedButton(
          onPressed: () async {
            await HapticFeedback.vibrate();
            await Navigator.push(context, MaterialPageRoute(builder: (context) => Client_Groupe_Parc_Inter()));

          },
          style: ElevatedButton.styleFrom(
              backgroundColor: gColors.primaryRed,
              side: const BorderSide(
                width: 1.0,
                color: gColors.primaryRed,
              )),
          child: Container(
            margin: EdgeInsets.only(top : 30,bottom: 30),
            child: Text('Démarrage Intervention', style: gColors.bodyTitle1_B_W),
          )),
    );
  }

  Widget AffBtn(
    String wChamps,
    String wTitle,
    String wValue,
    String ImgL,
    Color BckGrd,
    Color ForeGrd,
  ) {
    return TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () async {
          print("onPressed");

          await Missions_Dialog.Missions_dialog(context);

          //            await Navigator.push(context, MaterialPageRoute(builder: (context) => Client_Vue_Edit()));
/*
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return Container(padding: EdgeInsets.fromLTRB(30, 0, 30, 30), child: Client_Groupe_Inter_Det_Popup(bFact: true, wChamps: wChamps));
              });
*/
          setState(() {});
        },
        child: Column(
          children: [
            AffLigne(wTitle, "$wValue >", BckGrd, ImgL, ForeGrd),
          ],
        ));
  }
}
