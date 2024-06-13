import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_ImportExport.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Interventions.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Param.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Sites.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Ent.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'dart:async';

class Client_Intervention_Status_Dialog {
  Client_Intervention_Status_Dialog();
  static Future<void> Dialogs_Intervention_Status(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => Client_InterventionStatusDialog(),
    );
  }
}

//**********************************
//**********************************
//**********************************

class Client_InterventionStatusDialog extends StatefulWidget {
  const Client_InterventionStatusDialog({
    Key? key,
  }) : super(key: key);
  @override
  _Client_InterventionStatusDialogState createState() => _Client_InterventionStatusDialogState();
}

class _Client_InterventionStatusDialogState extends State<Client_InterventionStatusDialog> {

  static List<String> ListParam_Status = [];
  static List<String> ListParam_StatusID = [];
  String wStatus = "";
  String wStatusID = "";




  void Reload() async {
    setState(() {});
  }

  @override
  void initLib() async {
    ListParam_Status.clear();
      for (int i = 0; i < Srv_DbTools.ListParam_ParamAll.length; i++) {
        Param_Param element = Srv_DbTools.ListParam_ParamAll[i];
        if (element.Param_Param_Type.compareTo("Status_Interv") == 0) {
          if (element.Param_Param_ID.compareTo("Base") != 0) {
            ListParam_Status.add(element.Param_Param_Text);
            ListParam_StatusID.add(element.Param_Param_ID);
          }
        }
    };
    wStatus = ListParam_Status[0];
    wStatusID = ListParam_StatusID[0];


    print("wStatus $wStatus");
      print("wStatusID $wStatusID");
      print("wStatus ${Srv_DbTools.gIntervention.Intervention_Status}");


    for (int i = 0; i < ListParam_StatusID.length; i++) {
      String element = ListParam_StatusID[i];
      if (element == Srv_DbTools.gIntervention.Intervention_Status) {
        wStatus = ListParam_Status[i];
        wStatusID = ListParam_StatusID[i];
        break;
      }
    };



    Reload();
  }

  @override
  void initState() {
    initLib();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.white,
      backgroundColor: gColors.white,

      titlePadding: const EdgeInsets.fromLTRB(0, 20, 0, 0),


      title: Container(
        color: gColors.white,
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
        child: Column(
          children: [

            Container(
              width: 500,
              child: Text(
                "Changement de statut",
                style: gColors.bodyTitle1_B_G_20,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: 15,
            ),
            Container(
              color: gColors.black,
              height: 1,
            ),
          ],
        ),
      ),


      contentPadding: EdgeInsets.zero,
      content:
      ListParam_Status.length == 0
          ? Container()
          : Container(

        width: 50.0,
        height: 380,
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        child:

        Column(children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: ListParam_Status.length,
            itemBuilder: (BuildContext context, int index) {
              final item = ListParam_Status[index];

              return InkWell(
                  onTap: () async {
                    await HapticFeedback.vibrate();
                    wStatus = item;
                    wStatusID = ListParam_StatusID[index];
                    setState(() {});
                  },
                  child:


                  Container(
                      decoration: BoxDecoration(
                        color: (item.compareTo(wStatus) == 0) ? gColors.primaryGreen : Colors.transparent,
                        border: Border.all(
                          color: (item.compareTo(wStatus) == 0) ? gColors.primaryGreen : Colors.transparent,
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
                                color: (item.compareTo(wStatus) == 0) ? gColors.white : gColors.primary,
                              ))
                        ],
                      ))
              );
            },
          ),
          Container(
            height: 10,
          ),

          Container(
            color: gColors.black,
            height: 1,
          ),

        ],)


      ),

      actionsPadding: const EdgeInsets.fromLTRB(0, 0, 20, 5),

      actions: <Widget>[

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: gColors.primaryRed,
          ),
          child: Text(
            "Annuler",
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: gColors.primaryGreen,
              side: const BorderSide(
                width: 1.0,
                color: gColors.primaryGreen,
              )),
          child: Text(
            "Valider",
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          onPressed: () async {

          Srv_DbTools.gIntervention.Intervention_Status = wStatusID;
          await Srv_ImportExport.Intervention_Export_Update(Srv_DbTools.gIntervention);

    Navigator.pop(context);
          },
        )
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



//***************************
//***************************
//***************************
}
