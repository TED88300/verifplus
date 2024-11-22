import 'dart:async';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie_Param.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Art.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';

class Client_Groupe_Parc_Inter_Piece_Saisie_Dialog {
  Client_Groupe_Parc_Inter_Piece_Saisie_Dialog();

  static Future<void> Dialogs_Saisie(
    BuildContext context,
    VoidCallback onSaisie,
      VoidCallback onDelete,
    Parc_Art parc_Art,
  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => Client_Groupe_Parc_Inter_Piece_SaisieDialog(
        onSaisie: onSaisie,
        onDelete: onDelete,
        parc_Art: parc_Art,
      ),
    );
  }
}

//**********************************
//**********************************
//**********************************

class Client_Groupe_Parc_Inter_Piece_SaisieDialog extends StatefulWidget {
  final VoidCallback onSaisie;
  final VoidCallback onDelete;
  final Parc_Art parc_Art;
  const Client_Groupe_Parc_Inter_Piece_SaisieDialog({Key? key, required this.onSaisie,required this.onDelete, required this.parc_Art}) : super(key: key);
  @override
  Client_Groupe_Parc_Inter_Piece_SaisieDialogState createState() => Client_Groupe_Parc_Inter_Piece_SaisieDialogState();
}

class Client_Groupe_Parc_Inter_Piece_SaisieDialogState extends State<Client_Groupe_Parc_Inter_Piece_SaisieDialog> {
  String wAide = "";
  bool wEditFocus = false;

  Widget wIco = Container();

  String initParcsArt_Fact = "";
  String initParcsArt_Livr = "";

  int initParcsArt_Qte = 0;

  final qteController = TextEditingController();
  Image? wImage;

  Size size = Size(0, 0);

  List<Param_Saisie_Param> ListParam_Saisie_ParamFact = [];
  List<Param_Saisie_Param> ListParam_Saisie_ParamLivr = [];



  Future Reload() async {


    setState(() {});
  }

  @override
  void initLib() async {
    Uint8List blankBytes = Base64Codec().decode("R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7");
    wImage = Image.memory(
      blankBytes,
      height: 1,
    );
    String wImgPath = "${Srv_DbTools.SrvImg}ArticlesImg_Ebp_${widget.parc_Art.ParcsArt_Id}.jpg";
    gObj.pic = await gObj.networkImageToByte(wImgPath);
    if (gObj.pic.length > 0) {
      wImage = await Image.memory(
        gObj.pic,
      );
    }

    print("Reload Parc_Art ${widget.parc_Art.toString()}");
    Srv_DbTools.getParam_Saisie_ParamMem("Fact");
    ListParam_Saisie_ParamFact.clear();
    ListParam_Saisie_ParamFact.addAll(Srv_DbTools.ListParam_Saisie_Param);

    Srv_DbTools.getParam_Saisie_ParamMem("Livr");
    ListParam_Saisie_ParamLivr.clear();
    ListParam_Saisie_ParamLivr.addAll(Srv_DbTools.ListParam_Saisie_Param);

    await Reload();
  }

  @override
  void initState() {
    initParcsArt_Fact = widget.parc_Art.ParcsArt_Fact!;
    initParcsArt_Livr = widget.parc_Art.ParcsArt_Livr!;
    initParcsArt_Qte = widget.parc_Art.ParcsArt_Qte!;
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
    Widget CtrlFact = Container();
    CtrlFact = FlipFlopFact(context);


    Widget CtrlLivr = Container();
    CtrlLivr = FlipFlopLivr(context);

    double IcoWidth = 250;

    double wDialogHeight = 250;
    int nb = (ListParam_Saisie_ParamFact.length / 3).truncate();
    int modnb = ListParam_Saisie_ParamFact.length % 3;
    int nbL = nb;
    if (modnb > 0) nbL++;
    double wDialogBase = 220;
    double wLigneHeight = 52;
    wLigneHeight = 59;
    wDialogHeight = wDialogBase + nbL * wLigneHeight + 85;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.white,
      backgroundColor: gColors.white,
      title: Container(
          color: gColors.white,
          padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
          child: Column(
            children: [
              Text(
                "${widget.parc_Art.ParcsArt_Lib}",
                textAlign: TextAlign.center,
                style: gColors.bodyTitle1_B_G_20,
              ),
              Container(
                height: 8,
              ),
              Container(
                child: wImage!,
                height: IcoWidth,
                width: IcoWidth,
              ),
              Container(
                height: 8,
              ),
              Text(
                "${widget.parc_Art.ParcsArtId} ${widget.parc_Art.ParcsArt_Id}",
                textAlign: TextAlign.center,
                style: gColors.bodyTitle1_N_Gr,
              ),
              Container(
                height: 8,
              ),
            ],
          )),
      contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0,25.0),
      content: Container(
          color: gColors.white,
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
                padding: const EdgeInsets.fromLTRB(2, 20, 0, 0),
                child: CtrlFact,
              ),
              Container(
                color: gColors.greyLight,
                padding: const EdgeInsets.fromLTRB(2, 20, 0, 0),
                child: CtrlLivr,
              ),
              Spacer(),
              Container(
                color: gColors.black,
                height: 1,
              ),
              Valider(context),
            ],
          )),
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
          Text(initParcsArt_Fact),
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
            child: Text('Annuler', style: gColors.bodyTitle1_N_W),
          ),
          Container(
            color: gColors.primary,
            width: 8,
          ),
          new ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();
              widget.parc_Art.ParcsArt_Qte = initParcsArt_Qte;
              widget.parc_Art.ParcsArt_Fact = initParcsArt_Fact;
              widget.parc_Art.ParcsArt_Livr = initParcsArt_Livr;
              print ("Valider updateParc_Art > ParcsArtId ${widget.parc_Art.ParcsArtId}");
              await DbTools.updateParc_Art(widget.parc_Art);
              print ("Valider updateParc_Art <");

              for (int i = 0; i < DbTools.lParcs_Art.length; i++) {
                Parc_Art element = DbTools.lParcs_Art[i];
                print("Valider element Desc ${element.Desc()}");
              }
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

  Widget FlipFlopFact(BuildContext context) {
    List<Widget> Rows = [];

    List<Widget> BtnCardFacts = [];
    int nbBtn = 0;
    wAide = "Aide : ";
    ListParam_Saisie_ParamFact.forEach((element) {
      if (widget.parc_Art.ParcsArt_Lib!.compareTo("---") == 0) {
        if (element.Param_Saisie_Param_Default) {
          print(" J Param_Saisie_Param_Default");

          initParcsArt_Fact = element.Param_Saisie_Param_Label;
        }
      }

      //print("BtnCardFacts.add element ${element.Param_Saisie_ParamId} element.Param_Saisie_Param_Label ${element.Param_Saisie_Param_Label} widget.parc_Art.ParcsArt_Fact! ${initParcsArt_Fact}");
      BtnCardFacts.add(BtnCardFact(element.Param_Saisie_Param_Label, element.Param_Saisie_Param_Id, element.Param_Saisie_Param_Label.compareTo(initParcsArt_Fact) == 0, element.Param_Saisie_ParamId, element.Param_Saisie_Param_Color));

      if (element.Param_Saisie_Param_Label.compareTo(widget.parc_Art.ParcsArt_Lib!) == 0) wAide += element.Param_Saisie_Param_Aide;

      nbBtn++;
      if (nbBtn == 3) {
        nbBtn = 0;
        Row wRow = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: BtnCardFacts,
        );
        Rows.add(wRow);
        BtnCardFacts = [];
      }
    });

    if (nbBtn > 0) {
      nbBtn = 0;
      Row wRow = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: BtnCardFacts,
      );
      Rows.add(wRow);
      BtnCardFacts = [];
    }


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

  Widget BtnCardFact(String wText, String wId, bool wSel, int Param_Saisie_ParamId, String color) {
    Color BgColor = gColors.white;
    Color TxtColor = gColors.black;

    if (wSel) {
      BgColor = gColors.primaryGreen;
      TxtColor = gColors.white;
    }

    return wText.contains("---")
        ? InkWell(
            onTap: () async {
              await HapticFeedback.vibrate();
              initParcsArt_Fact = wText;
              if (wText == "Devis") initParcsArt_Livr = "Reliquat";
              print(" FlipFlopFact ${widget.parc_Art.ParcsArt_Id} ${widget.parc_Art.ParcsArt_Lib} ${initParcsArt_Fact} ${initParcsArt_Livr}");


              await Reload();
            },
            child: Container(
                padding: const EdgeInsets.fromLTRB(50, 5, 0, 0),
                child: Image.asset(
                  "assets/images/Plus_No_Sel.png",
                  width: 50,
                  height: 50,
                )))
        : Container(
            width: 172,
            height: 60,
            child: Card(
              color: BgColor,
              elevation: 0.2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0), side: BorderSide(width: 1, color: Colors.grey)),
              child: InkWell(
                onTap: () async {
                  await HapticFeedback.vibrate();
                  initParcsArt_Fact = wText;
                  if (wText == "Devis") initParcsArt_Livr = "Reliquat";
                  print(" FlipFlopFact ${widget.parc_Art.ParcsArt_Id} ${widget.parc_Art.ParcsArt_Lib} ${initParcsArt_Fact} ${initParcsArt_Livr}");

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

  Widget FlipFlopLivr(BuildContext context) {
    List<Widget> Rows = [];

    List<Widget> BtnCardLivrs = [];
    int nbBtn = 0;
    wAide = "Aide : ";
    ListParam_Saisie_ParamLivr.forEach((element) {
      if (widget.parc_Art.ParcsArt_Lib!.compareTo("---") == 0) {
        if (element.Param_Saisie_Param_Default) {
          print(" K Param_Saisie_Param_Default");
          initParcsArt_Livr = element.Param_Saisie_Param_Label;
        }
      }

      print("BtnCardLivrs.add element ${element.Param_Saisie_ParamId} element.Param_Saisie_Param_Label ${element.Param_Saisie_Param_Label} initParcsArt_Livr ${initParcsArt_Livr} ${element.Param_Saisie_Param_Label.compareTo(initParcsArt_Livr)}");
      BtnCardLivrs.add(BtnCardLivr(element.Param_Saisie_Param_Label, element.Param_Saisie_Param_Id, element.Param_Saisie_Param_Label.compareTo(initParcsArt_Livr) == 0, element.Param_Saisie_ParamId, element.Param_Saisie_Param_Color));

      if (element.Param_Saisie_Param_Label.compareTo(widget.parc_Art.ParcsArt_Lib!) == 0) wAide += element.Param_Saisie_Param_Aide;

      nbBtn++;
      if (nbBtn == 3) {
        nbBtn = 0;
        Row wRow = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: BtnCardLivrs,
        );
        Rows.add(wRow);
        BtnCardLivrs = [];
      }
    });

    if (nbBtn > 0) {
      nbBtn = 0;
      Row wRow = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: BtnCardLivrs,
      );
      Rows.add(wRow);
      BtnCardLivrs = [];
    }

    Rows.add(Container(
      margin: const EdgeInsets.fromLTRB(30, 20, 30, 20),
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
      decoration: BoxDecoration(
        border: Border.all(
          color: gColors.greyDark,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        color: gColors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              width: 60,
              height: 60,
              child: InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: gColors.primaryRed,
                  ),
                  child: Icon(
                    Icons.delete,
                    color: gColors.white,
                    size: 46,
                  ),
                ),
                onTap: () async {

/*
                  List<Parc_Art> wlParcs_Art = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "P");
                  List<Parc_Art> lParcs_Art = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "V");
                  lParcs_Art.addAll(wlParcs_Art);
                  print("deleteParc_Art lParcs_Art ${lParcs_Art.length}");
*/



                  List<Parc_Art> wlParcs_ArtDevis = await DbTools.getParcs_ArtSoDevis(Srv_DbTools.gIntervention.InterventionId!);
                  print("deleteParc_Art wlParcs_ArtDevis Av ${wlParcs_ArtDevis.length}");

                  print("deleteParc_Art widget.parc_Art.ParcsArtId ${widget.parc_Art.ParcsArtId}");


                  await DbTools.deleteParc_Art(widget.parc_Art.ParcsArtId!);

           /*       wlParcs_Art = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "P");
                  lParcs_Art = await DbTools.getParcs_Art(DbTools.gParc_Ent.ParcsId!, "V");
                  lParcs_Art.addAll(wlParcs_Art);
                  print("deleteParc_Art lParcs_Art ${lParcs_Art.length}");
*/
                  wlParcs_ArtDevis = await DbTools.getParcs_ArtSoDevis(Srv_DbTools.gIntervention.InterventionId!);
                  print("deleteParc_Art wlParcs_ArtDevis Ap ${wlParcs_ArtDevis.length}");


                  widget.onDelete();
                  Navigator.of(context).pop();
                },
              )),
          Container(
            width: 40,
          ),
          Container(
              width: 60,
              height: 60,
              child: GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(60),
                    ),
                    color: gColors.black,
                  ),
                  child: Icon(
                    Icons.remove,
                    color: gColors.white,
                    size: 46,
                  ),
                ),
                onTap: () async {
                  initParcsArt_Qte--;
                  setState(() {});
                },
              )),
          Container(
            width: 60,
            height: 60,
            padding: EdgeInsets.fromLTRB(10, 18, 10, 0),
            child: Text(
              "${initParcsArt_Qte}",
              style: gColors.bodyTitle1_B_G,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
              width: 60,
              height: 60,
              child:
              GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(60),
                    ),
                    color: gColors.black,
                  ),
                  child: Icon(
                    Icons.add,
                    color: gColors.white,
                    size: 46,
                  ),
                ),
                onTap: () async {
                  initParcsArt_Qte++;
                  setState(() {});
                },
              )
          ),
          Container(
            width: 100,
          ),
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

  Widget BtnCardLivr(String wText, String wId, bool wSel, int Param_Saisie_ParamId, String color) {
    Color BgColor = gColors.white;
    Color TxtColor = gColors.black;

    if (wSel) {
      BgColor = gColors.primaryGreen;
      TxtColor = gColors.white;
    }

    return wText.contains("---")
        ? InkWell(
        onTap: () async {
          await HapticFeedback.vibrate();
          widget.parc_Art.ParcsArt_Livr = wText;
          print(" FlipFlopLivr ${widget.parc_Art.ParcsArt_Id} ${widget.parc_Art.ParcsArt_Lib} ${widget.parc_Art.ParcsArt_Livr}");
          await Reload();
        },
        child: Container(
            padding: const EdgeInsets.fromLTRB(50, 5, 0, 0),
            child: Image.asset(
              "assets/images/Plus_No_Sel.png",
              width: 50,
              height: 50,
            )))
        : Container(
      width: 172,
      height: 60,
      child: Card(
        color: BgColor,
        elevation: 0.2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0), side: BorderSide(width: 1, color: Colors.grey)),
        child: InkWell(
          onTap: () async {
            await HapticFeedback.vibrate();
            initParcsArt_Livr = wText;
            print(" FlipFlopLivr ${widget.parc_Art.ParcsArt_Id} ${widget.parc_Art.ParcsArt_Lib} ${initParcsArt_Fact} ${initParcsArt_Livr}");

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







}
