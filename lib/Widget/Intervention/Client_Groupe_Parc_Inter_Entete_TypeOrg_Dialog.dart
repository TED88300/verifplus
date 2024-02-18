import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Ent.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'dart:async';

class Client_Groupe_Parc_Inter_Entete_TypeOrg_Dialog {
  Client_Groupe_Parc_Inter_Entete_TypeOrg_Dialog();
  static Future<void> Dialogs_TypeOrg(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => Client_Groupe_Parc_Inter_Entete_TypeOrgDialog(),
    );
  }
}

//**********************************
//**********************************
//**********************************

class Client_Groupe_Parc_Inter_Entete_TypeOrgDialog extends StatefulWidget {
  const Client_Groupe_Parc_Inter_Entete_TypeOrgDialog({
    Key? key,
  }) : super(key: key);
  @override
  _Client_Groupe_Parc_Inter_Entete_TypeOrgDialogState createState() => _Client_Groupe_Parc_Inter_Entete_TypeOrgDialogState();
}

class _Client_Groupe_Parc_Inter_Entete_TypeOrgDialogState extends State<Client_Groupe_Parc_Inter_Entete_TypeOrgDialog> {
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
    DbTools.getParcs_EntCount();

    DbTools.lParc_Ent_CountUsed.clear();
    DbTools.lParc_Ent_CountUnUsed.clear();
    DbTools.lParc_Ent_CountAll.forEach((elementCount) {
      if (elementCount.ParamTypeOg_count == 0)
        DbTools.lParc_Ent_CountUnUsed.add(elementCount);
      else
        DbTools.lParc_Ent_CountUsed.add(elementCount);
    });
    DbTools.lParc_Ent_CountAff.clear();
    DbTools.lParc_Ent_CountAff.addAll(DbTools.lParc_Ent_CountUsed);

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
              child: ModeAjout ? Text("Ajout d'un organe", style: gColors.bodyTitle1_B_G_20, textAlign: TextAlign.center,) :
                          Text("Selection du type d'organe", style: gColors.bodyTitle1_B_G_20, textAlign: TextAlign.center,),
            ),
          ],
        ),
      ),
      contentPadding: EdgeInsets.zero,
      content: Container(
          color: gColors.greyLight,
          height: 420,
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
                        ModeAjout ? ListeAjout(context) : Liste(context),
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

  //**********************************
  //**********************************
  //**********************************

  Widget Valider(BuildContext context) {
    return Container(
      width: 450,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          ModeAjout
              ? Container()
              : IconButton(
                  padding: new EdgeInsets.all(0),
                  icon: Icon(
                    Icons.add_box,
                    color: gColors.primaryGreen,
                    size: 46,
                  ),
                  onPressed: () async {
                    await HapticFeedback.vibrate();
                    ModeAjout = true;
                    DbTools.lParc_Ent_CountAff.clear();
                    DbTools.lParc_Ent_CountAff.addAll(DbTools.lParc_Ent_CountUnUsed);


                    wParamTypeOg = DbTools.lParc_Ent_CountAff[0].ParamTypeOg;
                    wParamType = DbTools.lParc_Ent_CountAff[0].ParamType;



                    setState(() {});
                  },
                ),
          ModeAjout ? Container() : Spacer(),
          new ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: gColors.primaryRed,
            ),
            child: Text('Annuler', style: gColors.bodyTitle1_N_W),
          ),
          Container(
            color: gColors.primary,
            width: 8,
          ),
          new ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();
              DbTools.ParamTypeOg = wParamTypeOg;

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

  //**********************************
  //**********************************
  //**********************************

  Widget ValiderAjout(BuildContext context) {
    return Container(
      width: 450,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          ModeAjout
              ? Container()
              : IconButton(
            padding: new EdgeInsets.all(0),
            icon: Icon(
              Icons.add_box,
              color: gColors.primaryGreen,
              size: 46,
            ),
            onPressed: () async {
              await HapticFeedback.vibrate();
              ModeAjout = true;
              setState(() {});
            },
          ),
          ModeAjout ? Container() : Spacer(),
          new ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();

              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: gColors.primaryRed,
            ),
            child: Text('Annuler', style: gColors.bodyTitle1_N_W),
          ),
          Container(
            color: gColors.primary,
            width: 8,
          ),
          new ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();
              DbTools.ParamTypeOg = wParamTypeOg;
              Parc_Ent wParc_Ent = Parc_Ent.Parc_EntInit(Srv_DbTools.gIntervention.InterventionId!, wParamType, 1);

              DbTools.insertParc_Ent(wParc_Ent);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: gColors.primaryGreen,
                side: const BorderSide(
                  width: 1.0,
                  color: gColors.primaryGreen,
                )),
            child: Text('Ajouter', style: gColors.bodyTitle1_B_W),
          ),
        ],
      ),
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


    print("elementCount ${DbTools.lParc_Ent_CountAll.length} ${DbTools.lParc_Ent_CountUnUsed.length} ${DbTools.lParc_Ent_CountUsed.length} ${DbTools.lParc_Ent_CountAff.length}");

    double index = 0;

    for (int i = 0; i < DbTools.lParc_Ent_CountAff.length; i++) {
      if (DbTools.lParc_Ent_CountAff[i].ParamTypeOg.compareTo(wParamTypeOg) == 0) {
        index = double.parse("${i}");
        break;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom(index));

    return Column(
      children: [
        Container(
          height: 350,
          width: 500,
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
                    itemCount: DbTools.lParc_Ent_CountAff.length,
                    itemBuilder: (context, index) {
                      final item = DbTools.lParc_Ent_CountAff[index];
                      return InkWell(
                          onTap: () async {
                            await HapticFeedback.vibrate();
                            print("scrollController index $index ${scrollController.position}");
                            wParamTypeOg = item.ParamTypeOg;
                            wParamType = item.ParamType;

                            setState(() {});
                          },
                          child: Container(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5), // TED
                              color: (item.ParamTypeOg.compareTo(wParamTypeOg) == 0) ? gColors.primaryGreen : Colors.transparent,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        child: Text("${item.ParamTypeOg_count}",
                                            textAlign: TextAlign.center,
                                            style: gColors.bodyTitle1_B_Gr.copyWith(
                                              color: (item.ParamTypeOg.compareTo(wParamTypeOg) == 0) ? gColors.white : gColors.primary,
                                            )),
                                      ),

                                      Container(
                                        child: Text(item.ParamTypeOg,
                                            textAlign: TextAlign.center,
                                            style: gColors.bodyTitle1_B_Gr.copyWith(
                                              color: (item.ParamTypeOg.compareTo(wParamTypeOg) == 0) ? gColors.white : gColors.primary,
                                            )),
                                      ),
                                    ],
                                  )
                                ],
                              )));
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        Valider(context),
      ],
    );
  }

  //***************************
  //***************************
  //***************************



  Widget ListeAjout(BuildContext context) {
    double index = 0;

    print("elementCount ajout ${DbTools.lParc_Ent_CountAll.length} ${DbTools.lParc_Ent_CountUnUsed.length} ${DbTools.lParc_Ent_CountUsed.length} ${DbTools.lParc_Ent_CountAff.length}");


    for (int i = 0; i < DbTools.lParc_Ent_CountAff.length; i++) {
      if (DbTools.lParc_Ent_CountAff[i].ParamTypeOg.compareTo(wParamTypeOg) == 0) {
        index = double.parse("${i}");
        break;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom(index));

    return Column(
      children: [
        Container(
          height: 350,
          width: 500,
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
                    itemCount: DbTools.lParc_Ent_CountAff.length,
                    itemBuilder: (context, index) {
                      final item = DbTools.lParc_Ent_CountAff[index];
                      return InkWell(
                          onTap: () async {
                            await HapticFeedback.vibrate();

                            print("scrollController index $index ${scrollController.position}");
                            wParamTypeOg = item.ParamTypeOg;
                            wParamType = item.ParamType;

                            setState(() {});
                          },
                          child: Container(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5), // TED
                              color: (item.ParamTypeOg.compareTo(wParamTypeOg) == 0) ? gColors.primaryGreen : Colors.transparent,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        child: Text(item.ParamTypeOg,
                                            textAlign: TextAlign.center,
                                            style: gColors.bodyTitle1_B_Gr.copyWith(
                                              color: (item.ParamTypeOg.compareTo(wParamTypeOg) == 0) ? gColors.white : gColors.primary,
                                            )),
                                      ),
                                    ],
                                  )
                                ],
                              )));
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        ValiderAjout(context),
      ],
    );
  }








}
