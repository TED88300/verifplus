import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Ent.dart';
import 'package:verifplus/Widget/Client/Client_Dialog.dart';
import 'package:verifplus/Widget/Client/Client_Interventions_Status.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter.dart';
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

  DateTime firstDate = DateTime(2100);
  DateTime lastDate = DateTime(1900);
  int wHours = 0;

  String Plannification = "";
  String wIntervenants = "";
  String wInterMission = "";
  String wAdresse = "";
  String wTel = "";

  List<Widget> ListWidget = [];

  int countTot = 0;
  int countX = 0;
  int wTimer = 0;

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
  Future initLib() async {
    if (Srv_DbTools.gIntervention.Intervention_Responsable!.isNotEmpty) {
      await Srv_DbTools.getUserMat(
          Srv_DbTools.gIntervention.Intervention_Responsable!);
      Srv_DbTools.selectedUserInter =
          "${Srv_DbTools.gUser.User_Nom} ${Srv_DbTools.gUser.User_Prenom}";
    }
    if (Srv_DbTools.gIntervention.Intervention_Responsable2!.isNotEmpty) {
      await Srv_DbTools.getUserMat(
          Srv_DbTools.gIntervention.Intervention_Responsable2!);
      Srv_DbTools.selectedUserInter2 =
          "${Srv_DbTools.gUser.User_Nom} ${Srv_DbTools.gUser.User_Prenom}";
    }
    if (Srv_DbTools.gIntervention.Intervention_Responsable3!.isNotEmpty) {
      await Srv_DbTools.getUserMat(
          Srv_DbTools.gIntervention.Intervention_Responsable3!);
      Srv_DbTools.selectedUserInter3 =
          "${Srv_DbTools.gUser.User_Nom} ${Srv_DbTools.gUser.User_Prenom}";
    }
    if (Srv_DbTools.gIntervention.Intervention_Responsable4!.isNotEmpty) {
      await Srv_DbTools.getUserMat(
          Srv_DbTools.gIntervention.Intervention_Responsable4!);
      Srv_DbTools.selectedUserInter4 =
          "${Srv_DbTools.gUser.User_Nom} ${Srv_DbTools.gUser.User_Prenom}";
    }

    if (Srv_DbTools.gIntervention.Intervention_Responsable5!.isNotEmpty) {
      await Srv_DbTools.getUserMat(
          Srv_DbTools.gIntervention.Intervention_Responsable5!);
      Srv_DbTools.selectedUserInter5 =
          "${Srv_DbTools.gUser.User_Nom} ${Srv_DbTools.gUser.User_Prenom}";
    }
    if (Srv_DbTools.gIntervention.Intervention_Responsable6!.isNotEmpty) {
      await Srv_DbTools.getUserMat(
          Srv_DbTools.gIntervention.Intervention_Responsable6!);
      Srv_DbTools.selectedUserInter6 =
          "${Srv_DbTools.gUser.User_Nom} ${Srv_DbTools.gUser.User_Prenom}";
    }

    Srv_DbTools.ListPlanning = await DbTools.getPlanning_InterventionId(
        Srv_DbTools.gIntervention.InterventionId!);

    await Srv_DbTools.getPlanning_InterventionIdRes(
        Srv_DbTools.gIntervention.InterventionId!);

    print("ListInterMission > ${Srv_DbTools.ListInterMission.length}");
    Srv_DbTools.ListInterMission = await DbTools.getInterMissionsIntervention(
        Srv_DbTools.gIntervention.InterventionId!);
    print("ListInterMission < ${Srv_DbTools.ListInterMission.length}");

    bool wMin = false, wMax = false;

    for (int i = 0; i < Srv_DbTools.ListPlanning.length; i++) {
      var element = Srv_DbTools.ListPlanning[i];
      print("element ${element.Desc()}");

      if (element.Planning_InterventionstartTime.isBefore(minStartTime)) {
        minStartTime = element.Planning_InterventionstartTime;
        wMin = true;
      }
      if (element.Planning_InterventionendTime.isAfter(maxEndTime)) {
        maxEndTime = element.Planning_InterventionendTime;
        wMax = true;
      }
    }

    firstDate = DateTime(2100);
    lastDate = DateTime(1900);
    wHours = 0;

    wIntervenants = "";
    for (int i = 0; i < Srv_DbTools.ListUserH.length; i++) {
      var element = Srv_DbTools.ListUserH[i];
      wIntervenants =
          "$wIntervenants${wIntervenants.isNotEmpty ? ", " : ""}${element.User_Nom} ${element.User_Prenom} (${element.H}h)";
    }

    for (int i = 0; i < Srv_DbTools.ListPlanning.length; i++) {
      var wplanningSrv = Srv_DbTools.ListPlanning[i];
      wHours += wplanningSrv.Planning_InterventionendTime.difference(
              wplanningSrv.Planning_InterventionstartTime)
          .inHours;
      if (firstDate.isAfter(wplanningSrv.Planning_InterventionstartTime))
        firstDate = wplanningSrv.Planning_InterventionstartTime;
      if (lastDate.isBefore(wplanningSrv.Planning_InterventionendTime))
        lastDate = wplanningSrv.Planning_InterventionendTime;
    }

    if (minStartTime.year == maxEndTime.year &&
        minStartTime.month == maxEndTime.month &&
        minStartTime.day == maxEndTime.day) {
      String formattedDate = DateFormat('dd/MM/yy').format(minStartTime);
      String formattedDeb = DateFormat('hh:mm').format(minStartTime);
      String formattedFin = DateFormat('hh:mm').format(maxEndTime);
      Plannification = "Plannifiée $formattedDate $formattedDeb/$formattedFin";
    } else {
      String formattedDateDeb =
          DateFormat('dd/MM/yy hh:mm').format(minStartTime);
      String formattedDateFin = DateFormat('dd/MM/yy hh:mm').format(maxEndTime);
      Plannification = "Plannifiée $formattedDateDeb - $formattedDateFin";
    }

    Plannification =
        "Plannifiée du ${DateFormat('dd/MM/yyyy').format(firstDate)} au ${DateFormat('dd/MM/yyyy').format(lastDate)} pour ${wHours} heures";

    wInterMission = "";
    for (int i = 0; i < Srv_DbTools.ListInterMission.length; i++) {
      var element = Srv_DbTools.ListInterMission[i];
      if (wInterMission.isNotEmpty) wInterMission += ",";
      wInterMission = "$wInterMission ${element.InterMission_Nom}";
    }

    countTot = 0;
    wTimer = 0;
    countX = 0;
    DbTools.glfParcs_Ent =
        await DbTools.getParcs_Ent(Srv_DbTools.gIntervention.InterventionId!);

    for (int jj = 0; jj < DbTools.glfParcs_Ent.length; jj++) {
      Parc_Ent elementEnt = DbTools.glfParcs_Ent[jj];
      countTot++;
      if (!elementEnt.Parcs_Date_Rev!.isEmpty) countX++;

      try {
        wTimer += elementEnt.Parcs_Intervention_Timer!;
      } catch (e) {
        print(e);
      }
    }
    wAdresse = "";
    if (Srv_DbTools.gZone.Zone_Adr1.isNotEmpty)
      wAdresse = wAdresse + " " + Srv_DbTools.gZone.Zone_Adr1;
    if (Srv_DbTools.gZone.Zone_Adr2.isNotEmpty)
      wAdresse = wAdresse + " " + Srv_DbTools.gZone.Zone_Adr2;
    if (Srv_DbTools.gZone.Zone_Adr3.isNotEmpty)
      wAdresse = wAdresse + " " + Srv_DbTools.gZone.Zone_Adr3;
    if (Srv_DbTools.gZone.Zone_Adr4.isNotEmpty)
      wAdresse = wAdresse + " " + Srv_DbTools.gZone.Zone_Adr4;
    if (Srv_DbTools.gZone.Zone_CP.isNotEmpty)
      wAdresse = wAdresse + " " + Srv_DbTools.gZone.Zone_CP;
    if (Srv_DbTools.gZone.Zone_Ville.isNotEmpty)
      wAdresse = wAdresse + " " + Srv_DbTools.gZone.Zone_Ville;

    final wDur = Duration(seconds: wTimer);

    ListWidget = [
      AffBtnStatus(
          "",
          "Type d'intervention",
          "${Srv_DbTools.gIntervention.Intervention_Parcs_Type} - ${Srv_DbTools.gIntervention.Intervention_Type} - ${Srv_DbTools.gIntervention.Intervention_Status}",
          "",
          gColors.white,
          gColors.primaryBlue),
      AffLigne("Plannification", "${Plannification}", gColors.white, "",
          gColors.primaryOrange),
      AffLigne(
          "Date Programmation",
          "${Srv_DbTools.gIntervention.Intervention_Date}",
          gColors.white,
          "",
          gColors.black),
      AffLigne(
          "Détail",
          ">>>>> Vérifications : ${countX} / ${countTot} <<<<<                    >>>>> Temps Passé : ${gObj.printDurationHHMM(wDur)} <<<<<",
          gColors.white,
          "",
          gColors.primaryOrange),
      AffBtnDate(
          "",
          "Dernière Visite",
          "${Srv_DbTools.gIntervention.Intervention_Date_Visite}",
          "",
          gColors.white,
          gColors.primaryBlue),
      AffLigne("Commercial", "", gColors.greyLight, "IM2", gColors.primaryBlue),
      AffLigne("Commercial", "${Srv_DbTools.selectedUserInter}", gColors.white,
          "IM2", gColors.black),
      AffLigne("Manager commercial", "${Srv_DbTools.selectedUserInter2}",
          gColors.white, "IM2b", gColors.black),
      AffLigne(
          "Techniques : ", "", gColors.greyLight, "IM3", gColors.primaryBlue),
      AffLigne("Manager Technique", "${Srv_DbTools.selectedUserInter3}",
          gColors.white, "IM3", gColors.black),
      AffLigne("Pilot Projet", "${Srv_DbTools.selectedUserInter4}",
          gColors.white, "IM3b", gColors.black),
      AffLigne("Cond Travaux", "${Srv_DbTools.selectedUserInter5}",
          gColors.white, "IM3c", gColors.black),
      AffLigne("Chef d'équipe", "${Srv_DbTools.selectedUserInter6}",
          gColors.white, "IM3d", gColors.black),
      AffLigne("Tech Affectés", "${wIntervenants}", gColors.white, "IM3e",
          Colors.black),
      AffLigneCercle(
          "Tâches & Ordes de missions",
          "${Srv_DbTools.ListInterMission.length}",
          gColors.greyLight,
          "IM4",
          gColors.primaryBlue),
      AffBtn(
          "", "", "${wInterMission}", "", gColors.white, gColors.primaryBlue),
      AffLigne(
          "Adresse", "", gColors.greyLight, "Icon_Adr2", gColors.primaryBlue),
      AffBtnMap("", "", "${wAdresse}", "", gColors.white, gColors.black),
      AffLigne(
          "Contact", "", gColors.greyLight, "Icon_Cont2", gColors.primaryBlue),
    ];

    await DbTools.getContactClientAdrType(
        Srv_DbTools.gClient.ClientId, Srv_DbTools.gZone.ZoneId, "ZONE");

    for (int i = 0; i < Srv_DbTools.ListContact.length; i++) {
      var element = Srv_DbTools.ListContact[i];
      print("Srv_DbTools.ListContact ZONE ${element.Desc()}");

      String wNom = "${element.Contact_Prenom} ${element.Contact_Nom}";
      if (element.Contact_Fonction.isNotEmpty)
        wNom = wNom + " - ${element.Contact_Fonction}";
      if (element.Contact_Service.isNotEmpty)
        wNom = wNom + "/${element.Contact_Service}";
      if (element.Contact_Tel1.isNotEmpty)
        wNom = wNom + " - ${element.Contact_Tel1}";
      if (element.Contact_Tel2.isNotEmpty)
        wNom = wNom + " - ${element.Contact_Tel2}";
      if (element.Contact_eMail.isNotEmpty)
        wNom = wNom + " - ${element.Contact_eMail}";
      print("ListContact ${wNom}");
      ListWidget.add(AffLigne(
          "    Contact Zone", "$wNom", gColors.white, "", gColors.primaryBlue));
    }

    await DbTools.getContactClientAdrType(
        Srv_DbTools.gClient.ClientId, Srv_DbTools.gSite.SiteId, "SITE");

    for (int i = 0; i < Srv_DbTools.ListContact.length; i++) {
      var element = Srv_DbTools.ListContact[i];
      print("Srv_DbTools.ListContact SITE ${element.Desc()}");
      String wNom = "${element.Contact_Prenom} ${element.Contact_Nom}";
      if (element.Contact_Tel1.isNotEmpty)
        wNom = wNom + " - ${element.Contact_Tel1}";
      if (element.Contact_Tel2.isNotEmpty)
        wNom = wNom + " - ${element.Contact_Tel2}";
      if (element.Contact_eMail.isNotEmpty)
        wNom = wNom + " - ${element.Contact_eMail}";
      print("ListContact ${wNom}");
      ListWidget.add(AffLigne(
          "    Contact Site", "$wNom", gColors.white, "", gColors.primaryBlue));
    }

    ListWidget.add(AffLigne(
        "Note", "", gColors.greyLight, "Icon_Note2", gColors.primaryBlue));

    ListWidget.add(
          Container(
            height : 200,
//            color : Colors.red,
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                "${Srv_DbTools.gIntervention.Intervention_Remarque}",
                textAlign: TextAlign.start,
                maxLines: 4,
                style: gColors.bodySaisie_B_B,
              )),
    );
//    ListContact.add(AffBtnInter());

    print("ListContact ${ListWidget.length}");
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
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
          child: DbTools.gBoolErrorSync
              ? Image.asset(
                  "assets/images/IcoWErr.png",
                )
              : Image.asset("assets/images/IcoW.png"),
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
    print("ListWidget ${ListWidget.length}");

    String wTitre2 =
        "${Srv_DbTools.gIntervention.Groupe_Nom} / ${Srv_DbTools.gIntervention.Site_Nom} / ${Srv_DbTools.gIntervention.Zone_Nom}";
    if (Srv_DbTools.gIntervention.Groupe_Nom ==
        Srv_DbTools.gIntervention.Site_Nom)
      wTitre2 = "${Srv_DbTools.gIntervention.Site_Nom}";
    return Scaffold(
        appBar: appBar(),
        body: Stack(
          children: [
            Container(

                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(children: [
                  gObj.InterventionTitleWidget(
                      "${Srv_DbTools.gIntervention.Client_Nom!.toUpperCase()}",
                      wTitre2: wTitre2,
                      wTimer: 0),
                  gColors.wLigne(),
                  Expanded(
                    child:
                        ListWidget.length == 0 ? Container() :
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: ListWidget.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListWidget[index];
                          },
                        ),

                  ),
                ])),
            Positioned(
                bottom: 20,
                right: 20,
                child: InkWell(
                  onTap: () async {
                    await HapticFeedback.vibrate();
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Client_Groupe_Parc_Inter()));
                    await initLib();
                  },
                  child: Container(
                      height: 50,
                      width: 260,
                      decoration: BoxDecoration(
                        color: gColors.primaryGreen,
                        border: Border.all(
                          color: gColors.primaryGreen,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Démarrage Intervention',
                                  style: gColors.bodyTitle1_B_Wr),
                            ],
                          )
                        ],
                      )),
                ))
          ],
        ));
  }

  @override
  Widget Entete_Btn_Search() {
    return Container(
        height: 57,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 8,
              ),
              InkWell(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
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
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          style:
                              gColors.bodySaisie_B_B.copyWith(color: ForeGrd),
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
                          style: gColors.bodySaisie_B_B
                              .copyWith(color: Colors.white),
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
      width: 640,
      margin: EdgeInsets.only(top: 5, bottom: 0),
      child: ElevatedButton(
          onPressed: () async {
            await HapticFeedback.vibrate();
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Client_Groupe_Parc_Inter()));
            await initLib();
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: gColors.primaryRed,
              side: const BorderSide(
                width: 1.0,
                color: gColors.primaryRed,
              )),
          child: Container(
            margin: EdgeInsets.only(top: 30, bottom: 30),
            child:
                Text('Démarrage Intervention', style: gColors.bodyTitle1_B_W),
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
          await initLib();
          setState(() {});
        },
        child: Column(
          children: [
            AffLigne(wTitle, "$wValue >", BckGrd, ImgL, ForeGrd),
          ],
        ));
  }

  Widget AffBtnStatus(
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
          await HapticFeedback.vibrate();
          await Client_Intervention_Status_Dialog.Dialogs_Intervention_Status(
              context);
          await initLib();
          setState(() {});
        },
        child: Column(
          children: [
            AffLigne(wTitle, "$wValue >", BckGrd, ImgL, ForeGrd),
          ],
        ));
  }

  Widget AffBtnDate(
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
          print("onPressed ${wValue}");

          var inputFormat = DateFormat('dd/MM/yyyy');
          var wDate = DateTime.now();

          try {
            wDate = inputFormat.parse(wValue);
          } catch (e) {}
          final DateTime? date = await showDatePicker(
              context: context,
              initialDate: wDate,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
              builder: (BuildContext context, Widget? child) {
                return Theme(
                  data: ThemeData(
                      brightness: Brightness.light,
                      primaryColor: gColors.primary),
                  child: child!,
                );
              });

          print("NEW DATE ${date}");
          String newDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

          try {
            newDate = DateFormat('dd/MM/yyyy').format(date!);
          } catch (e) {}

          print("NEW DATE ${date} / ${newDate}");
          Srv_DbTools.gIntervention.Intervention_Date_Visite = newDate;
          await DbTools.updateInterventions(Srv_DbTools.gIntervention);
          bool wRes =
              await Srv_DbTools.setIntervention(Srv_DbTools.gIntervention);
          print("•••• setIntervention ${wRes}");
          Srv_DbTools.gIntervention.Intervention_isUpdate = wRes;
          await DbTools.updateInterventions(Srv_DbTools.gIntervention);
          initLib();
        },
        child: Column(
          children: [
            AffLigne(wTitle, "$wValue >", BckGrd, ImgL, ForeGrd),
          ],
        ));
  }
}
