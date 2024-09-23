import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_button/group_button.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_ImportExport.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Planning_Interventions.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/Planning/Client_Groupe_Inter_Det.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

class Planning extends StatefulWidget {
  @override
  PlanningState createState() => PlanningState();
}

class PlanningState extends State<Planning> {
  final controllerWeeks = GroupButtonController();

  int selWeek = 5;
  List<String> buttonsWeeks = [];
  List<DateTime> buttonsWeeksDeb = [];
  List<DateTime> buttonsWeeksFin = [];

  ScrollController scrollController = ScrollController();

  double icoWidth = 38;
  bool affEdtFilter = false;
  TextEditingController ctrlFilter = new TextEditingController();
  String filterText = '';
  List<DateSection> sectionList = [];

  CarouselController buttonCarouselController = CarouselController();
  //*****************************************
  //*****************************************
  //*****************************************

  void getSurroundingWeeks(int NbWeek) {
    DateTime now = DateTime.now();
    var nowBase = DateTime(now.year, now.month, now.day);
    DateTime nowStart = nowBase.add(Duration(days: nowBase.weekday * -1 + 1));
    DateFormat formatter = DateFormat('dd MMM', 'fr');
    int j = 0;
    for (int i = -NbWeek; i <= NbWeek; i++) {
      DateTime weekStart = nowStart.add(Duration(days: i * 7));
      DateTime weekEnd = weekStart.add(Duration(days: 6));
      buttonsWeeks.add('${formatter.format(weekStart)} - ${formatter.format(weekEnd)}');

      DateTime weekEnd1 = weekStart.add(Duration(days: 7));
      if (nowBase.isAfter(weekStart) && nowBase.isBefore(weekEnd1)) {
        selWeek = j;
      }

      buttonsWeeksDeb.add(weekStart);
      buttonsWeeksFin.add(weekEnd);
      j++;
    }
  }

  @override
  Widget Entete_Btn_weeks() {
    print(" Entete_Btn_weeks ${selWeek}");

    return Container(
        height: 57,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
            child: Container(
                width: 320,
                height: 30,
                child: CarouselSlider(
                  carouselController: buttonCarouselController,
                  options: CarouselOptions(
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                    onPageChanged: (index, reason) {
                      setState(() {
                        selWeek = index;
                        sectionList = getDateSection(ctrlFilter.text);
                      });
                    },
                    initialPage: selWeek,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.3,
                    viewportFraction: 0.3,
                    height: 30.0,
                  ),
                  items: buttonsWeeks.map((w) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(color: Colors.white),
                            child: InkWell(
                                child: Container(
                                  padding: EdgeInsets.only(top: 5),
                                  width: 60,
                                  child: Text(
                                    '$w',
                                    textAlign: TextAlign.center,
                                    style: gColors.bodySaisie_B_B,
                                  ),
                                ),
                                onTap: () {
                                  // buttonCarouselController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.linear);
                                }));
                      },
                    );
                  }).toList(),
                )),
          )
        ]));
  }

  //*****************************************
  //*****************************************
  //*****************************************

  void _scrollToMiddle() {
    double listHeight = scrollController.position.maxScrollExtent;
    double middlePosition = listHeight / 2;

    scrollController.animateTo(
      middlePosition,
      duration: Duration(seconds: 2),
      curve: Curves.easeInOut,
    );
  }

  Future Reload() async {
    print("•••••••••••••••••• Reload");
    print("•••••••••••••••••• Reload");
    print("•••••••••••••••••• Reload");
    print("•••••••••••••••••• Reload");

    buttonsWeeks = [];
    print("••••••••••••••••• controllerWeeks.selectIndex");
    controllerWeeks.selectIndex(5);
    getSurroundingWeeks(5);
    await Srv_ImportExport.ImportAll();
    print("••••••••••••••••• Srv_DbTools.ListPlanning_Intervention.length ${Srv_DbTools.ListPlanning_Intervention.length}");
    Srv_DbTools.ListPlanning_Intervention.sort(Srv_DbTools.affSortComparisonData_Planning_Intervention);
    Filtre();
  }

  void Filtre() {
    sectionList = getDateSection(ctrlFilter.text);
    setState(() {});
  }

  @override
  void initLib() async {
    Reload();
  }

  void wScroll() {
    print("••••••••••••••••• wScroll");

/*
    double listViewWidth = scrollController.position.maxScrollExtent;
    int wCpt = buttonsWeeks.length;
    double celWidth = listViewWidth / (wCpt - 1);
    scrollController.jumpTo(celWidth * controllerWeeks.selectedIndex!);
*/
    setState(() {});
  }

  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      wScroll();
    });

    initLib();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("build sectionList ${sectionList.length} ${selWeek}");

    return Scaffold(
      body: Column(
        children: [
          gObj.InterventionTitleWidget("LISTE DES INTERVENTIONS PROGRAMMÉES"),
          Entete_Btn_weeks(),
          Entete_Btn_Search(),
          gColors.wLigne(),
          (sectionList.length == 0)
              ? Container()
              : Expanded(
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
                            },
                            child: Dismissible(
                              key: Key(item),
                              onDismissed: (direction) {},
                              child: new ElevatedButton(
                                onPressed: () async {
                                  await HapticFeedback.vibrate();
                                  await DbTools.getClient(wPlanning_Intervention.Planning_Interv_ClientId!);
                                  Srv_DbTools.ListGroupe = await DbTools.getGroupes(wPlanning_Intervention.Planning_Interv_ClientId!);
                                  await Srv_DbTools.getGroupeID(wPlanning_Intervention.Planning_Interv_GroupeId!);
                                  Srv_DbTools.ListSite = await DbTools.getSiteGroupe(Srv_DbTools.gGroupe.GroupeId);
                                  await Srv_DbTools.getSiteID(wPlanning_Intervention.Planning_Interv_SiteId!);

                                  Srv_DbTools.ListZone = await DbTools.getZones(wPlanning_Intervention.Planning_Interv_SiteId!);
                                  await Srv_DbTools.getZoneID(wPlanning_Intervention.Planning_Interv_ZoneId!);
                                  await DbTools.getInterventions(wPlanning_Intervention.Planning_Interv_ZoneId!);
                                  await DbTools.getIntervention(wPlanning_Intervention.Planning_Interv_InterventionId!);

                                  Srv_DbTools.gIntervention.Client_Nom = Srv_DbTools.gClient.Client_Nom;
                                  Srv_DbTools.gIntervention.Site_Nom = Srv_DbTools.gSite.Site_Nom;
                                  Srv_DbTools.gIntervention.Groupe_Nom = Srv_DbTools.gGroupe.Groupe_Nom;
                                  Srv_DbTools.gIntervention.Zone_Nom = Srv_DbTools.gZone.Zone_Nom;

                                  await Navigator.push(context, MaterialPageRoute(builder: (context) => Client_Groupe_Inter_Det()));
                                  Reload();



                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                                    elevation: 1,
                                    backgroundColor: Colors.white,
//                                    shadowColor: Colors.red
                                ),
                                child: Container(
                                  padding: EdgeInsets.only(left: 12.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: item3.isEmpty ? Color(0xFFf3a9dd) :Colors.grey,
                                  ),
                                  height: 55,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topRight: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
                                      border: Border.all(width: 1.0, color: item3.isEmpty ? Color(0xFFf3a9dd) :Colors.grey),
                                      color: Colors.white,
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: gColors.GrdBtn_Colors3,
                                          blurRadius: 5,
                                          offset: Offset(1, 1),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 10,
                                          child: Container(
                                              height: 50,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
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
                                              height: 50,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Container(
                                                      padding: EdgeInsets.only(right: item3.isEmpty ? 10: 0, left:  5),
                                                      height: rowh,
                                                      child: Text(item3.isEmpty ? "${item2}" :
                                                        "${item2} >",
                                                        textAlign: TextAlign.right,
                                                        style: gColors.bodySaisie_B_B.copyWith(color: gColors.primaryOrange),
                                                      )),
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )),
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
        child: AffHeader("${section.header}", "", gColors.white, "Icon_Planning"),
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
                SizedBox(width: 10),
                Expanded(
                    child: Divider(
                  color: gColors.primaryBlue,
                  thickness: 1,
                )),
                Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                    height: 55,
                    child: Text(
                      "${wTextL}",
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: gColors.bodyTitle1_B_Gr.copyWith(color: gColors.primaryBlue),
                    )),
                Expanded(
                    child: Divider(
                  color: gColors.primaryBlue,
                  thickness: 1,
                )),
                SizedBox(width: 10),
              ],
            ),
//            gColors.wLigne(),
          ],
        ));
  }

  @override
  Widget Entete_Btn_Search() {
    return Container(
        height: 57,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
/*
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
*/
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

  List<DateSection> getDateSection(
    String Filter, [
    int sectionSize = 10,
    int itemSize = 5,
  ]) {
    initializeDateFormatting('fr', null);
    var sections = List<DateSection>.empty(growable: true);
    var sections_Final = List<DateSection>.empty(growable: true);

    print("${buttonsWeeksDeb[selWeek]} ${buttonsWeeksFin[selWeek]}");

    print("ListPlanning_Intervention length ${Srv_DbTools.ListPlanning_Intervention.length}");
    String Rupt = "";
    DateTime RuptDate = DateTime.now();
    String RuptDateLib = "";
    var section = DateSection();
    int ideb = 0;

    for (int i = 0; i < Srv_DbTools.ListPlanning_Intervention.length; i++) {
      Planning_Intervention wPlanning_Intervention = Srv_DbTools.ListPlanning_Intervention[i];

      if (Filter.isNotEmpty) {
        if (!wPlanning_Intervention.Desc().contains(Filter)) {
          continue;
        }
      }
      DateTime weekStart = buttonsWeeksDeb[selWeek];
      DateTime weekEnd1 = weekStart.add(Duration(days: 7));

      bool wTest = wPlanning_Intervention.Planning_Interv_InterventionstartTime.isBefore(weekStart) || wPlanning_Intervention.Planning_Interv_InterventionstartTime.isAfter(weekEnd1);
      print("wPlanning_Intervention ${wPlanning_Intervention.Planning_Interv_InterventionstartTime} ${weekStart} ${weekEnd1} wTest ${wTest}");

      if (wTest) {
        continue;
      }
      String formattedDate = DateFormat('dd/MMM/yyyy').format(wPlanning_Intervention.Planning_Interv_InterventionstartTime);
      String formattedDateLib = DateFormat('EEEE dd MMM yy', 'fr').format(wPlanning_Intervention.Planning_Interv_InterventionstartTime);

      if (ideb == 0) {
        RuptDate = DateTime(wPlanning_Intervention.Planning_Interv_InterventionstartTime.year, wPlanning_Intervention.Planning_Interv_InterventionstartTime.month, wPlanning_Intervention.Planning_Interv_InterventionstartTime.day);
        RuptDateLib = formattedDateLib;
      }
      ideb++;

      String formattedDeb = DateFormat('HH:mm').format(wPlanning_Intervention.Planning_Interv_InterventionstartTime);
      String formattedFin = DateFormat('HH:mm').format(wPlanning_Intervention.Planning_Interv_InterventionendTime);
      print("wPlanning_Intervention ${formattedDate} ${formattedDateLib} ${formattedDeb} ${formattedFin}");

      if (Rupt != formattedDate) {
        if (Rupt == "") {
        } else {
          section.wDate = RuptDate;
          section.header = "${RuptDateLib}";
          print("ADDADDADDADDADDADD ${section.wDate}");
          sections.add(section);
        }
        section = DateSection();
        section.wDate = wPlanning_Intervention.Planning_Interv_InterventionstartTime;
        RuptDate = DateTime(wPlanning_Intervention.Planning_Interv_InterventionstartTime.year, wPlanning_Intervention.Planning_Interv_InterventionstartTime.month, wPlanning_Intervention.Planning_Interv_InterventionstartTime.day);
        section..header = "${formattedDateLib}";
        section..expanded = true;
        section..items = [];
        section..items2 = [];
        section..items3 = [];
        section..Planning_Interventions = [];
        Rupt = formattedDate;
//        print("Header ${formattedDate}");
      }
      section.Planning_Interventions.add(wPlanning_Intervention);
      if(wPlanning_Intervention.Planning_Interv_InterventionId == -1)
        {
          String wLib = "${wPlanning_Intervention.Planning_Libelle}";
//      print("wLib ${wLib}");
          section.items.add(wLib);

          String wLib3 = "";
//      print("wLib3 ${wLib3}");
          section.items3.add(wLib3);

          String wLibH = "${formattedDeb}/${formattedFin}";
//      print("wLibH ${wLibH}");
          section.items2.add(wLibH);
        }
      else
        {
          String wLib = "[${wPlanning_Intervention.Planning_Interv_InterventionId}] ${wPlanning_Intervention.Planning_Interv_Client_Nom} / ${wPlanning_Intervention.Planning_Interv_Site_Nom}";
//      print("wLib ${wLib}");
          section.items.add(wLib);

          String wLib3 = "${wPlanning_Intervention.Planning_Interv_Intervention_Parcs_Type} - ${wPlanning_Intervention.Planning_Interv_Intervention_Type} - ${wPlanning_Intervention.Planning_Interv_Intervention_Status}";
//      print("wLib3 ${wLib3}");
          section.items3.add(wLib3);

          String wLibH = "${formattedDeb}/${formattedFin}";
//      print("wLibH ${wLibH}");
          section.items2.add(wLibH);
        }

    }
    ;
    if (section.items.length > 0) {
//        print("ADDADDADDADDADDADD Fin  ${section.items.length} ${section.items[0]} ${section.items[1]}");
      sections.add(section);
    }

    print("sections ${sections.length}");

    for (int d = 0; d < 7; d++) {
      DateTime wDate = buttonsWeeksDeb[selWeek].add(Duration(days: d));
      print("Date ${wDate}");
      DateTime weekStart = wDate.add(Duration(seconds: -1));
      DateTime weekEnd1 = weekStart.add(Duration(days: 1, seconds: 2));

      bool trv = false;
      for (int i = 0; i < sections.length; i++) {
        print("weekStart ${weekStart} weekEnd1 ${weekEnd1} sections[i].wDate ${sections[i].wDate}");

        if (sections[i].wDate.isAfter(weekStart) && sections[i].wDate.isBefore(weekEnd1)) {
          trv = true;
          sections_Final.add(sections[i]);
          break;
        }
      }

      if (!trv) {
        section = DateSection();
        section.wDate = wDate;
        String formattedDateLib = DateFormat('EEEE dd MMM yy', 'fr').format(wDate);
        section..header = "${formattedDateLib}";
        section..expanded = false;
        sections_Final.add(section);
      }
    }

    return sections_Final;
  }
}

class DateSection implements ExpandableListSection<String> {
  bool expanded = true;
  DateTime wDate = DateTime.now();
  List<String> items = [];
  List<String> items2 = [];
  List<String> items3 = [];
  List<Planning_Intervention> Planning_Interventions = [];

  String header = "";

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
