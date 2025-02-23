import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Param_Saisie.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';

// Freq
// Année ....

class Client_Groupe_Parc_Inter_Entete_DialogNo {
  static String DescAff = "";
  static String DescAff2 = "";
  static String DescAff3 = "";
  static Param_Saisie param_Saisie = Param_Saisie.Param_SaisieInit();
  Client_Groupe_Parc_Inter_Entete_DialogNo();
  static Future<void> Dialogs_Entete(BuildContext context, VoidCallback onMaj) async {

    print("     Client_Groupe_Parc_Inter_EnteteDialogNo");

    await showDialog(
      context: context,
      builder: (BuildContext context) => Client_Groupe_Parc_Inter_EnteteDialogNo(onMaj: onMaj, param_Saisie: param_Saisie),
    );
  }
}

//**********************************
//**********************************
//**********************************

class Client_Groupe_Parc_Inter_EnteteDialogNo extends StatefulWidget {
  final VoidCallback onMaj;
  final Param_Saisie param_Saisie;

  const Client_Groupe_Parc_Inter_EnteteDialogNo({Key? key, required this.onMaj, required this.param_Saisie}) : super(key: key);

  @override
  _Client_Groupe_Parc_Inter_EnteteDialogNoState createState() => _Client_Groupe_Parc_Inter_EnteteDialogNoState();
}

class _Client_Groupe_Parc_Inter_EnteteDialogNoState extends State<Client_Groupe_Parc_Inter_EnteteDialogNo> {

  final NoSpecController = TextEditingController();


  Future Reload() async {
    print("     Client_Groupe_Parc_Inter_EnteteDialogNo Reload");

    NoSpecController.text = DbTools.gParc_Ent.Parcs_NoSpec!;
    AffDesc();
    setState(() {});
  }

  @override
  void initLib() async {
    Reload();
  }

  @override
  void initState() {
    print("_EnteteDialog initState param_Saisie ${widget.param_Saisie.Param_Saisie_ID}");
    initLib();
  }

  String DescAff = "N° 11 : Eau + Additif 6l PA portatif 2018";
  String DescAff2 = "RDC - Bâtiment A1 - Bureau";
  String DescAff3 = "";

  void AffDesc() {
    DbTools.glfParcs_Desc.forEach((element2) async {
      print(" DbTools.glfParcs_Desc ${element2.toMap()}");
    });

    DbTools.glfParcs_Desc.forEach((paramSaisie) async {
      switch (paramSaisie.ParcsDesc_Type) {
        case "DESC":
        case "DESC2":
          Srv_DbTools.DESC_Lib = paramSaisie.ParcsDesc_Lib.toString();
          break;
        case "FAB":
        case "FAB2":
          Srv_DbTools.FAB_Lib = paramSaisie.ParcsDesc_Lib.toString();
          break;
        case "TYPE":
        case "TYPE2":
          Srv_DbTools.TYPE_Lib = paramSaisie.ParcsDesc_Lib.toString();
          break;
        case "PRS":
          Srv_DbTools.PRS_Lib = paramSaisie.ParcsDesc_Lib.toString();
          break;
        case "CLF":
          Srv_DbTools.CLF_Lib = paramSaisie.ParcsDesc_Lib.toString();
          break;
        case "MOB":
          Srv_DbTools.MOB_Lib = paramSaisie.ParcsDesc_Lib.toString();
          break;
        case "PDT":
          Srv_DbTools.PDT_Lib = paramSaisie.ParcsDesc_Lib.toString();
          break;
        case "POIDS":
          Srv_DbTools.POIDS_Lib = paramSaisie.ParcsDesc_Lib.toString();
          break;
        case "GAM":
          Srv_DbTools.GAM_Lib = paramSaisie.ParcsDesc_Lib.toString();
          break;
      }
    });

    print("RETOUR ${Srv_DbTools.FAB_Lib} ${Srv_DbTools.PRS_Lib} ${Srv_DbTools.CLF_Lib} ${Srv_DbTools.PDT_Lib} ${Srv_DbTools.POIDS_Lib} ${Srv_DbTools.GAM_Lib} ");

    List<Param_Saisie> listparamSaisieTmp = [];
    listparamSaisieTmp.addAll(Srv_DbTools.ListParam_Saisie);
    listparamSaisieTmp.addAll(Srv_DbTools.ListParam_Saisie_Base);

    DescAff = "N°${DbTools.gParc_Ent.Parcs_order} ${DbTools.gParc_Ent.Parcs_NoSpec!.isEmpty ? '': DbTools.gParc_Ent.Parcs_NoSpec}";


//    PDT POIDS PRS MOB ANN FAB

    listparamSaisieTmp.sort(Srv_DbTools.affL1SortComparison);
    listparamSaisieTmp.forEach((element) async {
      if (element.Param_Saisie_Affichage_L1) {
        if (element.Param_Saisie_ID.compareTo("FREQ") == 0) {
          DescAff = "$DescAff ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_FREQ_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("ANN") == 0) {
          DescAff = "$DescAff ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_ANN_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("AFAB") == 0) {
          DescAff = "$DescAff ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_FAB_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("NIV") == 0) {
          DescAff = "$DescAff ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_NIV_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("ZNE") == 0) {
          DescAff = "$DescAff ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_ZNE_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("EMP") == 0) {
          DescAff = "$DescAff ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_EMP_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("LOT") == 0) {
          DescAff = "$DescAff ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_LOT_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("SERIE") == 0) {
          DescAff = "$DescAff ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_SERIE_Label!, element.Param_Saisie_ID)}";
        } else {
          DbTools.glfParcs_Desc.forEach((element2) async {
            if (element.Param_Saisie_ID == element2.ParcsDesc_Type) {
              DescAff = "$DescAff ${gColors.AbrevTxt_Param_Param(element2.ParcsDesc_Lib!, element.Param_Saisie_ID)}";
              print(" ELSE ${element.Param_Saisie_ID} ${element2.ParcsDesc_Lib} ${element2.toMap()}");
            }
          });
        }
      }
    });

    print(" AffDesc()  $DescAff");

    DescAff2 = "";
    listparamSaisieTmp.sort(Srv_DbTools.affL2SortComparison);
    listparamSaisieTmp.forEach((element) async {
      if (element.Param_Saisie_Affichage_L2) {
        if (element.Param_Saisie_ID.compareTo("FREQ") == 0) {
          DescAff2 = "$DescAff2 ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_FREQ_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("ANN") == 0) {
          DescAff2 = "$DescAff2 ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_ANN_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("AFAB") == 0) {
          DescAff2 = "$DescAff2 ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_FAB_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("NIV") == 0) {
          DescAff2 = "$DescAff2 ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_NIV_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("ZNE") == 0) {
          DescAff2 = "$DescAff2 ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_ZNE_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("EMP") == 0) {
          DescAff2 = "$DescAff2 ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_EMP_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("LOT") == 0) {
          DescAff2 = "$DescAff2 ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_LOT_Label!, element.Param_Saisie_ID)}";
        } else if (element.Param_Saisie_ID.compareTo("SERIE") == 0) {
          DescAff2 = "$DescAff2 ${gColors.AbrevTxt_Param_Param(DbTools.gParc_Ent.Parcs_SERIE_Label!, element.Param_Saisie_ID)}";
        } else {
          DbTools.glfParcs_Desc.forEach((element2) async {
            if (element.Param_Saisie_ID == element2.ParcsDesc_Type) {
              DescAff2 = "$DescAff2 ${gColors.AbrevTxt_Param_Param(element2.ParcsDesc_Lib!, element.Param_Saisie_ID)}";
            }
          });
        }
      }
    });

    DescAff3 = "${Srv_DbTools.REF_Lib} ${Srv_DbTools.gArticle_EbpEnt.Article_descriptionCommercialeEnClair}";
  }

  void onSaisie() async {
    widget.onMaj();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {




    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      backgroundColor: gColors.white,
      surfaceTintColor: Colors.white,
      title: Container(
        color: gColors.white,
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
        child: Column(
          children: [
            Container(
              height: 5,
            ),
            SizedBox(
              width: 500,
              child: Text(
                DescAff,
                style: gColors.bodyTitle1_B_G_20,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: 10,
            ),
            SizedBox(
              width: 500,
              child: Text(
                DescAff2,
                style: gColors.bodyTitle1_N_Gr,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 500,
              child: Text(
                DescAff3,
                style: gColors.bodyTitle1_N_Gr,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      contentPadding: EdgeInsets.zero,
      content: Container(
          color: gColors.greyLight,
          height: 200,
          child: Column(
            children: [
              Container(
                color: gColors.black,
                height: 1,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 50,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        gColors.TxtField(context, 95, 24, "N° Spécifique", NoSpecController, wTextInputType :TextInputType.name,  wErrorText : "",maxChar: 70),
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
      color: gColors.white,
      width: 550,

      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),

      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
//          Text(widget.param_Saisie.Param_Saisie_Controle),
          Container(
            color: gColors.primary,
            width: 8,
          ),
          ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();

              NoSpecController.text = DbTools.gParc_Ent.Parcs_NoSpec!;

              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: gColors.primaryRed,
            ),
            child: Text('Annuler', style: gColors.bodyTitle1_B_W),
          ),
          Container(
            color: gColors.primary,
            width: 8,
          ),
          ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();
              DbTools.gParc_Ent.Parcs_NoSpec = NoSpecController.text;
              await DbTools.updateParc_Ent(DbTools.gParc_Ent);
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
