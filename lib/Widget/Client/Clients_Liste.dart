import 'package:davi/davi.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Clients.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Groupes.dart';
import 'package:verifplus/Tools/DbSrv/Srv_ImportExport.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/Client/Client_Groupes.dart';
import 'package:verifplus/Widget/Client/Client_Sites.dart';
import 'package:verifplus/Widget/Client/Vue_Client.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

class Liste_Clients extends StatefulWidget {
  @override
  Liste_ClientsState createState() => Liste_ClientsState();
}

class Liste_ClientsState extends State<Liste_Clients> {
  double textSize = 14.0;
  int SelCol = -1;
  int SelID = -1;
  bool onCellTap = false;
  int CountTot = 0;
  int CountSel = 0;
  bool affEdtFilter = false;

  double icoWidth = 38;

  TextEditingController ctrlFilter = new TextEditingController();
  String filterText = '';

  Future Reload() async {

    print("Liste_Clients Reload");
    await Srv_ImportExport.ImportClient();
    await Srv_ImportExport.ImportAdresse();
    await Srv_ImportExport.ImportContact();

    CountTot = CountSel = Srv_DbTools.ListClientsearchresult.length;
    Filtre();
  }

  void Filtre() {
    Srv_DbTools.ListClientsearchresult.clear();
    Srv_DbTools.ListClient.forEach((element) async {
      if (filterText.isEmpty) {
        Srv_DbTools.ListClientsearchresult.add(element);
      } else {
        String nom = element.Client_Nom == null ? "" : element.Client_Nom;
        String cp = element.Adresse_CP == null ? "" : element.Adresse_CP;
        String ville = element.Adresse_Ville == null ? "" : element.Adresse_Ville;
        String id = element.ClientId.toString();
        if (nom.toUpperCase().contains(filterText.toUpperCase()))
          Srv_DbTools.ListClientsearchresult.add(element);
        else if (cp.toUpperCase().contains(filterText.toUpperCase()))
          Srv_DbTools.ListClientsearchresult.add(element);
        else if (ville.toUpperCase().contains(filterText.toUpperCase()))
          Srv_DbTools.ListClientsearchresult.add(element);
        else if (id.toUpperCase().contains(filterText.toUpperCase())) Srv_DbTools.ListClientsearchresult.add(element);
      }
    });
    CountSel = Srv_DbTools.ListClientsearchresult.length;
    print("FILTRE CLIENTS FIN");
    setState(() {});
  }

  @override
  void initLib() async {
    print("Liste_Clients initLib");
    Reload();
  }

  void initState() {
    print("Liste_Clients initState");
    initLib();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    print('Liste_Clients build');

    return Scaffold(
        body: Column(
          children: [
            gObj.InterventionTitleWidget(""),
            Entete_Btn_Search(),
            Expanded(
                child: //ClientsGridWidget(),
                    ClientGridWidget()),
          ],
        ),
        floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: FloatingActionButton(
                elevation: 0.0,
                child: new Icon(Icons.add),
                backgroundColor: gColors.secondary,
                onPressed: () async {
                  await ToolsBarAdd();
                  setState(() {});
                })
        )
    );
  }

  late Map<String, double> columnWidths = {
    'CID': double.nan,
    'ID': double.nan,
    'CP': double.nan,
    'VILLE': double.nan,
    'SITE': double.nan,
    'ORGAN': double.nan,
    'COLL': double.nan,
    'F': double.nan,
    'ETAT': double.nan,
  };

  Future ToolsBarAdd() async {
    print("ToolsBarAdd");

    Client wClient = await Client.ClientInit();
    await Srv_DbTools.addClient(wClient);
    wClient.ClientId = Srv_DbTools.gLastID;
    wClient.Client_Nom = "???";

    await HapticFeedback.vibrate();
    Srv_DbTools.gClient = wClient;
    OpenClient();
  }

  void OpenGroupe() async {
    return;

    await Srv_DbTools.getAdresseClientType(Srv_DbTools.gClient.ClientId, "LIVR");
    await Srv_DbTools.getContactClientAdrType(Srv_DbTools.gClient.ClientId, Srv_DbTools.gAdresse.AdresseId, "LIVR");
    await Srv_DbTools.getGroupesClient(Srv_DbTools.gClient.ClientId);
    if (Srv_DbTools.ListGroupe.isEmpty) {
      Srv_DbTools.gGroupe = Groupe.GroupeInit();
      Srv_DbTools.gGroupe.GroupeId = Srv_DbTools.gLastID;
      Srv_DbTools.gGroupe.Groupe_ClientId = Srv_DbTools.gClient.ClientId;
      Srv_DbTools.gGroupe.Groupe_Nom = Srv_DbTools.gClient.Client_Nom;
      Srv_DbTools.gGroupe.Groupe_Adr1 = Srv_DbTools.gAdresse.Adresse_Adr1;
      Srv_DbTools.gGroupe.Groupe_Adr2 = Srv_DbTools.gAdresse.Adresse_Adr2;
      Srv_DbTools.gGroupe.Groupe_Adr3 = Srv_DbTools.gAdresse.Adresse_Adr3;
      Srv_DbTools.gGroupe.Groupe_CP = Srv_DbTools.gAdresse.Adresse_CP;
      Srv_DbTools.gGroupe.Groupe_Ville = Srv_DbTools.gAdresse.Adresse_Ville;

      Srv_DbTools.gContactLivr = Srv_DbTools.gContact;

      await Srv_DbTools.getContactClientAdrType(Srv_DbTools.gClient.ClientId, Srv_DbTools.gGroupe.GroupeId, "GRP");
      Srv_DbTools.gContact.Contact_Civilite  = Srv_DbTools.gContactLivr.Contact_Civilite ;
      Srv_DbTools.gContact.Contact_Prenom    = Srv_DbTools.gContactLivr.Contact_Prenom   ;
      Srv_DbTools.gContact.Contact_Nom       = Srv_DbTools.gContactLivr.Contact_Nom      ;
      Srv_DbTools.gContact.Contact_Fonction  = Srv_DbTools.gContactLivr.Contact_Fonction ;
      Srv_DbTools.gContact.Contact_Service   = Srv_DbTools.gContactLivr.Contact_Service  ;
      Srv_DbTools.gContact.Contact_Tel1      = Srv_DbTools.gContactLivr.Contact_Tel1     ;
      Srv_DbTools.gContact.Contact_Tel2      = Srv_DbTools.gContactLivr.Contact_Tel2     ;
      Srv_DbTools.gContact.Contact_eMail     = Srv_DbTools.gContactLivr.Contact_eMail    ;
      Srv_DbTools.setContact(Srv_DbTools.gContact);

      await Srv_DbTools.setGroupe(Srv_DbTools.gGroupe);
      await Navigator.push(context, MaterialPageRoute(builder: (context) => Client_Sites()));

    } else if (Srv_DbTools.ListGroupe.length == 1) {
      Srv_DbTools.gGroupe = Srv_DbTools.ListGroupe[0];
      Srv_DbTools.gSelGroupe = Srv_DbTools.ListGroupe[0].Groupe_Nom;
      await Navigator.push(context, MaterialPageRoute(builder: (context) => Client_Sites()));

    } else {
      await Navigator.push(context, MaterialPageRoute(builder: (context) => Client_Groupes()));
    }
    setState(() {});
  }

  Future OpenClient() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => Client_Vue()));
    Reload();
  }
  //***************************
  //***************************
  //***************************

  Widget ClientGridWidget() {
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
                          "assets/images/Icon_Client.png",
                          height: icoWidth,
                          width: icoWidth,
                        ),
                      ),
                      Container(
                          child: Text(
                        "Clients",
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
            itemCount: Srv_DbTools.ListClientsearchresult.length,
            itemBuilder: (BuildContext context, int index) {
              Client client = Srv_DbTools.ListClientsearchresult[index];
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
              double rowh = 24;
              double mTop = 4;

              return Column(
                children: [
                  new GestureDetector(
                    //You need to make my child interactive
                    onDoubleTap: () async {
                      await HapticFeedback.vibrate();
                      Srv_DbTools.gClient = client;
                      await OpenClient();
                    },

                    onTap: () async {
                      await HapticFeedback.vibrate();
                      Srv_DbTools.gClient = client;
                      OpenGroupe();
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
                                  "${client.Client_Nom}",
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
                                    style: index > 4 ? gColors.bodySaisie_B_B.copyWith(color: gColors.primaryOrange) : gColors.bodySaisie_B_B,
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
      ],
    );
  }
}
