import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DCL_Ent.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_ImportExport.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Param.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/GestCo/DCL_Devis_Det.dart';
import 'package:verifplus/Widget/GestCo/DCL_Ent_Menu_Dialog.dart';
import 'package:verifplus/Widget/GestCo/Select_DCL_Ents_Add.dart';
import 'package:verifplus/Widget/Planning/Client_Groupe_Inter_Det.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gDialogs.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

class DCL_List extends StatefulWidget {
  const DCL_List({super.key});

  @override
  DCL_ListState createState() => DCL_ListState();
}

class DCL_ListState extends State<DCL_List> with SingleTickerProviderStateMixin {
  var formatter = NumberFormat('###,##0.00');

  bool isChecked = false;
  bool affAll = true;
  bool affEdtFilter = false;

  TextEditingController ctrlFilter = TextEditingController();
  String filterText = '';
  bool isAll = true;
  int PastilleType = 0;
  double textSize = 14.0;

  int SelCol = -1;
  int SelID = -1;
  bool onCellTap = false;
  String wAction = "";

  bool btnSel_Aff = true;

  bool bSortDate = false;

  bool isValo = false;
  int TotQTE = 0;
  double TotHT = 0.0;
  double TotTVA = 0.0;
  double TotTTC = 0.0;

  late final controller = SlidableController(this);

  bool isParam = false;

  void Reload() async {
    await Srv_ImportExport.getErrorSync();
    bool wRes = await Srv_DbTools.getDCL_EntAll();

    List<String> ldclEnt = [];
    for (int i = 0; i < Srv_DbTools.ListDCL_Ent.length; i++) {
      DCL_Ent wdclEnt = Srv_DbTools.ListDCL_Ent[i];
      if (!ldclEnt.contains(wdclEnt.DCL_Ent_Type!)) {
        ldclEnt.add(wdclEnt.DCL_Ent_Type!);
      }
      print("wDCL_Ent.DCL_Ent_ClientNom ${wdclEnt.DCL_Ent_ClientNom}");
    }

    PastilleType = ldclEnt.length;
    if (ldclEnt.isEmpty) {
      Srv_DbTools.gSelDCL_Ent = Srv_DbTools.gSelDCL_EntBase;
    } else {
      int index = ldclEnt.indexWhere((element) => element.compareTo(Srv_DbTools.gSelDCL_Ent) == 0);
      if (index < 0) {
        Srv_DbTools.gSelDCL_Ent = Srv_DbTools.gSelDCL_EntBase;
      }
    }
    Filtre();
  }

  void Filtre() {
    Srv_DbTools.gDCL_Ent = DCL_Ent.DCL_EntInit();
    isAll = true;
    List<DCL_Ent> wlistdclEnt = [];
    Srv_DbTools.ListDCL_Entsearchresult.clear();

    if (Srv_DbTools.gSelDCL_Ent.compareTo(Srv_DbTools.gSelDCL_EntBase) == 0) {
      wlistdclEnt.addAll(Srv_DbTools.ListDCL_Ent);
    } else {
      isAll = false;
      Srv_DbTools.ListDCL_Ent.forEach((element) async {
        if (element.DCL_Ent_Type!.compareTo(Srv_DbTools.gSelDCL_Ent) == 0) {
          wlistdclEnt.add(element);
        }
      });
    }

    List<DCL_Ent> wlistdclEntTmp = [];
    print("element SelDCL_DateDeb ${Srv_DbTools.SelDCL_DateDeb}");
    print("element SelDCL_DateFin ${Srv_DbTools.SelDCL_DateFin}");
    wlistdclEnt.forEach((element) async {
      DateTime wDate = DateFormat("dd/MM/yyyy").parse(element.DCL_Ent_Date!);
      if (wDate.compareTo(Srv_DbTools.SelDCL_DateDeb) >= 0) {
//        print("wDate ${Srv_DbTools.SelDCL_DateDeb} ${wDate.toString()}    ${wDate.compareTo(Srv_DbTools.SelDCL_DateDeb)}");
        wlistdclEntTmp.add(element);
      }
    });

    wlistdclEnt.clear();
    wlistdclEnt.addAll(wlistdclEntTmp);
    if (DbTools.wStatusCde != "Tous") {
      wlistdclEntTmp.clear();
      wlistdclEnt.forEach((element) async {
        if (element.DCL_Ent_Statut == DbTools.wStatusCde) {
          wlistdclEntTmp.add(element);
        }
      });
      wlistdclEnt.clear();
      wlistdclEnt.addAll(wlistdclEntTmp);
    }

    String wFilterText = filterText.trim().toUpperCase();
    if (wFilterText.isEmpty) {
      Srv_DbTools.ListDCL_Entsearchresult.addAll(wlistdclEnt);
    } else {
      wlistdclEnt.forEach((element) async {
        {
          String dclEntType = element.DCL_Ent_Type == null ? "" : element.DCL_Ent_Type!;
          String dclEntEtat = element.DCL_Ent_Etat == null ? "" : element.DCL_Ent_Etat!;
          String id = element.DCL_EntID.toString();

          if (dclEntType.toUpperCase().contains(wFilterText)) {
            Srv_DbTools.ListDCL_Entsearchresult.add(element);
          } else if (dclEntEtat.toUpperCase().contains(wFilterText))
            Srv_DbTools.ListDCL_Entsearchresult.add(element);
          else if (id.toUpperCase().contains(wFilterText))
            Srv_DbTools.ListDCL_Entsearchresult.add(element);
          else if (element.Desc().toUpperCase().contains(wFilterText)) Srv_DbTools.ListDCL_Entsearchresult.add(element);
        }
      });
    }

//    Srv_DbTools.SelDCL_DateDeb

    if (bSortDate) {
      Srv_DbTools.ListDCL_Entsearchresult.sort(Srv_DbTools.idSortComparison);
    } else {
      Srv_DbTools.ListDCL_Entsearchresult.sort(Srv_DbTools.affSortComparisonData_DCL);
    }

    TotHT = 0.0;
    TotTVA = 0.0;
    TotTTC = 0.0;
    Srv_DbTools.ListDCL_Entsearchresult.forEach((element) async {
      TotHT += element.DCL_Ent_MtHT!;
      TotTVA += element.DCL_Ent_MtTVA!;
      TotTTC += element.DCL_Ent_MtTTC!;
    });

    print(" TotHT $TotHT");

    setState(() {});
  }

  @override
  void initLib() async {
    Srv_DbTools.gSelDCL_Ent = "Ext";
    DbTools.wStatusCde = 'Tous';

    print(" gUserLogin_Art_Fav ${Srv_DbTools.gUserLogin_Art_Fav}");
    Reload();
  }

  @override
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
    return (!affEdtFilter)
        ? Container(
            height: 71,
            width: MediaQuery.of(context).size.width,
            color: gColors.LinearGradient3,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
              Container(
                width: 8,
              ),
              Expanded(
                  child: Container(
                      child: Text(
                (Srv_DbTools.gDCL_Ent.DCL_Ent_CCGSZ!.isEmpty) ? "Devis / Bon de commande / Bon de livraison / Bon de retour" : "${Srv_DbTools.gDCL_Ent.DCL_Ent_CCGSZ}",
                maxLines: 1,
                textAlign: TextAlign.left,
                style: gColors.bodyTitle1_B_Gr,
              ))),
              InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: SvgPicture.asset(
                      "assets/images/DCL_RechGr.svg",
                      height: icoWidth,
                      width: icoWidth,
                    ),
                  ),
                  onTap: () async {
                    affEdtFilter = !affEdtFilter;
                    setState(() {});
                  })
            ]))
        : EdtFilterWidget();
  }

  Widget EdtFilterWidget() {
    return Container(
        height: 92,
        width: MediaQuery.of(context).size.width,
        color: gColors.LinearGradient3,
        child: Container(
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: gColors.LinearGradient5,
                    width: 1.5,
                  ),
                ),
                width: MediaQuery.of(context).size.width - 56,
                margin: const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 20),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                    ),
                    InkWell(
                        child: SvgPicture.asset(
                          "assets/images/DCL_RechGr.svg",
                          height: 36,
                          width: 36,
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
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                          left: 5,
                          top: 15,
                        ),
                        border: InputBorder.none,
                        hintText: "Rechercher un document",
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
                ))));
  }

  @override
  Widget Entete_Tot_Search() {
    double wTotHT  = TotHT  ;
    double wTotTVA = TotTVA ;
    double wTotTTC = TotTTC ;

    print("❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️ Entete_Tot_Search ${Srv_DbTools.gDCL_Ent.DCL_EntID}");
    try{
      if ("${Srv_DbTools.gDCL_Ent.DCL_EntID}" != "null")
        {
        print("❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️ Entete_Tot_Search ${Srv_DbTools.gDCL_Ent.DCL_EntID}");
        wTotHT  = Srv_DbTools.gDCL_Ent.DCL_Ent_MtHT!;
        wTotTVA = Srv_DbTools.gDCL_Ent.DCL_Ent_MtTVA!;
        wTotTTC = Srv_DbTools.gDCL_Ent.DCL_Ent_MtTTC!;
        }
      }
    catch (e)
      {

      }

      return SizedBox(
        height: 71,
        child: Row(
          children: [
            Container(
              width: 8,
            ),
            InkWell(
                child: SizedBox(
                  width: icoWidth + 10,
                  child: Stack(children: <Widget>[
                    Image.asset(
                      "assets/images/DCL_Total.png",
                      color: isValo ? Colors.red : null,
                      height: icoWidth,
                      width: icoWidth,
                    ),
                  ]),
                ),
                onTap: () async {
                  await HapticFeedback.vibrate();
                  isValo = !isValo;
                  Filtre();
                }),
            Container(
                child: Row(
              children: [
                Text(
                  "(${Srv_DbTools.ListDCL_Entsearchresult.length})",
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  style: gColors.bodySaisie_B_B,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  "${gObj.formatterformat(wTotHT)}€ HT",
                  maxLines: 1,
                  textAlign: TextAlign.right,
                  style: gColors.bodyTitle1_B_Gr,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  "${gObj.formatterformat(wTotTVA)}€ TVA",
                  maxLines: 1,
                  textAlign: TextAlign.right,
                  style: gColors.bodyTitle1_N_Gr,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  "${gObj.formatterformat(wTotTTC)}€ TTC",
                  maxLines: 1,
                  textAlign: TextAlign.right,
                  style: gColors.bodyTitle1_N_Gr,
                ),
              ],
            ))
          ],
        ));
  }

  @override
  Widget Entete_Ico_Search() {
    String wType = DbTools.wTypeCde;
    Color wTypeColors = gColors.LinearGradient3;

    String wEtat = "État";
    Color wEtatColors = gColors.LinearGradient5;

    print(" DbTools.wStatusCde = ${DbTools.wStatusCde}");

    if (DbTools.wStatusCde == 'Préparation') {
      wEtat = "Prépa";
      wEtatColors = Colors.orangeAccent;
    }
    if (DbTools.wStatusCde == 'En cours') {
      wEtat = "En cours";
      wEtatColors = Colors.blueAccent;
    }
    if (DbTools.wStatusCde == 'Accepté') {
      wEtat = "Accepté";
      wEtatColors = gColors.primaryGreen;
    }
    if (DbTools.wStatusCde == 'Refusé') {
      wEtat = "Refusé";
      wEtatColors = gColors.red;
    }

    return Container(
        decoration: const BoxDecoration(
          color: gColors.LinearGradient3,
        ),
        height: 71,
        child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            width: 16,
          ),
          InkWell(
              child: SizedBox(
                width: icoWidth,
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
                affEdtFilter = false;
                await DCL_Ent_Menu_Dialog.Dialogs_DCL_Ent_Menu(context);
                Filtre();
              }),

/*

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
                  SvgPicture.asset(
                    "assets/images/DCL_Diam.svg",
                    height: 36,
                    width: 36,
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

*/

          Expanded(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    width: 140,
                    decoration: BoxDecoration(
                      color: wTypeColors,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.black,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          wType,
                          style: gColors.bodyTitle1_N_G24,
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    await gDialogs.Dialog_ActionType(context);
                    Filtre();
                  }),
              InkWell(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    width: 140,
                    decoration: BoxDecoration(
                      color: wEtatColors,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: wEtatColors,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          wEtat,
                          style: gColors.bodyTitle1_N_W24,
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    await gDialogs.Dialog_ActionSel(context);
                    Filtre();
                  }),
              InkWell(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    width: icoWidth + 10,
                    child: Stack(children: <Widget>[
                      Image.asset(
                        "assets/images/DCL_Impr.png",
                        height: icoWidth + 10,
                        width: icoWidth + 10,
                      ),
                    ]),
                  ),
                  onTap: () async {
                    await HapticFeedback.vibrate();
                    Filtre();
                  }),
              InkWell(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    width: icoWidth + 10,
                    child: Stack(children: <Widget>[
                      Image.asset(
                        "assets/images/DCL_Transf.png",
                        height: icoWidth + 10,
                        width: icoWidth + 10,
                      ),
                    ]),
                  ),
                  onTap: () async {
                    await HapticFeedback.vibrate();
                    Filtre();
                  }),
            ],
          )),
        ]));
  }

  double icoWidth = 40;

  @override
  Widget build(BuildContext context) {
    double LargeurLabel = 140;
    Param_Param wparamParam = Srv_DbTools.getParam_Param_in_Mem("Type_Organe", Srv_DbTools.gSelDCL_Ent);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      //    endDrawer: DbTools.gIsMedecinLogin! ? C_SideDrawer() : I_SideDrawer(),

      backgroundColor: Colors.white,

      body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            children: [
//              gObj.DCL_EntTitleWidgetCalc(context, "${Srv_DbTools.gClient.Client_Nom.toUpperCase()}", wTitre2: "${Srv_DbTools.gGroupe.Groupe_Nom}", wTitre3:"${Srv_DbTools.gSite.Site_Nom}", wTitre4:"${Srv_DbTools.gZone.Zone_Nom}"),
              Expanded(
                child: DCL_EntGridWidget(),
              ),
            ],
          )),
      floatingActionButton: !affAll
          ? Container()
          : Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 50, 60),
              child: FloatingActionButton(
                  elevation: 0.0,
                  backgroundColor: gColors.secondary,
                  onPressed: () async {
                    await Select_DCL_Ents_Add.Dialogs_Add(context, true);
                    Reload();
                  },
                  child: const Icon(Icons.add)),
            ),
    );
  }

  Future getNo(DCL_Ent dclEnt) async {
    if (await Srv_DbTools.getClient(dclEnt.DCL_Ent_ClientId!)) {
      dclEnt.DCL_Ent_ClientNom = "${Srv_DbTools.gClient.ClientId} - ${Srv_DbTools.gClient.Client_Nom}";
      dclEnt.DCL_Ent_CCGSZ = "${dclEnt.DCL_Ent_ClientNom} ";
    }

    if (dclEnt.DCL_Ent_GroupeId! >= 0) {
      await Srv_DbTools.getGroupeID(dclEnt.DCL_Ent_GroupeId!);
      if (Srv_DbTools.gGroupe.Groupe_Nom.isNotEmpty) dclEnt.DCL_Ent_GroupeNom = "/ ${Srv_DbTools.gGroupe.Groupe_Nom}";
      dclEnt.DCL_Ent_CCGSZ = "${dclEnt.DCL_Ent_ClientNom} ${dclEnt.DCL_Ent_GroupeNom}";
    }

    if (dclEnt.DCL_Ent_SiteId! >= 0) {
      await Srv_DbTools.getSiteID(dclEnt.DCL_Ent_SiteId!);
      if (Srv_DbTools.gSite.Site_Nom.isNotEmpty) dclEnt.DCL_Ent_SiteNom = "/ ${Srv_DbTools.gSite.Site_Nom}";
      dclEnt.DCL_Ent_CCGSZ = "${dclEnt.DCL_Ent_ClientNom} ${dclEnt.DCL_Ent_GroupeNom} ${dclEnt.DCL_Ent_SiteNom}";
    }

    if (dclEnt.DCL_Ent_ZoneId! >= 0) {
      await Srv_DbTools.getZoneID(dclEnt.DCL_Ent_ZoneId!);
      if (Srv_DbTools.gZone.Zone_Nom.isNotEmpty) dclEnt.DCL_Ent_ZoneNom = "/ ${Srv_DbTools.gZone.Zone_Nom}";
      dclEnt.DCL_Ent_CCGSZ = "${dclEnt.DCL_Ent_ClientNom} ${dclEnt.DCL_Ent_GroupeNom} ${dclEnt.DCL_Ent_SiteNom} ${dclEnt.DCL_Ent_ZoneNom} ";
    }
  }

  //***************************
  //***************************
  //***************************

  Future<bool> GetAdresseSrv(BuildContext context, DCL_Ent wdclEnt) async {
    if (wdclEnt.DCL_Ent_ZoneId! >= 0) {
      await Srv_DbTools.getZoneID(wdclEnt.DCL_Ent_ZoneId!);
      if (Srv_DbTools.gZone.Zone_Nom.isNotEmpty) wdclEnt.DCL_Ent_ZoneNom = "/ ${Srv_DbTools.gZone.Zone_Nom}";
      wdclEnt.DCL_Ent_CCGSZ = "iA ${wdclEnt.DCL_Ent_Num} / ${wdclEnt.DCL_Ent_ClientNom} ${wdclEnt.DCL_Ent_GroupeNom} ${wdclEnt.DCL_Ent_SiteNom} ${wdclEnt.DCL_Ent_ZoneNom} ";
      wdclEnt.DCL_Ent_Adr1 = "Adr Zone";
      wdclEnt.DCL_Ent_Adr2 = "${Srv_DbTools.gZone.Zone_Adr1} ${Srv_DbTools.gZone.Zone_Adr2} ${Srv_DbTools.gZone.Zone_CP} ${Srv_DbTools.gZone.Zone_Ville}";
    } else if (wdclEnt.DCL_Ent_SiteId! >= 0) {
      await Srv_DbTools.getSiteID(wdclEnt.DCL_Ent_SiteId!);
      if (Srv_DbTools.gSite.Site_Nom.isNotEmpty) wdclEnt.DCL_Ent_SiteNom = "/ ${Srv_DbTools.gSite.Site_Nom}";
      wdclEnt.DCL_Ent_CCGSZ = "iB ${wdclEnt.DCL_Ent_Num} / ${wdclEnt.DCL_Ent_ClientNom} ${wdclEnt.DCL_Ent_GroupeNom} ${wdclEnt.DCL_Ent_SiteNom}";
      wdclEnt.DCL_Ent_Adr1 = "Adr Site";
      wdclEnt.DCL_Ent_Adr2 = "${Srv_DbTools.gSite.Site_Adr1} ${Srv_DbTools.gSite.Site_Adr2} ${Srv_DbTools.gSite.Site_CP} ${Srv_DbTools.gSite.Site_Ville}";
    } else if (wdclEnt.DCL_Ent_GroupeId! >= 0) {
      await Srv_DbTools.getGroupeID(wdclEnt.DCL_Ent_GroupeId!);
      if (Srv_DbTools.gGroupe.Groupe_Nom.isNotEmpty) wdclEnt.DCL_Ent_GroupeNom = "/ ${Srv_DbTools.gGroupe.Groupe_Nom}";
      wdclEnt.DCL_Ent_CCGSZ = "iC ${wdclEnt.DCL_Ent_Num} / ${wdclEnt.DCL_Ent_ClientNom} ${wdclEnt.DCL_Ent_GroupeNom}";
      wdclEnt.DCL_Ent_Adr1 = "Adr Groupe";
      wdclEnt.DCL_Ent_Adr2 = "${Srv_DbTools.gGroupe.Groupe_Adr1} ${Srv_DbTools.gGroupe.Groupe_Adr2} ${Srv_DbTools.gGroupe.Groupe_CP} ${Srv_DbTools.gGroupe.Groupe_Ville}";
    } else if (await Srv_DbTools.getClient(wdclEnt.DCL_Ent_ClientId!)) {
      wdclEnt.DCL_Ent_ClientNom = "${Srv_DbTools.gClient.ClientId} - ${Srv_DbTools.gClient.Client_Nom}";
      wdclEnt.DCL_Ent_Adr1 = "Adr Client";
      wdclEnt.DCL_Ent_Adr2 = "${Srv_DbTools.gClient.Adresse_Adr1}  ${Srv_DbTools.gClient.Adresse_CP} ${Srv_DbTools.gClient.Adresse_Ville}";
    }
    return true;
  }

  Widget GetAdresse(BuildContext context, DCL_Ent wdclEnt, Color wColorText) {
    return FutureBuilder(
      future: GetAdresseSrv(context, wdclEnt),
      builder: (BuildContext context, AsyncSnapshot<bool> wRet) {
        if (wRet.hasData) {
          return SizedBox(
            height: 36,
            child: Row(
              children: <Widget>[
                Container(
                  width: 8,
                ),
                Container(
                    padding: const EdgeInsets.only(left: 5),
                    height: 22,
                    child: Text(
                      "${wdclEnt.DCL_Ent_Adr1}",
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      style: gColors.bodySaisie_B_B.copyWith(color: wColorText),
                    )),
                Container(
                    padding: const EdgeInsets.only(left: 5),
                    height: 22,
                    child: Text(
                      "${wdclEnt.DCL_Ent_Adr2}",
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      style: gColors.bodySaisie_N_B.copyWith(color: wColorText),
                    )),
              ],
            ),
          );
        } else {
          return Container(
            child: const Text("..."),
          );
        }
      },
    );
  }

  void doOptions(BuildContext context) {}

  Widget DCL_EntGridWidget() {
    print(" BUILD DCL_EntGridWidget");

    return Container(
        color: gColors.LinearGradient2,
        child: Column(
          children: <Widget>[
//            gColors.wLigne(),

            Expanded(
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverToBoxAdapter(
                      child: Container(
                    color: Colors.white,
//                      height: 200,
                    child: Column(
                      children: [
                        Entete_Btn_Search(),
                        if (!affEdtFilter) gColors.wLigne(),
                        if (!affEdtFilter) Entete_Tot_Search(),
                        if (!affEdtFilter) gColors.wLigne(),
                        if (!affEdtFilter) Entete_Ico_Search(),
                        if (!affEdtFilter) gColors.wLigne(),
                        gColors.ombre(),
                      ],
                    ),
                  ))
                ],
                body: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  itemCount: Srv_DbTools.ListDCL_Entsearchresult.length,
                  itemBuilder: (BuildContext context, int index) {


                    DCL_Ent dclEnt = Srv_DbTools.ListDCL_Entsearchresult[index];
                    Color wColor = Colors.transparent;
                    Color wColor2 = Colors.transparent;
                    Color wColorBack = Colors.transparent;
                    Color wColorBack2 = Colors.white;
                    Color wColorText = Colors.black;

                    if (Srv_DbTools.gDCL_Ent == dclEnt) {
                      if (!btnSel_Aff) wColorBack = gColors.backgroundColor;
                      wColorBack2 = gColors.backgroundColor;
                      wColorText = Colors.white;
                    }

                    if (dclEnt.DCL_Ent_Type == "Devis") {
                      wColor = gColors.getColorEtatDevis(dclEnt.DCL_Ent_Etat!);
                    }
                    if (dclEnt.DCL_Ent_Type == "Commande") {
                      wColor = gColors.getColorEtatCde(dclEnt.DCL_Ent_Etat!);
                    }
                    if (dclEnt.DCL_Ent_Type == "Bon de livraison") {
                      wColor = gColors.getColorEtatLivr(dclEnt.DCL_Ent_Etat!);
                    }

                    if (dclEnt.DCL_Ent_Type == "Devis") {
                      wColor2 = const Color(0xFFC00000);
                    }
                    if (dclEnt.DCL_Ent_Type == "Commande") {
                      wColor2 = const Color(0xFF0066FF);
                    }
                    if (dclEnt.DCL_Ent_Type == "Bon de livraison") {
                      wColor2 = const Color(0xFF4EA72E);
                    }
                    if (dclEnt.DCL_Ent_Type == "Bon de retour") {
                      wColor2 = const Color(0xFFE97132);
                    }

                    double rowh = 24;
                    String wNomClient = "${dclEnt.DCL_Ent_ClientNom}";
                    double wH = !btnSel_Aff
                        ? 57
                        : index == 0
                            ? 146
                            : 158;
                    return Column(
                      children: [
                        SizedBox(
                          height: wH,
                          width: 800,
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              Container(
                                color: wColorBack,
                                child: GestureDetector(
                                  onLongPress: () async {
                                    await HapticFeedback.vibrate();
                                    print(" on LongPress on LongPress on LongPress on LongPress on LongPress");
                                    btnSel_Aff = !btnSel_Aff;
                                    setState(() {});
                                  },
                                  onTap: () async {
                                    print(" >>>>>>>>>>>>>>>>>>> GestureDetector DETAIL");
                                    if (dclEnt.DCL_Ent_isOptions) {
                                      dclEnt.DCL_Ent_isOptions = false;
                                      setState(() {});
                                      return;
                                    }
                                    print(" DETAIL");
                                    await HapticFeedback.vibrate();
                                    if (Srv_DbTools.gDCL_Ent == dclEnt) {
                                      Srv_DbTools.gDCL_Ent = DCL_Ent.DCL_EntInit();
                                      setState(() {});
                                      return;
                                    } else {
                                      Srv_DbTools.gDCL_Ent = dclEnt;
                                      await getNo(dclEnt);
                                    }

                                    setState(() {});

                                    if (dclEnt.DCL_Ent_InterventionId! >= 0) {
                                      Srv_DbTools.gIntervention.Client_Nom = Srv_DbTools.gClient.Client_Nom;
                                      Srv_DbTools.gIntervention.Site_Nom = Srv_DbTools.gSite.Site_Nom;
                                      Srv_DbTools.gIntervention.Groupe_Nom = Srv_DbTools.gGroupe.Groupe_Nom;
                                      Srv_DbTools.gIntervention.Zone_Nom = Srv_DbTools.gZone.Zone_Nom;
                                      await HapticFeedback.vibrate();
                                      await Navigator.push(context, MaterialPageRoute(builder: (context) => const Client_Groupe_Inter_Det()));
                                      Reload();
                                    } else {
                                      await HapticFeedback.vibrate();
                                      await Navigator.push(context, MaterialPageRoute(builder: (context) => const DCL_Devis_Det()));
                                      Reload();
                                    }
                                  },
                                  child: Column(children: [
                                    (!btnSel_Aff)
                                        ? Column(
                                            children: [
                                              Container(
                                                width: 800,
                                                color: wColorBack2,
                                                height: 57,
                                                padding: const EdgeInsets.only(
                                                  top: 10,
                                                ),
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width: 8,
                                                    ),
                                                    Expanded(
                                                      flex: 8,
                                                      child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                                        gColors.gCircle(wColor),
                                                        InkWell(
                                                            child: Container(
                                                                padding: const EdgeInsets.only(
                                                                  left: 5,
                                                                ),
                                                                height: rowh,
                                                                child: Text(
                                                                  "zz${dclEnt.DCL_Ent_Num}",
                                                                  textAlign: TextAlign.right,
                                                                  style: gColors.bodySaisie_B_B.copyWith(color: wColorText),
                                                                )),
                                                            onTap: () async {
                                                              print("ë•ë DETAIL");

                                                              if (Srv_DbTools.gDCL_Ent == dclEnt)
                                                                Srv_DbTools.gDCL_Ent = DCL_Ent.DCL_EntInit();
                                                              else {
                                                                Srv_DbTools.gDCL_Ent = dclEnt;
                                                                await getNo(dclEnt);
                                                              }

                                                              setState(() {});
                                                            }),
                                                      ]),
                                                    ),
                                                    Expanded(
                                                        flex: 6,
                                                        child: Container(
                                                            padding: const EdgeInsets.only(left: 5),
                                                            height: rowh,
                                                            child: Text(
                                                              "${dclEnt.DCL_Ent_Date}",
                                                              maxLines: 1,
                                                              textAlign: TextAlign.left,
                                                              style: gColors.bodySaisie_B_B.copyWith(color: wColorText),
                                                            ))),
                                                    Expanded(
                                                      flex: 30,
                                                      child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                                        Container(
                                                            padding: const EdgeInsets.only(left: 5, right: 5),
                                                            height: rowh,
                                                            child: Text(
                                                              "${dclEnt.DCL_Ent_InterventionId! > 0 ? "(${dclEnt.DCL_Ent_InterventionId}) " : ""}$wNomClient",
                                                              textAlign: TextAlign.right,
                                                              style: gColors.bodySaisie_B_B.copyWith(color: wColorText),
                                                            ))
                                                      ]),
                                                    ),
                                                    if (isValo)
                                                      Expanded(
                                                          flex: 7,
                                                          child: Container(
                                                              padding: const EdgeInsets.only(right: 5),
                                                              height: rowh,
                                                              child: Text(
                                                                "${gObj.formatterformat(dclEnt.DCL_Ent_MtHT!)}€ HT",
                                                                maxLines: 1,
                                                                textAlign: TextAlign.right,
                                                                style: gColors.bodySaisie_B_B.copyWith(color: wColorText),
                                                              ))),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                        :
// BIG
                                        Slidable(
                                            key: const ValueKey(0),
                                            endActionPane: ActionPane(
                                              motion: const ScrollMotion(),
                                              children: [
                                                CustomSlidableAction(
                                                  onPressed: (_) {
                                                    setState(() {});
                                                  },
                                                  backgroundColor: gColors.LinearGradient5,
                                                  foregroundColor: Colors.white,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        "assets/images/DCL_Dupliquer.svg",
                                                        color: Colors.white,
                                                        height: 50,
                                                      ),
                                                      const Text("Dupliquer"),
                                                    ],
                                                  ),
                                                ),
                                                CustomSlidableAction(
                                                  onPressed: (_) => controller.openEndActionPane(),
                                                  backgroundColor: gColors.LinearGradient4,
                                                  foregroundColor: Colors.white,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        "assets/images/DCL_Reviser.svg",
                                                        color: Colors.white,
                                                        height: 50,
                                                      ),
                                                      const Text("Reviser")
                                                    ],
                                                  ),
                                                ),
                                                CustomSlidableAction(
                                                  onPressed: (_) => controller.openEndActionPane(),
                                                  backgroundColor: gColors.LinearGradient3b,
                                                  foregroundColor: Colors.white,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        "assets/images/DCL_Relancer.svg",
                                                        color: Colors.white,
                                                        height: 50,
                                                      ),
                                                      const Text("Relancer")
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),

                                            // The child of the Slidable is what the user sees when the
                                            // component is not dragged.
                                            child: Column(
                                              children: [
                                                Container(
                                                  color: index == 0 ? Colors.white : Colors.transparent,
                                                  height: index == 0 ? 0 : 12,
                                                ),
                                                Stack(
                                                  children: [



                                                    Row(
                                                      children: [
                                                        Container(
                                                          color: wColorBack2,
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Container(
                                                                width: 634,
                                                                height: 42,
                                                                margin: const EdgeInsets.only(
                                                                  top: 20,
                                                                ),
                                                                child: Row(
                                                                  children: <Widget>[
                                                                    Container(
                                                                      width: 8,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 100,
                                                                      child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                                                        gColors.gCircle(wColor),
                                                                        InkWell(
                                                                            child: Container(
                                                                                padding: const EdgeInsets.only(
                                                                                  left: 5,
                                                                                ),
                                                                                height: rowh,
                                                                                child: Text(
                                                                                  "${dclEnt.DCL_Ent_Num}",
                                                                                  textAlign: TextAlign.right,
                                                                                  style: gColors.bodySaisie_B_B.copyWith(color: wColorText),
                                                                                )),
                                                                            onTap: () async {
                                                                              print("ë•ë BIG DETAIL");
                                                                              if (Srv_DbTools.gDCL_Ent == dclEnt)
                                                                                Srv_DbTools.gDCL_Ent = DCL_Ent.DCL_EntInit();
                                                                              else
                                                                                Srv_DbTools.gDCL_Ent = dclEnt;
                                                                              await getNo(dclEnt);
                                                                            }),
                                                                      ]),
                                                                    ),
                                                                    SizedBox(
                                                                        width: 80,
                                                                        child: Container(
                                                                            padding: const EdgeInsets.only(left: 5),
                                                                            height: rowh,
                                                                            child: Text(
                                                                              "${dclEnt.DCL_Ent_Date}",
                                                                              maxLines: 1,
                                                                              textAlign: TextAlign.left,
                                                                              style: gColors.bodySaisie_B_B.copyWith(color: wColorText),
                                                                            ))),
                                                                    Expanded(
                                                                      child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                                                        Container(
                                                                            padding: const EdgeInsets.only(left: 5, right: 5),
                                                                            height: rowh,
                                                                            child: Text(
                                                                              "${dclEnt.DCL_Ent_InterventionId! > 0 ? "(${dclEnt.DCL_Ent_InterventionId}) " : ""}$wNomClient",
                                                                              textAlign: TextAlign.right,
                                                                              style: gColors.bodySaisie_B_B.copyWith(color: wColorText),
                                                                            ))
                                                                      ]),
                                                                    ),
                                                                    if (isValo)
                                                                      Container(
                                                                          padding: const EdgeInsets.only(right: 5),
                                                                          height: rowh,
                                                                          child: Text(
                                                                            "${gObj.formatterformat(dclEnt.DCL_Ent_MtHT!)}€",
                                                                            maxLines: 1,
                                                                            textAlign: TextAlign.right,
                                                                            style: gColors.bodySaisie_N_B.copyWith(color: wColorText),
                                                                          )),
                                                                    if (isValo)
                                                                      Container(
                                                                          padding: const EdgeInsets.only(left: 5, right: 10),
                                                                          height: rowh,
                                                                          child: Text(
                                                                            "HT",
                                                                            maxLines: 1,
                                                                            textAlign: TextAlign.right,
                                                                            style: gColors.bodySaisie_B_B.copyWith(color: wColorText),
                                                                          )),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 36,
                                                                width: 634,
                                                                child: Row(
                                                                  children: [
                                                                    GetAdresse(context, dclEnt, wColorText),
                                                                    if (isValo) const Spacer(),
                                                                    if (isValo)
                                                                      Container(
                                                                          padding: const EdgeInsets.only(left: 5),
                                                                          height: rowh,
                                                                          child: Text(
                                                                            "${gObj.formatterformat(dclEnt.DCL_Ent_MtTVA!)}€",
                                                                            maxLines: 1,
                                                                            textAlign: TextAlign.right,
                                                                            style: gColors.bodySaisie_N_B.copyWith(color: wColorText),
                                                                          )),
                                                                    if (isValo)
                                                                      Container(
                                                                          padding: const EdgeInsets.only(left: 5, right: 10),
                                                                          height: rowh,
                                                                          child: Text(
                                                                            "TVA",
                                                                            maxLines: 1,
                                                                            textAlign: TextAlign.right,
                                                                            style: gColors.bodySaisie_B_B.copyWith(color: wColorText),
                                                                          )),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 36,
                                                                width: 634,
                                                                child: Row(
                                                                  children: <Widget>[
                                                                    Container(
                                                                      width: 8,
                                                                    ),
                                                                    Container(
                                                                        padding: const EdgeInsets.only(left: 5),
                                                                        height: 22,
                                                                        child: Text(
                                                                          "Inter ",
                                                                          maxLines: 1,
                                                                          textAlign: TextAlign.left,
                                                                          style: gColors.bodySaisie_B_B.copyWith(color: wColorText),
                                                                        )),
                                                                    (dclEnt.DCL_Ent_InterventionId! > 0)
                                                                        ? Container(
                                                                            padding: const EdgeInsets.only(left: 5),
                                                                            height: 22,
                                                                            child: Text(
                                                                              "${dclEnt.DCL_Ent_InterventionId}".padLeft(5, "0"),
                                                                              maxLines: 1,
                                                                              textAlign: TextAlign.left,
                                                                              style: gColors.bodySaisie_N_B.copyWith(color: wColorText),
                                                                            ))
                                                                        : Container(
                                                                            height: 22,
                                                                            padding: const EdgeInsets.only(left: 5),
                                                                            child: Text(
                                                                              "".padLeft(5, "0"),
                                                                              maxLines: 1,
                                                                              textAlign: TextAlign.left,
                                                                              style: gColors.bodySaisie_N_B.copyWith(color: wColorText),
                                                                            )),
                                                                    Container(
                                                                        padding: const EdgeInsets.only(left: 5),
                                                                        height: 22,
                                                                        child: Text(
                                                                          "Aff ",
                                                                          maxLines: 1,
                                                                          textAlign: TextAlign.left,
                                                                          style: gColors.bodySaisie_B_B.copyWith(color: wColorText),
                                                                        )),
                                                                    Container(
                                                                        padding: const EdgeInsets.only(left: 5),
                                                                        height: 22,
                                                                        width: 60,
                                                                        child: Text(
                                                                          "Correctif ",
                                                                          maxLines: 1,
                                                                          textAlign: TextAlign.left,
                                                                          style: gColors.bodySaisie_N_B.copyWith(color: wColorText),
                                                                        )),
                                                                    if (isValo) const Spacer(),
                                                                    if (isValo)
                                                                      Container(
                                                                          padding: const EdgeInsets.only(left: 5),
                                                                          height: rowh,
                                                                          child: Text(
                                                                            "${gObj.formatterformat(0)}€",
                                                                            maxLines: 1,
                                                                            textAlign: TextAlign.right,
                                                                            style: gColors.bodySaisie_N_B.copyWith(color: wColorText),
                                                                          )),
                                                                    if (isValo)
                                                                      Container(
                                                                          padding: const EdgeInsets.only(left: 5, right: 5),
                                                                          height: rowh,
                                                                          child: Text(
                                                                            "ACT",
                                                                            maxLines: 1,
                                                                            textAlign: TextAlign.right,
                                                                            style: gColors.bodySaisie_B_B.copyWith(color: wColorText),
                                                                          )),
                                                                    if (isValo) const Spacer(),
                                                                    if (isValo)
                                                                      Container(
                                                                          padding: const EdgeInsets.only(left: 5),
                                                                          height: rowh,
                                                                          child: Text(
                                                                            "${gObj.formatterformat(dclEnt.DCL_Ent_MtTTC!)}€",
                                                                            maxLines: 1,
                                                                            textAlign: TextAlign.right,
                                                                            style: gColors.bodySaisie_N_B.copyWith(color: wColorText),
                                                                          )),
                                                                    if (isValo)
                                                                      Container(
                                                                          padding: const EdgeInsets.only(left: 5, right: 10),
                                                                          height: rowh,
                                                                          child: Text(
                                                                            "TTC",
                                                                            maxLines: 1,
                                                                            textAlign: TextAlign.right,
                                                                            style: gColors.bodySaisie_B_B.copyWith(color: wColorText),
                                                                          )),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                height: 12,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 6,
                                                          height: 146,
                                                          color: gColors.getColorTypeCde(dclEnt.DCL_Ent_Type!),
                                                        ),
                                                      ],
                                                    ),

                                                    InkWell(
                                                        child: Container(
                                                          height: wH -12,
                                                          width: 150,
                                                          color: Colors.transparent,

                                                        ),
                                                        onTap: () async {
                                                          print("ë•ë BIG DETAIL");
                                                          if (Srv_DbTools.gDCL_Ent == dclEnt)
                                                            Srv_DbTools.gDCL_Ent = DCL_Ent.DCL_EntInit();
                                                          else
                                                            {
                                                              Srv_DbTools.gDCL_Ent = dclEnt;
                                                              await getNo(dclEnt);
                                                            }
                                                          setState(() {

                                                          });
                                                        }),



                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                  ]),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                child: SizedBox(
                                  height: wH,
                                  width: 110,
                                  child: InkWell(
                                      child: Container(),
                                      onTap: () async {
                                        if (Srv_DbTools.gDCL_Ent == dclEnt) {
                                          Srv_DbTools.gDCL_Ent == DCL_Ent.DCL_EntInit();
                                        } else {
                                          Srv_DbTools.gDCL_Ent = dclEnt;
                                        }
                                        await getNo(dclEnt);

                                        setState(() {});
                                      }),
                                ),
                              )
                            ],
                          ),
                        ),
                        gColors.ombre(),
                        if (dclEnt.DCL_Ent_isOptions)
                          Column(
                            children: [
                              AffBtnParam("", "Réglage du devis (Paramètres, Business, Technique)", "${Srv_DbTools.gDCL_Ent.DCL_Ent_Affaire}", "DCL_Param2.svg", gColors.white, gColors.primaryBlue, "Reglt"),
                              gColors.ombre(),
                              Container(
                                height: 6,
                              ),
                              AffBtnParam("", "Réviser le devis (Ex : DV000001 > DV000001-R01)", "${Srv_DbTools.gDCL_Ent.DCL_Ent_Affaire}", "DCL_Reviser.svg", gColors.white, gColors.primaryBlue, "Rev"),
                              gColors.ombre(),
                              Container(
                                height: 6,
                              ),
                              AffBtnParam("", "Dupliquer le devis", "${Srv_DbTools.gDCL_Ent.DCL_Ent_Affaire}", "DCL_Dupliquer.svg", gColors.white, gColors.primaryBlue, "Dup"),
                              gColors.ombre(),
                              Container(
                                height: 6,
                              ),
                              AffBtnParam("", "Transférer le devis  en Bon de commande, Livraison", "${Srv_DbTools.gDCL_Ent.DCL_Ent_Affaire}", "DCL_Transf", gColors.white, gColors.primaryBlue, "Transf"),
                              gColors.ombre(),
                            ],
                          )
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 45.0),
          ],
        ));
  }

  Widget AffBtnParam(String wChamps, String wTitle, String wValue, String ImgL, Color BckGrd, Color ForeGrd, String wParam, {String wChampsNote = "", bool bLigne = true}) {
    return TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () async {
          print("onPressed");
          await HapticFeedback.vibrate();
          if (wParam == "Reglt") {
            DCL_Devis_Det.isParam = true;
            await HapticFeedback.vibrate();
            await Navigator.push(context, MaterialPageRoute(builder: (context) => const DCL_Devis_Det()));
            Reload();
          }

          setState(() {});
        },
        child: Column(
          children: [
            AffLigne(wTitle, "$wValue >", BckGrd, ImgL, ForeGrd, bLigne: bLigne),
          ],
        ));
  }

  Widget AffLigne(String wTextL, String wTextR, Color BckGrd, String ImgL, Color ForeGrd, {bool bLigne = true}) {
    double wHeight = 57;
    double mTop = 22;
    double icoWidth = 32;
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        color: BckGrd,
        child: Column(
          children: [
            Row(
              children: <Widget>[
                ImgL.isEmpty
                    ? Container()
                    : ImgL.contains(".svg")
                        ? Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: SvgPicture.asset(
                              "assets/images/$ImgL",
                              height: icoWidth,
                              width: icoWidth,
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: Image.asset(
                              "assets/images/$ImgL.png",
                              height: icoWidth,
                              width: icoWidth,
                            ),
                          ),
                Expanded(
                  child: Container(
                      padding: EdgeInsets.only(left: 10, top: mTop),
                      height: wHeight,
                      child: Text(
                        wTextL,
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        style: gColors.bodySaisie_B_B,
                      )),
                ),
                SvgPicture.asset(
                  "assets/images/DCL_FlD.svg",
                  height: 40,
                  width: 40,
                ),
                Container(
                  width: 6,
                ),
              ],
            ),
            if (bLigne) gColors.wLigne(),
          ],
        ));
  }
}
