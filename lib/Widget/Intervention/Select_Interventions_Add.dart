import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Clients.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Groupes.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Interventions.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Sites.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Ent.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';

import '../../Tools/DbSrv/Srv_Zones.dart';

// Freq
// Année ....

class Select_Interventions_Add {
  Select_Interventions_Add();
  static Future<void> Dialogs_Add(BuildContext context, bool isNew) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => Select_InterventionsAdd(isNew: isNew),
    );
  }
}

//**********************************
//**********************************
//**********************************

class Select_InterventionsAdd extends StatefulWidget {
  bool isNew = false;
  Select_InterventionsAdd({
    Key? key,
    required this.isNew,
  }) : super(key: key);

  @override
  _Select_InterventionsAddState createState() => _Select_InterventionsAddState();
}

class _Select_InterventionsAddState extends State<Select_InterventionsAdd> {
  final Search_Client_TextController = TextEditingController();
  final Search_Site_TextController = TextEditingController();

  int iListe = 0;

  String selDepot = "";
  List<String> ListDepot = [];

  Client selClient = Client.ClientInit();
  List<Client> ListClient = [];

  Groupe selGroupe = Groupe.GroupeInit();
  List<Groupe> ListGroupe = [];

  Site selSite = Site.SiteInit();
  List<Site> ListSite = [];

  Zone selZone = Zone.ZoneInit();
  List<Zone> ListZone = [];

  Intervention selIntervention = Intervention.InterventionInit();
  List<Intervention> ListIntervention = [];

  ScrollController scrollController = ScrollController(initialScrollOffset: 0);

  static List<String> ListParam_Type = [];
  String wType = "";

  static List<String> ListParam_Org = [];
  static List<String> ListParam_OrgID = [];
  String wOrg = "";
  String wOrgID = "";

  Future FlitreClient() async {
    ListClient.clear();
    ListGroupe.clear();
    ListSite.clear();
    ListZone.clear();
    ListIntervention.clear();

    print(">>>>>> ${Srv_DbTools.ListClient.length}");
    await Srv_DbTools.getClientRech(Search_Client_TextController.text, selDepot);
    print(">>>>>> ${Srv_DbTools.ListClient.length}");
    ListClient.addAll(Srv_DbTools.ListClient);
    if (ListClient.length == 1) {
      selClient = ListClient[0];
    }

    setState(() {});
  }

  Future FlitreSite() async {
    ListClient.clear();
    ListGroupe.clear();
    ListSite.clear();
    ListZone.clear();
    ListIntervention.clear();

    print(">>>>>> FlitreSite");

    await Srv_DbTools.getSiteRech(selClient.ClientId, Search_Site_TextController.text);
    print(">>>>>> ${Srv_DbTools.ListSite.length}");
    ListSite.addAll(Srv_DbTools.ListSite);
    print(">>>>>> ${ListSite.length}");

    if (ListSite.length == 1) {
      selSite = ListSite[0];
    }


    setState(() {});
  }

  Future FlitreZone() async {
    ListClient.clear();
    ListGroupe.clear();
    ListSite.clear();
    ListZone.clear();
    ListIntervention.clear();

    print(">>>>>> FlitreZone");

    await Srv_DbTools.getZonesSite(selSite.SiteId);
    print(">>>>>> ${Srv_DbTools.ListZone.length}");
    ListZone.addAll(Srv_DbTools.ListZone);
    print(">>>>>> ${ListZone.length}");

    if (ListZone.length == 1) {
      selZone = ListZone[0];
      iListe = 4;
    }

    setState(() {});
  }

  Future Reload() async {
    ListClient.clear();
    ListGroupe.clear();
    ListSite.clear();
    ListZone.clear();
    ListIntervention.clear();

    if (selDepot.isNotEmpty) {
      await Srv_DbTools.getClientDepotp(selDepot);
      print(">>>>>> ${Srv_DbTools.ListClient.length}");
      ListClient.addAll(Srv_DbTools.ListClient);

//      if (ListClient.length == 1) selClient = ListClient[0];

      if (selClient.ClientId > 0) {
        await Srv_DbTools.getGroupesClient(selClient.ClientId);
        print(">>>>>> ${Srv_DbTools.ListGroupe.length}");
        ListGroupe.addAll(Srv_DbTools.ListGroupe);

        if (ListGroupe.length == 1) selGroupe = ListGroupe[0];

        if (selGroupe.GroupeId > 0) {
          await Srv_DbTools.getSitesGroupe(selGroupe.GroupeId);
          print(">>>>>> ${Srv_DbTools.ListSite.length}");
          ListSite.addAll(Srv_DbTools.ListSite);

          if (ListSite.length == 1) selSite = ListSite[0];

          if (selSite.SiteId > 0) {
            await Srv_DbTools.getZonesSite(selSite.SiteId);
            print(">>>>>> ${Srv_DbTools.ListZone.length}");
            ListZone.addAll(Srv_DbTools.ListZone);

            if (ListZone.length == 1) selZone = ListZone[0];

            if (selZone.ZoneId > 0) {
              await Srv_DbTools.getInterventionsZone(selSite.SiteId);
              print(">>>>>> ${Srv_DbTools.ListIntervention.length}");
              ListIntervention.addAll(Srv_DbTools.ListIntervention);
            }
          }
        }
      }
    }
    setState(() {});
  }

  @override
  void initLib() async {
    await DbTools.getParam_Param();

    ListParam_Type.clear();
    Srv_DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("Type_Interv") == 0) {
        ListParam_Type.add(element.Param_Param_Text);
      }
    });
    wType = ListParam_Type[0];
    print("ListParam_Type  ${wType}");

    ListParam_Org.clear();
    Srv_DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("Type_Organe") == 0) {
        if (element.Param_Param_ID.compareTo("Base") != 0) {
          ListParam_Org.add(element.Param_Param_Text);
          ListParam_OrgID.add(element.Param_Param_ID);
        }
      }
    });
    wOrg = ListParam_Org[0];
    wOrgID = ListParam_OrgID[0];

    print("Type_Organe isNew ${widget.isNew} ${wOrg}");

    await DbTools.getAdresseType("AGENCE");
    int i = 0;
    ListDepot.clear();
    Srv_DbTools.ListAdressesearchresult.forEach((wAdresse) {
      ListDepot.add(wAdresse.Adresse_Nom);
      if (wAdresse.Adresse_Nom.compareTo("${Srv_DbTools.gUserLogin.User_Depot}") == 0) {
        selDepot = wAdresse.Adresse_Nom;
      }
    });
    await Reload();
  }

  @override
  void initState() {
    initLib();
  }

/*

  Widget setupAlertDialoadContainer() {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('Gujarat, India'),
          );
        },
      ),
    );
  }

*/

  double SelHeight = 760;
  double icoWidth = 40;

  @override
  Widget ListeAgences(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 40,
                child: Text(
                  "Selection Agence",
                  style: gColors.bodyTitle1_B_G,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          ListParam_Type.length == 0
              ? Container()
              : Container(


            width: 400.0, // Change as per your requirement
                  height: SelHeight, // Change as per your requirement
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: ListDepot.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = ListDepot[index];

                      return InkWell(
                          onTap: () async {
                            await HapticFeedback.vibrate();
                            selDepot = item;
                            setState(() {});
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                color: (item.compareTo(selDepot) == 0) ? gColors.primaryGreen : Colors.transparent,
                                border: Border.all(
                                  color: (item.compareTo(selDepot) == 0) ? gColors.primaryGreen : Colors.transparent,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                              padding: EdgeInsets.fromLTRB(10, 12, 10, 5), // TED
                              height: 45,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item,
                                      textAlign: TextAlign.left,
                                      style: gColors.bodyTitle1_B_Gr.copyWith(
                                        color: (item.compareTo(selDepot) == 0) ? gColors.white : gColors.primary,
                                      ))
                                ],
                              )));
                    },
                  ),
                ),
        ],
      ),
    );
  }

  @override
  Widget ListeClients(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 600,
                height: 30,
                child: Text(
                  "Selection Client",
                  style: gColors.bodyTitle1_B_G,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: 550.0,
                  height: 30,
                  child: TextField(
                    style: gColors.bodyTitle1_B_Gr,
                    onChanged: (text) {
                      selDepot = "";
                      FlitreClient();
                    },
                    controller: Search_Client_TextController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          Search_Client_TextController.clear();
                          selDepot = "";
                          FlitreClient();
                        },
                        icon: Image.asset(
                          "assets/images/Btn_Clear.png",
                          height: icoWidth,
                          width: icoWidth,
                        ),
                      ),
                    ),
                  )),
            ],
          ),
          ListParam_Type.length == 0
              ? Container()
              : Container(

                  width: 550.0,
                  height: SelHeight - ((selClient.Client_Nom.length == 0 ) ? 17 : 47),
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: ListClient.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = ListClient[index];

                      return InkWell(
                          onTap: () async {
                            await HapticFeedback.vibrate();
                            selClient = item;
                            setState(() {});
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                color: (item.Client_Nom.compareTo(selClient.Client_Nom) == 0) ? gColors.primaryGreen : Colors.transparent,
                                border: Border.all(
                                  color: (item.Client_Nom.compareTo(selClient.Client_Nom) == 0) ? gColors.primaryGreen : Colors.transparent,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                              padding: EdgeInsets.fromLTRB(10, 12, 10, 5), // TED
                              height: 45,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${item.Client_Nom} / ${item.Adresse_CP} ${item.Adresse_Ville}",
                                      textAlign: TextAlign.left,
                                      style: gColors.bodyTitle1_B_Gr.copyWith(
                                        color: (item.Client_Nom.compareTo(selClient.Client_Nom) == 0) ? gColors.white : gColors.primary,
                                      ))
                                ],
                              )));
                    },
                  ),
                ),
        ],
      ),
    );
  }

  @override
  Widget ListeSites(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 30,
                child: Text(
                  "Selection Site",
                  style: gColors.bodyTitle1_B_G,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: 550.0,
                  height: 30,
                  child: TextField(
                    style: gColors.bodyTitle1_B_Gr,
                    onChanged: (text) {
                      selDepot = "";
                      FlitreSite();
                    },
                    controller: Search_Site_TextController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          Search_Site_TextController.clear();
                          selDepot = "";
                          FlitreSite();
                        },
                        icon: Image.asset(
                          "assets/images/Btn_Clear.png",
                          height: icoWidth,
                          width: icoWidth,
                        ),
                      ),
                    ),
                  )),
            ],
          ),
          ListParam_Type.length == 0
              ? Container()
              : Container(
            width: 550.0,
                  height: SelHeight - ((selSite.Site_Nom.length == 0 ) ? 47 : 77),
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: ListSite.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = ListSite[index];

                      return InkWell(
                          onTap: () async {
                            await HapticFeedback.vibrate();
                            selSite = item;
                            setState(() {});
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                color: (item.Site_Nom.compareTo(selSite.Site_Nom) == 0) ? gColors.primaryGreen : Colors.transparent,
                                border: Border.all(
                                  color: (item.Site_Nom.compareTo(selSite.Site_Nom) == 0) ? gColors.primaryGreen : Colors.transparent,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                              padding: EdgeInsets.fromLTRB(10, 12, 10, 5), // TED
                              height: 45,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${item.Site_Nom} / ${item.Site_CP} ${item.Site_Ville}",
                                      textAlign: TextAlign.left,
                                      style: gColors.bodyTitle1_B_Gr.copyWith(
                                        color: (item.Site_Nom.compareTo(selSite.Site_Nom) == 0) ? gColors.white : gColors.primary,
                                      ))
                                ],
                              )));
                    },
                  ),
                ),
        ],
      ),
    );
  }

  @override
  Widget ListeZones(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 50,
                child: Text(
                  "Selection Zone",
                  style: gColors.bodyTitle1_B_G,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          ListParam_Type.length == 0
              ? Container()
              : Container(
            width: 550.0,
            height: SelHeight - ((selZone.Zone_Nom.length == 0 ) ? 77 : 107),
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: ListZone.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = ListZone[index];

                      return InkWell(
                          onTap: () async {
                            await HapticFeedback.vibrate();
                            selZone = item;
                            setState(() {});
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                color: (item.Zone_Nom.compareTo(selZone.Zone_Nom) == 0) ? gColors.primaryGreen : Colors.transparent,
                                border: Border.all(
                                  color: (item.Zone_Nom.compareTo(selZone.Zone_Nom) == 0) ? gColors.primaryGreen : Colors.transparent,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                              padding: EdgeInsets.fromLTRB(10, 12, 10, 5), // TED
                              height: 45,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${item.Zone_Nom} / ${item.Zone_CP} ${item.Zone_Ville}",
                                      textAlign: TextAlign.left,
                                      style: gColors.bodyTitle1_B_Gr.copyWith(
                                        color: (item.Zone_Nom.compareTo(selZone.Zone_Nom) == 0) ? gColors.white : gColors.primary,
                                      ))
                                ],
                              )));
                    },
                  ),
                ),
        ],
      ),
    );
  }

  double SelHeight2 = 270;

  @override
  Widget ListeType(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 250,
                height: 30,
                child: Text(
                  "Intervention",
                  style: gColors.bodyTitle1_B_G,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          ListParam_Type.length == 0
              ? Container()
              : Container(
            width: 250.0, // Change as per your requirement
            height: SelHeight - 72,

                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: ListParam_Type.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = ListParam_Type[index];

                      return InkWell(
                          onTap: () async {
                            await HapticFeedback.vibrate();
                            wType = item;
                            setState(() {});
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                color: (item.compareTo(wType) == 0) ? gColors.primaryGreen : Colors.transparent,
                                border: Border.all(
                                  color: (item.compareTo(wType) == 0) ? gColors.primaryGreen : Colors.transparent,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                              padding: EdgeInsets.fromLTRB(10, 12, 10, 5), // TED
                              height: 45,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item,
                                      textAlign: TextAlign.left,
                                      style: gColors.bodyTitle1_B_Gr.copyWith(
                                        color: (item.compareTo(wType) == 0) ? gColors.white : gColors.primary,
                                      ))
                                ],
                              )));
                    },
                  ),
                ),
        ],
      ),
    );
  }

  @override
  Widget ListeOrg(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 250,
                height: 30,
                child: Text(
                  "Types d'organe",
                  style: gColors.bodyTitle1_B_G,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          ListParam_Org.length == 0
              ? Container()
              : Container(
                  width: 250.0,
                  height: SelHeight - 72,
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: ListParam_Org.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = ListParam_Org[index];

                      return InkWell(
                          onTap: () async {
                            await HapticFeedback.vibrate();
                            wOrg = item;
                            wOrgID = ListParam_OrgID[index];

                            setState(() {});
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                color: (item.compareTo(wOrg) == 0) ? gColors.primaryGreen : Colors.transparent,
                                border: Border.all(
                                  color: (item.compareTo(wOrg) == 0) ? gColors.primaryGreen : Colors.transparent,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                              padding: EdgeInsets.fromLTRB(10, 12, 10, 5), // TED
                              height: 45,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item,
                                      textAlign: TextAlign.left,
                                      maxLines: 1,
                                      style: gColors.bodyTitle1_B_Gr.copyWith(
                                        color: (item.compareTo(wOrg) == 0) ? gColors.white : gColors.primary,
                                      ))
                                ],
                              )));
                    },
                  ),
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget Ctrl = Container();

    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.white,
      backgroundColor: gColors.white,
      title: Container(
        color: gColors.white,
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
        child: Column(
          children: [
            Container(
              height: 5,
            ),
            Container(
              width: 600,
              child: Text(
                "Intervention : Création $iListe",
                style: gColors.bodyTitle1_B_G32,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      contentPadding: EdgeInsets.zero,
      content: Container(
        color: gColors.greyLight,
        height: 900,
        child: Column(
          children: [
            Container(
              color: gColors.black,
              height: 1,
            ),


            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    (selDepot.length == 0) ? Container() :
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      width: 600,
                      height: 30,
                      child: Text(
                        "${selDepot}",
                        style: gColors.bodyTitle1_N_G,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    (selClient.Client_Nom.length == 0) ? Container() :
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      width: 600,
                      height: 30,
                      child: Text(
                        "${selClient.Client_Nom}",
                        style: gColors.bodyTitle1_N_G,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    (selSite.Site_Nom.length == 0) ? Container() :
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                      width: 600,
                      height: 30,
                      child: Text(
                        "${selSite.Site_Nom}",
                        style: gColors.bodyTitle1_B_G,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    (selZone.Zone_Nom.length == 0 || selSite.Site_Nom == selZone.Zone_Nom) ? Container() :
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                      width: 600,
                      height: 30,
                      child: Text(
                        "${selZone.Zone_Nom}",
                        style: gColors.bodyTitle1_B_G,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Container(
              height: 5,
            ),

            Container(
              color: gColors.black,
              height: 1,
            ),
            Row(
              children: [
                Spacer(),
                (iListe == 0) ? ListeAgences(context) : Container(),
                (iListe == 1) ? ListeClients(context) : Container(),
                (iListe == 2) ? ListeSites(context) : Container(),
                (iListe == 3) ? ListeZones(context) : Container(),
                (iListe == 4) ? ListeType(context) : Container(),
                (iListe == 4) ? Spacer() : Container(),
                (iListe == 4 && widget.isNew) ? ListeOrg(context) : Container(),
                Spacer(),
              ],
            ),
            Spacer(),
            iListe == 4 ? Valider(context) : Suite(context),
            Container(
              color: gColors.black,
              height: 1,
            ),
          ],
        ),
      ),
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

  Widget Suite(BuildContext context) {
    print("(iListe ${selClient} && selClient.ClientId ${selClient.ClientId}) ");

    return Container(
      width: 440,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
//          Text(widget.param_Saisie.Param_Saisie_Controle),
          Container(
            color: gColors.primary,
            width: 8,
          ),
          new ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: gColors.primaryRed,
            ),
            child: Text('Annuler', style: gColors.bodyTitle1_B_W),
          ),
          Container(
            color: gColors.primary,
            width: 8,
          ),
          new ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();
              if (iListe > 0)
                iListe--;
              else
                {
                  Navigator.of(context).pop();

                }
              if (iListe == 0) {
                selClient = Client.ClientInit();
              }
              if (iListe == 1) {                selZone = Zone.ZoneInit();

                selSite = Site.SiteInit();
                Search_Client_TextController.clear();
                FlitreClient();
              }
              if (iListe == 2) {
                selZone = Zone.ZoneInit();
                Search_Site_TextController.clear();
                FlitreSite();
              }
              if (iListe == 3) {
                FlitreZone();
              }

              setState(() {});
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: gColors.primaryGreen,
                side: const BorderSide(
                  width: 1.0,
                  color: gColors.primaryGreen,
                )),
            child: Text('Précédent', style: gColors.bodyTitle1_B_W),
          ),
          Container(
            color: gColors.primary,
            width: 8,
          ),
          ((iListe == 1 && selClient.ClientId == 0) || (iListe == 2 && selSite.SiteId == 0) || (iListe == 3 && selZone.ZoneId == 0))
              ? new ElevatedButton(
                  onPressed: () async {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: gColors.LinearGradient1,
                      side: const BorderSide(
                        width: 1.0,
                        color: gColors.LinearGradient1,
                      )),
                  child: Text('Suivant', style: gColors.bodyTitle1_B_W),
                )
              : new ElevatedButton(
                  onPressed: () async {
                    await HapticFeedback.vibrate();
                    iListe++;
                    if (iListe == 1) {
                      selClient = Client.ClientInit();
                      Search_Client_TextController.clear();
                      FlitreClient();
                    }
                    if (iListe == 2) {
                      selSite = Site.SiteInit();
                      Search_Site_TextController.clear();
                      FlitreSite();
                    }
                    if (iListe == 3) {
                      selZone = Zone.ZoneInit();
                      FlitreZone();
                    }
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: gColors.primaryGreen,
                      side: const BorderSide(
                        width: 1.0,
                        color: gColors.primaryGreen,
                      )),
                  child: Text('Suivant', style: gColors.bodyTitle1_B_W),
                ),
        ],
      ),
    );
  }

  Widget Valider(BuildContext context) {
    return Container(
      width: 440,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
//          Text(widget.param_Saisie.Param_Saisie_Controle),
          Container(
            color: gColors.primary,
            width: 8,
          ),
          new ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: gColors.primaryRed,
            ),
            child: Text('Annuler', style: gColors.bodyTitle1_B_W),
          ),
          Container(
            color: gColors.primary,
            width: 8,
          ),
          new ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();
              if (iListe > 0) iListe--;
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: gColors.primaryGreen,
                side: const BorderSide(
                  width: 1.0,
                  color: gColors.primaryGreen,
                )),
            child: Text('Précédent', style: gColors.bodyTitle1_B_W),
          ),          Container(
            color: gColors.primary,
            width: 8,
          ),
          new ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();

              var now = new DateTime.now();
              var formatter = new DateFormat('dd/MM/yyyy');
              String formattedDate = formatter.format(now);

              Srv_DbTools.gIntervention = Intervention.InterventionInit();
              bool wRet = await Srv_DbTools.addIntervention(Srv_DbTools.gSite.SiteId);
              Srv_DbTools.gIntervention.Intervention_isUpdate = wRet;
              if (!wRet) Srv_DbTools.gLastID = new DateTime.now().millisecondsSinceEpoch * -1;
              print("ADD Srv_DbTools.gLastID ${Srv_DbTools.gLastID}");
              print("ADD wRet ${wRet}");

              Srv_DbTools.gIntervention.InterventionId = Srv_DbTools.gLastID;
              Srv_DbTools.gIntervention.Intervention_ZoneId = selZone.ZoneId;
              Srv_DbTools.gIntervention.Intervention_Type = wType;
              Srv_DbTools.gIntervention.Intervention_Parcs_Type = wOrgID;
              Srv_DbTools.gIntervention.Intervention_Date = formattedDate;
              Srv_DbTools.gIntervention.Livr = "";
              Srv_DbTools.gSelIntervention = wOrgID;

              await DbTools.inserInterventions(Srv_DbTools.gIntervention);
              if (wRet) await Srv_DbTools.setIntervention(Srv_DbTools.gIntervention);

              if (widget.isNew) {
                Parc_Ent wParc_Ent = Parc_Ent.Parc_EntInit(Srv_DbTools.gIntervention.InterventionId!, wOrgID, 1);
                wParc_Ent.Parcs_Update = 1;
                await DbTools.insertParc_Ent(wParc_Ent);
//                await Srv_DbTools.InsertUpdateParc_Ent_Srv(wParc_Ent);
              }

              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: gColors.primaryGreen,
                side: const BorderSide(
                  width: 1.0,
                  color: gColors.primaryGreen,
                )),
            child: Text('Valider', style: gColors.bodyTitle1_B_W),
          ),
        ],
      ),
    );
  }
}
