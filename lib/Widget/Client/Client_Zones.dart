import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Zones.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/Client/Client_Dialog.dart';
import 'package:verifplus/Widget/Client/Client_Interventions.dart';
import 'package:verifplus/Widget/Client/Vue_Zone.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

class Client_Zones extends StatefulWidget {
  @override
  Client_ZonesState createState() => Client_ZonesState();
}

class Client_ZonesState extends State<Client_Zones> {
  double textSize = 14.0;

  int SelCol = -1;
  int SelID = -1;
  bool onCellTap = false;
  bool affAll = true;
  bool affEdtFilter = false;

  int PastilleGroupe = 0;

  int CountTot = 0;
  int CountSel = 0;

  TextEditingController ctrlFilter = new TextEditingController();
  String filterText = '';

  void Reload() async {
    bool wRes = await Srv_DbTools.getZones(Srv_DbTools.gSite.SiteId);

    if (!wRes) Srv_DbTools.ListZone = await DbTools.getZones(Srv_DbTools.gSite.SiteId);

    print("Client_Zones ${Srv_DbTools.ListZone.length} ");

    List<String> lGroupe = [];
    for (int i = 0; i < Srv_DbTools.ListZone.length; i++) {
      Zone wZone = Srv_DbTools.ListZone[i];
      if (lGroupe.indexOf(wZone.Groupe_Nom) == -1) {
        lGroupe.add(wZone.Groupe_Nom);
      }
    }
    PastilleGroupe = lGroupe.length;

    Filtre();
  }

  void Filtre() {
    List<Zone> wListZone = [];
    Srv_DbTools.ListZonesearchresult.clear();
    wListZone.addAll(Srv_DbTools.ListZone);

    if (filterText.isEmpty) {
      Srv_DbTools.ListZonesearchresult.addAll(wListZone);
    } else
      wListZone.forEach((element) async {
        {
          String nom = element.Zone_Nom == null ? "" : element.Zone_Nom;
          String cp = element.Zone_CP == null ? "" : element.Zone_CP;
          String ville = element.Zone_Ville == null ? "" : element.Zone_Ville;

          String Groupe_Nom = element.Groupe_Nom == null ? "" : element.Groupe_Nom;

          String id = element.ZoneId.toString();
          if (nom.toUpperCase().contains(filterText.toUpperCase()))
            Srv_DbTools.ListZonesearchresult.add(element);
          else if (cp.toUpperCase().contains(filterText.toUpperCase()))
            Srv_DbTools.ListZonesearchresult.add(element);
          else if (ville.toUpperCase().contains(filterText.toUpperCase()))
            Srv_DbTools.ListZonesearchresult.add(element);
          else if (Groupe_Nom.toUpperCase().contains(filterText.toUpperCase()))
            Srv_DbTools.ListZonesearchresult.add(element);
          else if (id.toUpperCase().contains(filterText.toUpperCase())) Srv_DbTools.ListZonesearchresult.add(element);
        }
      });

    CountSel = Srv_DbTools.ListZonesearchresult.length;

    print("Srv_DbTools.ListZonesearchresult ${Srv_DbTools.ListZonesearchresult.length}");

    print("FILTRE ZONES FIN ${Srv_DbTools.ListZone.length} ${Srv_DbTools.ListZonesearchresult.length}");
    setState(() {});
  }

  @override
  void initLib() async {
    Reload();
  }

  void initState() {
    initLib();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double LargeurLabel = 140;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: InkWell(
            onTap: () async {
              await HapticFeedback.vibrate();
              await Client_Dialog.Dialogs_Client(context);
            },
            child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
              AutoSizeText(
                "ZONES",
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
              child: DbTools.gErrorSync
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
        ),
        body: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              children: [
                gObj.InterventionTitleWidget("${Srv_DbTools.gClient.Client_Nom.toUpperCase()}", wTitre2: "${Srv_DbTools.gGroupe.Groupe_Nom} / ${Srv_DbTools.gSite.Site_Nom}"),

                Entete_Btn_Search(),
                Expanded(
                  child: ZoneGridWidget(),
                ),
              ],
            )),
        floatingActionButton: new FloatingActionButton(
            elevation: 0.0,
            child: new Icon(Icons.add),
            backgroundColor: gColors.secondary,
            onPressed: () async {
              setState(() {});
            }));
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

  double icoWidth = 40;

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

  //***************************
  //***************************
  //***************************

  Widget ZoneGridWidget() {
    String wP, wV = "---";
    String wTmpImage = "Statut_VIDE";

    return Column(
      children: <Widget>[
        gColors.wLigne(),
        Container(
          height: 57.0,
          color: gColors.greyLight,
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 25,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Image.asset(
                          "assets/images/Icon_Zone.png",
                          height: icoWidth,
                          width: icoWidth,
                        ),
                      ),
                      Container(
                          child: Text(
                        "Zones",
                        textAlign: TextAlign.start,
                        style: gColors.bodySaisie_B_B,
                      ))
                    ],
                  )),
              Expanded(
                  flex: 8,
                  child: Container(
                      child: Text(
                    "Période R",
                    textAlign: TextAlign.center,
                    style: gColors.bodySaisie_B_B,
                  ))),
              Expanded(
                  flex: 10,
                  child: Container(
                      child: Text(
                    "Statut",
                    textAlign: TextAlign.center,
                    style: gColors.bodySaisie_B_B,
                  ))),
              Expanded(
                  flex: 10,
                  child: Container(
                      child: Text(
                    "Visite",
                    textAlign: TextAlign.center,
                    style: gColors.bodySaisie_B_B,
                  ))),
            ],
          ),
        ),
        gColors.wLigne(),
        SizedBox(height: 5.0),
        Expanded(
          child: ListView.builder(
            itemCount: Srv_DbTools.ListZonesearchresult.length,
            itemBuilder: (BuildContext context, int index) {
              Zone zone = Srv_DbTools.ListZonesearchresult[index];

              double rowh = 24;

              wP = wV = "---";
              wV = "Multi >";
              wTmpImage = "Statut_VIDE";

              if (index > 2) {
                wP = "Sept.-22";
                wV = "26/09/23";
              }

              if (index == 3) wTmpImage = "Statut_EC";
              if (index == 4) wTmpImage = "Statut_CL";
              if (index == 5) wTmpImage = "Statut_FD";

              double mTop = 4;

              return Column(
                children: [
                  new GestureDetector(
                    //You need to make my child interactive
                    onDoubleTap: () async {
                      await HapticFeedback.vibrate();
                      Srv_DbTools.gZone = zone;
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => Zone_Vue()));
                    },

                    onTap: () async {
                      await HapticFeedback.vibrate();
                      Srv_DbTools.gZone = zone;
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => Client_Interventions()));

                      setState(() {});
                    },
                    child: Container(
                      height: 57,
                      color : Colors.white,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 25,
                              child: Container(
                                padding: EdgeInsets.only(left: 10, top: mTop),
                                height: rowh,
                                child: Text(
                                  "${zone.Zone_Nom}",
                                  maxLines: 1,
                                  style: gColors.bodySaisie_B_B,
                                ),
                              )),
                          Expanded(
                              flex: 8,
                              child: Container(
                                  padding: EdgeInsets.only(top: mTop),
                                  height: rowh,
                                  child: Text(
                                    wP,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: index == 5 ? gColors.bodySaisie_B_B.copyWith(color: Colors.red) : gColors.bodySaisie_B_B,
                                  ))),
                          Expanded(
                            flex: 10,
                            child: Container(
                              child: Image.asset(
                                "assets/images/${wTmpImage}.png",
                                height: icoWidth,
                                width: icoWidth,
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 10,
                              child: Container(
                                  padding: EdgeInsets.only(right: 10, top: mTop),
                                  height: rowh,
                                  child: Text(
                                    index == 5 ? "Planifié ${wV}" : wV,
                                    textAlign: TextAlign.right,
                                    maxLines: 1,
                                    style: index > 4 ? gColors.bodySaisie_B_B.copyWith(color: Colors.orange) : gColors.bodySaisie_B_B,
                                  ))),
                        ],
                      ),
                    ),
                  ),
                  gColors.wLigne(),
                ],
              );
            },
          ),
        ),
        SizedBox(height: 45.0),
      ],
    );
  }

  //***************************
  //***************************
  //***************************
}
