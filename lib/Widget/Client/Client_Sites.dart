import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_ImportExport.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Sites.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Zones.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/Client/Client_Groupe_Dialog.dart';
import 'package:verifplus/Widget/Client/Client_Interventions.dart';
import 'package:verifplus/Widget/Client/Client_Zones.dart';
import 'package:verifplus/Widget/Client/Vue_Site.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

class Client_Sites extends StatefulWidget {
  @override
  Client_SitesState createState() => Client_SitesState();
}

class Client_SitesState extends State<Client_Sites> {
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
  bool isAll = true;

  Future Reload() async {

    await Srv_ImportExport.getErrorSync();

    Srv_DbTools.gSelGroupe = Srv_DbTools.gSelGroupeBase;
    bool wRes = await Srv_DbTools.getGroupeSites(Srv_DbTools.gGroupe.GroupeId);

    if (!wRes) Srv_DbTools.ListSite = await DbTools.getSiteGroupe(Srv_DbTools.gGroupe.GroupeId);
    print("getSiteGroupe A ${Srv_DbTools.ListSite.length} ");

    if (Srv_DbTools.ListSite.isEmpty) {
      Srv_DbTools.gSite = Site.SiteInit();
      bool wRet = await Srv_DbTools.addSite(Srv_DbTools.gGroupe.GroupeId);
      Srv_DbTools.gSite.Site_isUpdate = wRet;
      if (!wRet) Srv_DbTools.gLastID = new DateTime.now().millisecondsSinceEpoch * -1;

      Srv_DbTools.gSite.SiteId = Srv_DbTools.gLastID;
      Srv_DbTools.gSite.Site_GroupeId = Srv_DbTools.gGroupe.GroupeId;
      Srv_DbTools.gSite.Site_Nom = Srv_DbTools.gGroupe.Groupe_Nom;
      Srv_DbTools.gSite.Site_Adr1 = Srv_DbTools.gAdresse.Adresse_Adr1;
      Srv_DbTools.gSite.Site_Adr2 = Srv_DbTools.gAdresse.Adresse_Adr2;
      Srv_DbTools.gSite.Site_Adr3 = Srv_DbTools.gAdresse.Adresse_Adr3;
      Srv_DbTools.gSite.Site_CP = Srv_DbTools.gAdresse.Adresse_CP;
      Srv_DbTools.gSite.Site_Ville = Srv_DbTools.gAdresse.Adresse_Ville;

      await DbTools.inserSites(Srv_DbTools.gSite);
      if (wRet)   await Srv_DbTools.setSite(Srv_DbTools.gSite);
      Srv_DbTools.ListSite.add(Srv_DbTools.gSite);

      print("getSiteGroupe B ${Srv_DbTools.ListSite.length} ");
    }
    print("getSiteGroupe B2 ${Srv_DbTools.ListSite.length} ");

    List<String> lGroupe = [];
    for (int i = 0; i < Srv_DbTools.ListSite.length; i++) {
      Site wSite = Srv_DbTools.ListSite[i];
      print("Client_Sites C ${wSite.toMap()} ");
      if (lGroupe.indexOf(wSite.Groupe_Nom) == -1) {
        print("Client_Sites C2 ${wSite.Groupe_Nom} ");
        lGroupe.add(wSite.Groupe_Nom);
      }
    }

    print("Client_Sites D ${lGroupe.length} ");


    PastilleGroupe = lGroupe.length;

    Filtre();
  }

  void Filtre() {
    isAll = true;
    List<Site> wListSite = [];
    Srv_DbTools.ListSitesearchresult.clear();

    print("Filtre A ${Srv_DbTools.ListSite.length} ");

    print("Filtre A2 ${Srv_DbTools.gSelGroupe} ${Srv_DbTools.gSelGroupeBase}");


    if (Srv_DbTools.gSelGroupe.compareTo(Srv_DbTools.gSelGroupeBase) == 0) {
      print("Filtre B1 ${Srv_DbTools.ListSite.length} ");
      wListSite.addAll(Srv_DbTools.ListSite);
    } else {
      print("Filtre B2 ${Srv_DbTools.ListSite.length} ${Srv_DbTools.gSelGroupe}");
      isAll = false;
      Srv_DbTools.ListSite.forEach((element) async {
        print("Filtre B3 ${element.Groupe_Nom} ${Srv_DbTools.gSelGroupe}");
        if (element.Groupe_Nom.compareTo(Srv_DbTools.gSelGroupe) == 0) {
          print("Filtre B4 ${element.Groupe_Nom} ${Srv_DbTools.gSelGroupe}");
          wListSite.add(element);
        }
      });
    }

    print("wListSite ${wListSite.length}");

    if (filterText.isEmpty) {
      Srv_DbTools.ListSitesearchresult.addAll(wListSite);
    } else
      wListSite.forEach((element) async {
        {
          String nom = element.Site_Nom == null ? "" : element.Site_Nom;
          String cp = element.Site_CP == null ? "" : element.Site_CP;
          String ville = element.Site_Ville == null ? "" : element.Site_Ville;

          String Groupe_Nom = element.Groupe_Nom == null ? "" : element.Groupe_Nom;

          String id = element.SiteId.toString();
          if (nom.toUpperCase().contains(filterText.toUpperCase()))
            Srv_DbTools.ListSitesearchresult.add(element);
          else if (cp.toUpperCase().contains(filterText.toUpperCase()))
            Srv_DbTools.ListSitesearchresult.add(element);
          else if (ville.toUpperCase().contains(filterText.toUpperCase()))
            Srv_DbTools.ListSitesearchresult.add(element);
          else if (Groupe_Nom.toUpperCase().contains(filterText.toUpperCase()))
            Srv_DbTools.ListSitesearchresult.add(element);
          else if (id.toUpperCase().contains(filterText.toUpperCase())) Srv_DbTools.ListSitesearchresult.add(element);
        }
      });

    CountSel = Srv_DbTools.ListSitesearchresult.length;

    print("Srv_DbTools.ListSitesearchresult ${Srv_DbTools.ListSitesearchresult.length}");

    print("FILTRE SITES FIN ${Srv_DbTools.ListSite.length} ${Srv_DbTools.ListSitesearchresult.length}");
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
          title: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
            AutoSizeText(
              "SITES",
              maxLines: 1,
              style: gColors.bodyTitle1_B_G24,
            ),
          ]),
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
        ),
        body: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              children: [
                gObj.InterventionTitleWidget("${Srv_DbTools.gClient.Client_Nom.toUpperCase()}", wTitre2: "${Srv_DbTools.gGroupe.Groupe_Nom} "),
                Entete_Btn_Search(),
                Expanded(
                  child: SiteGridWidget(),
                ),
              ],
            )),
        floatingActionButton: new FloatingActionButton(
            elevation: 0.0,
            child: new Icon(Icons.add),
            backgroundColor: gColors.secondary,
            onPressed: () async {
              await DbTools.getAdresseClientType(Srv_DbTools.gClient.ClientId, "LIVR");
              await Srv_DbTools.getContactClientAdrType(Srv_DbTools.gClient.ClientId, Srv_DbTools.gAdresse.AdresseId, "LIVR");

              Srv_DbTools.gSite = Site.SiteInit();
              bool wRet =  await Srv_DbTools.addSite(Srv_DbTools.gClient.ClientId);
              print("retour addSite  ${wRet.toString()}");
              Srv_DbTools.gSite.Site_isUpdate = wRet;
              if (!wRet) Srv_DbTools.gLastID = new DateTime.now().millisecondsSinceEpoch * -1;
              Srv_DbTools.gSite.SiteId          = Srv_DbTools.gLastID;
              print("retour gSite.gZone.SiteId  ${Srv_DbTools.gSite.SiteId}");
              Srv_DbTools.gSite.Site_GroupeId   = Srv_DbTools.gGroupe.GroupeId;
              Srv_DbTools.gSite.Site_Nom        = Srv_DbTools.gGroupe.Groupe_Nom + "_${Srv_DbTools.ListSite.length+1}";
              Srv_DbTools.gSite.Site_Adr1       = Srv_DbTools.gAdresse.Adresse_Adr1;
              Srv_DbTools.gSite.Site_Adr2       = Srv_DbTools.gAdresse.Adresse_Adr2;
              Srv_DbTools.gSite.Site_Adr3       = Srv_DbTools.gAdresse.Adresse_Adr3;
              Srv_DbTools.gSite.Site_CP         = Srv_DbTools.gAdresse.Adresse_CP;
              Srv_DbTools.gSite.Site_Ville      = Srv_DbTools.gAdresse.Adresse_Ville;
              DbTools.inserSites(Srv_DbTools.gSite);
              if (wRet)  Srv_DbTools.setSite(Srv_DbTools.gSite);



              await Srv_DbTools.getContactClientAdrType(Srv_DbTools.gClient.ClientId, Srv_DbTools.gSite.SiteId, "GRP");
              Srv_DbTools.gContact.Contact_Civilite  = Srv_DbTools.gContactLivr.Contact_Civilite ;
              Srv_DbTools.gContact.Contact_Prenom    = Srv_DbTools.gContactLivr.Contact_Prenom   ;
              Srv_DbTools.gContact.Contact_Nom       = Srv_DbTools.gContactLivr.Contact_Nom      ;
              Srv_DbTools.gContact.Contact_Fonction  = Srv_DbTools.gContactLivr.Contact_Fonction ;
              Srv_DbTools.gContact.Contact_Service   = Srv_DbTools.gContactLivr.Contact_Service  ;
              Srv_DbTools.gContact.Contact_Tel1      = Srv_DbTools.gContactLivr.Contact_Tel1     ;
              Srv_DbTools.gContact.Contact_Tel2      = Srv_DbTools.gContactLivr.Contact_Tel2     ;
              Srv_DbTools.gContact.Contact_eMail     = Srv_DbTools.gContactLivr.Contact_eMail    ;
              Srv_DbTools.setContact(Srv_DbTools.gContact);

              await Reload();
              
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
          InkWell(
              child: Container(
                  width: icoWidth + 10,
                  child: Stack(children: <Widget>[
                    Image.asset(
                      "assets/images/Groupe.png",
                      height: icoWidth,
                      width: icoWidth,
                    ),
                    !(PastilleGroupe > 0)
                        ? Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              height: 11,
                            ))
                        : Positioned(
                            top: 0,
                            right: 0,
                            child: Material(
                              borderRadius: BorderRadius.circular(20),
                              elevation: 5,
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: gColors.tks,
                                child: Text("${PastilleGroupe}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                    )),
                              ),
                            ),
                          ),
                  ])),
              onTap: () async {
                await HapticFeedback.vibrate();
                await Client_Groupe_Dialog.Dialogs_Groupe(context);
                Filtre();
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

  void OpenZone() async {
    bool wRes = await Srv_DbTools.getZones(Srv_DbTools.gSite.SiteId);
    if (!wRes) Srv_DbTools.ListZone = await DbTools.getZones(Srv_DbTools.gSite.SiteId);


    if (Srv_DbTools.ListZone.isEmpty) {
      Srv_DbTools.gZone = Zone.ZoneInit();
      bool wRet = await Srv_DbTools.addZone(Srv_DbTools.gSite.SiteId);
      Srv_DbTools.gZone.Zone_isUpdate = wRet;
      if (!wRet) Srv_DbTools.gLastID = new DateTime.now().millisecondsSinceEpoch * -1;
      Srv_DbTools.gZone.ZoneId = Srv_DbTools.gLastID;
      Srv_DbTools.gZone.Zone_SiteId = Srv_DbTools.gSite.SiteId;
      Srv_DbTools.gZone.Zone_Nom = Srv_DbTools.gSite.Site_Nom;
      Srv_DbTools.gZone.Zone_Adr1 = Srv_DbTools.gSite.Site_Adr1;
      Srv_DbTools.gZone.Zone_Adr2 = Srv_DbTools.gSite.Site_Adr2;
      Srv_DbTools.gZone.Zone_Adr3 = Srv_DbTools.gSite.Site_Adr3;
      Srv_DbTools.gZone.Zone_CP = Srv_DbTools.gSite.Site_CP;
      Srv_DbTools.gZone.Zone_Ville = Srv_DbTools.gSite.Site_Ville;
      await DbTools.inserZones(Srv_DbTools.gZone);
      if (wRet) await Srv_DbTools.setZone(Srv_DbTools.gZone);

      await Srv_DbTools.getContactClientAdrType(Srv_DbTools.gClient.ClientId, Srv_DbTools.gZone.ZoneId, "ZONE");
      await Navigator.push(context, MaterialPageRoute(builder: (context) => Client_Interventions()));
    } else if (Srv_DbTools.ListZone.length == 1) {
      Srv_DbTools.gZone = Srv_DbTools.ListZone[0];
      print("SELECT ZONE ${Srv_DbTools.gZone.Desc()}");
      await Srv_DbTools.getContactClientAdrType(Srv_DbTools.gClient.ClientId, Srv_DbTools.gZone.ZoneId, "ZONE");
      await Navigator.push(context, MaterialPageRoute(builder: (context) => Client_Interventions()));
    } else {
      await Navigator.push(context, MaterialPageRoute(builder: (context) => Client_Zones()));
    }
    setState(() {});

  }

  //***************************
  //***************************
  //***************************

  Widget SiteGridWidget() {
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
                          "assets/images/Icon_Site.png",
                          height: icoWidth,
                          width: icoWidth,
                        ),
                      ),
                      Container(
                          child: Text(
                        "Sites",
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
            itemCount: Srv_DbTools.ListSitesearchresult.length,
            itemBuilder: (BuildContext context, int index) {
              Site site = Srv_DbTools.ListSitesearchresult[index];
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
                      Srv_DbTools.gSite = site;
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => Site_Vue()));
                    },

                    onTap: () async {
                      await HapticFeedback.vibrate();
                      Srv_DbTools.gSite = site;
                      OpenZone();
                    },
                    child: Container(
                      height: 57,
                      color : Colors.white,
                      child: Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 5, bottom: 2),
                            child: Text(
                              site.Site_isUpdate ? " " : "◉",
                              maxLines: 1,
                              style: gColors.bodyTitle1_B_R32,
                            ),
                          ),

                          Expanded(
                              flex: 25,
                              child: Container(
                                padding: EdgeInsets.only(left: 10, top: mTop),
                                height: rowh,
                                child: Text(
                                  "${site.Site_Nom}",
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
