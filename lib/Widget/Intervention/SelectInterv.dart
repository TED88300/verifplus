// SELECTION INTERVENTION

import 'package:flutter/material.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Clients.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Groupes.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Interventions.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Sites.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Zones.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';


typedef selChanged = void Function(selChangedDetails pickerChangedDetails);

class selChangedDetails {
  selChangedDetails({this.depot, this.client, this.groupe, this.site, this.zone, this.intervention});
  final String? depot;
  final Client? client;
  final Groupe? groupe;
  final Site? site;
  final Zone? zone;
  final Intervention? intervention;
}

class Select_Inter {
  Select_Inter();

  static Future<void> Dialogs_Sel(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => const SelectInter(),
    );
  }
}

class SelectInter extends StatefulWidget {
  const SelectInter({super.key});


  @override
  State<StatefulWidget> createState() => SelectInterState();
}

class SelectInterState extends State<SelectInter> {
  final Search_Client_TextController = TextEditingController();
  final Search_Site_TextController = TextEditingController();

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

  Future FlitreClient() async {
    ListClient.clear();
    ListGroupe.clear();
    ListSite.clear();
    ListZone.clear();
    ListIntervention.clear();

    await Srv_DbTools.getClientRech(Search_Client_TextController.text, selDepot);
    print(">>>>>> ${Srv_DbTools.ListClient.length}");
    ListClient.addAll(Srv_DbTools.ListClient);

    setState(() {});
  }

  Future FlitreSite() async {
    ListClient.clear();
    ListGroupe.clear();
    ListSite.clear();
    ListZone.clear();
    ListIntervention.clear();

    print(">>>>>> FlitreSite");

    await Srv_DbTools.getSiteRech(0, Search_Site_TextController.text);
    print(">>>>>> ${Srv_DbTools.ListSite.length}");
    ListSite.addAll(Srv_DbTools.ListSite);
    print(">>>>>> ${ListSite.length}");
    setState(() {});
  }

  Future Relaod() async {
    ListClient.clear();
    ListGroupe.clear();
    ListSite.clear();
    ListZone.clear();
    ListIntervention.clear();

    if (selDepot.isNotEmpty) {
      await Srv_DbTools.getClientDepotp(selDepot);
      print(">>>>>> ${Srv_DbTools.ListClient.length}");
      ListClient.addAll(Srv_DbTools.ListClient);

      if (ListClient.length == 1) selClient = ListClient[0];

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

  void initLib() async {
    await DbTools.getAdresseType("AGENCE");
    ListDepot.clear();
    for (var wAdresse in Srv_DbTools.ListAdressesearchresult) {
      ListDepot.add(wAdresse.Adresse_Nom);
    }
    await Relaod();
  }

  @override
  void initState() {
    initLib();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    gColors.wTheme = Theme.of(context);
    return Theme(
        data: gColors.wTheme,
        child: AlertDialog(
          title: Container(
            width: 400,
            color: gColors.primary,
            child: Row(
              children: [
                Container(
                  width: 10,
                ),
                InkWell(
                  child: SizedBox(
                      height: 30.0,
                      child: Image.asset(
                        'assets/images/AppIcow.png',
                      )),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const Spacer(),
                Text(
                  "Recherche Intervention",
                  textAlign: TextAlign.center,
                  style: gColors.bodyTitle1_B_W,
                ),
                const Spacer(),
                Container(
                  width: 40,
                ),
              ],
            ),
          ),
          content: SizedBox(
              width: 2000,
              height: 500,
              child: Row(
                children: [
                  listDepots(),
                  const SizedBox(
                    width: 10,
                  ),
                  listClients(),
                  const SizedBox(
                    width: 10,
                  ),
                  listGroupes(),
                  const SizedBox(
                    width: 10,
                  ),
                  listSites(),
                  const SizedBox(
                    width: 10,
                  ),
                  listZones(),
                  const SizedBox(
                    width: 10,
                  ),
                  listInterventions(),
                ],
              )),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                setState(() {
//                  widget.onChanged(selChangedDetails(depot: selDepot, client: selClient, groupe: selGroupe, site: selSite, zone: selZone, intervention: selIntervention));
                });

                // ignore: always_specify_types
                Future.delayed(const Duration(milliseconds: 200), () {
                  // When task is over, close the dialog
                  Navigator.pop(context);
                });
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: gColors.primaryGreen,
              ),
              child: Text(
                'Valider',
                style: gColors.bodySaisie_B_W,
                //    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)
              ),
            ),
          ],
        ));
  }

  Widget listDepots() {
    double h = 500;
    return Column(
      children: [
        const SizedBox(
          width: 200,
          height: 32,
        ),
        Container(
          width: 200,
          height: h - 32,
          decoration: BoxDecoration(
              color: gColors.white,
              border: Border.all(
                color: gColors.primary,
              )),
          child: Column(
            children: [
              Container(
                width: 200,
                height: 20,
                color: gColors.primary,
                child: Text(
                  "Agences",
                  textAlign: TextAlign.center,
                  style: gColors.bodySaisie_B_W,
                ),
              ),
              SizedBox(
                  width: 200,
                  height: h - 54,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: ListDepot.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String wDepot = ListDepot[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: (wDepot == selDepot) ? Colors.blue : Colors.white,
                        ),
                        child: ListTile(
                          dense: true,
                          selected: (wDepot == selDepot),
                          selectedColor: Colors.white,
                          visualDensity: const VisualDensity(vertical: -4),
                          title: Text(wDepot),
                          onTap: () async {
                            if (selDepot != wDepot) {
                              selDepot = wDepot;
                            } else {
                              selDepot = "";
                            }
                            await Relaod();
                          },
                        ),
                      );
                    },
                  ))
            ],
          ),
        )
      ],
    );
  }

  Widget listClients() {
    double h = 500;
    double W = 350;
    return Container(
      width: W,
      height: h,
      decoration: BoxDecoration(
          color: gColors.white,
          border: Border.all(
            color: gColors.primary,
          )),
      child: Column(
        children: [
          TextFormField(
            controller: Search_Client_TextController,
            decoration: gColors.wRechInputDecorationSelPlanning,
            onChanged: (String? value) async {
              if (Search_Client_TextController.text.length >= 2) {
                selDepot = "";
                FlitreClient();
              }
            },
            style: gColors.bodySaisie_B_B,
          ),
          Container(
            width: W,
            height: 20,
            color: gColors.primary,
            child: Text(
              "Clients",
              textAlign: TextAlign.center,
              style: gColors.bodySaisie_B_W,
            ),
          ),
          SizedBox(
              width: W,
              height: h - 54,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: ListClient.length,
                itemBuilder: (BuildContext context, int index) {
                  final Client wClient = ListClient[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: (wClient.ClientId == selClient.ClientId) ? Colors.blue : Colors.white,
                    ),
                    child: ListTile(
                      dense: true,
                      selected: (wClient.ClientId == selClient.ClientId),
                      selectedColor: Colors.white,
                      visualDensity: const VisualDensity(vertical: -4),
                      title: Text(wClient.Client_Nom),
                      onTap: () async {
                        if (selClient.ClientId != wClient.ClientId) {
                          selClient = wClient;
                          Search_Client_TextController.text = "";
                          selDepot = selClient.Client_Depot;
                        } else {
                          selClient = Client.ClientInit();
                        }
                        await Relaod();
                      },
                    ),
                  );
                },
              ))
        ],
      ),
    );
  }

  Widget listGroupes() {
    double h = 500;
    return Column(
      children: [
        const SizedBox(
          width: 200,
          height: 32,
        ),
        Container(
          width: 200,
          height: h - 32,
          decoration: BoxDecoration(
              color: gColors.white,
              border: Border.all(
                color: gColors.primary,
              )),
          child: Column(
            children: [
              Container(
                width: 200,
                height: 20,
                color: gColors.primary,
                child: Text(
                  "Groupes",
                  textAlign: TextAlign.center,
                  style: gColors.bodySaisie_B_W,
                ),
              ),
              SizedBox(
                  width: 200,
                  height: h - 54,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: ListGroupe.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Groupe wGroupe = ListGroupe[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: (wGroupe.GroupeId == selGroupe.GroupeId) ? Colors.blue : Colors.white,
                        ),
                        child: ListTile(
                          dense: true,
                          selected: (wGroupe.GroupeId == selGroupe.GroupeId),
                          selectedColor: Colors.white,
                          visualDensity: const VisualDensity(vertical: -4),
                          title: Text(wGroupe.Groupe_Nom),
                          onTap: () async {
                            if (selGroupe.GroupeId != wGroupe.GroupeId) {
                              selGroupe = wGroupe;
                            } else {
                              selGroupe = Groupe.GroupeInit();
                            }
                            await Relaod();
                          },
                        ),
                      );
                    },
                  ))
            ],
          ),
        )
      ],
    );
  }

  Widget listSites() {
    double h = 500;
    double w = 390;

    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
          color: gColors.white,
          border: Border.all(
            color: gColors.primary,
          )),
      child: Column(
        children: [
          TextFormField(
            controller: Search_Site_TextController,
            decoration: gColors.wRechInputDecorationSelPlanning,
            onChanged: (String? value) async {
              if (Search_Site_TextController.text.length >= 2) {
                selDepot = "";
                FlitreSite();
              }
            },
            style: gColors.bodySaisie_B_B,
          ),
          Container(
            width: w,
            height: 20,
            color: gColors.primary,
            child: Text(
              "Sites",
              textAlign: TextAlign.center,
              style: gColors.bodySaisie_B_W,
            ),
          ),
          SizedBox(
              width: w,
              height: h - 54,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: ListSite.length,
                itemBuilder: (BuildContext context, int index) {
                  final Site wSite = ListSite[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: (wSite.SiteId == selSite.SiteId) ? Colors.blue : Colors.white,
                    ),
                    child: ListTile(
                      dense: true,
                      selected: (wSite.SiteId == selSite.SiteId),
                      selectedColor: Colors.white,
                      visualDensity: const VisualDensity(vertical: -4),
                      title: Text(wSite.Site_Nom),
                      onTap: () async {
                        if (selSite.SiteId != wSite.SiteId) {
                          selSite = wSite;
                          Search_Site_TextController.text = "";
                          await DbTools.getGroupe(selSite.Site_GroupeId);
                          selGroupe = Srv_DbTools.gGroupe;
                          await DbTools.getClient(selGroupe.Groupe_ClientId);
                          selClient = Srv_DbTools.gClient;
                          selDepot = selClient.Client_Depot;
                        } else {
                          selSite = Site.SiteInit();
                        }
                        await Relaod();
                      },
                    ),
                  );
                },
              ))
        ],
      ),
    );
  }

  Widget listZones() {
    double h = 500;
    return Column(
      children: [
        const SizedBox(
          width: 200,
          height: 32,
        ),
        Container(
          width: 200,
          height: h - 32,
          decoration: BoxDecoration(
              color: gColors.white,
              border: Border.all(
                color: gColors.primary,
              )),
          child: Column(
            children: [
              Container(
                width: 200,
                height: 20,
                color: gColors.primary,
                child: Text(
                  "Zones",
                  textAlign: TextAlign.center,
                  style: gColors.bodySaisie_B_W,
                ),
              ),
              SizedBox(
                  width: 200,
                  height: h - 54,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: ListZone.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Zone wZone = ListZone[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: (wZone.ZoneId == selZone.ZoneId) ? Colors.blue : Colors.white,
                        ),
                        child: ListTile(
                          dense: true,
                          selected: (wZone.ZoneId == selZone.ZoneId),
                          selectedColor: Colors.white,
                          visualDensity: const VisualDensity(vertical: -4),
                          title: Text(wZone.Zone_Nom),
                          onTap: () async {
                            if (selZone.ZoneId != wZone.ZoneId) {
                              selZone = wZone;
                            } else {
                              selZone = Zone.ZoneInit();
                            }
                            await Relaod();
                          },
                        ),
                      );
                    },
                  ))
            ],
          ),
        )
      ],
    );
  }

  Widget listInterventions() {
    double h = 500;
    double w = 400;

    return Column(
      children: [
        const SizedBox(
          width: 200,
          height: 32,
        ),
        Container(
          width: w,
          height: h - 32,
          decoration: BoxDecoration(
              color: gColors.white,
              border: Border.all(
                color: gColors.primary,
              )),
          child: Column(
            children: [
              Container(
                width: w,
                height: 20,
                color: gColors.primary,
                child: Text(
                  "Interventions",
                  textAlign: TextAlign.center,
                  style: gColors.bodySaisie_B_W,
                ),
              ),
              SizedBox(
                  width: w,
                  height: h - 54,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: ListIntervention.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Intervention wIntervention = ListIntervention[index];
                      String wDate = "----/----/-------";
                      if (wIntervention.Intervention_Date.isNotEmpty) wDate = wIntervention.Intervention_Date;
                      return Container(
                        decoration: BoxDecoration(
                          color: (wIntervention.InterventionId == selIntervention.InterventionId) ? Colors.blue : Colors.white,
                        ),
                        child: ListTile(
                          dense: true,
                          selected: (wIntervention.InterventionId == selIntervention.InterventionId),
                          selectedColor: Colors.white,
                          visualDensity: const VisualDensity(vertical: -4),
                          title: Text("[${wIntervention.InterventionId}] $wDate ${wIntervention.Intervention_Type} ${wIntervention.Intervention_Parcs_Type} ${wIntervention.Intervention_Status}"),
                          onTap: () async {
                            if (selIntervention.InterventionId != wIntervention.InterventionId) {
                              selIntervention = wIntervention;
                            } else {
                              selIntervention = Intervention.InterventionInit();
                            }
                            await Relaod();
                          },
                        ),
                      );
                    },
                  ))
            ],
          ),
        )
      ],
    );
  }
}
