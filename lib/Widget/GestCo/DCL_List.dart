import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DCL_Ent.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_ImportExport.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Param.dart';
import 'package:verifplus/Widget/Client/Client_DCL_Ent_Type_Dialog.dart';
import 'package:verifplus/Widget/Planning/Client_Groupe_Inter_Det.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';

class DCL_List extends StatefulWidget {
  @override
  DCL_ListState createState() => DCL_ListState();
}

class DCL_ListState extends State<DCL_List> with SingleTickerProviderStateMixin {
  bool isChecked = false;
  bool affAll = true;
  bool affEdtFilter = false;

  TextEditingController ctrlFilter = new TextEditingController();
  String filterText = '';
  bool isAll = true;
  int PastilleType = 0;
  double textSize = 14.0;

  int SelCol = -1;
  int SelID = -1;
  bool onCellTap = false;
  String wAction = "";

  void Reload() async {
    await Srv_ImportExport.getErrorSync();
    bool wRes = await Srv_DbTools.getDCL_EntAll();

    Srv_DbTools.ListDCL_Ent.sort(Srv_DbTools.affSortComparisonData_DCL);
    List<String> lDCL_Ent = [];
    for (int i = 0; i < Srv_DbTools.ListDCL_Ent.length; i++) {
      DCL_Ent wDCL_Ent = Srv_DbTools.ListDCL_Ent[i];


      wDCL_Ent.DCL_Ent_ClientNom = "";
      if (await Srv_DbTools.getClient(wDCL_Ent.DCL_Ent_ClientId!))
        {
          wDCL_Ent.DCL_Ent_ClientNom = Srv_DbTools.gClient.Client_Nom;
        }

      if (lDCL_Ent.indexOf(wDCL_Ent.DCL_Ent_Type!) == -1) {
        lDCL_Ent.add(wDCL_Ent.DCL_Ent_Type!);
      }
    }

    PastilleType = lDCL_Ent.length;
    if (lDCL_Ent.length == 0) {
      Srv_DbTools.gSelDCL_Ent = Srv_DbTools.gSelDCL_EntBase;
    } else {
      int index = lDCL_Ent.indexWhere((element) => element.compareTo(Srv_DbTools.gSelDCL_Ent) == 0);
      if (index < 0) {
        Srv_DbTools.gSelDCL_Ent = Srv_DbTools.gSelDCL_EntBase;
      }
    }
    Filtre();
  }

  void Filtre() {
    isAll = true;
    List<DCL_Ent> wListDCL_Ent = [];
    Srv_DbTools.ListDCL_Entsearchresult.clear();
    print("Srv_DbTools.ListDCL_Ent ${Srv_DbTools.ListDCL_Ent.length}");

    if (Srv_DbTools.gSelDCL_Ent.compareTo(Srv_DbTools.gSelDCL_EntBase) == 0) {
      wListDCL_Ent.addAll(Srv_DbTools.ListDCL_Ent);
    } else {
      isAll = false;
      Srv_DbTools.ListDCL_Ent.forEach((element) async {
        if (element.DCL_Ent_Type!.compareTo(Srv_DbTools.gSelDCL_Ent) == 0) {
          wListDCL_Ent.add(element);
        }
      });
    }

    print("wListDCL_Ent ${wListDCL_Ent.length}");

    if (filterText.isEmpty) {
      Srv_DbTools.ListDCL_Entsearchresult.addAll(wListDCL_Ent);
    } else
      wListDCL_Ent.forEach((element) async {
        {
          String DCL_Ent_Type = element.DCL_Ent_Type == null ? "" : element.DCL_Ent_Type!;
          String DCL_Ent_Etat = element.DCL_Ent_Etat == null ? "" : element.DCL_Ent_Etat!;

          String id = element.DCL_EntID.toString();
          if (DCL_Ent_Type.toUpperCase().contains(filterText.toUpperCase()))
            Srv_DbTools.ListDCL_Entsearchresult.add(element);
          else if (DCL_Ent_Type.toUpperCase().contains(filterText.toUpperCase()))
            Srv_DbTools.ListDCL_Entsearchresult.add(element);
          else if (DCL_Ent_Etat.toUpperCase().contains(filterText.toUpperCase()))
            Srv_DbTools.ListDCL_Entsearchresult.add(element);
          else if (id.toUpperCase().contains(filterText.toUpperCase())) Srv_DbTools.ListDCL_Entsearchresult.add(element);
        }
      });

    print("Srv_DbTools.ListDCL_Entsearchresult ${Srv_DbTools.ListDCL_Entsearchresult.length}");

    print("FILTRE DCL_EntS FIN ${Srv_DbTools.ListDCL_Ent.length} ${Srv_DbTools.ListDCL_Entsearchresult.length}");
    setState(() {});
  }

  @override
  void initLib() async {
    Srv_DbTools.gSelDCL_Ent = "Ext";
    Reload();
  }

  void initState() {
    initLib();
    super.initState();
    FBroadcast.instance().register("Maj_DCL_Ent", (value, callback) {
      initLib();
    });
  }

  @override
  void dispose() {
    FBroadcast.instance().unregister(this);
    super.dispose();
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
              child: Container(
                width: icoWidth + 10,
                child: Stack(children: <Widget>[
                  Image.asset(
                    "assets/images/Btn_Burger.png",
                    height: icoWidth,
                    width: icoWidth,
                  ),
                  !(PastilleType > 0)
                      ? Container()
                      : Positioned(
                          top: 0,
                          right: 0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20),
                            elevation: 5,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: gColors.tks,
                              child: Text("${PastilleType}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  )),
                            ),
                          ),
                        ),
                ]),
              ),
              onTap: () async {
                await HapticFeedback.vibrate();
                await Client_DCL_Ent_Type_Dialog.Dialogs_DCL_Ent_Type(context);
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

  @override
  Widget build(BuildContext context) {
    double LargeurLabel = 140;

    Param_Param wParam_Param = Srv_DbTools.getParam_Param_in_Mem("Type_Organe", Srv_DbTools.gSelDCL_Ent);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      //    endDrawer: DbTools.gIsMedecinLogin! ? C_SideDrawer() : I_SideDrawer(),

      backgroundColor: Colors.white,

      body: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            children: [
//              gObj.DCL_EntTitleWidgetCalc(context, "${Srv_DbTools.gClient.Client_Nom.toUpperCase()}", wTitre2: "${Srv_DbTools.gGroupe.Groupe_Nom}", wTitre3:"${Srv_DbTools.gSite.Site_Nom}", wTitre4:"${Srv_DbTools.gZone.Zone_Nom}"),
              Entete_Btn_Search(),
              Expanded(
                child: DCL_EntGridWidget(),
              ),
            ],
          )),
      floatingActionButton: !affAll
          ? Container()
          : Container(
              padding: EdgeInsets.fromLTRB(0, 0, 50, 60),
              child: new FloatingActionButton(
                  elevation: 0.0,
                  child: new Icon(Icons.add),
                  backgroundColor: gColors.secondary,
                  onPressed: () async {
//              await Select_DCL_Ents_Add.Dialogs_Add(context, true);
                    Reload();
                  }),
            ),
    );
  }

  //***************************
  //***************************
  //***************************

  Widget DCL_EntGridWidget() {
    return Column(
      children: <Widget>[
        gColors.wLigne(),
        Container(
          height: 57.0,
          color: gColors.greyLight,
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 5,
                  child: Container(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        "ID",
                        textAlign: TextAlign.left,
                        style: gColors.bodySaisie_B_B,
                      ))),
              Expanded(
                  flex: 8,
                  child: Container(
                      child: Text(
                        "Type",
                        textAlign: TextAlign.left,
                        style: gColors.bodySaisie_B_B,
                      ))),
              Expanded(
                  flex: 6,
                  child: Container(
                      child: Text(
                    "Statut",
                    textAlign: TextAlign.left,
                    style: gColors.bodySaisie_B_B,
                  ))),
              Expanded(
                  flex: 25,
                  child: Container(
                      child: Text(
                    "Client/Groupe/Site/Zone",
                    textAlign: TextAlign.left,
                    style: gColors.bodySaisie_B_B,
                  ))),

              Expanded(
                  flex: 5,
                  child: Container(
                      child: Text(
                    "Date",
                    textAlign: TextAlign.left,
                    style: gColors.bodySaisie_B_B,
                  ))),
            ],
          ),
        ),
        gColors.wLigne(),
        SizedBox(height: 5.0),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
            itemCount: Srv_DbTools.ListDCL_Entsearchresult.length,
            itemBuilder: (BuildContext context, int index) {
              DCL_Ent dCL_Ent = Srv_DbTools.ListDCL_Entsearchresult[index];
              Color wColor = Colors.transparent;

              print("dCL_Ent.DCL_Ent_Type ${dCL_Ent.DCL_Ent_Type}");

              if (dCL_Ent.DCL_Ent_Type == "Devis")
                  wColor = gColors.getColorEtatDevis(dCL_Ent.DCL_Ent_Etat!);
              if (dCL_Ent.DCL_Ent_Type == "Commande")
                  wColor = gColors.getColorEtatCde(dCL_Ent.DCL_Ent_Etat!);
              if (dCL_Ent.DCL_Ent_Type == "Bon de livraison")
                  wColor = gColors.getColorEtatLivr(dCL_Ent.DCL_Ent_Etat!);

              double rowh = 24;


/*
              String wNom = "${dCL_Ent.Client_Nom}/${dCL_Ent.Site_Nom}/${dCL_Ent.Groupe_Nom}/${dCL_Ent.Zone_Nom}";
              if (dCL_Ent.Client_Nom == dCL_Ent.Site_Nom && dCL_Ent.Client_Nom == dCL_Ent.Groupe_Nom && dCL_Ent.Client_Nom == dCL_Ent.Zone_Nom)
                wNom = "${dCL_Ent.Client_Nom}";
*/
              String wNom = "${dCL_Ent.DCL_Ent_ClientNom} ${dCL_Ent.DCL_Ent_InterventionId}";

              return Column(children: [
                new GestureDetector(
                    onTap: () async {
                      await HapticFeedback.vibrate();
                      Srv_DbTools.gDCL_Ent = dCL_Ent;

                      print("Selection");

                      await HapticFeedback.vibrate();
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => Client_Groupe_Inter_Det()));
                      Reload();
                    },
                    child: Container(
                      height: 57,
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
/*
                          !dCL_Ent.DCL_Ent_isUpdate
                              ? Expanded(
                                  flex: 10,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 25, bottom: 2),
                                    child: Text(
                                      "◉ --",
                                      maxLines: 1,
                                      style: gColors.bodyTitle1_B_R32,
                                    ),
                                  ))
                              :
*/


                          Expanded(
                                  flex: 5,
                                  child: Container(
                                      height: rowh,
                                      child: Text(
                                        "${dCL_Ent.DCL_EntID}",
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: gColors.bodySaisie_B_B,
                                      ))),

                          Expanded(
                              flex: 12,
                              child: Container(
                                height: rowh,
                                child: Text(
                                  "${dCL_Ent.DCL_Ent_Type}",
                                  maxLines: 1,
                                  style: gColors.bodySaisie_B_B,
                                ),
                              )),
                          Expanded(
                            flex: 12,
                            child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                              gColors.gCircle(wColor),
                              Container(
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  height: rowh,
                                  child: Text(
                                    "${dCL_Ent.DCL_Ent_Etat}",
                                    textAlign: TextAlign.right,
                                    style: gColors.bodySaisie_B_B,
                                  ))
                            ]),
                          ),
                          Expanded(
                              flex: 30,
                              child: Container(
                                height: rowh,
                                child: Text(
                                  "${wNom}",
                                  maxLines: 1,
                                  style: gColors.bodySaisie_B_B,
                                ),
                              )),
                          Expanded(
                              flex: 7,
                              child: Container(
                                  padding: EdgeInsets.only(left: 5),
                                  height: rowh,
                                  child: Text(
                                    "${dCL_Ent.DCL_Ent_Date}",
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: gColors.bodySaisie_B_B,
                                  ))),
                        ],
                      ),
                    )),
                gColors.wLigne(),
              ]);
            },
          ),
        ),
        SizedBox(height: 45.0),
      ],
    );
  }
}
