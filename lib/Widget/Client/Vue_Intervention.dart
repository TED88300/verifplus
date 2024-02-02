import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Desc.dart';
import 'package:verifplus/Widget/Client/Vue_Intervention_Saisie_Dialog.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';

import 'package:verifplus/Widget/Intervention/Client_Groupe_Parc_Inter_Entete_Dialog.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

class Intervention_Vue extends StatefulWidget {
  final VoidCallback onMaj;

  const Intervention_Vue({Key? key, required this.onMaj}) : super(key: key);

  @override
  Intervention_VueState createState() => Intervention_VueState();
}

class Intervention_VueState extends State<Intervention_Vue> {


  @override
  void initLib() async {

    for (int j = 0; j < Srv_DbTools.ListParam_Interv_Base.length; j++) {
      Param_Saisie wParam_Saisie = Srv_DbTools.ListParam_Interv_Base[j];
      print("&&&&&&&&&&&&&&&&&&&&&&&& ${wParam_Saisie.Desc()}");
    }

    setState(() {});
  }

  Future Reload(String Param_Saisie_ID) async {
    setState(() {});
  }
/*

  Future UpdateChaine() async {
    print(" UpdateChaine");
    DbTools.glfParcs_Desc = await DbTools.getParcs_Desc(DbTools.gParc_Ent.ParcsId!);
    for (int i = 0; i < Srv_DbTools.ListParam_Saisie.length; i++) {
      Param_Saisie param_Saisie = Srv_DbTools.ListParam_Saisie[i];
      Parc_Desc wParc_Desc = DbTools.getParcs_Desc_Id_Type(DbTools.gParc_Ent.ParcsId!, param_Saisie.Param_Saisie_ID);

      bool MajAuto = false;
      if (wParc_Desc.ParcsDesc_Lib!.compareTo("---") == 0) {
        switch (param_Saisie.Param_Saisie_ID) {
          case "PRS":
            await Srv_DbTools.getParam_Saisie_ParamMem_PRS();
            if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
              MajAuto = true;
              Srv_DbTools.PRS_Lib = Srv_DbTools.ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
              print(" MajAuto ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Lib} >");
            }
            break;
          case "CLF":
            await Srv_DbTools.getParam_Saisie_ParamMem_CLF();
            if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
              MajAuto = true;
              Srv_DbTools.CLF_Lib = Srv_DbTools.ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
              print(" MajAuto ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Lib} >");
            }
            break;
          case "MOB":
            await Srv_DbTools.getParam_Saisie_ParamMem_MOB();
            print(" MajAuto Srv_DbTools.ListParam_Saisie_Param.length  ${Srv_DbTools.ListParam_Saisie_Param.length }");
            if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
              MajAuto = true;
              Srv_DbTools.MOB_Lib = Srv_DbTools.ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
              print(" MajAuto ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Id} >  ${wParc_Desc.ParcsDesc_Lib}");
            }
            break;
            break;
          case "PDT":
            await Srv_DbTools.getParam_Saisie_ParamMem_PDT();
            print("PDT ${Srv_DbTools.ListParam_Saisie_Param.length} >");
            if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
              MajAuto = true;
              Srv_DbTools.PDT_Lib = Srv_DbTools.ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
              print(" MajAuto ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Lib} >");
            }
            break;
          case "POIDS":
            await Srv_DbTools.getParam_Saisie_ParamMem_POIDS();
            if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
              MajAuto = true;
              Srv_DbTools.POIDS_Lib = Srv_DbTools.ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
              print(" MajAuto ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Lib} >");
            }
            break;
          case "GAM":
            await Srv_DbTools.getParam_Saisie_ParamMem_GAM();
            if (Srv_DbTools.ListParam_Saisie_Param.length == 1) {
              MajAuto = true;
              Srv_DbTools.GAM_Lib = Srv_DbTools.ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
              print(" MajAuto ${param_Saisie.Param_Saisie_ID} > ${Srv_DbTools.ListParam_Saisie_Param.length}) ${wParc_Desc.ParcsDesc_Lib} >");
            }
            break;
        }

        if (MajAuto) {
          print("  MajAuto updateParc_Desc");
          wParc_Desc.ParcsDesc_Id = Srv_DbTools.ListParam_Saisie_Param[0].Param_Saisie_ParamId.toString();
          wParc_Desc.ParcsDesc_Lib = Srv_DbTools.ListParam_Saisie_Param[0].Param_Saisie_Param_Label;
          await DbTools.updateParc_Desc(wParc_Desc, "---");
          widget.onMaj();
          await Reload(param_Saisie.Param_Saisie_ID);
        }
      }
    }
  }

*/
  void initState() {
    initLib();
    super.initState();
  }

  void onSaisie() async {
    print ("onSaisie<<<<<>");
    widget.onMaj();

    setState(() {});
  }

  @override
  AppBar appBar() {
    return AppBar(
      title:

        Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
          AutoSizeText(
             "INFOS PRATIQUES",
            maxLines: 1,
            style: gColors.bodyTitle1_B_G24,
          ),
        ]),



      leading: InkWell(
        onTap: () async {
          await HapticFeedback.vibrate();
          Navigator.of(context).pop();
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 10, 0, 10),
          child: Image.asset("assets/images/IcoW.png"),
        ),
      ),
      actions: <Widget>[
        IconButton(
          iconSize: 40,
          icon: gColors.wBoxDecoration(context),
          onPressed: () async {
            gColors.AffUser(context);
          },
        ),


      ],
      backgroundColor: gColors.white,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),

      body: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gObj.InterventionTitleWidgetCalc(context, "${Srv_DbTools.gClient.Client_Nom.toUpperCase()}", wTitre2: "${Srv_DbTools.gGroupe.Groupe_Nom}", wTitre3:"${Srv_DbTools.gSite.Site_Nom}", wTitre4:"${Srv_DbTools.gZone.Zone_Nom}"),
              Container(
                height: 1,
                color: gColors.greyDark,
              ),


              buildDesc(context),

            ],
          )),
    );
  }



  @override
  Widget buildDesc(BuildContext context) {
    double LargeurCol = 190;
    double LargeurCol2 = gColors.MediaQuerysizewidth - 190 - 60;
    double H2 = 4;

    List<Widget> RowSaisies = [];
    Srv_DbTools.ListParam_Interv_Base.sort(Srv_DbTools.affSortComparison);
    for (int i = 0; i < Srv_DbTools.ListParam_Interv_Base.length; i++) {
      Param_Saisie element = Srv_DbTools.ListParam_Interv_Base[i];
      if (element.Param_Saisie_Affichage.compareTo("COL") == 0)
        RowSaisies.add(RowSaisie(element, LargeurCol, LargeurCol2, H2));
    }

    return
      //Expanded(child:
      Container(
          width: gColors.MediaQuerysizewidth,
//          height: 400,
          child: Container(
              padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
              color: gColors.greyDark,
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                color: gColors.white,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: RowSaisies.length,
                  itemBuilder: (context, index) {
                    return RowSaisies[index];
                  },
                  separatorBuilder: (BuildContext context, int index) => const Divider(
                    color: gColors.greyDark,
                  ),
                ),
              ))
        //),
      );
  }

  Widget RowSaisie(Param_Saisie param_Saisie, double LargeurCol, double LargeurCol2, double H2) {

    double IcoWidth = 30;

    String wStr = "";
    print("param_Saisie.Param_Saisie_ID ${param_Saisie.Param_Saisie_ID}");

//    if (wParc_Desc.ParcsDesc_Lib!.compareTo("---") == 0)
        {
      switch (param_Saisie.Param_Saisie_ID) {
        case "Contrat":
          wStr = Srv_DbTools.gIntervention.Intervention_Contrat!;
          break;
        case "TypeContrat":
          wStr = Srv_DbTools.gIntervention.Intervention_TypeContrat!;
          break;
        case "Duree":
          wStr = Srv_DbTools.gIntervention.Intervention_Duree!;
          break;
        case "Organes":
          wStr = Srv_DbTools.gIntervention.Intervention_Organes!;
          break;
        case "RT":
          wStr = Srv_DbTools.gIntervention.Intervention_RT!;
          break;
        case "APSAD":
          wStr = Srv_DbTools.gIntervention.Intervention_APSAD!;
          break;
      }
    }

    if (param_Saisie.Param_Saisie_Icon.compareTo("") == 0) LargeurCol += 40;
    return InkWell(
      onTap: () async {
        await HapticFeedback.vibrate();
            param_Saisie.Param_Saisie_Value = wStr;
            await Vue_Intervention_Saisie_Dialog.Dialogs_Saisie(context, onSaisie, param_Saisie);
          // await UpdateChaine();
        setState(() {});
      },
      child: Row(
        children: [
          Container(
            width: 10,
          ),
          param_Saisie.Param_Saisie_Icon.compareTo("") == 0
              ? Container(
            width: 0,
          )
              : Image.asset(
            "assets/images/${param_Saisie.Param_Saisie_Icon}.png",
            height: IcoWidth,
            width: IcoWidth,
          ),
          param_Saisie.Param_Saisie_Icon.compareTo("") == 0
              ? Container()
              : Container(
            width: 10,
          ),
          Container(
            width: LargeurCol,
            height: 20,
            padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
            child: Text(
              "${param_Saisie.Param_Saisie_Label}",
              style: gColors.bodySaisie_B_B,
            ),
          ),
          BtnCard("${wStr}", LargeurCol2),
        ],
      ),
    );
  }

  Widget BtnCard(String? wText, double LargeurCol2) {
    return new Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      width: LargeurCol2,
      height: 27,
      child: Card(
        color: gColors.transparent,
        elevation: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              wText!,
              textAlign: TextAlign.center,
              style: gColors.bodyTitle1_B_Gr.copyWith(
                color: wText.contains("---") ? Colors.black : gColors.primaryGreen,
              ),
            )
          ],
        ),
      ),
    );
  }



}
