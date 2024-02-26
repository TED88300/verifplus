import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Interventions.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Param.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/Client/Client_Dialog.dart';
import 'package:verifplus/Widget/Client/Client_Intervention_Type_Dialog.dart';
import 'package:verifplus/Widget/Client/Client_Interventions_Add.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

class Client_Interventions extends StatefulWidget {
  @override
  Client_InterventionsState createState() => Client_InterventionsState();
}

class Client_InterventionsState extends State<Client_Interventions> with SingleTickerProviderStateMixin {
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



    await Srv_DbTools.getInterventionsZone(Srv_DbTools.gZone.ZoneId);
    List<String> lIntervention = [];

    for (int i = 0; i < Srv_DbTools.ListIntervention.length; i++) {
      Intervention wIntervention = Srv_DbTools.ListIntervention[i];
      if (lIntervention.indexOf(wIntervention.Intervention_Parcs_Type!) == -1) {
        lIntervention.add(wIntervention.Intervention_Parcs_Type!);
      }
    }
    PastilleType = lIntervention.length;

    if (lIntervention.length == 0) {
      Srv_DbTools.gSelIntervention = Srv_DbTools.gSelInterventionBase;
    } else {
      int index = lIntervention.indexWhere((element) => element.compareTo(Srv_DbTools.gSelIntervention) == 0);
      if (index < 0) {
        Srv_DbTools.gSelIntervention = Srv_DbTools.gSelInterventionBase;
      }
    }
    Filtre();
  }

  void Filtre() {
    isAll = true;
    List<Intervention> wListIntervention = [];
    Srv_DbTools.ListInterventionsearchresult.clear();
    print("Srv_DbTools.ListIntervention ${Srv_DbTools.ListIntervention.length}");

    if (Srv_DbTools.gSelIntervention.compareTo(Srv_DbTools.gSelInterventionBase) == 0) {
      wListIntervention.addAll(Srv_DbTools.ListIntervention);
    } else {
      isAll = false;
      Srv_DbTools.ListIntervention.forEach((element) async {
        if (element.Intervention_Parcs_Type!.compareTo(Srv_DbTools.gSelIntervention) == 0) {
          wListIntervention.add(element);
        }
      });
    }

    print("wListIntervention ${wListIntervention.length}");

    if (filterText.isEmpty) {
      Srv_DbTools.ListInterventionsearchresult.addAll(wListIntervention);
    } else
      wListIntervention.forEach((element) async {
        {
          String Intervention_Type = element.Intervention_Type == null ? "" : element.Intervention_Type!;
          String Intervention_Parcs_Type = element.Intervention_Parcs_Type == null ? "" : element.Intervention_Parcs_Type!;
          String Intervention_Status = element.Intervention_Status == null ? "" : element.Intervention_Status!;

          String id = element.InterventionId.toString();
          if (Intervention_Type.toUpperCase().contains(filterText.toUpperCase()))
            Srv_DbTools.ListInterventionsearchresult.add(element);
          else if (Intervention_Parcs_Type.toUpperCase().contains(filterText.toUpperCase()))
            Srv_DbTools.ListInterventionsearchresult.add(element);
          else if (Intervention_Status.toUpperCase().contains(filterText.toUpperCase()))
            Srv_DbTools.ListInterventionsearchresult.add(element);
          else if (id.toUpperCase().contains(filterText.toUpperCase())) Srv_DbTools.ListInterventionsearchresult.add(element);
        }
      });

    print("Srv_DbTools.ListInterventionsearchresult ${Srv_DbTools.ListInterventionsearchresult.length}");

    print("FILTRE INTERVENTIONS FIN ${Srv_DbTools.ListIntervention.length} ${Srv_DbTools.ListInterventionsearchresult.length}");
    setState(() {});
  }

  @override
  void initLib() async {
    Srv_DbTools.gSelIntervention = "Ext";
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
                await Client_Intervention_Type_Dialog.Dialogs_Intervention_Type(context);
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

    Param_Param wParam_Param = Srv_DbTools.getParam_Param_in_Mem("Type_Organe", Srv_DbTools.gSelIntervention);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      //    endDrawer: DbTools.gIsMedecinLogin! ? C_SideDrawer() : I_SideDrawer(),

      backgroundColor: Colors.white,
      appBar: AppBar(
        title: InkWell(
          onTap: () async {
            await HapticFeedback.vibrate();
            await Client_Dialog.Dialogs_Client(context);
          },
          child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
            AutoSizeText(
              "INTERVENTIONS",
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
      ),
      body: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            children: [
              gObj.InterventionTitleWidgetCalc(context, "${Srv_DbTools.gClient.Client_Nom.toUpperCase()}", wTitre2: "${Srv_DbTools.gGroupe.Groupe_Nom}", wTitre3:"${Srv_DbTools.gSite.Site_Nom}", wTitre4:"${Srv_DbTools.gZone.Zone_Nom}"),
              Entete_Btn_Search(),
              Expanded(
                child: InterventionGridWidget(),
              ),
            ],
          )),
      floatingActionButton: !affAll
          ? Container()
          : new FloatingActionButton(
              elevation: 0.0,
              child: new Icon(Icons.add),
              backgroundColor: gColors.secondary,
              onPressed: () async {
                await Client_Interventions_Add.Dialogs_Add(context, true);

                Reload();
              }),
    );
  }

  //***************************
  //***************************
  //***************************

  Widget InterventionGridWidget() {
    return Column(
      children: <Widget>[
        gColors.wLigne(),
        Container(
          height: 57.0,
          color: gColors.greyLight,
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 10,
                  child: Container(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        "ID",
                        textAlign: TextAlign.center,
                        style: gColors.bodySaisie_B_B,
                      ))),
              Expanded(
                  flex: 25,
                  child: Container(
                      child: Text(
                    "Type",
                    textAlign: TextAlign.center,
                    style: gColors.bodySaisie_B_B,
                  ))),
              Expanded(
                  flex: 10,
                  child: Container(
                      child: Text(
                    "Date",
                    textAlign: TextAlign.center,
                    style: gColors.bodySaisie_B_B,
                  ))),
              Expanded(
                  flex: 10,
                  child: Container(
                      child: Text(
                    "Signature",
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
            ],
          ),
        ),
        gColors.wLigne(),
        SizedBox(height: 5.0),
        Expanded(
          child: ListView.builder(
            itemCount: Srv_DbTools.ListInterventionsearchresult.length,
            itemBuilder: (BuildContext context, int index) {
              Intervention intervention = Srv_DbTools.ListInterventionsearchresult[index];
              double rowh = 24;

              return Column(children: [
                new GestureDetector(
                    onTap: () async {
                      await HapticFeedback.vibrate();
                      Srv_DbTools.gIntervention = intervention;
                      await HapticFeedback.vibrate();
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => Client_Groupe_Parc_Inter()));
                      Reload();
                    },
                    child: Container(
                      height: 57,
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 10,
                              child: Container(
                                  height: rowh,
                                  child: Text(
                                    "${intervention.InterventionId}",
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: gColors.bodySaisie_B_B,
                                  ))),
                          Expanded(
                              flex: 25,
                              child: Container(
                                height: rowh,
                                child: Text(
                                  "${intervention.Intervention_Type} / ${intervention.Intervention_Parcs_Type}",
                                  maxLines: 1,
                                  style: gColors.bodySaisie_B_B,
                                ),
                              )),
                          Expanded(
                              flex: 10,
                              child: Container(
                                  padding: EdgeInsets.only(left: 5),
                                  height: rowh,
                                  child: Text(
                                    "${intervention.Intervention_Date}",
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: gColors.bodySaisie_B_B,
                                  ))),
                          Expanded(
                              flex: 10,
                              child: Container(
                                  padding: EdgeInsets.only(left: 5),
                                  height: rowh,
                                  child: Text(
                                    "14/09/23",
                                    textAlign: TextAlign.center,
                                    style: gColors.bodySaisie_B_B,
                                  ))),
                          Expanded(
                              flex: 10,
                              child: Container(
                                  padding: EdgeInsets.only(right: 5),
                                  height: rowh,
                                  child: Text(
                                    "${intervention.Intervention_Status!}> ",
                                    textAlign: TextAlign.right,
                                    style: gColors.bodySaisie_B_B.copyWith(color: Colors.orange),
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
