import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Interventions.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Parcs_Desc.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Parcs_Ent.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Ent.dart';

import 'package:verifplus/Widget/Widget_Tools/gColors.dart';

// Freq
// Année ....

class Client_Interventions_Add {
  Client_Interventions_Add();
  static Future<void> Dialogs_Add(BuildContext context, bool isNew) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => Client_InterventionsAdd(isNew: isNew),
    );
  }
}

//**********************************
//**********************************
//**********************************

class Client_InterventionsAdd extends StatefulWidget {
  bool isNew = false;
  Client_InterventionsAdd({
    Key? key,
    required this.isNew,
  }) : super(key: key);

  @override
  _Client_InterventionsAddState createState() => _Client_InterventionsAddState();
}

class _Client_InterventionsAddState extends State<Client_InterventionsAdd> {
  ScrollController scrollController = ScrollController(initialScrollOffset: 0);

  static List<String> ListParam_Type = [];
  String wType = "";

  static List<String> ListParam_Org = [];
  static List<String> ListParam_OrgID = [];
  String wOrg = "";
  String wOrgID = "";

  @override
  void initLib() async {
    await DbTools.getParam_Param();

    ListParam_Type.clear();
    Srv_DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("Type_Interv") == 0) {
        ListParam_Type.add(element.Param_Param_Text);
      }
    });
    wType = ListParam_Type[0];
    print("ListParam_Type  ${wType}");

    ListParam_Org.clear();
    Srv_DbTools.ListParam_ParamAll.forEach((element) {
      if (element.Param_Param_Type.compareTo("Type_Organe") == 0) {
        if (element.Param_Param_ID.compareTo("Base") != 0) {
          ListParam_Org.add(element.Param_Param_Text);
          ListParam_OrgID.add(element.Param_Param_ID);
        }
      }
    });
    wOrg = ListParam_Org[0];
    wOrgID = ListParam_OrgID[0];

    print("Type_Organe isNew ${widget.isNew} ${wOrg}");

    setState(() {});
  }

  @override
  void initState() {
    initLib();
  }

  Widget setupAlertDialoadContainer() {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('Gujarat, India'),
          );
        },
      ),
    );
  }

  double SelHeight = 380;
  @override
  Widget ListeInterv(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 50,
                child: Text(
                  "Type d'intervention",
                  style: gColors.bodyTitle1_B_G,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          ListParam_Type.length == 0
              ? Container()
              : Container(
                  width: 220.0, // Change as per your requirement
                  height: SelHeight, // Change as per your requirement
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: ListParam_Type.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = ListParam_Type[index];

                      return InkWell(
                          onTap: () async {
                            await HapticFeedback.vibrate();
                            wType = item;
                            setState(() {});
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                color: (item.compareTo(wType) == 0) ? gColors.primaryGreen : Colors.transparent,
                                border: Border.all(
                                  color: (item.compareTo(wType) == 0) ? gColors.primaryGreen : Colors.transparent,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                              padding: EdgeInsets.fromLTRB(10, 15, 10, 5), // TED
                              height: 45,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item,
                                      textAlign: TextAlign.left,
                                      style: gColors.bodyTitle1_B_Gr.copyWith(
                                        color: (item.compareTo(wType) == 0) ? gColors.white : gColors.primary,
                                      ))
                                ],
                              )));
                    },
                  ),
                ),
        ],
      ),
    );
  }

  @override
  Widget ListeOrg(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 280,
                height: 50,
                child: Text(
                  "Type d'organe",
                  style: gColors.bodyTitle1_B_G,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          ListParam_Org.length == 0
              ? Container()
              : Container(
                  width: 280.0,
                  height: SelHeight,
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: ListParam_Org.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = ListParam_Org[index];

                      return InkWell(
                          onTap: () async {
                            await HapticFeedback.vibrate();
                            wOrg = item;
                            wOrgID = ListParam_OrgID[index];

                            setState(() {});
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                color: (item.compareTo(wOrg) == 0) ? gColors.primaryGreen : Colors.transparent,
                                border: Border.all(
                                  color: (item.compareTo(wOrg) == 0) ? gColors.primaryGreen : Colors.transparent,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                              padding: EdgeInsets.fromLTRB(10, 15, 10, 5), // TED
                              height: 45,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item,
                                      textAlign: TextAlign.left,
                                      maxLines: 1,
                                      style: gColors.bodyTitle1_B_Gr.copyWith(
                                        color: (item.compareTo(wOrg) == 0) ? gColors.white : gColors.primary,
                                      ))
                                ],
                              )));
                    },
                  ),
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget Ctrl = Container();

    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.white,
      backgroundColor: gColors.white,
      title: Container(
        color: gColors.white,
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
        child: Column(
          children: [
            Container(
              height: 5,
            ),
            Container(
              width: 600,
              child: Text(
                "Intervention : Création",
                style: gColors.bodyTitle1_B_G32,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      contentPadding: EdgeInsets.zero,
      content: Container(
        color: gColors.greyLight,
        height: 500,
        child: Column(
          children: [
            Container(
              color: gColors.black,
              height: 1,
            ),
            Row(
              children: [
                Spacer(),
                ListeInterv(context),
                !widget.isNew ? Container() : Spacer(),
                !widget.isNew ? Container() : ListeOrg(context),
                Spacer(),
              ],
            ),
            Spacer(),
            Valider(context),
            Container(
              color: gColors.black,
              height: 1,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Container(
          height: 8,
        ),
      ],
    );
  }

  //**********************************
  //**********************************
  //**********************************

  Widget Valider(BuildContext context) {
    return Container(
      width: 440,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
//          Text(widget.param_Saisie.Param_Saisie_Controle),
          Container(
            color: gColors.primary,
            width: 8,
          ),
          new ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: gColors.primaryRed,
            ),
            child: Text('Annuler', style: gColors.bodyTitle1_B_W),
          ),
          Container(
            color: gColors.primary,
            width: 8,
          ),
          new ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();

              var now = new DateTime.now();
              var formatter = new DateFormat('dd/MM/yyyy');
              String formattedDate = formatter.format(now);

              Srv_DbTools.gIntervention = Intervention.InterventionInit();
              bool wRet = await Srv_DbTools.addIntervention(Srv_DbTools.gSite.SiteId);
              Srv_DbTools.gIntervention.Intervention_isUpdate = wRet;
              if (!wRet) Srv_DbTools.gLastID = new DateTime.now().millisecondsSinceEpoch * -1;
              print("ADD Srv_DbTools.gLastID ${Srv_DbTools.gLastID}");
              print("ADD ");
              Srv_DbTools.gIntervention.InterventionId = Srv_DbTools.gLastID;
              Srv_DbTools.gIntervention.Intervention_ZoneId = Srv_DbTools.gZone.ZoneId;
              Srv_DbTools.gIntervention.Intervention_Type = wType;
              Srv_DbTools.gIntervention.Intervention_Parcs_Type = wOrgID;
              Srv_DbTools.gIntervention.Intervention_Date = formattedDate;
              Srv_DbTools.gIntervention.Livr = "";
              Srv_DbTools.gSelIntervention = wOrgID;

              await DbTools.inserInterventions(Srv_DbTools.gIntervention);
              if (wRet) await Srv_DbTools.setIntervention(Srv_DbTools.gIntervention);

              if (widget.isNew) {
                Parc_Ent wParc_Ent = Parc_Ent.Parc_EntInit(Srv_DbTools.gIntervention.InterventionId!, wOrgID, 1);
                await DbTools.insertParc_Ent(wParc_Ent);
                await Srv_DbTools.InsertUpdateParc_Ent_Srv(wParc_Ent);
              }
              else {
                Intervention LastIntervention = Srv_DbTools.gIntervention;
                await Srv_DbTools.getParcs_DescInter(LastIntervention.InterventionId!);
                print("LastIntervention ${LastIntervention.InterventionId} ${Srv_DbTools.ListParc_Desc.length}");

                await Srv_DbTools.getParc_EntID(LastIntervention.InterventionId!);
                for (int i = 0; i < Srv_DbTools.ListParc_Ent.length; i++) {
                  Parc_Ent_Srv wParc_Ent_Srv = Srv_DbTools.ListParc_Ent[i];

                  if (wParc_Ent_Srv.Action!.compareTo("ES") == 0) continue;
                  if (wParc_Ent_Srv.Action!.compareTo("REFO") == 0) continue;

                  print(">>>>>>>>>>>>>>>>>>>> wParc_Ent_Srv ${wParc_Ent_Srv.toMap()}");
                  wParc_Ent_Srv.Parcs_InterventionId = Srv_DbTools.gIntervention.InterventionId;
                  var uuid = Uuid();
                  String uuidv1 = uuid.v1();
                  print("insertParc_Ent uuidv1 ${uuidv1}");
                  wParc_Ent_Srv.Parcs_UUID = uuidv1;
                  wParc_Ent_Srv.Parcs_UUID_Parent = "";
                  wParc_Ent_Srv.Action = "";
                  wParc_Ent_Srv.Livr = "";
                  wParc_Ent_Srv.Devis = "";
                  wParc_Ent_Srv.Parcs_Date_Rev = "";

                  print("wParc_Ent_Srv.Livr ${wParc_Ent_Srv.Livr}");
                  await Srv_DbTools.InsertUpdateParc_Ent_Srv_Srv(wParc_Ent_Srv);
                  int newParcsDesc_ParcsIdSrv = Srv_DbTools.gLastID;
                  await DbTools.insertParc_Ent_Srv(wParc_Ent_Srv);
                  int newParcsDesc_ParcsId = DbTools.gLastID;
                  Srv_DbTools.getParc_DescID(wParc_Ent_Srv.ParcsId!);
                  var lParc_Desc_Srv = Srv_DbTools.ListParc_Desc.where((element) => element.ParcsDesc_ParcsId == wParc_Ent_Srv.ParcsId);
                  print("lParc_Desc_Srv ${lParc_Desc_Srv.length}");
                  await Srv_DbTools.getParam_Saisie(wParc_Ent_Srv.Parcs_Type!, "Desc");
                  for (int i = 0; i < Srv_DbTools.ListParc_Desc.length; i++) {
                    print("wParc_Desc_Srv i ${i}");
                    Parc_Desc_Srv wParc_Desc_Srv = Srv_DbTools.ListParc_Desc[i];

                    var wListParam_Saisie = Srv_DbTools.ListParam_Saisie.where((element) => element.Param_Saisie_ID == wParc_Desc_Srv.ParcsDesc_Type);
                    print("wListParam_Saisie ${wParc_Desc_Srv.ParcsDesc_Type} ${wListParam_Saisie.length}");

                    if (wListParam_Saisie.length > 0) {
                      if (wParc_Desc_Srv.ParcsDesc_ParcsId == wParc_Ent_Srv.ParcsId) {
                        wParc_Desc_Srv.ParcsDesc_ParcsId = newParcsDesc_ParcsIdSrv;
                        print("wParc_Desc_Srv  ${wParc_Desc_Srv.toMap()}");
                        await Srv_DbTools.InsertUpdateParc_Desc_Srv_Srv(wParc_Desc_Srv);
                        print("wParc_Desc_Srv gLastID ${Srv_DbTools.gLastID} ");
                        wParc_Desc_Srv.ParcsDesc_ParcsId = newParcsDesc_ParcsId;
                        await DbTools.insertParc_Desc_Srv(wParc_Desc_Srv);
                      }
                    }
                  }
                }
              }
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: gColors.primaryGreen,
                side: const BorderSide(
                  width: 1.0,
                  color: gColors.primaryGreen,
                )),
            child: Text('Valider', style: gColors.bodyTitle1_B_W),
          ),
        ],
      ),
    );
  }
}
