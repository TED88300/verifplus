import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Groupes.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/Client/Client_Sites.dart';
import 'package:verifplus/Widget/Client/Vue_Groupe.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

class Client_Groupes extends StatefulWidget {
  @override
  Client_GroupesState createState() => Client_GroupesState();
}

class Client_GroupesState extends State<Client_Groupes> {
  double textSize = 14.0;

  int SelCol = -1;
  int SelID = -1;
  bool onCellTap = false;
  bool affEdtFilter = false;

  TextEditingController ctrlFilter = new TextEditingController();
  String filterText = '';

  Future Reload() async {
    await Srv_DbTools.getGroupesClient(Srv_DbTools.gClient.ClientId);

    Filtre();
  }

  void Filtre() {
    Srv_DbTools.ListGroupesearchresult.clear();
    Srv_DbTools.ListGroupe.forEach((element) async {
      if (filterText.isEmpty) {
        Srv_DbTools.ListGroupesearchresult.add(element);
      } else {
        String Groupe_Nom = element.Groupe_Nom == null ? "" : element.Groupe_Nom;
        String Groupe_CP = element.Groupe_CP == null ? "" : element.Groupe_CP;
        String Groupe_Ville = element.Groupe_Ville == null ? "" : element.Groupe_Ville;
        String GroupeId = element.GroupeId.toString();
        if (Groupe_Nom.toUpperCase().contains(filterText.toUpperCase()))
          Srv_DbTools.ListGroupesearchresult.add(element);
        else if (Groupe_CP.toUpperCase().contains(filterText.toUpperCase()))
          Srv_DbTools.ListGroupesearchresult.add(element);
        else if (Groupe_Ville.toUpperCase().contains(filterText.toUpperCase()))
          Srv_DbTools.ListGroupesearchresult.add(element);
        else if (GroupeId.toUpperCase().contains(filterText.toUpperCase())) Srv_DbTools.ListGroupesearchresult.add(element);
      }
    });

    print("FILTRE CLIENTS FIN");
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
  Widget Entete_Btn_Search() {
    return Container(
        height: 57,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
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

  @override
  Widget build(BuildContext context) {
    double LargeurLabel = 140;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        //    endDrawer: DbTools.gIsMedecinLogin! ? C_SideDrawer() : I_SideDrawer(),
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
            AutoSizeText(
              "GROUPES",
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
        ),
        body: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              children: [
                gObj.InterventionTitleWidget("${Srv_DbTools.gClient.Client_Nom.toUpperCase()}"),
                Entete_Btn_Search(),
                Expanded(
                  child: GroupeGridWidget(),
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
              await Srv_DbTools.addGroupe(Srv_DbTools.gClient.ClientId);

              Srv_DbTools.gGroupe = Groupe.GroupeInit();
              Srv_DbTools.gGroupe.GroupeId          = Srv_DbTools.gLastID;
              Srv_DbTools.gGroupe.Groupe_ClientId   = Srv_DbTools.gClient.ClientId;
              Srv_DbTools.gGroupe.Groupe_Nom        = Srv_DbTools.gClient.Client_Nom + "_${Srv_DbTools.ListGroupe.length+1}";
              Srv_DbTools.gGroupe.Groupe_Adr1       = Srv_DbTools.gAdresse.Adresse_Adr1;
              Srv_DbTools.gGroupe.Groupe_Adr2       = Srv_DbTools.gAdresse.Adresse_Adr2;
              Srv_DbTools.gGroupe.Groupe_Adr3       = Srv_DbTools.gAdresse.Adresse_Adr3;
              Srv_DbTools.gGroupe.Groupe_CP         = Srv_DbTools.gAdresse.Adresse_CP;
              Srv_DbTools.gGroupe.Groupe_Ville      = Srv_DbTools.gAdresse.Adresse_Ville;
              Srv_DbTools.setGroupe(Srv_DbTools.gGroupe);
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
              await Reload();

            }));
  }

  //***************************

  Widget GroupeGridWidget() {
    String wP, wV = "---";
    String wTmpImage = "Statut_VIDE";

    return Column(
      children: <Widget>[
        gColors.wLigne(),
        Container(
          height: 57.0,
          color: gColors.greyLight,
          child: Row(children: <Widget>[
            Expanded(
                flex: 25,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Image.asset(
                        "assets/images/Icon_Groupe.png",
                        height: icoWidth,
                        width: icoWidth,
                      ),
                    ),
                    Container(
                        child: Text(
                      "Groupes",
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
          ]),
        ),
        gColors.wLigne(),
        SizedBox(height: 5.0),
        Expanded(
          child: ListView.builder(
            itemCount: Srv_DbTools.ListGroupesearchresult.length,
            itemBuilder: (BuildContext context, int index) {
              Groupe groupe = Srv_DbTools.ListGroupesearchresult[index];
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
                      Srv_DbTools.gGroupe = groupe;
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => Groupe_Vue()));
                    },

                    onTap: () async {
                      await HapticFeedback.vibrate();
                      Srv_DbTools.gGroupe = groupe;
                      Srv_DbTools.gSelGroupe = groupe.Groupe_Nom;
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => Client_Sites()));
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
                                  "${groupe.Groupe_Nom}",
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
