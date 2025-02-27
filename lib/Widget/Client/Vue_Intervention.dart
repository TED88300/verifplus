import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/Client/Vue_Intervention_Saisie_Dialog.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
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
      Param_Saisie wparamSaisie = Srv_DbTools.ListParam_Interv_Base[j];
    }

    setState(() {});
  }

  Future Reload(String paramSaisieId) async {
    setState(() {});
  }

  @override
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
          child: DbTools.gBoolErrorSync
              ? Image.asset(
            "assets/images/IcoWErr.png",
          )
              : Image.asset("assets/images/IcoW.png"),
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
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gObj.InterventionTitleWidgetCalc(context, Srv_DbTools.gClient.Client_Nom.toUpperCase(), wTitre2: Srv_DbTools.gGroupe.Groupe_Nom, wTitre3:Srv_DbTools.gSite.Site_Nom, wTitre4:Srv_DbTools.gZone.Zone_Nom),
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
      if (element.Param_Saisie_Affichage.compareTo("COL") == 0) {
        RowSaisies.add(RowSaisie(element, LargeurCol, LargeurCol2, H2));
      }
    }

    return
      //Expanded(child:
      SizedBox(
          width: gColors.MediaQuerysizewidth,
//          height: 400,
          child: Container(
              padding: const EdgeInsets.fromLTRB(0, 1, 0, 0),
              color: gColors.greyDark,
              child: Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
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

  Widget RowSaisie(Param_Saisie paramSaisie, double LargeurCol, double LargeurCol2, double H2) {

    double IcoWidth = 30;

    String wStr = "";
    print("param_Saisie.Param_Saisie_ID ${paramSaisie.Param_Saisie_ID}");

//    if (wParc_Desc.ParcsDesc_Lib!.compareTo("---") == 0)
        {
      switch (paramSaisie.Param_Saisie_ID) {
        case "Contrat":
          wStr = Srv_DbTools.gIntervention.Intervention_Contrat;
          break;
        case "TypeContrat":
          wStr = Srv_DbTools.gIntervention.Intervention_TypeContrat;
          break;
        case "Duree":
          wStr = Srv_DbTools.gIntervention.Intervention_Duree;
          break;
        case "Organes":
          wStr = Srv_DbTools.gIntervention.Intervention_Organes;
          break;
        case "RT":
          wStr = Srv_DbTools.gIntervention.Intervention_RT;
          break;
        case "APSAD":
          wStr = Srv_DbTools.gIntervention.Intervention_APSAD;
          break;
      }
    }

    if (paramSaisie.Param_Saisie_Icon.compareTo("") == 0) LargeurCol += 40;
    return InkWell(
      onTap: () async {
        await HapticFeedback.vibrate();
            paramSaisie.Param_Saisie_Value = wStr;
            await Vue_Intervention_Saisie_Dialog.Dialogs_Saisie(context, onSaisie, paramSaisie);
          // await UpdateChaine();
        setState(() {});
      },
      child: Row(
        children: [
          Container(
            width: 10,
          ),
          paramSaisie.Param_Saisie_Icon.compareTo("") == 0
              ? Container(
            width: 0,
          )
              : Image.asset(
            "assets/images/${paramSaisie.Param_Saisie_Icon}.png",
            height: IcoWidth,
            width: IcoWidth,
          ),
          paramSaisie.Param_Saisie_Icon.compareTo("") == 0
              ? Container()
              : Container(
            width: 10,
          ),
          Container(
            width: LargeurCol,
            height: 20,
            padding: const EdgeInsets.fromLTRB(0, 2, 8, 0),
            child: Text(
              paramSaisie.Param_Saisie_Label,
              style: gColors.bodySaisie_B_B,
            ),
          ),
          BtnCard(wStr, LargeurCol2),
        ],
      ),
    );
  }

  Widget BtnCard(String? wText, double LargeurCol2) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      width: LargeurCol2,
      height: 31,
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
