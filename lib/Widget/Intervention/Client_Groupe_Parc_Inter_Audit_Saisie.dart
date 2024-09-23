import 'dart:async';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Parcs_Desc.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Desc.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';

class Client_Groupe_Parc_Inter_Audit_Saisie_Dialog {
  Client_Groupe_Parc_Inter_Audit_Saisie_Dialog();

  static Future<void> Dialogs_Saisie(
    BuildContext context,
    VoidCallback onSaisie,
    Param_Saisie param_Saisie,
    Parc_Desc parc_Desc,
  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => Client_Groupe_Parc_Inter_Audit_SaisieDialog(
        onSaisie: onSaisie,
        param_Saisie: param_Saisie,
        parc_Desc: parc_Desc,
      ),
    );
  }
}

//**********************************
//**********************************
//**********************************

class Client_Groupe_Parc_Inter_Audit_SaisieDialog extends StatefulWidget {
  final VoidCallback onSaisie;
  final Param_Saisie param_Saisie;
  final Parc_Desc parc_Desc;

  const Client_Groupe_Parc_Inter_Audit_SaisieDialog({Key? key, required this.onSaisie, required this.param_Saisie, required this.parc_Desc}) : super(key: key);

  @override
  Client_Groupe_Parc_Inter_Audit_SaisieDialogState createState() => Client_Groupe_Parc_Inter_Audit_SaisieDialogState();
}

class Client_Groupe_Parc_Inter_Audit_SaisieDialogState extends State<Client_Groupe_Parc_Inter_Audit_SaisieDialog> {
  String wAide = "";
  bool wEditFocus = false;

  Widget wIco = Container();

  TextEditingController tec_Search = TextEditingController();
  TextEditingController tec_Saisie = TextEditingController();

  String initParcsDesc_Lib = "";
  String initParcsDesc_Id = "";

  Future Reload() async {
    Srv_DbTools.getParam_Saisie_ParamMem(widget.param_Saisie.Param_Saisie_ID);
    print("${widget.param_Saisie.Param_Saisie_ID} ListParam_Saisie_Param lenght  ${Srv_DbTools.ListParam_Saisie_Param.length}");
    setState(() {});
  }

  @override
  void initLib() async {
    await Reload();
  }

  @override
  void initState() {
    initParcsDesc_Lib = widget.parc_Desc.ParcsDesc_Lib!;
    initParcsDesc_Id = widget.parc_Desc.ParcsDesc_Id!;

//    Widget wAide_Ico = gObj.getAssetImage("assets/images/Ico.png"),

    Srv_DbTools.ListParam_Saisie_Param.clear();

    initializeDateFormatting();
    initLib();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget Ctrl = Container();

    double wDialogHeight = 251;
    int nb = (Srv_DbTools.ListParam_Saisie_Param.length / 3).truncate();
    int modnb = Srv_DbTools.ListParam_Saisie_Param.length % 3;
    int nbL = nb;
    if (modnb > 0) nbL++;
    double wDialogBase = 80;
    double wLigneHeight = 52;

    Ctrl = FlipFlop(context);

    wLigneHeight = 59;
    wDialogHeight = wDialogBase + nbL * wLigneHeight + 44;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.white,
      backgroundColor: gColors.white,
      title: Container(
          color: gColors.white,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
          child: Column(
            children: [
              Text(
                "${widget.param_Saisie.Param_Saisie_Label}",
                textAlign: TextAlign.center,
                style: gColors.bodyTitle1_B_G_20,
              ),
              Text(
                "${widget.param_Saisie.Param_Saisie_Aide}",
                textAlign: TextAlign.center,
                style: gColors.bodyTitle1_N_Gr,
              ),
              Container(
                height: 8,
              ),
            ],
          )),
      contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      content: Container(
          color: gColors.greyLight,
          height: wDialogHeight,
//          width: 600,
          child: Column(
            children: [
              Container(
                color: gColors.black,
                height: 1,
              ),
              Container(
                color: gColors.greyLight,
                padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: Ctrl,
              ),
              Spacer(),
              Container(
                color: gColors.black,
                height: 1,
              ),
              Valider(context),
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
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(5, 10, 10, 0),
      width: 480,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(widget.param_Saisie.Param_Saisie_Controle),
          Container(
            color: gColors.primary,
            width: 8,
          ),
          new ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();
              widget.parc_Desc.ParcsDesc_Lib = initParcsDesc_Lib;
              widget.parc_Desc.ParcsDesc_Id = initParcsDesc_Id;
              widget.onSaisie();
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
              print(" VALIDER AUDIT ${widget.parc_Desc.ParcsDescId} ${widget.parc_Desc.ParcsDesc_Id} ${widget.parc_Desc.ParcsDesc_Lib}");
              await DbTools.updateParc_Desc_NoRaz(widget.parc_Desc, initParcsDesc_Lib);
              widget.onSaisie();
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

  Widget FlipFlop(BuildContext context) {
    List<Widget> Rows = [];

    List<Widget> BtnCards = [];
    int nbBtn = 0;
    wAide = "Aide : ";
    Srv_DbTools.ListParam_Saisie_Param.forEach((element) {
      if (widget.parc_Desc.ParcsDesc_Lib!.compareTo("---") == 0) {
        if (element.Param_Saisie_Param_Default) {
          widget.parc_Desc.ParcsDesc_Lib = element.Param_Saisie_Param_Label;
        }
      }

      //    print("BtnCards.add element ${element.Param_Saisie_ParamId}");
      BtnCards.add(BtnCard(element.Param_Saisie_Param_Label, element.Param_Saisie_Param_Id, element.Param_Saisie_Param_Label.compareTo(widget.parc_Desc.ParcsDesc_Lib!) == 0, element.Param_Saisie_ParamId, element.Param_Saisie_Param_Color));

      if (element.Param_Saisie_Param_Label.compareTo(widget.parc_Desc.ParcsDesc_Lib!) == 0) wAide += element.Param_Saisie_Param_Aide;

      nbBtn++;
      if (nbBtn == 3) {
        nbBtn = 0;
        Row wRow = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: BtnCards,
        );
        Rows.add(wRow);
        BtnCards = [];
      }
    });

    if (nbBtn > 0) {
      nbBtn = 0;
      Row wRow = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: BtnCards,
      );
      Rows.add(wRow);
      BtnCards = [];
    }

    Rows.add(Container(
      width: 410,
      padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            wAide,
//            textAlign: TextAlign.center,
            style: gColors.bodyTitle1_Aide,
            maxLines: 3,
          )
        ],
      ),
    ));

    return Container(
        child: Column(children: [
      Container(
        //     height: 660,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: Rows,
          ),
        ),
      ),
    ]));
  }

  Widget BtnCard(String wText, String wId, bool wSel, int Param_Saisie_ParamId, String color) {
    Color BgColor = gColors.white;
    Color TxtColor = gColors.black;

    if (wSel) {
      BgColor = gColors.primaryGreen;
      TxtColor = gColors.white;
    }

    return new Container(
      width: 160,
      height: 60,
      child: Card(
        color: BgColor,
        elevation: 0.2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0), side: BorderSide(width: 1, color: Colors.grey)),
        child: InkWell(
          onTap: () async {
            await HapticFeedback.vibrate();
            widget.parc_Desc.ParcsDesc_Lib = wText;
            widget.parc_Desc.ParcsDesc_Id = Param_Saisie_ParamId.toString();
            print(" FlipFlop ${widget.parc_Desc.ParcsDesc_Id} ${widget.parc_Desc.ParcsDesc_Lib}");
            await Reload();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                wText,
                textAlign: TextAlign.center,
                style: wSel
                    ? gColors.bodyTitle1_B_Gr.copyWith(
                        color: TxtColor,
                      )
                    : gColors.bodyTitle1_N_Gr.copyWith(
                        color: TxtColor,
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //**********************************
  //**********************************

  ScrollController scrollController = ScrollController(initialScrollOffset: 0);

  void _scrollToBottom(double index) {
    print("scrollController.position.maxScrollExtent ${scrollController.position.maxScrollExtent}");
    if (scrollController.hasClients) {
      double ii = 27.0 * (index);

      scrollController.animateTo(ii, //scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.elasticOut);
    } else {
      Timer(Duration(milliseconds: 400), () => _scrollToBottom(index));
    }
  }

  Widget Liste(BuildContext context) {
    print("tec_Search.text ${tec_Search.text}");
    print("tec_Saisie.text ${tec_Saisie.text}");

    Srv_DbTools.ListParam_Saisie_Paramsearchresult.clear();
    if (tec_Search.text.isEmpty)
      Srv_DbTools.ListParam_Saisie_Paramsearchresult.addAll(Srv_DbTools.ListParam_Saisie_Param);
    else
      Srv_DbTools.ListParam_Saisie_Param.forEach((element) {
        if (element.Param_Saisie_Param_Label.toLowerCase().contains(tec_Search.text.toLowerCase())) {
          Srv_DbTools.ListParam_Saisie_Paramsearchresult.add(element);
        }
      });

    double index = 0;
    for (int i = 0; i < Srv_DbTools.ListParam_Saisie_Paramsearchresult.length; i++) {
      if (Srv_DbTools.ListParam_Saisie_Paramsearchresult[i].Param_Saisie_Param_Label.compareTo(widget.parc_Desc.ParcsDesc_Lib!) == 0) {
        index = double.parse("${i}");
        break;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom(index));

    return Column(
      children: [
        Container(
          height: 40,
          width: 450,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 0,
              bottom: 4,
              right: 0,
              left: 0,
            ),
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  print("value ${value}");
                });
              },
              controller: tec_Search,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                hintText: 'Recherche',
                hintStyle: const TextStyle(fontSize: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
        Container(
          height: 324,
          width: 450,
          decoration: BoxDecoration(
            color: gColors.white,
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: Srv_DbTools.ListParam_Saisie_Paramsearchresult.length,
                  itemBuilder: (context, index) {
                    final item = Srv_DbTools.ListParam_Saisie_Paramsearchresult[index];
                    return InkWell(
                        onTap: () async {
                          await HapticFeedback.vibrate();
                          print("scrollController index $index ${scrollController.position}");
                          widget.parc_Desc.ParcsDesc_Lib = item.Param_Saisie_Param_Label;
                          widget.parc_Desc.ParcsDesc_Id = item.Param_Saisie_Param_Id;
                          await Reload();
                        },
                        child: Container(
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 5), // TED

                            color: (item.Param_Saisie_Param_Label.compareTo(widget.parc_Desc.ParcsDesc_Lib!) == 0) ? gColors.primaryGreen : Colors.transparent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.Param_Saisie_Param_Label,
                                    textAlign: TextAlign.center,
                                    style: gColors.bodyTitle1_B_Gr.copyWith(
                                      color: (item.Param_Saisie_Param_Label.compareTo(widget.parc_Desc.ParcsDesc_Lib!) == 0) ? gColors.white : gColors.primary,
                                    ))
                              ],
                            )));
                  },
                ),
              )
            ],
          ),
        ),
        Valider(context),
      ],
    );
  }
}
