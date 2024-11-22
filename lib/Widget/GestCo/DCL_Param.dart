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

class DCL_Param_Dialog {
  DCL_Param_Dialog();

  static String wSel = "";
  static List<String> ListParam = [];

  static Future<void> Dialogs_DCL_Param(BuildContext context, String wTitre) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => DCLParamDialog(wTitre: wTitre),
    );
  }
}

//**********************************
//**********************************
//**********************************

class DCLParamDialog extends StatefulWidget {
  final String wTitre;
  const DCLParamDialog({Key? key, required this.wTitre}) : super(key: key);

  @override
  _DCLParamDialogState createState() => _DCLParamDialogState();
}

class _DCLParamDialogState extends State<DCLParamDialog> {
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
  }

  @override
  Widget build(BuildContext context) {
    print(" Srv_DbTools.SelDCL_DateDeb ${Srv_DbTools.SelDCL_DateDeb}");

    return SimpleDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.transparent,
      backgroundColor: gColors.transparent,
      shadowColor: gColors.transparent,
      children: [
        Stack(
          children: [
            Container(
                color: gColors.transparent,
                height: 700,
                child: Column(
                  children: [
// Titre
                    Container(
                        child: Container(
                      width: 400,
                      height: 90,
                      padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                      decoration: BoxDecoration(
                        color: Colors.yellowAccent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 500,
                            child: Text(
                              widget.wTitre,
                              style: gColors.bodyTitle1_B_G,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            height: 25,
                          ),
                          Container(
                            color: gColors.black,
                            height: 1,
                          ),
                        ],
                      ),
                    )),

                    Container(
                      height: 474,
                    ),

// Pied
                    Container(
                        child: Container(
                      width: 400,
                      height: 90,
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      decoration: BoxDecoration(
                        color: gColors.LinearGradient3,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: gColors.black,
                            height: 1,
                          ),
                          Container(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: gColors.primaryRed,
                                ),
                                child: Container(
                                  width: 140,
                                  height: 40,
                                  padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                                  child: Text(
                                    "Annuler",
                                    style: gColors.bodyTitle1_B_W24,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                onPressed: () async {
                                  DCL_Param_Dialog.wSel = "";
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
                                child: Container(
                                  width: 140,
                                  height: 40,
                                  padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                                  child: Text(
                                    "Valider",
                                    style: gColors.bodyTitle1_B_W24,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                onPressed: () async {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    )),
                  ],
                )),
            Positioned(
              top: 79,
              left: 24,
              child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  height: 500,
                  width: 400,
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: DCL_Param_Dialog.ListParam.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = DCL_Param_Dialog.ListParam[index];

                          return InkWell(
                              onTap: () async {
                                await HapticFeedback.vibrate();
                                DCL_Param_Dialog.wSel = item;
                                setState(() {});
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: (item.compareTo(DCL_Param_Dialog.wSel) == 0) ? gColors.primaryGreen : Colors.transparent,
                                    border: Border.all(
                                      width: 0.7,
                                      color: (item.compareTo(DCL_Param_Dialog.wSel) == 0) ? gColors.primaryGreen : gColors.grey,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                  margin: EdgeInsets.fromLTRB(50, 0, 50, 10), // TED
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0), // TED
                                  height: 40,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(item,
                                          textAlign: TextAlign.left,
                                          maxLines: 1,
                                          style: gColors.bodyTitle1_B_Gr.copyWith(
                                            color: (item.compareTo(DCL_Param_Dialog.wSel) == 0) ? gColors.white : gColors.primary,
                                            fontWeight: (item.compareTo(DCL_Param_Dialog.wSel) == 0) ? FontWeight.bold : FontWeight.normal,
                                          ))
                                    ],
                                  )));
                        },
                      ),


                    ],
                  )),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget buildvp(BuildContext context) {
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
                widget.wTitre,
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
      content: DCL_Param_Dialog.ListParam.length == 0
          ? Container()
          : Container(
              width: 50.0,
              height: 430,
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: DCL_Param_Dialog.ListParam.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = DCL_Param_Dialog.ListParam[index];

                      return InkWell(
                          onTap: () async {
                            await HapticFeedback.vibrate();
                            DCL_Param_Dialog.wSel = item;
                            setState(() {});
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                color: (item.compareTo(DCL_Param_Dialog.wSel) == 0) ? gColors.primaryGreen : Colors.transparent,
                                border: Border.all(
                                  color: (item.compareTo(DCL_Param_Dialog.wSel) == 0) ? gColors.primaryGreen : Colors.transparent,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0), // TED
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
                                        color: (item.compareTo(DCL_Param_Dialog.wSel) == 0) ? gColors.white : gColors.primary,
                                      ))
                                ],
                              )));
                    },
                  ),
                  Container(
                    height: 10,
                  ),
                  Container(
                    color: gColors.black,
                    height: 1,
                  ),
                ],
              )),
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
            DCL_Param_Dialog.wSel = "";
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
            Navigator.pop(context);
          },
        )
      ],
    );
  }

//***************************
//***************************
//***************************
}
