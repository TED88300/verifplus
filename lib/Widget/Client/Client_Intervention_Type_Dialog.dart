import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Interventions.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Sites.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Ent.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'dart:async';

class Client_Intervention_Type_Dialog {
  Client_Intervention_Type_Dialog();
  static Future<void> Dialogs_Intervention_Type(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => Client_InterventionTypeDialog(),
    );
  }
}

//**********************************
//**********************************
//**********************************

class Client_InterventionTypeDialog extends StatefulWidget {
  const Client_InterventionTypeDialog({
    Key? key,
  }) : super(key: key);
  @override
  _Client_InterventionTypeDialogState createState() => _Client_InterventionTypeDialogState();
}

class _Client_InterventionTypeDialogState extends State<Client_InterventionTypeDialog> {
//  String DbTools.ParamTypeOg = "";
//  List<String> subLibArray = [];

  bool ModeAjout = false;
  String wParamType = "";
  String wParamTypeOg = DbTools.ParamTypeOg;

  void Reload() async {
    setState(() {});
  }

  @override
  void initLib() async {
    Reload();
  }

  @override
  void initState() {
    initLib();
    print("_TypeOrgDialog initState");
  }

  @override
  Widget build(BuildContext context) {
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
                "Selection d'un type d'organe",
                style: gColors.bodyTitle1_B_G_20,
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
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 30,
                        ),
                        Liste(context),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                color: gColors.black,
                height: 1,
              ),
            ],
          )),
      actions: <Widget>[
        Container(
          height: 8,
        ),
      ],
    );
  }

  //*********************
  //*********************
  //*********************

  ScrollController scrollController = ScrollController(initialScrollOffset: 0);

  void _scrollToBottom(double index) {
    print("scrollController.position.maxScrollExtent ${scrollController.position.maxScrollExtent}");
    if (scrollController.hasClients) {
      double ii = 27.0 * (index);

      scrollController.animateTo(ii, //scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 1300),
          curve: Curves.elasticOut);
    } else {
      Timer(Duration(milliseconds: 1400), () => _scrollToBottom(index));
    }
  }

  Widget Liste(BuildContext context) {
    List<String> lIntervention = [
      "Tous les types d'organe",
    ];
    print("elementCount ${Srv_DbTools.ListIntervention.length} ");
    double index = 0;

    for (int i = 0; i < Srv_DbTools.ListIntervention.length; i++) {
      Intervention wIntervention = Srv_DbTools.ListIntervention[i];

      if (lIntervention.indexOf(wIntervention.Intervention_Parcs_Type!) == -1) {
        lIntervention.add(wIntervention.Intervention_Parcs_Type!);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom(index));

    return Column(
      children: [
        Container(
          height: 370,
          width: 530,
          decoration: BoxDecoration(
            color: gColors.white,
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    itemCount: lIntervention.length,
                    itemBuilder: (context, index) {
                      final item = lIntervention[index];
                      return InkWell(
                          onTap: () async {
                            await HapticFeedback.vibrate();
                            print("scrollController index $index ${scrollController.position}");
                            Srv_DbTools.gSelIntervention = item;
                            Navigator.of(context).pop();
                          },
                          child:
                              Container(
                                  decoration: BoxDecoration(
                                    color: (item.compareTo(Srv_DbTools.gSelIntervention) == 0) ? gColors.primaryGreen : Colors.transparent,
                                    border: Border.all(
                                      color: (item.compareTo(Srv_DbTools.gSelIntervention) == 0) ? gColors.primaryGreen : Colors.transparent,
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
                                          textAlign: TextAlign.center,
                                          style: gColors.bodyTitle1_B_Gr.copyWith(
                                            color: (item.compareTo(Srv_DbTools.gSelIntervention) == 0) ? gColors.white : gColors.primary,
                                          ))
                                    ],
                                  )));
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  //***************************
  //***************************
  //***************************
}
