import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DCL_Ent.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_ImportExport.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Param.dart';
import 'package:verifplus/Widget/Client/Client_DCL_Ent_Type_Dialog.dart';
import 'package:verifplus/Widget/GestCo/DCL_Ent_Param.dart';
import 'package:verifplus/Widget/GestCo/Select_DCL_Ents_Add.dart';
import 'package:verifplus/Widget/Planning/Client_Groupe_Inter_Det.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gDialogs.dart';

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

  bool btnSel_Aff = false;

  bool bSortDate = false;


  void Reload() async {
    await Srv_ImportExport.getErrorSync();
    bool wRes = await Srv_DbTools.getDCL_EntAll();

    List<String> lDCL_Ent = [];
    for (int i = 0; i < Srv_DbTools.ListDCL_Ent.length; i++) {
      DCL_Ent wDCL_Ent = Srv_DbTools.ListDCL_Ent[i];
      wDCL_Ent.DCL_Ent_ClientNom = "";

      if (await Srv_DbTools.getClient(wDCL_Ent.DCL_Ent_ClientId!)) {
        wDCL_Ent.DCL_Ent_ClientNom = Srv_DbTools.gClient.Client_Nom;
        wDCL_Ent.DCL_Ent_CCGSZ = "${wDCL_Ent.DCL_Ent_Num} / ${wDCL_Ent.DCL_Ent_ClientNom}";
        wDCL_Ent.DCL_Ent_Adr1 = "Adr Client";
        wDCL_Ent.DCL_Ent_Adr2 = "${Srv_DbTools.gClient.Adresse_Adr1}  ${Srv_DbTools.gClient.Adresse_CP} ${Srv_DbTools.gClient.Adresse_Ville}";
      }

      if (wDCL_Ent.DCL_Ent_GroupeId! >= 0) {
        await Srv_DbTools.getGroupeID(wDCL_Ent.DCL_Ent_GroupeId!);
        wDCL_Ent.DCL_Ent_GroupeNom = Srv_DbTools.gGroupe.Groupe_Nom;
        wDCL_Ent.DCL_Ent_CCGSZ = "${wDCL_Ent.DCL_Ent_Num} / ${wDCL_Ent.DCL_Ent_ClientNom} / ${wDCL_Ent.DCL_Ent_GroupeNom}";
        wDCL_Ent.DCL_Ent_Adr1 = "Adr Groupe";
        wDCL_Ent.DCL_Ent_Adr2 = "${Srv_DbTools.gGroupe.Groupe_Adr1} ${Srv_DbTools.gGroupe.Groupe_Adr2} ${Srv_DbTools.gGroupe.Groupe_CP} ${Srv_DbTools.gGroupe.Groupe_Ville}";
      }

      if (wDCL_Ent.DCL_Ent_SiteId! >= 0) {
        await Srv_DbTools.getSiteID(wDCL_Ent.DCL_Ent_SiteId!);
        wDCL_Ent.DCL_Ent_SiteNom = Srv_DbTools.gSite.Site_Nom;
        wDCL_Ent.DCL_Ent_CCGSZ = "${wDCL_Ent.DCL_Ent_Num} / ${wDCL_Ent.DCL_Ent_ClientNom} / ${wDCL_Ent.DCL_Ent_GroupeNom} / ${wDCL_Ent.DCL_Ent_SiteNom}";
        wDCL_Ent.DCL_Ent_Adr1 = "Adr Site";
        wDCL_Ent.DCL_Ent_Adr2 = "${Srv_DbTools.gSite.Site_Adr1} ${Srv_DbTools.gSite.Site_Adr2} ${Srv_DbTools.gSite.Site_CP} ${Srv_DbTools.gSite.Site_Ville}";
      }

      if (wDCL_Ent.DCL_Ent_ZoneId! >= 0) {
        await Srv_DbTools.getZoneID(wDCL_Ent.DCL_Ent_ZoneId!);
        wDCL_Ent.DCL_Ent_ZoneNom = Srv_DbTools.gZone.Zone_Nom;
        wDCL_Ent.DCL_Ent_CCGSZ = "${wDCL_Ent.DCL_Ent_Num} / ${wDCL_Ent.DCL_Ent_ClientNom} / ${wDCL_Ent.DCL_Ent_GroupeNom} / ${wDCL_Ent.DCL_Ent_SiteNom} / ${wDCL_Ent.DCL_Ent_ZoneNom}";
        wDCL_Ent.DCL_Ent_Adr1 = "Adr Zone";
        wDCL_Ent.DCL_Ent_Adr2 = "${Srv_DbTools.gZone.Zone_Adr1} ${Srv_DbTools.gZone.Zone_Adr2} ${Srv_DbTools.gZone.Zone_CP} ${Srv_DbTools.gZone.Zone_Ville}";
      }

      if (lDCL_Ent.indexOf(wDCL_Ent.DCL_Ent_Type!) == -1) {
        lDCL_Ent.add(wDCL_Ent.DCL_Ent_Type!);
      }

      print("wDCL_Ent.DCL_Ent_CCGSZ ${wDCL_Ent.DCL_Ent_CCGSZ}");
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

    String wFilterText = filterText.trim().toUpperCase();
    if (wFilterText.isEmpty) {
      Srv_DbTools.ListDCL_Entsearchresult.addAll(wListDCL_Ent);
    } else
      wListDCL_Ent.forEach((element) async {
        {
          String DCL_Ent_Type = element.DCL_Ent_Type == null ? "" : element.DCL_Ent_Type!;
          String DCL_Ent_Etat = element.DCL_Ent_Etat == null ? "" : element.DCL_Ent_Etat!;
          String id = element.DCL_EntID.toString();

          if (DCL_Ent_Type.toUpperCase().contains(wFilterText))
            Srv_DbTools.ListDCL_Entsearchresult.add(element);
          else if (DCL_Ent_Etat.toUpperCase().contains(wFilterText))
            Srv_DbTools.ListDCL_Entsearchresult.add(element);
          else if (id.toUpperCase().contains(wFilterText))
            Srv_DbTools.ListDCL_Entsearchresult.add(element);
          else if (element.Desc().toUpperCase().contains(wFilterText)) Srv_DbTools.ListDCL_Entsearchresult.add(element);
        }
      });


    if (bSortDate)
      {
        Srv_DbTools.ListDCL_Entsearchresult.sort(Srv_DbTools.idSortComparison);
      }
    else
      {
        Srv_DbTools.ListDCL_Entsearchresult.sort(Srv_DbTools.affSortComparisonData_DCL);
      }

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
        width: MediaQuery.of(context).size.width,
        color: gColors.LinearGradient3,
        child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            width: 8,
          ),
          Expanded(
              child: Container(
                  child: Text(
            "${Srv_DbTools.gDCL_Ent.DCL_Ent_CCGSZ}",
            maxLines: 1,
            textAlign: TextAlign.left,
            style: gColors.bodySaisie_B_B,
          ))),
          Container(
            width: 8,
          ),
          EdtFilterWidget(),
        ]));
  }

  @override
  Widget Entete_Tot_Search() {
    return Container(
        height: 57,
        child: Row(
          children: [
            Container(
              width: 8,
            ),
            InkWell(
                child: Container(
                  width: icoWidth + 10,
                  child: Stack(children: <Widget>[
                    Image.asset(
                      "assets/images/DCL_Total.png",
                      height: icoWidth,
                      width: icoWidth,
                    ),
                  ]),
                ),
                onTap: () async {
                  await HapticFeedback.vibrate();
                  Filtre();
                }),
            Container(
                child: Text(
              "(${Srv_DbTools.ListDCL_Entsearchresult.length})",
              maxLines: 1,
              textAlign: TextAlign.left,
              style: gColors.bodySaisie_B_B,
            ))
          ],
        ));
  }

  @override
  Widget Entete_Ico_Search() {
    return Container(
        height: 57,
        color: gColors.LinearGradient3,
        child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            width: 16,
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
          InkWell(
              child: Container(
                width: icoWidth + 10,
                child: Stack(children: <Widget>[
                  Image.asset(
                    btnSel_Aff ? "assets/images/DCL_AffSel.png" : "assets/images/DCL_Aff.png",
                    height: icoWidth,
                    width: icoWidth,
                  ),
                ]),
              ),
              onTap: () async {
                await HapticFeedback.vibrate();
                btnSel_Aff = !btnSel_Aff;
                Filtre();
              }),
          InkWell(
              child: Container(
                width: icoWidth + 10,
                child: Stack(children: <Widget>[
                  Image.asset(
                    "assets/images/DCL_Date.png",
                    height: icoWidth,
                    width: icoWidth,
                  ),
                ]),
              ),
              onLongPress: () async {
                await HapticFeedback.vibrate();
                bSortDate = !bSortDate;
                Filtre();
              },
              onTap: () async {
                await HapticFeedback.vibrate();
                await gDialogs.Dialog_CdeDate(context);
                Filtre();
              }),
          Container(
            width: 32,
          ),
          InkWell(
              child: Container(
                width: icoWidth + 10,
                child: Stack(children: <Widget>[
                  Image.asset(
                    "assets/images/DCL_Impr.png",
                    height: icoWidth,
                    width: icoWidth,
                  ),
                ]),
              ),
              onTap: () async {
                await HapticFeedback.vibrate();
                Filtre();
              }),
          InkWell(
              child: Container(
                width: icoWidth + 10,
                child: Stack(children: <Widget>[
                  Image.asset(
                    "assets/images/DCL_Transf.png",
                    height: icoWidth,
                    width: icoWidth,
                  ),
                ]),
              ),
              onTap: () async {
                await HapticFeedback.vibrate();
                Filtre();
              }),
          Spacer(),
          Container(
              child: Text(
            "Total Net HT",
            maxLines: 1,
            textAlign: TextAlign.left,
            style: gColors.bodySaisie_B_B,
          )),
          Container(
            width: 8,
          ),
        ]));
  }

  double icoWidth = 40;

  Widget EdtFilterWidget() {
    return Container(
        child: !affEdtFilter
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
                )));
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
              gColors.wLigne(),
              Entete_Tot_Search(),
              gColors.wLigne(),
              Entete_Ico_Search(),
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
                    await Select_DCL_Ents_Add.Dialogs_Add(context, true);
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
        gColors.wLigne(),
        gColors.wLigne(),
        SizedBox(height: 5.0),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            itemCount: Srv_DbTools.ListDCL_Entsearchresult.length,
            itemBuilder: (BuildContext context, int index) {
              DCL_Ent dCL_Ent = Srv_DbTools.ListDCL_Entsearchresult[index];
              Color wColor = Colors.transparent;
              Color wColorBack = Colors.transparent;
              Color wColorText = Colors.black;

              if (Srv_DbTools.gDCL_Ent == dCL_Ent) {
                wColorBack = gColors.backgroundColor;
                wColorText = Colors.white;
              }

              if (dCL_Ent.DCL_Ent_Type == "Devis") {
                wColor = gColors.getColorEtatDevis(dCL_Ent.DCL_Ent_Etat!);
              }
              if (dCL_Ent.DCL_Ent_Type == "Commande") {
                wColor = gColors.getColorEtatCde(dCL_Ent.DCL_Ent_Etat!);
              }
              if (dCL_Ent.DCL_Ent_Type == "Bon de livraison") {
                wColor = gColors.getColorEtatLivr(dCL_Ent.DCL_Ent_Etat!);
              }

              double rowh = 24;
              String wNomClient = "${dCL_Ent.DCL_Ent_ClientNom}";
              double wH = !btnSel_Aff ? 57 : 85;
              return Container(
                height: wH,
                width: 800,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      color: wColorBack,
                      child: GestureDetector(
                        onTap: () async {
                          await HapticFeedback.vibrate();
                          Srv_DbTools.gDCL_Ent = dCL_Ent;
                          if (dCL_Ent.DCL_Ent_InterventionId! >= 0)
                          {
                            Srv_DbTools.gIntervention.Client_Nom = Srv_DbTools.gClient.Client_Nom;
                            Srv_DbTools.gIntervention.Site_Nom = Srv_DbTools.gSite.Site_Nom;
                            Srv_DbTools.gIntervention.Groupe_Nom = Srv_DbTools.gGroupe.Groupe_Nom;
                            Srv_DbTools.gIntervention.Zone_Nom = Srv_DbTools.gZone.Zone_Nom;
                            print(" Selection Intervention DCL_Ent_InterventionId ${dCL_Ent.DCL_Ent_InterventionId!} ${Srv_DbTools.gIntervention.Desc()}");
                            await HapticFeedback.vibrate();
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => Client_Groupe_Inter_Det()));
                            Reload();
                          }
                          else
                          {
                            print("Selection Param");
                            await HapticFeedback.vibrate();
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => DCL_Ent_Param()));
                            Reload();
                          }

                        },
                        child: Column(children: [
                          (!btnSel_Aff)
                              ? Container(
                                  height: 56,
                                  padding: EdgeInsets.only(
                                    top: 10,
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 8,
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                          gColors.gCircle(wColor),
                                          InkWell(
                                              child: Container(
                                                  padding: EdgeInsets.only(
                                                    left: 5,
                                                  ),
                                                  height: rowh,
                                                  child: Text(
                                                    "${dCL_Ent.DCL_Ent_Num}",
                                                    textAlign: TextAlign.right,
                                                    style: gColors.bodySaisie_B_B.copyWith(color: wColorText),
                                                  )),
                                              onTap: () async {
                                                print("Selection");
                                                Srv_DbTools.gDCL_Ent = dCL_Ent;

                                                setState(() {});
                                              }),
                                        ]),
                                      ),
                                      Expanded(
                                          flex: 6,
                                          child: Container(
                                              padding: EdgeInsets.only(left: 5),
                                              height: rowh,
                                              child: Text(
                                                "${dCL_Ent.DCL_Ent_Date}",
                                                maxLines: 1,
                                                textAlign: TextAlign.left,
                                                style: gColors.bodySaisie_B_B.copyWith(color: wColorText),
                                              ))),
                                      Expanded(
                                        flex: 30,
                                        child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                          Container(
                                              padding: EdgeInsets.only(left: 5, right: 5),
                                              height: rowh,
                                              child: Text(
                                                "${dCL_Ent.DCL_Ent_InterventionId! > 0 ? "(${dCL_Ent.DCL_Ent_InterventionId}) " : ""}${wNomClient}",
                                                textAlign: TextAlign.right,
                                                style: gColors.bodySaisie_B_B.copyWith(color: wColorText),
                                              ))
                                        ]),
                                      )
                                    ],
                                  ),
                                )
                              : Column(
                                  children: [
                                    Container(
                                      height: 40,
                                      padding: EdgeInsets.only(
                                        top: 10,
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: 8,
                                          ),
                                          Expanded(
                                            flex: 6,
                                            child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                              gColors.gCircle(wColor),
                                              InkWell(
                                                  child: Container(
                                                      padding: EdgeInsets.only(
                                                        left: 5,
                                                      ),
                                                      height: rowh,
                                                      child: Text(
                                                        "${dCL_Ent.DCL_Ent_Num}",
                                                        textAlign: TextAlign.right,
                                                        style: gColors.bodySaisie_B_B.copyWith(color: wColorText),
                                                      )),
                                                  onTap: () async {
                                                    print("Selection");
                                                    Srv_DbTools.gDCL_Ent = dCL_Ent;

                                                    setState(() {});
                                                  }),
                                            ]),
                                          ),
                                          Expanded(
                                              flex: 6,
                                              child: Container(
                                                  padding: EdgeInsets.only(left: 5),
                                                  height: rowh,
                                                  child: Text(
                                                    "${dCL_Ent.DCL_Ent_Date}",
                                                    maxLines: 1,
                                                    textAlign: TextAlign.left,
                                                    style: gColors.bodySaisie_B_B.copyWith(color: wColorText),
                                                  ))),
                                          Expanded(
                                            flex: 30,
                                            child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                              Container(
                                                  padding: EdgeInsets.only(left: 5, right: 5),
                                                  height: rowh,
                                                  child: Text(
                                                    "${dCL_Ent.DCL_Ent_InterventionId! > 0 ? "(${dCL_Ent.DCL_Ent_InterventionId}) " : ""}${wNomClient}",
                                                    textAlign: TextAlign.right,
                                                    style: gColors.bodySaisie_B_B.copyWith(color: wColorText),
                                                  ))
                                            ]),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 22,
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: 8,
                                          ),
                                          Container(
                                              padding: EdgeInsets.only(left: 5),
                                              height: 22,
                                              child: Text(
                                                "${dCL_Ent.DCL_Ent_Adr1}",
                                                maxLines: 1,
                                                textAlign: TextAlign.left,
                                                style: gColors.bodySaisie_B_B.copyWith(color: wColorText),
                                              )),
                                          Container(
                                              padding: EdgeInsets.only(left: 5),
                                              height: 22,
                                              child: Text(
                                                "${dCL_Ent.DCL_Ent_Adr2}",
                                                maxLines: 1,
                                                textAlign: TextAlign.left,
                                                style: gColors.bodySaisie_N_B.copyWith(color: wColorText),
                                              )),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 22,
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: 8,
                                          ),
                                          Container(
                                              padding: EdgeInsets.only(left: 5),
                                              height: 22,
                                              child: Text(
                                                "Intervention ",
                                                maxLines: 1,
                                                textAlign: TextAlign.left,
                                                style: gColors.bodySaisie_B_B.copyWith(color: wColorText),
                                              )),
                                          (dCL_Ent.DCL_Ent_InterventionId! > 0)
                                              ? Container(
                                                  padding: EdgeInsets.only(left: 5),
                                                  height: 22,
                                                  child: Text(
                                                    "${dCL_Ent.DCL_Ent_InterventionId}".padLeft(5, "0"),
                                                    maxLines: 1,
                                                    textAlign: TextAlign.left,
                                                    style: gColors.bodySaisie_N_B.copyWith(color: wColorText),
                                                  ))
                                              : Container(
                                                  padding: EdgeInsets.only(left: 5),
                                                  height: 22,
                                                  child: Text(
                                                    "".padLeft(5, "0"),
                                                    maxLines: 1,
                                                    textAlign: TextAlign.left,
                                                    style: gColors.bodySaisie_N_B.copyWith(color: wColorText),
                                                  )),
                                          Container(
                                              padding: EdgeInsets.only(left: 5),
                                              height: 22,
                                              child: Text(
                                                "Aff ",
                                                maxLines: 1,
                                                textAlign: TextAlign.left,
                                                style: gColors.bodySaisie_B_B.copyWith(color: wColorText),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                          gColors.wLigne(),
                        ]),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        height: wH,
                        width: 110,
                        child: InkWell(
                            child: Container(),
                            onTap: () async {
                              print("Selection");
                              Srv_DbTools.gDCL_Ent = dCL_Ent;

                              setState(() {});
                            }),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 45.0),
      ],
    );
  }
}
