import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie_Param.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Art.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

class Client_Groupe_Parc_Inter_Note extends StatefulWidget {
  final VoidCallback onMaj;
  final String x_t;

  const Client_Groupe_Parc_Inter_Note({Key? key, required this.onMaj, required this.x_t}) : super(key: key);

  @override
  Client_Groupe_Parc_Inter_NoteState createState() => Client_Groupe_Parc_Inter_NoteState();
}

class Client_Groupe_Parc_Inter_NoteState extends State<Client_Groupe_Parc_Inter_Note> {

  double IcoWidth = 30;

  @override
  Future initLib() async {
    print("initLib");
    setState(() {});
  }

  @override
  void initState() {
    initLib();
    super.initState();
  }

  void onSaisie() async {
    widget.onMaj();
    await initLib();
  }

  @override
  Widget build(BuildContext context) {
    print("build BL");
    Srv_DbTools.getParam_Saisie_ParamMem("Fact");
    print("initLib ${Srv_DbTools.ListParam_Saisie_Param.length}");

    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InterventionTitleWidget2(),
              Container(
                height: 1,
                color: gColors.greyDark,
              ),
              buildIcoTitre(context),

              buildDesc(context),
            ],
          )),
    );
  }

  static Widget InterventionTitleWidget2() {
    return Material(
      elevation: 4,
      child: Container(
        width: 640,
        height: 57,
        padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [

          const Spacer(),
          Text(
            "${Srv_DbTools.gIntervention.Intervention_Type}/${Srv_DbTools.gIntervention.Intervention_Parcs_Type} - ${Srv_DbTools.gIntervention.Intervention_Status} - Cr N° : ${Srv_DbTools.gIntervention.InterventionId} -Anthony FUNDONI",
            style: gColors.bodySaisie_B_G,
            textAlign: TextAlign.center,
          ),
          const Spacer(),

        ]),
      ),
    );
  }

  Widget buildIcoTitre(BuildContext context) {
    double IcoWidth = 30;

    return Container(
      width: 640,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      color: gColors.greyLight,
      child: Row(
        children: [
          Image.asset(
            "assets/images/Verif_titre.png",
            height: IcoWidth,
            width: IcoWidth,
          ),
          Container(
            width: 10,
          ),
          Expanded(
            child: Container(
              height: 20,
              padding: const EdgeInsets.fromLTRB(0, 2, 8, 0),
              child: Text(
                "Notes",
                style: gColors.bodyTitle1_B_Gr,
              ),
            ),
          ),


        ],
      ),
    );
  }

  @override
  Widget buildDesc(BuildContext context) {


    return
//      Expanded(child:
      SizedBox(
        width: 640,
        height: 770,

        child: Container()

      );
  }


  Future<Image> GetImage(Parc_Art art) async {
    if (art.wImgeTrv) {
      return art.wImage!;
    }


    await Srv_DbTools.getArticlesImg_Ebp( art.ParcsArt_Id!);
    gObj.pic = base64Decode(Srv_DbTools.gArticlesImg_Ebp.ArticlesImg_Image);

    if (gObj.pic.isNotEmpty) {
      art.wImgeTrv = true;
      art.wImage =  Image.memory(
        gObj.pic,
        fit: BoxFit.scaleDown,
        width: 30,
        height: 30,
      );
      return art.wImage!;
    }

    return Image.asset(
      "assets/images/Audit_det.png",
      height: 30,
      width: 30,
    );
  }
  Widget buildImage(BuildContext context, Parc_Art art) {
    return FutureBuilder(
      future: GetImage(art),
      builder: (BuildContext context, AsyncSnapshot<Image> image) {
        if (image.hasData) {
          return image.data!;
        } else {
          return Container(width: 30);
        }
      },
    );
  }

  Widget RowSaisie(Parc_Art parcArt, double H2) {

    Color wColor = Colors.green;

    for (int i = 0; i < Srv_DbTools.ListParam_Saisie_Param.length; i++) {
      Param_Saisie_Param eP = Srv_DbTools.ListParam_Saisie_Param[i];
      if (eP.Param_Saisie_Param_Label.compareTo(parcArt.ParcsArt_Fact!) == 0) {
        wColor = gColors.getColor(eP.Param_Saisie_Param_Color);
        break;
      }
    }
    String parcsartLivr = parcArt.ParcsArt_Livr!.substring(0,1);
    if (parcsartLivr.compareTo("R") != 0) parcsartLivr = "";

    return Container(
        color: Colors.white,
        height: 45,
        child: InkWell(
          onTap: () async {
            await HapticFeedback.vibrate();
            print("onTap ");
            print("onTap ${parcArt.toString()} ");


            setState(() {});
          },
          child: Row(
            children: [
              Container(
                width: 10,
              ),
              buildImage(context, parcArt),
              Container(
                width: 10,
              ),
              Container(
                width: 100,
                height: 20,
                padding: const EdgeInsets.fromLTRB(0, 2, 8, 0),
                child: Text(
                  "${parcArt.ParcsArt_Id}",
                  style: parcArt.ParcsArt_Livr!.substring(0,1).compareTo("R")==0 ? gColors.bodySaisie_B_O : gColors.bodySaisie_B_G,
                ),
              ),
              Expanded(
                child: Container(
                  height: 20,
                  padding: const EdgeInsets.fromLTRB(0, 2, 8, 0),
                  child: Text(
                    "[${parcArt.ParcsArt_Livr!.substring(0,1)}] ${parcArt.ParcsArt_Lib}",
                    style: parcArt.ParcsArt_Livr!.substring(0,1).compareTo("R")==0 ? gColors.bodySaisie_B_O : gColors.bodySaisie_B_G,
                  ),
                ),
              ),
              Container(
                width: 110,
                height: 20,
                padding: const EdgeInsets.fromLTRB(0, 2, 8, 0),
                child: Text(
                  "${parcArt.ParcsArt_Fact}",
                  style: gColors.bodyTitle1_B_Gr.copyWith(
                    color: wColor,
                  ),
                ),
              ),


              Container(
                width: 40,
                height: 20,
                padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                child: Text(
                  "${parcArt.Qte}",
                  style: gColors.bodyTitle1_N_Gr,
                  textAlign: TextAlign.center,
                ),
              ),



              Container(
                width: 10,
              ),
            ],
          ),
        ));
  }
}
