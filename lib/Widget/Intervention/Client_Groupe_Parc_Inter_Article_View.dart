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

class Client_Groupe_Parc_Inter_Article_View_Dialog {
  Client_Groupe_Parc_Inter_Article_View_Dialog();

  static Future<void> Dialogs_Saisie(
    BuildContext context,
    Parc_Art parc_Art,
  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => Client_Groupe_Parc_Inter_Article_ViewDialog(
        parc_Art: parc_Art,
      ),
    );
  }
}

//**********************************
//**********************************
//**********************************

class Client_Groupe_Parc_Inter_Article_ViewDialog extends StatefulWidget {
  final Parc_Art parc_Art;
  const Client_Groupe_Parc_Inter_Article_ViewDialog({Key? key, required this.parc_Art}) : super(key: key);
  @override
  Client_Groupe_Parc_Inter_Article_ViewDialogState createState() => Client_Groupe_Parc_Inter_Article_ViewDialogState();
}

class Client_Groupe_Parc_Inter_Article_ViewDialogState extends State<Client_Groupe_Parc_Inter_Article_ViewDialog> {
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
    print("Parc_Art ${widget.parc_Art.toString()}");

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
                "${widget.parc_Art.ParcsArt_Id}",
                textAlign: TextAlign.center,
                style: gColors.bodyTitle1_N_Gr,
              ),
              Container(
                height: 8,
              ),
            ],
          )),
      contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 25.0),
      content: Container(
          color: gColors.white,
          height: wDialogHeight,
          width: 600,
          child: Column(
            children: [
              Container(
                color: gColors.black,
                height: 1,
              ),
              Expanded(
                child: Container(
                    color: gColors.greyLight,
                    width: 600,
                    padding: const EdgeInsets.fromLTRB(22, 20, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Commandés ${widget.parc_Art.ParcsArt_Qte}",
                          textAlign: TextAlign.center,
                          style: gColors.bodyTitle1_B_G_20,
                        ),
                        SizedBox(height: 12,),
                        Text(
                          "Livrés ${widget.parc_Art.ParcsArt_Livr == 'Livré' ? widget.parc_Art.ParcsArt_Qte : 0}",
                          textAlign: TextAlign.center,
                          style: gColors.bodyTitle1_B_G_20,
                        ),
                        SizedBox(height: 12,),
                        Text(
                          "Reliquats ${widget.parc_Art.ParcsArt_Livr == 'Reliquat' ? widget.parc_Art.ParcsArt_Qte : 0}",
                          textAlign: TextAlign.center,
                          style: gColors.bodyTitle1_B_Sr,
                        ),
                      ],
                    )),
              ),
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
