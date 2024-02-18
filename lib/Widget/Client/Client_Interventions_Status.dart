import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Interventions.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';

class Client_Interventions_Status {
  Client_Interventions_Status();
  static Future<void> Dialogs_Status(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => Client_InterventionsStatus(),
    );
  }
}

//**********************************
//**********************************
//**********************************

class Client_InterventionsStatus extends StatefulWidget {
  @override
  _Client_InterventionsStatusState createState() => _Client_InterventionsStatusState();
}

class _Client_InterventionsStatusState extends State<Client_InterventionsStatus> {
  ScrollController scrollController = ScrollController(initialScrollOffset: 0);

  static List<String> ListParam_FiltreFam = [];
  static List<String> ListParam_FiltreFamID = [];

  String Fam = "";
  String FamID = "";

  bool isNew = false;

  Intervention newIntervention = Intervention.InterventionInit();
  Intervention LastIntervention = Intervention.InterventionInit();

  @override
  void initLib() async {
    if (Srv_DbTools.ListIntervention.length == 0) {
      isNew = true;
    } else {
      LastIntervention = Srv_DbTools.ListIntervention[0];
    }

    await Srv_DbTools.getParam_ParamAll();
    ListParam_FiltreFam.clear();
    ListParam_FiltreFamID.clear();

    Srv_DbTools.ListParam_ParamAll.forEach((element) {
      //    print("Desc ${element.Desc()}");
      if (element.Param_Param_Type.compareTo("Status_Interv") == 0) {
        ListParam_FiltreFam.add(element.Param_Param_Text);
        ListParam_FiltreFamID.add(element.Param_Param_ID);

        if (element.Param_Param_Text.compareTo(Srv_DbTools.gIntervention.Intervention_Status!) == 0) {
          Fam = element.Param_Param_Text;
          FamID = element.Param_Param_ID;
        }
      }
    });

    print("ListParam_FiltreFam isNew ${isNew} ");

    print("ListParam_FiltreFam isNew ${isNew} ${newIntervention.Intervention_Type}");

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
              width: 500,
              child: Text(
                "Intervention : ${Srv_DbTools.gIntervention.Intervention_Status}",
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
        height: 400,
        child: Column(
          children: [
            Container(
              color: gColors.black,
              height: 1,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 500,
                        child: Text(
                          "Status des interventions",
                          style: gColors.bodyTitle1_B_G,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  ListParam_FiltreFam.length == 0
                      ? Container()
                      : Container(
                          height: 300.0, // Change as per your requirement
                          width: 300.0, // Change as per your requirement
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: ListParam_FiltreFam.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = ListParam_FiltreFam[index];

                              return InkWell(
                                  onTap: () async {
                                    await HapticFeedback.vibrate();
                                    Fam = item;
                                    setState(() {});
                                  },
                                  child: Container(
                                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10), // TED
                                      color: (item.compareTo(Fam) == 0) ? gColors.primaryGreen : Colors.transparent,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(item,
                                              textAlign: TextAlign.center,
                                              style: gColors.bodyTitle1_B_Gr.copyWith(
                                                color: (item.compareTo(Fam) == 0) ? gColors.white : gColors.primary,
                                              ))
                                        ],
                                      )));
                            },
                          ),
                        ),
                ],
              ),
            ),
            const Spacer(),
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
              Srv_DbTools.gIntervention.Intervention_Status = Fam;
              Srv_DbTools.setIntervention(Srv_DbTools.gIntervention);
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
