import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Planning_Interventions.dart';
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
    await Srv_DbTools.getPlanning_InterventionRes(Srv_DbTools.gUserLogin.UserID);

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
                Planning_Intervention wPlanning_Intervention = sectionList[sectionIndex].Planning_Interventions[itemIndex];
                double rowh = 24;

                return Column(children: [
                  new GestureDetector(
                      onTap: () async {
                        await HapticFeedback.vibrate();
                        await Srv_DbTools.getClient(wPlanning_Intervention.Planning_Interv_ClientId!);
                        await Srv_DbTools.getGroupesClient(wPlanning_Intervention.Planning_Interv_ClientId!);
                        await Srv_DbTools.getGroupeID(wPlanning_Intervention.Planning_Interv_GroupeId!);
                        await Srv_DbTools.getGroupeSites(wPlanning_Intervention.Planning_Interv_ClientId!);
                        await Srv_DbTools.getSiteID(wPlanning_Intervention.Planning_Interv_SiteId!);
                        await Srv_DbTools.getZones(wPlanning_Intervention.Planning_Interv_SiteId!);
                        await Srv_DbTools.getZoneID(wPlanning_Intervention.Planning_Interv_ZoneId!);
                        await Srv_DbTools.getInterventionsID_Srv(wPlanning_Intervention.Planning_Interv_InterventionId!);

//                        await Navigator.push(context, MaterialPageRoute(builder: (context) => Client_Groupe_Parc_Inter()));
                        await Navigator.push(context, MaterialPageRoute(builder: (context) => Client_Groupe_Inter_Det()));
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 5, right: 5,top: 5),

                        height: 57,
                        color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                flex: 10,
                                child: Container(
                                    padding: EdgeInsets.only(left: 5),
                                    height: rowh,
                                    child: Text(
                                      "${item}",
                                      maxLines: 1,
                                      textAlign: TextAlign.left,
                                      style: gColors.bodySaisie_B_B,
                                    ))),

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
                      )),
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
        section..Planning_Interventions = [];
        Rupt = formattedDate;
        print("Header ${formattedDate}");
      }


      section..Planning_Interventions.add(wPlanning_Intervention);
      String wLib = "[${wPlanning_Intervention.Planning_Interv_InterventionId}] ${wPlanning_Intervention.Planning_Interv_Client_Nom} / ${wPlanning_Intervention.Planning_Interv_Groupe_Nom} / ${wPlanning_Intervention.Planning_Interv_Site_Nom} / ${wPlanning_Intervention.Planning_Interv_Zone_Nom}";
      print("wLib ${wLib}");
      section..items.add(wLib);
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
