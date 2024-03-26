import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Widget/Client/Client_Interventions_Status.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:printing/printing.dart';
import 'package:verifplus/pdf/Aff_Bdc.dart';


class Client_Groupe_Parc_Inter_Signature extends StatefulWidget {
  final VoidCallback onMaj;
  final String x_t;

  const Client_Groupe_Parc_Inter_Signature({Key? key, required this.onMaj, required this.x_t}) : super(key: key);

  @override
  Client_Groupe_Parc_Inter_SignatureState createState() => Client_Groupe_Parc_Inter_SignatureState();
}

class Client_Groupe_Parc_Inter_SignatureState extends State<Client_Groupe_Parc_Inter_Signature> {

  double IcoWidth = 30;

  @override
  Future initLib() async {
    print("initLib");
    setState(() {});
  }

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
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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

              Dupliquer(),
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
        padding: EdgeInsets.fromLTRB(10, 12, 10, 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [

          Text(
            "${Srv_DbTools.gIntervention.Intervention_Type}/${Srv_DbTools.gIntervention.Intervention_Parcs_Type} - ${Srv_DbTools.gIntervention.Intervention_Status} - Cr N° : ${Srv_DbTools.gIntervention.InterventionId} -Anthony FUNDONI",
            style: gColors.bodySaisie_B_G,
            textAlign: TextAlign.center,
          ),



        ]),
      ),
    );
  }


  Widget buildIcoTitre(BuildContext context) {
    double IcoWidth = 30;

    return Container(
      width: 640,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 8),
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
              padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
              child: Text(
                "Signature",
                style: gColors.bodyTitle1_B_Gr,
              ),
            ),
          ),


        ],
      ),
    );
  }





  Widget Dupliquer() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(0, 650, 0, 0),
      width: 640,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[

          new ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();

              await Navigator.push(context, MaterialPageRoute(builder: (context) => Aff_Bdc()));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: gColors.primaryGreen,
                side: const BorderSide(
                  width: 1.0,
                  color: gColors.primaryGreen,
                )),
            child: Text('Imprimer', style: gColors.bodyTitle1_B_W),
          ),


          new ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();

              await Client_Interventions_Status.Dialogs_Status(context);

            },
            style: ElevatedButton.styleFrom(
                backgroundColor: gColors.primaryGreen,
                side: const BorderSide(
                  width: 1.0,
                  color: gColors.primaryGreen,
                )),
            child: Text('Statut', style: gColors.bodyTitle1_B_W),
          ),

/*

          new ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();
              await Client_Interventions_Add.Dialogs_Add(context,false);

              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: gColors.primaryGreen,
                side: const BorderSide(
                  width: 1.0,
                  color: gColors.primaryGreen,
                )),
            child: Text('Dupliquer', style: gColors.bodyTitle1_B_W),
          ),

*/


        ],
      ),
    );
  }

}
