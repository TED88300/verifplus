import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_ImportExport.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Planning_Interventions.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter.dart';
import 'package:verifplus/Widget/Planning/Client_Groupe_Inter_Det.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

class Planning extends StatefulWidget {
  @override
  PlanningState createState() => PlanningState();
}

class PlanningState extends State<Planning> {
  double icoWidth = 38;
  bool affEdtFilter = false;
  TextEditingController ctrlFilter = new TextEditingController();
  String filterText = '';
  List<DateSection> sectionList = [];

  Future Reload() async {
    print(" Reload ");

    await Srv_ImportExport.ImportAll();
    sectionList = getDateSection();
    print("sectionList length ${sectionList.length}");
    Filtre();
  }

  void Filtre() {
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
    print("build sectionList ${sectionList.length}");

    return Scaffold(
      body: Column(
        children: [
          gObj.InterventionTitleWidget("LISTE DES INTERVENTIONS PROGRAMMÉES"),
          Entete_Btn_Search(),
          gColors.wLigne(),
          Expanded(
              child: ExpandableListView(
            builder: SliverExpandableChildDelegate<String, DateSection>(
              sectionList: sectionList,
              headerBuilder: _buildHeader,
              itemBuilder: (context, sectionIndex, itemIndex, index) {
                String item = sectionList[sectionIndex].items[itemIndex];
                String item2 = sectionList[sectionIndex].items2[itemIndex];
                String item3 = sectionList[sectionIndex].items3[itemIndex];
                Planning_Intervention wPlanning_Intervention = sectionList[sectionIndex].Planning_Interventions[itemIndex];
                double rowh = 18;

                return Column(children: [
                  new GestureDetector(
                      onTap: () async {
                        print("wPlanning_Intervention.Planning_Interv_InterventionId ${wPlanning_Intervention.Planning_Interv_InterventionId}");
                        await HapticFeedback.vibrate();
                        await DbTools.getClient(wPlanning_Intervention.Planning_Interv_ClientId!);
                        Srv_DbTools.ListGroupe = await DbTools.getGroupes(wPlanning_Intervention.Planning_Interv_ClientId!);
                        await Srv_DbTools.getGroupeID(wPlanning_Intervention.Planning_Interv_GroupeId!);
                        Srv_DbTools.ListSite = await DbTools.getSiteGroupe(Srv_DbTools.gGroupe.GroupeId);
                        await Srv_DbTools.getSiteID(wPlanning_Intervention.Planning_Interv_SiteId!);
                        Srv_DbTools.ListZone =  await DbTools.getZones(wPlanning_Intervention.Planning_Interv_SiteId!);
                        print("wPlanning_Intervention.Planning_Interv_InterventionId ${wPlanning_Intervention.Planning_Interv_InterventionId}");
                        await Srv_DbTools.getZoneID(wPlanning_Intervention.Planning_Interv_ZoneId!);
                        await DbTools.getInterventions(wPlanning_Intervention.Planning_Interv_ZoneId!);
                        await DbTools.getIntervention(wPlanning_Intervention.Planning_Interv_InterventionId!);

                        Srv_DbTools.gIntervention.Client_Nom = Srv_DbTools.gClient.Client_Nom;
                        Srv_DbTools.gIntervention.Site_Nom = Srv_DbTools.gSite.Site_Nom;
                        Srv_DbTools.gIntervention.Groupe_Nom = Srv_DbTools.gGroupe.Groupe_Nom;
                        Srv_DbTools.gIntervention.Zone_Nom = Srv_DbTools.gZone.Zone_Nom;


                        print(" •••••••••••  gIntervention ${Srv_DbTools.gIntervention.Desc()}");
                        await Navigator.push(context, MaterialPageRoute(builder: (context) => Client_Groupe_Inter_Det()));
                        Reload();

                      },
                      child:


                      Dismissible(
                      key: Key(item),
                      onDismissed: (direction) {
/*
                      setState(() {

                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$item dismissed')));
*/
                      },
                      child:

                      Container(
                        padding: EdgeInsets.only(left: 5, right: 5,top: 5),
                        height: 57,
                        color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                flex: 10,
                                child:
                                Container(
                                    height: 50,
                                  child:
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        padding: EdgeInsets.only(left: 5),
                                        height: rowh,
                                        child: Text(
                                          "${item}",
                                          maxLines: 1,
                                          textAlign: TextAlign.left,
                                          style: gColors.bodySaisie_B_B,
                                        )),
                                    Container(
                                        padding: EdgeInsets.only(left: 50),
                                        height: rowh,
                                        child: Text(
                                          "${item3}",
                                          maxLines: 1,
                                          textAlign: TextAlign.left,
                                          style: gColors.bodySaisie_B_B,
                                        )),
                                  ],
                                )),

                  ),

                            Expanded(
                                flex: 2,
                                child: Container(
                                    padding: EdgeInsets.only(right: 5),
                                    height: rowh,
                                    child: Text(
                                      "${item2} >",
                                      textAlign: TextAlign.right,
                                      style: gColors.bodySaisie_B_B.copyWith(color: gColors.primaryOrange),
                                    ))),
                          ],
                        ),
                      ))),
                  gColors.wLigne(),
                ]);
              },
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int sectionIndex, int index) {
    DateSection section = sectionList[sectionIndex];
    return InkWell(
        child: AffHeader("${section.header}", "", gColors.greyLight, "Icon_Planning"),
        onTap: () {
          //toggle section expand state
          setState(() {
            section.setSectionExpanded(!section.isSectionExpanded());
          });
        });
  }

  Widget AffHeader(String wTextL, String wTextR, Color BckGrd, String ImgL) {
    double icoWidth = 32;

    return Container(
        height: 57,

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
                Expanded(
                    child: Container(
                        padding: EdgeInsets.only(right: 10, top: 20),
                        height: 55,

                        child: Text(
                          "${wTextL}",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: gColors.bodyTitle1_B_Gr.copyWith(color: gColors.primaryOrange),
                        ))),
              ],
            ),
            gColors.wLigne(),
          ],
        ));
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



  static List<DateSection> getDateSection([int sectionSize = 10, int itemSize = 5]) {
    initializeDateFormatting('fr', null);
    var sections = List<DateSection>.empty(growable: true);

    print("ListPlanning_Intervention length ${Srv_DbTools.ListPlanning_Intervention.length}");
    String Rupt = "";
    var section = DateSection();
    for (int i = 0; i < Srv_DbTools.ListPlanning_Intervention.length; i++) {
      Planning_Intervention wPlanning_Intervention = Srv_DbTools.ListPlanning_Intervention[i];

      String formattedDate = DateFormat('dd/MMM/yyyy').format(wPlanning_Intervention.Planning_Interv_InterventionstartTime);
      String formattedDateLib = DateFormat('EEEE dd/MM/yy', 'fr').format(wPlanning_Intervention.Planning_Interv_InterventionstartTime);

      String formattedDeb = DateFormat('hh:mm').format(wPlanning_Intervention.Planning_Interv_InterventionstartTime);
      String formattedFin = DateFormat('hh:mm').format(wPlanning_Intervention.Planning_Interv_InterventionendTime);

      if (Rupt != formattedDate) {
        if (Rupt == "") {
        } else {
          sections.add(section);
        }
        section = DateSection();
        section..header = "${formattedDateLib}";
        section..expanded = true;
        section..items = [];
        section..items2 = [];
        section..items3 = [];
        section..Planning_Interventions = [];
        Rupt = formattedDate;
        print("Header ${formattedDate}");
      }
      section..Planning_Interventions.add(wPlanning_Intervention);
      String wLib = "[${wPlanning_Intervention.Planning_Interv_InterventionId}] ${wPlanning_Intervention.Planning_Interv_Client_Nom} / ${wPlanning_Intervention.Planning_Interv_Site_Nom}";
      print("wLib ${wLib}");
      section..items.add(wLib);

      String wLib3 = "${wPlanning_Intervention.Planning_Interv_Intervention_Parcs_Type} - ${wPlanning_Intervention.Planning_Interv_Intervention_Type} - ${wPlanning_Intervention.Planning_Interv_Intervention_Status}";
      print("wLib3 ${wLib3}");
      section..items3.add(wLib3);



      String wLibH = "${formattedDeb}/${formattedFin}";
      print("wLibH ${wLibH}");
      section..items2.add(wLibH);
    }
    sections.add(section);

    return sections;
  }

}

class DateSection implements ExpandableListSection<String> {
  late bool expanded;
  late List<String> items;
  late List<String> items2;
  late List<String> items3;
  late List<Planning_Intervention> Planning_Interventions;



  late String header;

  @override
  List<String> getItems() {
    return items;
  }

  @override
  bool isSectionExpanded() {
    return expanded;
  }

  @override
  void setSectionExpanded(bool expanded) {
    this.expanded = expanded;
  }
}
