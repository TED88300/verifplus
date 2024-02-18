import 'dart:async';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';

class Vue_Intervention_Saisie_Dialog {
  Vue_Intervention_Saisie_Dialog();

  static Future<void> Dialogs_Saisie(
    BuildContext context,
    VoidCallback onSaisie,
    Param_Saisie param_Saisie,

  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => Vue_Intervention_SaisieDialog(
        onSaisie: onSaisie,
        param_Saisie: param_Saisie,

      ),
    );
  }
}

//**********************************
//**********************************
//**********************************

class Vue_Intervention_SaisieDialog extends StatefulWidget {
  final VoidCallback onSaisie;
  final Param_Saisie param_Saisie;
  const Vue_Intervention_SaisieDialog({Key? key, required this.onSaisie, required this.param_Saisie}) : super(key: key);

  @override
  Vue_Intervention_SaisieDialogState createState() => Vue_Intervention_SaisieDialogState();
}

class Vue_Intervention_SaisieDialogState extends State<Vue_Intervention_SaisieDialog> {
  String wAide = "";
  bool wEditFocus = false;

  Widget wIco = Container();
  TextEditingController tec_Search = TextEditingController();
  TextEditingController tec_Saisie = TextEditingController();

   String initValue = "";

  double IcoWidth = 350;

  Future Reload() async {
    print("widget.param_Saisie.Param_Saisie_ID ${widget.param_Saisie.Param_Saisie_ID}");
/*

    switch (widget.param_Saisie.Param_Saisie_ID) {
      case "PRS":
        Srv_DbTools.getParam_Saisie_ParamMem_PRS();
        if (Srv_DbTools.ListParam_Saisie_Param.length == 0) Srv_DbTools.getParam_Saisie_ParamMem(widget.param_Saisie.Param_Saisie_ID);
        break;
      case "CLF":
        Srv_DbTools.getParam_Saisie_ParamMem_CLF();
        if (Srv_DbTools.ListParam_Saisie_Param.length == 0) Srv_DbTools.getParam_Saisie_ParamMem(widget.param_Saisie.Param_Saisie_ID);
        break;
      case "MOB":
        Srv_DbTools.getParam_Saisie_ParamMem_MOB();
        print("Saisie MOB ${Srv_DbTools.ListParam_Saisie_Param.length}");
        if (Srv_DbTools.ListParam_Saisie_Param.length == 0) Srv_DbTools.getParam_Saisie_ParamMem(widget.param_Saisie.Param_Saisie_ID);
        break;
      case "PDT":
        Srv_DbTools.getParam_Saisie_ParamMem_PDT();
        if (Srv_DbTools.ListParam_Saisie_Param.length == 0) Srv_DbTools.getParam_Saisie_ParamMem(widget.param_Saisie.Param_Saisie_ID);
        break;
      case "POIDS":
        Srv_DbTools.getParam_Saisie_ParamMem_POIDS();
        if (Srv_DbTools.ListParam_Saisie_Param.length == 0) Srv_DbTools.getParam_Saisie_ParamMem(widget.param_Saisie.Param_Saisie_ID);
        break;
      case "GAM":
        Srv_DbTools.getParam_Saisie_ParamMem_GAM();
        if (Srv_DbTools.ListParam_Saisie_Param.length == 0) Srv_DbTools.getParam_Saisie_ParamMem(widget.param_Saisie.Param_Saisie_ID);
        break;

      default:
        Srv_DbTools.getParam_Saisie_ParamMem(widget.param_Saisie.Param_Saisie_ID);
        break;
    }
*/

    print("${widget.param_Saisie.Param_Saisie_ID} ListParam_Saisie_Param lenght  ${Srv_DbTools.ListParam_Saisie_Param.length}");

    setState(() {});
  }

  @override
  void initLib() async {
    await Reload();
  }

  
  @override
  void initState() {
    initValue = widget.param_Saisie.Param_Saisie_Value;

    

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

    double wDialogHeight = 250;
    int nb = (Srv_DbTools.ListParam_Saisie_Param.length / 3).truncate();
    int modnb = Srv_DbTools.ListParam_Saisie_Param.length % 3;
    int nbL =  nb;
    if (modnb > 0) nbL++ ;
    double wDialogBase = 130;
    double wLigneHeight = 52;

    switch (widget.param_Saisie.Param_Saisie_Controle) {

      case "FlipFlop":
        Ctrl = FlipFlop(context);
        wLigneHeight = 59;
        wDialogHeight = wDialogBase + nbL * wLigneHeight + 44;
        break;

      case "FlipFlopIco":
        print("FlipFlopIco");
        Ctrl = FlipFlopIco(context);
        wLigneHeight = 59;
        wDialogHeight = wDialogBase + nbL * wLigneHeight + 135;
        break;

      case "FlipFlopEdt":
        print("FlipFlopEdt ${widget.param_Saisie.Param_Saisie_Label}");
        Ctrl = FlipFlopEdt(context);
        wLigneHeight = 59;
        wDialogHeight = wDialogBase + nbL * wLigneHeight + 31;
        break;
      case "Liste":
        print("Liste Liste Liste Liste");
        Ctrl = Liste(context);
        wDialogHeight = 640;
        break;

      case "ListeEdt":
        print("ListeEdt ListeEdt ListeEdt ListeEdt");
        Ctrl = ListeEdt(context);
        wDialogHeight = 495;
        break;

      case "Annee":
        Ctrl = Annee(context);
        wDialogHeight = 375;
        break;

      case "EdtTxt":
        txtController.text = widget.param_Saisie.Param_Saisie_Value;
        if (txtController.text.compareTo("---") == 0) txtController.text = "";
        Ctrl = EdtTxt(context);
        wDialogHeight = 230;
        break;

      case "EdtTxtNR":
        txtController.text = widget.param_Saisie.Param_Saisie_Value;
        if (txtController.text.compareTo("---") == 0) txtController.text = "";
        Ctrl = EdtTxtNR(context);
        wDialogHeight = 180;
        break;

      default:
        Ctrl = Txt(context);
        wDialogHeight = wDialogBase;
        break;
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.white,
      backgroundColor: gColors.white,
      title: Container(
          color: gColors.white,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
     contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 25.0),

      content: SingleChildScrollView(
        child: Container(
            color: gColors.white,
            height: wDialogHeight ,
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
                Container(
                  color: gColors.black,
                  height: 1,
                ),
                Valider(context),
              ],
            )),
      ),
    );
  }

  //**********************************
  //**********************************
  //**********************************

  void onSaisie() async {
    initLib();
    setState(() {});
  }

  Widget Valider(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
      width: 480,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          widget.param_Saisie.Param_Saisie_ID.compareTo("DESC") != 0
              ? Container()
              : Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await HapticFeedback.vibrate();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gColors.greyDark,
                    ),
                    child: Text('Articles', style: gColors.bodyTitle1_N_W),
                  ),
                ),
          Spacer(),
          Text(widget.param_Saisie.Param_Saisie_Controle),
          Container(
            color: gColors.primary,
            width: 8,
          ),
          new ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();
              widget.param_Saisie.Param_Saisie_Value = initValue;

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
      if (widget.param_Saisie.Param_Saisie_Value.compareTo("---") == 0) {
        if (element.Param_Saisie_Param_Default) {
          widget.param_Saisie.Param_Saisie_Value = element.Param_Saisie_Param_Label;
        }
      }

      //  print("BtnCards.add element ${element.Param_Saisie_ParamId}");
      BtnCards.add(BtnCard(element.Param_Saisie_Param_Label, element.Param_Saisie_Param_Id, element.Param_Saisie_Param_Label.compareTo(widget.param_Saisie.Param_Saisie_Value) == 0, element.Param_Saisie_ParamId));

      if (element.Param_Saisie_Param_Label.compareTo(widget.param_Saisie.Param_Saisie_Value) == 0) wAide += element.Param_Saisie_Param_Aide;

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
      width: 450,
      height: 95,
      padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            wAide,
            style: gColors.bodyTitle1_Aide,
            maxLines: 3,
          )
        ],
      ),
    ));

    return Container(
        child:
        Column(children: [
      Container(
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

  Widget BtnCard(String wText, String wId, bool wSel, int Param_Saisie_ParamId) {
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
            widget.param_Saisie.Param_Saisie_Value = wText;

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
//**********************************

  Widget FlipFlopIco(BuildContext context) {
    List<Widget> Rows = [];

    List<Widget> BtnCards = [];
    int nbBtn = 0;
    wAide = "Aide : ";
    wIco = Container();

    Srv_DbTools.ListParam_Saisie_Param.forEach((element) {
      if (widget.param_Saisie.Param_Saisie_Value.compareTo("---") == 0) {
        if (element.Param_Saisie_Param_Default) {
          widget.param_Saisie.Param_Saisie_Value = element.Param_Saisie_Param_Label;
        }
      }

      BtnCards.add(BtnCardIco(
        element.Param_Saisie_Param_Label,
        element.Param_Saisie_Param_Id,
        element.Param_Saisie_Param_Label.compareTo(widget.param_Saisie.Param_Saisie_Value) == 0,
        element.Param_Saisie_Param_Ico,
      ));

      if (element.Param_Saisie_Param_Label.compareTo(widget.param_Saisie.Param_Saisie_Value) == 0) {
        wAide += element.Param_Saisie_Param_Aide;
        wIco = Container(
          width: 450,
          padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              element.Param_Saisie_Param_Ico,
            ],
          ),
        );
      }

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
      width: 450,
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

    Rows.add(wIco);

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
//      Valider(context),
    ]));
  }

  Widget BtnCardIco(String wText, String wId, bool wSel, Widget wIco) {
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
            widget.param_Saisie.Param_Saisie_Value = wText;

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
              ),
            ],
          ),
        ),
      ),
    );
  }

//**********************************
//**********************************
//**********************************

  Widget FlipFlopEdt(BuildContext context) {
    List<Widget> Rows = [];

    List<Widget> BtnCards = [];
    int nbBtn = 0;
    wAide = "Aide : ";
    Srv_DbTools.ListParam_Saisie_Param.forEach((element) {
      print("element.Param_Saisie_Param_Label A ${element.Param_Saisie_Param_Label} ${widget.param_Saisie.Param_Saisie_Value}");

      if (widget.param_Saisie.Param_Saisie_Value.compareTo("---") == 0) {
        if (element.Param_Saisie_Param_Default) {
          widget.param_Saisie.Param_Saisie_Value = element.Param_Saisie_Param_Label;
        }
      }

      BtnCards.add(BtnCard(element.Param_Saisie_Param_Label, element.Param_Saisie_Param_Id, element.Param_Saisie_Param_Label.compareTo(widget.param_Saisie.Param_Saisie_Value) == 0, element.Param_Saisie_ParamId));

      if (element.Param_Saisie_Param_Label.compareTo(widget.param_Saisie.Param_Saisie_Value) == 0) wAide += element.Param_Saisie_Param_Aide;

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
    tec_Saisie.text = widget.param_Saisie.Param_Saisie_Value;
    if (tec_Saisie.text.compareTo("---") == 0) tec_Saisie.text = "";

    tec_Saisie.selection = TextSelection.fromPosition(TextPosition(offset: tec_Saisie.text.length));

    Rows.add(Container(
      width: 450,
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
        child: Column(
      children: [
        Container(
//          height: wEditFocus ? 220 : null,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: Rows,
            ),
          ),
        ),
        Container(
          height: 50,
          width: 450,
          child: Padding(
              padding: EdgeInsets.fromLTRB(5.0, 10.0, 0.0, 10.0),
              child: Focus(
                child: TextFormField(
                  onChanged: (value) async {
                    await HapticFeedback.vibrate();
                    widget.param_Saisie.Param_Saisie_Value = "${value}";
                  },
                  controller: tec_Saisie,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    hintStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                onFocusChange: (hasFocus) {
                  wEditFocus = hasFocus;
                  print("wEditFocus $wEditFocus");
                  setState(() {});
                },
              )),
        ),
//        Valider(context),
      ],
    ));
  }

  //**********************************
  //**********************************
  //**********************************

  Widget Annee(BuildContext context) {
    List<String> ListMonth = DateFormat.EEEE('fr').dateSymbols.MONTHS;
    print(ListMonth);

    int _selectedMonth = 0;

    int currentYear = DateTime.now().year;
    int startingYear = 1990;
    List ListYear = List.generate((currentYear - startingYear) + 1, (index) => startingYear + index);

    int _selectedYear = 0;

    int wM = 0;
    int wY = ListYear.length - 1;
    int wYi = 0;

    if (widget.param_Saisie.Param_Saisie_Value.isNotEmpty) {
      if (!widget.param_Saisie.Param_Saisie_Value.contains("---")) {
        List<String> Decompo = widget.param_Saisie.Param_Saisie_Value.split("-");
        if (Decompo.length == 1) {
          wY = int.parse(widget.param_Saisie.Param_Saisie_Value);
        } else {
          wM = int.parse(Decompo[0]) - 1;
          wY = int.parse(Decompo[1]);
        }
      } else {
        wY = DateTime.now().year;
        widget.param_Saisie.Param_Saisie_Value = "1-${wY}";
      }
    }

    wYi = wY - 1990;

    print("wY ${wM} ${wY}");

    _selectedMonth = wM + 1;
    _selectedYear = wY;

    return Container(
        height: 300,
        width: 450,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 210,
                  width: 160,
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(initialItem: wM),
                    magnification: 1.22,
                    squeeze: 1.2,
                    useMagnifier: true,
                    itemExtent: 32,
                    onSelectedItemChanged: (int selectedItem) async {
                      await HapticFeedback.vibrate();
                      _selectedMonth = selectedItem + 1;
                      print("_selectedMonth ${_selectedMonth}");
                      widget.param_Saisie.Param_Saisie_Value = "${_selectedMonth}-${_selectedYear}";
                      setState(() {});
                    },
                    children: List<Widget>.generate(ListMonth.length, (int index) {
                      return Center(
                        child: Text(
                          ListMonth[index],
                          style: gColors.bodyTitle1_B_Pr,
                        ),
                      );
                    }),
                  ),
                ),
                Container(
                  height: 210,
                  width: 160,
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(initialItem: wYi),
                    magnification: 1.22,
                    squeeze: 1.2,
                    useMagnifier: true,
                    itemExtent: 32,
                    onSelectedItemChanged: (int selectedItem) async {
                      await HapticFeedback.vibrate();

                      _selectedYear = selectedItem + 1990;
                      print("_selectedYear ${_selectedYear}");
                      widget.param_Saisie.Param_Saisie_Value = "${_selectedMonth}-${_selectedYear}";
                      setState(() {});
                    },
                    children: List<Widget>.generate(ListYear.length, (int index) {
                      return Center(
                        child: Text(
                          ListYear[index].toString(),
                          style: gColors.bodyTitle1_B_Pr,
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
//            Valider(context),
          ],
        ));
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
      if (Srv_DbTools.ListParam_Saisie_Paramsearchresult[i].Param_Saisie_Param_Label.compareTo(widget.param_Saisie.Param_Saisie_Value) == 0) {
        index = double.parse("${i}");
        break;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom(index));

    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).viewInsets.bottom != 0 ? 324 : 524,
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
                          widget.param_Saisie.Param_Saisie_Value = item.Param_Saisie_Param_Label;

                          await Reload();
                        },
                        child:

                        Container(
                            decoration: BoxDecoration(
                              color: (item.Param_Saisie_Param_Label.compareTo(widget.param_Saisie.Param_Saisie_Value) == 0) ? gColors.primaryGreen : Colors.transparent,
                              border: Border.all(
                                color: (item.Param_Saisie_Param_Label.compareTo(widget.param_Saisie.Param_Saisie_Value) == 0) ? gColors.primaryGreen : Colors.transparent,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
//              margin: EdgeInsets.fromLTRB(0, 2, 0, 2),
                            padding: EdgeInsets.fromLTRB(10, 15, 10, 5), // TED
                            height: 45,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.Param_Saisie_Param_Label,
                                    textAlign: TextAlign.center,
                                    style: gColors.bodyTitle1_B_Gr.copyWith(
                                      color: (item.Param_Saisie_Param_Label.compareTo(widget.param_Saisie.Param_Saisie_Value) == 0) ? gColors.white : gColors.primary,
                                    ))
                              ],
                            ))

                    );
                  },
                ),
              )
            ],
          ),
        ),
        Container(
          height: 40,
          width: 450,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 4,
              right: 0,
              left: 0,
            ),
            child: Focus(
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
              onFocusChange: (hasFocus) {
                wEditFocus = hasFocus;
                print("wEditFocus $wEditFocus");
                setState(() {});
              },
            ),
          ),
        ),
//        Valider(context),
      ],
    );
  }

  //**********************************
  //**********************************
  //**********************************

  Widget ListeEdt(BuildContext context) {
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
      if (Srv_DbTools.ListParam_Saisie_Paramsearchresult[i].Param_Saisie_Param_Label.compareTo(widget.param_Saisie.Param_Saisie_Value) == 0) {
        index = double.parse("${i}");
        break;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom(index));

    tec_Saisie.text = widget.param_Saisie.Param_Saisie_Value;
    tec_Saisie.selection = TextSelection.fromPosition(TextPosition(offset: tec_Saisie.text.length));

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
                    widget.param_Saisie.Param_Saisie_Value = item.Param_Saisie_Param_Label;
                    tec_Saisie.text = item.Param_Saisie_Param_Label;
                    tec_Saisie.selection = TextSelection.fromPosition(TextPosition(offset: tec_Saisie.text.length));
                  },
                  child: Container(
//              margin: EdgeInsets.fromLTRB(0, 2, 0, 2),
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5), // TED

                      color: (item.Param_Saisie_Param_Label.compareTo(widget.param_Saisie.Param_Saisie_Value) == 0) ? gColors.primaryGreen : Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.Param_Saisie_Param_Label,
                              textAlign: TextAlign.center,
                              style: gColors.bodyTitle1_B_Gr.copyWith(
                                color: (item.Param_Saisie_Param_Label.compareTo(widget.param_Saisie.Param_Saisie_Value) == 0) ? gColors.white : gColors.primary,
                              ))
                        ],
                      )));
            },
          ),
        ),
        Container(
          height: 50,
          width: 450,
          child: Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 4,
                right: 0,
                left: 0,
              ),
              child: Focus(
                child: TextFormField(
                  onChanged: (value) async {
                    await HapticFeedback.vibrate();
                    widget.param_Saisie.Param_Saisie_Value = "${value}";
                  },
                  controller: tec_Saisie,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    hintStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                onFocusChange: (hasFocus) {
                  wEditFocus = hasFocus;
                  print("wEditFocus $wEditFocus");
                  setState(() {});
                },
              )),
        ),
//        Valider(context),
      ],
    );
  }

  //**********************************
  //**********************************
  //**********************************

  final txtController = TextEditingController();

  Widget EdtTxt(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
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
          child: TextField(
            keyboardType: TextInputType.visiblePassword,
            controller: txtController,
            autofocus: false,
            decoration: InputDecoration(
              hintText: '${widget.param_Saisie.Param_Saisie_Label}',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            ),
            onChanged: (value) async {
              await HapticFeedback.vibrate();
              widget.param_Saisie.Param_Saisie_Value = txtController.text;
            },
          ),
        ),
//        Valider(context),
      ],
    );
  }

  Widget EdtTxtNR(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
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
          child: TextField(
            keyboardType: TextInputType.visiblePassword,
            controller: txtController,
            autofocus: false,
            decoration: InputDecoration(
              hintText: '${widget.param_Saisie.Param_Saisie_Label}',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            ),
            onChanged: (value) async {
              await HapticFeedback.vibrate();
              widget.param_Saisie.Param_Saisie_Value = txtController.text.toUpperCase();
            },
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
          height: 50,
          width: 450,
          child: ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();
              txtController.text = "Non renseigné sur l'équipement".toUpperCase();
              widget.param_Saisie.Param_Saisie_Value = txtController.text;
              await HapticFeedback.vibrate();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: gColors.white,
                side: const BorderSide(
                  width: 1.0,
                  color: gColors.black,
                )),
            child: Text("Non renseigné sur l'équipement".toUpperCase(), style: gColors.bodyTitle1_N_Gr),
          ),
        ),
//        Valider(context),
      ],
    );
  }

  //**********************************
  //**********************************
  //**********************************

  
  Widget Txt(BuildContext context) {
    return Text("Txt");
  }
}
